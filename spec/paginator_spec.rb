require 'spec_helper'

describe Paginator do
  it 'returns defaults if not paginated' do
    json = '{"summary":{
      "paginated":"false"
    }}'
    site = JSON.parse(json)

    paginator = Paginator.new(site, :all)
    paginator.define_pagination_params
    expect(paginator.add_on).to eq ""
    expect(paginator.steps).to eq [""]
  end

  it 'returns the correct add_on with pagination' do
    json = '{"summary":{
      "paginated":"true",
      "pagination":{
        "format":"&pg=NUM",
        "start":"1",
        "scale":"1",
        "records_per_page":"25"
      }
    }}'
    site = JSON.parse(json)

    paginator = Paginator.new(site, 50)
    paginator.define_pagination_params
    expect(paginator.add_on).to eq "&pg=NUM"
  end

  it 'returns the correct pages when given record limit' do
    json = '{"summary":{
      "paginated":"true",
      "pagination":{
        "format":"&pg=NUM",
        "start":"1",
        "scale":"1",
        "records_per_page":"25"
      }
    }}'
    site = JSON.parse(json)

    paginator = Paginator.new(site, 50)
    paginator.define_pagination_params
    expect(paginator.steps).to eq [1, 2]
  end

  it 'adds an additional page if pages wrap to next page' do
    json = '{"summary":{
      "paginated":"true",
      "pagination":{
        "format":"&pg=NUM",
        "start":"1",
        "scale":"1",
        "records_per_page":"25"
      }
    }}'
    site = JSON.parse(json)

    paginator = Paginator.new(site, 58)
    paginator.define_pagination_params
    expect(paginator.steps).to eq [1, 2, 3]
  end

  it 'can handle a starting of 0' do
    json = '{"summary":{
      "paginated":"true",
      "pagination":{
        "format":"&pg=NUM",
        "start":"0",
        "scale":"10",
        "records_per_page":"10"
      }
    }}'
    site = JSON.parse(json)

    paginator = Paginator.new(site, 32)
    paginator.define_pagination_params
    expect(paginator.steps).to eq [0, 10, 20, 30]
  end
end
