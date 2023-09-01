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

  def search
    city = params[:city]
    state = params[:state]
    name = params[:name]

    if invalid_parameters?(city, state, name)
      render json: { errors: [{ detail: "Invalid combination of parameters." }] }, status: :unprocessable_entity
      return
    end

    @markets = Market.all

    @markets = @markets.where("LOWER(name) = ?", name.downcase) if name.present?
    @markets = @markets.where("LOWER(state) = ?", state.downcase) if state.present?
    @markets = @markets.where("LOWER(city) = ?", city.downcase) if city.present?

    render json: MarketSerializer.new(@markets)
  end


  private

  def invalid_parameters?(city, state, name)
    (city.present?) && (state.blank? && name.blank?) || (city.present? && name.present?) && state.blank? || (state.blank? && city.blank? && name.blank?)
  end
end

