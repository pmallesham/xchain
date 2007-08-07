// ActionScript file
package com.rh.xchain.model 
{
	import com.adobe.cairngorm.model.ModelLocator;
	import mx.collections.XMLListCollection;

	[Bindable]
	public class ModelLocator implements com.adobe.cairngorm.model.ModelLocator
	{
		private static var modelLocator : com.rh.xchain.model.ModelLocator;
        
        public static function getInstance() : com.rh.xchain.model.ModelLocator 
        {
            if ( modelLocator == null )
            {
				modelLocator = new com.rh.xchain.model.ModelLocator();            	
            }
			return modelLocator;
		}
       
		public function ModelLocator() 
		{
			if ( com.rh.xchain.model.ModelLocator.modelLocator != null )
			{
                throw new Error( "Only one ModelLocator instance should be instantiated" ); 
   			}   
		}
        
        public var countries:XMLListCollection = new XMLListCollection(); 
        
        public var login : Login = new Login();
        public var securityState : Number;
        public static const LOGGED_OUT : Number = 1;
        public static const LOGGED_IN : Number = 2;
        
        
        public var mainWorkflowState : Number; 
        public static const VIEWING_ORDERS : Number = 1;
        public static const VIEWING_CUSTOMERS : Number = 2;
        public static const VIEWING_INVENTORY : Number = 3;
        public static const VIEWING_REPORTS : Number = 4;
        public static const VIEWING_ADMIN : Number = 5;
        
    }    
}

