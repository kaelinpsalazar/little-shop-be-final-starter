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

system("rails db:migrate")
# db/seeds.rb

# db/seeds.rb

Coupon.create([
  {name: "SUMMER24", code: "SUMMER24", percentage_off: 0.0, active: true, amount_off: 10.00, merchant_id: 2},
  {name: "FALL24", code: "FALL24", percentage_off: 0.0, active: true, amount_off: 20.00, merchant_id: 2},
  {name: "WINTER24", code: "WINTER24", percentage_off: 0.0, active: true, amount_off: 30.00, merchant_id: 2},
  {name: "SPRING24", code: "SPRING24", percentage_off: 0.0, active: true, amount_off: 40.00, merchant_id: 2},
  {name: "SUMMER25", code: "SUMMER25", percentage_off: 10.00, active: true, amount_off: 0.0, merchant_id: 2},
  {name: "FALL25", code: "FALL25", percentage_off: 20.00, active: false, amount_off: 0.0, merchant_id: 2},
  {name: "SPRING25", code: "SPRING25", percentage_off: 40.00, active: false, amount_off: 0.0, merchant_id: 2},
  {name: "WINTER25", code: "WINTER25", percentage_off: 30.00, active: false, amount_off: 0.0, merchant_id: 2},
  {name: "SUMMER25_MERCHANT1", code: "SUMMER25_MERCHANT1", percentage_off: 10.00, active: true, amount_off: 0.0, merchant_id: 1},
  {name: "FALL25_MERCHANT1", code: "FALL25_MERCHANT1", percentage_off: 20.00, active: false, amount_off: 0.0, merchant_id: 1},
  {name: "SPRING25_MERCHANT1", code: "SPRING25_MERCHANT1", percentage_off: 40.00, active: true, amount_off: 0.0, merchant_id: 1},
  {name: "WINTER25_MERCHANT1", code: "WINTER25_MERCHANT1", percentage_off: 30.00, active: false, amount_off: 0.0, merchant_id: 1},
  {name: "HOLIDAY20", code: "HOLIDAY20", percentage_off: 15.00, active: true, amount_off: 0.0, merchant_id: 1},
  {name: "NEWYEAR21", code: "NEWYEAR21", percentage_off: 25.00, active: true, amount_off: 0.0, merchant_id: 2},
  {name: "BACKTOSCHOOL21", code: "BACKTOSCHOOL21", percentage_off: 10.00, active: false, amount_off: 5.00, merchant_id: 2},
  {name: "VALENTINES22", code: "VALENTINES22", percentage_off: 5.00, active: true, amount_off: 10.00, merchant_id: 1},
  {name: "EASTER22", code: "EASTER22", percentage_off: 20.00, active: true, amount_off: 15.00, merchant_id: 1},
  {name: "LABORDAY22", code: "LABORDAY22", percentage_off: 0.0, active: true, amount_off: 50.00, merchant_id: 2},
  {name: "CYBERMONDAY22", code: "CYBERMONDAY22", percentage_off: 30.00, active: true, amount_off: 0.0, merchant_id: 2},
  {name: "BLACKFRIDAY22", code: "BLACKFRIDAY22", percentage_off: 40.00, active: false, amount_off: 0.0, merchant_id: 2},
  {name: "WINTERCLEARANCE22", code: "WINTERCLEARANCE22", percentage_off: 0.0, active: true, amount_off: 20.00, merchant_id: 1},
  {name: "SUMMERCLEARANCE22", code: "SUMMERCLEARANCE22", percentage_off: 50.00, active: true, amount_off: 0.0, merchant_id: 1},
  {name: "SPRINGSALE22", code: "SPRINGSALE22", percentage_off: 10.00, active: true, amount_off: 10.00, merchant_id: 2},
])


