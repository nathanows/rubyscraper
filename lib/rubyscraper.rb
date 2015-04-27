require 'rubyscraper/version'
require 'rubyscraper/processor'
require 'rubyscraper/api_dispatcher'

class RubyScraper
  def self.call(opts)
    processor = Processor.new(opts)
    results   = processor.call
    num_saved = ApiDispatcher.post(results, opts["endpoint"])
 
    return results.count, num_saved
  end
end
