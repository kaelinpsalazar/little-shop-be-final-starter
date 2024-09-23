class CouponSerializer
  include JSONAPI::Serializer

  attributes :name, :code, :active, :amount_off, :percentage_off, :merchant_id
end
