require 'rails_helper'

RSpec.describe 'Coupons', type: :request do
  describe 'GET /api/v1/merchants/:merchant_id/coupons' do
    before do
      @merchant = Merchant.create!(name: "Example Merchant")
      @coupon1 = Coupon.create!(name: "Discount 10%", code: "SAVE10", amount_off: 10, merchant: @merchant)
      @coupon2 = Coupon.create!(name: "Discount 20%", code: "SAVE20", amount_off: 20, merchant: @merchant)
      @coupon3 = Coupon.create!(name: "Discount 30%", code: "SAVE30", amount_off: 30, merchant: @merchant)

      get "/api/v1/merchants/#{@merchant.id}/coupons"
    end

    it 'successfully returns coupons for a merchant' do
      expect(response).to be_successful

      json_response = JSON.parse(response.body, symbolize_names: true)


      expect(json_response[:data][0][:attributes]).to include(
        name: @coupon1.name,
        code: @coupon1.code,
        amount_off: @coupon1.amount_off,
        active: @coupon1.active
      )

      expect(json_response[:data][1][:attributes]).to include(
        name: @coupon2.name,
        code: @coupon2.code,
        amount_off: @coupon2.amount_off,
        active: @coupon2.active
      )

      expect(json_response[:data][2][:attributes]).to include(
        name: @coupon3.name,
        code: @coupon3.code,
        amount_off: @coupon3.amount_off,
        active: @coupon3.active
      )
    end

    it 'returns a 404 status if the merchant does not exist' do
      get "/api/v1/merchants/99999/coupons" 
      expect(response).to have_http_status(404)
    end
  end
end
