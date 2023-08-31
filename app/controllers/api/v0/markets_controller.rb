class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all.includes(:vendors))
  end

  def show
    market = Market.find(params[:id])
    render json: MarketSerializer.new(market)
    rescue ActiveRecord::RecordNotFound => e
    render json: { errors: [{ detail: e.message }] }, status: :not_found
  end
end

