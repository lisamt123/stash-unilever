/**********************************************************************
Purpose: Handler class for Opportunity for the Food Solution (NAFS).
History :
VERSION AUTHOR         DATE         DETAIL Description
1.0     Accenture      18/Jul/2016     Draft                     
***********************************************************************/

public with sharing class FS_OpportunityHandler {
    Private FS_OpportunityHelper helper = new FS_OpportunityHelper();
    public void onAfterInsert(Map<Id, Opportunity> newOpportunityMap,List<Opportunity> listNewTrigger) {
        system.debug('OnAFTERINSERT call ------------>>>'+newOpportunityMap);
        FS_OpportunityHelper2.sharingOpportunityWithDistributorOwner(newOpportunityMap.values());
        helper.rollUptoAccountPlan(listNewTrigger);
        helper.rollUptoDefinedObjective(listNewTrigger);
    }
    public void onAfterUpdate(Map<Id, Opportunity> newOpportunityMap, Map<Id, Opportunity> oldOpportunityMap,List<Opportunity> listNewTrigger){
        FS_OpportunityHelper2.createOpportunityTeamMember(newOpportunityMap.values(), oldOpportunityMap);
        helper.copyLineItemToExistingOpp(listNewTrigger,oldOpportunityMap);
        helper.rollUpOpportunityLineItem(listNewTrigger);  
        helper.rollUptoAccountPlan(listNewTrigger);
        helper.rollUptoDefinedObjective(listNewTrigger);
    }
    public void onBeforeInsert(List<Opportunity> listNewTrigger) {        
        helper.validateOpportunity(listNewTrigger);            
    }
}