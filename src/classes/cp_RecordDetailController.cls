/**
*
* Author:		Carmine Barbuto
* Date:			15/05/2014
* Description:	Class to disable relevant buttons if user has no
*				permission to edit.
*
*
**/
public with sharing class cp_RecordDetailController {
	
	public Boolean canEdit {get; set;}
	
	public cp_RecordDetailController(ApexPages.StandardController std) {

		// Check edit permission based on Host Planner
		cp_Event__c mainEvent = [SELECT HostPlanner__c FROM cp_Event__c WHERE id = :std.getId()];
		canEdit = cp_PlannerUtility.canEditEvent(mainEvent.HostPlanner__c, UserInfo.getUserId());
	}
}