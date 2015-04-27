require 'rubyscraper/version'
require 'rubyscraper/processor'

class RubyScraper
  def self.call(opts)
    processor = Processor.new(opts)
    results   = processor.call
    #output    = ApiDispatcher.post(results, opts)
 
    return results.count, 0
  end

  #def send_to_server
    #@scraped_jobs += jobs.length
    #jobs.each do |job|
      #new_job = {
        #position: job["position"],
        #location: job["location"],
        #description: job["description"],
        #source: job["url"]
      #}

      #RestClient.post(endpoint, job: new_job){ |response, request, result, &block|
        #case response.code
        #when 201
          #@posted_jobs += 1
          #puts "Job saved."
        #when 302
          #puts "Job already exists."
        #else
          #puts "Bad request."
        #end
      #}
    #end
    #@jobs = []
  #end
end
