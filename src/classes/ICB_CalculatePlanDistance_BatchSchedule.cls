/**********************************************************************
Name: ICB_CalculatePlanDistance_BatchSchedule
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
This class scheduler the daily execution to calculate 
distance beetween visits(Event).
/************ Code to schedule ***************
ICB_CalculatePlanDistance_BatchSchedule sch = new ICB_CalculatePlanDistance_BatchSchedule();
String cron = '0 0 11 * * ?';
system.schedule('ICB_CalculatePlanDistance_BatchSchedule', cron, sch);
********************************************************
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Carlos Carvalho 12/06/2016  Class creation  
***********************************************************************/
global class ICB_CalculatePlanDistance_BatchSchedule implements Schedulable
{
    
    /*******************************************************************
     Purpose: This method execute the batch
     Parameters: [SchedulableContext]
     Returns: [VOID]
     Throws [Exceptions]: [NONE]
     ********************************************************************/
    global void execute ( SchedulableContext aContext )
    {
        //Execute distance plan calculation
        ICB_CalculatePlanDistaance_Batch batch = new ICB_CalculatePlanDistaance_Batch();
        Database.executeBatch( batch );
    }
}