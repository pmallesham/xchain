package com.rh.xchain.control
{
    import com.adobe.cairngorm.control.FrontController;
    import com.rh.xchain.commands.LoginCommand; 
    import com.rh.xchain.control.*; 
        
    public class LoginControl extends FrontController
    {

        public static const EVENT_LOGIN:String = "login";
        
        public function LoginControl():void
        {
            trace('addcommand'); 
            addCommand( LoginControl.EVENT_LOGIN, LoginCommand );
        }
       
    }
}