require 'rails_helper'

RSpec.describe "Coupon Merchants endpoints", type: :request do
  before(:each) do
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)
    @coupon1 = create(:coupon, merchant: @merchant1)
    @coupon2 = create(:coupon, merchant: @merchant1)
    @coupon3 = create(:coupon, merchant: @merchant2) 
  end

  describe "it shows a coupon" do
    it "should show a specific coupon and its details" do
      get "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}"
      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(json[:data][:attributes][:name]).to eq(@coupon1.name)
      expect(json[:data][:attributes][:coupon_value]).to eq(@coupon1.coupon_value)
      expect(json[:data][:attributes][:unique_code]).to eq(@coupon1.unique_code)
      expect(json[:data][:attributes][:active]).to eq(@coupon1.active)
      expect(json[:data][:attributes][:usage_count]).to eq(@coupon1.usage_count)
    end
    it "tracks how many timesthe coupon was used" do
        invoice1 = create(:invoice, merchant: @merchant1, coupon: @coupon1)
        invoice2 = create(:invoice, merchant: @merchant1, coupon: @coupon1)
        invoice3 = create(:invoice, merchant: @merchant1, coupon: nil)
        expect(@coupon1.usage_count).to eq(2)
    end
    it 'does not count invoices with no coupon applied' do
      invoice1 = create(:invoice, merchant: @merchant1, coupon: nil)
      invoice2 = create(:invoice, merchant: @merchant1, coupon: nil)
      expect(@coupon1.usage_count).to eq(0)
    end
  end 
  
  describe "show all coupons" do
    it "should return all of a merchants coupons" do
      get "/api/v1/merchants/#{@merchant1.id}/coupons"
      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(json[:data].length).to eq(2)
      expect(json[:data][0][:attributes][:merchant_id]).to eq(@merchant1.id)
      expect(json[:data][1][:attributes][:merchant_id]).to eq(@merchant1.id)
    end
  end

  describe "create" do
    it "should create a new coupon" do
      new_coupon_params ={
        name: '99% Off',
        unique_code: 'FUNCOUNT10',
        coupon_value: 10,
        merchant_id: @merchant1.id
      }
        headers = { "CONTENT_TYPE" => "application/json"}
        post "/api/v1/merchants/#{@merchant1.id}/coupons", headers: headers, params: JSON.generate(coupon: new_coupon_params)
        expect(response.status).to eq(201)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:attributes][:name]).to eq(new_coupon_params[:name])
        expect(json[:data][:attributes][:unique_code]).to eq(new_coupon_params[:unique_code])
        expect(json[:data][:attributes][:coupon_value]).to eq(new_coupon_params[:coupon_value])
        expect(json[:data][:attributes][:merchant_id]).to eq(@merchant1.id)
      end
  end

  describe "update" do
    it "should update an existing coupon" do
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
          expect(changed_coupon[:data][:attributes][:name]).to eq(coupon_params[:name])
          expect(changed_coupon[:data][:attributes][:unique_code]).to eq(coupon_params[:unique_code])
          expect(changed_coupon[:data][:attributes][:coupon_value]).to eq(coupon_params[:coupon_value])
          expect(changed_coupon[:data][:attributes][:merchant_id]).to eq(coupon_params[:merchant_id])
    end

    it "responds with an error message" do
      coupon = Coupon.create(
        name: '99% Off',
        unique_code: 'FUNCOUNT10',
        coupon_value: 10,
        merchant_id: @merchant1.id
      )

      invalid_params = { coupon: { name: '', unique_code: '', coupon_value: nil } }
      headers = { "CONTENT_TYPE" => "application/json" }

      patch "/api/v1/merchants/#{@merchant1.id}/coupons/#{coupon.id}", headers: headers, params: JSON.generate(invalid_params)

      expect(response.status).to eq(422)
      error = JSON.parse(response.body,symbolize_names:true)
      expect(error[:errors]).to include("Unique code can't be blank")
    end

    
  end

  describe "change status" do
    before do
      @coupon1.update(active:true)
      @coupon2.update(active:false)
    end
    it  "activates a coupon" do
      coupon_params = { active: true }
      headers = { "CONTENT_TYPE" => "application/json" }
      expect(@coupon2.active).to be false
      patch "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}", params: JSON.generate({ coupon: coupon_params }), headers: headers
    
      expect(response).to be_successful
      coupon = JSON.parse(response.body, symbolize_names: true)
      expect(coupon[:data][:attributes][:active]).to be true
    end
    
    it "successfully deactivates a coupon" do
      coupon_params = { active: false }
      headers = { "CONTENT_TYPE" => "application/json" }
      expect(@coupon1.active).to be true
      
      patch "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}", params: JSON.generate({ coupon: coupon_params }), headers: headers
      expect(response).to be_successful
      coupon = JSON.parse(response.body, symbolize_names: true)
      expect(coupon[:data][:attributes][:active]).to be false
    end

    it "does not let you deactivate with a pending invoices" do
      create(:invoice, status: 'packaged', coupon: @coupon1)
  
      headers = { "CONTENT_TYPE" => "application/json"}
      patch "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon1.id}", params: { coupon: { active: false } }.to_json, headers: headers
      error = JSON.parse(response.body, symbolize_names: true)
  
      expect(response.status).to eq(422)
      expect(error[:errors]).to include("Cannot deactivate coupon because there are pending invoices.")
      @coupon1.reload
      expect(@coupon1.active).to eq(true) 
      
  
    end
  end

  

  describe "sad paths" do
    it "returns error when the coupon code is not unique" do
      Coupon.create!(name: 'First Coupon', unique_code: 'FUNCOUNT10', coupon_value: 10, merchant_id: @merchant1.id)
      coupon_params = {
        name: 'Second Coupon',
        unique_code: 'FUNCOUNT10',  
        coupon_value: 20,
        merchant_id: @merchant1.id
      }
  
      headers = { "CONTENT_TYPE" => "application/json" }
      post "/api/v1/merchants/#{@merchant1.id}/coupons", headers: headers, params: JSON.generate({ coupon: coupon_params })
      error = JSON.parse(response.body, symbolize_names: true)
  
      expect(response.status).to eq(422)
      expect(error[:errors]).to include("Unique code has already been taken")
    end

     it "will respond with an error if a merchant already has 5 coupons" do
       max_merchant = Merchant.create!(name: "Kaelin")
       create_list(:coupon, 5, merchant: max_merchant)
     
       coupon_params = {
         name: '98% Off',
         unique_code: 'LIMIT10',
         coupon_value: 10,
         merchant_id: max_merchant.id
       }
       headers = { "CONTENT_TYPE" => "application/json"}
       post "/api/v1/merchants/#{max_merchant.id}/coupons", headers: headers, params: JSON.generate(coupon: coupon_params)     
       error = JSON.parse(response.body, symbolize_names: true)
       expect(response).to_not be_successful
       expect(error[:errors].first).to eq("This merchant has the max number of coupons")
     end
  end


  
end


# describe "active/inactive filter" do
#   before :each do
#     @merchant1 = Merchant.create!(name: "Merchant 1")
#     @active_coupon = Coupon.create!(name: "10% Off", unique_code: "dcvxcdfdd5d0", coupon_value: 10, merchant: @merchant1, active: true)
#     @inactive_coupon = Coupon.create!(name: "20% Off", unique_code: "abc12345d0", coupon_value: 20, merchant: @merchant1, active: false)
#   end
#   it "will return a coupon if it's status is active" do
#     result = Coupon.filter_by_status(@merchant1, 'active')      
#     expect(result).to include(@active_coupon)
#     expect(result).not_to include(@inactive_coupon)
#   end
#   it "returns inactive coupons when filtering by 'inactive'" do
#     result = Coupon.filter_by_status(@merchant1, 'inactive')
#     expect(result).to include(@inactive_coupon)
#     expect(result).not_to include(@active_coupon)
#   end
#   it "returns all coupons when no filter is provided" do
#     result = Coupon.filter_by_status(@merchant1, nil)
#     expect(result).to include(@active_coupon, @inactive_coupon)
#   end
# end