/**
*
* Author:		Carmine Barbuto
* Date:			20/05/2014
* Description:	Class for Event delete, implementing new custom
*				sharing model based on Host Planner.
*				Without sharing to override standard delete
* 				permissions.
*
*
**/
public without sharing class cp_EventDeleteController {
	
	public Boolean 		canDelete 	{get; set;}
	public cp_Event__c	mainEvent 	{get; set;}

	// CONSTRUCTOR
	public cp_EventDeleteController(ApexPages.StandardController std) {
		// Check edit permission based on Host Planner
		mainEvent = [SELECT HostPlanner__c, Parent_Event__c, Name FROM cp_Event__c WHERE id = :std.getId()];
		canDelete = cp_PlannerUtility.canEditEvent(mainEvent.HostPlanner__c, UserInfo.getUserId());
	}

	// DELETE EVENT
	public void confirmDelete() {
		if (canDelete) {
			// Check if this was an activation and update visibility table
			if (mainEvent.Parent_Event__c != null) {
				List<cp_PlannerLocation__c> locs = [SELECT Id 
													FROM cp_PlannerLocation__c 
													WHERE 
													Planner__c =:mainEvent.HostPlanner__c AND
													Event__c =:mainEvent.Parent_Event__c];
				if (!locs.isEmpty()) {
					for (cp_PlannerLocation__c curr : locs) {
						curr.Activate__c 		= false;
						curr.OptOut__c 			= false;
						curr.OptOutReason__c 	= null;
					}
				}
				update locs;											
			}

			// Delete event
			delete mainEvent;
		}
	}

	// BACK BUTTON
	public Pagereference back() {
		return new PageReference('/' + mainEvent.Id);
	}
	
}