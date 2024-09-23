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

# db/seeds.rb

# Create some merchants to associate with the coupons
# Create some merchants to associate with the coupons
merchant1 = Merchant.find_or_create_by!(name: "Merchant One")
merchant2 = Merchant.find_or_create_by!(name: "Merchant Two")

# Create coupons
Coupon.find_or_create_by!(code: "NY2024") do |coupon|
  coupon.name = "New Year Sale"
  coupon.active = true
  coupon.amount_off = 10.0
  coupon.percentage_off = nil
  coupon.merchant = merchant1
end

Coupon.find_or_create_by!(code: "SPRING20") do |coupon|
  coupon.name = "Spring Discount"
  coupon.active = true
  coupon.amount_off = nil
  coupon.percentage_off = 20.0
  coupon.merchant = merchant1
end

Coupon.find_or_create_by!(code: "SUMMER15") do |coupon|
  coupon.name = "Summer Special"
  coupon.active = true
  coupon.amount_off = 15.0
  coupon.percentage_off = nil
  coupon.merchant = merchant2
end

Coupon.find_or_create_by!(code: "FALL30") do |coupon|
  coupon.name = "Fall Clearance"
  coupon.active = false
  coupon.amount_off = nil
  coupon.percentage_off = 30.0
  coupon.merchant = merchant2
end

Coupon.find_or_create_by!(code: "WINTER50") do |coupon|
  coupon.name = "Winter Blowout"
  coupon.active = true
  coupon.amount_off = 50.0
  coupon.percentage_off = nil
  coupon.merchant = merchant1
end

