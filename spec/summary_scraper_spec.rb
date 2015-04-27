require 'spec_helper'

describe SummaryScraper do
  it 'can pull records from first page of paginated site' do
    paginator = OpenStruct.new(add_on: "&pg=", pages: [1])
    json = '{
      "base_url":"http://www.careers.stackoverflow.com",
      "summary":{
        "url":"/jobs/tag/ruby?sort=p",
        "loop":".listResults .-item",
        "fields":[
          {
            "field":"position",
            "method":"find",
            "path":"h3.-title a"
          },
          {
            "field":"url",
            "method":"find",
            "path":"h3.-title a",
            "attr":"href"
          },
          {
            "field":"posting_date",
            "method":"first",
            "path":"p._muted"
          }
        ]
      }
    }'
    site = JSON.parse(json)

    scraper = SummaryScraper.new(site, paginator.add_on, paginator.pages)
    results = scraper.call
    expect(results.length).to eq 25
    expect(results.first["position"]).to be_a String
    expect(results.first["position"]).to_not be_empty
    expect(results.first["url"]).to be_a String
    expect(results.first["url"]).to match(/^http/)
    expect(results.first["posting_date"]).to be_a String
    expect(results.first["posting_date"]).to_not be_empty
  end

  it 'can pull records from multiple pages of paginated site' do
    paginator = OpenStruct.new(add_on: "&pg=", pages: [1, 2])
    json = '{
      "base_url":"http://www.careers.stackoverflow.com",
      "summary":{
        "url":"/jobs/tag/ruby?sort=p",
        "loop":".listResults .-item",
        "fields":[
          {
            "field":"position",
            "method":"find",
            "path":"h3.-title a"
          },
          {
            "field":"url",
            "method":"find",
            "path":"h3.-title a",
            "attr":"href"
          },
          {
            "field":"posting_date",
            "method":"first",
            "path":"p._muted"
          }
        ]
      }
    }'
    site = JSON.parse(json)

    scraper = SummaryScraper.new(site, paginator.add_on, paginator.pages)
    results = scraper.call
    expect(results.length).to be > 26
  end

  it 'can pull records from non-paginated site' do
    paginator = OpenStruct.new(add_on: "", pages: [""])
    json = '{
      "base_url":"https://weworkremotely.com",
      "summary":{
        "url":"/categories/2/jobs",
        "has_sub_pages":"false",
        "loop":"section.jobs ul li",
        "fields":[
          {
            "field":"position",
            "method":"find",
            "path":"span.title"
          },
          {
            "field":"company",
            "method":"find",
            "path":"span.company"
          },
          {
            "field":"url",
            "method":"find",
            "path":"a",
            "attr":"href"
          },
          {
            "field":"posting_date",
            "method":"find",
            "path":"span.date"
          }
        ]
      }
    }'
    site = JSON.parse(json)

    scraper = SummaryScraper.new(site, paginator.add_on, paginator.pages)
    results = scraper.call
    expect(results.length).to be > 1
    expect(results.first["position"]).to be_a String
    expect(results.first["position"]).to_not be_empty
    expect(results.first["company"]).to be_a String
    expect(results.first["company"]).to_not be_empty
    expect(results.first["url"]).to be_a String
    expect(results.first["url"]).to match(/^http/)
    expect(results.first["posting_date"]).to be_a String
    expect(results.first["posting_date"]).to_not be_empty
  end
end
