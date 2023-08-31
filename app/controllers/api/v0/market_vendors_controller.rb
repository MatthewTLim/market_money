class Api::V0::MarketVendorsController < ApplicationController
  def create
    market_id = params[:market_id]
    vendor_id = params[:vendor_id]

    if vendor_id.blank? || market_id.blank?
      render json: { errors: [{ detail: "Both vendor_id and market_id are required." }] }, status: :bad_request
    elsif invalid_vendor_and_market_ids?(vendor_id, market_id)
      render json: { errors: [{ detail: "Both vendor_id and market_id must be valid." }] }, status: :not_found
    else
      market_vendor = MarketVendor.new(vendor_id: vendor_id, market_id: market_id)

      if market_vendor.save
        render json: { message: "Vendor added to market successfully." }, status: :created
      else
        render json: { errors: [{ detail: market_vendor.errors.full_messages }] }, status: :unprocessable_entity
      end
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted )
  end

  def invalid_vendor_and_market_ids?(vendor_id, market_id)
    vendor = Vendor.find_by(id: vendor_id)
    market = Market.find_by(id: market_id)

    !(vendor.present? && market.present?)
  end
end

