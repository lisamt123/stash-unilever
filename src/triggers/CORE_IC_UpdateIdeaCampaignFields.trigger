/* This Trigger Prevents updates Status picklist with the value of Status Formula for Idea Campaigns 
** Initial Written By : Mindtree on 04-Jun-2015
** Updated By : Mindtree on 05-Jun-2015 Change : Status update logic
** Update By : Mindtree on 10-June-2015 Change : Commented Status as it was decided to use batch 
*/
trigger CORE_IC_UpdateIdeaCampaignFields on IdeaTheme (before insert, before update) {
    for (IdeaTheme iTheme : Trigger.new) {
        if (iTheme.StartDate.Date() <= System.Today() &&iTheme.EndDate.Date() >= System.Today()) {
            iTheme.Status = 'Active';
        }
        else if (iTheme.EndDate.Date() < System.Today()) {
            iTheme.Status = 'Closed';
        }
        else {
            iTheme.Status = 'Draft';
        }
        iTheme.Description = iTheme.Description__c;
    }
}