# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d little_shop_development db/data/little_shop_development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)

merchant_1 = Merchant.first
merchant_2 = Merchant.second
merchant_3 = Merchant.third
merchant_4 = Merchant.fourth
merchant_5 = Merchant.fifth

Coupon.create([
  # Merchant 1 Coupons
  { name: '10% Off', unique_code: 'DISCOUNT10', coupon_value: 10, merchant_id: merchant_1.id },
  { name: '15% Off', unique_code: 'DISCOUNT15', coupon_value: 15, merchant_id: merchant_1.id },
  { name: 'Free Shipping', unique_code: 'FREESHIP', coupon_value: 0, merchant_id: merchant_1.id },
  { name: '25% Off', unique_code: 'DISCOUNT25', coupon_value: 25, merchant_id: merchant_1.id },
  { name: '50% Off', unique_code: 'HALFOFF', coupon_value: 50, merchant_id: merchant_1.id },

  # Merchant 2 Coupons
  { name: '20% Off', unique_code: 'DISCOUNT20', coupon_value: 20, merchant_id: merchant_2.id },
  { name: '30% Off', unique_code: 'DISCOUNT30', coupon_value: 30, merchant_id: merchant_2.id },
  { name: 'Free Shipping', unique_code: 'SHIPPINGFREEDOM', coupon_value: 0, merchant_id: merchant_2.id },
  { name: 'BOGO Free', unique_code: 'BOGOFREE', coupon_value: 100, merchant_id: merchant_2.id },
  { name: '10% Off Next Order', unique_code: 'NEXT10', coupon_value: 10, merchant_id: merchant_2.id },

  # Merchant 3 Coupons
  { name: 'Buy One Get One', unique_code: 'BOGO', coupon_value: 100, merchant_id: merchant_3.id },
  { name: '35% Off', unique_code: 'DISCOUNT35', coupon_value: 35, merchant_id: merchant_3.id },
  { name: '10% Off', unique_code: 'DISCOUNT10OFF', coupon_value: 10, merchant_id: merchant_3.id },
  { name: '10% Off Today Only', unique_code: 'TODAY10', coupon_value: 10, merchant_id: merchant_3.id },
  { name: '20% Off', unique_code: 'DISCOUNT20OFF', coupon_value: 20, merchant_id: merchant_3.id },

  # Merchant 4 Coupons
  { name: '15% Off', unique_code: 'HAPPY15', coupon_value: 15, merchant_id: merchant_4.id },
  { name: 'Free Item With Purchase', unique_code: 'FREEITEM', coupon_value: 100, merchant_id: merchant_4.id },
  { name: '50% Off', unique_code: 'HALFPRICE', coupon_value: 50, merchant_id: merchant_4.id },
  { name: '25% Off', unique_code: 'SUMMER25', coupon_value: 25, merchant_id: merchant_4.id },
  { name: 'Exclusive Member Discount', unique_code: 'EXCLMEMBER', coupon_value: 30, merchant_id: merchant_4.id },

  # Merchant 5 Coupons
  { name: '10% Off', unique_code: 'WINTER10', coupon_value: 10, merchant_id: merchant_5.id },
  { name: '15% Off Your First Order', unique_code: 'FIRST15', coupon_value: 15, merchant_id: merchant_5.id },
  { name: '20% Off', unique_code: 'FESTIVE20', coupon_value: 20, merchant_id: merchant_5.id },
  { name: 'Buy 2 Get 1 Free', unique_code: 'BUY2GET1', coupon_value: 100, merchant_id: merchant_5.id },
  { name: '10% Off on Referrals', unique_code: 'REFERRAL10', coupon_value: 10, merchant_id: merchant_5.id }
])