require 'rails_helper'

describe "Vendor endpoint" do
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

  it "returns a vendor" do
    vendor_id = create(:vendor).id

    get "/api/v0/vendors/#{vendor_id}"
    expect(response).to be_successful

    vendor_data = JSON.parse(response.body)["data"]

    expect(vendor_data).to have_key("id")
    expect(vendor_data).to have_key("type")
    expect(vendor_data).to have_key("attributes")

    attributes = vendor_data["attributes"]

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
  end

  it "returns an error if the market_id is invalid" do
    invalid_id = 123123123123

    get "/api/v0/vendors/#{invalid_id}"

    expect(response).to have_http_status(:not_found)


    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(error_response).to have_key(:errors)
    expect(error_response[:errors][0]).to have_key(:detail)
    expect(error_response[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=#{invalid_id}")
  end
end



