class OrderStatus < ActiveRecord::Base
  
  has_many :orders
  attr_accessor :next_statuses
  
  def self.find_all
      find(:all, :order => 'sort_order ASC')
  end
  
  def self.next_status(current_status)
    if current_status.flow_next?
      find(:all, :conditions => "id IN (#{current_status.flow_next})", :order => 'sort_order ASC')
    else
      find(:all,:order => 'sort_order ASC')
    end
  end
  
  def find_next_available_statuses(super_user = false)
    if !super_user 
      statuses = Array.new
      statuses << self
      if flow_next?
        statuses << OrderStatus.find(:all, :conditions => ["id IN (?)", flow_next], :order => 'sort_order ASC')
      else 
        statuses << OrderStatus.find(:first, :conditions => ["sort_order > ?", sort_order ], :order => 'sort_order ASC')
      end
      return statuses
    else 
      return OrderStatus.find_all
    end
  end
  
end
