// ActionScript file
package com.rh.xchain.model
{
    import com.rh.xchain.vo.LoginVO;
    
    public class Login
    {
        [Bindable]
        public var loginVO : LoginVO;
        [Bindable]
        public var loginDate : Date;
        [Bindable]
        public var statusMessage : String;
        [Bindable]
        public var isPending : Boolean;
    }
}