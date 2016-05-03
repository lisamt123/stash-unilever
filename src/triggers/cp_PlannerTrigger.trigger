/**
*
* Author:       Carmine Barbuto
* Date:         08/05/2014
* Description:  Trigger for Planner updates.
*
**/
trigger cp_PlannerTrigger on cp_Planner__c (after update, after delete) {
	cp_PlannerTriggerHandler handler = new cp_PlannerTriggerHandler(true,200);
    if (Trigger.isAfter) {
    	if (Trigger.isUpdate) {
    		handler.OnAfterUpdate(trigger.newMap);
    	} else if (Trigger.isDelete) {
            handler.OnAfterDelete(trigger.oldMap);
        }
    }
}