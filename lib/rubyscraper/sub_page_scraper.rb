require 'capybara'
require 'capybara/poltergeist'

class SubPageScraper
  attr_reader :site, :listings
  include Capybara::DSL

  def initialize(site, listings)
    @site     = site
    @listings = listings

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, js_errors: false)
    end
    Capybara.default_driver = :poltergeist
  end

  def call
    @listings.inject [] do |results, listing|
      sleep 1
      results << pull_sub_page_data(site, listing)
    end
  end

  def pull_sub_page_data(site, listing)
    visit listing["url"]
    site["sub_page"]["fields"].each do |field|
      if field["method"] == "all"
        if has_css?(field["path"])
          values = all(field["path"]).map do |elem|
            elem.send(field["loop_collect"])
          end
          listing[field["field"]] = values.join(field["join"])
        end
      else
        if has_css?(field["path"])
          listing[field["field"]] = 
            send(field["method"].to_sym,field["path"]).text
        end
      end
    end; puts listing; listing
  end
end
