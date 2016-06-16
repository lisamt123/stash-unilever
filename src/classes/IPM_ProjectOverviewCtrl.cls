/****************************************************************************************************************************
    @Description: Single page controller class for the Project Overview Ctrl
    @Change Log - Samrat: Change date time to date as per VD of stopping projects
                  Samrat: Changed Stopping Logic on line 117\
                  Nitish: Added format() to Date/DateTime at line 506 and line 520 to display date as per user's locale
    @Author: Cognizant Technology
    @Date: Jan 2015
    Sonar issue : (Avoid really long classes.)
    comment :This controller class handles the complex logic of showing alerts and notifications in header, project summary, all the sections and To-do's
    associated to logged-in user's functional role, BET code, project's history and chatter posta in Recent Activiites column, due to which class size has been increased. 
*/
public with sharing class IPM_ProjectOverviewCtrl extends IPM_ProjectIntermediateController {

    public IPM_ProjectOverviewCtrl() {
        //class Constructor 
    }
    public Map<String, String> BusinessCaseMessageMap{get;set;}
    public List<IPM_Project__History> lstprojecthistory {get;set;} //variable to identify if the project is fast track
    public String lstalertMessage {get;set;} //alert message for the fast track
    public List<String> lstFinAlertMessage {get;set;} //Alert message for financial misalignment
    public List<String> lstRolloutProjectAlertMessage {get;set;} //Alert message for Rollout local projec leader is blank
    public List<String> lstFinTLDAlertMessage {get;set;} //Alert message for financial TLD misalignment
    public List<String> lstFinDataMissingAlertMessage {get;set;} 
        public List<String> LstLocalFinTLDMisalignedMessage {get;set;} //Alert message for financial TLD misalignment
    public IPM_Task__c[] tasksList{get;set;}//list of tasks to be made displayed
    public Integer noOfNotifications{get;set;}//number of notifications that a page can display
    public IPM_Project_Document__c projectDoc{get; set;}//current gate document that the project is associated with
    private String currPhase;//current phase
    public boolean IsUpdateStatus{get;set;}//used by security analysis
    public String stoppedMsg{get;set;}//if the project is stopped
    public String gateDateAlert{get;set;}//notification related to Gate Doc due date
    public String currGate{get;set;}//current gate of the project
    public String currGateToDisplay{get;set;}//current gate of the project with appeneded 'in' lieteral to display on Overview page
    public String unApprovedCurrGate{get;set;}//if the gate is unapproved
    public IPM_Milestone__c milesTone{get;set;}//standard milestone associated to the gate
    public IPM_Project__c project {get;set;}//project record details sobject
    public String projectId {get;set;}//project id variable
    public Map<String,String> alertMessage { get; set; }  // To get the Alert Message
    public Map<String,String> alertMessageToday { get; set; }  // To get the Alert Message
    public Map<String,String> alertMessagePast { get; set; }  // To get the Alert Message
    public String documentAlertMessage {get;set;}  //To get the document status change alert messages
    public List<String> additionalAlertMessages {get;set;}
    public integer alertscount {get;set;}  // Used for no of alerts displayed on UI
    public boolean dueDateMsg{get;set;}
    public boolean dueDateMsgToday{get;set;}
    public boolean dueDateMsgPast{get;set;}
    public string ProName{get;set;}
    public string gateName{get;set;}
    public List<IPM_Task__c> tasks ;
    public Integer noOfRecords{get; set;} //Total number of records used for pagination
    public Integer size{get;set;} //page size
    public string gateDueDateMessage{get;set;}
    public boolean isProjLeader{get;set;}
    public List<IPM_Project_Rollout__c> lstprojectRollout{get;set;}
    public boolean isAcessDuetoTeam{get;set;}
    private static final String DATEFORMAT='dd MMMM yyyy';

    /****************************************************************************************************************************
    * internal set variables for all the associated project documents, sections, tasks & milestones ids
    */
    private Set<String> projectDocsSet;
    private Set<String> projectTasksSet;
    private Set<String> projectMSSet;
    private Set<String> projectSectionsSet;
    public List<IPM_Project_Document_Section__c> projectSections {get;set;}//list of assigned project sections
    public Integer allIncompleteTasks {get;set;}//incomplete tasks for the current users
    public String taskId{get;set;}//task id component which requires completion
    public String isChecked{get;set;}//if this task is checked
    public sObject projSectionList{get; set;} //generic sObject for the project section list
    public Integer remainingDays{get;set;}//number of days that the current date is due for the current gate.
    public Integer betFirstReleaseDueDate{get;set;}//number of days that the current date is due for first release BET.
    public Integer betFinalReleaseDueDate{get;set;}//number of days that the current date is due for final release BET.
    public String betMsgFirstReleaseDueDate{get;set;}//BET due date first release message
    public String betMsgFinalReleaseDueDate{get;set;}//BET due date final release message
    public objectHistoryWrapper[] activityHistory {get;set;} //all the chatter feed & activity history will be stored in this wrapped list
    public Boolean Taskeditable{get;set;}//used by security
    public DateTime stoppedDate{get;set;}//when was the project stopped if any
    public list<IPM_Project__c>lstofuser{get;set;}//get user type from project
    public Decimal globalyearDec{get;set;}//hold global year value
    public String globalbusinessImpactStr{get;set;}//hold global business impact
    public String regionalORlocalBusinessImpactStr{get;set;}//hold regional or local business impact
    public static final String BLANK_STR = '';
    public static final String TASK_SOBJECTNAME = 'IPM_Task__History';
    public static final String DOCUMENT_SEC_HISTORY_SOBJECTNAME = 'IPM_Project_Document_Section__History';
    public static final String SDOC_HISTORY_OBJNAME  = 'IPM_Project_Document__History';
    public static final String SMILESTONE_HISTORY_OBJNAME  = 'IPM_Milestone__History';
    private static final String PLANNED_STR= 'The planned ';
    public static final String KEY_FINANCE_STR = 'Key Financial Data is missing. Please update your business case: ';
    private static final String GATE_STR='gate';

    public String projectDocStatusStyleClass{get;set;}

    public Map<String, String> objectFldMap = new Map<String, String>{
                                              TASK_SOBJECTNAME => 'IPM_Completed__c,IPM_Task_Name__c,IPM_Task_Complexity__c,IPM_Assignee__c,IPM_Task_Type__c',
                                              DOCUMENT_SEC_HISTORY_SOBJECTNAME => 'IPM_Section_Name__c,IPM_Section_Owner__c,IPM_Section_Status__c',
                                              SDOC_HISTORY_OBJNAME => 'IPM_Document_Status__c,IPM_Approval_Date__c',
                                              SMILESTONE_HISTORY_OBJNAME => BLANK_STR};//internal map to store the objects with fields to capture activity history
    public Map<String, String> objectAddtnlFldsMap = new Map<String, String>{
                                              TASK_SOBJECTNAME => 'Parent.IPM_Task_Name__c',
                                              DOCUMENT_SEC_HISTORY_SOBJECTNAME => 'Parent.IPM_Project_Section__c',
                                              SDOC_HISTORY_OBJNAME => 'Parent.IPM_GateDocuments__c',
                                              SMILESTONE_HISTORY_OBJNAME => 'Parent.IPM_Name__c'
                                                                     };//additional fields if any per object mentioned
    
    public static final String STR_PARENTID = 'ParentId';
    public static final String STR_OLDVALUE = 'OldValue';
    public static final String STR_NEWVALUE = 'NewValue';
    public static final String STR_CREATEDBY = 'CreatedById';
    public static final String STR_FIELD = 'field';
    private static final String SPACE = ' ';
    
    private static final string CLASS_NAME = IPM_ProjectOverviewCtrl.class.getName();
    public List<IPM_Milestone__c> rolloutProjectRecentMilestone {get;set;}
    List<IPM_Project_Resource__c> projResList = New List<IPM_Project_Resource__c> ();
    List<IPM_Project_Resource__c> projResCompleteList = New List<IPM_Project_Resource__c> ();
    public ApexPages.StandardSetController con{get;set;}
    public String betInformationMessage {get;set;}//Contains the BET message to display
    public BET_BETWrapper betWrapper {get;set;}//Contains BET details
    public User  betOwner {get;set;}//Contains BET owner details
    public String hasBETAccess{get;set;} //Defines user access on BET
    public Boolean isIdeasPhase{get;set;}//Defines if project is in ideas phase
    @TestVisible private Boolean bPaginated = false;
    public boolean isExemptFromThresholdITO{get;set;}//check if the project is eligible to set Exempt From Threshold iTO
    public boolean showSuggestedMembers {get;set;}//Defines if suggested members button is available
    public List<Id> suggestedMembersList {get;set;}//List of functional team members to be passed to BET
    public List<BET_MemberBucketWrapper> memberBucketList {get;set;}//Map of functional team members to be passed to BET
    public List<id> suggestedManagerList {get;set;}//List of managers to be passed to BET
    public Boolean showBET{get;set;}//Defines if BET is available for the project
    public String toolkitOption {get;set;}//Specifies the related Toolkit option
    public String requestedBETId{get;set;}  //Specifies ID of BET with which link is requested
    public id BETId{get;set;}//Specifies Id of related BET
    public Id projectWithBET;//Specifies ID of project with BET
    public Boolean isOriginal{get;set;}//Specifies if its an original project
    public Boolean memberCallFromURL{get;set;}//Specifies if suggested member call is from URL
    //IPM BET changes
    public id categryId{get;set;}
    public id CategoryGroupId{get;set;}
    public id BrandPositionId{get;set;}
    public Map<Id,Date>ProjDueDateMap = new Map<Id,Date>();
    //For Incomplete Child Project Alert Message
    public String childProjectsIncompleteAlert{get; set;}
    public String ecoDesignAlert {get;set;}
    public String ecoDesignSecId {get;set;}
    public Static final String ENVIRONMENTAL_IMPACT = 'Environmental_Impact';
    public boolean rolloutsGenerated {get;set;} //Eco Design
    public boolean bShowAlertsBar{get;set;}//variable to show/hide Alerts
    public boolean bShowShipToTradeButton{get;set;}//variable to show Ship to trade button
    public boolean bShowChangeStatusButton{get;set;}//variable to show Change Status button
    public boolean bPhaseChangeInProgress{get;set;}//variable to check if phase change is in progress or not
    public string earliestTLD=null;//DEF3195 Mukul to review
    public String projectPriority{get;set;}//varibale to show project priority for local rollout projects
    
    //SD constructor
    public IPM_ProjectOverviewCtrl(IPM_ProjDocumentSectionHstryController controller) {
       
        //variables/properties initialisation
        noOfNotifications = 0;
        alertscount=0;
        taskId = BLANK_STR;
        betInformationMessage = BLANK_STR;
        projectPriority = null;
        betOwner = new User();
        allIncompleteTasks = 0;
        IsUpdateStatus=false;
        isProjLeader = false;
        isOriginal = false;
        toolkitOption = BLANK_STR;
        hasBETAccess = System.label.IPM_BETRequestNo;
        memberCallFromURL = false;
        showBET= false;
        isIdeasPhase = false;
        bShowAlertsBar = false;
        bShowShipToTradeButton = false;
        bShowChangeStatusButton = false;
        bPhaseChangeInProgress = false;
        projectDocsSet = new Set<String>();
        projectTasksSet = new Set<String>();
        projectMSSet = new Set<String>();
        projectSectionsSet = new Set<String>();
        isExemptFromThresholdITO=false;
        ProjDueDateMap = new Map<Id,Date>();
        additionalAlertMessages = new List<STring>();
        projectSections = new List<IPM_Project_Document_Section__c>();
        projectId = ApexPages.currentPage().getParameters().get('id');
        showSuggestedMembers = false;
        suggestedMembersList = new List<Id>();
        suggestedManagerList = new LisT<Id>();
        memberBucketList = new List<BET_MemberBucketWrapper>();
        rolloutsGenerated = false;//Eco Design
        lstprojecthistory=[SELECT ParentId,Parent.Name,Parent.IPM_Fast_Track_Project__c 
                           FROM IPM_Project__History 
                           WHERE Field =:IPM_ConstantUtils.FAST_TRACK_FIELD AND ParentId=:projectId AND 
                                 CreatedDate >=: System.today()-IPM_ConstantUtils.CONST_7 limit 10000];

        if(!lstprojecthistory.isEmpty()){
            for(IPM_Project__History history:lstprojecthistory){
                if(history.Parent.IPM_Fast_Track_Project__c){
                    lstalertMessage=Label.IPM_FastTrack;

                }else{
                    lstalertMessage=Label.IPM_No_FastTrack;

                }
                noOfNotifications=1;
            }
        }
        
        isAcessDuetoTeam=false;
        lstofuser=new list<IPM_Project__c>();
        lstofuser=[SELECT Name,IPM_Phase__c,Deputy_Project_Leader__c,IPM_Project_Leader__c,IPM_Project_Gatekeeper__c,IPM_Technical_Project_Leader__c,IPM_Finance_Member__c FROM IPM_Project__c 
                                       WHERE Id=:projectId  limit 1];
         if(lstofuser!=null && !lstofuser.isEmpty()) {
            if((lstofuser[0].IPM_Project_Leader__c ==userinfo.getuserid() && lstofuser[0].IPM_Project_Leader__c !=null)||
             (lstofuser[0].Deputy_Project_Leader__c==userinfo.getuserid() && lstofuser[0].Deputy_Project_Leader__c !=null) ){
               IsUpdateStatus=true; 
               isProjLeader = true;
            }
            if(lstofuser[0].IPM_Project_Leader__c != null){
                suggestedManagerList.add(lstofuser[0].IPM_Project_Leader__c);
            }
            if(lstofuser[0].Deputy_Project_Leader__c != null && lstofuser[0].Deputy_Project_Leader__c != lstofuser[0].IPM_Project_Leader__c){
                suggestedManagerList.add(lstofuser[0].Deputy_Project_Leader__c);
            }
            if((lstofuser[0].IPM_Project_Leader__c ==userinfo.getuserid() && lstofuser[0].IPM_Project_Leader__c !=null)||
             (lstofuser[0].Deputy_Project_Leader__c==userinfo.getuserid() && lstofuser[0].Deputy_Project_Leader__c !=null) || (lstofuser[0].IPM_Project_Gatekeeper__c ==userinfo.getuserid() && lstofuser[0].IPM_Project_Gatekeeper__c !=null)||
             (lstofuser[0].IPM_Technical_Project_Leader__c==userinfo.getuserid() && lstofuser[0].IPM_Technical_Project_Leader__c !=null) || (lstofuser[0].IPM_Finance_Member__c==userinfo.getuserid() && lstofuser[0].IPM_Finance_Member__c !=null) ){
             isAcessDuetoTeam=true;
            }
        }
        
        //security for central team and BP users
        IPM_CustomPermission cpr = new IPM_CustomPermission();
        boolean isCentralTeam=false;
        boolean isBPUser=false;
        isCentralTeam = cpr.hasPermission(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
        isBPUser=cpr.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
        if(isCentralTeam || isBPUser){

             IsUpdateStatus=true; 
             isProjLeader = true;
        }    
        
        
       List<IPM_Task__c> tskList = [SELECT Id FROM IPM_Task__c WHERE IPM_Project__c = :projectId LIMIT 50000];
       projSectionList = (tskList!=null && !tskList.isEmpty()) ? tskList[0] : new IPM_Task__c();
       
       
       IPM_Project__c projObj = IPM_Utils.getCurrentPhase(projectId);
       if(!Test.isRunningTest()){
           currPhase = projObj.IPM_Phase__c;
       }
       else{
           currPhase = projObj.IPM_Temporary_Phase__c;
       }
       init();
       
       // Adding Alert for Local Project leader is blank for rollout Projects
       lstRolloutProjectAlertMessage = new List<String>();
       if(project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT)
       {
            lstprojectRollout = [SELECT ID,Name,IPM_Regional_PL__c FROM IPM_Project_Rollout__c where Regional_Project__c = : project.id limit 50000];
            for(IPM_Project_Rollout__c rollOutProject : lstprojectRollout){
                if(String.isBlank(rollOutProject.IPM_Regional_PL__c) || rollOutProject.IPM_Regional_PL__c == null)
                {
                    lstRolloutProjectAlertMessage.add(String.format(Label.IPM_Local_Project_Leader_BlankMsg,new List<String>{rollOutProject.Name}));
                    noOfNotifications++;
                }
            }
       } 
       
       currGateToDisplay = BLANK_STR;
       // get the current project type
       IPM_Project_Type__c currentProjecttype =  IPM_Utils.retrieveProjectType(project);
       if(currentProjecttype != null && currentProjecttype.IPM_Gate_Document__c != null){
           currGateToDisplay = Label.IPM_IN + IPM_ConstantUtils.IPM_SPACE +   currentProjecttype.IPM_Gate_Document__c;
       }
       
       /**********************************************************
       Logic to set boolean variable bShowAlertsBar in order to show/hide Alerts
       if alert/notifications are not present or phase change is in progress, then don't show alerts
       ***********************************************************/
       
       if(project.IPM_Project_Job_Status__c != IPM_ConstantUtils.JOB_STATUS_ELIGIBLE && project.IPM_Project_Job_Status__c != IPM_ConstantUtils.JOB_STATUS_PROCESSING ) 
       {    
            bPhaseChangeInProgress = false;
            
            if( (noOfNotifications != null && noOfNotifications >= 1) || (alertscount != null && alertscount >=1) )
            {
            	bShowAlertsBar = true;
            }	
            else 
            {
            	bShowAlertsBar = false;
            }	
        }
        else
        {
            bPhaseChangeInProgress = true;
            bShowAlertsBar = false;
        }
        
        /**********************************************************
    Logic to set boolean variable bShowShipToTradeButton in order to show Ship to Trade button 
    when original project is in Market deployment phase / operational project in Market Ready phase
    ***********************************************************/     
        if( (( projectDoc != null && projectDoc.IPM_Document_Status__c == IPM_ConstantUtils.STATUS_APPROVED && project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL && project.IPM_Phase__c == IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE) || 
                (project.IPM_Phase__c == IPM_ConstantUtils.MARKET_READY_GATE && project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL) ) && IsUpdateStatus )
        {
        	bShowShipToTradeButton = true;
        }	
        else
        {
        	bShowShipToTradeButton = false;
        }	
        
        /**********************************************************
    Logic to set boolean variable bShowChangeStatusButton in order to show Change Status button 
    ***********************************************************/     
        if( ( projectDoc != null && projectDoc.IPM_Document_Status__c != IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED && projectDoc.IPM_Document_Status__c != IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS && 
                    projectDoc.IPM_Document_Status__c != IPM_ConstantUtils.STATUS_NOT_STARTED && projectDoc.IPM_Document_Status__c != IPM_ConstantUtils.DOCUMENT_STATUS_STOPPED && project.IPM_Phase__c != IPM_ConstantUtils.PHASE_PLE ) && IsUpdateStatus)
        {
 	       bShowChangeStatusButton = true;
        }   
        else{
        	bShowChangeStatusButton = false;
        }
        
    }
    
    //DEF3195-Earliest Target Launch is not displayed on overview page
    public string getEarlTLD(){
        return earliestTLD;
    }

    /*******************************************************************************************************
    * @description: initial method which actually retrieves information for all the columns mentioned in the project overview page
    */
    private void init() {
        /*
        * retreiving the selective project details with all its associated related lists like PD, PS, Tasks & Milestones
        */
        project = [SELECT Rollout_Plan_Target_Launch_Date__c,name,IPM_Project_Type__c,Exempt_from_Threshold__c,IPM_Parent_Project__r.BET_Link_Requested__c,IPM_Stopped_Date_Time__c,IPM_Project_Stopped_By__c,IPM_Stopped_Comments__c, IPM_Project_Name__c, IPM_Target_Launch_Dates__c, IPM_Complexity__c, IPM_Parent_Project__r.IPM_Parent_Project__c,Bulk_BET_Member_Request__c,IPM_Parent_Project__r.IPM_Parent_Project__r.BET_Denied_BET_Link__c,
        IPM_PM_Approach__c,IPM_Project_Leader__r.Name, IPM_Project_Gatekeeper__r.Name, IPM_Project_Description__c, IPM_Stopped_Phase__c,Is_Archieved__c, IPM_BET_Toolkit__c,BET__c,IPM_Parent_Project__r.IPM_Parent_Project__r.BET_Link_Requested_on_Date__c,IPM_Parent_Project__r.BET_Denied_BET_Link__c,
        IPM_Project_Leader__r.SmallPhotoUrl, IPM_Project_Gatekeeper__r.SmallPhotoUrl,IPM_Brand__c,IPM_Stopped_By__c,IPM_Phase__c,IPM_Fast_Track_Project__c,BET_Link_Requested__c,IPM_CompanyCardText__c ,IPM_ProjectSubType__c,IPM_Parent_Project__r.BET_Link_Requested_on_Date__c,BET_Denied_BET_Link__c,
        IPM_Stopped_By__r.Name,IPM_UserCategory__c, IPM_Sub_Category__c, IPM_FilledIn_Percentage__c,IPM_Category_Text__c,IPMProject_Span__c,IPM_Project_Logo__c,IPM_Parent_Project__r.BET__c,IPM_Parent_Project__r.IPM_BET_Toolkit__c,BET_Link_Requested_on_Date__c,
        IPM_Clustering__r.Name, IPM_Brand_Positioning__c,IPM_White_Space_Project__c,IPM_Bosscard_Status__c,IPM_Bosscard__c,IPM_Gatekeeping_Model__c,IPM_Category__r.name,IPM_Parent_Project__r.IPM_Parent_Project__r.BET__c,IPM_Parent_Project__r.IPM_Parent_Project__r.IPM_BET_Toolkit__c,
        IPM_Category_Icon__c,IPM_Target_Launch_Date__c,IPM_Parent_Project__c,IPM_Parent_Project__r.name, IPM_Project_Leader__c, IPM_Technical_Project_Leader__c, 
        Deputy_Project_Leader__c, IPM_Finance_Member__c, IPM_Project_Gatekeeper__c,BET_MS_Final_Release_Date__c,BET_MS_First_Release_Date__c,BET_TLD_Final_Release_Date__c,BET_TLD_First_Release_Date__c,
        IPM_Parent_Project__r.IPM_Target_Launch_Dates__c,IPM_Parent_Project__r.IPM_Project_Name__c,IPM_SourceProjectType__c,
        IPM_Exists_AtLeast_OneAssmntPerEICountry__c,IPM_Temporary_Phase__c,   IPM_Parent_Project__r.IPM_Parent_Project__r.BET_Link_Requested__c,EcoDesign_Sync_Status__c, IPM_Global_Project_Id__c, IPM_Project_Job_Status__c,
        (SELECT IPM_Task_Name__c, IPM_Due_Date1__c, IPM_Task_Type__c, IPM_Project_Document_Section__r.IPM_Section_Sequence__c,
        IPM_Project_Document_Section__r.IPM_Section_Name__c, IPM_Completed__c, IPM_Completed_Date__c,IPM_Project_Document_Section__c,IPM_Active__c,
        IPM_Project__c
        FROM Tasks__r 
        WHERE IPM_Assignee__c = :UserInfo.getUserId() AND IPM_Phase__c = :currPhase AND IPM_Active__c=TRUE
        ORDER BY IPM_Due_Date1__c limit 10000),
        (SELECT id,name,IPM_Project__c from IPM_Countries__r limit 10000),
        (SELECT IPM_Project__c ,IPM_Project_Template__r.IPM_Template_Complexity__c,LastModifiedBy.Name,IPM_GateDocuments__c,
        IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,
        LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c
        From Project_Documents__r limit 10000),
        (SELECT IPM_Phase__c,IPM_Project__c, IPM_Type_of_gate__c,IPM_Due_Date__c,IPM_Type_of_Milestone__c FROM IPM_Milestones__r limit 10000)
        ,(SELECT Global_External_Id__c ,Year_3_iTO_Global__c,Business_Impact_Global__c,Business_Impact_Regional__c, Regional_External_Id__c FROM IPM_Financials_Consolidated__r WHERE (Global_External_Id__c=:lstofuser[0].Name) limit 10000)
        ,(SELECT ipm_cpp_local__c from IPM_Financials_Local__r where Financial_External_ID__c =: lstofuser[0].name limit 1)
        ,(SELECT ipm_cpp_regional__c from IPM_Financials_Regional__r where Financial_External_ID__c =: lstofuser[0].name + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE limit 1)//Note: For Local project, Financial record without consilidate suffix will be used but for Regional as it will always have consolidation, record with _Consolidate will be used.
        ,(SELECT Id,IPM_Target_Launch_Dates__c,IPM_Project_Name__c,Rollout_Plan_Target_Launch_Date__c,IPM_Temporary_Phase__c  from IPM_Projects__r),
        (SELECT Id, IPM_Project__c,IPM_Project_Role_Owner__c,IPM_User__c,IPM_Role_Type__c FROM IPM_Project_Resources__r 

                             limit 10000)
                             FROM IPM_Project__c 
                             WHERE Id =:projectId];
                            
         if(project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT && project.IPMProject_Span__c == IPM_ConstantUtils.ROLLOUT_SPAN_LOCAL && !project.IPM_Financials_Local__r.isEmpty())
            projectPriority = project.IPM_Financials_Local__r[0].ipm_cpp_local__c;
<<<<<<< HEAD


=======
         }
         //CR0405-New CPP for Local rollouts. When local project priority is null ie financials are not created, 
         // regional numbers will be used to calculate priority
         if(projectPriority==null && project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT && project.IPMProject_Span__c == IPM_ConstantUtils.ROLLOUT_SPAN_REGIONAL && !project.IPM_Financials_Regional__r.isEmpty())
         {
            projectPriority = project.IPM_Financials_regional__r[0].ipm_cpp_regional__c;
         }
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
         projResCompleteList = project.IPM_Project_Resources__r;
         for(IPM_Project_Resource__c res : projResCompleteList){
 	      if(IPM_ConstantUtils.IPM_ROLE_SUPPLY_CHAIN.equals(res.IPM_Role_Type__c)){
                res.IPM_Role_Type__c=IPM_ConstantUtils.FUNCTIONAL_ROLE_SC;  
            }
            if(res.IPM_User__c == UserInfo.getUserId()){
                projResList.add(res);
                isAcessDuetoTeam=true;
<<<<<<< HEAD
            }   
         }
         //projResList =  project.IPM_Project_Resources__r;      
           if(project.IPM_Projects__r != NULL && project.IPM_Projects__r.size() > 0){          
            rolloutProjectRecentMilestone = [SELECT Id, IPM_Project__c, IPM_Project__r.Name, IPM_Type_of_gate__c, IPM_Due_Date__c 
=======
                if(res.IPM_Project_Role_Owner__c){
                   plFunctionalRoleSet.add(res.IPM_Role_Type__c);//get PL functional roles as team member
                }
            }   
        
        	functionalRoleSet.add(res.IPM_Role_Type__c); // IPM_Role_Type__c will give functional role 
        }
        
              
        //projResList =  project.IPM_Project_Resources__r;      
        if(project.IPM_Projects__r != NULL && !project.IPM_Projects__r.isEmpty()){          
            rolloutProjectRecentMilestone = [SELECT Id, IPM_Project__c, IPM_Project__r.Name,IPM_Name__c,IPM_Type_of_gate__c, IPM_Due_Date__c ,IPM_Project__r.Is_Archieved__c
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
                                                                  from IPM_Milestone__c
                                                                  where IPM_Project__r.IPM_Parent_Project__c =: projectId 
                                                                  AND IPM_Due_Date__c != NULL AND IPM_Due_Date__c >= TODAY
                                                                  AND IPM_Completed_On__c = null 
                                                                  AND IPM_Phase__c != : IPM_ConstantUtils.PHASE_MARKET_DEPLOYMENT
                                                                  ORDER BY IPM_Due_Date__c asc, IPM_Project__r.IPM_Target_Launch_Dates__c asc limit 1]; 
             if(rolloutProjectRecentMilestone != null && !rolloutProjectRecentMilestone.isEmpty()){
                gateDueDateMessage = string.format(System.Label.IPM_GateDueDateMesg, new string[] {String.valueof(rolloutProjectRecentMilestone[0].IPM_Name__c)});
             }                                                  
         }                
         if(projResList != NULL && projResList.isEmpty() && project.IPM_Project_Leader__c != UserInfo.getUserId() && project.IPM_Technical_Project_Leader__c != UserInfo.getUserId()
            && project.Deputy_Project_Leader__c != UserInfo.getUserId() && project.IPM_Finance_Member__c != UserInfo.getUserId() && project.IPM_Project_Gatekeeper__c != UserInfo.getUserId()){
            rolloutProjectRecentMilestone = null;
         }
         else if( project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && project.IPM_Phase__c ==  IPM_ConstantUtils.PHASE_IDEAS){
                  rolloutProjectRecentMilestone = null;
          }  
         else if(project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){
                if(project.IPM_Phase__c  ==  IPM_ConstantUtils.PHASE_IDEAS ||  project.IPM_Phase__c  ==  IPM_ConstantUtils.PHASE_FEASIBILITY || project.IPM_Phase__c  ==  IPM_ConstantUtils.PHASE_CAPABILITY){
                    rolloutProjectRecentMilestone = null;
                }
         }
        
        //DEF3195-Earliest Target Launch is not displayed on overview page
        list<IPM_Project_Rollout__c> ro = [select Target_Launch_Date__c from IPM_Project_Rollout__c where IPM_Regional_Rollout_Status__c=:IPM_ConstantUtils.ROLLOUT_LEADER and (IPM_Project__c=:project.id or Regional_Project__c=:project.id)];
        if(ro!=null && ro.size()>0){
            if(ro[0].Target_Launch_Date__c!=null){
                earliestTLD = ro[0].Target_Launch_Date__c.format();
            }           
        }
         
        stoppedDate= project.IPM_Stopped_Date_Time__c!= null ? project.IPM_Stopped_Date_Time__c: null;
        // get the stopped date ipm ProjectCancel Page
        for(IPM_Project_Document__c eachDoc : project.Project_Documents__r) {
            projectDocsSet.add(eachDoc.Id);
            if(IPM_Utils.phaseGateDocumentMap.containsKey(currPhase)) {
                currGate = IPM_Utils.phaseGateDocumentMap.get(currPhase);
                if(eachDoc.IPM_Document_Status__c != IPM_ConstantUtils.STATUS_APPROVED) {
                    unApprovedCurrGate = IPM_Utils.phaseGateDocumentMap.get(currPhase);
                }
                projectDoc = eachDoc;
            }
        }
      /*projectDocStatusStyleClass = projectDoc.IPM_Document_Status__c == IPM_ConstantUtils.STATUS_NOT_STARTED ?  'greyFont'  
                                                        : projectDoc.IPM_Document_Status__c == IPM_ConstantUtils.DOCUMENT_STATUS_STOPPED ?  IPM_ConstantUtils.IPM_BOSS_CSS_STOPPED 
                                                        : (projectDoc.IPM_Document_Status__c == IPM_ConstantUtils.STATUS_IN_PROGRESS || projectDoc.IPM_Document_Status__c == IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED || projectDoc.IPM_Document_Status__c == IPM_ConstantUtils.DOCUMENT_STATUS_POSTPONED) ? IPM_ConstantUtils.IPM_BOSS_CSS_STATUS 
                                                        : (projectDoc.IPM_Document_Status__c == IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED || projectDoc.IPM_Document_Status__c == IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS ) ? IPM_ConstantUtils.IPM_BOSS_CSS_COMPLETED
                                                        : IPM_ConstantUtils.BLANK;
        */  
        //process for milestone RL
        for(IPM_Milestone__c eachMS : project.IPM_Milestones__r) {
          ProjDueDateMap.put(eachMS.IPM_Project__c,eachMS.IPM_Due_Date__c);
            if(eachMS.IPM_Phase__c == currPhase && eachMS.IPM_Type_of_Milestone__c == IPM_ConstantUtils.STANDARD) {
                milesTone = eachMS;
            }else {
                milesTone = new IPM_Milestone__c();
            }
            projectMSSet.add(eachMS.Id);
        }
        tasksList = new list<IPM_Task__c>();
        //get financial details
        globalyearDec=0.0;
        globalbusinessImpactStr=BLANK_STR;
        //regionalORlocalBusinessImpactStr = BLANK_STR;
        Map<Id,Decimal> projIdiTOMap =  new Map<Id,Decimal>();
        
        // Get project it and iTO value map
        projIdiTOMap = IPM_Utils.createProjectITOValueMap();
        if(projIdiTOMap != null && !projIdiTOMap.isEmpty() && projIdiTOMap.containsKey(project.id)){
            globalyearDec = projIdiTOMap.get(project.id);
        }

        if((((IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(project.IPMProject_Span__c)&&(IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL.equalsIgnoreCase(project.IPM_Project_Type__c))) || (IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c)&&(IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL.equalsIgnoreCase(project.IPM_Project_Type__c))) || (IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c)&&(IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT.equalsIgnoreCase(project.IPM_Project_Type__c)))) && (project.Exempt_from_Threshold__c))){
            isExemptFromThresholdITO = true;
        }

        //get global impact value for project      
        globalbusinessImpactStr='';
