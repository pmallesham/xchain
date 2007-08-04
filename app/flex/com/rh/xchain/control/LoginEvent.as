package com.rh.xchain.control 
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.rh.xchain.vo.LoginVO; 
    
    /**
     * The Cairngorm event broadcast when the user attempts to log in
     */
    public class LoginEvent extends CairngormEvent 
    {
        /**
         * The login details for the user
         */
        public var loginVO : LoginVO;
                
        /**
         * The constructor, taking a LoginVO
         */
        public function LoginEvent( loginVO : LoginVO ) 
        {
            super( LoginControl.EVENT_LOGIN );
            this.loginVO = loginVO;
            trace('Login event instantiated'); 
        }
    }    
}