class Api::V1::Merchants::CouponsController < ApplicationController

  def index
    merchant = Merchant.find(params[:merchant_id])
    coupons = Coupon.filter_by_status(merchant, params[:filter])
    render json: CouponSerializer.new(coupons)
  end

  def show
    # retrieving the merchant object with matching ID
    merchant = Merchant.find(params[:merchant_id])
    # grabbing the applicable coupon whose Id matches
    coupon = merchant.coupons.find(params[:id])
    # returns the data as JSON
    render json: CouponSerializer.new(coupon)
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.new(coupon_params)
    
    if coupon.save
      render json: CouponSerializer.new(coupon), status: :created
    else
      render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    coupon = Coupon.find(params[:id])
  
    if coupon_params[:active] == false && coupon.invoices.exists?(status: 'packaged')
      render json: { errors: ["Cannot deactivate coupon because there are pending invoices."] }, status: :unprocessable_entity
    elsif coupon.update(coupon_params)
      render json: CouponSerializer.new(coupon), status: :ok
    else
      render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def coupon_params 
    params.require(:coupon).permit(:name, :unique_code, :coupon_value, :merchant_id, :active)
  end
  

end
