// ActionScript file
package com.xchain.events {
    import flash.events.Event;
    
    /**
     * This custom Event class adds an XML user property to a basic Event.
     */
    public class LoginEvent extends Event {
        /**
         * The name of the new LoginEvent type.
         */
        public static const LOGIN:String = "login";
    
        /**
         * The user who logged in.
         */
        public var user:XML;
    
        /**
         * Constructor.
         * @param user the XML of the user who logged in
         */
        public function LoginEvent(user:XML) {
            super(LOGIN);
            this.user = user;
        }
    }
}