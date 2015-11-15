public with sharing class IPM_LogUtils {
    
    /**
     *  Log a message with runtime information
     */ 
    public static void log(String t, System.LoggingLevel level) {
        System.debug(level, ' *** ' + t);
    }
    
}