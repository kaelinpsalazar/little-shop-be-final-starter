class Coupon < ApplicationRecord
  belongs_to :merchant
  has_one :invoice, required: false

  validates :unique_code, uniqueness: true, presence: true
  validates :coupon_value, numericality: { greater_than: 0 }
end