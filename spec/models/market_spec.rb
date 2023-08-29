require 'rails_helper'

RSpec.describe Market, type: :model do
  describe "#relationships" do
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe "#validations" do
    it "is valid with valid attributes" do
      market = create(:market)
      expect(market).to be_valid
    end

    it "is not valid without a name" do
      market = Market.new(name: nil)
      expect(market).to_not be_valid
    end
    it "is not valid without a street" do
      market = Market.new(street: nil)
      expect(market).to_not be_valid
    end
    it "is not valid without a city" do
      market = Market.new(city: nil)
      expect(market).to_not be_valid
    end
    it "is not valid without a state" do
      market = Market.new(state: nil)
      expect(market).to_not be_valid
    end
    it "is not valid without a zip" do
      market = Market.new(zip: nil)
      expect(market).to_not be_valid
    end
  end

  describe "#vendor_count" do
    it "counts the number of vendor a market has" do
      @g_markets = create_list(:market, 3)

      @g_vendors = create_list(:vendor, 9)

      @g_markets.each do |market|
        3.times do
          vendor = @g_vendors.sample
          create(:market_vendor, market: market, vendor: vendor)
        end
      end

      expect(@g_markets.first.vendor_count).to eq(3)
    end
  end
end