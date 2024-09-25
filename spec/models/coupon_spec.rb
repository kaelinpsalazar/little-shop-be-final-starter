require 'rails_helper'

RSpec.describe Coupon, type: :model do
  let!(:merchant) { Merchant.create(name: "Test Merchant") } 

  context "validations" do
    before do
      Coupon.create!(name: "testNamee", code: "testcode", merchant: merchant, active: true, amount_off: 10)
    end

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
    it { should validate_numericality_of(:amount_off).allow_nil }
    it { should validate_inclusion_of(:active).in_array([true, false]) }
  end

  describe "merchant_coupon_limit" do
    before do
      5.times do |i|
        Coupon.create!(name: "testname #{i}", code: "testt#{i}", merchant: merchant, active: true)
      end
    end

    it "is invalid if a merchant has more than 5 active coupons" do
      new_coupon = Coupon.new(name: "new coupon", code: "testCode1", merchant: merchant, active: true)
      expect(new_coupon).not_to be_valid
      expect(new_coupon.errors.full_messages).to include("Merchant cannot have more than 5 active coupons.")
    end

    it "is valid if the merchant has fewer than 5 active coupons" do
      merchant.coupons.first.update(active: false)
      valid_coupon = Coupon.new(name: "new coupon", code: "test_code1", merchant: merchant, active: true)
      expect(valid_coupon).to be_valid
    end
  end

  describe ".sorted_by_active" do
    it "returns coupons sorted by active status" do
      active_coupon = Coupon.create!(name: "test-coupon", code: "active", merchant: merchant, active: true)
      inactive_coupon = Coupon.create!(name: "test-coupon2", code: "inactive", merchant: merchant, active: false)

      sorted_coupons = Coupon.sorted_by_active(merchant)

      expect(sorted_coupons.first).to eq(active_coupon)
      expect(sorted_coupons.last).to eq(inactive_coupon)
    end
  end
  describe ".sorted_by_inactive" do
    it "returns coupons sorted by inactive status" do
      active_coupon = Coupon.create!(name: "test-coupon", code: "active", merchant: merchant, active: true)
      inactive_coupon = Coupon.create!(name: "test-coupon2", code: "inactive", merchant: merchant, active: false)
  
      sorted_coupons = Coupon.sorted_by_inactive(merchant)
  
      expect(sorted_coupons.first).to eq(inactive_coupon)
      expect(sorted_coupons.last).to eq(active_coupon)
    end
  end
end