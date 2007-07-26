package com.xchain.events
{
	import flash.events.Event;

	public class CustomerPickedEvent extends Event
	{
		public static const CUSTOMER_PICKED:String = "CustomerPicked";
		public var customerID:Number; 
		public function CustomerPickedEvent(customerID:Number)
		{
			super(CUSTOMER_PICKED); 
			this.customerID = customerID; 
		}
	}
}