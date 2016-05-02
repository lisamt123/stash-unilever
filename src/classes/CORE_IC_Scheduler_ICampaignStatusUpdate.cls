/* This Class implements Batch Apex Scheduler for Status Update based on Start Date and End Date
** Initial Write By : Mindtree for Start date validation. Date: 01-Jun-2015
** Updated By : Mindtree Date : 10-June-2015 Change: Status check in query removed
*/
global with sharing class CORE_IC_Scheduler_ICampaignStatusUpdate implements Schedulable {
    global void execute(SchedulableContext ctx) {
        string query = 'SELECT id,Title,Status,StartDate,EndDate FROM IdeaTheme';
        CORE_IC_Batch_ICampaignStatusUpdate batchApex=new CORE_IC_Batch_ICampaignStatusUpdate(query);
        ID batchprocessid = Database.executeBatch(batchApex,20);
    }
    
}