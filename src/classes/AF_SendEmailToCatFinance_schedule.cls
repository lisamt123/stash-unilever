/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_SendEmailToCatFinance_schedule
@CreateDate : 15/6/2014
@Description : This is a class is used to schedule the  AF_SendEmailToCatFinance batch class
@              
@Version : 1.0
@reference : none
****************************************************************************************************************************/
global with sharing class AF_SendEmailToCatFinance_schedule  implements Schedulable
{
	global void execute(SchedulableContext ctx) 
	{  
		AF_SendEmailToCatFinance catfinance= new AF_SendEmailToCatFinance();
		database.executeBatch(catfinance);
	}
}