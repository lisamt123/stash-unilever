/* This Class implements method for batch CORE_IC_Scheduler_ICampaignStatusUpdate
** Update Status to 'Active' if current date falls between start and end date else to 'Closed'
** Initial Write By : Mindtree for Start date validation. Date: 01-Jun-2015
** Updated By : Mindtree to check for executing trigger only if start date changed. Date: 04-Jun-2015 
** Updated By : Mindtree on 10-June-2015 Change : Updating only field BatchInvoked__c to trigger CORE_IC_UpdateIdeaCampaignFields. The status logic done only in trigger now.
*/
global with sharing class CORE_IC_Batch_ICampaignStatusUpdate implements Database.Batchable<sObject>
{
    global final String query;
    global CORE_IC_Batch_ICampaignStatusUpdate(string q)
    {
       query=q;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,  List<IdeaTheme> ideaThemeList) 
    {  
        system.debug('~~~~1');
        List<IdeaTheme> ideaTheme = new List<IdeaTheme>();
        for (IdeaTheme iTheme: ideaThemeList) {
        iTheme.BatchInvoked__c = 'Y';
           ideaTheme.add(iTheme);
            system.debug('~~~~1'+iTheme);
        }
        system.debug('~~~~1'+ideaTheme);
        if(ideaTheme.size() > 0)
        update ideaTheme;        
    }
    //finish Mehtod
    global void finish(Database.BatchableContext BC)
    {
        System.debug('Apex job finished');
    }
}