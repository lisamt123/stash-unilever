/**
* @author Cognizant Technology Solutuions
* @date 24/4/2015
* @group IPM Exception Log
* @description Exception Logging utility for IPM application
*/

global with sharing class AF_ExceptionLoggingHelper {
    
    
    public static final String EXCEPTION_LOGGER_DEFAULT_APP_NAME = 'IPM-NG';
    
     /*******************************************************************************************************
    * @description list collection type to store the exception records to be inserted at once.    
    */ 
    
    public static List<Exception_Log__c> exceptionlogList {get;set;}
    
    
    /*******************************************************************************************************
    * @description Creates the exception records based on future Invocations.
    * @param running user info 
    * @param Exception Initiating Class Name 
    * @param Exception Initiating Method Name 
    * @param Exception Class attributes
    * @return 
    */    

    @future
    public static void insertLogRecord(String runninguserId, String className,String methodName,String exMsg, String typeName, String stackTrace,String applicationName)
    {
        exceptionlogList = new List<Exception_Log__c>();                
        exceptionlogList.add(createObjectData(runninguserId,className,methodName,exMsg,typeName,stackTrace,applicationName)); 
        
        if(!exceptionlogList.isEmpty()){
            insert exceptionlogList;
        }    
    }
    
    public static void createApplicationLevelErrorLog(String applicationName,String runninguserId, String className,String methodName,String exMsg, String typeName, String stackTrace)
    {
        processExceptionLog(runninguserId,className,methodName,exMsg,typeName,stackTrace,applicationName);          
    }
    
     /*******************************************************************************************************
    * @description Creates the exception records based on certain considerations.
    * @param running user info 
    * @param Exception Initiating Class Name 
    * @param Exception Initiating Method Name 
    * @param Exception Class attributes
    * @return 
    */     
    public static void createErrorLog(String runninguserId, String className,String methodName,String exMsg, String typeName, String stackTrace){
        
      processExceptionLog(runninguserId,className,methodName,exMsg,typeName,stackTrace,null);       
    }
    
    private static void processExceptionLog(String runninguserId, String className,String methodName,String exMsg, String typeName, String stackTrace, String applicationName)
    {
        String appName = applicationName;
        if(appName == null){
            appName = EXCEPTION_LOGGER_DEFAULT_APP_NAME;
        }
        
        if(Limits.getDMLStatements() >= Limits.getLimitDMLStatements())
        {
            System.debug('*********No Of DML Statement Limit Reached.********');        
        }      
        else if(System.isFuture() && Limits.getFutureCalls() >= Limits.getLimitFutureCalls()) 
        {   
            try
            {
                exceptionlogList = new List<Exception_Log__c>();                
                exceptionlogList.add(createObjectData(runninguserId,className,methodName,exMsg,typeName,stackTrace,appName)); 
                insert exceptionlogList;
            }
            catch(exception ex)
            {
                System.debug('*********Exception in Logger Class ********'+ex.getMessage());
            }          
                                  
        }
        else
        {
            if(!Test.isRunningTest())
            {
                insertLogRecord(runninguserId,className,methodName,exMsg,typeName,stackTrace,appName);           
            }
        } 
    }
    
    public static Exception_Log__c createObjectData(String runninguserId, String className,String methodName,String exMsg, String typeName, String stackTrace,String applicationName)
    {
        Exception_Log__c exceptionLog = new Exception_Log__c();
        exceptionLog.Running_User__c = runninguserId;
        exceptionLog.Class_Name__c = className;
        exceptionLog.Method_Name__c = methodName;
        exceptionLog.Exception_Message__c = exMsg;            
        exceptionLog.Exception_Type__c= typeName;
        exceptionLog.StackTrace_Message__c = stackTrace;
        exceptionLog.Application_Name__c = applicationName;
        return exceptionLog;
    }   
            
}