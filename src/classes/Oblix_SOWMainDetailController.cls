public with sharing class Oblix_SOWMainDetailController extends Oblix_SWOPparentController{

    // controller attribute to ease passing of comment text from vf page to controller
    public String sowSubmitComments {get; set;}
    public String sowApproveComments {get; set;}
    public String sowRejectComments {get; set;}
    public String uploadedAtt {get; set;}
    public String last_updated {get; set;}
    public Attachment pageAttachment {get; set;}
    public Map <Id, String> map_att_locale {get; set;}

    private static final String FIELD_SET_SOW_MAIN_DETAIL = 'oblix_sow_main_detail';
    private static final String OBJECT_SOW_TO_QUERY = 'marketing_sow__c';

    public List<CampaignNonCampaignItems> li_campaign_and_non_campaign_items {get; set;}

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
                Stage_Projected_CFY__c, Stage_Completed_CFY__c, Projected_Stage_PFY__c, Completed_Stage_PFY__c, Value_To_BePaid_Manual_Override__c, Campaign_Total_Fees__c, Percentage_of_Fee_for_this_FY__c  FROM Oblix_SOW_Projects__c WHERE Financial_Year__c = :selected_sow.Id LIMIT 500]){
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

            // 21/04 DE351: For SysAdmin and SU set them as designated Agency approvers if no Agency approver was previously assigned to prevent error message
            //              All other users won't be able to complete Unilever Approval if no Agency approver is assigned (handled by try-catch bellow)
            if (selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_AWAITING_UNILEVER_APPROVAL &&
                    (Oblix_PermissionHandler.hasSuperUserpermissionSet() || Oblix_PermissionHandler.isSystemAdmin()) &&
                    selected_sow.Agency_SOW_Approver_Name__c == null) {

                selected_sow.Agency_SOW_Approver_Name__c = UserInfo.getUserId();
                update selected_sow;
            }

            if(selected_sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_AWAITING_AGENCY_APPROVAL){

                // reload SOW to get new sow status
                selected_sow = getSOW(selected_sow.Id, Oblix_Utils.getAllFieldsInFieldsSet(OBJECT_SOW_TO_QUERY, FIELD_SET_SOW_MAIN_DETAIL) , null);
 
                selected_sow.Marked_for_cloning__c = true;
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


    ///*******************************************************************************
    //* @author       Slavko Skular
    //* @date         2016-04-06
    //* @description  create a copy of the approvd SOW. This can be made a future
    //                method if required (depending on number of campaigns, assets
    //                and non-campaign items)
    //********************************************************************************/
    /*public Id copySOW(Id sowId){

        // clone SOW

        Marketing_SOW__c sowClone;
        Savepoint sp;

        try{

            sp = Database.setSavepoint();

            Marketing_SOW__c sow = [SELECT Id, Active__c,Agency_Contact__c,Agency_Name__c,Agency_SOW_Approver_Name__c,Approval_Submitter__c,BB_or_BD__c,
                                            BigOblixProductCategory__c,Brand_Name__c,Currency__c,Financial_Year__c,MarketingSOWParent__c,Name,OblixBrand__c,
                                            OblixSOWOverallTotal__c,OblixTotalCampaignCalculatedTotalFee__c,OblixTotalNumberofbasics__c,OblixTotalNumberofprojects__c,
                                            OblixTotalOtherItemsFees__c,Oblix_AgencyEstimate__c,Oblix_Current_FY_Total__c,Oblix_TotalCampaignAdjustment__c,
                                            OwnerId,Percentage_of_Total_Fee_Campaign_Fees__c,Percentage_of_Total_Fee_Non_Campaign__c,RecordTypeId,SmallProductCategory__c
                                            ,SOW_Creator_is_Approver__c,SOW_Status__c,Total_Campaigns_This_FY__c,Total_Campaign_Fee_Agency__c,Total_Campaign_Fee__c,
                                            Type_of_SOW__c,Unilever_Lead__c,Unilever_SOW_Approver_Name__c 
                                    FROM Marketing_SOW__c WHERE Id =: sowId];

            sowClone = sow.clone(false, true, false, false);
            //sowClone.OwnerId = sow.OwnerId;
            sowClone.OwnerId = UserInfo.getUserId();
            sowClone.SOW_Status__c = Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER;
            sowClone.Approved_version__c = sowId;
            sowClone.Name += CLONE_SUFFIX;

            insert sowClone;




            // clone campaigns

            List<Oblix_SOW_Projects__c> master_campaigns = [SELECT Id,Agency_Percentage_of_Fees_to_this_FY__c,Asset_Deliverables__c,BET_first_release__c,Brand_Led_Growth__c,Budget_Burnt_to_date__c,Campaign_Countries__c,Campaign_Fees_Total__c
                    ,Campaign_Hub_Summary__c,Campaign_Idea__c,Campaign_Points__c,Campaign_Score__c,Campaign_Splits_Total__c,Campaign_Status__c,Campaign_Total_Adjustment__c,Campaign_Total_Fees__c
                    ,Completed_Stage__c,Date_for_Assets_to_be_in_BET__c,Description__c,Enforce_Trigger_Update__c,Fees_To_Be_Paid_Next_Financial_Year__c,Final_release__c,Financial_Year__c,First_Air_Date__c
                    ,Innovation_Projects__c,IsDeleted,Is_this_High_Risk__c,Is_type_of_item_usually_poduced_by_this__c,Jobs_to_be_Done__c,List_Preview_Markets__c,Live_date_Asset_delivery__c,Live_Date__c
                    ,Name,Number_of_Agency_Hub_Splits__c,Number_of_Markets_for_Preview__c,Number_of_Previews__c,OblixClonedFromParentProject__c,OblixProjectSplitPercentage_Comment__c,OblixRegion__c
                    ,Oblix_ProjectBoxNumber__c,Other_Kinds_of_Research__c,Overall_Project_Complete__c,Percentage_of_Fee_for_Next_FY__c,Percentage_of_Fee_for_this_FY__c,Platform__c,Preview_Date__c
                    ,Production_Completion_Date__c,Projected_Stage__c,ProjectTotalAssetscore__c,Project_Completion_Date__c,Project_Finish_Date__c,Project_Priority__c,Project_Scale_1__c,Project_Scale_2__c
                    ,Project_Stage__c,Project_Start_Date__c,Region__c,Selected_Countries__c,Should_legal_review_this_project__c,Start_of_TV_production__c,Stimulus_Requirements__c,Timescale_Notes__c
                    ,Total_Adapt_Fees__c,Total_Asset_Deliverables__c,Total_Digital_Fee__c,Total_Fees_for_Project__c,Total_Locations__c,Total_Project_Score__c,Total_Value_Driver__c,Value_To_BePaid_Manual_Override__c
                    ,Value_to_be_paid_in_Current_FY__c, (SELECT Actual_Delivery_Date__c,Additional_Description__c,Agency_Projects__c,Asset_Description__c,Asset_name__c,Asset_Picklist__c,Asset_Scoring_Number__c
                    ,Asset_Title__c,Asset_Total_Score__c,Asset_Type__c,Calculator_Question__c,Category__c,Channels__c,FULL_Description__c,Location__c,Name,OblixClonedFromParentAsset__c,Option_Name__c,Quantity__c
                    ,RecordTypeId,Sub_Category__c,SystemModstamp,Target_Delivery_Date__c,MDM_id__c,Asset_Score__c FROM Agency_Project_Assets__r)
                    , (SELECT Enforce_Trigger_Update__c,Name,OblixCountry__c,Percentage__c,Project_Splits__c FROM Marketing_SOW_Project_Splits__r) 
                    FROM Oblix_SOW_Projects__c WHERE Financial_Year__c = : sowId];

            Map<Id, Oblix_SOW_Projects__c> map_master_cloned_campaigns = new Map<Id, Oblix_SOW_Projects__c>();

            List<Oblix_SOW_Projects__c> liso_cloned_campaigns = new List<Oblix_SOW_Projects__c>();
            for(Oblix_SOW_Projects__c master_campaign : master_campaigns){
                Oblix_SOW_Projects__c cloned_project = master_campaign.clone(false,true,false,false);
                cloned_project.Name +=  clone_suffix;
                cloned_project.Financial_Year__c = sowClone.Id;
                map_master_cloned_campaigns.put(master_campaign.Id, cloned_project);
            }

            insert map_master_cloned_campaigns.values();




            // clone campaign assets

            List<Oblix_Project_Assets__c> li_clone_assets_to_insert = new List<Oblix_Project_Assets__c>();

            for(Oblix_SOW_Projects__c master_campaign : master_campaigns){
                for(Oblix_Project_Assets__c master_asset : master_campaign.Agency_Project_Assets__r){
                    Oblix_Project_Assets__c cloned_asset = master_asset.clone(false,true,false,false);
                    cloned_asset.Agency_Projects__c = map_master_cloned_campaigns.get(master_campaign.Id).Id;
                    li_clone_assets_to_insert.add(cloned_asset);
                }
            }

            insert li_clone_assets_to_insert;




            // clone hub splits

            List<Oblix_Marketing_SOW_Project_Splits__c> li_cloned_hubs_to_insert = new List<Oblix_Marketing_SOW_Project_Splits__c>();

            for(Oblix_SOW_Projects__c master_campaign : master_campaigns){
                for (Oblix_Marketing_SOW_Project_Splits__c master_hub : master_campaign.Marketing_SOW_Project_Splits__r){
                    Oblix_Marketing_SOW_Project_Splits__c cloned_hub = master_hub.clone(false,true,false,false);
                    cloned_hub.Project_Splits__c = map_master_cloned_campaigns.get(master_campaign.Id).Id;
                    li_cloned_hubs_to_insert.add(cloned_hub);
                }
            }

            insert li_cloned_hubs_to_insert;




            // clone non-campaign items

            List<Marketing_Basics__c> li_clone_non_campaigns_to_insert = new List<Marketing_Basics__c>();

            List<Marketing_Basics__c> master_non_campaigns = [SELECT Activities__c,Activity_Fee_Agency__c,Agency_Department__c,Agency__c,Description__c,Financial_Year_old__c,
                                                Financial_Year__c,FTE__c,Hourly_Rate_Agency__c,Id,Name,Non_Campaign_Key__c,Non_campaign_title__c,
                                                No_of_Hours_Required__c,OblixCountry__c,OblixOtherItemFee__c,Oblix_FTE_Real_Price__c,Oblix_Hourly_Rate__c,
                                                Oblix_SOWMarketing__c,Order__c,Other_Activities__c,RecordTypeId,Resource_Fee_Agency__c,Role_Title__c 
                                            FROM Marketing_Basics__c WHERE Oblix_SOWMarketing__c =: sowId];

            for(Marketing_Basics__c master_non_campaign : master_non_campaigns){
                Marketing_Basics__c cloned_non_campaign = master_non_campaign.clone(false,true,false,false);
                cloned_non_campaign.Oblix_SOWMarketing__c = sowClone.Id;
                cloned_non_campaign.Non_Campaign_Key__c = master_non_campaign.Non_Campaign_Key__c.replace(sow.Id, sowClone.Id);
                li_clone_non_campaigns_to_insert.add(cloned_non_campaign);
            }

            insert li_clone_non_campaigns_to_insert;


            // clone attachments

            List<Attachment> master_attachments = [SELECT Id FROM Attachment WHERE ParentId =: sowId];

            for(Attachment master_attachment : master_attachments){
                cloneAttachment(master_attachment.Id, sowClone.Id);
            }

        } catch (Exception e){
            // on any error, roll back all changes so no loose SOWs are left in the system
            Database.rollback(sp);

        }

        return sowClone == null ? null : sowClone.Id;

    }

    @future
    private static void cloneAttachment(Id attachmentId, Id newParentId){

        Attachment master_attachment = [SELECT Body,ContentType,Description,Id,IsPrivate,Name,OwnerId,ParentId FROM Attachment WHERE Id =: attachmentId];

        Attachment clone_attachment = master_attachment.clone(false, true, false, false);
        clone_attachment.ParentId = newParentId;

        insert clone_attachment;

    }*/

    
}