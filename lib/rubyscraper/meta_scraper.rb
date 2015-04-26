require 'initializer'

class MetaScraper
  def initialize(opts)
    @opts = opts
    Initializer.capybara_setup
  end
end
