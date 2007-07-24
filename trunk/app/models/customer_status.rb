class CustomerStatus < ActiveRecord::Base
  has_many :customers
end
