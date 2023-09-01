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

  it " returns a list of vendors for a specific market" do
    get "/api/v0/markets/#{@g_markets.first.id}/vendors"

    expect(response).to be_successful

    vendors_data = JSON.parse(response.body)

    expect(vendors_data).to have_key("data")

    vendors = vendors_data["data"]

    vendors.each do |vendor|

      attributes = vendor["attributes"]

      expect(attributes).to have_key("name")
      expect(attributes["name"]).to be_a(String)

      expect(attributes).to have_key("description")
      expect(attributes["description"]).to be_a(String)

      expect(attributes).to have_key("contact_name")
      expect(attributes["contact_name"]).to be_a(String)

      expect(attributes).to have_key("contact_phone")
      expect(attributes["contact_phone"]).to be_a(String)

      expect(attributes).to have_key("credit_accepted")
      expect(attributes['credit_accepted']).to be_a(TrueClass).or be_a(FalseClass)

      expect(vendor).to have_key("id")
      expect(vendor["id"]).to be_a(String)

      expect(vendor).to have_key("type")
      expect(vendor["type"]).to be_a(String)

      expect(vendor).to have_key("attributes")
      expect(vendor["attributes"]).to be_a(Hash)
    end
  end

  it "returns an error if the market_id is invalid" do
    invalid_id = 123123123123

    get "/api/v0/markets/#{invalid_id}/vendors"

    expect(response).to have_http_status(:not_found)


    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(error_response).to have_key(:errors)
    expect(error_response[:errors][0]).to have_key(:detail)
    expect(error_response[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=#{invalid_id}")
  end



  describe "#search" do
    it "returns markets matching the state parameter" do
      market1 = create(:market, state: "CA")
      market2 = create(:market, state: "CA")
      create(:market, state: "NY")

      get "/api/v0/markets/search", params: { state: "CA" }

      expect(response).to have_http_status(:ok)

      expect(JSON.parse(response.body)["data"].length).to eq(2)
    end

    it "returns markets matching the state and city parameter" do
      market1 = create(:market, state: "CA", city: "Los Angeles")
      market2 = create(:market, state: "CA", city: "Los Angeles")
      market3 = create(:market, state: "NY")

      get "/api/v0/markets/search", params: { state: "CA", city: ("Los Angeles") }

      expect(response).to have_http_status(:ok)

      expect(JSON.parse(response.body)["data"].length).to eq(2)
    end

    it "returns markets matching the state, city, and name parameters" do
      market1 = create(:market, state: "CA", city: "San Francisco", name: "Farmers Market")
      market2 = create(:market, state: "CA", city: "San Francisco", name: "Farmers Market")
      create(:market, state: "NY", city: "New York", name: "Local Market")

      get "/api/v0/markets/search", params: { state: "CA", city: "San Francisco", name: "Farmers Market" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"].length).to eq(2)
    end

    it "returns markets matching the state and name parameter" do
      market1 = create(:market, state: "CA", name: "Farmers Market")
      market2 = create(:market, state: "CA", name: "Farmers Market")
      market3 = create(:market, name: "Farmers Market")
      market4 = create(:market)


      get "/api/v0/markets/search", params: { name: "Farmers Market", state: "CA" }

      expect(response).to have_http_status(:ok)
      require 'pry'; binding.pry
      expect(JSON.parse(response.body)["data"].length).to eq(2)
    end

    it "returns markets matching the name parameter" do
      market1 = create(:market, name: "Farmers Market")
      market2 = create(:market, name: "Farmers Market")
      market3 = create(:market, name: "Other Market")

      create(:market, name: "Local Market")

      get "/api/v0/markets/search", params: { name: "Farmers Market" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"].length).to eq(2)
    end

    it "returns an error when just a city parameter is passed" do
      market1 = create(:market, city: "San Francisco")
      market2 = create(:market, city: "San Francisco")
      create(:market, city: "New York")

      get "/api/v0/markets/search", params: { city: "San Francisco" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"][0]["detail"]).to eq("Invalid combination of parameters.")
    end

    it "returns an error with invalid parameter combination" do
      get "/api/v0/markets/search", params: { city: "San Francisco", name: "Farmers Market" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"][0]["detail"]).to eq("Invalid combination of parameters.")
    end

    it "returns an empty array if no markets match the parameters" do
      get "/api/v0/markets/search", params: { state: "TX" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]).to be_empty
    end
  end
end
