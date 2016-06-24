/****************************************************************************
@Description : To Display the list of Active Projects
@Created Date: March 2015
@Author: Cognizant
@Referenced: ipmMyActiveProjects,ipmMyActiveProjects1 components
*****************************************************************************/
public with sharing class IPM_MyProjects{
    
    //*@Description: Used to store current project Id
    public String projectId{get;set;}
    
    //*@Description: Used to store project count
    public integer projectcount {get;set;}
    
    //*@Description: Used for alert message
    public Map<String,integer> alertMessage {get;set;}
    private static final string CLASS_NAME = IPM_MyProjects.class.getName();
    private Integer DAY_VALUE = 14;
    //*@Description: Used to refer "Filled-In string
     public string getFilledString(){
         return IPM_ConstantUtils.STATUS_NOT_FILLED;
     }
    /****************************************************************************
    @Description : Initialization of the parameterized constructor 
    @Param: Controller
    *****************************************************************************/
    
    public IPM_MyProjects(IPM_HomePageController controller) {
        alertMessage=new Map<String,integer>();
        getProjects();
    }
    
    /****************************************************************************
    @Description : Initialization of the constructor and reading the page Parameters
    *****************************************************************************/
    
    public IPM_MyProjects() {
        alertMessage = new Map<String,integer>();
    }
    
    
    /****************************************************************************
    @Description : Used to get projects
    @Return: List
    *****************************************************************************/
    public List<ProjectWrapper> getProjects() {
        projectcount =0; 
        List<IPM_Project__c> lstProjects;
        List<IPM_Milestone__c> lstipmmilestones;
        List<Id> projectIds=new List<Id>();
        for(IPM_Project_Resource__c res : [SELECT IPM_Project__c FROM IPM_Project_Resource__c 
                                       WHERE IPM_User__c = : UserInfo.getUserId() 
                                       and IPM_Role_Type__c != : IPM_ConstantUtils.IPM_ROLE_GUEST 
                                       Limit 10000]){
                projectIds.add(res.IPM_Project__c);
        }
      
        try {
           // @@ Design Review - Change to get the list of all project user has acess to                                  
          lstProjects =[SELECT Name,IPM_Bosscard_Status__c,IPM_Bosscard__r.IPM_Brand__c,IPM_Brand_Positioning__c, IPM_Project_Type__c, IPM_GateKeeping_Model__c, IPMProject_Span__c,
                            IPM_CompanyCardText__c ,
                                            IPM_Bosscard__r.IPM_Filled_In_Percent__c,IPMRegion__c,IPM_Bosscard__r.Name,
                                            IPM_Bosscard__r.IPM_Bosscard_Logo__c,IPM_Bosscard__r.IPM_Bosscard_Status__c,IPM_Project_Logo__c,IPM_Brand__c,
                                            IPM_Category_Text__c,IPM_FilledIn_Percentage__c,IPM_Phase__c,IPM_Project_Job_Status__c,IPM_IsSaved__c,IPM_Project_Name__c,IPM_Target_Launch_Dates__c 
                                            FROM IPM_Project__c WHERE (IPM_Project_Leader__c = : UserInfo.getUserId() 
                                            or Deputy_Project_Leader__c  = : UserInfo.getUserId()  or IPM_Technical_Project_Leader__c = : UserInfo.getUserId() 
                                            or IPM_Project_Gatekeeper__c = : UserInfo.getUserId() or IPM_Finance_Lead__c = : UserInfo.getUserId() 
                                            or IPM_Bosscard__r.OwnerId = :UserInfo.getUserId() or Id IN : projectIds)  and Is_Archieved__c = false 
                                            and IPM_Project_Name__c != NULL and IPM_Phase__c != :IPM_ConstantUtils.PHASE_PLE 
                                            Order By Upcoming_Milestone_Due_Date__c,IPM_Project_Name__c Limit 1000];
                                                                            
                                            
          Id recordtypeid=Schema.Sobjecttype.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.PROJECT_MILESTONES).getRecordTypeId();
          
          lstipmmilestones=[SELECT Id,IPM_Name__c,IPM_Project__c,IPM_Project__r.Name,
                                                  IPM_Project__r.IPM_Phase__c,IPM_Due_Date__c,IPM_Planned_Date__c,
                                                  IPM_Completed_On__c,IPM_Phase__c FROM IPM_Milestone__c 
                                                  WHERE IPM_Project__c IN : lstProjects and 
                                                  IPM_Type_of_Milestone__c =: IPM_ConstantUtils.STANDARD  And RecordtypeId = : recordtypeid Limit 10000];
                                                
        }
        catch(Exception ex) {
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                            'getProjects',ex.getMessage(),ex, 'Error', null, null, null,null);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,system.label.IPM_System_Admin));         
        }       
        Map<Id,String> mapdocsDate=new Map<Id,String>();
        
        for(IPM_Milestone__c ipmmiles:lstipmmilestones){
            if(ipmmiles.IPM_Project__r.IPM_Phase__c == ipmmiles.IPM_Phase__c){
                if(ipmmiles.IPM_Due_Date__c != null && Date.valueOf(System.now().format(IPM_ConstantUtils.DATE_FORMAT)).daysBetween(ipmmiles.IPM_Due_Date__c) <= DAY_VALUE && IPM_Utils.phaseGateDocumentMap.containsKey(ipmmiles.IPM_Phase__c)){
                   
                        alertMessage.put(ipmmiles.IPM_Project__r.Name+IPM_Utils.phaseGateDocumentMap.get(ipmmiles.IPM_Phase__c),Date.valueOf(System.now().format('YYYY-MM-dd')).daysBetween(ipmmiles.IPM_Due_Date__c));
                  
                } 
                mapdocsDate.put(ipmmiles.IPM_Project__c,ipmmiles.IPM_Due_Date__c+IPM_ConstantUtils.COMMA+ipmmiles.IPM_Name__c);
            }
        }
        //get bosscard list
        list<IPM_Bosscard__c>bosscardList=new list<IPM_Bosscard__c>();
        //Changed the query to show only In Progress bosscards where logged-in user is the owner & not displaying skipped bosscard 
        bosscardList=[SELECT name,IPM_Category__c,IPM_Bosscard_Logo__c,IPM_isBosscardSkipped__c,IPM_Brand__c,IPM_BosscardName__c,IPM_Brand_Positioning__c,
                      IPM_Bosscard_Status__c,IPM_Filled_In_Percent__c FROM IPM_Bosscard__c 
                      WHERE IPM_BosscardName__c!=null 
                      AND IPM_Bosscard_Status__c = :IPM_ConstantUtils.STATUS_IN_PROGRESS
                      AND OwnerId = :UserInfo.getUserId() AND IPM_isBosscardSkipped__c=False 
                      order by IPM_BosscardName__c limit 1000];
             
        List<ProjectWrapper> projects=new List<ProjectWrapper>();
        List<ProjectWrapper> projectsWithoutCurrentMilestoneDueDate=new List<ProjectWrapper>();
        
        for(IPM_Bosscard__c bCard:bosscardList){
            projects.add(new ProjectWrapper(new IPM_Project__c(), null,bCard));
            projectcount ++;
        }
        for(IPM_Project__c proj:lstProjects){
        	String d = mapdocsDate.get(proj.Id);
        	if(d != null){
                String[] datephase=d.split(IPM_ConstantUtils.COMMA);
        	if( datephase[0] == 'null' ){
        		projectsWithoutCurrentMilestoneDueDate.add(new ProjectWrapper(proj, mapdocsDate.get(proj.Id),new IPM_Bosscard__c()));
        	}else{
            	projects.add(new ProjectWrapper(proj, mapdocsDate.get(proj.Id),new IPM_Bosscard__c()));
            } 
          }else
            projectsWithoutCurrentMilestoneDueDate.add(new ProjectWrapper(proj, null,new IPM_Bosscard__c()));
            
            projectcount ++;
        }
        projects.addAll(projectsWithoutCurrentMilestoneDueDate);
        
        return projects;
    }
     
    /****************************************************************************
    @Description : Wrapper Class
    *****************************************************************************/

    public class ProjectWrapper {
        //*@Description: Used to refer instance of IPM_Project__c
        public IPM_Project__c projectObj{get;set;}
        //*@Description: Used to store due date of project
        public String projectDocumentDate{get;set;}
        //*@Description: Used to project phase
        public String phaseValue{get;set;}
        //*@Description:Used to refer instance of IPM_Bosscard__c
        public IPM_Bosscard__c bosscardObj{get;set;}
        //*@Description:Used to refer curernt gate name for each project
        public String currGate{get;set;}
        
        
        /****************************************************************************
        @Description : Initialization of the constructor and reading the page Parameters
        @Param: IPM_Project__c,String
        *****************************************************************************/
        public ProjectWrapper(IPM_Project__c p, String d,IPM_Bosscard__c b) {
            
            projectObj = p;
            bosscardObj= b;
            if(d != null){
                String[] datephase=d.split(IPM_ConstantUtils.COMMA);
                if(datephase[0] != 'null'){
                    projectDocumentDate = date.valueOf(datephase[0]).format();
                }
                phaseValue=datephase[1];
                
                 IPM_Project_Type__c currentProjecttype =  IPM_Utils.retrieveProjectType(p);
            if(currentProjecttype != null && currentProjecttype.IPM_Gate_Document__c != null){
                currGate = currentProjecttype.IPM_Gate_Document__c;
            }
               //currGate = phaseValue.remove('Gate Approval').removeEnd(' ');
            }
        }
             
    }
}