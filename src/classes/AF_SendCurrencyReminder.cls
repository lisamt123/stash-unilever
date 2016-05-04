/*****************************************************************************************************************************
   @Author :Cognizant
   @name : af_SendCurrencyReminder 
   @CreateDate : 23/8/2014
   @Description : This is a batch class
   @              this is used to send email to category finance users.
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
global with sharing class AF_SendCurrencyReminder implements Database.Batchable<sobject>{
 global string emailcat='select AF_CurrencyUpdateRequired__c  from Send_Email__c Limit 1';
 private static string className_STR=AF_SendCurrencyReminder.class.getName();
    /***********************************************************************************
*  @Description: this is the execute method of the Batch class
*  @name : execute
*  @param : ctx
*  @return: none.
*************************************************************************************/
  global Database.QueryLocator start(Database.BatchableContext BC)
  {
  return database.getquerylocator(emailcat);
   }
    global void execute(Database.BatchableContext BC,list<sobject> email) 
    {  
     //Boolean IsthisCalledfromTest;
    String DayofMonth;
    if(!Test.isRunningtest())
    {
      DayofMonth=string.valueOf(system.now().month());
    }
    else
    {
      DayofMonth='1';
    }
    if(DayofMonth=='1')
    {
      Send_Email__c mynewmail = new Send_Email__c();
      mynewmail.AF_CurrencyUpdateRequired__c = true;
      try{
      insert mynewmail;
      }
      catch(Exception e)
        {
            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'execute',e.getMessage(),e.getTypeName(),e.getStackTraceString());
            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Insert)); 
        }
    }
    }
    /***********************************************************************************
*  @Description: this is the finish method of the Batch class
*  @name : finish
*  @param : BC
*  @return: none.
*************************************************************************************/
    global void finish(Database.BatchableContext BC)
    {
        system.debug('Batch class is completed');
    }
}