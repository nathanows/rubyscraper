# RubyScraper

RubyScraper is a gem built to scrape 1-2 layer listing sites. The original intent was, and the included example scrapes.json config file is for scraping job posting sites. The gem allows you to pull summary listings from a main index page, then follow in the nested url's to sub-pages for those listings to scrape additional data. The example is for job sites, but this could easily be used for blogs, recipe sites, news sites, products, etc.. 

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

## Usage

First configure a scrape config file. See the example file (`scrapes.json`) for format and options. All available options are specified in the contained examples. As a rough overview though:

####Scrape Config File Options

```
[
  {
    "name":"stackoverflow",                             # => REQUIRED Site Name (No spaces)
    "base_url":"http://www.careers.stackoverflow.com",  # => REQUIRED Base Site URL (Thru domain, no trailing '/')
    "summary":{                                         # => REQUIRED Summary block (main scrape page)
      "url":"/jobs/tag/ruby?sort=p",                    # => REQUIRED Any url additions to access main scrape page
                                                                      If only pulling base site use "/"
      "has_sub_pages":"true",                           # => REQUIRED Are there sub-pages to scrape?
      "paginated":"true",                               # => REQUIRED Are all listings on the main page? Or is the 
                                                                      site paginated?
      "pagination":{                                    # => OPTIONAL Required for paginated sites
        "format":"&pg=",                                              - URL pagination param
        "start":"1",                                                  - Starting point (some sites go by records)
        "scale":"1",                                                  - Whats the incrementer for pages/records
        "records_per_page":"25"                                       - Number of records on each page
      },
      "loop":".listResults .-item",                     # => REQUIRED The main container of each scrape element
      "fields":[                                        # => REQUIRED Which fields should be scraped from this page
        {
          "field":"position",                                - Output file name
          "method":"find",                                   - Capybara search method (find: only 1 matching elem)
          "path":"h3.-title a"                               - Path to containing element
        },
        {
          "field":"url",                                     - To scrape sub-pages, this is required with name 'url'
          "method":"find",
          "path":"h3.-title a",
          "attr":"href"                                      - To access an html attribute, add an attr row
        },
        {
          "field":"posting_date",
          "method":"first",                                  - To access the first occurence of a given element
          "path":"p._muted"
        }
      ]
    },
    "sub_page":{                                        # => OPTIONAL if scraping from sub-pages, list fields
      "fields":[
        {
          "field":"company",
          "method":"find",
          "path":"a.employer"
        },
        {
          "field":"location",
          "method":"find",
          "path":"span.location"
        },
        {
          "field":"description",
          "method":"all",                                    - Use 'all' method to collect data from multiple elems
          "path":"div.description p",                        - Path to the collection of elems to be aggregated
          "loop_collect":"text",                             - What is being selected from that collection
          "join":"\n"                                        - How to join output string
        },
        {
          "field":"tags",
          "method":"all",
          "path":"div.tags a.post-tag",
          "loop_collect":"text",
          "join":", "
        }
      ]
    }
  }
]
```


#### RubyScraper runtime options

Type `rubyscraper -h` for full option list.

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
