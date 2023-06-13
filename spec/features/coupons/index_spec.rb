require 'rails_helper'

RSpec.describe "Merchant Coupons Index" do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Casio Care")


    @coupon1 = Coupon.create!(name: "Summer BOGO", unique_code: "BOGO50", discount: 50, merchant_id: @merchant1.id, discount_type: "percent", status: 1 )
    @coupon2 = Coupon.create!(name: "Everthing Must Go", unique_code: "BOGO35", discount: 35, merchant_id: @merchant1.id, discount_type: "percent", status: 0 )
    @coupon3 = Coupon.create!(name: "July4th", unique_code: "4SALE", discount: 15, merchant_id: @merchant1.id, discount_type: "dollar", status: 1 )
    @coupon4 = Coupon.create!(name: "Winter Sale", unique_code: "WINTER35", discount: 35, merchant_id: @merchant1.id, discount_type: "dollar", status: 1 )
    @coupon5 = Coupon.create!(name: "Fall Sale", unique_code: "FALL10", discount: 10, merchant_id: @merchant1.id, discount_type: "percent", status: 0 )
    @coupon6 = Coupon.create!(name: "XMAS Sale", unique_code: "XMAS35", discount: 25, merchant_id: @merchant1.id, discount_type: "percent", status: 0 )


    @coupon_m2_1 = Coupon.create!(name: "Winter Sale", unique_code: "BOGO25", discount: 25, merchant_id: @merchant2.id, discount_type: "dollar" )

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

      within("#coupons") do
        expect(page).to have_content("July 4th Sale:")
        expect(page).to have_content("$50 Off")
      end
    end

    it "flash error message appears if coupon code is not unique" do
      visit merchant_coupons_path(@merchant1)

      click_link("Create New Coupon")

      fill_in "Name", with: "July 4th Sale"
      fill_in "Discount Code", with: "BOGO50"
      fill_in "Discount Amount", with: 50
      select("dollar", from: "Discount Type")
      click_button "Submit"

      expect(current_path).to eq(new_merchant_coupon_path(@merchant1))
      expect(page).to have_content("Coupon Code Not Unique")  
    end

    it "flash error message appears if merchant has 5 active coupons" do
        @coupon7 = Coupon.create!(name: "XMAS 25", unique_code: "XMAS25", discount: 25, merchant_id: @merchant1.id, discount_type: "percent", status: 1 )
        @coupon8 = Coupon.create!(name: "XMAS 15", unique_code: "XMAS15", discount: 25, merchant_id: @merchant1.id, discount_type: "percent", status: 1 )


      visit merchant_coupons_path(@merchant1)

      click_link("Create New Coupon")

      fill_in "Name", with: "July Sale"
      fill_in "Discount Code", with: "July5"
      fill_in "Discount Amount", with: 5
      select("percent", from: "Discount Type")
      click_button "Submit"

      expect(current_path).to eq(new_merchant_coupon_path(@merchant1))
      expect(page).to have_content("Merchant has 5 Active Coupons")  
    end
  end

  describe "Merchant Coupon Index Sorted" do
    it "active coupons section" do
      visit merchant_coupons_path(@merchant1)

      within("#active_coupons") do
        expect(page).to have_content(@coupon1.name)
        expect(page).to have_content(@coupon3.name)
        expect(page).to have_content(@coupon4.name)
      end
    end

    it "inactive coupons section" do
      visit merchant_coupons_path(@merchant1)

      within("#inactive_coupons") do
        expect(page).to have_content(@coupon2.name)
        expect(page).to have_content(@coupon5.name)
        expect(page).to have_content(@coupon6.name)
      end
    end
  end
end