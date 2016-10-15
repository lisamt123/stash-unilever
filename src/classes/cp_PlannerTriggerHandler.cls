/**
*
* Author:		Carmine Barbuto
* Date:			08/05/2014
* Description:	Trigger Handler for Planner updates.
*				Changing the planner name will update
* 				all "Track" fields on Planner Event.
*
**/
public class cp_PlannerTriggerHandler {
	
	private boolean m_isExecuting                           = false;
    private integer BatchSize                               = 0;

	public cp_PlannerTriggerHandler(boolean isExecuting, integer size) {
		m_isExecuting = isExecuting;
        BatchSize = size;
	}

	// ********************* HEADINGS ********************* //
    
    // AFTER UPDATE
    public void OnAfterUpdate(Map<ID, cp_Planner__c> pMap) {
        cp_PlannerUtility.setPlannerTextField(getRelatedEvents(pMap), true);
    }

    // AFTER DELETE
    public void OnAfterDelete(Map<ID, cp_Planner__c> pMap) {
        cp_PlannerUtility.setPlannerTextField(getRelatedEvents(pMap), true);
    }


    // ********************* BUSINESS LOGIC ********************* //

    public Map<Id,cp_Event__c> getRelatedEvents(Map<ID, cp_Planner__c> pMap) {

    	Set<Id> evIds = new Set<Id>();
    	for (cp_PlannerLocation__c curr : [SELECT Event__c FROM cp_PlannerLocation__c WHERE Planner__c IN :pMap.values()]) {
    		evIds.add(curr.Event__c);
    	}
    	Map<Id,cp_Event__c> eventMap = new Map<Id,cp_Event__c>([SELECT Id FROM cp_Event__c WHERE Id IN :evIds]);

    	return eventMap;
    }
}