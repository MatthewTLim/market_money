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

  def create
    begin
      vendor = Vendor.new(vendor_params)

      if vendor.save
        render json: VendorSerializer.new(vendor), status: :created
      else
        render json: { errors: [{ detail: vendor.errors.full_messages }] }, status: :bad_request
      end
    rescue ActiveRecord::ActiveRecordError => e
      render json: { errors: [{ detail: e.message }] }, status: :bad_request
    end
  end

  def update
    begin
      vendor = Vendor.find(params[:id])

      if vendor.update(vendor_params)
        render json: VendorSerializer.new(Vendor.update(params[:id], vendor_params))
      else
        render json: { errors: [{ detail: vendor.errors.full_messages }] }, status: :bad_request
      end
    rescue ActiveRecord::ActiveRecordError => e
      render json: { errors: [{ detail: e.message }] }, status: :bad_request
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted )
  end
end