<<<<<<< HEAD
        /*KEEP THE BELOW CODE TO CHECK IMPACT OF NEW CHANGE.
        for(IPM_Financial__c fin:project.IPM_Financials_Consolidated__r){
            globalbusinessImpactStr+='1';
            if(fin.Global_External_Id__c==lstofuser[0].Name && fin.Global_External_Id__c!=null && fin.Business_Impact_Global__c != null){
                globalbusinessImpactStr+='2';
                globalbusinessImpactStr += fin.Business_Impact_Global__c;
                break;
            } 
            globalbusinessImpactStr+='4';
            
        }*/
        //DEF2103-30/12/15-Reopen for BI not calculated on Global projects
        /*Analysis-IPM_Financials_Consolidated__r is not returning value may be because of recent change in BIG query above or change in formula field.
        New query is introduced now to fetch BI from IPM financial for global projects.
        */
        if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL){
            list<IPM_Financial__c> liFinGlobal = [SELECT Business_Impact_Global__c FROM IPM_Financial__c WHERE parent_project__r.IPMProject_Span__c=:IPM_ConstantUtils.PROJECT_SPAN_GLOBAL and parent_project__c=:lstofuser[0].id and regional_external_id__c=null limit 1];
            if (liFinGlobal!=null && liFinGlobal.size()>0){
                globalbusinessImpactStr = liFinGlobal[0].Business_Impact_Global__c;
            }
        }
        
        //DEF2103 - Copy Global Business Impact for Regional and Local projects from Global Project
        /*Case: When project is Regional Rollout*/
        if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT){
            list<IPM_Financial__c> liFinParentReg = [select Business_Impact_Global__c from IPM_Financial__c where (Parent_Project__c=:project.IPM_Parent_Project__c OR global_project_id__c=:project.IPM_Parent_Project__c) and parent_project__r.IPMProject_Span__c=:IPM_ConstantUtils.PROJECT_SPAN_GLOBAL limit 1];
            if (liFinParentReg!=null && liFinParentReg.size()>0){
                globalbusinessImpactStr = liFinParentReg[0].Business_Impact_Global__c;
            }
        }
        /*Case: When project is Regional Original*/
        else if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL){
            list<IPM_Financial__c> liFinRegOrig = [select Business_Impact_Regional__c from IPM_Financial__c where (regional_external_id__c=:lstofuser[0].Name OR global_project_id__c=:lstofuser[0].Name) and regional_project__r.IPMProject_Span__c=:IPM_ConstantUtils.PROJECT_SPAN_REGIONAL limit 1];
            if (liFinRegOrig!=null && liFinRegOrig.size()>0){
                globalbusinessImpactStr = liFinRegOrig[0].Business_Impact_Regional__c;
            }
        }
        else if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL &&  project.IPM_Project_Type__c !=IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
            list<IPM_Financial__c> liFinParentLoc = [select Business_Impact_Global__c from IPM_Financial__c where global_project_id__c=:project.IPM_Global_Project_Id__c and parent_Project__c=:project.IPM_Global_Project_Id__c limit 1];
            if (liFinParentLoc!=null && liFinParentLoc.size()>0){
                globalbusinessImpactStr = liFinParentLoc[0].Business_Impact_Global__c;
            }
        }
        //DEF3019
        if (project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
           	globalbusinessImpactStr = IPM_ConstantUtils.BLANK;	
        }
         BusinessCaseMessageMap = new Map<String, String>();
