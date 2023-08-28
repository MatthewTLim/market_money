class Api::V0::MarketsController < ApplicationController
  def index
    markets = Market.all.includes(:vendors)
    market_response = MarketFacade.build_collection(markets)
    render json:{ data: market_response }, status: :ok
  end
end