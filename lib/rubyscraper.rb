require 'capybara'
require 'capybara/poltergeist'
require 'rest-client'
require 'rubyscraper/version'

class RubyScraper
  include Capybara::DSL

  def initialize(endpoint)
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, js_errors: false)
    end
    Capybara.default_driver = :poltergeist
    @jobs = []
    @posted_jobs = 0
    @endpoint = endpoint
    @search_terms_file = File.expand_path('../assets/search-terms.txt', __FILE__)
    @search_terms = []
    File.foreach(@search_terms_file) { |x| @search_terms << x.strip }
  end

  def scrape
    get_summaries
    get_bodies
    send_to_server
    return @jobs.length, @posted_jobs
  end

  def get_summaries
    @search_terms.each do |term|
      visit "http://careers.stackoverflow.com/jobs?searchTerm=#{term}&sort=p"
      (1..5).to_a.each do |page|
        visit "http://careers.stackoverflow.com/jobs?searchTerm=ruby&sort=p&pg=#{page}"
        all(".listResults .-item").each do |listing|
          position = listing.find("h3.-title a").text
          url = listing.find("h3.-title a")["href"]
          posting_date = listing.first("p._muted").text

          @jobs << { position: position, url: url, posting_date: posting_date }
        end
      end
      puts "Pulled #{term} job summaries."
    end
  end

  def get_bodies
    @jobs.each_with_index do |job, i|
      puts "Job #{i+1} pulled."
      sleep 1
      visit "http://careers.stackoverflow.com#{job[:url]}"
      if has_css?("a.employer")
        job[:company] = find("a.employer").text
      end
      if has_css?("span.location")
        job[:location] = find("span.location").text
      end
      #job[:description] = first("div.description p")
      description = all("div.description p").map do |p|
        p.text
      end
      job[:description] = description.join("\n")
      tags = all("div.tags a.post-tag").map do |tag|
        tag.text
      end
      job[:tags] = tags
    end
  end

  def send_to_server
    @jobs.each_with_index do |job, i|
      new_job = {
        position: job[:position],
        location: job[:location],
        description: job[:description],
        source: "http://careers.stackoverflow.com#{job[:url]}"
      }
      RestClient.post(@endpoint, job: new_job){ |response, request, result, &block|
        case response.code
        when 201
          @posted_jobs += 1
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
