require 'rails_helper'

RSpec.describe Api::V0::MarketVendorsController, type: :controller do
  describe "#invalid_vendor_and_market_ids?" do
    before do
      @market = create(:market)
      @vendor = create(:vendor)
    end

    it "returns false if both vendor and market are valid" do
      expect(controller.send(:invalid_vendor_and_market_ids?, @vendor.id, @market.id)).to be(false)
    end

    it "returns true if either vendor or market is invalid" do
      expect(controller.send(:invalid_vendor_and_market_ids?, @vendor.id, nil)).to be(true)
      expect(controller.send(:invalid_vendor_and_market_ids?, nil, @market.id)).to be(true)
      expect(controller.send(:invalid_vendor_and_market_ids?, nil, nil)).to be(true)
    end
  end

  describe '#find_market_vendor' do
    it 'renders an error response if the market vendor association does not exist' do
      @market = create(:market)
      @vendor = create(:vendor)

      allow(controller).to receive(:params).and_return({ market_id: @market.id, vendor_id: @vendor.id })
      allow(@MarketVendor).to receive(:find_by).and_return(nil)

      expect(controller).to receive(:render).with(json: { errors: [{ detail: "Market vendor association not found." }] }, status: :not_found)

      controller.send(:find_market_vendor)
    end
  end
end
