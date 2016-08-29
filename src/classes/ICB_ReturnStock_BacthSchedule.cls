/**********************************************************************
Name: ICB_ReturnStock_BacthSchedule
Copyright © 2016 Unilever
======================================================
======================================================
Purpose:
This class scheduler the week execution to return items for inventory
/************ Code to schedule ***************
ICB_ReturnStock_BacthSchedule sch = new ICB_ReturnStock_BacthSchedule();
String cron = '0 00 05 ? * 1';
system.schedule('Return Stock', cron, sch);
********************************************************
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Antonio Raul	12/06/2016  Class creation  
***********************************************************************/
global with sharing class ICB_ReturnStock_BacthSchedule implements Schedulable
{
    
    /*******************************************************************
     Purpose: This method execute the batch
     Parameters: [SchedulableContext]
     Returns: [VOID]
     Throws [Exceptions]: [NONE]
     ********************************************************************/
    global void execute ( SchedulableContext aContext )
    {
        ICB_ReturnStock_Batch batch = new ICB_ReturnStock_Batch();
        Database.executeBatch( batch );
    }
}