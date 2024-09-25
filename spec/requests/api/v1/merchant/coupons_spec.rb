require 'rails_helper'

RSpec.describe 'Coupons', type: :request do
  before :each do
    @merchant = Merchant.create!(name: "Example Merchant")
    @customer = Customer.create!(first_name: "Test", last_name: "Customer")
    @coupon1 = Coupon.create!(name: "Discount 10%", code: "SAVE10", amount_off: 10, merchant_id: @merchant.id, active: true)
    @coupon2 = Coupon.create!(name: "Discount 20%", code: "SAVE20", amount_off: 20, merchant_id: @merchant.id, active: true)
    @coupon3 = Coupon.create!(name: "Discount 30%", code: "SAVE30", amount_off: 30, merchant_id: @merchant.id, active: true)
    
    get "/api/v1/merchants/#{@merchant.id}/coupons"
  end

  it 'successfully returns coupons for a merchant' do
    expect(response).to be_successful

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response[:data].count).to eq(3)

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

  it '404 if the merchant does not exist' do
    get "/api/v1/merchants/99999/coupons"
    expect(response).to have_http_status(404)
  end

  it 'finds one coupon' do
    get api_v1_merchant_coupon_path(@merchant.id, @coupon2.id)
    expect(response).to be_successful

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response[:data][:attributes]).to include(
      name: @coupon2.name,
      code: @coupon2.code,
      amount_off: @coupon2.amount_off,
      active: @coupon2.active
    )
  end

  describe "POST /create" do
    it "successfully creates a coupon" do
      coupon_params = {
        coupon: {
          name: "BOGO256",
          code: "BOGO256",
          amount_off: 42.00,
          active: false,
          merchant_id: @merchant.id  
        }
      }

      headers = { "CONTENT_TYPE" => "application/json" }
      post api_v1_merchant_coupons_path(@merchant.id), headers: headers, params: JSON.generate(coupon_params)

      expect(response).to have_http_status(:created)

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data][:attributes]).to include(
        name: "BOGO256",
        code: "BOGO256",
        amount_off: 42.00,
        active: false,
        merchant_id: @merchant.id
      )
    end
  end

  describe "PATCH /update" do
    before :each do
      @merchant1 = Merchant.create!(name: "Merchant 1")
      @merchant1_coupons = [
        Coupon.create!(name: "Discount 10%", code: "SAVE106", amount_off: 10, merchant: @merchant1, active: true),
        Coupon.create!(name: "Discount 20%", code: "SAVE206", amount_off: 20, merchant: @merchant1, active: false)
      ]
    end

    it "successfully activates a coupon" do
      coupon_params = { active: true }

      headers = { "CONTENT_TYPE" => "application/json" }
      patch api_v1_merchant_coupon_path(@merchant1.id, @merchant1_coupons[1].id), headers: headers, params: JSON.generate(coupon: coupon_params)

      expect(response).to be_successful
      coupon = JSON.parse(response.body, symbolize_names: true)
      expect(coupon[:data][:attributes][:active]).to be true
    end

    it "successfully deactivates a coupon" do
      coupon_params = { active: false }

      headers = { "CONTENT_TYPE" => "application/json" }
      patch api_v1_merchant_coupon_path(@merchant1.id, @merchant1_coupons[1].id), headers: headers, params: JSON.generate(coupon: coupon_params)

      expect(response).to be_successful
      coupon = JSON.parse(response.body, symbolize_names: true)
      expect(coupon[:data][:attributes][:active]).to be false
    end
  end

  describe "GET /index with sorted=active " do
    it "returns only active coupons for the merchant" do
      get "/api/v1/merchants/#{@merchant.id}/coupons", params: { sorted: "active" }

      expect(response).to be_successful

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response[:data].count).to eq(3) 
      expect(json_response[:data].all? { |coupon| coupon[:attributes][:active] }).to be(true)
    end

  end
end
