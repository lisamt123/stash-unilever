/********************************************************************
 Name:  CPA_ScheduleBatchProrfAgeUpdate()
 Copyright © 2015  Unilever
 ======================================================
======================================================
Purpose:  Schedular class to schedule the Batch process for Pworf Ageing calculation                                                     
-------                                                             
======================================================
======================================================
History                                                            
-------                                                             
VERSION  AUTHOR                DATE              DETAIL                 Description
   1.0   Jayprakash Bharti     03/04/2015        INITIAL DEVELOPMENT           
***********************************************************************/
global with sharing class CPA_ScheduleBatchProrfAgeUpdate implements Schedulable
{
    global void execute(SchedulableContext sc)
    { 
         CPA_batchProrfAgeUpdate b = new CPA_batchProrfAgeUpdate();
         database.executebatch(b,200);
    }
}