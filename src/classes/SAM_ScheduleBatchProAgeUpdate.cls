/********************************************************************
 Name:  SAM_ScheduleBatchProAgeUpdate()
 Copyright © 2016  Unilever
 ======================================================
======================================================
Purpose:  Schedular class to schedule the Batch process for Request Ageing calculation                                                     
-------                                                             
======================================================
======================================================
History                                                            
-------                                                             
VERSION  AUTHOR                DATE              DETAIL                 Description
   1.0   Mindtree           19/07/2016        INITIAL DEVELOPMENT           
***********************************************************************/
global with sharing class SAM_ScheduleBatchProAgeUpdate implements Schedulable
{
    global void execute(SchedulableContext sc)
    { 
         SAM_RequestAgeUpdate b = new SAM_RequestAgeUpdate();
         database.executebatch(b,200);
    }
}