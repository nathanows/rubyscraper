require 'capybara'
require 'capybara/poltergeist'

class SummaryScraper
  attr_reader :site, :pagination_addon, :pagination_pages
  include Capybara::DSL

  def initialize(site, pagination_addon, pagination_pages)
    @site             = site
    @pagination_addon = pagination_addon
    @pagination_pages = pagination_pages

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, js_errors: false)
    end
    Capybara.default_driver = :poltergeist
  end

  def call
    pagination_pages.inject [] do |results, page|
      results += get_summaries(page)
    end
  end

  private

  def get_summaries(page_no)
    visit page_url(page_no)

    all(site["summary"]["loop"]).inject [] do |results, listing|
      record = pull_summary_data(site, listing)
      record = listing_cleanup(site, record)
      results << record
    end
  end

  def page_url(page)
    site["base_url"] + site["summary"]["url"] + pagination_addon + page.to_s
  end
  
  def pull_summary_data(site, record)
    output = Hash.new
    site["summary"]["fields"].each do |field|
      if field["attr"]
        if record.has_css?(field["path"])
          output[field["field"]] = 
            record.send(field["method"].to_sym, field["path"])[field["attr"]]
        end
      else
        if record.has_css?(field["path"])
          output[field["field"]] = 
            record.send(field["method"].to_sym, field["path"]).text
        end
      end
    end; output
  end

  def listing_cleanup(site, listing)
    # Add base url if not present
    unless listing["url"].match(/^http/)
      listing["url"] = "#{site["base_url"]}#{listing["url"]}"
    end
    listing
  end
end
