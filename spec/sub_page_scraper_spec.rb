require 'spec_helper'

describe SubPageScraper do
  it 'can pull record subfields from a list of existing jobs' do
    jobs = [{"url" => "http://careers.stackoverflow.com/jobs/84266/software-developer-qhr-technologies"},
            {"url" => "http://careers.stackoverflow.com/jobs/81592/service-engineer-bloomberg-lp"}]
    json = '{
      "sub_page":{
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
            "method":"all",
            "path":"div.description p",
            "loop_collect":"text",
            "join":"\n"
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
    }'
    site = JSON.parse(json)

    scraper = SubPageScraper.new(site, jobs)
    results = scraper.call
    expect(results.length).to eq 2
    expect(results.first["company"]).to be_a String
    expect(results.first["company"]).to_not be_empty
    expect(results.first["location"]).to be_a String
    expect(results.first["location"]).to_not be_empty
    expect(results.first["description"]).to be_a String
    expect(results.first["description"]).to_not be_empty
    expect(results.first["tags"]).to be_a String
    expect(results.first["tags"]).to_not be_empty
  end
end
