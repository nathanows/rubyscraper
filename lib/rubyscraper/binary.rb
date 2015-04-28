require 'rubyscraper'
require 'rubyscraper/option_parser'

class RubyScraper
  class Binary
    def self.call(argv, outstream, errstream)
      outstream.puts "RubyScraper"
      outstream.puts "---------------------------------------------"
      outstream.puts "Started scraping..."
      outstream.puts "---------------------------------------------"

      options = OptparseExample.parse(argv)
      records_scraped, records_saved = RubyScraper.call(options)

      outstream.puts "---------------------------------------------"
      outstream.puts "Scraped #{records_scraped} records, succesfully posted #{records_saved} records."
      outstream.puts "---------------------------------------------"
      outstream.puts "Completed!"
    end
  end
end
