require 'rubyscraper'

class RubyScraper
  class Binary
    def self.call(argv, outstream, errstream)
      outstream.puts "StackOverflow Job Scraper"
      outstream.puts "---------------------------------------------"
      outstream.puts "Started scraping..."
      endpoint = argv.first
      outstream.puts "Sending post requests to #{endpoint}"
      jobs_scraped, jobs_saved = RubyScraper.new(endpoint).scrape
      outstream.puts "Scraped #{jobs_scraped} jobs, succesfully posted #{jobs_saved} jobs."
      outstream.puts "---------------------------------------------"
      outstream.puts "Completed!"
    end
  end
end
