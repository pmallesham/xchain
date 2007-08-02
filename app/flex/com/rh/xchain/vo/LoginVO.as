// ActionScript file
package com.rh.xchain.vo
{
	import com.adobe.cairngorm.vo.ValueObject;
    
	[Bindable]
    public class LoginVO implements ValueObject
    {
        public var username : String;
        public var password : String;
        public var loginDate : Date;
    }
    
}
