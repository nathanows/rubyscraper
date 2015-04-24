require 'capybara'
require 'capybara/poltergeist'
require 'rest-client'
require 'rubyscraper/version'

class RubyScraper
  include Capybara::DSL
  attr_reader :scrape_config, :pages, :jobs, :posted_jobs, :endpoint

  def initialize(endpoint, pages=1)
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, js_errors: false)
    end
    Capybara.default_driver = :poltergeist

    @jobs = []
    @posted_jobs = 0
    @pages = pages
    @endpoint = endpoint
    @scrape_file = File.expand_path('../assets/scrapes.json', __FILE__)
    @scrape_config = JSON.parse(File.read(@scrape_file))
  end

  def scrape
    scrape_config.each do |site|
      get_summaries(site)
      get_bodies(site)
    end
    send_to_server
    return jobs.length, posted_jobs
  end

  def get_summaries(site)
    site["summary"]["params"][0]["SEARCHTERM"].each do |term|
      summary_url = "#{site["base_url"]}#{site["summary"]["url"].sub("SEARCHTERM", term)}"
      (1..pages).to_a.each do |page|
        visit "#{summary_url}#{site["summary"]["pagination_fmt"]}#{page}"
        all(site["summary"]["loop"]).each do |listing|
          job = pull_summary_data(site, listing)
          job = modify_data(site, job)
          jobs << job
        end
        puts "Pulled #{term}[page: #{page}] job summaries."
      end
    end
  end

  def pull_summary_data(site, listing)
    job = Hash.new
    site["summary"]["fields"].each do |field|
      if field["attr"]
        job[field["field"]] = 
          listing.send(field["method"].to_sym,field["path"])[field["attr"]]
      else
        job[field["field"]] = 
          listing.send(field["method"].to_sym,field["path"]).text
      end
    end; job
  end

  def modify_data(site, job)
    job["url"] = "#{site["base_url"]}#{job["url"]}"
    job
  end

  def get_bodies(site)
    jobs.each_with_index do |job, i|
      sleep 1
      pull_job_data(site, job)
      puts "Job #{i+1} pulled."
    end
  end

  def pull_job_data(site, job)
    visit job["url"]

    site["sub_page"]["fields"].each do |field|
      if field["method"] == "all"
        if has_css?(field["path"])
          values = all(field["path"]).map do |elem|
            elem.send(field["loop_collect"])
          end
          job[field["field"]] = values.join(field["join"])
        end
      else
        if has_css?(field["path"])
          job[field["field"]] = 
            send(field["method"].to_sym,field["path"]).text
        end
      end
    end
  end

  def send_to_server
    jobs.each_with_index do |job, i|
      new_job = {
        position: job[:position],
        location: job[:location],
        description: job[:description],
        source: job[:url]
      }

      RestClient.post(endpoint, job: new_job){ |response, request, result, &block|
        case response.code
        when 201
          posted_jobs += 1
          puts "Job saved."
        when 302
          puts "Job already exists."
        else
          puts "Bad request."
        end
      }
    end
  end
end
