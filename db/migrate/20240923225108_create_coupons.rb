class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.boolean :active, default: true
      t.float :amount_off 
      t.decimal :percentage_off, precision: 5, scale: 2 
      t.references :merchant, foreign_key: true, null: false

      t.timestamps
    end

    # Add unique index for the code column
    add_index :coupons, :code, unique: true
  end
end
