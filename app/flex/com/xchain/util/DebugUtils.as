// ActionScript file
package com.b2brailed.util {
    import com.b2brailed.util.DebugMessage;
    import com.b2brailed.components.DebugPanel;
    import mx.core.Application;

    public class DebugUtils {
        public static function debug(str:String):void {
            var debugPanel:DebugPanel = Application.application.getChildByName("debugPanel");
            if (debugPanel != null) {
                debugPanel.addMessage(new DebugMessage(str));
            }
        }

        public static function debugToString(obj:Object):Object {
            DebugUtils.debug(obj.toString());
            return obj;
        }
    }
}