/*****************************************************************************************************************************
   @Author :Cognizant
   @name : af_SendCurrencyReminder 
   @CreateDate : 23/8/2014
   @Description : This is a batch class
   @              this is used to send email to category finance users.
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
global with sharing class af_SendCurrencyReminder implements Database.Batchable<sobject>{
 global string emailcat='select AF_CurrencyUpdateRequired__c  from Send_Email__c';
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
      insert mynewmail;
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