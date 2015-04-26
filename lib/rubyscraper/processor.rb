class Processor
  attr_reader :sites, :top_scraper, :sub_scraper

  def initialize(opts)
    @pages         = opts[:pages] || :default
    @config        = JSON.parse(File.read(opts[:file]))
    @sites         = @config["sites"]
    @meta_scraper  = MetaScraper.new()
    @page_scraper  = PageScraper.new()
    #@global_config = @config["configuration"]
  end

  def call
    opts[:single_site] ? scrape_single_site : scrape_all_sites
  end

  private

  def scrape_single_site
    single_site = sites.select { |site| site["name"] == single_site }

    results = top_scraper.scrape(single_site)
    results = sub_scraper.scrape() if has_sub_pages?(single_site)
  end

  def scrape_all_sites
    sites.inject [] do |all_results, site|
      results = top_scraper.scrape(site)
      results = sub_scraper.scrape() if has_sub_pages?(single_site)

      all_results += results
    end
  end

  def has_sub_pages?(site)
    site["has_sub_pages"] == "true"
  end
end
