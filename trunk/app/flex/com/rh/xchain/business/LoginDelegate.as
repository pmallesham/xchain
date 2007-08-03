package com.rh.xchain.business
{
    import com.adobe.cairngorm.business.Responder;
    import com.adobe.cairngorm.business.ServiceLocator;
    import com.rh.xchain.vo.LoginVO;
    
    import flash.utils.setTimeout;
    
    import mx.rpc.AsyncToken;
    import mx.rpc.events.ResultEvent;
    
    public class LoginDelegate
    {
        private var responder : Responder;
        private var service : Object;
                
        public function LoginDelegate( responder : Responder )
        {
            //this.service = ServiceLocator.getInstance().getService( "loginService" );
            this.responder = responder;
        }
        
        public function login( loginVO : LoginVO ): void
        {
            //var token : AsyncToken = service.login( loginVO );
            //token.resultHandler = responder.onResult;
            //token.faultHandler = responder.onFault;
            
            //for demo purpose: simulate remote service result
            setTimeout( loginResult, 1000, loginVO );
        }
        
        private function loginResult( loginVO : LoginVO ): void
        {
            if( Math.random() > .5 )
            {
                responder.onResult( loginVO );
            }
            else
            {
                responder.onFault();
            }            
        }    
    }
}

