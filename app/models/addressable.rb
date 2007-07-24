class Addressable < ActiveRecord::Base
  belongs_to :customer
  belongs_to :address
end
