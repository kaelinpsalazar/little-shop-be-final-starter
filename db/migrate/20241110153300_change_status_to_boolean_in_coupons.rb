class ChangeStatusToBooleanInCoupons < ActiveRecord::Migration[7.0]
  def up
    add_column :coupons, :active, :boolean, default: true

    Coupon.reset_column_information
    Coupon.update_all(active: false, status: 'inactive')
    Coupon.where(status: 'active').update_all(active: true)

    remove_column :coupons, :status
  end

  end
end
