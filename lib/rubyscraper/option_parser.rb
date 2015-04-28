require 'rubyscraper/version'
require 'optparse'
require 'ostruct'

class OptparseExample
  def self.parse(args)
    options              = OpenStruct.new
    options.config_file  = ""
    options.endpoint     = ""
    options.record_limit = 50
    options.single_site  = ""
    options.scrape_delay = 1

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: RubyScraper [options]"

      opts.separator ""
      opts.separator "Specific options:"
      opts.separator ""

      opts.separator "REQUIRED:"
      # Mandatory argument
      opts.on("-f", "--file FILENAME.JSON",
              "Specify the file_name of your RubyScraper config file") do |file|
        options.config_file = file
      end

      opts.separator ""
      opts.separator "REQUIRED (if using as service to send results as post requests):"
      # Mandatory argument if sending results to POST endpoint
      opts.on("-e", "--endpoint URL",
              "Enter the api endpoint URL here",
              "  (If using scraper as a service to send post requests to server)",) do |url|
        options.endpoint = url
      end

      opts.separator ""
      opts.separator "OPTIONAL:"

      opts.on("-rl", "--record-limit N", Integer,
              "Pull N records per site",
              "  (approximate because if there are 25 records per",
              "  page, and 51 is provided, it will go to 3 pages)") do |limit|
        options.record_limit = limit
      end

      opts.on("-d", "--delay N", Float, "Delay N seconds before executing") do |n|
        options.delay = n
      end

      opts.on("-s", "--site SITENAME", "Scrape a single SITENAME from the config file") do |site|
        options.single_site = site
      end

      opts.separator ""
      opts.separator "Common options:"

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end

      opts.on_tail("--version", "Show version") do
        puts RubyScraper::VERSION
        exit
      end
    end

    opt_parser.parse!(args)
    options
  end
end
