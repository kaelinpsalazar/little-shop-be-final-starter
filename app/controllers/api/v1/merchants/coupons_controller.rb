class Api::V1::Merchants::CouponsController < ApplicationController

  def index
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons
    render json: CouponSerializer.new(coupon)
  end

  def show
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find(params[:id])
    render json: CouponSerializer.new(coupon)
  end

  def create
    coupon = Coupon.create!(coupon_params)
    render json: CouponSerializer.new(coupon), status: :created
  end

  def update 
    coupon = Coupon.find(params[:id])
    if coupon.update!(coupon_params)
      render json: CouponSerializer.new(coupon), status: :ok
    end
  end

  private

  def coupon_params 
    params.require(:coupon).permit(:name, :unique_code, :coupon_value, :merchant_id)
  end
  

end
