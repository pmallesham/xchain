require File.dirname(__FILE__) + '/../spec_helper'

describe Agent do
  before(:each) do
    @agent = Agent.find(4)
  end
  
  it "should have agents" do 
  	@agent.should have(1).customers
  end
  	
end
