# app/presenters/market_presenter.rb
class MarketPoro
  def initialize(market)
    @market = market
  end

  def as_json
    {
      id: @market.id.to_s,
      type: "market",
      attributes:{
          name: @market.name,
          street: @market.street,
          city: @market.city,
          county: @market.county,
          state: @market.state,
          zip: @market.zip,
          lat: @market.lat,
          lon: @market.lon,
          vendor_count: vendor_count
          }
    }
  end

  private

  def vendor_count
    @market.vendors.count
  end
end
