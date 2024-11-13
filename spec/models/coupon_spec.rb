require "rails_helper"

RSpec.describe Coupon do
  it { should belong_to :merchant}
  it { should have_many :invoices}

    let!(:merchant1) { create(:merchant) }
    let!(:merchant2) { create(:merchant) }

    let!(:coupon1) { create(:coupon, merchant: merchant1, active: true) }
    let!(:coupon2) { create(:coupon, merchant: merchant1, active: false) }
    let!(:coupon3) { create(:coupon, merchant: merchant2, active: true) }
    let!(:coupon4) { create(:coupon, merchant: merchant1, active: true) }
    let!(:coupon5) { create(:coupon, merchant: merchant1, active: false) }
    let!(:coupon6) { create(:coupon, merchant: merchant1, active: true) }
   

  describe "tests" do
  
    it "returns an error if there are more than 5 coupons for a merchant" do
      coupon = Coupon.create(name: "A Coupon", unique_code: "SOMECODE", coupon_value: 10, merchant: merchant1)

      expect(coupon).not_to be_valid
      expect(coupon.errors[:base]).to include("This merchant has the max number of coupons")

    end

    
    it "affirms that active coupons are shown" do
      active_coupons = Coupon.filter_by_status(merchant1, true)
      expect(active_coupons).to include(coupon1)
      expect(active_coupons).to_not include(coupon2, coupon3)
    end

    it "returns all coupons for a merchant when no status is provided (status is nil)" do
      all_coupons = Coupon.filter_by_status(merchant1, nil)
      expect(all_coupons).to include(coupon1, coupon2, coupon4, coupon5, coupon6)
      expect(all_coupons).not_to include(coupon3)
    end
    
    it 'returns the number of invoices associated with the coupon' do
      merchant = create(:merchant)
      coupon = create(:coupon, merchant: merchant)
      create_list(:invoice, 3, coupon: coupon)

      expect(coupon.usage_count).to eq(3)
    end
   
  
  end

  


  
 
end

