/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_SendEmailToCatFinance
   @CreateDate : 23/8/2014
   @Description : This is a batch class
   @			  this is used to send email to category finance users.
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
global with sharing class af_SendCurrencyReminder implements Schedulable
{
	/***********************************************************************************
*  @Description: this is the execute method of the Batch class
*  @name : execute
*  @param : ctx
*  @return: none.
*************************************************************************************/
	global void execute(SchedulableContext ctx) 
	{  
		//Boolean IsthisCalledfromTest;
		String DayofMonth;
		if(!Test.isRunningtest())
		{
			DayofMonth=string.valueOf(system.now().day());
		}
		else
		{
			DayofMonth='01';
		}
		if(DayofMonth=='01')
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