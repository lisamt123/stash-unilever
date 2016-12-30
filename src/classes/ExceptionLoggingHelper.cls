/**
* @author Cognizant Technology Solutuions
* @date 24/4/2015
* @group IPM Exception Log
* @description Exception Logging utility for Accenture local use only. 
* 
*/

global without sharing class ExceptionLoggingHelper {      
   
    public static void createErrorLog(String runninguserId, String className,String methodName,String exMsg, Exception exceptionOccured, 
                                            String debugLevel, String integrationPayload, String referenceInfo, Integer timer, String applicationName){
        System.debug('@@@');
        //processExceptionLog(runninguserId,className,methodName,exMsg,exceptionOccured,debugLevel,integrationPayload,referenceInfo,timer,applicationName);       
    }
}