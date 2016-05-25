public with sharing virtual class Oblix_SOWMainDetalControllerExt extends Oblix_SWOPparentController {

	// controller attribute to ease passing of comment text from vf page to controller
    public String sowSubmitComments {get; set;}
    public String sowApproveComments {get; set;}
    public String sowRejectComments {get; set;}
    public String uploadedAtt {get; set;}
    public String last_updated {get; set;}
    public Attachment pageAttachment {get; set;}
    public Map <Id, String> map_att_locale {get; set;}
    public Oblix_DashboardsHandler scoresFYFeeDashboard {get; set;}
    public Oblix_DashboardsHandler scoresFullFeeDashboard {get; set;}
<<<<<<< HEAD
=======
    public DateTime pageLastRefreshed {get;set;}
>>>>>>> develop

	public static final String FIELD_SET_SOW_MAIN_DETAIL = 'oblix_sow_main_detail';
    public static final String OBJECT_SOW_TO_QUERY = 'marketing_sow__c';

    public List<CampaignNonCampaignItems> li_campaign_and_non_campaign_items {get; set;}

    public Id campaignIDSync { get; set; }

<<<<<<< HEAD
=======
    public Boolean isAdmin {
    	get{
    		return Oblix_PermissionHandler.isSystemAdmin() || Oblix_PermissionHandler.hasSuperUserpermissionSet();
    	}
    }

>>>>>>> develop
    public Boolean can_delete_sow{
        get{
            return Oblix_PermissionHandler.canDeleteSOW(selected_sow.SOW_Status__c, selected_sow.Id);
        }
    }

    public Boolean can_delete_attachment{
        get{
            return Oblix_PermissionHandler.canDeleteAttachment(selected_sow.SOW_Status__c);
        }
    }

    public Boolean can_add_attachment{
        get{
            return Oblix_PermissionHandler.canAddNewAttachment(selected_sow.SOW_Status__c);
        }
    }

    public Boolean can_manage_campaign{
        get{
            return Oblix_PermissionHandler.canManageCampaign(selected_sow.SOW_Status__c, selected_sow.Id, null);
        }
    }

    public Boolean can_manage_non_campaign{
        get{
            return Oblix_PermissionHandler.canManageNonCampaign(selected_sow.SOW_Status__c, selected_sow.Id);
        }
    }

    public Boolean sow_approvers_defined{
        get{
            // until the agency users are live, agency approvers aren't mandatory
<<<<<<< HEAD
            return selected_sow.Unilever_SOW_Approver_Name__c != null || Oblix_PermissionHandler.isSystemAdmin() || Oblix_PermissionHandler.hasSuperUserpermissionSet();// && selected_sow.Agency_SOW_Approver_Name__c != null;
=======
            return (selected_sow.Unilever_SOW_Approver_Name__c != null && selected_sow.Unilever_SOW_Approver_Name__r.IsActive) || Oblix_PermissionHandler.isSystemAdmin() || Oblix_PermissionHandler.hasSuperUserpermissionSet();// && selected_sow.Agency_SOW_Approver_Name__c != null;
>>>>>>> develop
            //Blank Unilever approver is taken care of inside submitForApproval() method so can proceed if SystemAdmin or SuperUser
        }
    }

    public Boolean can_submit_for_approval{
        get{
            return Oblix_PermissionHandler.canSubmitForApproval(selected_sow.SOW_Status__c,selected_sow.SOW_PFY__r.SOW_Status__c, selected_sow.Sync_Status__c);
        }
    }

    public Boolean can_see_submit_for_approval_button{
        get{
            return Oblix_PermissionHandler.canSeeSubmitForApprovalButton(selected_sow.SOW_Status__c,selected_sow.SOW_PFY__r.SOW_Status__c, selected_sow.Sync_Status__c);
        }
    }

    public Boolean can_reject_sow{
        get{
            return Oblix_PermissionHandler.canRejectSOW(selected_sow.SOW_Status__c, selected_sow.Id);
        }
    }

    public Boolean can_approve_sow{
        get{
            return Oblix_PermissionHandler.canApproveSOW(selected_sow.SOW_Status__c, selected_sow.Id);
        }
    }

    public Boolean show_submit{
        get{

            Boolean is_sole_editor = Oblix_PermissionHandler.isOnlyBrandCatEditor(selected_sow.OblixBrand__c, selected_sow.SmallProductCategory__c, UserInfo.getUserId());
            Boolean is_with_ul2 = (selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_REJECTED_BY_AGENCY) || (selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_REJECTED_BY_UNILEVER) || (selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER );

            System.debug('### show_submit');
            System.debug('### is_sole_editor: ' + is_sole_editor);
            System.debug('### selected_sow.SOW_Status__c: ' + selected_sow.SOW_Status__c);
            System.debug('### is_with_ul2: ' + is_with_ul2);
            System.debug('### can_submit_for_approval: ' + can_submit_for_approval);
            System.debug('### Oblix_PermissionHandler.hasUL1permissionSet(): ' + Oblix_PermissionHandler.hasUL1permissionSet());

            return can_see_submit_for_approval_button && ( !( Oblix_PermissionHandler.hasUL1permissionSet() && is_with_ul2) || is_sole_editor);
        }
    }

    public Boolean isAgencyApproval{
        get{
            return selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_AWAITING_AGENCY_APPROVAL;
        }
    }

    //Hide Submit for approval button if the Financial year hasn't been updated
    public Boolean submitForApprovalFX{
        get{
            //Date fxDate = null;
            Oblix_FX_Change__c orgFY = Oblix_FX_Change__c.getInstance(UserInfo.getOrganizationId());
            Integer sowFY = Oblix_SOWHandlerLogic.getFinancialYear(selected_sow);
            
            if(orgFY != null && orgFY.Financial_Year__c != null && sowFY != null && 
                orgFY.Financial_Year__c >= sowFY){
                return false;
            }else{
                return true;
            }
    }set;}
    
    //Hide Submit for approval button if the Financial year hasn't been updated
    public Boolean isFXApprovedForFY{
        get{
            Oblix_FX_Change__c orgFY = Oblix_FX_Change__c.getInstance(UserInfo.getOrganizationId());
            Integer sowFY = Oblix_SOWHandlerLogic.getFinancialYear(selected_sow);
            
            if(orgFY != null && orgFY.Financial_Year__c != null && sowFY != null && 
                orgFY.Financial_Year__c >= sowFY){
                return true;
            }else{
                return false;
            }
    }set;}

    public Boolean canSeeDashboard{
        get{
            return Oblix_PermissionHandler.canSeeDashboards();
        }
    }

<<<<<<< HEAD
=======
    //**********************************************************************************************************************************
    // ROLLOVER SYNC STATUSES
    //**********************************************************************************************************************************

// S.M. 2016-05-21 - status messages
// rollover status list

//- Initiate Rollover
//    - On Original SOW (just after clicking initiate rollover): Rollover Initiated - your B/Fwd record will be created shortly after few minutes. You can continue working on other records (Sync_Status__c = ’Sync In Progress’ OR ’Sync Requested' && NFY is null)
//    - On the Original SOW (when Initial Sync is completed): Here is the link to your brought forward recode: [link to record] (get NFY record for link) (NFY != NULL)
//- Sync
//    - On both Original & Brough Forward SOW (when subsequent sync process is running): Rollover in Progress. This Scope of Work is currently Read Only. (Sync_Status__c = ’Sync In Progress’ OR ’Sync Requested' && NFY is != null)
//    - On BFwd SOW (after sync requested - just after click): Sync Initiated - your record will be synced shortly after a few minutes. You can continue working on other records (Sync_Status__c = ’Sync Requested’ && PFY is != null)
//    - On BFwd SOW (after sync completed - staying on the page): Sync Completed! Please refresh this page to see the latest changes (Sync_Status__c = ’Sync Completed’ && PFY is != null && lastrefreshed < PFY.lastmodifiedDate)
//    - On BFwd SOW (after sync completed - coming back to the page - original not finalised then remove): Here is the link to your original recode: [link to record] (get PFY record for link) (PFY != NULL && PFY.status <> ‘finalised’) - IMPORTANT: This Scope of Work has campaigns brought forward from a previous financial year. Please make changes to these campaigns via: Shahin Full cycle 2__2016 (Live) and use Sync to reflect the changes below (PFY <> NULL and PFY not finalised)
//- Approved record
//    - On original record: Here is the link to your live SOW [link to Live SOW] (Cloned_SOW != NULL && Status__c = ‘Approved’)


    public Boolean is_going_through_rollover {
        get {
            return selected_sow.SOW_PFY__c != NULL && selected_sow.SOW_PFY__r.SOW_Status__c != Oblix_Utils.SOW_STATUS_FINALISED;
        }
    }

    public Boolean is_initial_rollover_sync_requested {
        get {
            return selected_sow.SOW_NFY__c == NULL && (selected_sow.Sync_Status__c == Oblix_Utils.JOB_STATUS_SYNC_REQUESTED);
        }
    }

    public Boolean is_initial_sync_completed {
        get {
            return selected_sow.SOW_NFY__c != NULL;
        }
    }

    public Boolean is_rollover_in_progress {
        get {
            system.debug('### is_rollover_in_progress - selected_sow.SOW_NFY__c:  ' + selected_sow.SOW_NFY__c + ' - selected_sow.SOW_PFY__r.Sync_Status__c: ' + selected_sow.SOW_PFY__r.Sync_Status__c
                  + ' - selected_sow.Sync_Status__c: ' + selected_sow.SOW_PFY__r.Sync_Status__c);
            return Oblix_Utils.is_sync_job_running && (selected_sow.Sync_Status__c == Oblix_Utils.SOW_STATUS_CAMPAIGN_SYNC_REQUIRED || selected_sow.Sync_Status__c == Oblix_Utils.JOB_STATUS_SYNC_REQUESTED);
        }
    }
    public Boolean is_sync_requested {get;set;}
         //Sync_Status__c = ’Sync Requested’ && PFY is != null
        //get {
        //    return !Oblix_Utils.is_sync_job_running && selected_sow.SOW_PFY__c != NULL;
        //}

    //}

    public Boolean is_sync_complete {
        // Sync_Status__c = ’Sync Completed’ && PFY is != null
        get {
            return selected_sow.SOW_PFY__c != NULL && (selected_sow.SOW_PFY__r.Sync_Status__c == Oblix_Utils.JOB_STATUS_SYNC_COMPLETED);
        }
    }
    public Boolean is_approved_original_record {
        // Cloned_SOW != NULL && Status__c = ‘Approved’
        get {
            return selected_sow.Cloned_SOW__c != NULL && selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_APPROVED_BY_AGENCY;
        }
    }


    //**********************************************************************************************************************************
    // ROLLOVER SYNC RELATED MESSAGES SHOW/HIDE
    //**********************************************************************************************************************************

    public Boolean can_see_rollover_initiated_message_on_original_sow{
        get {
            return is_initial_rollover_sync_requested
                && !Oblix_PermissionHandler.hasAG1permissionSet() && !Oblix_PermissionHandler.hasAG2permissionSet();
        }
    }


    public Boolean can_see_sync_completed_on_original_sow{
        get {
            return is_initial_sync_completed
                && !Oblix_PermissionHandler.hasAG1permissionSet() && !Oblix_PermissionHandler.hasAG2permissionSet();
        }
    }


    public Boolean can_see_sync_in_progress{
        get {
            return is_rollover_in_progress && !is_sync_complete
                && !Oblix_PermissionHandler.hasAG1permissionSet() && !Oblix_PermissionHandler.hasAG2permissionSet();
        }
    }


    public Boolean can_see_sync_requested_on_bfwd_sow{
        get {
            return is_sync_requested && !is_rollover_in_progress && !is_sync_complete
                && !Oblix_PermissionHandler.hasAG1permissionSet() && !Oblix_PermissionHandler.hasAG2permissionSet();
        }
    }

    public Boolean can_see_sync_completed_on_bfwd_sow_staying_on_the_page{
        get {
            return is_sync_complete && selected_sow.SOW_PFY__r.LastmodifiedDate > pageLastRefreshed
                && !Oblix_PermissionHandler.hasAG1permissionSet() && !Oblix_PermissionHandler.hasAG2permissionSet();
        }
    }


    public Boolean can_see_link_to_cloned_record{
        get {
            return is_approved_original_record
                && !Oblix_PermissionHandler.hasAG1permissionSet() && !Oblix_PermissionHandler.hasAG2permissionSet();
        }
    }

    //Only UL users can see warning about SOW going through a rollover if SOW has at least 1 B/Fwd Campaign
    public Boolean can_see_rollover_warning {
        get {
            return is_going_through_rollover && (selected_sow.B_Fwd_Campaign_count__c > 0) && !Oblix_PermissionHandler.hasAG1permissionSet() && !Oblix_PermissionHandler.hasAG2permissionSet();
        }
    }

>>>>>>> develop
    public Boolean hasCampaigns {get; set;}



	public Oblix_SOWMainDetalControllerExt() {
		
	}

	/*******************************************************************
        Purpose: Inner Class Used to have list of Campaign and non Campaign in the same list
        Parameters: none
        Returns: none
        Throws [Exceptions]: none
    ********************************************************************/
    public class CampaignNonCampaignItems {
        public SObject dynamic_object {get;set;}
        public String s_object_type {get;set;}
        public Oblix_CampaignStageLogic stage_identifier {get;set;}
        public String sectionKey {get;set;}
        public String name {get;set;}
        public Decimal cost {get;set;}

        public CampaignNonCampaignItems(String object_type, SObject campaign_non_campaign, Boolean can_edit) {
            
            s_object_type = object_type;
            dynamic_object = campaign_non_campaign;

            // initialise StageIdentifier if it is a campaign type
            if ('Campaign' == object_type){
                //system.debug('##campaign_non_campaign: ' + campaign_non_campaign);
                stage_identifier = new Oblix_CampaignStageLogic((Oblix_SOW_Projects__c) campaign_non_campaign, can_edit,can_edit);
            }
        }

        public CampaignNonCampaignItems(String object_type, Oblix_BasketSectionWrapper nonCampaignSectionWrapper) {
            
            s_object_type = object_type;

            sectionKey = nonCampaignSectionWrapper.key;
            name = nonCampaignSectionWrapper.name;
            cost = nonCampaignSectionWrapper.totalValue;

        }
    }

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-08
    * @description  submit SOW for approval
    ********************************************************************************/
    public PageReference submitForApproval(){

        Id submitterId = UserInfo.getUserId();

        Savepoint sp;

        sp = Database.setSavepoint();

        // skip unilever approval if creator is approver
        if(submitterId == selected_sow.Unilever_SOW_Approver_Name__c){
            selected_sow.SOW_Creator_is_Approver__c = true;
            selected_sow.SOW_Status__c = Oblix_Utils.SOW_STATUS_AWAITING_AGENCY_APPROVAL;
        } else {
            selected_sow.SOW_Creator_is_Approver__c = false;
            selected_sow.SOW_Status__c = Oblix_Utils.SOW_STATUS_AWAITING_UNILEVER_APPROVAL;
        }
        
        selected_sow.OwnerId = submitterId;
        selected_sow.Approval_Submitter__c = submitterId;

        // 21/04 DE351: For SysAdmin and SU set them as designated Unilever approvers if no Unilever approver was previously assigned to prevent error message
        //              All other users won't be able to submit SOW for approval if no Unilever approver is assigned (handled by try-catch bellow)
        if ((Oblix_PermissionHandler.hasSuperUserpermissionSet() || Oblix_PermissionHandler.isSystemAdmin()) &&
<<<<<<< HEAD
                selected_sow.Unilever_SOW_Approver_Name__c == null) {
=======
                (selected_sow.Unilever_SOW_Approver_Name__c == null || !selected_sow.Unilever_SOW_Approver_Name__r.IsActive)) {
>>>>>>> develop

            selected_sow.Unilever_SOW_Approver_Name__c = UserInfo.getUserId();
            //update selected_sow;
        }

        //update selected_sow;
        update selected_sow;

        //if(selected_sow.SOW_Creator_is_Approver__c){

        //    // just lock the record
        //    try{
        //        Approval.lock(new List<Marketing_SOW__c>{selected_sow});
        //    } catch (Exception e){
        //        system.debug(e);
        //        Database.rollback(sp);
        //        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'An undexpected error occured. Please contact your administrator.'));
        //        return null;
        //    }

        //} else {

        try {
            // Create an approval request for the SOW
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments(sowSubmitComments);
            req1.setObjectId(selected_sow.Id);

            // Submit on behalf of a specific submitter
            req1.setSubmitterId(submitterId);

            // Submit the record to specific process and skip the criteria evaluation
            req1.setProcessDefinitionNameOrId(Oblix_Utils.APPROVAL_PROCESS_NAME);
            //req1.setSkipEntryCriteria(true);

            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);

            // Verify the result
            //System.assert(result.isSuccess());
        } catch (Exception e) {

            // 21/04 DE351
            Database.rollback(sp);

            if (e.getMessage().contains('MANAGER_NOT_DEFINED')) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'No Unilever approver defined. Please contact your administrator.'));
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'An undexpected error occured. Please contact your administrator.'));
            }

            System.debug('### Exception during the approval process: ' + e.getMessage());
            return null;
        }

        //}

        PageReference ref = new PageReference('/apex/oblix_sowmain');
        return ref;

    }

