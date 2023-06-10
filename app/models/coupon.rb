class Coupon < ApplicationRecord
  validates_presence_of :name,
                        :unique_code,
                        :discount

  belongs_to :merchant
  has_many :invoices
  enum status: {inactive: 0, active: 1}

def coupon_use_count
invoices.joins(:transactions)
        .where(transactions: {result: 'success'})
        .count
end  
end