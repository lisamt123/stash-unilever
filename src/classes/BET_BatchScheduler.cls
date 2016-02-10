/**********************************************************************
Name: BET_BatchScheduler
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Schedulable Class for schedule two batchjobs to send info mail about First_release_date__c and Final_release_date__c to owners
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             08/12/2014      INITIAL DEVELOPMENT
1.1     Blessy Voola            17 Mar 2015    T0- code changes to send reminder mail only once i.e., 
                                                30 days before first and final release due date.    
**********************************************************************/
/* class without sharing modifier due to this is a batch scheduler */
global class BET_BatchScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc) {
    	  String firstquery='SELECT Id, Name, Status__c, Launch_Date__c, First_Release_Due_Date__c, Owner.Name, Owner.Id, Owner.Email FROM uw_BET__c WHERE (IPM_Project__c <> null OR (Inoplan_Project__c <> null and Inoplan_Project__r.name != \'No Inoplan Project\')) and First_Release_Due_Date__c=:due';
     	  BET_ReleaseDateEmails batchFirst = new BET_ReleaseDateEmails(firstquery,true);
     	  database.executebatch(batchFirst, 5); 
       	
       	String finalquery='SELECT Id, Name, Status__c, Launch_Date__c, Final_Release_Due_Date__c, Owner.Name, Owner.Id, Owner.Email FROM uw_BET__c WHERE (IPM_Project__c <> null OR (Inoplan_Project__c <> null and Inoplan_Project__r.name != \'No Inoplan Project\')) and Final_Release_Due_Date__c=:due';
      	BET_ReleaseDateEmails batchFinal= new BET_ReleaseDateEmails(finalquery,false);
       	database.executebatch(batchFinal, 5); 
    }
}