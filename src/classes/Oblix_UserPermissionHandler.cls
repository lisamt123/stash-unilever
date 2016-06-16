/*****************************************************************************************
* @author       Slavko Skular
* @date         2016-02-07
* @description  Trigger handler for Oblix_User_Permission__c custom object
*
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Slavko Skular              2016-02-07          Created

******************************************************************************************/
public with sharing class Oblix_UserPermissionHandler implements ITrigger{

	List<Marketing_SOW__c> affectedSOWs;
	Map<String, Set<Id>> brandCatKey_unileverApproverIds_map = new Map<String, Set<Id>>();
    Map<String, Set<Id>> brandCatKey_agencyApproverIds_map = new Map<String, Set<Id>>();
    Map<String, List<Oblix_User_Permission__c>> brandCatKey_UserPermissions_map = new Map<String, List<Oblix_User_Permission__c>>();
    List<Marketing_SOW__Share> li_sharesToInsert = new List<Marketing_SOW__Share>();

	/*******************************************************************************
    * @date         2016-02-07
    * @description  This method is called prior to execution of a BEFORE trigger. 
                    Use this to cache any data required into maps 
                    prior execution of the trigger.
    ********************************************************************************/
	public void bulkBefore(){
		return;
	}

	/*******************************************************************************
    * @date         2016-02-07
    * @description  This method is called prior to execution of a AFTER trigger. 
                    Use this to cache any data required into maps 
                    prior execution of the trigger.
    ********************************************************************************/
	public void bulkAfter(){

		if(Trigger.isAfter){
			// get the list of SOWs affected by this change - search by brandCategory key
			affectedSOWs = Oblix_UserPermissionHandlerLogic.retrieveAffectedSOWs(Trigger.new, Trigger.old);
			// as this is the after trigger, most up-to-date approvers setting is already stored in Oblix_User_Permission__c
			Oblix_UserPermissionHandlerLogic.retrieveBrandCategoryApprovers(affectedSOWs, brandCatKey_unileverApproverIds_map, brandCatKey_agencyApproverIds_map);
			Oblix_SOWHandlerLogic.deleteAllManualSharing(affectedSOWs);

			brandCatKey_UserPermissions_map = Oblix_SOWHandlerLogic.retrieveUserPermissions(affectedSOWs);
		}

	}

	public void beforeInsert(SObject so){
		return;
	}

	public void beforeUpdate(SObject oldSo, SObject so){
		return;
	}

	public void beforeDelete(SObject so){
		return;
	}

	public void afterInsert(SObject so){
		return;
	}

	public void afterUpdate(SObject oldSo, SObject so){
		return;
	}

	public void afterDelete(SObject so){
		return;
	}

	/**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
	public void andFinally(){

		// update sharings
		if(Trigger.isAfter){

			// update approvers on SOW
			Oblix_UserPermissionHandlerLogic.updateSOWApprovers(affectedSOWs, brandCatKey_unileverApproverIds_map, brandCatKey_agencyApproverIds_map);

			for(Marketing_SOW__c sow : affectedSOWs){

				List<Marketing_SOW__Share> li_sowShare = Oblix_SOWHandlerLogic.adjustSharing(sow, brandCatKey_UserPermissions_map);
        		li_sharesToInsert.addAll(li_sowShare);
        	}

        	if(!li_sharesToInsert.isEmpty()){
	            insert li_sharesToInsert;
	        }

		}

	}
}