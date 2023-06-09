class CouponsController < ApplicationController
  before_action :find_merchant, only: [:new, :create, :index]

def index
  @coupons = @merchant.coupons
end

def new

end

def create
  coupon = Coupon.new(coupon_params)
  if coupon.save
    flash.notice = "Succesfully Created New Coupon"
    redirect_to merchant_coupons_path(@merchant)
  else
    flash.notice = "Merchant has 5 Active Coupons or Coupon Code Not Unique"
    redirect_to new_merchant_coupon_path(@merchant)
  end
end 

private
def find_merchant
  @merchant = Merchant.find(params[:merchant_id])
end

def coupon_params
  params.permit(:name, :unique_code, :discount, :discount_type)
end  

end