class MarketFacade
  def initialize(market)
    @market = market
  end

  def as_json
    MarketPoro.new(@market).as_json
  end

  def self.build_collection(markets)
    markets.map { |market| new(market).as_json }
  end
end
