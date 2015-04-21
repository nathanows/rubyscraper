require 'rss'
require 'rubyscraper/version'

class RubyScraper
  def self.call(endpoint)
    terms = get_search_terms("search-terms.txt")
    jobs_scraped = 0
    jobs_saved = 0
    terms.each do |term|
      scraped, saved = pull_rss(term)
      jobs_scraped += scraped
      jobs_saved += saved
    end
    return jobs_scraped, jobs_saved
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

  # SAMPLE ITEM
  # <item>
  #   <guid isPermaLink="true">
  #     http://careers.stackoverflow.com/jobs/84858/awesome-ruby-on-rails-engineer-veritrans-indonesia
  #   </guid>
  #   <link>
  #     http://careers.stackoverflow.com/jobs/84858/awesome-ruby-on-rails-engineer-veritrans-indonesia
  #   </link>
  #   <category>
  #     ruby
  #   </category>
  #   <category>
  #     ruby-on-rails
  #   </category>
  #   <title>
  #     Awesome Ruby on Rails Engineer at Veritrans Indonesia (Kota Jakarta Pusat, Indonesia)
  #   </title>
  #   <description>
  #     &lt;p&gt;You could work for a startup with yet another recycled social product idea, no business model, 
  #     naive executive teams and ten minutes of funding.&lt;/p&gt;&lt;br /&gt;&lt;p&gt;Or you could become part 
  #     of the band at Veritrans Indonesia, a company with a&amp;nbsp;&lt;em&gt;real&amp;nbsp;&lt;/em&gt;solid 
  #     vision led by an industry rock star and play a key role in developing the most advanced internet payment 
  #     gateway platform in the country.&lt;/p&gt;&lt;br /&gt;&lt;p&gt;You&amp;nbsp;&lt;em&gt;will&lt;/em&gt;&amp;nbsp;
  #     have plenty of&amp;nbsp;&lt;em&gt;opportunities&lt;/em&gt;&amp;nbsp;to sharpen&amp;nbsp;your&amp;nbsp;skills in
  #     adding new features and going beyond.&lt;/p&gt;&lt;br /&gt;&lt;p&gt;You&amp;nbsp;&lt;em&gt;will&lt;/em&gt;
  #     &amp;nbsp;work closely with t
  #   </description>
  #   <pubDate>
  #     Mon, 06 Apr 2015 12:37:22 Z
  #   </pubDate>
  #   <a10:updated>
  #     2015-04-06T12:37:22Z
  #   </a10:updated>
  # </item>

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

  def self.get_search_terms(filename)
    file = File.expand_path("../assets/#{filename}", __FILE__)
    f = File.open(file, "r")
    terms = []
    f.each_line do |line|
      terms << line.chomp
    end
    f.close
    terms
  end
end
