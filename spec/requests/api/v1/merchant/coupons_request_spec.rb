require 'rails_helper'

RSpec.describe "Coupon Merchants endpoints", type: :request do
  before(:each) do
    @merchant1 = create(:merchant)
    @coupon1 = create(:coupon, merchant: @merchant1)
  end
end