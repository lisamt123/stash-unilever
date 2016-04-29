/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BonusQuarterly_Reminder_schedule  
@CreateDate : 21/6/2014
@Description : This is a class is used to schedule the AF_Bonusquarterly_Reminder batch class
@               
@Version : 1.0
@reference : none
***********************************************************************************/
global with sharing class AF_BonusQuarterly_Reminder_schedule  implements Schedulable
{
    /*****************************************************************************************************************************
@Author :Cognizant
@name : execute
@CreateDate : 21/6/2014
@Description : This is method is used to call the AF_Bonusquarterly_Reminder  batch class
@               
@Version : 1.0
@reference : none
***********************************************************************************/
    global void execute(SchedulableContext ctx) 
    {  
        AF_Bonusquarterly_Reminder  Reminder= new AF_Bonusquarterly_Reminder ();
        database.executeBatch(Reminder);
    }
}