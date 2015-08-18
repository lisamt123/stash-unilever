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
global class BET_BatchScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc) {
   //--------T0-Begin-------
    datetime d1 = system.today().addDays(30);
    String duedate= d1.format('yyyy-MM-dd');
       //--------T0-End-------
    // BET_ReleaseDateEmails batchFirst = new BET_ReleaseDateEmails('SELECT Id, Name, Status__c, Launch_Date__c, First_release_date__c, Owner.Name, Owner.Id, Owner.Email FROM uw_BET__c WHERE First_release_date__c = NEXT_MONTH AND ( ( CALENDAR_MONTH(First_release_date__c) < 7 AND  DAY_IN_MONTH(First_release_date__c) = 15 ) OR ( CALENDAR_MONTH(First_release_date__c) > 6 AND DAY_IN_MONTH(First_release_date__c) = 30 ))', true);
     String firstquery='SELECT Id, Name, Status__c, Launch_Date__c, FirstReleaseDate__c, Owner.Name, Owner.Id, Owner.Email FROM uw_BET__c WHERE First_release_date__c='+duedate;
     BET_ReleaseDateEmails batchFirst = new BET_ReleaseDateEmails(firstquery,true);
     database.executebatch(batchFirst, 5); 
       // BET_ReleaseDateEmails batchFinal = new BET_ReleaseDateEmails('SELECT Id, Name, Status__c, Launch_Date__c, Final_release_date__c, Owner.Name, Owner.Id, Owner.Email FROM uw_BET__c WHERE Final_release_date__c = NEXT_MONTH AND DAY_IN_MONTH(Final_release_date__c) = 1', false);
       String finalquery='SELECT Id, Name, Status__c, Launch_Date__c, FinalReleaseDate__c, Owner.Name, Owner.Id, Owner.Email FROM uw_BET__c WHERE Final_release_date__c ='+duedate;
       BET_ReleaseDateEmails batchFinal= new BET_ReleaseDateEmails(finalquery,false);
       database.executebatch(batchFinal, 5); 
         
     
    }
}