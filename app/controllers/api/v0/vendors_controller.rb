class Api::V0::VendorsController < ApplicationController
  before_action :find_vendor, only: [:show, :update, :destroy]

  def index
    @market = Market.find(params[:market_id])
    render json: VendorSerializer.new(@market.vendors)
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: [{ detail: e.message }] }, status: :not_found
  end

  def show
    render json: VendorSerializer.new(@vendor)
  end

  def create
    vendor = Vendor.new(vendor_params)

    if vendor.save!
      render json: VendorSerializer.new(vendor), status: :created
    else
      render json: { errors: [{ detail: vendor.errors.full_messages }] }, status: :bad_request
    end
  rescue ActiveRecord::ActiveRecordError => e
    render json: { errors: [{ detail: e.message }] }, status: :bad_request
  end

  def update
    if @vendor.update(vendor_params)
      render json: VendorSerializer.new(@vendor)
    else
      render json: { errors: [{ detail: @vendor.errors.full_messages }] }, status: :bad_request
    end
  end

  def destroy
    render status: :no_content if @vendor.destroy
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end

  def find_vendor
    @vendor = Vendor.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: [{ detail: e.message }] }, status: :not_found
  end
end
