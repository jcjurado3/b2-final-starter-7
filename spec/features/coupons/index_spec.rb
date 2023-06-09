require 'rails_helper'

RSpec.describe "Merchant Coupons Index" do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Casio Care")


    @coupon1 = Coupon.create!(name: "Summer BOGO", unique_code: "BOGO50", discount: 50, merchant_id: @merchant1.id )
    @coupon2 = Coupon.create!(name: "Summer BOGO", unique_code: "BOGO35", discount: 35, merchant_id: @merchant1.id )


    @coupon_m2_1 = Coupon.create!(name: "Winter Sale", unique_code: "BOGO50", discount: 25, merchant_id: @merchant2.id )

  end
  describe "Coupon Index Page" do
    it "merchant dashboard has link to coupon index page" do
      visit merchant_dashboard_index_path(@merchant1)

      expect(page).to have_link("Coupons")

      click_link "Coupons"

      expect(current_path).to eq(merchant_coupons_path(@merchant1))
    end

    it "displays all names of coupons including amount off with link to coupons show page" do
      visit merchant_coupons_path(@merchant1)
      within("#coupon-#{@coupon1.id}") do
        expect(page).to have_content(@coupon1.name)
        expect(page).to have_content("#{@coupon1.discount}% Off")

        expect(page).to_not have_content(@coupon_m2_1.name)
        expect(page).to_not have_content("#{@coupon_m2_1.discount}% Off")

        expect(page).to have_link(@coupon1.name)

        expect(page).to_not have_link(@coupon_m2_1.name)
      end

      within("#coupon-#{@coupon2.id}") do
        expect(page).to have_content(@coupon2.name)
        expect(page).to have_content("#{@coupon2.discount}% Off")

        expect(page).to_not have_content(@coupon_m2_1.name)
        expect(page).to_not have_content("#{@coupon_m2_1.discount}% Off")

        expect(page).to have_link(@coupon2.name)

        expect(page).to_not have_link(@coupon_m2_1.name)
      end

    end
  end
end