class Shipment
  
  def get_shipping_amount(opts = {})
    #:weight => self.shipping_weight
    #:dest_city => self.shipping_city
    #:dest_postal_code => self.shipping_post_code_at_order
    #:dest_country => self.shipping_country.code
    return 12.00  
  end
end
