/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BonusQuaterEmailToCatfinance_Schedule
@CreateDate : 21/6/2014
@Description : This is a class is used to schedule the AF_BonusQuaterlyEmailToCatFinance batch class
@               
@Version : 1.0
@reference : none
***********************************************************************************/
global with sharing class AF_BonusQuaterEmailToCatfinance_Schedule implements Schedulable
{
    /*****************************************************************************************************************************
@Author :Cognizant
@name : execute
@CreateDate : 21/6/2014
@Description : This is method is used to call the AF_BonusQuaterlyEmailToCatFinance batch class
@               
@Version : 1.0
@reference : none
***********************************************************************************/
    global void execute(SchedulableContext ctx) 
    {  
        AF_BonusQuaterlyEmailToCatFinance  EmailtoCatFinance= new AF_BonusQuaterlyEmailToCatFinance();
        database.executeBatch(EmailtoCatFinance);
    }
}