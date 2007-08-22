class Agent < Customer
  #todo rename this to something a lot more meaningful 
  # agent has many customers through ... retailers ? 
  has_many :representations2 , :class_name => 'Representation'
  has_many :customers, :through => :representations2

end
