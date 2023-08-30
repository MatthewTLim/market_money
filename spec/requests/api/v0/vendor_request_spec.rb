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

  it "can create a new vendor" do
    vendor_params = ({
      name: "test vendor",
      description: "This is a test description",
      contact_name: "Testy",
      contact_phone: "123-123-1231",
      credit_accepted: true
    })

    headers = {"CONTENT_TYPE" => "application/json"}

    post api_v0_vendors_path, headers: headers, params: JSON.generate(vendor: vendor_params)

    created_vendor = Vendor.last

    expect(response).to be_successful

    expect(created_vendor.name).to eq(vendor_params[:name])
    expect(created_vendor.description).to eq(vendor_params[:description])
    expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
    expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
    expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
  end

  it "returns an error if a field is left empty" do
    vendor_params = ({
      name: nil,
      description: "This is a test description",
      contact_name: "Testy",
      contact_phone: "123-123-1231",
      credit_accepted: true
    })

    headers = {"CONTENT_TYPE" => "application/json"}

    post api_v0_vendors_path, headers: headers, params: JSON.generate(vendor: vendor_params)

    expect(response).to have_http_status(:bad_request)

    error_response = JSON.parse(response.body, symbolize_names: true)
    # require 'pry'; binding.pry
    expect(error_response).to have_key(:errors)
    expect(error_response[:errors][0]).to have_key(:detail)
    expect(error_response[:errors][0][:detail]).to eq(["Name can't be blank"])
  end

  it "can update an existing vendors details" do
    id = create(:vendor).id
    previous_name = Vendor.last.name
    update_vendor_params = ({ name: "Changed Name market" })
    headers = {"CONTENT_TYPE" => "application/json"}

    patch api_v0_vendor_path(id), headers: headers, params: JSON.generate(vendor: update_vendor_params)
    update_vendor = Vendor.find_by(id: id)

    expect(response).to be_successful
    expect(update_vendor.name).to_not eq(previous_name)
    expect(update_vendor.name).to eq("Changed Name market")
  end

  it "will not update a vendor if attribute is nil or empty" do
    id = create(:vendor).id
    update_vendor_params = ({ name: nil})
    headers = {"CONTENT_TYPE" => "application/json"}

    patch api_v0_vendor_path(id), headers: headers, params: JSON.generate(vendor: update_vendor_params)

    expect(response).to have_http_status(:bad_request)

    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(error_response).to have_key(:errors)
    expect(error_response[:errors][0]).to have_key(:detail)
    expect(error_response[:errors][0][:detail]).to eq(["Name can't be blank"])
  end
end



