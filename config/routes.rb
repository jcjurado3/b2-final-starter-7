Rails.application.routes.draw do
  
  get "/", to: "application#welcome"
  
  resources :merchants, only: [:show] do
    resources :dashboard, only: [:index]
    resources :coupons, only: [:index, :show, :new, :create]
    resources :coupon_status, only: [:update]
    resources :items, except: [:destroy]
    resources :item_status, only: [:update]
    resources :invoices, only: [:index, :show, :update]
  end

  namespace :admin do
    resources :dashboard, only: [:index]
    resources :merchants, except: [:destroy]
    resources :merchant_status, only: [:update]
    resources :invoices, except: [:new, :destroy]
  end
end
