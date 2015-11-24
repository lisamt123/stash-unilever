/**************************************************************************************************************
*@Author:Cognizant
*@Date:October 2014
*@Description : This is the Controller used to display Count of Tasks and Milestones.
*To display Alerts and give permissions as prt of security.
*Referring in IPM_TaskList Page
****************************************************************************************************************/

 
public with sharing class IPM_Taskview extends IPM_ProjectIntermediateController { 

    public Boolean pmApproachMessage {get;set;} // To check the Approach of the project
    public Boolean isTaskeditable {get;set;} // To check if the task is editable
    public Boolean isAllTask {get;set;} // To check the task list
    public Boolean isMilestoneEditable {get;set;} // To check the milestone is editable
    public Boolean isBDuser {get;set;} // Teammember permissions
    public Boolean isupdateDates {get;set;} // Update Due dates
    public string functionRole {get;set;}  // To know the Functional role of the user    
    public boolean isvisible {get;set;} // Visibility of the page
    public id projectId {get;set;} // Getting the projectids
    public Boolean updateApproach{get;set;}//checking for security
    public Boolean updateComplexity{get;set;}//checking for security
    public IPM_Project_Type__c projectType{get;set;}
    //*@Description: Specifies complexity type
    public string complexityType{get;set;}
    private final String IPM_TASKVIEW_STR = IPM_Taskview.class.getName();
    private static final String ERROR_STR = 'Error';
    public boolean isCreateTask{get;set;}
    
    /****************************************************************************
@Description : Initialization of the parameterized constructor 
@Param: Controller
*****************************************************************************/
    
    public Ipm_Taskview (ApexPages.StandardController controller) {
        try
        {
            isupdateDates = true;
            isvisible = true;
            isCreateTask=false;
            functionRole = '';
            complexityType = '';
            updateApproach = false;
            isMilestoneEditable = false;
            isTaskeditable = false;
            isAllTask = false;
            updateComplexity = false;
            projectId = apexpages.currentpage().getparameters().get(IPM_Utils.Id);
            getIpmuserType();
            
            complexityType = project.IPM_Complexity__c;
            
            if(project.IPM_PM_Approach__c == IPM_Utils.External)
            {
                pmApproachMessage = true;
            }
            
            if(project.IPM_Phase__c == IPM_ConstantUtils.PHASE_PLE)
            {
                isMilestoneEditable = isTaskeditable = isupdateDates = false;
            }   

            projectType = IPM_Utils.retrieveProjectType(project);
                     
        }catch(Exception eX){ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,Label.IPM_Generic_ErrorMessage);ApexPages.addMessage(myMsg); }
    }
    
    
    
    /****************************************************************************
    @Description : To get the users based on Functional Role
    @Param: project id
    *****************************************************************************/
    
    public void getIpmuserType(){
        try
        {
            Id loggedInUser = userinfo.getuserid();
           
            // To query the Team Members on project Resource object
            list<IPM_Project_Resource__c> projectResourceList = [select Id,IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,IPM_Project__r.IPM_Project_Leader__c,IPM_Project__r.Deputy_Project_Leader__c,IPM_Project__r.IPM_Technical_Project_Leader__c 
                                                                 from IPM_Project_Resource__c where 
                                                                 IPM_Project__c=:projectId and IPM_User__c=:userinfo.getuserid() and IPM_Project__r.Is_Archieved__c=false  limit 1];
            
            if(projectResourceList != null && !projectResourceList.isEmpty()){
                IPM_Project_Resource__c projectResource = projectResourceList[0];
              
                if( projectResource.IPM_Role_Type__c != IPM_Utils.Guest ){
                
                    isMilestoneEditable = false;
                    
                    if( projectResource.IPM_Role_Type__c == IPM_Utils.BD || projectResource.IPM_Role_Type__c == IPM_Utils.BDMarketing )
                    {
                        isBDuser=true;
                    }
                   if(projectResource.IPM_Project_Role_Owner__c)
                   {
                                isCreateTask=true;
                                isTaskeditable =true;
                   }
                }
                else {
                    isMilestoneEditable=false;
                    
                }
                if( projectResource.IPM_Role_Type__c != null && !String.isBlank(projectResource.IPM_Role_Type__c)){
                    functionRole = projectResource.IPM_Role_Type__c;
                }
                if(projectResource.IPM_Role_Type__c==IPM_Utils.CMI || projectResource.IPM_Role_Type__c==IPM_Utils.CD || projectResource.IPM_Role_Type__c==IPM_Utils.Finance || projectResource.IPM_Role_Type__c==IPM_Utils.Guest){
                    isupdateDates=false;
                }
            } 
            
            // Checking the user List
            if(!project.Is_Archieved__c){
                // To check the Project Leader
               if( loggedInUser != null && ( loggedInUser == project.IPM_Project_Leader__c || loggedInUser == project.Deputy_Project_Leader__c ))                            
                {
                    isMilestoneEditable=true;
                    
                }
              
               if(loggedInUser == project.IPM_Project_Leader__c || loggedInUser == project.Deputy_Project_Leader__c || loggedInUser == project.IPM_Technical_Project_Leader__c)
               {
                        isTaskeditable =true;
                        isCreateTask=true;
                        isAllTask=true;
                        
                        if(loggedInUser == project.IPM_Project_Leader__c || loggedInUser == project.Deputy_Project_Leader__c || (loggedInUser == project.IPM_Technical_Project_Leader__c && (project.IPM_Technical_Project_Leader__c == project.IPM_Project_Leader__c || project.IPM_Technical_Project_Leader__c == project.Deputy_Project_Leader__c))){
                            
                            updateApproach =true;
                            updateComplexity = true;
                        }
               }
            }
            //security for central team and BP users
                IPM_CustomPermission cpr = new IPM_CustomPermission();
                boolean isCentralTeam=false;
                boolean isBPUser=false;
                isCentralTeam = cpr.hasPermission(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
                isBPUser=cpr.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
                if(isCentralTeam || isBPUser){
                    isMilestoneEditable=true;
                    isTaskeditable=true;
                    updateApproach=true;
                    updateComplexity = true;
                    isCreateTask=true;
                    isAllTask=true;
                } 
            
            
        }catch(Exception eX){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage)); ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_TASKVIEW_STR,'getIpmuserType',ex.getMessage(),ex, ERROR_STR, null, null, null,null); }       
    }    
    /****************************************************************************
    @Description : save complexity type
    *****************************************************************************/
    
    public void saveComplexityType(){
        list<IPM_Project__c> projectUpdateList = new list<IPM_Project__c>();
        
        if(project.IPM_Complexity__c != complexityType || project.IPM_Child_Complexity__c != complexityType )
        {
                project.IPM_Complexity__c = complexityType;
                project.IPM_Child_Complexity__c = complexityType;
                projectUpdateList.add(project);
        }
        try
        {
            if(!projectUpdateList.isEmpty())
            {
                update projectUpdateList;
            }
        }
        catch(Exception ex) {ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_TASKVIEW_STR,'SaveComplexityType',ex.getMessage(),ex, ERROR_STR, null, null, null,null); }
    }  
}