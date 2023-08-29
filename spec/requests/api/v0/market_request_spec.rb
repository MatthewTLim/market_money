require 'rails_helper'

describe "Markets API" do
  before do
    @g_markets = create_list(:market, 3)

    @g_vendors = create_list(:vendor, 9)

    @g_markets.each do |market|
      3.times do
        vendor = @g_vendors.sample
        create(:market_vendor, market: market, vendor: vendor)
      end
    end
  end

  it "sends a list of all markets with vendor count" do
    get '/api/v0/markets'

    expect(response).to be_successful

    markets_data = JSON.parse(response.body)

    expect(markets_data).to have_key("data")

    markets = markets_data["data"]

    markets.each do |market|
      attributes = market["attributes"]

      expect(attributes).to have_key("name")
      expect(attributes["name"]).to be_a(String)

      expect(attributes).to have_key("street")
      expect(attributes["street"]).to be_a(String)

      expect(attributes).to have_key("city")
      expect(attributes["city"]).to be_a(String)

      expect(attributes).to have_key("county")
      expect(attributes["county"]).to be_a(String)

      expect(attributes).to have_key("state")
      expect(attributes['state']).to be_a(String)

      expect(attributes).to have_key("zip")
      expect(attributes["zip"]).to be_a(String)

      expect(attributes).to have_key("lat")
      expect(attributes["lat"]).to be_a(String)

      expect(attributes).to have_key("lon")
      expect(attributes["lon"]).to be_a(String)

      expect(attributes).to have_key("vendor_count")
      expect(attributes["vendor_count"]).to be_an(Integer)

      expect(market).to have_key("id")
      expect(market["id"]).to be_a(String)

      expect(market).to have_key("type")
      expect(market["type"]).to be_a(String)

      expect(market).to have_key("attributes")
      expect(market["attributes"]).to be_a(Hash)
    end
  end

  it "gets one market by using the id" do
    id = create(:market).id

    get "/api/v0/markets/#{id}"

    market_raw_data = JSON.parse(response.body)
    market_data = market_raw_data["data"]

    expect(market_data).to have_key("id")
    expect(market_data["id"]).to be_a(String)

    expect(market_data).to have_key("type")
    expect(market_data["type"]).to be_a(String)

    expect(market_data).to have_key("attributes")
    expect(market_data["attributes"]).to be_a(Hash)

    attributes = market_data["attributes"]

    expect(attributes).to have_key("name")
    expect(attributes["name"]).to be_a(String)

    expect(attributes).to have_key("street")
    expect(attributes["street"]).to be_a(String)

    expect(attributes).to have_key("city")
    expect(attributes["city"]).to be_a(String)

    expect(attributes).to have_key("county")
    expect(attributes["county"]).to be_a(String)

    expect(attributes).to have_key("state")
    expect(attributes['state']).to be_a(String)

    expect(attributes).to have_key("zip")
    expect(attributes["zip"]).to be_a(String)

    expect(attributes).to have_key("lat")
    expect(attributes["lat"]).to be_a(String)

    expect(attributes).to have_key("lon")
    expect(attributes["lon"]).to be_a(String)

    expect(attributes).to have_key("vendor_count")
    expect(attributes["vendor_count"]).to be_an(Integer)
  end

  it "displays an error message when an invalid id is passed to the show page" do
    invalid_id = 123123123123123

    get "/api/v0/markets/#{invalid_id}"
    expect(response).to have_http_status(:not_found)


    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(error_response).to have_key(:errors)
    expect(error_response[:errors][0]).to have_key(:detail)
    expect(error_response[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=#{invalid_id}")
  end
end
