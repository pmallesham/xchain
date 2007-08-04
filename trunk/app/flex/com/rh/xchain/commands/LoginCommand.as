package com.rh.xchain.commands
{
    import mx.rpc.events.ResultEvent;
    import com.adobe.cairngorm.business.Responder;
    import com.adobe.cairngorm.commands.Command;
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.rh.xchain.business.LoginDelegate;
    import com.rh.xchain.control.LoginEvent;
    import com.rh.xchain.model.ModelLocator;
    import com.rh.xchain.vo.LoginVO;
    
    public class LoginCommand implements Command, Responder
    {
        private var model : ModelLocator = ModelLocator.getInstance();
       
        public function execute( event : CairngormEvent ) : void
        {
        	trace('LoginCommand.execute called'); 
            model.login.isPending = true;
            
            var delegate : LoginDelegate = new LoginDelegate( this );   
            var loginEvent : LoginEvent = LoginEvent( event );  
            delegate.login( loginEvent.loginVO );          
        }
           
        public function onResult( event : * = null ) : void
        {            
            model.login.loginDate = new Date();
            model.login.loginVO = LoginVO( event );
            model.login.isPending = false;
            
            model.securityState = ModelLocator.LOGGED_IN
        }
                
        public function onFault( event : * = null ) : void
        {
            model.login.statusMessage = "Your username or password was wrong, please try again.";
            model.login.isPending = false;
        }
    }
}
