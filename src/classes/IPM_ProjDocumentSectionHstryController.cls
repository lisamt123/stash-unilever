/**********************************************************************************************************************************************
* @author Cognizant
* @date 12/03/2015
* @description Used for Viewing Gate Document Section History and Changing the Project Document Status
*/
public with sharing class IPM_ProjDocumentSectionHstryController extends IPM_ProjectIntermediateController
{   
    //public IPM_Project__c project{get; set;}//used to store query result from IPM_Project__c object
    public Id projectId{get; set;}//used to store current project id
    public List<IPM_Project_Document__c> projectDocList = new List<IPM_Project_Document__c>();
    public IPM_Project_Document__c projectDoc {get; set;}//used to store query result from IPM_Project_Document__c object
    public Id sectionId{get;set;} //used to store query result
    public Boolean secHistory {get;set;} //boolean variable     
    public Boolean isTaskeditable{get;set;} //true if task is editable
    public Boolean isAllTask{get;set;} //boolean variable
    public string gateDocument{get;set;} //used to store gate type
    public IPM_Project_Document_Section__c projDocSec{get; set;}//Used fopr Getting History
    public List<IPM_Project_Document_Section__c> projSectionList{get; set;} 
    public string nextPhase;
    public string nextPhaseMessage{get;set;}
    //For Filled-In Percentage
    public Integer NonNegotiable;
    public Integer removeoptional;
    public decimal FilledinPer{get;set;} //Contains Filled-In Percentage of Project Document Sections
    public Boolean bDocStatusNotStartedOrApproved{get;set;}//Flag to check if document is in Not Started or Approved Status
    public static final String IPM_PROJECTDOC_SECTION_HISTORYCTLR_STR = 'IPM_ProjDocumentSectionHstryController';
    /*******************************************************************************************************************************************
* @description Fetching the Page Parameters and Retrieving Project and Projec Document
*/ 
    public IPM_ProjDocumentSectionHstryController(){
        projDocSec=new IPM_Project_Document_Section__c();
        FilledinPer=0;
        isTaskeditable=false;
        isAllTask=false; 
        bDocStatusNotStartedOrApproved = false;
        projectId=ApexPages.currentPage().getParameters().get('Id');
        if(ApexPages.currentPage().getParameters().get('projDocSecId')!=NULL){
            sectionId=ApexPages.currentPage().getParameters().get('projDocSecId');
            secHistory=true;
        }
        else{
            secHistory=false;
        }
        if(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_IDEAS) {
            gateDocument=IPM_ConstantUtils.CHARTER_GATE;   
            nextPhase = IPM_ConstantUtils.PHASE_FEASIBILITY ;
        }else if(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_FEASIBILITY && project.IPM_GateKeeping_Model__c==IPM_ConstantUtils.GATEKEEPING_MODEL_GCLT){         
            gateDocument=IPM_ConstantUtils.CONTRACT_GATE;
            nextPhase = IPM_ConstantUtils.PHASE_CAPABILITY ;
        }else if(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_FEASIBILITY && project.IPM_GateKeeping_Model__c==IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT && project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT){
            gateDocument=IPM_ConstantUtils.CONTRACT_GATE;
            nextPhase = IPM_ConstantUtils.PHASE_CAPABILITY ;
        }else if(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_FEASIBILITY && project.IPM_GateKeeping_Model__c==IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT && project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL){      
            gateDocument=IPM_ConstantUtils.CHARTER_GATE;
            nextPhase = IPM_ConstantUtils.PHASE_CAPABILITY ;
       }else if(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_FEASIBILITY && project.IPM_GateKeeping_Model__c==IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT && project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL){      
            gateDocument=IPM_ConstantUtils.CONTRACT_GATE;
            nextPhase = IPM_ConstantUtils.PHASE_CAPABILITY ;
                }else if(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_FEASIBILITY && project.IPM_GateKeeping_Model__c==IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH){      
            gateDocument=IPM_ConstantUtils.CONTRACT_GATE; 
            nextPhase = IPM_ConstantUtils.PHASE_CAPABILITY ;                      
        }else if(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_CAPABILITY){            
            gateDocument=IPM_ConstantUtils.MARKET_READY_GATE;
            nextPhase = IPM_ConstantUtils.PHASE_MARKET_READY ;
        }else if(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_MARKET_READY && (project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL || project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)){
            gateDocument=IPM_ConstantUtils.MARKET_READY_GATE;
            nextPhase = IPM_ConstantUtils.PHASE_MARKET_DEPLOYMENT ;
        }else if(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_MARKET_READY && project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL){
            gateDocument=IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE;
            nextPhase = IPM_ConstantUtils.PHASE_MARKET_DEPLOYMENT ;
        }else if(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_MARKET_DEPLOYMENT && project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL){
            gateDocument=IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE; 
        }else if(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_PLE && project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL){
            gateDocument=IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE;  
        }
        
        
        if((project.IPM_Phase__c!=IPM_ConstantUtils.PHASE_CAPABILITY && (project.IPMProject_Span__c!=IPM_ConstantUtils.PROJECT_SPAN_LOCAL || project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)) ||
            (project.IPM_Phase__c!=IPM_ConstantUtils.PHASE_FEASIBILITY && (project.IPMProject_Span__c!=IPM_ConstantUtils.PROJECT_SPAN_LOCAL || project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)) ||
            (project.IPM_Phase__c!=IPM_ConstantUtils.PHASE_PLE && (project.IPMProject_Span__c!=IPM_ConstantUtils.PROJECT_SPAN_LOCAL || project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)) ||
            ((project.IPM_Phase__c==IPM_ConstantUtils.PHASE_MARKET_READY || project.IPM_Phase__c==IPM_ConstantUtils.PHASE_MARKET_DEPLOYMENT) && project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL)){        
                projectDocList=[SELECT Id,IPM_Contract_GateKeeper_Model__c,IPM_Project_Template__r.IPM_Template_Complexity__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,
                            LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name,IPM_GateDocuments__c,IPM_Project__c 
                            FROM IPM_Project_Document__c 
                            WHERE IPM_Project__c=:project.Id AND IPM_GateDocuments__c=:gateDocument]; 
                projectDoc= new IPM_Project_Document__c();
                if(projectDocList!=null && !projectDocList.isEmpty()){
                    projectDoc= projectDocList[0];
                }
                
                 //For Storing Filled-In Percentage Calculation in Project Object 
                If(projectDoc != null && ( projectDoc.IPM_Document_Status__c==IPM_ConstantUtils.STATUS_NOT_STARTED || projectDoc.IPM_Document_Status__c==IPM_ConstantUtils.STATUS_APPROVED)){
                		bDocStatusNotStartedOrApproved = true;
                		
                        Integer NonNegotiable=[SELECT count() FROM IPM_Project_Document_Section__c 
                                               WHERE IPM_Default_Section__c=true AND IPM_Project_Document__c=:projectDoc.Id 
                                               AND IPM_Section__r.IPM_Section_Type__c IN :IPM_ConstantUtils.SECTION_LIST_WO_HEADER_SUBHEADER];
                        Integer removeoptional=[SELECT count() FROM IPM_Project_Document_Section__c 
                                                WHERE IPM_Section_Status__c=:IPM_ConstantUtils.SECTION_STATUS_FILLED 
                                                AND IPM_Project_Document__c=:projectDoc.Id AND  IPM_Default_Section__c=true AND 
                                                IPM_Section__r.IPM_Section_Type__c IN :IPM_ConstantUtils.SECTION_LIST_WO_HEADER_SUBHEADER];
                                
                                if(NonNegotiable!=0){
                                        FilledinPer=math.round((Decimal.valueof(removeoptional)/decimal.valueof(NonNegotiable))*100);
                                }
                                
                        }            
                
                projSectionList=new List<IPM_Project_Document_Section__c>();
                
                projSectionList=[SELECT Id,IPM_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.Id,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,
                                 LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c 
                                 FROM IPM_Project_Document_Section__c 
                                 WHERE IPM_Project_Document__c=:projectDoc.Id Limit 1];          
            }if(gateDocument != null && !String.isBlank(gateDocument) && nextPhase!= null && !String.isBlank(nextPhase)){
                nextPhaseMessage = string.format(System.Label.IPM_ProjectPhaseChangeMesg, new string[] {nextPhase,gateDocument});
            }
        
    }
    
    /*******************************************************************************************
    @description To Move the Gate Document to next phase When the Status is Approved with Edits
*/ 
    public static String LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId();
    public static String REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).getRecordTypeId();
    public static String MOVE_TO_NEXT_DOC_STR = 'moveToNextDocument'; 
    public void moveToNextDocument(){
        
        Date dt=date.parse(System.today().format());
        projectDoc.IPM_Approval_Date__c=dt;
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
                    Id currentProjectId = project.Id; // variable used in query below NO SONAR
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
                    Id currentProjectId = project.Id; // variable used in query below NO SONAR
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
            catch (DmlException ex)
            {
                Database.Rollback(sp);
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTDOC_SECTION_HISTORYCTLR_STR,
                MOVE_TO_NEXT_DOC_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);

        }
            catch (Exception ex)
            {
            Database.rollback(sp);
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_PROJECTDOC_SECTION_HISTORYCTLR_STR,
                MOVE_TO_NEXT_DOC_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
}