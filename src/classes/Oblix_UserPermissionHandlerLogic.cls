/*****************************************************************************************
* @author       Slavko Skular
* @date         2016-02-07
* @description  Trigger handler Logic for Oblix_User_Permission__c custom object
*
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Slavko Skular              2016-02-07          Created
*    Slavko Skular              2016-05-03          Updated to reassign an active
													approval process

******************************************************************************************/
public with sharing class Oblix_UserPermissionHandlerLogic {

	/*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-07
    * @description  Returns all affected SOW records. Those are all SOW records that
    				have the same brand and category as user permission records.
    				Include both old and new values of CategoryBrand_id__c field!
    ********************************************************************************/
	public static List<Marketing_SOW__c> retrieveAffectedSOWs(List<Oblix_User_Permission__c> newUserPermissions, List<Oblix_User_Permission__c> oldUserPermissions){

		Set<Id> oldAndNewCategoryBrands = new Set<Id>();
		if(newUserPermissions != null){
			for(Oblix_User_Permission__c up : newUserPermissions){
				oldAndNewCategoryBrands.add(up.CategoryBrand_id__c);
			}
		}
		if(oldUserPermissions != null){
			for(Oblix_User_Permission__c up : oldUserPermissions){
				oldAndNewCategoryBrands.add(up.CategoryBrand_id__c);
			}
		}

		//get the related brand and category ids so we can build the BradCatKeys
		List<MDO_CategoryBrands__c> categoryBrands = [SELECT Id, Brand_id__c, Product_Category_Id__c
														FROM MDO_CategoryBrands__c 
														WHERE Id IN :oldAndNewCategoryBrands];

		Set<Id> brandIds = new Set<Id>();
		Set<Id> categoryIds = new Set<Id>();
		Set<String> brandCatKeys = new Set<String>();
		for(MDO_CategoryBrands__c cb : categoryBrands){
			brandIds.add(cb.Brand_id__c);
			categoryIds.add(cb.product_Category_Id__c);
			brandCatKeys.add(cb.brand_id__c + '_' + cb.product_Category_Id__c);
		}

<<<<<<< HEAD
		List<Marketing_SOW__c> affectedSOWs_unfiltered = [SELECT Id, OblixBrand__c, SmallProductCategory__c, Unilever_SOW_Approver_Name__c, Agency_SOW_Approver_Name__c, OwnerId
=======
		List<Marketing_SOW__c> affectedSOWs_unfiltered = [SELECT Id, OblixBrand__c, SmallProductCategory__c, Unilever_SOW_Approver_Name__c, Agency_SOW_Approver_Name__c, OwnerId, Oblix_AgencyEstimate__c, SOW_Status__c
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
												FROM Marketing_SOW__c 
												WHERE OblixBrand__c IN :brandIds 
													AND SmallProductCategory__c IN :categoryIds];

		// make sure only affected SOWs are returned, not any SOW which has any of the brands in brandsSet and any category in categoriesSet
		List<Marketing_SOW__c> affectedSOWs = new List<Marketing_SOW__c>();
		for(Marketing_SOW__c sow : affectedSOWs_unfiltered){
			String sowKey = sow.OblixBrand__c + '_' + sow.SmallProductCategory__c;
			if(brandCatKeys.contains(sowKey)){
				affectedSOWs.add(sow);
			}
		}

		return affectedSOWs;

	}

	/*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-07
    * @description  This method gets approvers for the brand-BigC combination, and
                    populates the unilever and agency approvers maps passed in by
                    reference. (uses existing Oblix_SOWHandlerLogic method)
    ********************************************************************************/
	public static void retrieveBrandCategoryApprovers(List<Marketing_SOW__c> affectedSOWs, Map<String, Set<Id>> brandCatKey_unileverApproverIds_map, Map<String, Set<Id>> brandCatKey_agencyApproverIds_map){
		Oblix_SOWHandlerLogic.retrieveBrandCategoryApprovers(affectedSOWs, brandCatKey_unileverApproverIds_map, brandCatKey_agencyApproverIds_map);
	}


	/*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-07
    * @description  For SOWs that are locked by an active approval process, abort the
    				approval process to unlock the record. When all records are
    				unlocked, set SOW approvers (uses existing Oblix_SOWHandlerLogic
    				method)
    ********************************************************************************/
	public static void updateSOWApprovers(List<Marketing_SOW__c> affectedSOWs, Map<String, Set<Id>> brandCatKey_unileverApproverIds_map, Map<String, Set<Id>> brandCatKey_agencyApproverIds_map){

		Map<Id, Marketing_SOW__c> sowsToUpdateMap = new Map<Id, Marketing_SOW__c>();

		for(Marketing_SOW__c sow : affectedSOWs){
<<<<<<< HEAD
			if(Oblix_SOWHandlerLogic.setSOWApprovers(sow, brandCatKey_unileverApproverIds_map, brandCatKey_agencyApproverIds_map)){
				sowsToUpdate.add(sow);
=======
			if(Oblix_SOWHandlerLogic.setSOWApprovers(sow, brandCatKey_unileverApproverIds_map, brandCatAGKey_agencyApproverIds_map)){
				sowsToUpdatemap.put(sow.Id, sow);
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
			}
		}

		// first exclude any SOWs that are currently being approved
		List<ProcessInstanceWorkItem> pendingApprovalsToUpdate = new List<ProcessInstanceWorkItem>();
		List<ProcessInstanceWorkItem> pendingApprovals = [Select Id, ActorId, ProcessInstance.TargetObjectId From ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId IN :sowsToUpdateMap.values()];
		for(ProcessInstanceWorkItem pis : pendingApprovals){
			Marketing_SOW__c targetSOW = sowsToUpdateMap.get(pis.ProcessInstance.TargetObjectId);
			if(targetSOW.SOW_Status__c == Oblix_Utils.SOW_STATUS_AWAITING_UNILEVER_APPROVAL && targetSOW.Unilever_SOW_Approver_Name__c != pis.ActorId && targetSOW.Unilever_SOW_Approver_Name__c != null){
				pis.ActorId = targetSOW.Unilever_SOW_Approver_Name__c;
				pendingApprovalsToUpdate.add(pis);
			} else if(targetSOW.SOW_Status__c == Oblix_Utils.SOW_STATUS_AWAITING_AGENCY_APPROVAL && targetSOW.Agency_SOW_Approver_Name__c != pis.ActorId && targetSOW.Agency_SOW_Approver_Name__c != null){
				pis.ActorId = targetSOW.Agency_SOW_Approver_Name__c;
				pendingApprovalsToUpdate.add(pis);
			}
		}

		if(!sowsToUpdateMap.isEmpty())
			update sowsToUpdateMap.values();

		if(!pendingApprovalsToUpdate.isEmpty())
			update pendingApprovalsToUpdate;

		/*Set<Id> lockedSOWIds = new Set<Id>();
		for(ProcessInstance pi : pendingApprovals)
			lockedSOWIds.add(pi.TargetObjectId);

		// Should approvals in progress be aborted on this change?
		if(!lockedSOWIds.isEmpty())
			abortRelatedApprovals(lockedSOWIds);

		// after all related approvals have been aborted, no sowsToUpdate in scope should be locked anymore
		if(!sowsToUpdate.isEmpty())
			update sowsToUpdate;*/

	}

	/*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-07
    * @description  Aborts approvals in progress to unlock SOW records.
    ********************************************************************************/
	/*public static void abortRelatedApprovals(Set<Id> lockedSOWIds){

		List<ProcessInstanceWorkitem> workItems = [Select Id, ActorId from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId = :lockedSOWIds];

		for(ProcessInstanceWorkitem wi : workItems){

			Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
			//pwr.setComments('Approval automatically aborted due to a change in the list of users authorised for approving this brand and category.');
			//pwr.setAction('Reassigned');
			pwr.setWorkitemId(wi.Id);
			//pwr.setNextApproverIds();
			Approval.ProcessResult result =  Approval.process(pwr);

		}

	}*/

}