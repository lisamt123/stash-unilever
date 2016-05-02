/* This Trigger Prevents from start date less than today for Idea Campaigns 
** Initial Write By : Mindtree for Start date validation. Date: 01-Jun-2015
** Updated By : Mindtree to check for executing trigger only if start date changed. Date: 04-Jun-2015
*/
trigger CORE_IC_ICampaignStartDateValidation on IdeaTheme (before insert, after update) {
    if (trigger.IsAfter && trigger.IsUpdate)
    {
        for (IdeaTheme nIdeaTheme : trigger.new) {
            if (nIdeaTheme.StartDate != Trigger.oldMap.get(nIdeaTheme.Id).StartDate) {    // Field has been changed!          
                if (nIdeaTheme.StartDate < System.today()) {    nIdeaTheme.StartDate.addError('Start date should be greater than or equal to today.');
                }
            }
        }      
    } 
    else if (trigger.IsBefore && trigger.IsInsert)
    {
        for (IdeaTheme nIdeaTheme : trigger.new) {
            if (nIdeaTheme.StartDate < System.today()) {    nIdeaTheme.StartDate.addError('Start date should be greater than or equal to today.');
            }
        }
    }
}