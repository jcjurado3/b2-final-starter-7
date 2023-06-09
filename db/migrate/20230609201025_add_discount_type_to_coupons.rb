class AddDiscountTypeToCoupons < ActiveRecord::Migration[7.0]
  def change
    add_column :coupons, :discount_type, :string
  end
end
