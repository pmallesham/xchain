class OrderStatusHistory < ActiveRecord::Base
  belongs_to :order
  belongs_to :order_status
end
