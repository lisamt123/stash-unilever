public with sharing class Oblix_SOWMainDetailController extends Oblix_SWOPparentController{

    // controller attribute to ease passing of comment text from vf page to controller
    public String sowSubmitComments {get; set;}
    public String sowApproveComments {get; set;}
    public String sowRejectComments {get; set;}
    public String uploadedAtt {get; set;}
    public String last_updated {get; set;}
    public Attachment pageAttachment {get; set;}
    public Map <Id, String> map_att_locale {get; set;}
    public Oblix_DashboardsHandler scoresDashboard {get; set;}

    private static final String FIELD_SET_SOW_MAIN_DETAIL = 'oblix_sow_main_detail';
    private static final String OBJECT_SOW_TO_QUERY = 'marketing_sow__c';

    public List<CampaignNonCampaignItems> li_campaign_and_non_campaign_items {get; set;}

    public Id campaignIDSync { get; set; }

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
            return selected_sow.Unilever_SOW_Approver_Name__c != null || Oblix_PermissionHandler.isSystemAdmin() || Oblix_PermissionHandler.hasSuperUserpermissionSet();// && selected_sow.Agency_SOW_Approver_Name__c != null;
            //Blank Unilever approver is taken care of inside submitForApproval() method so can proceed if SystemAdmin or SuperUser
        }
    }

    public Boolean can_submit_for_approval{
        get{
            return Oblix_PermissionHandler.canSubmitForApproval(selected_sow.SOW_Status__c);
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

    public Boolean is_sole_editor{
        get{
            return Oblix_PermissionHandler.isOnlyBrandCatEditor(selected_sow.OblixBrand__c, selected_sow.SmallProductCategory__c, UserInfo.getUserId());
        }
    }

    public Boolean is_with_ul2{
        get{
            return (selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_REJECTED_BY_AGENCY) || (selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_REJECTED_BY_UNILEVER) || (selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER );
        }
    }

    public Boolean show_submit{
        get{
            return can_submit_for_approval && ( !( Oblix_PermissionHandler.hasUL1permissionSet() && is_with_ul2) || is_sole_editor);
        }
    }

    public Boolean isAgencyApproval{
        get{
            return selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_AWAITING_AGENCY_APPROVAL;
        }
    }

    public String reportDeveloperName{
        get{
            return Oblix_Utils.SWOP_DASHBOARD_REPORT_CAMPAIGNS_PER_BOX;
        }
    }

    public String reportFilter{
        get{
            Oblix_DashboardsController.ColumnFilter cfSelectedSOW = new Oblix_DashboardsController.ColumnFilter('Marketing_SOW__c.Name', 'equals', selected_sow.Name);
            return JSON.serialize(cfSelectedSOW);
        }
    }




    //public static PageReference reportFolderURL {
    //    get{
    //        if(reportFolderURL == null){
    //            List<Folder> reportFolderIdList = [SELECT Id FROM Folder WHERE Name =: Oblix_Constants.SWOPReportFolder];
    //            if(!reportFolderIdList.isEmpty()){
    //                reportFolderURL = new PageReference('/' + reportFolderIdList[0].Id);
    //            }
    //        }
    //        return reportFolderURL;
    //    } set;
    //}


    public Oblix_SOWMainDetailController() {

        String sow_id = ApexPAges.currentPage().getParameters().get('sowId');
        selected_sow = getSOW(sow_id, Oblix_Utils.getAllFieldsInFieldsSet(OBJECT_SOW_TO_QUERY, FIELD_SET_SOW_MAIN_DETAIL), null);
        pageAttachment = new Attachment();
        map_att_locale = new Map <Id, String>();
        last_updated = '';
        uploadedAtt = ApexPAges.currentPage().getParameters().get('att');
        if (selected_sow != null && selected_sow.Id != null) {
            liso_attachments = getSOWAttachments(selected_sow.Id);
            
            li_campaign_and_non_campaign_items = new List<CampaignNonCampaignItems>();

            // get campaigns
            for(Oblix_SOW_Projects__c campaign : [SELECT Id, Name, OblixRegion__c, Selected_Countries__c, First_3_selected_countries__c, Campaign_Status__c, Total_Fees_for_Project__c, Value_to_be_paid_in_Current_FY__c, 
                Projected_Stage_CFY__c, Completed_Stage_CFY__c, Projected_Stage_PFY__c, Completed_Stage_PFY__c, Value_To_BePaid_Manual_Override__c, Campaign_Total_Fees__c, Percentage_of_Fee_for_this_FY__c, 
                Sync_Required_NFY__c, Stage_Projected_CFY__c, Stage_Completed_CFY__c, Campaign_PFY__c  
                FROM Oblix_SOW_Projects__c 
                WHERE Financial_Year__c = :selected_sow.Id LIMIT 500]){
                li_campaign_and_non_campaign_items.add(new CampaignNonCampaignItems('Campaign', campaign, can_edit));
            }

            // get non-campaigns
            /*for(Marketing_Basics__c nonCampaign : [SELECT Id, Name, OblixCountry__r.Name, OblixOtherItemFee__c FROM Marketing_Basics__c WHERE Oblix_SOWMarketing__c = : selected_sow.Id LIMIT 500]){
                li_campaign_and_non_campaign_items.add(new CampaignNonCampaignItems('Non Campaign', nonCampaign, can_edit));
            }*/

            Map<String, Oblix_SOWNonCampaignPageHelper.BasketSectionWrapper> nonCampItemSections = Oblix_SOWNonCampaignPageHelper.initBasketSections(selected_sow.Id);
            for (Oblix_SOWNonCampaignPageHelper.BasketSectionWrapper sectionWrapper : nonCampItemSections.values()) {
                li_campaign_and_non_campaign_items.add(new CampaignNonCampaignItems('Non Campaign', sectionWrapper));
            }
            
            // get attachments
            liso_attachments = getSOWAttachments(selected_sow.Id);

            if (selected_sow.Cloning_failed__c) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Error. Please contact System Administrator'));
            }
            if(selected_sow.Marked_for_cloning__c) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info, 'Open for Updates version is being created.'));
            }

            if(!liso_attachments.isEmpty()){
                for(Attachment att:liso_attachments){
                    map_att_locale.put(att.Id, date.valueof(att.CreatedDate).format());
                }
            }

            last_updated = Oblix_Utils.toLocaleDate(selected_sow.LastModifiedDate);

            scoresDashboard = new Oblix_DashboardsHandler(Oblix_DashboardsHandler.Type.SOW_SCORES, selected_sow.Id);

        }
        
    }


    public PageReference deleteAction(){

        PageReference sow_details_page = Page.oblix_sowmain;

        try{
            // Campaign Splits and SWOP Campaigns have master-detail so the related records will be deleted also
            Database.DeleteResult delete_result_main_campaign = Database.delete(selected_sow, true);

        // not a DML exception
        } catch (Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'There was an issue while trying to delete this SOW: ' + e.getMessage()));
        }

        return sow_details_page;
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

        public CampaignNonCampaignItems(String object_type, Oblix_SOWNonCampaignPageHelper.BasketSectionWrapper nonCampaignSectionWrapper) {
            
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
            selected_sow.SOW_Status__c = Oblix_Utils.SOW_STATUS_AWAITING_AGENCY_APPROVAL_TBC;
        } else {
            selected_sow.SOW_Creator_is_Approver__c = false;
            selected_sow.SOW_Status__c = Oblix_Utils.SOW_STATUS_AWAITING_UNILEVER_APPROVAL;
        }
        
        selected_sow.OwnerId = submitterId;
        selected_sow.Approval_Submitter__c = submitterId;

        // 21/04 DE351: For SysAdmin and SU set them as designated Unilever approvers if no Unilever approver was previously assigned to prevent error message
        //              All other users won't be able to submit SOW for approval if no Unilever approver is assigned (handled by try-catch bellow)
        if ((Oblix_PermissionHandler.hasSuperUserpermissionSet() || Oblix_PermissionHandler.isSystemAdmin()) &&
                selected_sow.Unilever_SOW_Approver_Name__c == null) {

            selected_sow.Unilever_SOW_Approver_Name__c = UserInfo.getUserId();
            update selected_sow;
        }

        //update selected_sow;
        update selected_sow;

        if(selected_sow.SOW_Creator_is_Approver__c){

            // just lock the record
            try{
                Approval.lock(new List<Marketing_SOW__c>{selected_sow});
            } catch (Exception e){
                system.debug(e);
                Database.rollback(sp);
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'An undexpected error occured. Please contact your administrator.'));
                return null;
            }

        } else {

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

        }

        PageReference ref = new PageReference('/apex/oblix_sowmain');
        return ref;

    }

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
            //Once it's already approved by Unilever skip the step if it's rejected by agencies

            // 21/04 DE351: For SysAdmin and SU set them as designated Agency approvers if no Agency approver was previously assigned to prevent error message
            //              All other users won't be able to complete Unilever Approval if no Agency approver is assigned (handled by try-catch bellow)
            if (selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_AWAITING_UNILEVER_APPROVAL &&
                    (Oblix_PermissionHandler.hasSuperUserpermissionSet() || Oblix_PermissionHandler.isSystemAdmin()) &&
                    selected_sow.Agency_SOW_Approver_Name__c == null ) {
                    
                    selected_sow.Agency_SOW_Approver_Name__c = UserInfo.getUserId();
                    update selected_sow;
            }

            if(selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_AWAITING_AGENCY_APPROVAL){

                // reload SOW to get new sow status
                selected_sow = getSOW(selected_sow.Id, Oblix_Utils.getAllFieldsInFieldsSet(OBJECT_SOW_TO_QUERY, FIELD_SET_SOW_MAIN_DETAIL) , null);
 
                //selected_sow.Marked_for_cloning__c = true;
                // set the sync status to clone requested to allow batch job to process it
                updateSyncStatusAndNameSuffix();
                
                update selected_sow;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info, 'SOW will be cloned shortly. Please refresh SOW list in a few minutes.'));

            }

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
    private void updateSyncStatusAndNameSuffix(){

        // is it Initial Approval or EOY approval?
        if (selected_sow.Initial_Approval_Complete__c){
            selected_sow.Name_Suffix__c = Oblix_Utils.NAME_SUFFIX_FINALISED;
        }else{
            // mark as clone requested to let the batch job pick this up 
            selected_sow.Sync_Status__c = Oblix_Utils.JOB_STATUS_CLONE_REQUESTED;
        }


    }
    /*******************************************************************************
    * @author       Ignacio Llorca
    * @date         2016-04-25
    * @description  Slavko's method to attach a file to an existing SOW. If the page is in create mode,
    *               inserts a SOW first (on cancel it will be deleted). Migrated to Main Detail page.
    ********************************************************************************/
    public PageReference uploadAttachment(){

        PageReference uploadedAtt = new PageReference('/apex/oblix_sowmaindetail?sowId=' + selected_sow.Id + '&att=true');
        uploadedAtt.setRedirect(true);

        if(pageAttachment.body == null){

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'No file selected. Select a file you would like to attach to this SOW.'));
            return null;
        } else {

            pageAttachment.OwnerId = UserInfo.getUserId();
            pageAttachment.ParentId = selected_sow.id;
            //IR - Comented out as far of DE330 defect fix
            //pageAttachment.IsPrivate = true;

            try{

                insert pageAttachment;
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Attachment uploaded successfully'));
                // clear blob data from viewstate
                pageAttachment.body = null;
                List<Attachment> insertedAtt = [SELECT Id, Name, CreatedDate, Createdby.Name, Description 
                                                FROM Attachment WHERE Id =: pageAttachment.Id limit 1];
                if(!insertedAtt.isEmpty())
                    liso_attachments.add(insertedAtt[0]);
                // create new attachemnt instance for page upload
                map_att_locale = new Map<Id, String>();
                for(Attachment att:liso_attachments){
                    map_att_locale.put(att.Id, date.valueof(att.CreatedDate).format());
                }
                pageAttachment = new Attachment();
                return uploadedAtt;
            } catch(DmlException e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'There was an error while uploading the attachment ' + e.getMessage()));
                return null;
            }
        }

    }

    /*******************************************************************************
    * @author       Ignacio Llorca
    * @date         2016-02-26
    * @description  deletes a single attachment attached to this SOW
    ********************************************************************************/
    public PageReference deleteAtt(){
        PageReference uploadedAtt = new PageReference('/apex/oblix_sowmaindetail?sowId=' + selected_sow.Id + '&att=true');
        uploadedAtt.setRedirect(true);

        if(deleteAttachmentId != null){
            try{
                delete new Attachment(Id = deleteAttachmentId);
                liso_attachments = getSOWAttachments(selected_sow.Id);
                return uploadedAtt;
            } catch (DmlException e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'You do not have permission to delete this attachment'));
                return null;
            }
        }
        return uploadedAtt;
    }

    /*******************************************************************************
    * @author       makepositive
    * @date         2016-05-05
    * @description  sets  SOW.Sync_Status__c to "Sync Requested"
    ********************************************************************************/
    public PageReference initiateRollOver(){
        System.DEBUG('In Here');
        selected_sow.Sync_Status__c = Oblix_Utils.JOB_STATUS_SYNC_REQUESTED;
        try{
            update selected_sow;
        }catch (DmlException e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'Could not initiate roll over'));
            return null;
        }
        return null;
    }

    /******************************************************************************************
    * @author       makepositive
    * @date         2016-05-05
    * @description  If no campaign Id is passed in - syncs all the child campaigns that have "Sync Required" to "Sync Reqeusted"
    *               If campaign Id is passed in - only that single campaign is set to sync required 
    *******************************************************************************************/
    public PageReference syncCampaigns(){
        System.DEBUG('In Here');
        System.DEBUG(campaignIDSync);
        List<Oblix_SOW_Projects__c> campaignsToUpdate = new List<Oblix_SOW_Projects__c>();
        if(campaignIDSync == null){
            for(Oblix_SOW_Projects__c eachCampaign : [SELECT Id, Sync_Status__c 
                                                        FROM Oblix_SOW_Projects__c 
                                                        WHERE Financial_Year__c =:selected_sow.Id 
                                                        AND Sync_Status__c = :Oblix_Utils.JOB_STATUS_SYNC_REQUIRED
                                                        LIMIT 1000]){
                eachCampaign.Sync_Status__c = Oblix_Utils.JOB_STATUS_SYNC_REQUESTED;
                campaignsToUpdate.add(eachCampaign);
            }
        }else{
            for(Oblix_SOW_Projects__c eachCampaign : [SELECT Id, Sync_Status__c 
                                                    FROM Oblix_SOW_Projects__c 
                                                    WHERE Id =:campaignIDSync 
                                                    AND Sync_Status__c = :Oblix_Utils.JOB_STATUS_SYNC_REQUIRED
                                                    LIMIT 1]){
                eachCampaign.Sync_Status__c = Oblix_Utils.JOB_STATUS_SYNC_REQUESTED;
                campaignsToUpdate.add(eachCampaign);
            }            
        }
        try{
            update campaignsToUpdate;
            campaignIDSync = null;
        }catch (DmlException e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.ERROR, 'Could not update related Campaigns'));
            return null;
        }
        return null;
    }

    
}