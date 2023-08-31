require 'rails_helper'

describe "Market_Vendors endpoint" do
  it "creates a new association between a market and a vendor" do
    market = create(:market)
    vendor = create(:vendor)
    headers = {"CONTENT_TYPE" => "application/json"}

    post  "/api/v0/market_vendors", headers: headers, params: { market_id: market.id, vendor_id: vendor.id }.to_json
    # require 'pry'; binding.pry
    market.reload
    expect(MarketVendor.exists?(market: market, vendor: vendor)).to be(true)

    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)).to eq({ "message" => "Vendor added to market successfully." })
  end

  it "returns a 400 status code and error message if vendor_id or market_id is missing" do
    vendor = create(:vendor)
    market = create(:market)

    post  "/api/v0/market_vendors", params: { market_id: market.id, vendor_id: nil }

    expect(response).to have_http_status(:bad_request)
    expect(JSON.parse(response.body)).to eq({"errors"=>[{"detail"=>"Both vendor_id and market_id are required."}]})
  end

  it "returns a 404 status code if vendor id or market is invlaid" do
    vendor = create(:vendor)
    market = create(:market)
    invalid_id = 123123123

    post  "/api/v0/market_vendors", params: { market_id: market.id, vendor_id: invalid_id }
    expect(response).to have_http_status(:not_found)
    expect(JSON.parse(response.body)).to eq({"errors"=>[{"detail"=>"Both vendor_id and market_id must be valid."}]})
  end
end

# If an invalid vendor id or and invalid market id is passed in, a 404 status code as well as a descriptive message should be sent back with the response.
