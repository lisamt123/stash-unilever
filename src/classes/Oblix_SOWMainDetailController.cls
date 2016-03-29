public with sharing class Oblix_SOWMainDetailController extends Oblix_SWOPparentController{

    // controller attribute to ease passing of comment text from vf page to controller
    public String sowSubmitComments {get; set;}
    public String sowApproveComments {get; set;}
    public String sowRejectComments {get; set;}

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
            return selected_sow.Unilever_SOW_Approver_Name__c != null;// && selected_sow.Agency_SOW_Approver_Name__c != null;
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
        if (selected_sow != null && selected_sow.Id != null) {

            li_campaign_and_non_campaign_items = new List<CampaignNonCampaignItems>();

            // get campaigns
            for(Oblix_SOW_Projects__c campaign : [SELECT Id, Name, OblixRegion__c, Selected_Countries__c, First_3_selected_countries__c, Campaign_Status__c, Total_Fees_for_Project__c, Value_to_be_paid_in_Current_FY__c, 
                Projected_Stage__c, Completed_Stage__c, Value_To_BePaid_Manual_Override__c, Campaign_Total_Fees__c, Percentage_of_Fee_for_this_FY__c  FROM Oblix_SOW_Projects__c WHERE Financial_Year__c = :selected_sow.Id LIMIT 500]){
                li_campaign_and_non_campaign_items.add(new CampaignNonCampaignItems('Campaign', campaign, can_edit));
            }

            // get non-campaigns
            for(Marketing_Basics__c nonCampaign : [SELECT Id, Name, OblixCountry__r.Name, OblixOtherItemFee__c FROM Marketing_Basics__c WHERE Oblix_SOWMarketing__c = : selected_sow.Id LIMIT 500]){
                li_campaign_and_non_campaign_items.add(new CampaignNonCampaignItems('Non Campaign', nonCampaign, can_edit));
            }

            // get attachments
            liso_attachments = getSOWAttachments(selected_sow.Id);

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

        public CampaignNonCampaignItems(String object_type, SObject campaign_non_campaign, Boolean can_edit) {
            
            s_object_type = object_type;
            dynamic_object = campaign_non_campaign;

            // initialise StageIdentifier if it is a campaign type
            if ('Campaign' == object_type){
                //system.debug('##campaign_non_campaign: ' + campaign_non_campaign);
                stage_identifier = new Oblix_CampaignStageLogic((Oblix_SOW_Projects__c) campaign_non_campaign, can_edit,can_edit);
            }
        }
    }


    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-08
    * @description  submit SOW for approval
    ********************************************************************************/
    public PageReference submitForApproval(){

        Id submitterId = UserInfo.getUserId();

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

        //update selected_sow;
        update selected_sow;

        if(selected_sow.SOW_Creator_is_Approver__c){

            // just lock the record
            try{
                Approval.lock(new List<Marketing_SOW__c>{selected_sow});
            } catch (Exception e){
                system.debug(e);
            }

        } else {

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

        // get sow approval record - there can be only one (?)
        List<ProcessInstanceWorkitem> workItems = [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :selected_sow.Id];
        // S.M 20160209 adding checks and removing else to fix sonar issue
        if(NULL != workItems && workItems.size() == 1){

            ProcessInstanceWorkitem wi = workItems[0];

            Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
            pwr.setComments(sowApproveComments);
            pwr.setAction('Approve');
            pwr.setWorkitemId(wi.Id);
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

    
}