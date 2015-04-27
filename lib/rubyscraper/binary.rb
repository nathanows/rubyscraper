require 'rubyscraper'

class RubyScraper
  class Binary
    def self.call(argv, outstream, errstream)
      outstream.puts "StackOverflow Job Scraper"
      outstream.puts "---------------------------------------------"
      outstream.puts "Started scraping..."
      opts = {"endpoint" => argv[0]}
      jobs_scraped, jobs_saved = RubyScraper.call(opts)
      outstream.puts "Scraped #{jobs_scraped} jobs, succesfully posted #{jobs_saved} jobs."
      outstream.puts "---------------------------------------------"
      outstream.puts "Completed!"
    end
  end
end

# Refactor (How to call gem)
#
# SCRAPE FILE LOAD
# run from directory containing rubyscrapes.json file (search all contained files?)
# add -f /path/to/file.json to override
#
# ENDPOINT
# add some option to save to file? some other output format?
# required flag -e OR --endpoint http://localhost:3000/api/v1/jobs
#
# PAGINATION LIMIT
# defaults to pages set in JSON file
# add -r OR --records all to pull all records on site
#
# SINGLE SITE
# defaults to running all non-skipped sites
# add -s OR --site sitename
