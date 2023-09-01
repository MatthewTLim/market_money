require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe "#relationships" do
    it { should have_many(:market_vendors) }
    it { should have_many(:markets).through(:market_vendors) }
  end

  describe "#validations" do
    it "is valid with valid attributes" do
      vendor = create(:vendor)
      expect(vendor).to be_valid
    end

    it "is not valid without a name" do
      vendor = Vendor.new(name: nil)
      expect(vendor).to_not be_valid
    end

    it "is not valid without a contact_name" do
      vendor = Vendor.new(contact_name: nil)
      expect(vendor).to_not be_valid
    end

    it "is not valid without a contact_phone" do
      vendor = Vendor.new(contact_phone: nil)
      expect(vendor).to_not be_valid
    end

    it "is not valid without a credit_accepted" do
      vendor = Vendor.new(credit_accepted: nil)
      expect(vendor).to_not be_valid
    end
  end
end