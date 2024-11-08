class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :unique_code, :coupon_value, :merchant_id
end