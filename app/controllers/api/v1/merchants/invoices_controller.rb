class Api::V1::Merchants::InvoicesController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    invoices = if params[:status].present?
      merchant.invoices.where(status: params[:status])
    else
      merchant.invoices
    end
    render json: InvoiceSerializer.new(invoices)
  end

  private
  def invoice_params
    params.require(:coupon).permit(:customer_id, :merchant_id, :status, :coupon.id, :invoice_coupon_counter)
  end

end