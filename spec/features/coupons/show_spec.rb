require "rails_helper"

RSpec.describe "Merchant Coupon Show Page " do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Casio Care")


    @coupon1 = Coupon.create!(name: "Summer BOGO", unique_code: "BOGO50", discount: 50, merchant_id: @merchant1.id, discount_type: "percent" )
    @coupon2 = Coupon.create!(name: "Everthing Must Go", unique_code: "TAKE50", discount: 50, merchant_id: @merchant1.id, discount_type: "dollar" )


    @coupon_m2_1 = Coupon.create!(name: "Winter Sale", unique_code: "WINTER50", discount: 25, merchant_id: @merchant2.id )

  end

  describe "Merchant's coupon show page" do
    it "displays coupon name, discount code, amd discount value" do
      visit merchant_coupon_path(@merchant1, @coupon1)

      expect(page).to have_content(@coupon1.name)
      expect(page).to have_content(@coupon1.unique_code)
      expect(page).to have_content("50% Off")

      expect(page).to_not have_content(@coupon2.name)
      expect(page).to_not have_content(@coupon2.unique_code)
      expect(page).to_not have_content("$50 Off")

      visit merchant_coupon_path(@merchant1, @coupon2)

      expect(page).to have_content(@coupon2.name)
      expect(page).to have_content(@coupon2.unique_code)
      expect(page).to have_content("$50 Off")

      expect(page).to_not have_content(@coupon1.name)
      expect(page).to_not have_content(@coupon1.unique_code)
      expect(page).to_not have_content("50% Off")

    end

    it "displays coupon's status and number of times coupon has been used" do

    end
  end
end