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

  describe "#GET" do
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

    it "returns an error if the market_id is not found" do
      invalid_id = 123123123123

      get "/api/v0/vendors/#{invalid_id}"

      expect(response).to have_http_status(:not_found)


      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors][0]).to have_key(:detail)
      expect(error_response[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=#{invalid_id}")
    end

    it "returns an error if the vendor_id is not found" do
      invalid_id = 999

      get "/api/v0/vendors/#{invalid_id}"

      expect(response).to have_http_status(:not_found)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors][0]).to have_key(:detail)
      expect(error_response[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=#{invalid_id}")
    end
  end

  describe "#create" do
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
      expect(error_response[:errors][0][:detail]).to eq("Validation failed: Name can't be blank")
    end

    it "returns an error with invalid params" do

      invalid_params = {
        description: "invalid description",
        credit_accepted: true
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v0_vendors_path, headers: headers, params: JSON.generate(vendor: invalid_params)


      expect(response).to have_http_status(:bad_request)


      response_body = JSON.parse(response.body)


      expect(response_body).to have_key("errors")
      expect(response_body["errors"]).to be_an(Array)
      expect(response_body["errors"]).not_to be_empty
      expect(response_body["errors"][0]).to have_key("detail")
      expect(response_body["errors"][0]["detail"]).to include("Name can't be blank")
      expect(response_body["errors"][0]["detail"]).to include("Contact name can't be blank")
      expect(response_body["errors"][0]["detail"]).to include("Contact phone can't be blank")
    end
  end

  describe "#update" do
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
      update_vendor_params = ({ credit_accepted: nil})
      headers = {"CONTENT_TYPE" => "application/json"}

      patch api_v0_vendor_path(id), headers: headers, params: JSON.generate(vendor: update_vendor_params)

      expect(response).to have_http_status(:bad_request)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors][0]).to have_key(:detail)
      expect(error_response[:errors][0][:detail]).to eq(["Credit accepted is not included in the list"])
    end
  end

  describe "#delete" do
    it "can delete a vendor as well as its associations" do
      id = create(:vendor).id

      expect(Vendor.count).to eq(10)

      delete api_v0_vendor_path(id)

      expect(response).to be_successful
      expect(Vendor.count).to eq(9)
      expect{ Vendor.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "can not delete a vendor if the provided id is invalid" do
      invalid_id = 123123123

      delete api_v0_vendor_path(invalid_id)

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors][0]).to have_key(:detail)
      expect(error_response[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=123123123")
    end
  end
end



