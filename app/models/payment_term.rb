class PaymentTerm < ActiveRecord::Base
  has_many :orders
  has_many :customers
end
