require 'capybara'
require 'capybara/poltergeist'

class SubPageScraper
  attr_reader :site, :listings, :delay
  include Capybara::DSL

  def initialize(site, listings, delay)
    @site     = site
    @listings = listings
    @delay    = delay

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, js_errors: false)
    end
    Capybara.default_driver = :poltergeist
  end

  def call
    puts "Pulling #{@listings.count} listings from #{@site["name"]}:"
    listings = @listings.inject [] do |results, listing|
      sleep delay
      listing = pull_sub_page_data(site, listing)
      listing = listing_cleanup(listing)
      results << listing
    end; puts "\n"; listings
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
    end; print "."; listing
  end

  def listing_cleanup(listing)
    # Remove 'Headquarters: ' from weworkremotely jobs
    listing["location"].slice!("Headquarter: ") if !listing["location"].to_s.empty?
    listing
  end
end
