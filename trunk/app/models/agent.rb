class Agent < Customer
  has_many :customers, :through => :representation
  belongs_to :representation
end
