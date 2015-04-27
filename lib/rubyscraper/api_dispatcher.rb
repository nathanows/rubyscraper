require 'rest-client'

class ApiDispatcher
  def self.post(results, endpoint)
    results.inject 0 do |posted, listing|
      new_listing = {
        position: listing["position"],
        location: listing["location"],
        description: listing["description"],
        source: listing["url"]
      }

      RestClient.post(endpoint, job: new_listing){ |response, request, result, &block|
        case response.code
        when 201
          puts "Job saved."
          posted += 1
        when 302
          puts "Job already exists."
          posted
        else
          puts "Bad request."
          posted
        end
      }
    end
  end
end
