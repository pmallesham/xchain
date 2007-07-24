class Agent < ActiveRecord::Base
  has_many :customers, :through => :representation
  belongs_to :representation
end
