class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :unique_code, :coupon_value, :merchant_id, :active, :usage_count

  attribute :usage_count do |object|
    object.usage_count
  end
end