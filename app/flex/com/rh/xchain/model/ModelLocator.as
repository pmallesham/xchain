// ActionScript file
package com.rh.xchain.model 
{
	import com.adobe.cairngorm.model.ModelLocator;

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
			if ( com.adobe.cairngorm.samples.login.model.ModelLocator.modelLocator != null )
			{
                throw new Error( "Only one ModelLocator instance should be instantiated" ); 
   			}   
		}
        
        public var login : Login = new Login();
        public var mainWorkflowState : Number;
		/*
		mainWorkfowStates
		*/
        public static const VIEWING_LOGIN_SCREEN : Number = 1;
        public static const VIEWING_DASHBOARD : Number = 3;
        public static const VIEWING_ORDERS : Number = 4;
        public static const VIEWING_CUSTOMERS : Number = 5;
        public static const VIEWING_INVENTORY : Number = 6;
        public static const VIEWING_REPORTS : Number = 7;
        public static const VIEWING_ADMIN : Number = 8;
        
    }    
}