<<<<<<< HEAD
    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-09
    * @description  reject SOW with mandatory comments
    ********************************************************************************/
    public PageReference rejectSOW(){

        // get sow approval record - there can be only one (?)
        List<ProcessInstanceWorkitem> workItems = [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :selected_sow.Id];
        // S.M 20160209 adding checks and removing else to fix sonar issue
        if(NULL!=workItems && workItems.size() == 1){

            ProcessInstanceWorkitem wi = workItems[0];

            Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
            pwr.setComments(sowRejectComments);
            pwr.setAction('Reject');
            pwr.setWorkitemId(wi.Id);
            system.debug('## selected_sow.Id: ' + selected_sow.Id + 'pwr: ' + JSON.serializePretty(pwr) + ' WorkItem: ' + wi.Id);
            Approval.ProcessResult result =  Approval.process(pwr);

            if(result.isSuccess()){
                // reload SOW to get new sow status
                selected_sow = getSOW(selected_sow.Id, Oblix_Utils.getAllFieldsInFieldsSet(OBJECT_SOW_TO_QUERY, FIELD_SET_SOW_MAIN_DETAIL) , null);
            }

        }
        //} else {

        //    // there should be only one work item for a given object.
        // refactoring: add error message?

        //}

        PageReference ref = new PageReference('/apex/oblix_sowmain');
        return ref;

    }
