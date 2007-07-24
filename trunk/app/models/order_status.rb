class OrderStatus < ActiveRecord::Base
  has_many :orders
  attr_accessor :next_statuses
  
  def self.next_status(current_status)
    if current_status.flow_next?
      find(:all, :conditions => "id IN (#{current_status.flow_next})", :order => 'sort_order ASC')
    else
      find(:all,:order => 'sort_order ASC')
    end
  end
  
  def find_next_available_statuses()
    statuses = Array.new
    statuses << self
    statuses << OrderStatus.find(:all, :conditions => ["id IN (?)", flow_next], :order => 'sort_order ASC')
    return statuses
  end
  
end
