/**********************************************************************
Purpose: Handler class for Opportunity for the Food Solution (NAFS).
History :
VERSION AUTHOR         DATE         DETAIL Description
1.0     Accenture      18/Jul/2016     Draft                     
***********************************************************************/

public with sharing class FS_OpportunityHandler {

    public void onAfterInsert(Map<Id, Opportunity> newOpportunityMap) {
    	system.debug('OnAFTERINSERT call ------------>>>'+newOpportunityMap);
        FS_OpportunityHelper2.sharingOpportunityWithDistributorOwner(newOpportunityMap.values());        
    }
    public void onAfterUpdate(Map<Id, Opportunity> newOpportunityMap, Map<Id, Opportunity> oldOpportunityMap) {
        FS_OpportunityHelper2.createOpportunityTeamMember(newOpportunityMap.values(), oldOpportunityMap);        
    }
}