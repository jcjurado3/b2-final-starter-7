require "rails_helper"

RSpec.describe "Merchant Coupon Show Page " do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Casio Care")


    @coupon1 = Coupon.create!(name: "Summer BOGO", unique_code: "BOGO50", discount: 50, merchant_id: @merchant1.id, discount_type: "percent", status: 1 )
    @coupon2 = Coupon.create!(name: "Everthing Must Go", unique_code: "TAKE50", discount: 50, merchant_id: @merchant1.id, discount_type: "dollar", status: 0 )


    @coupon_m2_1 = Coupon.create!(name: "Winter Sale", unique_code: "WINTER50", discount: 25, merchant_id: @merchant2.id, discount_type: "dollar" )

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon1.id)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon1.id)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2, coupon_id: @coupon1.id)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2, coupon_id: @coupon2.id)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2, coupon_id: @coupon2.id)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

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
      visit merchant_coupon_path(@merchant1, @coupon1)
      expect(page).to have_content("Coupon Status: active")
      expect(page).to have_content("Times Used: 3")

      visit merchant_coupon_path(@merchant1, @coupon2)

      expect(page).to have_content("Coupon Status: inactive")
      expect(page).to have_content("Times Used: 2")

    end
  end

  describe "Merchant Coupon Deactivate" do
    it "displays button to deactivate coupon" do
    visit merchant_coupon_path(@merchant1, @coupon1)
    coupon = Coupon.find(@coupon1.id)

    expect(page).to have_content("Coupon Status: active")
    expect(page).to have_button("Deactivate")
    expect(page).to_not have_button("Activate")
    click_button "Deactivate"

    expect(page).to have_content("Coupon Status: inactive")
    end

    it "displays button to activate coupon" do
      visit merchant_coupon_path(@merchant1, @coupon2)
  
      expect(page).to have_content("Coupon Status: inactive")
      expect(page).to have_button("Activate")
      click_button "Activate"
  
      expect(page).to have_content("Coupon Status: active")
      end
  end
end