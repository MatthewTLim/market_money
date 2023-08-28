require 'rails_helper'

describe "Markets API" do
  before do
    g_markets = create_list(:market, 3)

    g_vendors = create_list(:vendor, 9)

    g_markets.each do |market|
      3.times do
        vendor = g_vendors.sample
        create(:market_vendor, market: market, vendor: vendor)
      end
    end
  end

  it "sends a list of all markets with vendor count" do
  get '/api/v0/markets'

  expect(response).to be_successful

  markets = JSON.parse(response.body)

    markets["data"].each do |market|
      expect(market).to have_key("id")
      expect(market["id"]).to be_an(Integer)

      expect(market).to have_key("name")
      expect(market["name"]).to be_a(String)

      expect(market).to have_key("street")
      expect(market["street"]).to be_a(String)

      expect(market).to have_key("city")
      expect(market["city"]).to be_a(String)

      expect(market).to have_key("county")
      expect(market["county"]).to be_a(String)

      expect(market).to have_key("state")
      expect(market['state']).to be_a(String)

      expect(market).to have_key("zip")
      expect(market["zip"]).to be_a(String)

      expect(market).to have_key("lat")
      expect(market["lat"]).to be_a(String)

      expect(market).to have_key("lon")
      expect(market["lon"]).to be_a(String)

      expect(market).to have_key("vendor_count")
      expect(market["vendor_count"]).to be_a(Integer)
    end
  end
end
