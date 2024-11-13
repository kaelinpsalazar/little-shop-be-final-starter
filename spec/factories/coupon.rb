FactoryBot.define do
  factory :coupon do
    name { "Discount 10%" }
    coupon_value { 10 }
    unique_code { Faker::Alphanumeric.alphanumeric(number: 10).upcase }
    active { false }
    association :merchant
  end
end