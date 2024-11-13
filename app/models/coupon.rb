class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices, dependent: :nullify

  validates :unique_code, uniqueness: true, presence: true
  validates :coupon_value, numericality: { greater_than: 0 }

  validate :max_coupons, on: [:create]
  
  
# return the number of times a invoice is associated with a coupon 
  def usage_count
    invoices.count
  end

 
  

  def self.filter_by_status(merchant, status)
    # if status is there, filter on that
    if status.present?
      where(merchant: merchant, active: status)
    else
      # if no status jsut return all
      where(merchant: merchant)
    end
  end
  





  def max_coupons 
    if merchant && merchant.coupons.count >= 5
      errors.add(:base, "This merchant has the max number of coupons")
    end
  end



  


end