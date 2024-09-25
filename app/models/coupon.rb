class Coupon < ApplicationRecord
  belongs_to :merchant
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :amount_off, numericality: true, allow_nil: true
  validates :active, inclusion: { in: [true, false] }

  validate :merchant_coupon_limit, on: :create

  def merchant_coupon_limit
    return if merchant.nil? 
    if merchant.coupons.where(active: true).count >= 5
      errors.add(:base, "Merchant cannot have more than 5 active coupons.")
    end
  end

  def self.sorted_by_active(merchant)
    merchant.coupons.order(active: :desc)
  end

  def self.sorted_by_inactive(merchant)
    merchant.coupons.order(active: :asc)
  end

end