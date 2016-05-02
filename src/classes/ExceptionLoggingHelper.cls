/**
* @author Cognizant Technology Solutuions
* @date 24/4/2015
* @group IPM Exception Log
* @description Exception Logging utility for IPM application
*/

global without sharing class ExceptionLoggingHelper {      
    
    
    public static final String EXCEPTION_LOGGER_DEFAULT_APP_NAME = 'IPM-NG';
    private static final string INSERT_OPERATION = 'insert';
    private static final string UPDATE_OPERATION = 'update';
    private static final string DELETE_OPERATION = 'delete';
    private static final string UNDELETE_OPERATION = 'undelete';
     
    /*******************************************************************************************************
    * @description list collection type to store the exception records to be inserted at once.    
    */ 
    private static List<Exception_Log__c> exceptionlogList {get;set;}
    private static string sObjectName{get;set;}
    private static string operationType{get;set;}
    
    public static void initializeExceptionLog()
    {
        if(Trigger.isExecuting && Trigger.isBefore && sObjectName == null && operationType == null)
        {
            sObjectName = getSObjectName(Trigger.new,Trigger.old);
            operationType = getSObjectOperationType();
        }
    }
    
    private static String getSObjectName(List<sObject> newTrigger,List<sObject> oldTrigger)
    {
        sObject exceptionSObject = null;
        
        /* Get Object Type information */
        if(newTrigger !=null && !newTrigger.isEmpty())
        {
            exceptionSObject = newTrigger[0];
        }
        else if(oldTrigger!=null)
        {
            exceptionSObject = oldTrigger[0]; 
        }
        
        if(exceptionSObject !=null)
        {
            SObjectType sObjectToken = exceptionSObject.getsObjectType();
            Schema.DescribeSObjectResult sObjectDescibe = sObjectToken.getDescribe();
            String objectName = sObjectDescibe.getName();
            return objectName;
        }
        return null;
    }
    
    private static String getSObjectOperationType()
    {
        /* Get Operation Type information */
        if(Trigger.isInsert)
        {
            return INSERT_OPERATION;
        }
        else if(Trigger.isUpdate)
        {
            return UPDATE_OPERATION;
        }
        else if(Trigger.isDelete)
        {
            return DELETE_OPERATION;
        }
        else if(Trigger.isUndelete)
        {
            return UNDELETE_OPERATION;
        }
        return null;
    }
     
    public static void createErrorLog(String runninguserId, String className,String methodName,String exMsg, Exception exceptionOccured, 
                                            String debugLevel, String integrationPayload, String referenceInfo, Integer timer, String applicationName){
        
        processExceptionLog(runninguserId,className,methodName,exMsg,exceptionOccured,debugLevel,integrationPayload,referenceInfo,timer,applicationName);       
    }
    
    private static void processExceptionLog(String runninguserId, String className,String methodName,String exMsg, Exception exceptionOccured, 
                                            String debugLevel, String integrationPayload,String referenceInfo, Integer timer, String applicationName)
    {
        String referenceId = null;
        String logCode = null;
        
        if(applicationName == null)
        {
            applicationName = EXCEPTION_LOGGER_DEFAULT_APP_NAME;
        }
        
        if(exceptionlogList == null)
        {
            exceptionlogList = new List<Exception_Log__c>();
        }                
        
        if(exceptionOccured != null && exceptionOccured.getTypeName() == 'System.DmlException'){
            referenceId = exceptionOccured.getDmlId(0);
            logCode = string.valueOf(exceptionOccured.getDmlType(0));
        }
        
        //skip log insertion if exception occured in constructor, as @future and DML operations are not allowed in constructor. 
        if(exceptionOccured != null && className != methodName)
            exceptionlogList.add(createObjectData(runninguserId,className,methodName,exMsg,exceptionOccured.getTypeName(),exceptionOccured.getStackTraceString(),logCode,debugLevel,integrationPayload,referenceId,referenceInfo,timer,applicationName));
                
        if(Limits.getLimitDMLStatements() < 1)
        {
            System.debug('*********No Of DML Statement Limit Reached.********');        
        }      
        else
        {   
            if(!System.Test.isRunningTest())
            {
                try
                { 
                    if(!Trigger.isExecuting)
                    {
                        // In case it is not invoked from trigger, make asyncronous call and create Exception Record.
                        if(!System.isFuture() && !System.isBatch() && Limits.getFutureCalls() < 1)
                        {
                            //skip log insertion if exception occured in constructor, as @future and DML operations are not allowed in constructor. 
                            if(className != methodName){
                                insertExceptionInFuture(runninguserId,className,methodName,exMsg,exceptionOccured.getTypeName(),exceptionOccured.getStackTraceString(),logCode,debugLevel,integrationPayload,referenceId,referenceInfo,timer,applicationName);
                            }
                        }
                        else{
                            //skip log insertion if exception occured in constructor, as DML operations are not allowed in constructor. 
                            if(className != methodName){
                                List<Exception_Log__c> exceptionList = new List<Exception_Log__c>{ createObjectData(runninguserId,className,methodName,exMsg,exceptionOccured.getTypeName(),exceptionOccured.getStackTraceString(),logCode,debugLevel,integrationPayload,referenceId,referenceInfo,timer,applicationName)};
                                insert exceptionList;
                            }                   
                        }
                    }
                }
                catch(exception ex)
                {
                    System.debug('*********Exception in Logger Class ********'+ex.getMessage());
                    insert exceptionlogList;
                }  
            }
        }
    }
    
    @future
    public static void insertExceptionInFuture(String runninguserId, String className,String methodName,String exMsg, String execptionType, String stackTrace, String logCode,  
                                            String debugLevel, String integrationPayload, String referenceId, String referenceInfo, Integer timer, String applicationName)
    {
        List<Exception_Log__c> exceptionList = new List<Exception_Log__c>{ createObjectData(runninguserId,className,methodName,exMsg,execptionType,stackTrace,logCode,debugLevel,integrationPayload,referenceId,referenceInfo,timer,applicationName)};
        insert exceptionList;
    }
    
    private static Exception_Log__c createObjectData(String runninguserId, String className,String methodName,String exMsg, String exceptionType, String stackTrace, String logCode, 
                                            String debugLevel, String integrationPayload, String referenceId, String referenceInfo, Integer timer, String applicationName)
    {
        Exception_Log__c exceptionLog = new Exception_Log__c();
        exceptionLog.Running_User__c = runninguserId;
        exceptionLog.Class_Name__c = className;
        exceptionLog.Method_Name__c = methodName;
        exceptionLog.Exception_Message__c = exMsg;            
        exceptionLog.Exception_Type__c= exceptionType;
        exceptionLog.StackTrace_Message__c = stackTrace;
        exceptionLog.LogCode__c = logCode;
        exceptionLog.DebugLevel__c = debugLevel;
        exceptionLog.IntegrationPayload__c = integrationPayload;
        exceptionLog.ReferenceId__c = referenceId;
        exceptionLog.ReferenceInfo__c = referenceInfo;
        exceptionLog.Timer__c = timer;
        exceptionLog.Application_Name__c = applicationName;
        return exceptionLog;
    }
    
    //method to insert all exceptions at once
    public static void insertLogRecordList()
    {
        if(Trigger.isExecuting && Trigger.isAfter)
        {
            String incomingSObjectName = getSObjectName(Trigger.new,Trigger.Old);
            String incomingOperationType = getSObjectOperationType();
            
            if(sObjectName!=null && operationType!=null && 
                sObjectName == incomingSObjectName && operationType == incomingOperationType)   
            {
                if(exceptionlogList != null && !exceptionlogList.isEmpty())
                {
                    insert exceptionlogList;
                    exceptionlogList = null;
                    sObjectName = null;
                    operationType = null;
                }
            }
        }
    }
}