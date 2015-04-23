require 'capybara'
require 'capybara/poltergeist'
require 'rubyscraper/version'

include Capybara::DSL

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end

Capybara.default_driver = :poltergeist

class RubyScraper
  def self.call(endpoint)
    visit "http://careers.stackoverflow.com/jobs?searchTerm=ruby&sort=p"
    start = Time.now
    jobs = []

    (1..2).to_a.each do |page|
      visit "http://careers.stackoverflow.com/jobs?searchTerm=ruby&sort=p&pg=#{page}"

      all(".listResults .-item").each do |listing|
        position = listing.find("h3.-title a").text
        url = listing.find("h3.-title a")["href"]
        posting_date = listing.first("p._muted").text

        jobs << {
          position: position,
          url: url,
          posting_date: posting_date
        }
      end
      puts "page #{page}"
    end

    jobs.each_with_index do |job, i|
      puts "job pull #{i}"
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

    puts jobs.first
    puts jobs.last
    puts pages
    elapsed = Time.now - start
    puts elapsed
    return jobs.length, 0
  end

  def self.pull_rss(term)
    base_address = 'http://careers.stackoverflow.com/jobs/feed'
    rss = RSS::Parser.parse("#{base_address}?searchTerm=#{term}", false)
    saved = 0
    rss.items.each do |item|
      item_saved = send_to_server(item)
      saved += 1 if item_saved
    end
    return rss.items.count, saved
  end

  def self.send_to_server(rss_item)
    date = DateTime.strptime(rss_item.pubDate.to_s, '%a, %e %b %Y %H:%M:%S %z')
    # parse item contents
    # item = item_contents.to_json
    # RestClient.post(rails_server) {item}
    # Send post request to Rails server containing all relevant data
    # Rails server does a find_or_create_by on contents
    # If item is found return a status code of not-created
    # If item is created return 201
    # If succesful save return true, else false
    return true
  end
end
