FactoryBot.define do
  factory :coupon do
    name { "Discount 10%" }
    coupon_value { 10 }
    unique_code { "DISCOUNT10" }
    association :merchant 
  end
end