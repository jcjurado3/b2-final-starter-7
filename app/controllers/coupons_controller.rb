class CouponsController < ApplicationController
  before_action :find_merchant, only: [:new, :create, :index]

def index
  @coupons = @merchant.coupons
end 

private


def find_merchant
  @merchant = Merchant.find(params[:merchant_id])
end

end