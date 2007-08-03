package com.rh.xchain.control
{
    import com.adobe.cairngorm.control.FrontController;
    import com.rh.xchain.commands.LoginCommand; 
    
    public class LoginControl extends FrontController
    {
        public function LoginControl()
        {
            addCommand( LoginControl.EVENT_LOGIN, LoginCommand );
        }
        
        public static const EVENT_LOGIN : String = "login";
    }
}