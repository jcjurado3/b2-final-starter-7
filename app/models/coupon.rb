class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :unique_code,
                        :discount,
                        :discount_type
  validates_uniqueness_of :unique_code

  belongs_to :merchant
  has_many :invoices
  enum status: [:inactive, :active]

def coupon_use_count
invoices.joins(:transactions)
        .where(transactions: {result: 'success'})
        .count
end

end