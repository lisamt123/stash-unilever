/******************************************** 
*@Author:Cognizant
*@Date: November 2014
*@Description : To add Adhoc Tasks to the project. 
*Referring in  IPM_AddTask Page
*********************************************/
public with sharing class IPM_NewTask {   
     
    private final String IPM_NEWTASK_STR = IPM_NewTask.class.getName();
    private static final string DO_SAVE_TASKS = 'doSaveTasks';
    private static final String PERCENT_SIGN = '%';
    private static final String ERROR = 'Error';
    private static final String SPACE = ' ';
    private map<string,Id> assigneeIdName;
    public IPM_Task__c tasks{get;set;} // To intialize the tasks
    public IPM_Project__c projectObject{get;set;} // Getting the project details
    public sObject taskObject{get;set;} // Quering the task object
    public String sObjName{get; set;} // Initializing the sobject
    public Id projectId{get; set;} // Getting the projectid
    public Id taskId{get; set;} // Getting the taskid
    public boolean displayDueDate {get;set;} // To check the due date 
    public boolean validate {get;set;} // To validate for popup to show
    public boolean redirectToGateDocument {get;set;} // Checking the Gate document exists
    public String redirectToGateDocumentUrl {get;set;} // Redirecting to Gate document page
    public String selectedSectionId {get;set;} // To check the values in the Documnet section values in the picklist
    public String roleValue {get;set;} // To filter the sections based on role
    public string ProjectWizard{get;set;} // Checking for projects related to tasks
    public boolean displayPopup {get; set;} // To display pop up message
    public transient String sectionValue {get;set;}
    public map<Id,String> userIdName{get;set;}
    public String roleList {get;set;}
    public list<SelectOption> FuntionalRolelist;
    public Map<Id,Id> projectDocSectionToSectionMap {get;set;}
    public Map<Id,String> SectionToExtenalIdSectionMap {get;set;}
	public Map<string,set<string>> sectionToFunctionalRoleMap;
    
    
    private Map<String,String> phaseGateMapping;
    
    
    private static final Id recordTypeIdValue = Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectTasks).getRecordTypeId();
    
    private static Map<String, String> phaseGateMap = new Map<String, String>{IPM_Utils.Ideas => IPM_Utils.Charter, IPM_Utils.Feasibility => IPM_Utils.Contract,
                                                                                      IPM_Utils.Capability => IPM_Utils.IPM_MarketReadyGate, IPM_Utils.MarketReady => IPM_Utils.IPM_MarketDeploymentGate,
                                                                                      IPM_Utils.MarketDeployment => IPM_Utils.notapplicable, IPM_Utils.PostLaunchEvaluation => IPM_Utils.notapplicable, IPM_Utils.IPM_Stopped => IPM_Utils.notapplicable};
    private static Map<String, String> projToTaskPhaseMap = new Map<String, String>{IPM_Utils.Ideas => IPM_Utils.Ideas, IPM_Utils.Feasibility => IPM_Utils.Feasibility,
                                                                                      IPM_Utils.Capability => IPM_Utils.Capability, IPM_Utils.MarketReady => IPM_Utils.MarketReady,
                                                                                      IPM_Utils.MarketDeployment => IPM_Utils.MarketDeployment, IPM_Utils.IPM_PLE => IPM_Utils.PostLaunchEvaluation};
    /*Description :Constructor to fetch the details of the Tasks*/
    
    public IPM_NewTask (ApexPages.StandardController controller) 
    {
        try{
            IPM_IECompatible.ieFix();
            phaseGateMapping =  new Map<String,String>();
            projectDocSectionToSectionMap = new Map<Id,Id>();
            SectionToExtenalIdSectionMap = new Map<Id,String>();
            
            ProjectWizard=ApexPages.currentPage().getParameters().get(IPM_Utils.projectWizard);
            tasks = (IPM_Task__c)controller.getRecord();
            if(String.IsNotBlank(ApexPages.currentPage().getParameters().get(IPM_Utils.projDocSecId)))
            {
                redirectToGateDocument = true;  
                redirectToGateDocumentUrl= IPM_Utils.projDocSecId;
            }
            else
            {
                redirectToGateDocument = false;  
            }
            //query project with its resources and milestone
            if(String.IsNotBlank(ApexPages.currentPage().getParameters().get(IPM_Utils.IPM_NewTaskprojectId)))
            {
                projectId = ApexPages.currentPage().getParameters().get(IPM_Utils.IPM_NewTaskprojectId);
                sObjName = projectId.getSObjectType().getDescribe().getName();
               try
                { 
                    Set<String> childList = new Set<String> {'IPM_Project_Resource__c','IPM_Milestone__c'};
                    string query = IPM_Utils.prepareSOQLQuery(sObjName ,true,childList,true)+' where id =: projectId ';
                    projectObject  = Database.query(query);
                                        
                    if(projectObject != null )
                    {   
                        //get map of role as key and its functional owner as value
                        assigneeIdName = getAssignee(projectObject);
                        
                        //set of all user including logged in user
                        set<Id> userId = new set<Id>();
                        if(assigneeIdName != null && !assigneeIdName.isEmpty())
                        {
                            for(string role : assigneeIdName.keySet())
                            {
                                userId.add(assigneeIdName.get(role));
                            }
                        }
                        
                        //query the user in and create map of user id as key and user name as value
                        userIdName = new Map<Id,String>();
                        for(User usr : [Select Id,Name from User Where Id IN: userId ] )
                        {
                            userIdName.put(usr.id,usr.Name);
                         }
                     }
                   
                // To check the user Role 
                //if the Add Task New is invoked from associated ToDos of section then default values should be populated. 
                if(redirectToGateDocument)
                {
                    id proDocSecId = ApexPages.currentPage().getParameters().get(IPM_Utils.projDocSecId);
                    list<IPM_Project_Document_Section__c> proDocSecList = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Section__c,IPM_Default_Section__c,IPM_FunctionalRole__c from IPM_Project_Document_Section__c where Id =:proDocSecId ];
                    if(proDocSecList != NULL && !proDocSecList.isEmpty()){
                        tasks.IPM_Function__c = proDocSecList[0].IPM_FunctionalRole__c;
                        sectionValue = string.valueOf(proDocSecList[0].IPM_Section_Sequence__c+ SPACE +proDocSecList[0].IPM_Section_Name__c);
                        selectedSectionId  = proDocSecList[0].id;
                    }
                }

                if(projectObject != null)
                {
                    //assign task assignee from map  and assign phase and gate type values same as project
                    if(tasks.IPM_Function__c != null && assigneeIdName != null && assigneeIdName.containsKey(tasks.IPM_Function__c)){
                    tasks.IPM_Assignee__c = assigneeIdName.get(tasks.IPM_Function__c);
                    }
                    if(projToTaskPhaseMap.containsKey(projectObject.IPM_Phase__c)) 
                    {
                        tasks.IPM_Phase__c = projToTaskPhaseMap.get(projectObject.IPM_Phase__c);
                        tasks.IPM_Type_of_Gate__c = phaseGateMap.get(tasks.IPM_Phase__c);
                    }
                    tasks.IPM_Task_Complexity__c = projectObject.IPM_Complexity__c;
                  }
                    
                } 
                catch(Exception ex)
                {
                    ApexPages.addMessage(new  ApexPages.Message(ApexPages.Severity.ERROR,IPM_Utils.Invalidproject));
                }
            }
            
            if(String.IsNotBlank(ApexPages.currentPage().getParameters().get(IPM_Utils.taskId)))
            {
                taskId = ApexPages.currentPage().getParameters().get(IPM_Utils.taskId);
				 sectionWiseFunctionalRoleList();
                try
                {
                    sObjName = taskId.getSObjectType().getDescribe().getName();
                    String query=IPM_Utils.prepareSOQLQuery(sObjName ,false,null,true)+' where id =: taskId ';
                    taskObject= Database.query(query);
                    
                    tasks = (IPM_Task__c)taskObject;
                    if(tasks.Id == null && tasks.IPM_Project__c == null)
                    {
                       tasks.IPM_Project__c=apexpages.currentpage().getparameters().get(IPM_Utils.IPM_NewTaskprojectId);
                    }
                    
                    if(tasks.IPM_Type_of_Task__c == IPM_ConstantUtils.FUTURE_ADHOC_TASKS  || tasks.IPM_Type_of_Task__c == IPM_ConstantUtils.FUTURE_STANDARD_TASKS)
                    {
                        selectedSectionId = tasks.IPM_Section__c;
                    }
                    else
                    {
                        selectedSectionId = tasks.IPM_Project_Document_Section__c;
                    }
                    
                }
                catch(Exception ex)
                {
                    ApexPages.addMessage(new  ApexPages.Message(ApexPages.Severity.ERROR,IPM_Utils.Invalidproject)); 
                }
            }
            else
            {
                // In case there is no task Id associated, it means we are creating new adhoc task.
                tasks.IPM_Type_of_Task__c = IPM_ConstantUtils.ADHOC;
                tasks.IPM_Phase_Task_Added__c = projectObject.IPM_Phase__c;
                tasks.RecordTypeId = recordTypeIdValue;
                tasks.IPM_Project__c = apexpages.currentpage().getparameters().get(IPM_Utils.IPM_NewTaskprojectId);
                
            }
            // Displaying due dates based on Approach
            displayDueDate=true;
            if(projectObject.IPM_PM_Approach__c == IPM_Utils.External){
                displayDueDate = false;
            }
                        
        }catch(Exception ex){
            ApexPages.addMessage(new  ApexPages.Message(ApexPages.Severity.ERROR,IPM_Utils.Invalidproject)); 
         }
    }
    
    public void closePopup()
    {       
        displayPopup = false;   
    } 
    
    public void showPopup()
    {       
        displayPopup = true;   
    }
    
    public void upsertTask(List<IPM_Task__c> task)
    {
        List<Database.UpsertResult> taskResult = Database.upsert(task, false);
        String sErrorMessage = IPM_ConstantUtils.BLANK;
        for(Database.UpsertResult upsertResult : taskResult){
            if(!upsertResult.isSuccess()){
                for(Database.error errorResult : upsertResult.getErrors()){
                        sErrorMessage += errorResult.getMessage();
                }
            }
        }
        if(String.isNotBlank(sErrorMessage)){
            ApexPages.addMessage(new  ApexPages.Message(ApexPages.Severity.ERROR,IPM_Utils.Invalidproject)); 
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_NEWTASK_STR,'upsertTask',sErrorMessage,null, ERROR, null, null, null,null);
        }
    }
        
    /***************************************************************
    *@Description :Redirecting to Gate doc on click of Task Name
    *@Param: Present Taskid
    ****************************************************************/
    
    public pageReference doSaveTasks(){
        try
        {
            validate = true;
            
            //assign task assign from map created in constructor
            if(tasks.IPM_Function__c != null && assigneeIdName != null && assigneeIdName.containsKey(tasks.IPM_Function__c)){
                tasks.IPM_Assignee__c = assigneeIdName.get(tasks.IPM_Function__c);
            }
            
            if(tasks.IPM_Type_of_Task__c == IPM_ConstantUtils.FUTURE_ADHOC_TASKS  || tasks.IPM_Type_of_Task__c == IPM_ConstantUtils.FUTURE_STANDARD_TASKS)
            {
                tasks.IPM_Section__c = selectedSectionId;
                tasks.IPM_Task_Section_External_ID__c = SectionToExtenalIdSectionMap.get(selectedSectionId);
                tasks.IPM_Project_Document_Section__c = null;
            }
            else
            {
            	if(projectDocSectionToSectionMap.containsKey(selectedSectionId))
            	{
            		tasks.IPM_Section__c = projectDocSectionToSectionMap.get(selectedSectionId);
            	}
                tasks.IPM_Task_Section_External_ID__c = SectionToExtenalIdSectionMap.get(selectedSectionId);
                tasks.IPM_Project_Document_Section__c = selectedSectionId;
            }
            
            tasks.IPM_Active__c = true;
            
            // check for task due date, which should not be greater than milestone due date
            checkTaskDueDateGreaterThanMilestone(projectObject);
            
            checkTaskValidations(tasks);
                
              try{
                if(String.isNotBlank(tasks.IPM_Task_Name__c) && validate)
                {
                    upsertTask(new List<IPM_Task__c>{tasks});
                }
             }catch(Exception ex)
             {
                ApexPages.addMessage(new  ApexPages.Message(ApexPages.Severity.ERROR,IPM_Utils.Invalidproject)); 
                validate =false;
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_NEWTASK_STR, DO_SAVE_TASKS,ex.getMessage(),ex, ERROR, null, null, null,null);
            }
            closePopup();
        }catch(Exception ex)
        {
            ApexPages.addMessage(new  ApexPages.Message(ApexPages.Severity.ERROR,IPM_Utils.Invalidproject)); 
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_NEWTASK_STR, DO_SAVE_TASKS,ex.getMessage(),ex, ERROR, null, null, null,null);
        }
        return null;            
    }
    
    /********************************************************************************
     *@Description : check the task validations
     *@Return : none
    *********************************************************************************/
    public void checkTaskValidations(IPM_Task__c tasks)
    {
        //check if name is blank
        if(String.isBlank(tasks.IPM_Task_Name__c))
        {
            validate = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.IPM_TaskNameErrorMsg));
        } 
            //check if Function role is blank
        if(String.isBlank(tasks.IPM_Function__c))
        {
            validate = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.IPM_FunctionalRoleErrorMsg));
        }
             
        if(tasks.IPM_Due_Date1__c < System.Today())
                {
                validate = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.IPM_TaskDueDateErrorMsg));
                }
             
      if(String.isNotBlank(tasks.IPM_Type_of_Gate__c) && tasks.IPM_Type_of_Gate__c == IPM_Utils.notapplicable)
                {
                tasks.IPM_Type_of_Gate__c = IPM_ConstantUtils.BLANK;
                }
    }
    
    
    /********************************************************************************
     *@Description : create task due date validations
     *@Return : none
    *********************************************************************************/
    public void checkTaskDueDateGreaterThanMilestone(IPM_Project__c projectObject)
    {
        if(projectObject != null && projectObject.IPM_Milestones__r != null )
        {
            
            for(IPM_Milestone__c milestone :projectObject.IPM_Milestones__r)
            {
                if(milestone.IPM_Due_Date__c != null && tasks.IPM_Due_Date1__c != null && milestone.IPM_Type_of_Milestone__c == IPM_Utils.Standard && milestone.IPM_Phase__c == tasks.IPM_Phase__c
                    && tasks.IPM_Due_Date1__c > milestone.IPM_Due_Date__c )
                {   
                validate = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.IPM_TaskDueDateErrorMsg));
                }
            }
         }
    }
    /********************************************************************************
     *@Description : create custome picklist field for current and future phases
     *@Return : List of options
    *********************************************************************************/
    public List<SelectOption> getPhaselist()
    {
        List<SelectOption> options = new List<SelectOption>();
        Set<String> nextPhases = new Set<String>();
        
        try
        {
            // Get Phase and Gate Mapping for Original Project.
            IPM_Project_Metadata__mdt projectMetaData = IPM_Utils.retrieveProjectMetadata(projectObject);
            String[] applicablePhases = projectMetaData.IPM_ApplicablePhases__c.split(IPM_ConstantUtils.COMMA);
            String[] applicableGates = projectMetaData.IPM_ApplicableGates__c.split(IPM_ConstantUtils.COMMA);
            
            // Get curent Project Type information based on Project Phase. 
            IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(projectObject);
            
            list<IPM_Project_Type__c> nextPhasesList = IPM_Utils.getNextPhases(associatedProjectType,false);
            nextPhasesList.add(associatedProjectType);
            
            // Only Adhoc tasks have option of delegation across Levels.
            if(tasks.IPM_Type_of_Task__c == IPM_ConstantUtils.ADHOC || tasks.IPM_Type_of_Task__c == IPM_ConstantUtils.FUTURE_ADHOC_TASKS) 
            {
                // composite Mapping between Phase and Gate At Original/Operational Level.
                for(Integer index=0;index<applicablePhases.size();index++)
                {
                    phaseGateMapping.put(applicablePhases[index],applicableGates[index]);
                }
                
                // Prepare a Set of Next Phases for current Project.
                for(IPM_Project_Type__c projectType : nextPhasesList) 
                {   
                    nextPhases.add(projectType.IPM_Phase__c);
                }
                
                for(String phase :applicablePhases)
                {   
                    if(nextPhases.contains(phase))
                    {
                        options.add(new SelectOption(phase,phase));
                    } 
                }
            }
            else
            {
                for(IPM_Project_Type__c projectType :nextPhasesList)
                {   
                    if(String.isBlank(projectType.IPM_Gate_Document__c))
                    {
                        projectType.IPM_Gate_Document__c = 'N/A';
                    }
                    phaseGateMapping.put(projectType.IPM_Phase__c,projectType.IPM_Gate_Document__c);
                    nextPhases.add(projectType.IPM_Phase__c);
                }
                for(String phase :applicablePhases)
                {   
                    if(nextPhases.contains(phase))
                    {
                        options.add(new SelectOption(phase,phase));
                    } 
                }
            }
            
            if(tasks.IPM_Type_of_Gate__c == null)
            {
                tasks.IPM_Type_of_Gate__c = associatedProjectType.IPM_Gate_Document__c;
            }
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new  ApexPages.Message(ApexPages.Severity.ERROR,Label.IPM_Generic_ErrorMessage)); 
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_NEWTASK_STR,'getPhaselist',ex.getMessage(),ex, ERROR, null, null, null,null);
            return null;
        }
        return options;
    }
    
     /********************************************************************************
     *@Description : This is to display sections based on Gate document
    *********************************************************************************/
    
    public void getGateSections()
    {
        tasks.IPM_Type_of_Gate__c = phaseGateMapping.get(tasks.IPM_Phase__c);
        
        // If Task Type is Adhoc or Future adhoc, Validate if phase has changed.
        if(tasks.IPM_Type_of_Task__c == IPM_ConstantUtils.ADHOC || tasks.IPM_Type_of_Task__c == IPM_ConstantUtils.FUTURE_ADHOC_TASKS)
        {
            if( projectObject.IPM_Phase__c != tasks.IPM_Phase__c )
            {
                tasks.IPM_Type_of_Task__c = IPM_ConstantUtils.FUTURE_ADHOC_TASKS;
            }
            else
            {
                tasks.IPM_Type_of_Task__c = IPM_ConstantUtils.ADHOC;
            }
        }
        else
        {
            if( projectObject.IPM_Phase__c != tasks.IPM_Phase__c )
            {
                tasks.IPM_Type_of_Task__c = IPM_ConstantUtils.FUTURE_STANDARD_TASKS;
            }
            else
            {
                tasks.IPM_Type_of_Task__c = IPM_ConstantUtils.STANDARD_TASKS;
            }
        }
        
        //tasks.IPM_Function__c = '';
        
   }
   
   public List<SelectOption> getGateSpecificSpan()
   {
        List<SelectOption> projectSpanOptionList = new List<SelectOption>();
            
        List<IPM_Project_Type__c> associatedProjectTypeList = new List<IPM_Project_Type__c>();
        if(String.isNotBlank(tasks.IPM_Type_of_Gate__c))
        {
            IPM_Project__c expectedProject = new IPM_Project__c();
            expectedProject.IPM_CompanyCardText__c = projectObject.IPM_CompanyCardText__c;
            expectedProject.IPM_GateKeeping_Model__c = projectObject.IPM_GateKeeping_Model__c;
            expectedProject.IPM_SourceProjectType__c = projectObject.IPM_SourceProjectType__c;
            expectedProject.IPM_Phase__c = tasks.IPM_Phase__c;
            
            // If type of Task is adhoc or future adhoc get the project span
            if(tasks.IPM_Type_of_Task__c == IPM_ConstantUtils.ADHOC || tasks.IPM_Type_of_Task__c == IPM_ConstantUtils.FUTURE_ADHOC_TASKS)
            {
                associatedProjectTypeList = IPM_Utils.getProjectSpanBasedOnGate(expectedProject,tasks.IPM_Type_of_Gate__c);
            }
            else
            {
                expectedProject.IPM_Project_Type__c = projectObject.IPM_Project_Type__c;
                expectedProject.IPMProject_Span__c = projectObject.IPMProject_Span__c;
                associatedProjectTypeList.add(IPM_Utils.retrieveProjectType(expectedProject));  
            }
  
            for(IPM_Project_Type__c projectType : associatedProjectTypeList)
            {
                projectSpanOptionList.add(new SelectOption(projectType.IPM_Project_Span__c,projectType.IPM_Project_Span__c));
            }
            if(projectObject.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)
            {
            	projectSpanOptionList.add(new SelectOption(projectObject.IPMProject_Span__c,projectObject.IPMProject_Span__c));
            }
        }
        
        return projectSpanOptionList;
   }
   
    
    /********************************************************************************
     *@Description : This is to display sections based on User Role 
     *@Param: Present projectid
     *@Return : List of options
    *********************************************************************************/
    
    public void getSections(){
        getSectionlist();
    }
    
    /********************************************************************************
     *@Description : create dependent picklist of section sequence and section name, which is depenedent on functional role value selection
     *@Param: Present projectid
     *@Return : List of options
    *********************************************************************************/
    public List<SelectOption> getSectionlist()
    {
     try
        {
        	List<SelectOption> options = new List<SelectOption>();
            if(tasks.IPM_Project_Document_Section__c == null)
            {
            	options.add(new SelectOption(IPM_ConstantUtils.BLANK,IPM_ConstantUtils.BLANK));
            }
             
            if(string.isNotBlank(tasks.IPM_Function__c)  && string.isNotBlank(tasks.IPM_Type_of_Gate__c) )
            {        
                String functionalRole = IPM_ConstantUtils.BLANK;
                String projectType = IPM_ConstantUtils.BLANK;
                
                functionalRole = assignFunctionRole(tasks.IPM_Function__c);    
                
                String sSectionSequence = IPM_Utils.eightvalue + PERCENT_SIGN;
                
                projectType = projectObject.IPM_SourceProjectType__c;
                
                if(tasks.IPM_Type_of_Task__c == IPM_ConstantUtils.FUTURE_ADHOC_TASKS  || tasks.IPM_Type_of_Task__c == IPM_ConstantUtils.FUTURE_STANDARD_TASKS) 
                {
                    for(IPM_Section__c docsections :[SELECT IPM_Document_Template__r.IPM_Document_Type__c,External_ID__c,Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_IS_Default_Section__c 
                                                    FROM IPM_Section__c 
                                                    WHERE  
                                                    IPM_FunctionalRole__c =: functionalRole  
                                                    AND IPM_IS_Default_Section__c = true 
                                                    AND IPM_Document_Template__r.IPM_Document_Type__c =: tasks.IPM_Type_of_Gate__c
                                                    AND IPM_Document_Template__r.IPM_Project_Template__r.IPM_Template_Complexity__c =: projectObject.IPM_Complexity__c
                                                    AND IPM_Section_Type__c NOT IN (:IPM_ConstantUtils.SECTION_TYPE_HEADER,:IPM_ConstantUtils.SECTION_TYPE_SUBHEADER)
                                                    AND ( NOT IPM_Section_Sequence__c like :sSectionSequence)
                                                    AND IPM_Document_Template__r.IPM_Project_Template__r.IPM_Project_Type__c =: projectType
                                                    AND ProjectSpan__c includes (:tasks.IPM_TaskSpan__c) 
                                                    ] ) 
                                {
                                    if(string.isNotBlank(docsections.IPM_Section_Sequence__c) && string.isNotBlank(docsections.IPM_Section_Name__c))
                                    {
                                        options.add(new SelectOption(docsections.Id,docsections.IPM_Section_Sequence__c+ SPACE +docsections.IPM_Section_Name__c));
                                        SectionToExtenalIdSectionMap.put(docsections.Id,docsections.External_ID__c);
                                    }   
                               } 
                 }        
                 else
                 {
                    for(IPM_Project_Document_Section__c docsections : [SELECT Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Section__c,IPM_Section__r.External_ID__c,IPM_Default_Section__c 
                                                                            FROM IPM_Project_Document_Section__c 
                                                                            WHERE IPM_Gate_Document__c=:tasks.IPM_Type_of_Gate__c 
                                                                            AND IPM_FunctionalRole__c =: FunctionalRole  
                                                                            AND IPM_Default_Section__c = true
                                                                            AND IPM_Project_Document__r.IPM_Project_Complexity__c =: projectObject.IPM_Complexity__c 
                                                                            AND IPM_Section__r.IPM_Section_Type__c NOT IN (:IPM_ConstantUtils.SECTION_TYPE_HEADER,:IPM_ConstantUtils.SECTION_TYPE_SUBHEADER)
                                                                            AND ( NOT IPM_Section_Sequence__c like :sSectionSequence)
                                                                            AND IPM_Project_Document__r.IPM_Project__c =:projectObject.id ] ) 
                          {
                                if(string.isNotBlank(docsections.IPM_Section_Sequence__c) && string.isNotBlank(docsections.IPM_Section_Name__c))
                                {
                                    options.add(new SelectOption(docsections.Id,docsections.IPM_Section_Sequence__c+ SPACE +docsections.IPM_Section_Name__c));
                                    projectDocSectionToSectionMap.put(docsections.Id,docsections.IPM_Section__c);
                                    SectionToExtenalIdSectionMap.put(docsections.Id,docsections.IPM_Section__r.External_ID__c); 
                                }  
                          }
                 }
                        
                if(assigneeIdName != null && assigneeIdName.containsKey(tasks.IPM_Function__c))
                {
                    tasks.IPM_Assignee__c = assigneeIdName.get(tasks.IPM_Function__c);
                }
            }
            if(tasks.IPM_Project_Document_Section__c != null)
            {
            	options.add(new SelectOption(IPM_ConstantUtils.BLANK,IPM_ConstantUtils.BLANK));
            }	
            return options;
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new  ApexPages.Message(ApexPages.Severity.ERROR,Label.IPM_Generic_ErrorMessage)); 
            
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_NEWTASK_STR,'getSectionlist',ex.getMessage(),ex, ERROR, null, null, null,null);
            return null;
        }
    }
    
     /********************************************************************************
     *@Description : Assigns function role
     *@Return : String
    *********************************************************************************/
    private static String assignFunctionRole(String taskFunctionRole)
    {
    	String functionalRole = IPM_ConstantUtils.BLANK;
    	if(taskFunctionRole == IPM_Utils.SupplyChain)
        {
            functionalRole = IPM_Utils.IPM_NewTaskIPM_FunctionalRole;
        }
        else
        {
            functionalRole = taskFunctionRole ;
        }
        return functionalRole;
    }
    /********************************************************************************
     *@Description : create custome picklist field for functional role.'BB' role will only be shown for local projects.
     *@Return : List of options
    *********************************************************************************/
    public List<SelectOption> getFuntionalRolelist()
    {
        try
        {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption(IPM_ConstantUtils.BLANK,IPM_ConstantUtils.BLANK));
            //get all the picklist values for task functional role
            Schema.DescribeFieldResult fieldResult = IPM_Task__c.IPM_Function__c.getDescribe();
            List<Schema.PicklistEntry> functionalRole = fieldResult.getPickListValues();
            
            for(Schema.PicklistEntry role :functionalRole)
            {   
                string roleValue = role.getValue();
                //if project span is local then only add role as 'BB'
                 
                if(roleValue != IPM_ConstantUtils.FUNCTIONAL_ROLE_BB)
                {
                    options.add(new SelectOption(roleValue,roleValue));
                }
                else if(projectObject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
                {
                    options.add(new SelectOption(roleValue,roleValue));
                }
            }
            return options;
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new  ApexPages.Message(ApexPages.Severity.ERROR,Label.IPM_Generic_ErrorMessage)); 
            
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_NEWTASK_STR, 'getFuntionalRolelist',ex.getMessage(),ex, ERROR, null, null, null,null);
            return null;
        }
    }
    /********************************************************************************
     *@Description : create dependent picklist of section sequence and section name, which is depenedent on functional role value selection
     *@Param: project record
     *@Return :  map of role as key and its functional owner as value,default functional owner is PL
    *********************************************************************************/
    public map<string,Id> getAssignee(IPM_Project__c projectObj){
        
        map<String,Id> funcAssigneeId = new map<String,Id> ();
        
        
        Schema.DescribeFieldResult fieldResult = IPM_Task__c.IPM_Function__c.getDescribe();
        List<Schema.PicklistEntry> functionalRole = fieldResult.getPickListValues();
        
        for(Schema.PicklistEntry role :functionalRole)
        {
            funcAssigneeId.put(role.getValue(),projectObj.IPM_Project_Leader__c);
        }
        if(projectObj.IPM_Project_Resources__r != null)
        {
            for(IPM_Project_Resource__c projRes :projectObj.IPM_Project_Resources__r)
            {
                if(funcAssigneeId.containsKey(projRes.IPM_Role_Type__c) && projRes.IPM_Project_Role_Owner__c)
                {
                    funcAssigneeId.put(projRes.IPM_Role_Type__c,projRes.IPM_User__c);
                }
            }
        }
        return funcAssigneeId;
    }
	/********************************************************************************
     *@Description : get all project document section/ section list used for edit task
     *@Param: none
     *@Return :  picklist values where each value is combination of section sequence and section name
    *********************************************************************************/
    public List<SelectOption> getListSections() {
		
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption(IPM_ConstantUtils.BLANK,IPM_ConstantUtils.BLANK));
		
    	String projectType = String.IsNotBlank(projectObject.IPM_SourceProjectType__c) ? projectObject.IPM_SourceProjectType__c : IPM_ConstantUtils.BLANK;
        String sSectionSequence = IPM_Utils.eightvalue + PERCENT_SIGN;
        
        //check if phase selected is future phase     
        if(tasks.IPM_Type_of_Task__c == IPM_ConstantUtils.FUTURE_ADHOC_TASKS  || tasks.IPM_Type_of_Task__c == IPM_ConstantUtils.FUTURE_STANDARD_TASKS) 
	    {
	    	//as phase is future phase project document section is not inserted, so add sections to option 
	        for(IPM_Section__c docsections :[SELECT IPM_Document_Template__r.IPM_Document_Type__c,External_ID__c,Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_IS_Default_Section__c 
	                                        FROM IPM_Section__c 
	                                        WHERE  
	                                        IPM_IS_Default_Section__c = true 
	                                        AND IPM_Document_Template__r.IPM_Document_Type__c =: tasks.IPM_Type_of_Gate__c
	                                        AND IPM_Document_Template__r.IPM_Project_Template__r.IPM_Template_Complexity__c =: projectObject.IPM_Complexity__c
	                                        AND IPM_Section_Type__c NOT IN (:IPM_ConstantUtils.SECTION_TYPE_HEADER,:IPM_ConstantUtils.SECTION_TYPE_SUBHEADER)
	                                        AND ( NOT IPM_Section_Sequence__c like :sSectionSequence)
	                                        AND IPM_Document_Template__r.IPM_Project_Template__r.IPM_Project_Type__c =: projectType
	                                        AND ProjectSpan__c includes (:tasks.IPM_TaskSpan__c) 
	                                        ] ) 
	            {
	                if(string.isNotBlank(docsections.IPM_Section_Sequence__c) && string.isNotBlank(docsections.IPM_Section_Name__c))
	                {
	                    options.add(new SelectOption(docsections.Id,docsections.IPM_Section_Sequence__c+ SPACE +docsections.IPM_Section_Name__c));
	                    SectionToExtenalIdSectionMap.put(docsections.Id,docsections.External_ID__c);
	                }   
	           } 
	     } //check if phase selected is current phase       
	     else{
	     	//as project documnet section is present for current phase add it to option
	        for(IPM_Project_Document_Section__c docsections : [SELECT Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Section__c,IPM_Section__r.External_ID__c,IPM_Default_Section__c 
	                                                                FROM IPM_Project_Document_Section__c 
	                                                                WHERE IPM_Gate_Document__c=:tasks.IPM_Type_of_Gate__c 
	                                                                AND IPM_Default_Section__c = true
	                                                                AND IPM_Project_Document__r.IPM_Project_Complexity__c =: projectObject.IPM_Complexity__c 
	                                                                AND IPM_Section__r.IPM_Section_Type__c NOT IN (:IPM_ConstantUtils.SECTION_TYPE_HEADER,:IPM_ConstantUtils.SECTION_TYPE_SUBHEADER)
	                                                                AND ( NOT IPM_Section_Sequence__c like :sSectionSequence)
	                                                                AND IPM_Project_Document__r.IPM_Project__c =:projectObject.id ] ) 
	              {
	                    if(string.isNotBlank(docsections.IPM_Section_Sequence__c) && string.isNotBlank(docsections.IPM_Section_Name__c))
	                    {
	                        options.add(new SelectOption(docsections.Id,docsections.IPM_Section_Sequence__c+ SPACE +docsections.IPM_Section_Name__c));
	                        projectDocSectionToSectionMap.put(docsections.Id,docsections.IPM_Section__c);
	                        SectionToExtenalIdSectionMap.put(docsections.Id,docsections.IPM_Section__r.External_ID__c); 
	                    }  
	              }
	     }

    	return options;
    }
    /********************************************************************************
     *@Description : creates mapping of functional role to list of section external id list
     *@Param: none
     *@Return :  none
    *********************************************************************************/
    
	public void sectionWiseFunctionalRoleList()
    {
    	sectionToFunctionalRoleMap = new Map<string,set<string>>();
    	
    	//get all records of custome setting
        List<IPM_Gate_Document_Section_Access__c> docAccessList = IPM_Gate_Document_Section_Access__c.getall().values();
		
		//iterate over rcutome setting records
		for(IPM_Gate_Document_Section_Access__c docAccessRec : docAccessList){
			
			//get all section external ids in list from both access fields
			list<string> secExternalIdList = docAccessRec.IPM_Gate_Document_Section_Access_1__c.split(',');
			
			if(docAccessRec.IPM_Gate_Document_Section_Access_2__c != null){
				secExternalIdList.addAll(docAccessRec.IPM_Gate_Document_Section_Access_2__c.split(','));
			}
			//iterate over section external id list
			for(string secExtId : secExternalIdList)
			{
					string secExtIdUpperCase = secExtId.toUpperCase();
					set<string> functionalRoleSet = new  set<string>();
					
					//if functional role to section external id map is null or not contains the current section external id then add this to map
					if(sectionToFunctionalRoleMap.isEmpty() || (!sectionToFunctionalRoleMap.isEmpty() && !sectionToFunctionalRoleMap.containsKey(secExtIdUpperCase)))
					{
						functionalRoleSet.add(docAccessRec.Name);
					}
					//if map contains section external id then add new functional role to existing functional role list
					else if(!sectionToFunctionalRoleMap.isEmpty() && sectionToFunctionalRoleMap.containsKey(secExtIdUpperCase))
					{
						functionalRoleSet = sectionToFunctionalRoleMap.get(secExtIdUpperCase);
						functionalRoleSet.add(docAccessRec.Name);
					}
					sectionToFunctionalRoleMap.put(secExtIdUpperCase,functionalRoleSet);
			}
		}
		
    }
    /********************************************************************************
     *@Description : creates functional role list having an access to selected section
     *@Param: none
     *@Return :  picklist
    *********************************************************************************/
     
	public List<SelectOption> getListFunctionalRole() {
		
		List<SelectOption> options = new List<SelectOption>();
		
		//check if section is selected
		if((selectedSectionId == null || string.isBlank(selectedSectionId)) ){
			return options;
		}
			
			
		options.add(new SelectOption(IPM_ConstantUtils.BLANK,IPM_ConstantUtils.BLANK));
		
		//check if section is selected and get functional role list from the section to functional role list map
		if(string.isNotBlank(selectedSectionId) && SectionToExtenalIdSectionMap.containsKey(selectedSectionId))
    	{
    		string sectionExternalId = SectionToExtenalIdSectionMap.get(selectedSectionId).toUpperCase();
    		set<string> roleSet = sectionToFunctionalRoleMap.get(sectionExternalId);
			list<string> roleList =  new list<string>();
    		
    		for(string role : roleSet)
    		{
    			string roleValue = role;
    			if(role.equalsIgnoreCase(IPM_ConstantUtils.IPM_ROLE_BD_MARKETING ))
				{ 
					roleValue = IPM_ConstantUtils.FUNCTIONAL_ROLE_BD;
				}
				if(role.equalsIgnoreCase(IPM_ConstantUtils.TEAM_TECHNICAL_PROJECT_LEADER ))
				{ 
					roleValue = IPM_ConstantUtils.TEAM_CORETPL;
				}
				if(role.equalsIgnoreCase(IPM_ConstantUtils.PROJECT_LEADER ))
				{ 
					roleValue = IPM_ConstantUtils.FUNCTIONAL_ROLE_PL;
				}
				roleList.add(roleValue);
    			options.add(new SelectOption(roleValue,roleValue));
    		}
    		if(!roleList.isEmpty() && !roleSet.contains(tasks.IPM_Function__c) && tasks.IPM_SectionExternalIDFormula__c.equalsIgnoreCase(sectionExternalId) )
    		{
    			options.add(new SelectOption(tasks.IPM_Function__c,tasks.IPM_Function__c));
    		}
    	}
		return options;
	}
	/********************************************************************************
     *@Description : get user name as per functional role selected
     *@Param: none
     *@Return :  string
    *********************************************************************************/
    
	public string getFunctionalRoleOwner() {
		
		string taskIOwner = '';
		
		if(tasks.IPM_Function__c == null || string.isBlank(tasks.IPM_Function__c))
			return taskIOwner;
		
		//get user name
		if(assigneeIdName != null && !assigneeIdName.isEmpty()){
			string taskIOwnerId = assigneeIdName.get(tasks.IPM_Function__c);
			
			if(userIdName != null && !userIdName.isEmpty())
			{
				taskIOwner = userIdName.get(taskIOwnerId);
			}
		}
		return 	taskIOwner;
	}
}