class Discount < ActiveRecord::Base
  has_many :pricing
  has_many :discount_tables, :order => "qty ASC"
  
  def get_discount(qty)
    discount_tables.each do |dt|
      return dt.discount_applied if qty <= dt.qty 
    end
    return discount_tables.last.discount_applied
  end
end

