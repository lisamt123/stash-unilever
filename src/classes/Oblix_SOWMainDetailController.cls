/**
    About
    -----
    Description: Class Oblix_SOWMainDetailController
    Created for: OBLIX Project
    Create date: 10/ 2015
    Created by Asmae ESSBAI
    Author : @Asmae
    Details
    -------

       Update History
    --------------
*/
public with sharing class Oblix_SOWMainDetailController extends Oblix_SWOPparentController {

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
            return Oblix_PermissionHandler.canManageCampaign(selected_sow.SOW_Status__c, selected_sow.Id);
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

    //public Marketing_SOW__c selected_sow {get; set;}
    public id sow_id {get; set;}
    public id project_id {get; set;}
    public List<Attachment> liso_attachments {get; set;}
    public List<Attachment> liso_attachments_to_add {get; set;}
    public List<Note> liso_notes {get; set;}

    // controller attribute to ease passing of comment text from vf page to controller
    public String sowSubmitComments {get; set;}
    public String sowApproveComments {get; set;}
    public String sowRejectComments {get; set;}

    //Projects to the Sow
    public List<Oblix_SOW_Projects__c> liso_projects_for_sow {get; set;}
    // Ids of SOW projects
    
    // private set<id> setIdsProject;
    public boolean isEdit {get; set;}

    public boolean editMode { get; set; }


    public set<String> setRecordType  {get; set;}
    public Oblix_SOW_Projects__c selectedProject {get; set;}
    public boolean isViewProject {get; set;}
    public List<Marketing_Basics__c> liso_other_non_campaign_items  {get; set;}
    public String seriesProject {get; set;}
    public Map<Id, Integer> midi_sow_id_overall_total {get; set;}
    public List<CampaignNonCampaignItems> li_campaign_and_non_campaign_items {get; set;}
    public note noteAsset {get; set;}

    //Thousand Block Part :
    //public  limitWrapper[] thousandBlocks {get; set;}
    private final Integer listLimit;
    public String selectedProjectId {get; set;}
    public Integer countOfUpdatesFeed {get; set;}
    public List<SelectOption> filesCountList {get; set;}
    //Selected count
    public String FileCount {get; set;}

    public List<Attachment> allFileList {get; set;}

    private static final Integer notesSize = 255;
    private static final String sow_param_name = 'sowId';
    private static final String FIELD_SET_SOW_MAIN_DETAIL = 'oblix_sow_main_detail';
    private static final String OBJECT_SOW_TO_QUERY = 'marketing_sow__c';

    //achraf
    public Attachment attachment {
        get {
            if (attachment == null)
                {attachment = new Attachment();}
            return attachment;
        } set;
    }

    public List<Oblix_CampaignStageLogic> li_stage_identifier {get;set;}

    /*******************************************************************
        Purpose: Controller constructor
        Parameters: none
        Returns: none
        Throws [Exceptions]: none
    ********************************************************************/
    public Oblix_SOWMainDetailController() {
        listLimit = 999;
        initializeAttributes();
        init();
    }
    
    /*******************************************************************
        Purpose: Used to initialize atributes
        Parameters: none
        Returns: none
        Throws [Exceptions]: none
    ********************************************************************/
    public void initializeAttributes() {

        liso_notes = new list<Note>();
        noteAsset = new note();
        //thousandBlocks = new List<limitWrapper>();
        liso_projects_for_sow = new List<Oblix_SOW_Projects__c>();
        liso_attachments = new List<Attachment>();
        liso_attachments_to_add = new List<Attachment>();
        seriesProject = '';
        midi_sow_id_overall_total = new map<id, Integer>();
        if (project_id == null) {selectedProject = new Oblix_SOW_Projects__c();}
        isEdit = false;
        editMode = false;
        //Initialize
        filesCountList = new List<SelectOption>() ;
        FileCount = '' ;
        allFileList = new List<Attachment>() ;

        //Adding values count list - you can change this according to your need
        for (Integer i = 1 ; i < 11 ; i++) {
            filesCountList.add(new SelectOption('' + i , '' + i)) ;
        }

        li_campaign_and_non_campaign_items  = new List<CampaignNonCampaignItems>();

    }

    /*******************************************************************
        Purpose: Used to initialize atributes
        Parameters: none
        Returns: none
        Throws [Exceptions]: none
    ********************************************************************/
    public void init() {
        System.DEBUG('Init Called!!!!');
        // get SOW and Campaign IDs from page parameters
        sow_id = ApexPAges.currentPage().getParameters().get(sow_param_name);
        project_id = ApexPAges.currentPage().getParameters().get('projectId');

        if(sow_Id == null){
            editMode = false;
        }else{
            editMode = true;
        }
        // retrieve required fields from db for SOW if param passed in otherwise initialise a new object
        if (sow_id == null) {
            selected_sow = new Marketing_SOW__c ();
        }
        else {
            selected_sow = getSOW(sow_id, Oblix_Utils.getAllFieldsInFieldsSet(OBJECT_SOW_TO_QUERY, FIELD_SET_SOW_MAIN_DETAIL) , null);
        }
        
        //System.DEBUG('!!selected_sow:'+selected_sow);
        // retrieve required fields from db for Campaign if param passed in otherwise initialise a new object
        
        if (project_id == null){ 
            selectedProject = new Oblix_SOW_Projects__c();
        }
        else{
            selectedProject = [SELECT Id, Name, Project_Finish_Date__c, Project_Stage__c, Platform__c, CreatedById, Project_Start_Date__c, CreatedDate
                , OblixRegion__c, Project_Priority__c, Project_Completion_Date__c, Description__c, Campaign_Countries__c, Selected_Countries__c, First_Air_Date__c
                , Production_Completion_Date__c, Financial_Year__c, Value_To_BePaid_Manual_Override__c,Percentage_of_Fee_for_this_FY__c FROM Oblix_SOW_Projects__c WHERE id = :project_id];
        }

        //System.DEBUG('Init Called 2 !!!!');
    
        if (selected_sow != null && selected_sow.Id != null) {
            // retrieve the children sows for the given parent
            List<Marketing_SOW__c> liso_children_sow = new List<Marketing_SOW__c>();
            
            liso_children_sow = [SELECT OblixSOWOverallTotal__c, Oblix_Current_FY_Total__c,Total_Campaigns_This_FY__c,OblixTotalOtherItemsFees__c 
                FROM Marketing_SOW__c WHERE MarketingSOWParent__c = :selected_sow.id AND Type_of_SOW__c = 'Baseline'];

            System.DEBUG('Init Called 3 !!!!');
            
            if (!liso_children_sow.isEmpty()){
                midi_sow_id_overall_total.put(selected_sow.id, (Integer)liso_children_sow[0].OblixSOWOverallTotal__c);
            } else {
                midi_sow_id_overall_total.put(selected_sow.id, 0);
            }

            System.DEBUG('Init Called 4 !!!!');

            countOfUpdatesFeed = NumberOfSowChatterFeedItem(selected_sow.Id);

            liso_attachments = [SELECT Name, ParentId, Parent.Name, CreatedBy.Name, CreatedDate FROM Attachment WHERE ParentId = : selected_sow.Id];
            
            // retrieve campaign items
            liso_projects_for_sow = [SELECT Name, Project_Finish_Date__c, Campaign_Status__c, Platform__c, Project_Stage__c, Projected_Stage__c, Completed_Stage__c
                , CreatedById, Total_Fees_for_Project__c, Value_to_be_paid_in_Current_FY__c, Project_Start_Date__c, CreatedDate, OblixRegion__c, Project_Priority__c
                , Project_Completion_Date__c, Description__c, Campaign_Countries__c, Selected_Countries__c, First_Air_Date__c, Production_Completion_Date__c, Financial_Year__c, Campaign_Total_Fees__c, Value_To_BePaid_Manual_Override__c,Percentage_of_Fee_for_this_FY__c
                FROM Oblix_SOW_Projects__c WHERE Financial_Year__c = : selected_sow.Id LIMIT 500];
            
            // retrieve non campaign items
            liso_other_non_campaign_items = [SELECT  m.Role_Title__c, m.RecordTypeId, m.Other_Activities__c, m.Oblix_SOWMarketing__c, m.OblixOtherItemFee__c, m.OblixCountry__c
                , m.No_of_Hours_Required__c, m.Name, m.LastModifiedById, m.Id, m.Financial_Year_old__c, OblixCountry__r.Name
                , m.Financial_Year__c, m.FTE__c, m.Description__c, m.CreatedDate, m.CreatedById, m.Agency__c, m.Agency_Department__c, m.Activities__c 
                FROM Marketing_Basics__c m WHERE Oblix_SOWMarketing__c = : selected_sow.Id LIMIT 500]; // m.Discipline__c,

            // retrieve notes
            liso_notes = [SELECT Body FROM Note WHERE parentId = :selected_sow.Id];

            System.DEBUG('Init Called 5 !!!!' + liso_projects_for_sow);
            System.DEBUG('Init Called 5 !!!!' + liso_other_non_campaign_items);
            //
            if (!liso_projects_for_sow.isEmpty())
                for (Oblix_SOW_Projects__c  project : liso_projects_for_sow)
                    li_campaign_and_non_campaign_items.add(new CampaignNonCampaignItems('Campaign', project, hasEditAccess));
                

            if (!liso_other_non_campaign_items.isEmpty())
                for (Marketing_Basics__c otherItem : liso_other_non_campaign_items ) 
                    li_campaign_and_non_campaign_items.add(new CampaignNonCampaignItems('Non Campaign', otherItem, hasEditAccess));
            System.DEBUG('Init Called 6 !!!!');

            String seriesbis = '';
            date d_projStart, d_prodCompletion, d_projEnd, d_firstAir, d_projCompletion ;
            String series = '';
            //date d1,d2;
            if (liso_projects_for_sow.size() > 0){

                for (Oblix_SOW_Projects__c  pr : liso_projects_for_sow) {
                    System.DEBUG('Init Called 7 !!!!');
                    if (pr.Project_Start_Date__c != null) { d_projStart = pr.Project_Start_Date__c.addMonths(-1);  }
                    else { d_projStart  = date.newInstance(2015, 1, 1);}
                    if (pr.Project_Finish_Date__c != null ){ d_projEnd = pr.Project_Finish_Date__c.addMonths(-1);  }
                    else { d_projEnd = date.newInstance(2015, 1, 1);}
                    System.DEBUG('Init Called 8 !!!!');
                    if (pr.Production_Completion_Date__c != null) { d_prodCompletion = pr.Production_Completion_Date__c.addMonths(-1);  }
                    else { d_prodCompletion = date.newInstance(2015, 1, 1); }
                    if (pr.First_Air_Date__c != null) { d_firstAir = pr.First_Air_Date__c.addMonths(-1);}
                    else {d_firstAir = date.newInstance(2015, 1, 1);}
                    if (pr.Project_Completion_Date__c != null){ d_projCompletion = pr.Project_Completion_Date__c.addMonths(-1);}
                    else {d_projCompletion = date.newInstance(2015, 1, 1);}
                    String dateutc = 'Date.UTC(' ;
                    series = series + '{' +
                             '"unitName"' + ':"' + pr.name + '",' +
                             '"beginTimestamp"' + ':' + dateutc + d_projStart.year() + ',' + d_projStart.month() + ',' + d_projStart.day() + '),' +
                             '"x1Timestamp"' + ':' + dateutc + d_projCompletion.year() + ',' + d_projCompletion.month() + ',' + d_projCompletion.day() + '),' +
                             '"x2Timestamp"' + ':' + dateutc + d_firstAir.year() + ',' + d_firstAir.month() + ',' + d_firstAir.day() + '),' +
                             '"x3Timestamp"' + ':' + dateutc + d_prodCompletion.year() + ',' + d_prodCompletion.month() + ',' + d_prodCompletion.day() + '),' +
                             '"endTimestamp"' + ':' + dateutc + d_projEnd.year() + ',' + d_projEnd.month() + ',' + d_projEnd.day() + ')' +
                             +'}' + ',' ;
                }
            }
            seriesProject = '[' + series.removeEnd(',') + ']';
            System.DEBUG('Init Called 9 !!!!');
        }
        //if (!li_campaign_and_non_campaign_items.isEmpty()) {
        //    getthousandBlocks(li_campaign_and_non_campaign_items);

        //}

    }
    

    /*******************************************************************
        Purpose: get Financial Year Options
        Parameters: none
        Returns: FY Options 
        Throws [Exceptions]: none
    ********************************************************************/
    public List<SelectOption> getFYSelectOptions() {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('', 'Financial Year'));
        
        for( Schema.PicklistEntry f : Marketing_SOW__c.fields.Financial_Year__c.getDescribe().getPicklistValues()){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        return options;
        
    }
    

    /*******************************************************************
        Purpose: Back to VF5
        Parameters: none
        Returns: page reference
        Throws [Exceptions]: none
    ********************************************************************/
    public pageReference backAction() {
        Pagereference mainPage = Page.Oblix_SOWMain;
        mainPage.setRedirect(True);
        return mainPage;
    }

    public pageReference cancelAction(){
        if(selected_sow != null && !editMode && selected_sow.Id != null){
            delete selected_sow;
        }
        Pagereference mainPage = Page.Oblix_SOWMain;
        mainPage.setRedirect(True);
        return mainPage;

    }

    //public Pagereference exitSwop(){
    //    return Oblix_Utils.exitSwop();
    //}
    /*
    public pageReference CreateProjectAction() {
        Pagereference meNewPage = Page.Oblix_VF07_ProjectNew;
                meNewPage.getParameters().put('project_id', project_id);
                meNewPage.setRedirect(True);
        return meNewPage;
    }
    public pageReference SaveProjectAction() {
         Pagereference meNewPage = Page.Oblix_VF06_SOWView;
                meNewPage.getParameters().put('id', sow_id);
                meNewPage.setRedirect(True);
        return meNewPage;
    }
    */

    /*******************************************************************
        Purpose: Sets isEdit variable to true
        Parameters: none
        Returns: none
        Throws [Exceptions]: none
    ********************************************************************/
    public void editAction() {
        isEdit = true;
    }
    
    /*******************************************************************
        Purpose: Clones Marketing SOW record
        Parameters: none
        Returns: none
        Throws [Exceptions]: none
    ********************************************************************/
    public void cloneAction() {

        // create a 'clone' record and initialize it's values
        Marketing_SOW__c selSowClone = new Marketing_SOW__c(
            Name = selected_sow.Name,
            BB_or_BD__c = selected_sow.BB_or_BD__c,
            Oblix_AgencyEstimate__c = selected_sow.Oblix_AgencyEstimate__c,
            Oblix_AgencyEstimate__r = selected_sow.Oblix_AgencyEstimate__r,
            OblixBrand__c = selected_sow.OblixBrand__c,
            OblixBrand__r = selected_sow.OblixBrand__r,
            BigOblixProductCategory__c = selected_sow.BigOblixProductCategory__c,
            BigOblixProductCategory__r = selected_sow.BigOblixProductCategory__r,
            SmallProductCategory__c = selected_sow.SmallProductCategory__c,
            SmallProductCategory__r = selected_sow.SmallProductCategory__r,
            Agency_Contact__c = selected_sow.Agency_Contact__c,
            Agency_Contact__r = selected_sow.Agency_Contact__r,
            Unilever_Lead__c = selected_sow.Unilever_Lead__c,
            Unilever_Lead__r = selected_sow.Unilever_Lead__r);



        // reinitialize ALL attributes except the ones on the screen when creating new SOW

        sow_id = null;
        selected_sow = null;

        ApexPAges.currentPage().getParameters().clear();

        project_id = null;
        liso_attachments = null;
        liso_attachments_to_add = null;
        liso_notes = null;
        //Projects to the Sow
        liso_projects_for_sow = null;
        // Ids of SOW projects
        // private set<id> setIdsProject;
        isEdit = null;

        setRecordType = null;
        selectedProject = null;
        isViewProject = null;
        liso_other_non_campaign_items = null;
        seriesProject = null;
        midi_sow_id_overall_total = null;
        li_campaign_and_non_campaign_items = null;
        noteAsset = null;

        //Thousand Block Part :
        //thousandBlocks = null;
        selectedProjectId = null;
        countOfUpdatesFeed = null;
        filesCountList = null;
        //Selected count
        FileCount = null;

        allFileList = null;

        //achraf
        attachment = null;

        initializeAttributes();
        init();

        // set the VF page values
        selected_sow = selSowClone;
        sow_id = null;
    }



    public Pagereference editActionPage(){
        Pagereference editPageSOW = Page.oblix_sowcreate;
        editPageSOW.getParameters().put(sow_param_name, selected_sow.Id);
        editPageSOW.setRedirect(True);
        return editPageSOW;
    }
    /*******************************************************************
        Purpose: Delete SOW and related objects
        Parameters: none
        Returns: page reference to Dahsboard
        Throws [Exceptions]: none
    ********************************************************************/
    public PageReference deleteAction(){

        // Campaign and Non-Campaign items are Master-Detail relationship - they will be automatically deleted
        // Campaign has Assets(MD) and Splits(Lookup), so splits will have to be deleted manually
        PageReference sow_details_page = Page.oblix_sowmain;

        // get related agency splits
        try{

            //List<Oblix_Marketing_SOW_Project_Splits__c> liso_campaign_splits_to_delete = [SELECT Id FROM Oblix_Marketing_SOW_Project_Splits__c WHERE Project_Splits__r.Financial_Year__c =:selected_sow.Id];
            
            //// try to delete the children records
            //List<Database.DeleteResult> delete_result_splits = Database.delete(liso_campaign_splits_to_delete, true);
            
            //Boolean isSuccess = true;
            //for(Database.DeleteResult dr : delete_result_splits){
            //    if(!dr.isSuccess()){
            //        isSuccess = false;
            //        break;
            //    }
            //}
            
            //// only try to delete SOW if we managed to delete it's children campaign splits records
            //if(isSuccess){

                // Campaign Splits and SWOP Campaigns have master-detail so the related records will be deleted also
                Database.DeleteResult delete_result_main_campaign = Database.delete(selected_sow, true);
            //}

        // not a DML exception
        } catch (Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'There was an issue while trying to delete this SOW: ' + e.getMessage()));
        }

        return sow_details_page;
    }

    private String getRequiredFieldsErrorMessage(){
        String errorRequired = '';
        
        if (String.isBlank(selected_sow.Name)) {
            errorRequired += ' Name';
        }
        if (String.isBlank(selected_sow.BB_or_BD__c)) {
            errorRequired = (errorRequired != '' ?  errorRequired + ', ' : '') + 'BB/BD';
            // errorRequired += (errorRequired.contains('Name') ? errorRequired+', ' : 'The following fields are required : ') + 'BB/BD';
        }
        if (String.isBlank(selected_sow.Financial_Year__c)) {
            errorRequired = (errorRequired != '' ?  errorRequired + ', ' : '') + 'Financial Year';
            //errorRequired = ((errorRequired.contains('Name') || errorRequired.contains('BB')) ? errorRequired+', ' : 'The following fields are required : ') + 'Financial Year';
        }
        if (errorRequired != '') {
            errorRequired = 'The following fields are required : ' + errorRequired;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, errorRequired));
        }
        return errorRequired;

    }

    /*******************************************************************
        Purpose: used to save a New SOW
        Parameters: none
        Returns: PageReference
        Throws [Exceptions]: none
    ********************************************************************/
    public PageReference saveSOW() {
        
        String errorRequired = getRequiredFieldsErrorMessage();

        System.DEBUG('In HERE!!! : ' + selected_sow);
        try {

            // set static variable on the trigger handler to avoid setting big/small category
            Oblix_SOWHandler.b_initiated_from_vf_page = true;

            if (String.isBlank(errorRequired)){

                upsert selected_sow;
                selected_sow = getSOW(selected_sow.Id, Oblix_Utils.getAllFieldsInFieldsSet(OBJECT_SOW_TO_QUERY, FIELD_SET_SOW_MAIN_DETAIL) , null);

                sow_id = selected_sow.Id;
                
                List<Marketing_SOW__c> liso_children_sow = new List<Marketing_SOW__c>();

                //System.debug('###selected_sow.id : ' + selected_sow.id);
                liso_children_sow = [SELECT OblixSOWOverallTotal__c, Oblix_Current_FY_Total__c,Total_Campaigns_This_FY__c,OblixTotalOtherItemsFees__c 
                    FROM Marketing_SOW__c WHERE MarketingSOWParent__c = :selected_sow.id  AND Type_of_SOW__c = 'Baseline'];
                
                if (liso_children_sow != null && !liso_children_sow.isEmpty()) {
                    //System.debug('###liso_children_sow : ' + liso_children_sow );
                    midi_sow_id_overall_total.put(selected_sow.id, (Integer)liso_children_sow[0].OblixSOWOverallTotal__c);

                } else {
                    midi_sow_id_overall_total.put(selected_sow.id, 0);
                }

                if (!liso_attachments_to_add.isEmpty()) {
                    for (Attachment att : liso_attachments_to_add) {
                        att.parentId = selected_sow.id;
                    }
                    insert liso_attachments_to_add;
                }

                insertNotes();

                PageReference newSOW = new PageReference('/apex/Oblix_SOWMainDetail?sowId='+ sow_id);
                newSOW.setRedirect(true);

                return newSOW;
            }
            else{
                return null;
            }

        } catch (Exception le) {

            if (le.getMessage().contains('DUPLICATES_DETECTED')) {
                errorRequired += 'Duplicate Value Found with the same Name';
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, errorRequired));
            }
            if (le.getMessage().contains('TOO_LONG_NOTE')) {
                errorRequired += 'Your note is too long. Max length is 255 characters.';
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, errorRequired));
            }

            System.debug('The following exception has occurred: ' + le.getMessage());
        }

        isEdit = false;
        return null;
    }

    private void insertNotes(){

        if (noteAsset.body != null  && noteAsset.body.length() <= notesSize) {
            System.debug('###NoteBody size: ' + String.valueOf(noteAsset.body.length())); //&& noteAsset.id == null
            noteAsset.parentId =  selected_sow.id;
            noteAsset.title = 'NoteII';
            noteAsset.isPrivate = false;
            insert noteAsset;
            noteAsset = [select body from note where id = :noteAsset.id];
            //liso_notes.add(noteAsset);
            //noteAsset = new note();
        } else if (noteAsset.body != null && noteAsset.id == null) {
            throw new Oblix_Utils.CustomException('TOO_LONG_NOTE');
        }
    }

    public void softSaveCampaign(){
        String errorRequired = getRequiredFieldsErrorMessage();
        
        try{


            // set static variable on the trigger handler to avoid setting big/small category
            Oblix_SOWHandler.b_initiated_from_vf_page = true;
            
            if (String.isBlank(errorRequired) && selected_sow != null && selected_sow.Id == null){

                insert selected_sow;
                selected_sow = getSOW(selected_sow.Id, Oblix_Utils.getAllFieldsInFieldsSet(OBJECT_SOW_TO_QUERY, FIELD_SET_SOW_MAIN_DETAIL) , null);
            }

            uploadeAttachment(); 

        }catch(Exception le){
            if (le.getMessage().contains('DUPLICATES_DETECTED')) {
                errorRequired += 'Duplicate Value Found with the same Name';
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, errorRequired));
            }
            if (le.getMessage().contains('TOO_LONG_NOTE')) {
                errorRequired += 'Your note is too long. Max length is 255 characters.';
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, errorRequired));
            }

            //System.debug('The following exception has occurred: ' + le.getMessage());
        }
    }

    public void refreshAttachments(){
        System.Debug(liso_attachments);
        liso_attachments = new List<Attachment>();
        liso_attachments = [Select Id, Name, ParentId, Parent.Name, CreatedBy.Name, CreatedDate from Attachment where ParentId = : selected_sow.Id];
    }
    /*******************************************************************
        Purpose: Save the attachment into attachment object
        Parameters: none
        Returns: none
        Throws [Exceptions]: none
    ********************************************************************/
    public void uploadeAttachment() {
        system.debug('==============saving name = ' + attachment.name);
        system.debug('==============saving desc = ' + attachment.description);
        system.debug('==============saving File= ' + attachment.body);

        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = selected_sow.id; // the record the file is attached to
        attachment.IsPrivate = true;
        try {
            insert attachment;
             attachment= [Select Id, Name, ParentId, Parent.Name, CreatedBy.Name, CreatedDate from Attachment where Id = : attachment.Id];
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Attachment uploaded successfully'));

        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error uploading attachment'));
            //return null;
        } finally {
            if (attachment.Id != null) {
                attachment.Body = null;
                liso_attachments.add(attachment );
                attachment = new Attachment();
            }

        }

    }

    /*******************************************************************
        Purpose: Get number of chatter feeds 
        Parameters: none
        Returns: number of chatter feeds
        Throws [Exceptions]: none
    ********************************************************************/
    private Integer NumberOfSowChatterFeedItem(Id sowFeedId) {
        Integer rows = [select count() from Marketing_SOW__Feed where ParentId = : sowFeedId ];
        return rows ;

    }


    /*******************************************************************
        Purpose: Method used to redirect to the Selected Marketing sow View
        Parameters: none
        Returns: Redirection to the selected MS
        Throws [Exceptions]: none
    ********************************************************************/
    public PageReference msDetail() {
        Pagereference meNewPage = Page.Oblix_VF10_nonCampaignView;
                meNewPage.getParameters().put('MSid', selected_sow.id);
                meNewPage.setRedirect(True);
        meNewPage.setRedirect(True);
        return meNewPage;
    }

    

    /*******************************************************************
        Purpose: Cancel Action
        Parameters: none
        Returns: none
        Throws [Exceptions]: none
    ********************************************************************/
    public void cancel() {
        return;
    }

    /*******************************************************************
        Purpose: Used to redirect to the Selected Project View
        Parameters: none
        Returns: Redirection to the Project View Page
        Throws [Exceptions]: none
    ********************************************************************/
    public PageReference viewProject() {

        PageReference meNewPage ;
        List<Marketing_Basics__c > x = [select id from Marketing_Basics__c where id = :selectedProjectId limit 1]  ;
        if ( x.isempty() )  {
                meNewPage = Page.Oblix_CampaignSummary;
                meNewPage.getParameters().put('projectId', selectedProjectId);
        } else return null;
        meNewPage.setRedirect(True);
        return meNewPage;
    }

    public PageReference viewNonCampaign() {

        PageReference meNewPage ;

        meNewPage = Page.Oblix_sownoncampaigncreate;
        meNewPage.getParameters().put(sow_param_name, sow_id);
        meNewPage.getParameters().put('preSelectedName', selectedProjectId);
        System.DEBUG('preSelectedName : ' + selectedProjectId);
        meNewPage.setRedirect(True);
        return meNewPage;
    }

    /*******************************************************************
        Purpose: redirects user to non campaign page
        Parameters: none
        Returns: page reference to non campaign page creating
        Throws [Exceptions]: none
    ********************************************************************/
    public PageReference createNonCamp() {
        Pagereference meNewPage = Page.Oblix_VF09_nonCampaignEdit;
                meNewPage.getParameters().put('MSid', sow_id);
                meNewPage.setRedirect(True);
        return meNewPage;
    }

    /*******************************************************************
        Purpose: redirects user to add campaign page
        Parameters: none
        Returns: Redirection to the Project View Page
        Throws [Exceptions]: none
    ********************************************************************/
    public PageReference addProject() {
        Pagereference campaignCreatePage = Page.Oblix_CampaignCreate;
                campaignCreatePage.getParameters().put(sow_param_name, selected_sow.Id);
        return campaignCreatePage;
    }

    public PageReference addNonCampaignProject() {
        Pagereference nonCampaignCreatePage = Page.Oblix_SOWNonCampaignCreate;
        nonCampaignCreatePage.getParameters().put(sow_param_name, selected_sow.Id);
        return nonCampaignCreatePage;
    }

    /*******************************************************************
        Purpose: used to avoid Limit of Thousand Record by Repeat component
        Parameters: none
        Returns: List of Records by Block of Thousand 
        Throws [Exceptions]: none
    ********************************************************************/
    //public limitWrapper[] getThousandBlocks(List<CampaignNonCampaignItems> li_campaign_and_non_campaign_items) {
    //    //declare it above
    //    thousandBlocks = new List<limitWrapper>();

    //    Integer counter = 0;
    //    Integer loopCount = 0;
    //    list<CampaignNonCampaignItems> tmpProject = new list<CampaignNonCampaignItems>();
    //    for (Integer i = 0; i < li_campaign_and_non_campaign_items.size(); i++) {
    //        if (counter < listLimit) {

    //            if (i != li_campaign_and_non_campaign_items.size() - 1) {
    //                tmpProject.add(li_campaign_and_non_campaign_items.get(i));
    //                counter++;
    //            } else {
    //                tmpProject.add(li_campaign_and_non_campaign_items.get(i));
    //                counter++;
    //                loopCount++;

    //                thousandBlocks.add(new limitWrapper(tmpProject, loopCount));
    //                return thousandBlocks;
    //            }

    //        } else {
    //            loopCount++;
    //            thousandBlocks.add(new limitWrapper(tmpProject, loopCount));
    //            tmpProject = new List<CampaignNonCampaignItems>();
    //            tmpProject.add(li_campaign_and_non_campaign_items.get(i));
    //            counter = 0;
    //        }

    //    }

    //    if (thousandBlocks.size() == 0) {
    //        loopCount++;
    //        thousandBlocks.add(new limitWrapper(tmpProject, loopCount));
    //    }

    //    return thousandBlocks;
    //}


    /*******************************************************************
        Purpose: Wrapper class used to bypass the Limit of 1000 Record on a repeat
        Parameters: none
        Returns: List of Records by Block of Thousand 
        Throws [Exceptions]: none
    ********************************************************************/
    public class LimitWrapper {
        public  List<CampaignNonCampaignItems>  liso_projects_for_sow {get; set;}
        public Integer blockNumber {get; set;}
        public limitWrapper(List<CampaignNonCampaignItems> projectRecords, Integer i) {
            liso_projects_for_sow = projectRecords;
            blockNumber = i;
        }
    }


    /*******************************************************************
        Purpose: Add Attachment popup
        Parameters: none
        Returns: null page reference
        Throws [Exceptions]: none
    ********************************************************************/
    public Pagereference SaveAttachments() {

        //Attachment a = new Attachment(parentId = accid, name=myfile.name, body = myfile.body);
        for (Attachment a : allFileList) {
            if (a.name != '' && a.name != '' && a.body != null)
                {liso_attachments_to_add.add(new Attachment(name = a.name, body = a.body)) ;}
        }

        return null;
    }

    /*******************************************************************
        Purpose: calculates the number of attachements
        Parameters: none
        Returns: null page reference
        Throws [Exceptions]: none
    ********************************************************************/
    public PageReference changeCount() {
        allFileList.clear() ;
        
        //Adding multiple attachments instance
        for (Integer i = 1 ; i <= Integer.valueOf(FileCount) ; i++)
            allFileList.add(new Attachment()) ; 
        
        return null ;
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

        public CampaignNonCampaignItems(String object_type, SObject campaign_non_campaign, Boolean hasEditAccess) {
            
            s_object_type = object_type;
            dynamic_object = campaign_non_campaign;

            // initialise StageIdentifier if it is a campaign type
            if ('Campaign' == object_type){
                //system.debug('##campaign_non_campaign: ' + campaign_non_campaign);
                stage_identifier = new Oblix_CampaignStageLogic((Oblix_SOW_Projects__c) campaign_non_campaign, hasEditAccess,hasEditAccess);
            }
        }
    }

    /*******************************************************************
        Purpose: remove attachment
        Parameters: none
        Returns: none
        Throws [Exceptions]: none
    ********************************************************************/
    @RemoteAction
    public static void removeAttachments(List<String> attachmentsToRemove) {
        if (!attachmentsToRemove.isEmpty()) {
            try {
                delete [SELECT Id FROM Attachment WHERE Id IN :attachmentsToRemove];
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Attachment uploaded successfully'));

            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error removing attachment'));
            }
        }
    }

    /*******************************************************************
        Purpose: Sets the Big and Small categories when a CategoryBrand 
                 is found for a selected SOW brand. If no categories are found, 
                 sets lookups to null; If more than one is found, sets from first in the list
        Parameters: none
        Returns: none
        Throws [Exceptions]: none
    ********************************************************************/
    public void getCategoryBrand(){
        
        List<MDO_CategoryBrands__c> categoryBrandList = [SELECT Id, product_Category_Id__r.Id, product_Category_Id__r.Name
            , product_Category_Id__r.parent_L2__r.Id, product_Category_Id__r.parent_L2__r.Name 
            FROM MDO_CategoryBrands__c WHERE brand_id__c =:selected_sow.OblixBrand__c];
        
        System.debug('numberOfCategoryBrands: ' + categoryBrandList.size());
        
        if(categoryBrandList.size() == 0){
            
            // no categories for this brand.
            selected_sow.BigOblixProductCategory__r = null;
            selected_sow.BigOblixProductCategory__c = null;
            selected_sow.SmallProductCategory__r = null;
            selected_sow.SmallProductCategory__c = null;
            
        } else {
            
            // one or more categories exist for this brand. If more than one, select first from the list
            selected_sow.BigOblixProductCategory__r = categoryBrandList[0].product_Category_Id__r.parent_L2__r;
            selected_sow.BigOblixProductCategory__c = categoryBrandList[0].product_Category_Id__r.parent_L2__c;
            selected_sow.SmallProductCategory__r = categoryBrandList[0].product_Category_Id__r;
            selected_sow.SmallProductCategory__c = categoryBrandList[0].product_Category_Id__c;
            
        }
        
    }

    /*******************************************************************
        Purpose: gets the folder id for the reports
        Parameters: none
        Returns: page reference standar page
        Throws [Exceptions]: none
    ********************************************************************/
    public static PageReference reportFolderURL {
        get{
            
            if(reportFolderURL == null){
                
                List<Folder> reportFolderIdList = [SELECT Id FROM Folder WHERE Name =: Oblix_Constants.SWOPReportFolder];
                if(!reportFolderIdList.isEmpty()){
                    reportFolderURL = new PageReference('/' + reportFolderIdList[0].Id);
                }
                
            }
            
            return reportFolderURL;
            
        } set;
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
                selected_sow = getSOW(sow_id, Oblix_Utils.getAllFieldsInFieldsSet(OBJECT_SOW_TO_QUERY, FIELD_SET_SOW_MAIN_DETAIL) , null);
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
                selected_sow = getSOW(sow_id, Oblix_Utils.getAllFieldsInFieldsSet(OBJECT_SOW_TO_QUERY, FIELD_SET_SOW_MAIN_DETAIL) , null);
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