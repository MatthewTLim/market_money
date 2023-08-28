require 'rails_helper'

RSpec.describe MarketVendor, type: :model do
  describe "#relationships" do
    it { should belong_to(:vendor) }
    it { should belong_to(:market) }
  end
end