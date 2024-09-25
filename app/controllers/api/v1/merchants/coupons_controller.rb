class Api::V1::Merchants::CouponsController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    coupons = merchant.coupons
    if params[:sorted].present?
      if params[:sorted] == "active"
        coupons = coupons.order(active: :desc)  
      elsif params[:sorted] == "inactive"
        coupons = coupons.order(active: :asc)  
      end
    end
    render json: CouponSerializer.new(coupons)
  end

  def show
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find(params[:id])

    render json: CouponSerializer.new(coupon), status: :ok  
  end

  def create
    new_coupon = Coupon.new(coupon_params)
  
    new_coupon.save
    render json: CouponSerializer.new(new_coupon), status: :created
  
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find_by(id: params[:id])
    
    if coupon.update(coupon_params) 
      render json: CouponSerializer.new(coupon), status: :ok
    else
      render json: { error: coupon.errors.full_messages }, status: :unprocessable_entity
    end
  end

  

  private

  def coupon_params
    params.require(:coupon).permit(:name, :code, :active, :amount_off, :percentage_off, :merchant_id)
  end
  
end
