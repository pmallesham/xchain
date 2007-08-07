require File.dirname(__FILE__) + '/../test_helper'

class OrderTest < Test::Unit::TestCase
  fixtures :orders, :addresses, :addressables, :customers

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_prefill_address
    @order = Order.find(1)
    @order.prefill_address(Customer.find(:first))
    assert_equal @order.billing_address '103 Dynamite'
    assert_equal @order.billing_city 'Acmetown'
  end
end
