FactoryBot.define do
  factory :coupon do
    sequence(:code) { |n| "DISCOUNT_#{n}" }  # Generates unique codes like DISCOUNT_1, DISCOUNT_2, etc.
    name { "Discount 10%" }
    percentage { true }
    active { true }
    amount_off { 0 }  # Set to a default valid amount; adjust as necessary
    discount_percentage { 10.0 }
    merchant  # Associate with a merchant
  end
end