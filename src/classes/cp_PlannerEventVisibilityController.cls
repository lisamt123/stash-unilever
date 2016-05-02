/**
*
* Author:		Carmine Barbuto
* Date:			17/12/2013
* Description:	Visualforce controller to display the visibility
*				record for all the planners activated on this event.
*				The table will also display a row for planners that
*				have been activated in child objects.
*
**/
public without sharing class cp_PlannerEventVisibilityController {
    
    public List<cp_PlannerLocation__c>      plList      {get; set;}
    public Map<Id,cp_PlannerLocation__c>    plMap       {get; set;}
    
    // CONSTRUCTORS
    public cp_PlannerEventVisibilityController(ApexPages.StandardController std) {
    	// Initialise...
        plList                  = new List<cp_PlannerLocation__c>();
        plMap                   = new Map<Id,cp_PlannerLocation__c>();
    	cp_Event__c	mainEvent 	= (cp_Event__c) std.getRecord();
    	
        // Retrieve all locations from event and child events
        for (cp_PlannerLocation__c curr : [SELECT Activate__c, OptOut__c, Planner__c, 
                                            Planner__r.Owner__r.Name, OptOutReason__c,
                                            Planner__r.Name, LastModifiedBy.Name
                                            FROM cp_PlannerLocation__c 
                                            WHERE 
                                            Event__c = :mainEvent.Id OR
                                            Event__r.Parent_Event__c = :mainEvent.Id
                                            ORDER by Planner__r.Name]) {
            // Skip duplicates
            if (!plMap.containsKey(curr.Planner__c)) {
                plMap.put(curr.Planner__c,curr);
                plList.add(curr);
            }
        }

    }
    
}