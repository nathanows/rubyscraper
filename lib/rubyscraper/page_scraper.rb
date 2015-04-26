require 'initializer'

class PageScraper
  def initialize(opts)
    @opts = opts
    Initializer.capybara_setup
  end
end
