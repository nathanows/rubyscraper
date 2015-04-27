class Paginator
  attr_reader :site, :record_limit, :pagination

  def initialize(site, record_limit)
    @site         = site
    @pagination   = site["summary"]["pagination"]
    @record_limit = record_limit
  end

  def define_pagination_params
    if paginated_site?
      # define params
      @steps  = url_page_addons
      @add_on = pagination["format"]
    else
      @steps  = [""]
      @add_on = ""
    end
  end

  def add_on
    @add_on
  end

  def steps
    @steps
  end

  private

  def url_page_addons
    output = []
    num_pages.times do |i|
      output << pagination_start + pagination_scale * i
    end
    output
  end

  def num_pages
    output = record_limit / records_per_page
    output += 1 if record_limit % records_per_page != 0
    output
  end

  def records_per_page
    pagination["records_per_page"].to_i
  end

  def pagination_start
    pagination["start"].to_i
  end

  def pagination_scale
    pagination["scale"].to_i
  end

  def paginated_site?
    site["summary"]["paginated"] == "true"
  end
end
