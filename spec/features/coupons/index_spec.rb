require 'rails_helper'

RSpec.describe "Merchant Coupons Index" do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Casio Care")


    @coupon1 = Coupon.create!(name: "Summer BOGO", unique_code: "BOGO50", discount: 50, merchant_id: @merchant1.id, discount_type: "percent" )
    @coupon2 = Coupon.create!(name: "Everthing Must Go", unique_code: "BOGO35", discount: 35, merchant_id: @merchant1.id, discount_type: "percent" )


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

  describe "Merchant Coupon Create" do
    it "has link to create new coupon" do
      visit merchant_coupons_path(@merchant1)

      expect(page).to have_link("Create New Coupon")
      click_link("Create New Coupon")
      expect(current_path).to eq(new_merchant_coupon_path(@merchant1))

      fill_in "Name", with: "July 4th Sale"
      fill_in "Discount Code", with: "July50"
      fill_in "Discount Amount", with: 50
      select("dollar", from: "Discount Type")
      click_button "Submit"

      expect(current_path).to eq(merchant_coupons_path(@merchant1))
save_and_open_page
      within("#coupons") do
        expect(page).to have_content("July 4th Sale:")
        expect(page).to have_content("$50 Off")
      end
    end
  end
end