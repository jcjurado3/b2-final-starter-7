class CouponsController < ApplicationController
  before_action :find_merchant, only: [:new, :create, :index, :show]

def index
  @active_coupons = @merchant.active_coupons
  @inactive_coupons = @merchant.inactive_coupons
  @holidays = HolidayService.new.holiday_info.first(3)
  @image_juneteenth = ImageSearch.new.image_search("Independence Day").image_small_url

end

def new

end

def create
  @coupon = Coupon.new(new_coupon_params)

  if @merchant.active_coupon_check == true
    flash.notice = "Merchant has 5 Active Coupons"
    redirect_to new_merchant_coupon_path(@merchant)
  elsif @coupon.save
    flash.notice = "Succesfully Created New Coupon"
    redirect_to merchant_coupons_path(@merchant)
  else
    flash.notice = "Coupon Code Not Unique"
    redirect_to new_merchant_coupon_path(@merchant)
  end
end 

def show
  @coupon = Coupon.find(params[:id])
end

private
def find_merchant
  @merchant = Merchant.find(params[:merchant_id])
end

def new_coupon_params
  params.permit(:name, :unique_code, :discount, :discount_type, :merchant_id)
end  

end