=======
    
>>>>>>> develop

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-09
    * @description  approve SOW with optional comments
    ********************************************************************************/
    public PageReference approveSOW(){

        PageReference ref = null;

        Savepoint sp;

        sp = Database.setSavepoint();

        // get sow approval record - there can be only one (?)
        // UPDATE: 21/04 IR - 
        // no, there can be more than one ProcessInstanceWorkitem record - one per user/group that can approve current step independently (first approval wins)
        List<ProcessInstanceWorkitem> workItems = [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :selected_sow.Id];
        // S.M 20160209 adding checks and removing else to fix sonar issue
        if(NULL != workItems && workItems.size() == 1){

            if(selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_AWAITING_AGENCY_APPROVAL){

                // reload SOW to get new sow status
                selected_sow = getSOW(selected_sow.Id, Oblix_Utils.getAllFieldsInFieldsSet(OBJECT_SOW_TO_QUERY, FIELD_SET_SOW_MAIN_DETAIL) , ', (SELECT Name_Suffix__c FROM Marketing_Projects__r)');
 
                // set the sync status to clone requested to allow batch job to process it
                updateSyncStatusAndNameSuffix();
                
                // show appropriate notification to user
                showNotificationToUser(selected_sow);

            }

            //Once it's already approved by Unilever skip the step if it's rejected by agencies
            // 21/04 DE351: For SysAdmin and SU set them as designated Agency approvers if no Agency approver was previously assigned to prevent error message
            //              All other users won't be able to complete Unilever Approval if no Agency approver is assigned (handled by try-catch bellow)
            if (selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_AWAITING_UNILEVER_APPROVAL &&
                    (Oblix_PermissionHandler.hasSuperUserpermissionSet() || Oblix_PermissionHandler.isSystemAdmin()) &&
<<<<<<< HEAD
                    selected_sow.Agency_SOW_Approver_Name__c == null ) {
=======
                    (selected_sow.Agency_SOW_Approver_Name__c == null || !selected_sow.Agency_SOW_Approver_Name__r.IsActive) ) {
>>>>>>> develop
                    
                    selected_sow.Agency_SOW_Approver_Name__c = UserInfo.getUserId();
            }

            update selected_sow;

            try {
                ProcessInstanceWorkitem wi = workItems[0];

                Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
                pwr.setComments(sowApproveComments);
                pwr.setAction('Approve');
                pwr.setWorkitemId(wi.Id);
                Approval.ProcessResult result =  Approval.process(pwr);

                System.debug('Approval successfull');

                if(!result.isSuccess()){
                    
                    Database.rollback(sp);
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'An undexpected error occured. Please contact your administrator.'));

                } else {

                    if(!isAgencyApproval){
                        ref = new PageReference('/apex/oblix_sowmain');
                    }
                }
            } catch (Exception e) {
                Database.rollback(sp);

                // 21/04 DE351
                if (e.getMessage().contains('MANAGER_NOT_DEFINED')) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'No agency approver defined. Please contact your administrator.'));
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'An undexpected error occured. Please contact your administrator.'));
                }

                System.debug('### Exception during the approval process: ' + e.getMessage());
            }

        }

        return ref;

    }

    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-05-07
    * @description  Depending on the type of approval update the name suffix 
                    or set the sync status to a value to be picked up by the job
    ********************************************************************************/
    public void updateSyncStatusAndNameSuffix(){

        // is it Initial Approval or EOY approval?
        if (selected_sow.Initial_Approval_Complete__c){
            selected_sow.Name_Suffix__c = Oblix_Utils.NAME_SUFFIX_FINALISED;
            // also update all related campaigns to be finalised
            updateCampaignNameSuffix();
            // enforce full campaign update 
            // S.M. 2016-05-17 taken out as the user can only submit for approval once sync is complete
            //selected_sow.Sync_Status__c = Oblix_Utils.JOB_STATUS_SYNC_REQUESTED;
        }else{
            // mark as clone requested to let the batch job pick this up 
            selected_sow.Sync_Status__c = Oblix_Utils.JOB_STATUS_CLONE_REQUESTED;
        }
    }

    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-05-07
    * @description  Set the name suffix for campaigns below SOW being finalised
    ********************************************************************************/
    public void updateCampaignNameSuffix(){

        List<Oblix_SOW_Projects__c> list_campaigns_to_update = new List<Oblix_SOW_Projects__c>();

        // is it Initial Approval or EOY approval?
        for (Oblix_SOW_Projects__c campaign : selected_sow.Marketing_Projects__r){
            campaign.Name_Suffix__c = Oblix_Utils.NAME_SUFFIX_FINALISED;
            list_campaigns_to_update.add(campaign);
        }

        update list_campaigns_to_update;
    }

    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-05-07
    * @description  depending on if SOW initial approved or not show appropriate message to user
    ********************************************************************************/
    public void showNotificationToUser(Marketing_SOW__c selected_sow){

        // is it Initial Approval or EOY approval?
        if (selected_sow.Initial_Approval_Complete__c){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info, 'SOW finalised successfully!'));
            
        }else{

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info, 'SOW will be cloned shortly. Please refresh SOW list in a few minutes.'));        
        }


    }

}