=======
       // Set Business Impact
       // Check if the source Project is ORIGINAL
       	if(project.IPM_SourceProjectType__c==IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)
		{
			//IF SPAN is Global
			if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
			{
				fin=[SELECT Business_Impact_Global__c,Business_Impact_Regional__c					            
					 FROM IPM_Financial__c 
					 WHERE Parent_Project__c=:project.Id AND Financial_External_ID__c=:project.IPM_Project_Name__c+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE LIMIT 1];
		            globalbusinessImpactStr = (fin.isEmpty() ? IPM_ConstantUtils.EDITMODE_FALSE : (fin[0].Business_Impact_Global__c != null ? (project.IPM_Phase__c!=IPM_ConstantUtils.PHASE_IDEAS ? fin[0].Business_Impact_Regional__c : fin[0].Business_Impact_Global__c ):  IPM_ConstantUtils.BLANK) );
			}
			//IF SPAN is Regional
			else if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
			{	//Project Type is Original
				if(project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)
				{
					 fin=[SELECT Business_Impact_Regional__c
					 FROM IPM_Financial__c 
					 WHERE Regional_Project__c=:project.Id AND Financial_External_ID__c=:project.IPM_Project_Name__c+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE LIMIT 1];
					globalbusinessImpactStr = (fin.isEmpty() ? IPM_ConstantUtils.EDITMODE_FALSE :(fin[0].Business_Impact_Regional__c != null ? fin[0].Business_Impact_Regional__c :IPM_ConstantUtils.BLANK)); 	
				}
				else if(project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT)
				{
					//Project Type is Rollout
					fin=[SELECT Business_Impact_Global__c,Business_Impact_Regional__c
						 FROM IPM_Financial__c 
						 WHERE Parent_Project__c=:project.IPM_Parent_Project__c AND Financial_External_ID__c=:project.IPM_Parent_Project__r.IPM_Project_Name__c+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE LIMIT 1];
					 globalbusinessImpactStr = (fin.isEmpty() ? IPM_ConstantUtils.EDITMODE_FALSE :(fin[0].Business_Impact_Regional__c != null ? fin[0].Business_Impact_Regional__c :IPM_ConstantUtils.BLANK));
				}
			}
			else if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
			{
				string parentProjectType=project.IPM_Parent_Project__r.IPM_Project_Type__c;
				// if local is Child to Regional Original Project
				if(parentProjectType==IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)
				{
					fin=[SELECT Business_Impact_Regional__c FROM IPM_Financial__c 
							  WHERE Regional_Project__c=:project.IPM_Parent_Project__c 
							  AND Financial_External_ID__c=:project.IPM_Parent_Project__r.IPM_Project_Name__c+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE LIMIT 1];
					globalbusinessImpactStr = (fin.isEmpty() ? IPM_ConstantUtils.EDITMODE_FALSE :(fin[0].Business_Impact_Regional__c != null ? fin[0].Business_Impact_Regional__c :IPM_ConstantUtils.BLANK));
				}
				// if local is Child to Regional Local Project
				else if(parentProjectType==IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT)// traverse to its Global Project for getting BI from CONSOLIDATED Financial
				{
					IPM_Project__c globalParentId= [Select IPM_Parent_Project__r.IPM_Parent_Project__c,IPM_Parent_Project__r.IPM_Parent_Project__r.IPM_Project_Name__c FROM IPM_Project__c where ID=:project.Id];
					fin=[SELECT Business_Impact_Global__c,Business_Impact_Regional__c FROM IPM_Financial__c 
							 WHERE Parent_Project__c=:globalParentId.IPM_Parent_Project__r.IPM_Parent_Project__c
							 AND Financial_External_ID__c=:globalParentId.IPM_Parent_Project__r.IPM_Parent_Project__r.IPM_Project_Name__c+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE LIMIT 1];
					 
					 
					globalbusinessImpactStr =  (fin.isEmpty() ? IPM_ConstantUtils.EDITMODE_FALSE :(fin[0].Business_Impact_Regional__c != null ? fin[0].Business_Impact_Regional__c :IPM_ConstantUtils.BLANK));
				}
				
			}
			if(globalbusinessImpactStr.equalsIgnoreCase(IPM_ConstantUtils.EDITMODE_FALSE))
            {
                hideFinSection = false;
			}
		}
		// For BI where Source is OPERATIONAL project. Will work got GKM5,GKM6,GKM7 OPERATIONAL
		else if(project.IPM_SourceProjectType__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)
		{
			globalbusinessImpactStr = IPM_ConstantUtils.BLANK;			
	
		}
        //upto here
        BusinessCaseMessageMap = new Map<String, String>();
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
        List<IPM_Financial__c> financialList = [Select Id, RecordTypeId, Global_Project_Id__c,Regional_Project__c,Local_Project__c, Financial_External_ID__c, Display_Name__c,
                                                 Parent_Project__r.Name,
                            (SELECT Id, Turnover_Global__c, Turnover_Local__c,Turnover_Regional__c, Profit_Before_Overheads_Global__c,
                            Profit_Before_Overheads_Local__c, Profit_Before_Overheads_Regional__c,
                            Gross_Profit_Global__c, Gross_Profit_Local__c, Gross_Profit_Regional__c FROM IPM_Financial_Years__r where
                            (Year__c =: '1' or Year__c =: '2' or Year__c =:'3') and Year_Type__c = 'Calendar' ) FROM
                            IPM_Financial__c where (Regional_Project__c = : project.Id or Global_Project_Id__c = : project.Id 
                            or Local_Project__c = : project.Id) and recordtype.Name =: 'Default' Limit: IPM_ConstantUtils.MaxLimit];  
       for(IPM_Financial__c fin : financialList ){
        for(IPM_Financial_Year__c FinYear: fin.IPM_Financial_Years__r){
          if(FinYear.Turnover_Global__c ==0 || FinYear.Turnover_Local__c == 0 || FinYear.Turnover_Regional__c == 0 || FinYear.Profit_Before_Overheads_Global__c == 0 ||
            FinYear.Profit_Before_Overheads_Local__c == 0 || FinYear.Profit_Before_Overheads_Regional__c == 0 || FinYear.Gross_Profit_Global__c == 0 || 
            FinYear.Gross_Profit_Local__c == 0 || FinYear.Gross_Profit_Regional__c == 0){
            if(ProjDueDateMap.get(fin.Global_Project_Id__c) < system.today().addDays(IPM_ConstantUtils.col_fourteen) || ProjDueDateMap.get(fin.Regional_Project__c) < system.today().addDays(IPM_ConstantUtils.col_fourteen) || ProjDueDateMap.get(fin.Local_Project__c) < system.today().addDays(IPM_ConstantUtils.col_fourteen)){
              if(fin.Global_Project_Id__c != null){
                BusinessCaseMessageMap.put(fin.Global_Project_Id__c,KEY_FINANCE_STR+fin.Display_Name__c);
                ++noOfNotifications;
              }
              if(fin.Regional_Project__c != null){
                BusinessCaseMessageMap.put(fin.Regional_Project__c,KEY_FINANCE_STR+fin.Display_Name__c);
                ++noOfNotifications;
              }
              if(fin.Local_Project__c != null){
                BusinessCaseMessageMap.put(fin.Local_Project__c,KEY_FINANCE_STR+fin.Display_Name__c);
                ++noOfNotifications;
              }
            }
          }
        }
        }
        
        //Adding alert for Regional-Local financial
        List<IPM_Financial__c> RegionalOrLocalFins = new List<IPM_Financial__c>();
        RegionalOrLocalFins = [SELECT Id, Name, Misaligned__c, Misaligned_Date__c, Target_Launch_Date__c, Regional_Project__c, Regional_Project__r.Name, Regional_Project__r.IPM_Target_Launch_Dates__c, Local_Project__c, Local_Project__r.Name, Local_Project__r.IPM_Target_Launch_Dates__c 
                                                        FROM IPM_Financial__c WHERE Regional_Project__c =: project.Id OR Local_Project__c=: project.Id limit 50000];
        lstFinAlertMessage = new list<String>();       
        lstFinTLDAlertMessage = new list<String>();
        LstLocalFinTLDMisalignedMessage = new List<String>();
                lstFinDataMissingAlertMessage = new list<String>();

        for(IPM_Financial__c fin: RegionalOrLocalFins ){  
            if(project.IPMProject_Span__c != IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && fin.Local_Project__c != NULL && fin.Regional_Project__c != NULL && fin.Misaligned__c && (system.today() > fin.Misaligned_Date__c)){               
                lstFinAlertMessage.add(IPM_ConstantUtils.FIN_MISALIGNED_ALERT1 +fin.Regional_Project__r.Name+ IPM_ConstantUtils.FIN_MISALIGNED_ALERT2 +fin.Local_Project__r.Name+IPM_ConstantUtils.FIN_MISALIGNED_ALERT3); //The financials for project {Regional.Project Name} and {Local.Project Name} are  misaligned.
                ++noOfNotifications;                
            }
     
        }        
        
        //Adding alert for TLD misalignment
        if(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(project.IPMProject_Span__c))
        {
        	for(IPM_Project__c localProj: project.IPM_Projects__r)
        	{ 
        		if(localProj.IPM_Target_Launch_Dates__c != localProj.Rollout_Plan_Target_Launch_Date__c)
        		{
        			lstFinTLDAlertMessage.add(IPM_ConstantUtils.FIN_TLDMISALIGNED_ALERT1 + 
        			localProj.IPM_Project_Name__c + IPM_ConstantUtils.FIN_TLDMISALIGNED_ALERT2 + project.IPM_Project_Name__c);
                    ++noOfNotifications;
        		}
        	}	
        }
        if(IPM_ConstantUtils.PROJECT_SPAN_LOCAL.equalsIgnoreCase(project.IPMProject_Span__c) && project.IPM_Target_Launch_Dates__c != project.Rollout_Plan_Target_Launch_Date__c)
		{
        			LstLocalFinTLDMisalignedMessage.add(IPM_ConstantUtils.FIN_TLDMISALIGNED_ALERT1 + 
        			project.IPM_Project_Name__c + IPM_ConstantUtils.FIN_TLDMISALIGNED_ALERT2 + project.IPM_Parent_Project__r.IPM_Project_Name__c);
                    ++noOfNotifications;
        }
                //DEF2344 fix
            List<IPM_Project__c> projList = IPM_ValidationHelper.validateMilestoneAndFinacialData(new List<IPM_Project__c>{project});
            if(!projList.isEmpty()) {
                lstFinDataMissingAlertMessage.add(Label.IPM_Finacial_Data_Missing);
                ++noOfNotifications;
            }
        
         
        //Calculate nearest Gate Due date for Rollout 

       //process for Tasks RL
        for(IPM_Task__c eachTask : project.Tasks__r) {
            if(!eachTask.IPM_Completed__c) {
                tasksList.add(eachTask);
            }
            projectTasksSet.add(eachTask.Id);
        }
        // Identify the due date for the Gate document for the project
        allIncompleteTasks = tasksList.size();
        
        if(project.Is_Archieved__c != null && project.Is_Archieved__c) {
            stoppedMsg = SPACE + Label.IPM_Project_Stopped_By + SPACE + project.IPM_Stopped_By__r.Name + SPACE + Label.IPM_At + SPACE;
            stoppedMsg += project.IPM_Stopped_Date_Time__c.Date() + SPACE + Label.IPM_During + SPACE + project.IPM_Phase__c +  SPACE + Label.IPM_Phase_Label + SPACE;
        }
        
        if(project.IPM_Target_Launch_Dates__c!=null)
        {
        //Alert for BET First Release is due on X
        Datetime targetLaunchDate=datetime.newInstance(project.IPM_Target_Launch_Dates__c.year(),project.IPM_Target_Launch_Dates__c.month(),project.IPM_Target_Launch_Dates__c.day());
       
        if(project.BET_MS_First_Release_Date__c != null){
            betFirstReleaseDueDate = system.today().daysBetween(project.BET_MS_First_Release_Date__c);
            if(betFirstReleaseDueDate<=15 && betFirstReleaseDueDate!=0 && betFirstReleaseDueDate >0) 
             {
                
                Datetime betFirstReleaseDate=datetime.newInstance(project.BET_MS_First_Release_Date__c.year(),project.BET_MS_First_Release_Date__c.month(),project.BET_MS_First_Release_Date__c.day());
                betMsgFirstReleaseDueDate = project.IPM_Project_Name__c +IPM_ConstantUtils.BET_FIRST_RELEASE_MESSAGE_STR1 + targetLaunchDate.format(DATEFORMAT) + IPM_ConstantUtils.BET_FIRST_RELEASE_MESSAGE_STR2+ betFirstReleaseDate.format(DATEFORMAT); 
                ++noOfNotifications;
             }
         } 
         
        //Alert for BET Final Release is due on X 
        if(project.BET_MS_Final_Release_Date__c != null)
        { 
            betFinalReleaseDueDate = system.today().daysBetween(project.BET_MS_Final_Release_Date__c);
            if(betFinalReleaseDueDate<=15 && betFinalReleaseDueDate!=0 && betFinalReleaseDueDate>0) 
            {
                Datetime betFinalReleaseDate=datetime.newInstance(project.BET_MS_Final_Release_Date__c.year(),project.BET_MS_Final_Release_Date__c.month(),project.BET_MS_Final_Release_Date__c.day());
                betMsgFinalReleaseDueDate =project.IPM_Project_Name__c +IPM_ConstantUtils.BET_FINAL_RELEASE_MESSAGE_STR1 + targetLaunchDate.format(DATEFORMAT) + IPM_ConstantUtils.BET_FINAL_RELEASE_MESSAGE_STR2+ betFinalReleaseDate.format(DATEFORMAT); 
                ++noOfNotifications;
            }       
        }
    } 
        
        //Process for associated project sections
        List<IPM_Project_Document_Section__c> projectSectionsList = new List<IPM_Project_Document_Section__c>(); 
        //get resorces list for project with their respective role
        
        string userRole = BLANK_STR;
        if(projResList != null && !projResList.isEmpty() && projResList[0].IPM_Project_Role_Owner__c){
            userRole =  (projResList[0].IPM_Role_Type__c != null && projResList[0].IPM_Role_Type__c == IPM_Utils.SupplyChain)? IPM_Utils.IPM_NewTaskIPM_FunctionalRole : projResList[0].IPM_Role_Type__c;
        }                  
        // we have different project sections for different personas
        if(project.IPM_Project_Leader__c == UserInfo.getUserId()) {
            projectSectionsList = [SELECT IPM_Section_Name__c, IPM_Section_Sequence__c, IPM_Section_Status__c, IPM_Functional_Input_Status__c,
                                                                                IPM_Project_Document__r.IPM_Project__c,IPM_Master_Section_External_Id__c,IPM_FunctionalRole__c
                                                                        FROM IPM_Project_Document_Section__c
                                                                        WHERE IPM_Project_Document__r.IPM_Project__c = :projectId AND 
                                                                                IPM_Section_Status__c != :IPM_ConstantUtils.STATUS_EXCLUDED AND
                                                                                IPM_Project_Document__r.IPM_GateDocuments__c = :currGate AND
                                                                                IPM_FunctionalRole__c =: IPM_Utils.roleForProjectLeader AND  
                                                                                IPM_Default_Section__c = true
                                                                        ORDER BY IPM_Section_Sequence__c limit 50000] ;
        } else if(project.IPM_Project_Leader__c != UserInfo.getUserId() && userRole != null ) {
            projectSectionsList = [SELECT IPM_Section_Name__c, IPM_Section_Sequence__c, IPM_Section_Status__c, IPM_Functional_Input_Status__c,
                                                                                IPM_Project_Document__r.IPM_Project__c,IPM_Master_Section_External_Id__c,IPM_Project_Document__r.IPM_Project__r.IPM_Answer_of_Q1__c,IPM_FunctionalRole__c
                                                                        FROM IPM_Project_Document_Section__c
                                                                        WHERE IPM_Project_Document__r.IPM_Project__c = :projectId AND 
                                                                                IPM_Section_Status__c != :IPM_ConstantUtils.STATUS_EXCLUDED AND
                                                                                IPM_Project_Document__r.IPM_GateDocuments__c = :currGate AND
                                                                                IPM_FunctionalRole__c =: userRole AND
                                                                                IPM_Default_Section__c = true AND 
                                                                                ((IPM_Master_Section_External_Id__c !=:ENVIRONMENTAL_IMPACT) OR (IPM_Master_Section_External_Id__c =:ENVIRONMENTAL_IMPACT AND IPM_Project_Document__r.IPM_Project__r.IPM_Answer_of_Q1__c !=:IPM_ConstantUtils.BLG )) 
                                                                        ORDER BY IPM_Section_Sequence__c limit 50000];
        }
        
        /*Eco Design*/
        if(project.EcoDesign_Sync_Status__c != null) {
            rolloutsGenerated = true;
        }
        for(IPM_Project_Document_Section__c eachProSection : projectSectionsList) {
        	if((eachProSection.IPM_Section_Status__c == IPM_ConstantUtils.SECTION_STATUS_FILLED || eachProSection.IPM_Section_Status__c == IPM_ConstantUtils.STATUS_NOT_STARTED) 
        	      && (eachProSection.IPM_Section_Sequence__c != NULL && !eachProSection.IPM_Section_Sequence__c.startsWith('8.'))) {
                projectSections.add(eachProSection);
            }
            if(eachProSection.IPM_Master_Section_External_Id__c == ENVIRONMENTAL_IMPACT && !project.IPM_Exists_AtLeast_OneAssmntPerEICountry__c && rolloutsGenerated) {
                ecoDesignSecId = eachProSection.id; 
                noOfNotifications++;
                ecoDesignAlert = Label.IPM_Alert_No_Assessment_For_EI_Country;
            }
            projectSectionsSet.add(eachProSection.Id);
        }
        /*for(IPM_Project_Document_Section__c eachProSection : projectSectionsList) {
        	if(eachProSection.IPM_Section_Status__c == IPM_ConstantUtils.STATUS_NOT_STARTED && (eachProSection.IPM_Section_Sequence__c != NULL && !eachProSection.IPM_Section_Sequence__c.startsWith('8.'))) {
                projectSections.add(eachProSection);
            }
        }*/
        //Now everything is done with retrieving the data, now get the history of the activities done.
        if(!projectMSSet.isEmpty()) 
        {
        	getMSDetail(projectMSSet);
        }	
        
        loadObjectHistory();

        /*BET processing*/
        if(ApexPages.currentPage().getParameters().containsKey('showMembers')){
            memberCallFromURL = true;
        }
        IPM_ProjectMetadata__c projMetadata = IPM_Utils.retrieveProjectMetadata(project);
        Boolean isRollout = (project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT);
        Boolean isLinkDenied = false;
        isOriginal = (project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL ) ;
       if(isOriginal && projMetadata!= null && projMetadata.BET__c && !isRollout){
            projectWithBET = projectId;
            setBETDetails(project.IPM_BET_Toolkit__c,project.BET_Link_Requested__c,project.BET__c);
            isLinkDenied = String.isNotBlank(project.BET_Denied_BET_Link__c) && String.isBlank(project.BET__c) && String.isBlank(project.BET_Link_Requested__c);
        }else if(isRollout && String.isNotBlank(project.IPM_Parent_Project__r.IPM_Parent_Project__c)){
            projectWithBET = project.IPM_Parent_Project__r.IPM_Parent_Project__c;
            isLinkDenied = String.isNotBlank(project.IPM_Parent_Project__r.IPM_Parent_Project__r.BET_Denied_BET_Link__c) && String.isNotBlank(project.IPM_Parent_Project__r.IPM_Parent_Project__r.BET__c) && String.isNotBlank(project.IPM_Parent_Project__r.IPM_Parent_Project__r.BET_Link_Requested__c);
            setBETDetails(project.IPM_Parent_Project__r.IPM_Parent_Project__r.IPM_BET_Toolkit__c,project.IPM_Parent_Project__r.IPM_Parent_Project__r.BET_Link_Requested__c ,project.IPM_Parent_Project__r.IPM_Parent_Project__r.BET__c);
        }else if(isRollout && String.isNotBlank(project.IPM_Parent_Project__c)){
            projectWithBET = project.IPM_Parent_Project__c;
            isLinkDenied = String.isNotBlank(project.IPM_Parent_Project__r.BET_Denied_BET_Link__c) && String.isNotBlank(project.IPM_Parent_Project__r.BET__c) && String.isNotBlank(project.IPM_Parent_Project__r.BET_Link_Requested__c);
            setBETDetails(project.IPM_Parent_Project__r.IPM_BET_Toolkit__c,project.IPM_Parent_Project__r.BET_Link_Requested__c,project.IPM_Parent_Project__r.BET__c);
        }
        if(project.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS && (project.IPM_Temporary_Phase__c == null || project.IPM_Temporary_Phase__c == IPM_ConstantUtils.PHASE_IDEAS)){
            isIdeasPhase = true;
        }
        if(String.isNotBlank(BETId)){
            betWrapper = BET_BETService.getBet(BETId);
            betOwner = [Select SmallPhotoUrl,name From User where id =: betWrapper.betOwner];
            hasBETAccess = BET_AccessService.HasUserAccess(UserInfo.getUserId(),BETId);
        }else if(String.isNotBlank(requestedBETId)){
            betWrapper = BET_BETService.getBet(requestedBETId);  
        }
        if(isIdeasPhase){
            betInformationMessage = (toolkitOption == IPM_ConstantUtils.CREATE_NEW_BET) ? (isProjLeader ? System.label.IPM_NewBETMessage : System.label.IPM_FunctionalTeamMsgIdeas) : 
                                    (toolkitOption == IPM_ConstantUtils.NO_BET ? (isProjLeader ?System.label.IPM_NoBETMsgPL : System.label.IPM_BETMsgFunctionalIdeas) :
                                    (toolkitOption == IPM_ConstantUtils.LINK_EXISTING_BET && requestedBETId != null ? (isProjLeader ? String.format(System.label.IPM_LinkBETPLMsgIdeas,new string[]{betWrapper.betName}) : 
                                    String.format(System.label.IPM_BETLinkFunctionalMsg,new string[]{betWrapper.betName})):(isProjLeader && BETId==null ? System.label.IPM_BET_LinkExist_NoBET :' '))); 
        }else if(!isIdeasPhase && isOriginal){
            if(toolkitOption == IPM_ConstantUtils.CREATE_NEW_BET && String.isBlank(BETId) ){
                betInformationMessage = isProjLeader ? System.label.IPM_CreateBETMsg : System.Label.IPM_NoNewBETMsgFunctional;
                if(isProjLeader){
                    additionalAlertMessages.add(System.label.IPM_LeaderBETAlert);
                    alertscount += 1 ;      
                }
            }else if(toolkitOption == IPM_ConstantUtils.LINK_EXISTING_BET && String.isBlank(BETId)){
            betInformationMessage = (isLinkDenied ? (isProjLeader ? System.Label.IPM_BETLinkRejectMsgPL : System.label.IPM_BETDeniedMsgFunctional) :
                                        (String.isNotBlank(requestedBETId)?( isProjLeader ? String.format(System.label.IPM_LinkBETPLMsg,new string[]{betWrapper.betName}) : String.format(System.label.IPM_BETReqPendingMsgFunctional,new string[]{betWrapper.betName})):(isProjLeader ? System.label.IPM_BET_LinkExist_NoBET :' ')));
                if(isProjLeader && String.isBlank(requestedBETId)){
                    additionalAlertMessages.add(String.format(System.label.IPM_BETChangeSelectionAlert,new String[]{projectId}));
                    alertscount += 1 ;      
                }
            }else if(toolkitOption == IPM_ConstantUtils.NO_BET ){
                betInformationMessage = (isProjLeader ?  System.label.IPM_NoBETMsgPLOther :  System.label.IPM_NoBETMsgFunctional);
            }
        }else if(isRollout && String.isBlank(BETId)){
            betInformationMessage = (toolkitOption != IPM_ConstantUtils.NO_BET) ? (isProjLeader ? System.label.IPM_BETMsgRegionalLocalPL : System.label.IPM_BETMsgRegionalLocal) : System.label.IPM_NoBETRegionalLocal;
        }
        //Validate and if available then add members for BET Suggested members request
        if(isOriginal && ((toolkitOption != IPM_ConstantUtils.NO_BET && String.isNotBlank(BETId)) ||(toolkitOption == IPM_ConstantUtils.LINK_EXISTING_BET && String.isNotBlank(requestedBETId)) )&& isProjLeader  && !project.Bulk_BET_Member_Request__c){
            if(projResCompleteList!= null && !projResCompleteList.isEmpty()){
                List<String> permittedFunctionalTeams = System.label.IPM_BETFunctionalTeams.split(';');
                set<STring> permittedFuncitonalTeamSet = new Set<String>();
                for(String team : permittedFunctionalTeams){
                    permittedFuncitonalTeamSet.add(team);
                }
                Map<String,List<Id>> userbucketMap =  new Map<String,List<Id>>();
                for(IPM_Project_Resource__c res : projResCompleteList){
                    if(permittedFuncitonalTeamSet.contains(res.IPM_Role_Type__c)){
                        suggestedMembersList.add(res.IPM_User__c);
                        List<id> members =  new List<id>();
                        if(userbucketMap.containsKey(res.IPM_Role_Type__c)){
                            members =  userbucketMap.get(res.IPM_Role_Type__c);
                        }
                        members.add(res.IPM_User__c);
                        userbucketMap.put(res.IPM_Role_Type__c,members);
                    }                    
                }
                for(String key : userbucketMap.keySet()){
                    BET_MemberBucketWrapper rec = new BET_MemberBucketWrapper();
                    rec.GroupName = key;
                    rec.GroupUserIds = userbucketMap.get(key);
                    memberBucketList.add(rec);
                }
            } 
            showSuggestedMembers = true;         
            additionalAlertMessages.add(String.format(System.label.IPM_BETAddMembersAlert,new String[]{projectId}));
            alertscount += 1 ;            
        }
        
        //Retrieve Category Id, Category Group Id & Brand Position Id for new BET Creation: Retrieve these values only if CERATE BET component is to be called
        if(project.IPM_BET_Toolkit__c == IPM_ConstantUtils.CREATE_NEW_BET &&  string.isBlank(project.bet__c)){
            list<MDO_BrandPosition__c> lstBrandPos = new list<MDO_BrandPosition__c>();
            list<MDO_Category__c> lstCat = new list<MDO_Category__c>();
            lstBrandPos = [SELECT Id FROM MDO_BrandPosition__c where name = :project.IPM_Brand_Positioning__c and status__c = :IPM_ConstantUtils.STRING_STATUS_ACTIVE  LIMIT 1];
            lstCat = [SELECT Id,parent_L2__c FROM MDO_Category__c  where name = :project.IPM_Category_Text__c and status__c = :IPM_ConstantUtils.STRING_STATUS_ACTIVE  LIMIT 1];
            if(!lstBrandPos.isEmpty()){
                BrandPositionId = lstBrandPos[0].id;    
            }
            if(!lstCat.isEmpty()){
                categryId = lstCat[0].id;  
                CategoryGroupId = lstCat[0].parent_L2__c;
            }
        }
        //Alert for Regional project not past Contract or Market Ready
       List<IPM_Project_Document__c> childProjectsDocumentsIncomplete=new List<IPM_Project_Document__c> ();
       if(project!=null && (project.IPM_Phase__c==IPM_ConstantUtils.PHASE_FEASIBILITY || project.IPM_Phase__c==IPM_ConstantUtils.PHASE_CAPABILITY) && project.IPM_GateKeeping_Model__c==IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH && project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
       {
        childProjectsDocumentsIncomplete=[SELECT IPM_Project__r.IPM_Parent_Project__c FROM IPM_Project_Document__c WHERE IPM_Project__r.IPM_Parent_Project__c=:project.Id AND 
        (IPM_Document_Status__c=:IPM_ConstantUtils.STATUS_IN_PROGRESS OR IPM_Document_Status__c=:IPM_ConstantUtils.STATUS_NOT_STARTED)
		AND IPM_Project__r.IPM_Phase__c=:project.IPM_Phase__c LIMIT 50000];
        String currentGate = IPM_ConstantUtils.BLANK; 
        for(IPM_Project_Document__c parentDoc:project.Project_Documents__r)
        {  
         for(IPM_Project_Document__c childDoc:childProjectsDocumentsIncomplete)	 
         {	
        	if(IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED.equalsIgnoreCase(parentDoc.IPM_Document_Status__c) && parentDoc.IPM_Project__c == childDoc.IPM_Project__r.IPM_Parent_Project__c)
        	{
        	  ++noOfNotifications;
              if(IPM_ConstantUtils.PHASE_FEASIBILITY.equalsIgnoreCase(project.IPM_Phase__c)){
                currentGate=IPM_ConstantUtils.CONTRACT_GATE;
               }
              else if(IPM_ConstantUtils.PHASE_CAPABILITY.equalsIgnoreCase(project.IPM_Phase__c)){
              currentGate=IPM_ConstantUtils.MARKET_READY_GATE;
              }
              childProjectsIncompleteAlert=System.Label.IPM_Alert_Please_be_aware_that_some_of_your_regional_rollouts_have_not_progresse+IPM_ConstantUtils.IPM_SPACE +currentGate+ IPM_ConstantUtils.IPM_SPACE+System.label.IPM_Alert_Gate_or_proposed_to_go_through + IPM_ConstantUtils.IPM_SPACE+currentGate+IPM_ConstantUtils.IPM_SPACE+System.Label.IPM_Alert_Gate;
        	}
         }	   
        }
       }
        
    }
    
     /*******************************************************************
    * @description: code to request access to bet
    */
    public void requestBETAccess(){
        String accessLevel = isProjLeader ? IPM_ConstantUtils.BET_MANAGER_ACCESS :  IPM_ConstantUtils.BET_MEMBER_ACCESS;
        BET_BETWrapper.MemberRequest newReq = new BET_BETWrapper.MemberRequest();
        newReq.UserId = UserInfo.getUserId();
        newReq.AccessLevel = accessLevel;
        List<BET_BETWrapper.MemberRequest> newReqList = new List<BET_BETWrapper.memberRequest>();
        newReqList.add(newReq);
        BET_AccessService.RequestAccess(newReqList,BETid,projectWithBET);
        hasBETAccess = BET_AccessService.HasUserAccess(UserInfo.getUserId(),BETId);
    }
    
    /*Method to set up bet options*/
    public void setBETDetails(String projtoolkitOption,String requestedBET,Id projbetId){
        showBET = true; 
        toolkitOption = projtoolkitOption;
        requestedBETId = requestedBET;
        BETId = projbetId;
    }

    /*******************************************************************
    * @description: Get the sobject details of the milestone basing on the ids
    * @param1 - pdId : set id of the milestone
    * @return : sobject details milestone wise.
    */
    private Map<String, IPM_Milestone__c> getMSDetail(Set<String> msIds) {
        
        Map<String, IPM_Milestone__c> mapToReturn = new Map<String, IPM_Milestone__c>();
        list<IPM_Milestone__c> lst = [SELECT IPM_Name__c,IPM_Phase__c,IPM_Completed__c,IPM_Type_of_gate__c,IPM_Project__r.IPM_Phase__c,LastModifiedBy.Name,
        IPM_Project__r.Name,IPM_Project__r.IPM_Project_Name__c ,IPM_Due_Date__c,IPM_Project__r.IPM_Project_Leader__r.Name FROM IPM_Milestone__c WHERE Id IN :msIds limit 50000];
        alertMessage = new Map<String,String>();
        alertMessageToday = new Map<String,String>();
        alertMessagePast = new Map<String,String>();
        additionalAlertMessages = new List<String>();
        Integer DateValue;
        //alertscount=0;
        List<IPM_Country__c> countryLst = [select id,name,Geography__r.Market_Type__c,IPM_Project__c from IPM_Country__c where IPM_Project__c =: projectId and Geography__r.Market_Type__c  =: IPM_ConstantUtils.MARKETTYPE_DEVELOPED limit 1] ;
        for(IPM_Milestone__c eachRec : lst) {
            mapToReturn.put(eachRec.Id, eachRec);
            if(eachRec.IPM_Project__r.IPM_Phase__c == eachRec.IPM_Phase__c){
                if(String.IsNotBlank(String.valueOf(eachRec.IPM_Due_Date__c)) && !eachRec.IPM_Completed__c){
                    DateValue=Date.valueOf(System.today()).daysBetween(Date.valueOf(eachRec.IPM_Due_Date__c));
                    if(DateValue<0){
                            alertMessagePast.put(System.Label.IPM_DUE_DATE_FOR , eachRec.IPM_Type_of_gate__c +SPACE+IPM_Utils.off+SPACE+eachRec.IPM_Project__r.IPM_Project_Name__c);
                            alertscount++;
                    }
                    if(DateValue==0){
                           alertMessageToday.put(eachRec.IPM_Name__c,PLANNED_STR+eachRec.IPM_Type_of_gate__c+IPM_ConstantUtils.IPM_SPACE+GATE_STR);
                           alertscount++;
                     }
                    if(DateValue<=IPM_ConstantUtils.CONST_21 && DateValue!=0 && DateValue >0){
                           alertMessage.put(eachRec.IPM_Project__r.IPM_Project_Name__c+SPACE+eachRec.IPM_Name__c+SPACE+System.Label.IPM_DUE_IN,DateValue+SPACE+System.Label.IPM_DAY);
                           alertscount++;
                    }
                } 
            }
                if(!project.IPM_Fast_Track_Project__c && (project.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS || project.IPM_Phase__c == IPM_ConstantUtils.PHASE_FEASIBILITY) && eachRec.IPM_Name__c ==  IPM_Utils.MarketReadyGateApproval ){
                if(eachRec.IPM_Due_Date__c != NULL && project.IPM_Target_Launch_Dates__c != NULL){
                    DateValue = Date.valueOf(eachRec.IPM_Due_Date__c).daysBetween(Date.valueOf(project.IPM_Target_Launch_Dates__c)) ;
                }
                if( ( countryLst != null && countryLst.size()  ==1 && DateValue< 180) || (project.IPM_Countries__r!= null && project.IPM_Countries__r.size() > 0 && DateValue<120 ) || ((project.IPM_Countries__r).isEmpty() && dateValue < 180 )){
                    additionalAlertMessages.add(system.label.IPM_AlertMsgOutsideOTIF);
                    alertscount++;      
                }
           }
        }
       for(IPM_Project_Document__c eachDoc:[SELECT IPM_GateDocuments__c,IPM_Document_Status__c,IPM_Project__r.IPM_Project_Name__c FROM IPM_Project_Document__c where IPM_Project__c=: projectId])
       {
            if(IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS.equalsIgnoreCase(eachDoc.IPM_Document_Status__c) && (System.Label.IPM_CHARTER.equalsIgnoreCase(eachDoc.IPM_GateDocuments__c) || IPM_ConstantUtils.CONTRACT_GATE.equalsIgnoreCase(eachDoc.IPM_GateDocuments__c)))
            {
                documentAlertMessage = eachDoc.IPM_Project__r.IPM_Project_Name__c +IPM_ConstantUtils.Colon+eachDoc.IPM_GateDocuments__c+SPACE+system.label.IPM_Gate_Approved_With_Edits;
                alertscount++;
            }
        }
            
        return mapToReturn;
    }
    /*******************************************************************
    * @description: Get the sobject details of the user basing on the ids
    * @param1 - pdId : set id of the user
    * @return : sobject details user wise.
    */
    private Map<String, User> getUserDetails(Set<String> usId) {
        
        Map<String, User> mapToReturn = new Map<String, User>();
        list<User> lst = [SELECT Name, SmallPhotoUrl FROM User WHERE Id IN :usId limit 50000];
        for(User eachRec : lst) {
            mapToReturn.put(eachRec.Id, eachRec);
        }
        return mapToReturn;
    }
    
    /*******************************************************************
    * @description: method which actually loads the activity history 
    */
    public void loadObjectHistory() {
        
        activityHistory = new List<objectHistoryWrapper>();//initialise the wrapped list now
        
         /* Internal variables used for various combinations of data being filtered out 
         */
        Set<String> usrIds = new Set<String>();
 
        //Now get the chatter feed for the project, this is the universal chatter feed that we have notified, its time to show them all!
        List<IPM_Project__Feed> projectFeed = [SELECT Body,ParentId,CreatedDate,CreatedById FROM IPM_Project__Feed WHERE ParentId = :projectId ORDER BY CreatedDate DESC limit 50000];
        for(IPM_Project__Feed eachObjHistory : projectFeed) {
            usrIds.add(String.valueOf(eachObjHistory.get(STR_CREATEDBY)));
        }
        Map<String, User> userDetailMap = getUserDetails(usrIds);
        
        //Process & fill them in the activityHistory object
        for(IPM_Project__Feed eachObjHistory : projectFeed) {
            objectHistoryWrapper objWrap = new objectHistoryWrapper();
            DateTime dT = eachObjHistory.CreatedDate;
            Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            objWrap.theDate = myDate.format();
            objWrap.user = userDetailMap.get(eachObjHistory.createdById).Name;
            objWrap.recordLink = eachObjHistory.ParentId;
            objWrap.whoImage = userDetailMap.get(eachObjHistory.createdById).SmallPhotoUrl;
            objWrap.actionType = IPM_ConstantUtils.CHATTER;
            objWrap.action = eachObjHistory.Body;
            activityHistory.add(objWrap);
        }
    
    }
    
    /*******************************************************************
    * @description: Mark the task as complete
    */
    public void markComplete() {
        try{
            List<IPM_Task__c> tObj = [SELECT IPM_Completed__c, IPM_Completed_Date__c FROM IPM_Task__c WHERE Id =:taskId limit 50000];
            tObj[0].IPM_Completed__c = isChecked == 'true' ? true : false; 
            tObj[0].IPM_Completed_Date__c = isChecked == 'true' ? system.today() : null;
            update tObj[0];
        }
        catch (DmlException ex)
        {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
               'markComplete',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));   
        }       
        if(!Test.isRunningTest()){
           init();
        }
           bPaginated  = false;
    }
    
    //@description: Wrapper class to wrap, when was the activity taken place by whom and what?
    public class objectHistoryWrapper {
        
        public String theDate {get; set;}
        public String who {get; set;}
        public String user {get; set;} 
        public String action {get; set;}
        public String whoImage{get; set;}
        public String recordLink{get;set;}
        public String actionType{get; set;}
        public String fromValue {get; set;}
        public String toValue {get;set;}
    }
    
    /*****************************************************************
        Function Summary :In actions for Move to PLE at MarketDeployment Gate  
        Created Date:
        Created By: Kannan and Samrat
        Referenced: IPM_ProjectOverviewCtrl (Page)
    ******************************************************************/
     public void moveToPLE()
     {
        try{

             project.IPM_Phase__c=IPM_ConstantUtils.PHASE_PLE;
             project.IPM_Actual_Launch_Date__c=Date.today();
             update project ;
        }
        catch (DmlException ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
               'moveToPLE',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));   
 
        }
     }
     
   
    public List<IPM_Task__c> getTasks() {
       size = 5;
       if(!bPaginated){
           con = new ApexPages.StandardSetController(tasksList);
       }
       noOfRecords = con.getResultSize();
       con.setPageSize(size);
       return (List<IPM_Task__c>)con.getRecords();
    }
    
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer getPageNumber(){
        return con.getPageNumber();
    }
    // returns the first page of records
     public void first() {
         bPaginated = true;
         con.first();
     }

     // returns the last page of records
     public void last() {
         bPaginated = true;
         con.last();
     }

     // returns the previous page of records
     public void previous() {
        bPaginated = true;
        con.previous();
     }

     // returns the next page of records
     public void next() {
        bPaginated = true;
        con.next();
     }     

}