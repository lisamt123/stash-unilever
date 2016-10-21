/****
*Class       -----     ErrorLogHandler
*Description -----     This class will hold the utility functions that will be reusable in any
*                      application across salesforce
***/
public class FA_ErrorLogHandler{
    // declare the variables
   static List<FA_ErrorLog__c> lstErrorLog = new List<FA_ErrorLog__c>();
   static FA_ErrorLog__c objErrorLog;
    
    /*
    * method name - errorMethod
    * arguments   - String objectName, String className, String methodName, String sSeverity, String sErrorMsg
    * return type - void
    * description - This is the generic method that can create ERROR records in the Error Log
    *               when an error has occurred while making any DML operation.
    */
    public static void errorMethodVoid(String objectName, String className, String methodName, String sSeverity, String sErrorMsg){
        // clear the list
        lstErrorLog.clear();
        // ++ if the issue is of type Error
        if(null != sErrorMsg && sErrorMsg != ''){
            objErrorLog = new FA_ErrorLog__c();
            // map the values to the field and put that in the list that will be inserted later
            objErrorLog.FA_Object_Name__c = objectName;
            objErrorLog.FA_Apex_Class_Trigger__c = className;
            objErrorLog.FA_Method_Name__c = methodName;
            objErrorLog.FA_Description__c = sErrorMsg.length()>32768 ? sErrorMsg.substring(4,32768): sErrorMsg;
            objErrorLog.FA_Severity__c = sSeverity;
            objErrorLog.FA_type__c = 'Error';
            lstErrorLog.add(objErrorLog);
                
        }
        // check if the size of lstErrorLog is greater than zero. This will happen
        // if a record has failed while causing the DML operation.
        if(null != lstErrorLog && lstErrorLog.size()>0){
            insert lstErrorLog;
        }
    }
    
    /*
    * method name - errorMethod
    * arguments   - String objectName, String className, String methodName, String sSeverity, Exception e
    * return type - String sMessage
    * description - This is the generic method that can create EXCEPTION records in the Error Log
    *               when an esxception has occurred while making any operation.
    */    
    public static String errorMethod(String objectName, String className, String methodName, String sSeverity, Exception ex){
        //Map<String, Error_Messages_Setting__c> errorMessageSettings = Error_Messages_Setting__c.getAll();
        // clear the list
        lstErrorLog.clear();
        // get the message for the occured Exception
        String sMessage = 'Some error has occured.So unable to process the request.Contact the System Admin';
        // ++ if the issue is of type Exception
        if(null != ex){
            objErrorLog = new FA_ErrorLog__c();
            // map the values to the field and put that in the list that will be inserted later
            objErrorLog.FA_Object_Name__c = objectName;
            objErrorLog.FA_Apex_Class_Trigger__c = className;
            objErrorLog.FA_Method_Name__c = methodName;
            objErrorLog.FA_Description__c = String.valueOf(ex);
            objErrorLog.FA_Severity__c = sSeverity;
            objErrorLog.FA_type__c = 'Exception';
            lstErrorLog.add(objErrorLog);
        }
        // check if the size of lstErrorLog is greater than zero. This will happen
        // if a record has failed while causing the DML operation.
        if(null != lstErrorLog && lstErrorLog.size()>0){
            insert lstErrorLog;
        }
        if(Test.isRunningTest())
            return  ex.getMessage();
        else
           return sMessage;
    }
    

          /* Custom Exception class which is used to throw exception in a test method*/
   
          public class MyException extends Exception {} 
              
   
        /** The method 'errorMethod' - This is the testmethod for error log which can create EXCEPTION records in the Error Log
         ** when an exception has occurred while making any operation.
         **/
          
          
         static testMethod void errorMethod(){              
              
              errorMethodVoid('testobject', 'testclass', 'testmethod','fatal','unable to process the request');
              try{
              throw new MyException();
              }
              catch(MyException e){
              String result = FA_ErrorLogHandler.errorMethod('testobject', 'testclass', 'testmethod','fatal', e);
              } 
         }     
      

       
      
}