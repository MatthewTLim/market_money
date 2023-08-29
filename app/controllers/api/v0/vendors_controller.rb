class Api::V0::VendorsController < ApplicationController
  def index
    begin
      @market = Market.find(params[:market_id])
      render json: VendorSerializer.new(@market.vendors)
      rescue ActiveRecord::RecordNotFound => e
      render json: { errors: [{ detail: e.message }] }, status: :not_found
    end
  end

  def show
    begin
      vendor = Vendor.find(params[:id])
      render json: VendorSerializer.new(vendor)
      rescue ActiveRecord::RecordNotFound => e
      render json: { errors: [{ detail: e.message }] }, status: :not_found
    end
  end
end

