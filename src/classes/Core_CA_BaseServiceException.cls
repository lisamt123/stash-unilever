/*
  Class Name: Core_CA_BaseServiceException
  Author : Mindtree
  Date: 1 June 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Custom exception class used for both Chatter Approval and Ideation App
*/
global class Core_CA_BaseServiceException extends Exception{
    /* 
    Custom Settings that has the details of The admin queue id and how many days once we can delete the bug tracking records
    The usersid's who receive the email are configured in the queue
    */ 
  //  public static BugTracking_Configuration__c objBugTracking_Config = BugTracking_Configuration__c.getInstance('BugTrackingConfig');
    
    
    public static void resolveExceptions(Exception exceptionObj ){
        system.debug(LoggingLevel.ERROR,'Message: ' + exceptionObj.getMessage());
        system.debug(LoggingLevel.ERROR,'Cause: ' + exceptionObj.getCause());
        system.debug(LoggingLevel.ERROR,'Line number: ' + exceptionObj.getLineNumber());
        system.debug(LoggingLevel.ERROR,'Stack trace: ' + exceptionObj.getStackTraceString());
       // processAfterExceptionOccurence(exceptionObj.getMessage(),exceptionObj,null);
        
    }
    public static void resolveExceptions(String message,Exception exceptionObj ){
        
        system.debug(LoggingLevel.ERROR,'Message: ' + message);
        system.debug(LoggingLevel.ERROR,'Cause: ' + exceptionObj.getCause());
        system.debug(LoggingLevel.ERROR,'Line number: ' + exceptionObj.getLineNumber());
        system.debug(LoggingLevel.ERROR,'Stack trace: ' + exceptionObj.getStackTraceString());
       // processAfterExceptionOccurence(message,exceptionObj,null);
        
    }
    public static void resolveExceptions(String message,Exception exceptionObj, String request){
        
        system.debug(LoggingLevel.ERROR,'Message: ' + message);
        system.debug(LoggingLevel.ERROR,'Cause: ' + exceptionObj.getCause());
        system.debug(LoggingLevel.ERROR,'Line number: ' + exceptionObj.getLineNumber());
        system.debug(LoggingLevel.ERROR,'Stack trace: ' + exceptionObj.getStackTraceString());  
      //  processAfterExceptionOccurence(message,exceptionObj,request);     
        
    }
    /* 
        The actions to be taken once an exption happened are being handled below
            1.) An entry about the exception and its detail are logged into Bug_Tracking__c object
            2.) A workflow rule is triggred once an entry is made into Bug_Tracking__c object and it sends out emails
                to the users configured in 'ErrorSupportQueue'
    */
  //  public static void processAfterExceptionOccurence(String message,Exception exceptionObj, String request){
        /*
            Exception details cannot be serialized and deserialized, so populating in a wrapper class 
        */
    //    ExceptionWrapper exceptionWrapperObj = populateExceptionWrapper(exceptionObj);
        /*
            If the current request from the client is not a future call, the post actions of exception handling can be ASYNC in nature
        */
    //    if(isFutureCallAllowed()){
            /*
                @future method cannot take parameters other than  primitive data types, arrays of primitive data types, 
                or collections of primitive data types. 
                Methods with the future annotation cannot take sObjects or objects as arguments.
                so the exception wrapper is being serialized and deserialized 
            */
    /*        list<string> lstExceptionObj = new list<string>();
            lstExceptionObj.add(JSON.serialize(exceptionWrapperObj));
            createBugTrackingFuture(message,lstExceptionObj,request);
        }
        else{
            createBugTracking(message,exceptionWrapperObj,request);
        }
    
    }*/
    
  /*  private static void createBugTracking(String message,ExceptionWrapper exceptionObj, String request)
    {       
        insertBugTrackingObject(message,exceptionObj,request);
    }
    @future
    private static void createBugTrackingFuture(String message,list<string> lstExceptionObj, String request)
    {
        ExceptionWrapper exceptionObj = null;
        for (String strExceptionObj : lstExceptionObj)
        {
            exceptionObj = (ExceptionWrapper) JSON.deserialize(strExceptionObj, ExceptionWrapper.class);            
        }
        
        insertBugTrackingObject(message,exceptionObj,request);
    }
   */ 
  /*  private static void insertBugTrackingObject(String message,ExceptionWrapper exceptionObj, String request){
        system.debug(LoggingLevel.DEBUG,'Inside exception class = '+message+' fffff '+exceptionObj+' ttttt '+request);
        String[] strClassName;
        Bug_Tracking__c objBug  = new Bug_Tracking__c();        
        // Insert Exception in the System 
        if(message == null || message == '' && exceptionObj.excMessage != null)
        message = exceptionObj.excMessage;  
        
        system.debug(LoggingLevel.INFO,'Inside BaseServiceException: insertBugTrackingObject : objBugTracking_Config = '+exceptionObj);
        objBug.OwnerId          = objBugTracking_Config.Admin_Queue_Id__c;
        objBug.Error__c         = message;
        
        if(exceptionObj != null && exceptionObj.excStackTrace != null){
            objBug.Error_Description__c = exceptionObj.excCause+'  '+exceptionObj.excTypeName+'  '+exceptionObj.excMessage+'  '+exceptionObj.excStackTrace;
        }
        
        objBug.Severity__c = 'Major';       
        
        if(request != null){
            objBug.Request__c = request;
        }       
        
        DatabaseServiceUtil.upsertOperation(objBug);  
    }
    */
    /*
        If the current request from the client is not a future call, the post actions of exception handling can be ASYNC in nature
    */
  /*  private static boolean isFutureCallAllowed(){   
        system.debug(LoggingLevel.INFO,'Inside BaseServiceException: isFutureCallAllowed: is future value = '+(System.isFuture())); 
        return !(System.isFuture());
    }
    private static ExceptionWrapper populateExceptionWrapper(Exception exceptionObj){
        ExceptionWrapper excWrapperObj = new ExceptionWrapper();
        excWrapperObj.excMessage = exceptionObj.getMessage();
        excWrapperObj.excCause = String.valueOf(exceptionObj.getCause());
        excWrapperObj.excLineNumber = String.valueOf(exceptionObj.getLineNumber());
        excWrapperObj.excStackTrace = String.valueOf(exceptionObj.getStackTraceString());
        excWrapperObj.excTypeName = String.valueOf(exceptionObj.getTypeName());
        return excWrapperObj;
        
    
    }
    */
    /*
        Wrapper class created so that the exception details can be populated into it
    */
  /*  public class ExceptionWrapper{
        public String excMessage;
        public String excCause;
        public String excLineNumber;
        public String excStackTrace;    
        public String excTypeName;
    }
*/
}