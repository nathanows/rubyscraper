# RubyScraper

RubyScraper is a gem built 

## Installation
### Dependency
RubyScraper relies on PhantomJS as its headless web browser. Install this before installing the gem with:

```
brew install phantomjs
```

### CLI
Install RubyScraper by running:

```
gem install rubyscraper
```

### Gemfile
*Work in Progress*
Add this line to your application's Gemfile:

```ruby
gem 'rubyscraper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubyscraper

## Usage

```
Usage: RubyScraper [options]

Specific options:

REQUIRED:
    -f, --file FILENAME.JSON         Specify the file_name of your RubyScraper config file

REQUIRED (if using as service to send results as post requests):
    -e, --endpoint URL               Enter the api endpoint URL here
                                       (If using scraper as a service to send post requests to server)

OPTIONAL:
    -r, --record-limit N             Pull N records per site
                                       (approximate because if there are 25 records per
                                       page, and 51 is provided, it will go to 3 pages)
    -d, --delay N                    Delay N seconds before executing
    -s, --site SITENAME              Scrape a single SITENAME from the config file

Common options:
    -h, --help                       Show this message
        --version                    Show version
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rubyscraper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write your tests and don't break anything :) *run tests with `rspec`*
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
