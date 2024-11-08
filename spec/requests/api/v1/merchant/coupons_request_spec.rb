require 'rails_helper'

RSpec.describe "Coupon Merchants endpoints", type: :request do
  before(:each) do
    @merchant1 = create(:merchant)
    @coupon1 = create(:coupon, merchant: @merchant1)
  end
  it "should show a specific coupon and its details" do

    get "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}"

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(json[:data][:attributes][:name]).to eq(@coupon1.name)
    expect(json[:data][:attributes][:coupon_value]).to eq(@coupon1.coupon_value)
    expect(json[:data][:attributes][:unique_code]).to eq(@coupon1.unique_code)
  end

  it "should return all of a merchants coupons" do
    get "/api/v1/merchants/#{@merchant1.id}/coupons"

    json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    

  end

  it "should create a new coupon" do
    new_coupon_params ={
      name: '99% Off',
      unique_code: 'FUNCOUNT10',
      coupon_value: 10,
      merchant_id: @merchant1.id}

    headers = { "CONTENT_TYPE" => "application/json"}
    post "/api/v1/merchants/#{@merchant1.id}/coupons", headers: headers, params: JSON.generate(coupon: new_coupon_params)
    expect(response.status).to eq(201)

  end

  it "should update an existing coupont" do
    coupon = Coupon.create(
      name: '99% Off',
      unique_code: 'FUNCOUNT10',
      coupon_value: 10,
      merchant_id: @merchant1.id
    )

    coupon_params ={
      name: '95% Off',
      unique_code: 'NOCOUNT10',
      coupon_value: 14,
      merchant_id: @merchant1.id}

    headers = { "CONTENT_TYPE" => "application/json" }
    patch "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}", headers: headers, params: JSON.generate({coupon: coupon_params})

    changed_coupon = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful


  end

  
end