class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :unique_code
      t.integer :coupon_value
      t.timestamps
    end
  end
end
