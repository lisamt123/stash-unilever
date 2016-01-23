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
        
        
        if((project.IPM_Phase__c!=IPM_ConstantUtils.PHASE_CAPABILITY && project.IPMProject_Span__c!=IPM_ConstantUtils.PROJECT_SPAN_LOCAL) ||
            (project.IPM_Phase__c!=IPM_ConstantUtils.PHASE_FEASIBILITY && project.IPMProject_Span__c!=IPM_ConstantUtils.PROJECT_SPAN_LOCAL) ||
            (project.IPM_Phase__c!=IPM_ConstantUtils.PHASE_PLE && project.IPMProject_Span__c!=IPM_ConstantUtils.PROJECT_SPAN_LOCAL) ||
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
                                                                   WHERE IPM_Default_Section__c=true AND IPM_Project_Document__c=:projectDoc.Id AND IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_HEADER AND 
                                                                   IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_SUBHEADER AND IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c!=:IPM_ConstantUtils.APPENDIX];
                        Integer removeoptional=[SELECT count() FROM IPM_Project_Document_Section__c 
                                                                        WHERE IPM_Section_Status__c=:IPM_ConstantUtils.SECTION_STATUS_FILLED AND IPM_Project_Document__c=:projectDoc.Id AND  IPM_Default_Section__c=true AND 
                                                                    IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_HEADER AND IPM_Section__r.IPM_Section_Type__c!=:IPM_ConstantUtils.SECTION_TYPE_SUBHEADER AND IPM_Section__r.IPM_Parent_Section__r.IPM_Section_Name__c!=:IPM_ConstantUtils.APPENDIX];
                                
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
    
    /*******************************************************************************************************************************************
* @description For Moving to Next Gate Document When Status is Approved with Edit
*/ 
    public void moveToNextDocument(){
        //Savepoint for Rollback Transaction
        Savepoint sp;
        try{
            sp = Database.setSavepoint();
            List<IPM_Project__c> childProjects=new List<IPM_Project__c>(); //Contains Child Project
            IPM_Project__c ParentProject=new IPM_Project__c(); //Contains Parent Project
            if(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_IDEAS)
                project.IPM_Phase__c=IPM_ConstantUtils.PHASE_FEASIBILITY;
            else{
                childProjects=[SELECT Id,IPM_Phase__c,IPM_Parent_Project__c FROM IPM_Project__c WHERE IPM_Parent_Project__c=:project.Id];
                if(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_FEASIBILITY && project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){
                    for(IPM_Project__c cp:childProjects){
                        cp.IPM_Phase__c=IPM_ConstantUtils.PHASE_CAPABILITY;    
                    }
                    project.IPM_Phase__c=IPM_ConstantUtils.PHASE_CAPABILITY;
                }
                else if(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_FEASIBILITY && project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL){
                    project.IPM_Phase__c=IPM_ConstantUtils.PHASE_CAPABILITY;    
                }
                else if(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_CAPABILITY && project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL){
                    for(IPM_Project__c cp:childProjects){
                        cp.IPM_Phase__c=IPM_ConstantUtils.PHASE_MARKET_READY;    
                    }
                    project.IPM_Phase__c=IPM_ConstantUtils.PHASE_MARKET_READY;
                }
                else if(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_CAPABILITY && project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL){
                    project.IPM_Phase__c=IPM_ConstantUtils.PHASE_MARKET_READY;    
                }   
                
                else if(project.IPM_Phase__c==IPM_ConstantUtils.PHASE_MARKET_READY && project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL){
                    project.IPM_Phase__c=IPM_ConstantUtils.PHASE_MARKET_DEPLOYMENT;    
                }
                if(project.IPM_Parent_Project__c!=null && project.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && project.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT && project.IPM_GateKeeping_Model__c==IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT){
                    ParentProject=[SELECT id,IPM_Actual_Launch_Date__c,IPM_GateKeeping_Model__c,IPM_Phase__c FROM IPM_Project__c WHERE id=:project.IPM_Parent_Project__c];
                    ParentProject.IPM_Phase__c=project.IPM_Phase__c;
                    update ParentProject;
                }
            }
            //Updating Project phase
            update project;
            //Updating Phase of Child Projects
            if(childProjects!=null && !childProjects.isEmpty())
                update childProjects;
            //Updating Project Document Status Approved    
            projectDoc.IPM_Contract_GateKeeper_Model__c=project.IPM_GateKeeping_Model__c;
            Date dt=date.parse(System.today().format());
            projectDoc.IPM_Approval_Date__c=dt;
            projectDoc.IPM_Document_Status__c=IPM_ConstantUtils.STATUS_APPROVED;
            update projectDoc;
        }
        catch(Exception ex){
            Database.rollback(sp);
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),'IPM_ProjDocumentSectionHstryController',
                'moveToNextDocument',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);                
        }
    }
    
}