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
    public String docSecList {get;set;} // To check the values in the Documnet section values in the picklist
    public String roleValue {get;set;} // To filter the sections based on role
    public string ProjectWizard{get;set;} // Checking for projects related to tasks
    public boolean displayPopup {get; set;} // To display pop up message
    public transient String sectionValue {get;set;}
    public map<Id,String> userIdName{get;set;}
    public String roleList {get;set;}
    public list<SelectOption> FuntionalRolelist;
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
                        sectionValue = string.valueOf(proDocSecList[0].IPM_Section_Sequence__c+' '+proDocSecList[0].IPM_Section_Name__c);
                        docSecList  = proDocSecList[0].id;
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
                  }
                    
                } 
                catch(Exception ex)
                {
                    ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,IPM_Utils.Invalidproject);
                    ApexPages.addMessage(myMsg); 
                }
            }
            
            if(String.IsNotBlank(ApexPages.currentPage().getParameters().get(IPM_Utils.taskId)))
            {
                taskId = ApexPages.currentPage().getParameters().get(IPM_Utils.taskId);
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
                }
                catch(Exception ex)
                {
                    ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,IPM_Utils.Invalidproject);
                    ApexPages.addMessage(myMsg); 
                }
            }
            // Displaying due dates based on Approach
            displayDueDate=true;
            if(projectObject.IPM_PM_Approach__c == IPM_Utils.External){
                displayDueDate = false;
            }
                        
        }catch(Exception ex){
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,IPM_Utils.Invalidproject);
            ApexPages.addMessage(myMsg); 
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
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,IPM_Utils.Invalidproject);
            ApexPages.addMessage(myMsg); 
            
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_NEWTASK_STR,
                'upsertTask',sErrorMessage,null, ERROR, null, null, null,null);
        }
    }
        
    /***************************************************************
    *@Description :Redirecting to Gate doc on click of Task Name
    *@Param: Present Taskid
    ****************************************************************/
    
    public pageReference doSaveTasks(){
        try{
            validate = true;
           
            if(tasks.IPM_Project__c == null)
            {
                tasks.IPM_Project__c=apexpages.currentpage().getparameters().get(IPM_Utils.IPM_NewTaskprojectId);
            }
            
            Id recordTypeIdValue = Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectTasks).getRecordTypeId();
            if(recordTypeIdValue != null)
            {
                tasks.RecordTypeId = recordTypeIdValue;
            }
            
            // Checking the Sections of gatedocument. 
            if(docSecList != null){
                tasks.IPM_Project_Document_Section__c=docSecList;
            }
            //assign task assign from map created in constructor
            if(tasks.IPM_Function__c != null && assigneeIdName != null && assigneeIdName.containsKey(tasks.IPM_Function__c)){
                tasks.IPM_Assignee__c = assigneeIdName.get(tasks.IPM_Function__c);
            }
            
                tasks.IPM_Active__c = TRUE;
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
                // check for task due date, which should not be greater than milestone due date
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
                if(tasks.IPM_Due_Date1__c < System.Today())
                {
             	validate = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.IPM_TaskDueDateErrorMsg));
                }
             
             if(String.isNotBlank(tasks.IPM_Type_of_Gate__c) && tasks.IPM_Type_of_Gate__c == IPM_Utils.notapplicable)
                {
             	tasks.IPM_Type_of_Gate__c = IPM_ConstantUtils.BLANK;
                }
	    	
             try{
				if(String.isNotBlank(tasks.IPM_Task_Name__c) && validate)
                {
                    upsertTask(new List<IPM_Task__c>{tasks});
                }
             }catch(Exception ex)
             {
                ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,IPM_Utils.Invalidproject);
                ApexPages.addMessage(myMsg); 
                validate =false;
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_NEWTASK_STR,
                    DO_SAVE_TASKS,ex.getMessage(),ex, ERROR, null, null, null,null);
            }
            closePopup();
        }catch(Exception ex)
        {
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,IPM_Utils.Invalidproject);
            ApexPages.addMessage(myMsg); 
            
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_NEWTASK_STR,
                    DO_SAVE_TASKS,ex.getMessage(),ex, ERROR, null, null, null,null);
        }
        return null;            
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
    try{
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(IPM_ConstantUtils.BLANK,IPM_ConstantUtils.BLANK));
        if(string.isNotBlank(tasks.IPM_Function__c)  && string.isNotBlank(tasks.IPM_Type_of_Gate__c) ){
                
             List<IPM_Project_Document__c> pdocument=[SELECT Id,IPM_Project__c 
                                                      FROM IPM_Project_Document__c 
                                                      WHERE IPM_Project__c =: projectId
                                                      AND IPM_GateDocuments__c =: tasks.IPM_Type_of_Gate__c 
                                                      AND IPM_Project_Complexity__c=: projectObject.IPM_Complexity__c];
                
            if(pdocument != null && !pdocument.isEmpty()){
                    
                String FunctionalRole = IPM_ConstantUtils.BLANK;
                if(tasks.IPM_Function__c == IPM_Utils.SupplyChain)
                {
                    FunctionalRole = IPM_Utils.IPM_NewTaskIPM_FunctionalRole;
                }else
                {
                    FunctionalRole = tasks.IPM_Function__c ;
                }
                String sSectionSequence = IPM_Utils.eightvalue + PERCENT_SIGN;
                
                    for(IPM_Project_Document_Section__c docsections : [SELECT Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Section__c,IPM_Default_Section__c 
                                                                        FROM IPM_Project_Document_Section__c 
                                                                        WHERE IPM_Project_Document__c=:pdocument[0].Id 
                                                                        AND IPM_FunctionalRole__c =: FunctionalRole  
                                                                        AND IPM_Default_Section__c = true 
                                                                        AND IPM_Section__r.IPM_Section_Type__c NOT IN (:IPM_ConstantUtils.SECTION_TYPE_HEADER,:IPM_ConstantUtils.SECTION_TYPE_SUBHEADER)
                                                                        AND ( NOT IPM_Section_Sequence__c like :sSectionSequence)] ) {
                             if(string.isNotBlank(docsections.IPM_Section_Sequence__c) && string.isNotBlank(docsections.IPM_Section_Name__c))
                            {
                                options.add(new SelectOption(docsections.Id,docsections.IPM_Section_Sequence__c+' '+docsections.IPM_Section_Name__c));
                            }   
                    }
            }
            if(assigneeIdName != null && assigneeIdName.containsKey(tasks.IPM_Function__c))
            {
                tasks.IPM_Assignee__c = assigneeIdName.get(tasks.IPM_Function__c);
            }
            }return options;
        }
        catch(Exception ex)
        {
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,IPM_Utils.Invalidproject);
            ApexPages.addMessage(myMsg); 
            
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_NEWTASK_STR,
                    'getSectionlist',ex.getMessage(),ex, ERROR, null, null, null,null);
            return null;
        }
    }
    
    /********************************************************************************
     *@Description : create custome picklist field for functional role.'BB' role will only be shown for local projects.
     *@Return : List of options
    *********************************************************************************/
    public List<SelectOption> getFuntionalRolelist()
    {
        
    try{
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(IPM_ConstantUtils.BLANK,IPM_ConstantUtils.BLANK));
        //get all the picklist values for task functional role
        Schema.DescribeFieldResult fieldResult = IPM_Task__c.IPM_Function__c.getDescribe();
        List<Schema.PicklistEntry> functionalRole = fieldResult.getPickListValues();
        
        for(Schema.PicklistEntry role :functionalRole)
        {   
            string roleValue = role.getValue();
            //if project span is local then only add role as 'BB'
            if(roleValue == IPM_ConstantUtils.FUNCTIONAL_ROLE_BB && projectObject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
            {
                options.add(new SelectOption(roleValue,roleValue));
            }
            else if(roleValue != IPM_ConstantUtils.FUNCTIONAL_ROLE_BB){
                options.add(new SelectOption(roleValue,roleValue));
            }
            
        }
        return options;
     }
        catch(Exception ex)
        {
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,IPM_Utils.Invalidproject);
            ApexPages.addMessage(myMsg); 
            
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_NEWTASK_STR,
                    'getFuntionalRolelist',ex.getMessage(),ex, ERROR, null, null, null,null);
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
}