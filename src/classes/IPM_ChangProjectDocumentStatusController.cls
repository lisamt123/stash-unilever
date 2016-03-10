/*****************************************************************
@Description :used for changing the status of a Gate document
@Created Date: 2014/12/15
@Author: Cognizant 
@Referenced: ipmChangeCurrenDocumentStatus Page
******************************************************************/
public with sharing class IPM_ChangProjectDocumentStatusController extends IPM_ProjectIntermediateController
{  
    // Variables Declaration
    public Id projectId{get; set;} //used to fetch current projectId 
    public IPM_Project_Document__c projectDoc {get; set;} //used to store query result from IPM_Project_Document__c object
    public List<IPM_Project_Document_Section__c> projSectionList {get; set;} //used to store query result from IPM_Project_Document_Section__c object
    public List<IPM_Project_Document_Section__c> projSectionListUpdate {get; set;} //used to store query result from IPM_Project_Document_Section__c object
    public List<IPM_Milestone__c> dueMilestones{get; set;} //used to store query result from IPM_Milestone__c object
    public Boolean showSkipSections{get; set;} // true if projSectionList size is greater than 0
    public String Status{get; set;} // used to store the IPM_Document_Status__c of the projectDoc object
    public Integer oldSize{get;set;} //used to store the size of projSectionList
    public Boolean showValidation {get;set;} //true if we want to implement validations according to the conditions
    public Integer rolloutCount; // used to store the count of IPM_Project_Rollout__c 
    public Integer rolloutFilledCount; //used to store the count of IPM_Project_Rollout__c and where regional PL is null or TLD is  equal to null   
    public List<IPM_Questionnaire__c> riskQuesList; //used to store query result from IPM_Questionnaire__c object
    public List<IPM_Milestone__c> milestoneList{get;set;}
    public IPM_Financial__c fin{get;set;}
    public IPM_Project__C ParentProject{get;set;} //used to fetch parent id of current project
    public string isCapability{get;set;} 
    public IPM_Project_Type__c associatedProjectType{get;set;}
    //upto here
    //To replace duplicate string literals
    private static final String IPM_CHANGEPROJDOCSTATUSCONT_STR = IPM_ChangProjectDocumentStatusController.class.getName();
    public static final String SUBMIT_STR = 'submit';
    public static final String LINEBREAK_STR = '</a><br/>';
    public static final String TARGET_STR = '" target="_top">';
    public static final String HREF_STR = '<a href="';
    //For Showing Validation Error Messages
    public Boolean milestoneError{get; set;}
    public Boolean riskError{get; set;}
    public Boolean financialError{get; set;}
    public Boolean rolloutNotExistsError{get; set;}
    public Boolean rolloutRegionalPLFilledError{get; set;}
    public Boolean rolloutCountryPLFilledError{get; set;}
    public Boolean completedError{get; set;}
    public String riskSectionId{get; set;}
    public Boolean showStop{get; set;}
    public Boolean showPostpone{get; set;}
    public Boolean showApprove{get; set;}
    public String showErrorMsg{get; set;}
    public Boolean isOperational{get; set;}
    public Boolean isDefaultAvailable{get; set;}
    public Boolean discriptionError{get;set;}
    public Boolean ecoDesignNoAssessmentError{get;set;}
    public String ecoDesignSectionId{get;set;}
    public string finExternalID{get;set;}
    public static final String REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).getRecordTypeId();
    public static final String LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId();
    public Boolean isRiskComplete{get;set;}//boolean to check if Risk section is complete
    public static final string ENVIRONMENTAL_IMPACT=IPM_ConstantUtils.IPM_ENVIRONMENTAL_IMPACT;
    
    /*****************************************************************
    @Description :Constructor Fetch the Page parameters and retrieve lists
    *****************************************************************/
    public IPM_ChangProjectDocumentStatusController()
    {
        super();           
        isDefaultAvailable=false;
        isOperational=false;
        showSkipSections=false;
        showStop=true;
        showPostpone=true;
        showApprove=true;
        isCapability = IPM_ConstantUtils.PHASE_CAPABILITY;
        projectId=ApexPages.currentPage().getParameters().get('Id');
        
        if(projectId!=null)
        { 
            associatedProjectType = IPM_Utils.retrieveProjectType(project);
            
            if(associatedProjectType!=null)
            {
                String currentGate = associatedProjectType.IPM_Gate_Document__c;
                        
                projectDoc=[SELECT Id,IPM_Proposed_Date__c,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,
                LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Updated_User_By__c,
                IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c,IPM_Stopped_Comments__c,IPM_Project__r.IPM_Current_Document_Status__c
                FROM IPM_Project_Document__c 
                WHERE IPM_Project__c=:project.Id AND IPM_GateDocuments__c=:currentGate];
                
                Status=projectDoc.IPM_Document_Status__c;
                
                projSectionList=[SELECT Id,IPM_Section_Type__c,IPM_Default_Section__c,IPM_Negotiable__c,IPM_Section_Sequence__c,IPM_Section_Name__c,IPM_Gate_Document_Summary__c,IPM_Section__c,IPM_Section__r.External_ID__c,IPM_Project_Document__r.IPM_Project__r.IPM_ProjectSubType__c, IPM_Project_Document__r.IPM_Project__r.IPM_Answer_of_Q1__c
                FROM IPM_Project_Document_Section__c 
                WHERE (Not IPM_Section_Sequence__c like :IPM_ConstantUtils.APPENDIX_HEADER_SEQUENCE_FOR_QUERY) AND IPM_Project_Document__c=:projectDoc.Id AND IPM_Section_Status__c=:IPM_ConstantUtils.STATUS_NOT_STARTED AND IPM_Default_Section__c=true AND IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_HEADER
				AND IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_SUBHEADER ORDER BY IPM_Section_Sequence__c asc];
				
                
                projSectionListUpdate=[SELECT Id,IPM_Default_Section__c,IPM_Negotiable__c,IPM_Section_Type__c,IPM_Section_Sequence__c,IPM_Section_Name__c,IPM_Gate_Document_Summary__c 
                FROM IPM_Project_Document_Section__c 
                WHERE IPM_Project_Document__c=:projectDoc.Id AND IPM_Section_Status__c=:IPM_ConstantUtils.STATUS_NOT_STARTED AND IPM_Default_Section__c=true AND IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_HEADER AND IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_SUBHEADER ORDER BY IPM_Section_Sequence__c asc];
                
                String standardType = IPM_ConstantUtils.STANDARD;// variable used in query below NO SONAR
                String milestoneQuery = IPM_Utils.prepareSOQLQuery('IPM_Milestone__c',false,null,true);
                String milestoneWhereClause = ' WHERE IPM_Type_of_Milestone__c =:standardType AND  IPM_Project__c=:projectId AND IPM_Active__c = true LIMIT 50000';
                milestoneQuery = milestoneQuery + milestoneWhereClause;
                milestoneList = database.query(milestoneQuery);
                
                if(project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL || (project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && IPM_ConstantUtils.PROJECT_SPAN_REGIONAL==project.IPMProject_Span__c) ){
                    isOperational=true;
                }
                               
                // Show all Validations on selecting Propose
                showValidationMethod();               
            }
        }
    }
    
    /***********************************************************************
    @Description :Used on click of the Submit Button. 
    Based on the selected Status perform the Actions
    @param: Not Applicable
    @Referenced: ipmChangeCurrenDocumentStatus(Page)
    **********************************************************************/
    public void submit()
    {   
        if(!String.isBlank(Status))
        {
            projectDoc.IPM_Document_Status__c=Status;//setting the project document status
        }
        //functionality when Document status is STOPPED
        if(projectDoc.IPM_Document_Status__c == IPM_ConstantUtils.DOCUMENT_STATUS_STOPPED)
        {  
              stopProject();
            
        }       
        //functionality when Document status is PROPOSED
        else if(projectDoc.IPM_Document_Status__c==IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED)
        {
            showStop=false;
            showPostpone=false;
            showValidation=true;
            rolloutFilledCount=0;
            rolloutCount=0;
            finExternalID=IPM_ConstantUtils.BLANK;
            riskQuesList=new List<IPM_Questionnaire__c >();//instantiate questionnaire List
                              
            showValidationMethod();
            proposeProject();
        }
         //functionality when Document status is POSTPONED
        else if(projectDoc.IPM_Document_Status__c==IPM_ConstantUtils.DOCUMENT_STATUS_POSTPONED)
        {   
           // Postponed Comments and Postponed date is required. Posponed Date must be in future         
            postponeProject();
        }
        //functionality when Document status is Approved with Edits
        else if( projectDoc.IPM_Document_Status__c == IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS)
        {  
            approvedWithEditsProject();
                       
        }
        //functionality for Document Statues APPROVED
        else if(projectDoc.IPM_Document_Status__c==IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED)
        {
            approveProject();
        } 
    }    
   
    /*****************************************************************
    Function Summary :used for Rerendering on Selection (DO NOT REMOVE)
    Created Date: 26/12/2014
    Created By: Kannan and Samrat
    Referenced: ipmChangeCurrenDocumentStatus Page
    ******************************************************************/
    public void updateStatus()
    {
        //Method invoked from IPM_ChangeCurrenDocumentStatus page
    } 
    
    /****************************************************************************
    @Description : For getting contract and market ready approver
    @Return: List of contract approvers
    *****************************************************************************/
    public List<SelectOption> getContractApprovers(){
        Schema.sObjectType sobject_type = IPM_Project__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map=new Map<String, Schema.SObjectField>();
        field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(IPM_ConstantUtils.IPM_GATEKEEPING_MODEL).getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        
        return options;
    }  
    
    /****************************************************************************
    @Description : For getting complexity type
    @Return: List of complexity type
    *****************************************************************************/
    public List<SelectOption> getcomplexities(){
        Schema.sObjectType sobject_type = IPM_Project__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map=new Map<String, Schema.SObjectField>();
        field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(IPM_ConstantUtils.IPM_CHILD_COMPLEXITY).getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        
        return options;
    }
    /*****************************************************************
    @Description :TO Validate each EI Country has Assessment created
    @Created Date: 2015/10/14
    @Author: Cognizant
    @return: Void
    Referenced: ipmChangeCurrenDocumentStatus Page
    ******************************************************************/
    public void ecoDesignAssessmentValidate()
    {
        String projectQuery = IPM_Utils.prepareSOQLQuery('IPM_Project__c',false,null,true);
        String projectWhereClause = ' WHERE id  =: projectId limit 1';
        projectWhereClause = projectQuery + projectWhereClause;
        List<IPM_Project__c> projList  = database.query(projectWhereClause);
        if(projList != null && !projList.isEmpty() && IPM_Utils.isProjectToBeSyncedToEcoDesign(projList[0]) && !projList[0].IPM_Exists_AtLeast_OneAssmntPerEICountry__c)
        {
            ecoDesignNoAssessmentError = true;  
        }
    }
    
    /***********************************************************************
    @Description :Validate Milestones     
    @param: Not Applicable
    @Author: Cognizant
    @return: Void
    @Referenced:showValidationMethod function
    **********************************************************************/
    public void validateMilestone()
    {
        if(project!=null && !milestoneList.isEmpty())
            {
                dueMilestones = new List<IPM_Milestone__c>();
                // FOR GKM2 RCLT DUE Date is mandatory only for IDEAS Milestone for IDEAS Phase.
                if(project.IPM_GateKeeping_Model__c != null && IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT == project.IPM_GateKeeping_Model__c && 
                    IPM_ConstantUtils.PHASE_IDEAS == project.IPM_Phase__c)
                {
                    for(IPM_Milestone__c mileStone : milestoneList)
                    {
                        if(project.IPM_Phase__c == milestone.IPM_Phase__c && milestone.IPM_Due_Date__c == null )
                        {
                            dueMilestones.add(milestone);
                            break;
                        }
                    }
                }
                else
                {     // Default Check for Due Date is mandatory of all standard Milestone.
                    for(IPM_Milestone__c mileStone : milestoneList)
                    {
                        if(milestone.IPM_Due_Date__c == null )
                        {
                            dueMilestones.add(milestone);
                        }
                    }
                }
                
                
            }
    
    }
    
    /***********************************************************************
    @Description :Validate Rollouts and Financials      
    @param: Not Applicable
    @Author: Cognizant
    @return: Void
    @Referenced:showValidationMethod function
    **********************************************************************/
    public void validateRolloutAndFin()
    {
        fin=new IPM_Financial__c();//instantiate financial object
        if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL)
                {
                    finExternalID=project.IPM_Project_Name__c+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
                    //Check for Global level
                    rolloutCount=[SELECT count() FROM IPM_Project_Rollout__c WHERE IPM_Project__c=:projectId AND  isActive__c=true];
                    rolloutFilledCount=[SELECT count() FROM IPM_Project_Rollout__c WHERE IPM_Project__c=:projectId AND RecordTypeId=:Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).getRecordTypeId() AND (IPM_Regional_PL__c=null OR Target_Launch_Date__c=null) AND  isActive__c=true];
                    
                    if(rolloutCount>0)
                    {
                        fin=[SELECT Year_3_iTO_Global__c,Year_3_iTO_Regional__c,Year_3_iTO_Local__c FROM IPM_Financial__c WHERE Financial_External_ID__c=:finExternalID AND  isActive__c=true];
                    }
                }
                else if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL &&    (project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL || project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT))
                {
                    finExternalID=project.IPM_Project_Name__c+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
                    //Check for Regional level
                    rolloutCount=[SELECT count() FROM IPM_Project_Rollout__c WHERE Regional_Project__c=:projectId AND  isActive__c=true];
                    rolloutFilledCount=[SELECT count() FROM IPM_Project_Rollout__c WHERE Regional_Project__c=:projectId AND RecordTypeId=:Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId() AND (IPM_Regional_PL__c=null OR Target_Launch_Date__c=null) AND  isActive__c=true];
                    if(rolloutCount>0)
                    {
                        fin=[SELECT Year_3_iTO_Regional__c,Year_3_iTO_Global__c,Year_3_iTO_Local__c  FROM IPM_Financial__c WHERE Financial_External_ID__c=:finExternalID AND  isActive__c=true];
                    }
                    
                }
                else if(project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)
                {
                  
                    finExternalID=project.IPM_Project_Name__c;
                    fin=[SELECT Year_3_iTO_Global__c,Year_3_iTO_Regional__c,Year_3_iTO_Local__c  FROM IPM_Financial__c WHERE Financial_External_ID__c=:finExternalID AND  isActive__c=true];
                  
                }
    }
    
    /***********************************************************************
    @Description :Validate RMP comments      
    @param: Not Applicable
    @Author: Cognizant
    @return: Void
    @Referenced:showValidationMethod function
    **********************************************************************/
    
    public void validateRisk()
    {
       // Risk Question Validation Check
            riskQuesList=[SELECT Id,IPM_Charter_Comments__c,IPM_Charter_Score__c,IPM_Contract_Comments__c,IPM_Contract_Score__c,IPM_Market_Ready_Score__c,IPM_Market_Ready_Comments__c,IPM_Project_Document_Section__c,IPM_Project__c 
                          FROM IPM_Questionnaire__c 
                          WHERE (IPM_Active_RQS__c=true OR IPM_Is_Added_Question__c=true) AND IPM_Project__c=:projectId];
            for(IPM_Questionnaire__c risk:riskQuesList)
            {
                if((projectDoc.IPM_GateDocuments__c==IPM_ConstantUtils.CHARTER_GATE && String.isBlank(risk.IPM_Charter_Comments__c) && risk.IPM_Charter_Score__c>=IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE) || 
                    (projectDoc.IPM_GateDocuments__c==IPM_ConstantUtils.CONTRACT_GATE && String.isBlank(risk.IPM_Contract_Comments__c) && risk.IPM_Contract_Score__c>=IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE) ||
                    (projectDoc.IPM_GateDocuments__c==IPM_ConstantUtils.MARKET_READY_GATE && String.isBlank(risk.IPM_Market_Ready_Comments__c) && risk.IPM_Market_Ready_Score__c>=IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE)){
                isRiskComplete=false;                
                }       
            }
    }
    
    /***********************************************************************
    @Description :Used on page load and on submit of the Change Button      
    @param: Not Applicable
    @Author: Cognizant
    @return: Void
    @Referenced:submit function
    **********************************************************************/
    public void showNotFilledSections()
    {
    	 if(projSectionList != NULL && !projSectionList.isEmpty()){
                    showSkipSections=true;
                    oldSize=projSectionList.size();
                }               
                
                for(IPM_Project_Document_Section__c pds:projSectionList){
                    if(pds.IPM_Negotiable__c && pds.IPM_Default_Section__c){
                        isDefaultAvailable=true;                        
                }                   
        }
        
        if(showSkipSections || isDefaultAvailable)
        {
        	showValidation=false;
        }
    }  
    /***********************************************************************
    @Description :Used on page load and on submit of the Change Button      
    @param: Not Applicable
    @Author: Cognizant
    @return: Void
    @Referenced:submit function
    **********************************************************************/  
    public void showValidationMethod(){
        showErrorMsg=IPM_ConstantUtils.BLANK;
        riskSectionId=IPM_ConstantUtils.BLANK;
        //boolean value initialized
        showValidation=true;
        showStop=true;
        showPostpone=true;
        showApprove=true;
        isRiskComplete=true;//boolean to check if Risk section is complete 
        for(IPM_Project_Document_Section__c pds:projSectionList){
                if(pds.IPM_Negotiable__c && pds.IPM_Default_Section__c){
                    isDefaultAvailable=true;                        
                }
                //For Risk & Eco-Design Section Id
                if(pds.IPM_Section__r.External_ID__c==IPM_ConstantUtils.RISK_SECTION)
                {
                    riskSectionId=pds.Id;
                }
                if(pds.IPM_Section__r.External_ID__c==IPM_ConstantUtils.ENVIRONMENTAL_IMPACT_EXTERNAL_ID)
                {
                    ecoDesignSectionId = pds.Id;
                }
                
           }    
         if(projectId!=null){
         		  //check for Filled in Sections
         		  showNotFilledSections();
                 // Milestone Validation Check            
                   validateMilestone();
                // Rollouts and Financials Validation Check
                   validateRolloutAndFin();
                // Risk Question Validation Check
                   validateRisk();
                //ecoDesign validation check
                   ecoDesignAssessmentValidate();   
            }
           
     //All the validation Messages to be displayed on the UI. The below code base will be updated based on the NEW UI (after refactoring is over)
            if(dueMilestones != NULL && !dueMilestones.isEmpty())
            {
                showValidation=false;
                milestoneError=true;
            }
            
            if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
            {
                if(rolloutFilledCount>0 && project.IPM_Project_Type__c!=IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)
                {
                    showValidation=false;
                    rolloutRegionalPLFilledError=true;
                }
            
                if(rolloutCount<1 && project.IPM_Project_Type__c!=IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)
                {
                    showValidation=false;
                    rolloutNotExistsError=true;
                }
                
                if(fin.Year_3_iTO_Global__c==0.00)
                {
                    showValidation=false;
                    financialError=true;
                }   
            }
            
            if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
            {
               if(rolloutCount<1 && project.IPM_Phase__c==IPM_ConstantUtils.PHASE_IDEAS && project.IPM_Project_Type__c!=IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)
                {
                    showValidation=false;
                    rolloutNotExistsError=true;
                }
               
                if(rolloutFilledCount>0 && project.IPM_Phase__c!=IPM_ConstantUtils.PHASE_IDEAS && project.IPM_Project_Type__c!=IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)
                {
                    showValidation=false;
                    rolloutCountryPLFilledError=true;
                }
                if(fin.Year_3_iTO_Regional__c==0.00)
                {
                    showValidation=false;
                    financialError=true;
                }
                
            }
            
            if(project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL && fin.Year_3_iTO_Local__c==0.00)
            {
                showValidation=false;
                financialError=true;
            }
            
            if(!isRiskComplete)
            {
                showValidation=false;
                riskError=true;
            }
               
            if(!project.IPM_IsCompleted__c)
            {
                showValidation=false;
                completedError=true;
            }
              if(String.isBlank(project.IPM_Project_Description__c))
            {
                showValidation=false;
                discriptionError=true;
            }
            
        }
        
        
    /***********************************************************************
    @Description :Used on click of the Change Button if Proposed     
    @param: Not Applicable
    @Author: Cognizant
    @return: Void
    @Referenced:submit function
    **********************************************************************/
        
        public void proposeProject(){
            // Used to Set Error Message information.
            String errorMsg=IPM_ConstantUtils.BLANK;
            if(showValidation)
            {
                showValidation=true;
                    project.IPM_Current_Document_Status__c = projectDoc.IPM_Document_Status__c;
                    project.IPM_Document_Update_Date__c = Date.today();
                    
                    System.savePoint updateSavePoint = Database.SetsavePoint();
                    try
                    {
                        if(projectDoc!=null)
                        {
                           
                            update project;
                        }
                        
                        if(projSectionList != NULL && !projSectionList.isEmpty())
                        { 
                            update projSectionList;
                        }
                    }
                    catch (Exception ex)
                    {
                        Database.rollback(updateSavePoint);
                         ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CHANGEPROJDOCSTATUSCONT_STR,
                                SUBMIT_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);    
                    }
            }
            else 
            {
                showValidation=false;
                apexpages.addmessage(new apexpages.message(apexpages.severity.error,errorMsg));
            }
        }
    /***********************************************************************
    @Description :Used on click of the Submit Button if Stopped     
    @param: Not Applicable
    @Author: Cognizant
    @return: Void
    @Referenced:submit function
    **********************************************************************/
    
    public void stopProject(){
        if(!String.isBlank(projectDoc.IPM_Stopped_Comments__c))
            {
                showStop=true;
                Date dt=date.parse(System.today().format());
                projectDoc.IPM_Stopped_Date__c=dt;
                projectDoc.IPM_Updated_User_By__c=UserInfo.getUserId();
                project.IPM_Stopped_Date_Time__c=System.now();
                project.Is_Archieved__c=true;
                project.IPM_Stopped_By__c=UserInfo.getUserId();
                project.IPM_Stopped_Comments__c=projectDoc.IPM_Stopped_Comments__c;
                project.IPM_Current_Document_Status__c = projectDoc.IPM_Document_Status__c;
                project.IPM_Document_Update_Comments__c = projectDoc.IPM_Stopped_Comments__c;
                try
                {               
                    update project;
                }
                catch (Exception ex)
                {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,system.label.IPM_System_Admin));
                    ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CHANGEPROJDOCSTATUSCONT_STR,
                        SUBMIT_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);    
                        
                }
            }
            else 
            {
                showStop=false;
                showErrorMsg=system.label.IPM_Stopmsg;
            }
      
    }
    
    /***********************************************************************
    @Description :Used on click of the Submit Button if postpone     
    @param: Not Applicable
    @Author: Cognizant
    @return: Void
    @Referenced:submit function
    **********************************************************************/
    public void postponeProject()
    {
      showPostpone = false;
            showErrorMsg=IPM_ConstantUtils.BLANK; 
            Boolean validPostpone=true;
            System.SavePoint sp = Database.setSavePoint();
            IPM_Milestone__c currentPhaseMilestone = null;
            String currentPhase = project.IPM_Phase__c;
            Integer currentProjectPhaseSequence = 0;
                    
            try
            {
                if(String.isBlank(projectDoc.IPM_Postponed_Comments__c) || projectDoc.IPM_Postponement_Date__c == null)
                {
                    showErrorMsg=IPM_ConstantUtils.BLANK;
                    validPostpone=false;
                }
            
                if(String.isBlank(showErrorMsg) && projectDoc.IPM_Postponement_Date__c!=null && projectDoc.IPM_Postponement_Date__c <= System.today())
                {
                    showErrorMsg=system.label.IPM_PostponeDate_Validation;
                }
                
                if(String.isBlank(showErrorMsg))
                {
                    if(currentPhase!=null && IPM_ConstantUtils.phaseSequence.containsKey(currentPhase))
                    {
                        currentProjectPhaseSequence = IPM_ConstantUtils.phaseSequence.get(currentPhase);
                    }
                    
                    for(IPM_Milestone__c milestone : milestoneList)
                    {
                        String milestonePhase = milestone.IPM_Phase__c;
                        Integer mileStonePhaseSequence = 0;
                        if(milestonePhase!=null && IPM_ConstantUtils.phaseSequence.containsKey(milestonePhase))
                        {
                            mileStonePhaseSequence = IPM_ConstantUtils.phaseSequence.get(milestonePhase);
                        }
                        
                        if(mileStonePhaseSequence >= currentProjectPhaseSequence)
                        {
                           if(mileStonePhaseSequence == currentProjectPhaseSequence)
                           {
                               currentPhaseMilestone = milestone;
                           }
                        }
                    }
                    
                    // get the set of previos phases
                    Set<String> previousPhases = new Set<String>();
                    for(String phase : IPM_ConstantUtils.phaseSequence.KeySet()){
                        if(currentPhaseMilestone.IPM_Phase__c!= null && phase == currentPhaseMilestone.IPM_Phase__c)
                        {
                            break;
                        }
                        previousPhases.add(phase);      
                    }
                    
                    for(IPM_Milestone__c milestone : milestoneList)
                    {
                        if(currentPhaseMilestone.IPM_Phase__c != null && milestone.IPM_Phase__c != currentPhaseMilestone.IPM_Phase__c)
                        {   
                            // Due date validation check with previous milestones 
                            if(previousPhases.contains(milestone.IPM_Phase__c))
                            {
                                if(milestone.IPM_Due_Date__c != null && milestone.IPM_Due_Date__c > projectDoc.IPM_Postponement_Date__c)
                                {
                                    showErrorMsg = Label.IPM_Milestone_Due_Date;
                                    break;
                                }
                                
                            }
                            else
                            {
                                // Due date validation check with next milestones 
                                if(milestone.IPM_Due_Date__c != null && milestone.IPM_Due_Date__c < projectDoc.IPM_Postponement_Date__c)
                                {
                                    showErrorMsg = Label.IPM_Postponed_Future_Date_Validation;
                                    break;
                                }
                            }
                        }
                    }
                }
                
                if(String.isBlank(showErrorMsg) && currentPhaseMilestone !=null && validPostpone)
                {
                    validPostpone=true;
                    project.IPM_Current_Document_Status__c = projectDoc.IPM_Document_Status__c;
                    project.IPM_Document_Update_Comments__c = projectDoc.IPM_Postponed_Comments__c;  
                    project.IPM_Document_Update_Date__c = projectDoc.IPM_Postponement_Date__c;
                    update project;
                    
                    currentPhaseMilestone.IPM_Planned_Date__c = projectDoc.IPM_Postponement_Date__c;
                    currentPhaseMilestone.IPM_Due_Date__c = projectDoc.IPM_Postponement_Date__c;
                    update currentPhaseMilestone;
                    
                    showPostpone = true;    
                }
            } 
            catch (Exception ex)
            {
                Database.Rollback(sp);
                showErrorMsg = Label.IPM_Generic_ErrorMessage;
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CHANGEPROJDOCSTATUSCONT_STR,
                SUBMIT_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            }  
    }
    
    /***********************************************************************
    @Description :Used on click of the Submit Button if approve with Edits     
    @param: Not Applicable
    @Author: Cognizant
    @return: Void
    @Referenced:submit function
    **********************************************************************/
    public void approvedWithEditsProject(){
       try
            {
                project.IPM_Current_Document_Status__c = projectDoc.IPM_Document_Status__c;
                project.IPM_Document_Update_Date__c = Date.today();  
                update project;
            }
            catch (Exception ex)
            {  
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,system.label.IPM_System_Admin));
                 ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CHANGEPROJDOCSTATUSCONT_STR,
                SUBMIT_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);

            }   
      
    }
    
    /***********************************************************************
    @Description :Used on click of the Submit Button if Approved     
    @param: Not Applicable
    @Author: Cognizant
    @return: Void
    @Referenced:submit function
    **********************************************************************/
    
    public void approveProject(){
      showStop=false;
            showPostpone=false;
            showValidation=false;
            Date dt=date.parse(System.today().format());
            projectDoc.IPM_Approval_Date__c=dt;
            projectDoc.IPM_Updated_User_By__c=UserInfo.getUserId();
            showApprove = true;
                
            IPM_Project_Type__c currentProjectType =  IPM_Utils.retrieveProjectType(project);
            IPM_Project_Type__c nextPhaseProjectType = IPM_Utils.getNextPhase(currentProjectType,false);
            
            List<IPM_Project_Rollout__c> regionalRolloutList = new List<IPM_Project_Rollout__c>();
            List<IPM_Project_Rollout__c> localRolloutList = new List<IPM_Project_Rollout__c>();
             
            if(currentProjectType!=null && nextPhaseProjectType !=null && nextPhaseProjectType.IPM_Phase__c!=null)
            {
                project.IPM_Current_Document_Status__c = projectDoc.IPM_Document_Status__c;
                project.IPM_Document_Update_Date__c = Date.today();
                project.IPM_Document_Update_Comments__c = projectDoc.IPM_Approved_Comments__c;
                project.IPM_Phase__c = nextPhaseProjectType.IPM_Phase__c;
                
                if(currentProjectType.IPM_CreateRegionalProjectOnStatusChange__c)
                {
                    Id currentProjectId = project.Id;// used in teh query Below NO SONAR
                    
                    String rolloutQuery = IPM_Utils.prepareSOQLQuery('IPM_Project_Rollout__c',false,null,true);
                    String rolloutWhereClause = ' WHERE IPM_Project__c =:currentProjectId  AND recordTypeId = :REGIONAL_ROLLOUT_RECORDTYPE limit 10000';
                    rolloutWhereClause = rolloutQuery + rolloutWhereClause;
                    regionalRolloutList = database.query(rolloutWhereClause);
                        
                    if(!regionalRolloutList.isEmpty())
                    {
                        for(IPM_Project_Rollout__c rollout : regionalRolloutList)
                        {
                            rollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                            rollout.IPM_RolloutJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_PHASECHANGE;  
                        }
                    }
                }
                
                if(currentProjectType.IPM_CreateLocalProjectOnStatusChange__c)
                {
                    Id currentProjectId = project.Id;// used in the query  below NO SONAR
                     
                    String rolloutQuery = IPM_Utils.prepareSOQLQuery('IPM_Project_Rollout__c',false,null,true);
                    String rolloutWhereClause = ' WHERE Regional_Project__c  =:currentProjectId  AND recordTypeId = :LOCAL_ROLLOUT_RECORDTYPE limit 10000';
                    rolloutWhereClause = rolloutQuery + rolloutWhereClause;
                    localRolloutList = database.query(rolloutWhereClause);
                        
                    if(!localRolloutList.isEmpty())
                    {
                        for(IPM_Project_Rollout__c rollout : localRolloutList)
                        {
                            rollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                            rollout.IPM_RolloutJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_PHASECHANGE;  
                        }
                    }
                }
            }
            
            
            System.SavePoint sp = Database.SetSavePoint();  
            try
            {   
                if(currentProjectType.IPM_CreateRegionalProjectOnStatusChange__c && regionalRolloutList!=null && !regionalRolloutList.isEmpty())
                {
                    update regionalRolloutList; 
                }
                
                if(currentProjectType.IPM_CreateLocalProjectOnStatusChange__c && localRolloutList!=null && !localRolloutList.isEmpty())
                {
                    update localRolloutList;
                }
                    
                update project; 
            }
            catch (Exception ex)
            {
                Database.Rollback(sp);
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_CHANGEPROJDOCSTATUSCONT_STR,
                SUBMIT_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);

            }
    }
    
    
    
}
