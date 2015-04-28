require 'rubyscraper/version'
require 'rubyscraper/processor'
require 'rubyscraper/api_dispatcher'

class RubyScraper
  def self.call(opts)
    record_limit = opts.record_limit
    config_file  = File.expand_path(opts.config_file, Dir.pwd)
    single_site  = opts.single_site
    scrape_delay = opts.scrape_delay
    endpoint     = opts.endpoint

    processor = Processor.new(config_file, single_site, record_limit, scrape_delay)
    results   = processor.call
    num_saved = ApiDispatcher.post(results, endpoint)
 
    return results.count, num_saved
  end
end
