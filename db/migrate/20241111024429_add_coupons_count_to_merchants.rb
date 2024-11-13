class AddCouponsCountToMerchants < ActiveRecord::Migration[7.1]
  def change
    add_column :merchants, :coupons_count, :integer, default: 0
  end
end
