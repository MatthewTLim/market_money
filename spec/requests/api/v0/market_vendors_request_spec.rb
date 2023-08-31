require 'rails_helper'

describe "Market_Vendors endpoint" do
  describe "#create" do
    it "creates a new association between a market and a vendor" do
      market = create(:market)
      vendor = create(:vendor)
      headers = {"CONTENT_TYPE" => "application/json"}

      post  "/api/v0/market_vendors", headers: headers, params: { market_id: market.id, vendor_id: vendor.id }.to_json

      market.reload
      expect(MarketVendor.exists?(market: market, vendor: vendor)).to be(true)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to eq({ "message" => "Vendor added to market successfully." })
    end

    it "returns a 404 status code if vendor id or market is invalid" do
      vendor = create(:vendor)
      market = create(:market)
      invalid_id = 123123123

      post  "/api/v0/market_vendors", params: { market_id: market.id, vendor_id: invalid_id }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to eq({"errors"=>[{"detail"=>"Both vendor_id and market_id must be valid."}]})

      post  "/api/v0/market_vendors", params: { market_id: invalid_id, vendor_id: vendor.id}

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to eq({"errors"=>[{"detail"=>"Both vendor_id and market_id must be valid."}]})
    end

    it "returns status 400 if both market_id and vendor_id are missing" do
      post "/api/v0/market_vendors", params: { market_id: nil, vendor_id: nil }

      expect(response).to have_http_status(:bad_request)

      error_response = JSON.parse(response.body)
      expect(error_response).to have_key("errors")
      expect(error_response["errors"]).to be_an(Array)
      expect(error_response["errors"]).not_to be_empty
      expect(error_response["errors"][0]).to have_key("detail")
      expect(error_response["errors"][0]["detail"]).to eq("Both vendor_id and market_id are required.")
    end

    it "returns a 400 status code and error message if vendor_id or market_id is missing" do
      vendor = create(:vendor)
      market = create(:market)

      post  "/api/v0/market_vendors", params: { market_id: market.id, vendor_id: nil }

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to eq({"errors"=>[{"detail"=>"Both vendor_id and market_id are required."}]})

      post  "/api/v0/market_vendors", params: { market_id: nil, vendor_id: vendor.id }

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to eq({"errors"=>[{"detail"=>"Both vendor_id and market_id are required."}]})

      post  "/api/v0/market_vendors", params: { market_id: nil, vendor_id: nil }

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to eq({"errors"=>[{"detail"=>"Both vendor_id and market_id are required."}]})
    end

    it "returns a 422 status code if the vendor_market association already exists" do
      vendor = create(:vendor)
      market = create(:market)

      post  "/api/v0/market_vendors", params: { market_id: market.id, vendor_id: vendor.id }

      expect(market.vendors.count).to eq(1)

      post  "/api/v0/market_vendors", params: { market_id: market.id, vendor_id: vendor.id }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({"errors"=>[{"detail"=>"MarketVendor association already exists."}]})
    end
  end

  describe "#destroy" do
    it "can destroy a vendor" do
      market = create(:market)
      vendor = create(:vendor)

      post  "/api/v0/market_vendors", params: { market_id: market.id, vendor_id: vendor.id }

      expect(market.vendors.count).to eq(1)

      headers = {"CONTENT_TYPE" => "application/json"}

      delete  "/api/v0/market_vendors", headers: headers, params: { market_id: market.id, vendor_id: vendor.id }.to_json

      expect(response).to be_successful
      expect(response).to have_http_status(:no_content)
      expect(market.vendors.count).to eq(0)
    end

    it "returns 404 status code if market_vendor resource can not be found" do
      market = create(:market)
      vendor = create(:vendor)
      invalid_id = 123123123

      post  "/api/v0/market_vendors", params: { market_id: market.id, vendor_id: vendor.id }

      expect(market.vendors.count).to eq(1)

      headers = {"CONTENT_TYPE" => "application/json"}

      delete  "/api/v0/market_vendors", headers: headers, params: { market_id: market.id, vendor_id: 123123123 }.to_json

      expect(response).to_not be_successful
      expect(response).to have_http_status(:not_found)
      expect(market.vendors.count).to eq(1)

      delete  "/api/v0/market_vendors", headers: headers, params: { market_id: invalid_id, vendor_id: vendor.id }.to_json

      expect(response).to_not be_successful
      expect(response).to have_http_status(:not_found)
      expect(market.vendors.count).to eq(1)

      json_response = JSON.parse(response.body)

      expect(json_response["errors"]).to be_an(Array)
      expect(json_response["errors"].first["detail"]).to eq("Market vendor association not found.")
    end

  end
end
