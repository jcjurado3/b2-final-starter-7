require 'rails_helper'

RSpec.describe "Merchant Coupons Index" do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @coupon1 = Coupon.create!(name: "Summer BOGO", unique_code: "BOGO50", discount: 50, merchant_id: @merchant1.id )
  end
  describe "Coupon Index Page" do
    it "merchant dashboard has link to coupon index page" do
      visit merchant_dashboard_index_path(@merchant1)

      expect(page).to have_link("Coupons")

      click_link "Coupons"

      expect(current_path).to eq("/merchants/#{@merchant1.id}/coupons")
    end
  end
end