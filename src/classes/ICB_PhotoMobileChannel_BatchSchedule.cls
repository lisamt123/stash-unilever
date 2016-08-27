/**********************************************************************
Name: ICB_PhotoMobileChannel_BatchSchedule
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
This class scheduler the daily add photo in user.
/************ Code to schedule ***************
ICB_PhotoMobileChannel_BatchSchedule sch = new ICB_PhotoMobileChannel_BatchSchedule();
String cron = '0 0 * * * ?';
system.schedule('Setup Photo', cron, sch);
********************************************************
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
1.1    Antonio Raul 25/08/2016  Class updated 
1.0    Thiago Oliveira 24/08/2016  Class creation  
***********************************************************************/
global class ICB_PhotoMobileChannel_BatchSchedule implements Schedulable
{
     /*******************************************************************
     Purpose: This method execute the batch
     Parameters: [SchedulableContext]
     Returns: [VOID]
     Throws [Exceptions]: [NONE]
     ********************************************************************/
    global void execute(SchedulableContext sc)
    {
        Database.executeBatch(new ICB_PhotoMobileChannel_Batch());
    }
}