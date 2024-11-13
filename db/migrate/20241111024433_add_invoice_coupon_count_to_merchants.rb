class AddInvoiceCouponCountToMerchants < ActiveRecord::Migration[7.1]
  def change
    add_column :merchants, :invoice_coupon_count, :integer, default: 0
  end
end
