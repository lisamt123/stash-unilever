/**
   @Author : Cognizant
   @name IPM_TaskCompCtrl
   @CreateDate 
   @Description :Controller class for TODO component to display ToDos
   @Version <1.0>
   @reference 
  */   
public with sharing class IPM_TaskCompCtrl extends AbstractStandardSetExtension{
    
    private transient static final String CLASS_NAME = IPM_TaskCompCtrl.class.getName();
    private transient String taskId = IPM_ConstantUtils.BLANK;
    private String phase = IPM_ConstantUtils.BLANK;
    private String user = IPM_ConstantUtils.BLANK;
    private static final String ERROR_STR = 'Error';
    public String projectId{get;set;} //project id
    public Integer openTasks{get;set;} //number of open tasks being shown to the user
    public Integer closedTasks {get; set;}//number of open tasks being shown to the user
    public Boolean isAsc{get;set;}//toggling variable to sort tasks
    public Boolean isExternalApproach{get;set;}//external approach to the project checker
    public Map<String, String> currentSort{get;set;} //sorting variable where the current sort fits in
    public Boolean IsTaskEditable{get;set;}//used by security
    public Boolean IsAllEditable{get;set;}//used by security
    public String UFunctionRole{get;set;}//this property needs to be removed.
    public Boolean pmApproachMessage{get;set;}// task would be managed externally or internally
    public IPM_Project__c projectObj {get;set;}//project object
    public Integer totalTask{get;set;}//total no of task
    public String pagintnDisp {get;set;}//pagination
    public boolean isCreateTask{get;set;}
    public boolean isApproachEdit{get;set;}//Update approach
    public boolean isTaskReadOnly{get;set;}//Update approach
    public Boolean reactivateProjectFlag{get;set;} // used by security to give edit access on Wizard for IPM Busines Partner user
    //gettter & setter for taskId
    
      
    public void setTaskId(String tskId) {
        taskId = tskId;
    }
    public String getTaskId() { //getter for the task id
        return taskId;
    }
    //gettter & setter for phase
    
    public void setPhase(String projPhase) {
        phase = projPhase;
    }
    public String getPhase() {
        return phase;
    }
    
    //gettter & setter for user property
    
    public void setUser(String projUser) {
        user = projUser;
    }
    public String getUser() {
        return user;
    }
    
    public String isChecked{get;set;}//Page property which sends back marked milestones for completion
    public Boolean toggleTask{get;set;}//Toggling variable per tasks assigned per current persona
    public String toggleRole{get;set;}//Toggling variable for My functional Role
    public String[] phasesList{get;set;}//includes all the available phases per project
    public String[] usersList{get;set;}//stores all the users in a list
    public String isCompleteTasks{get;set;}//Is this task complete?
    public Map<Id, String> userMap{get;set;}//user map which stored the fotos of the users
    public Map<String,Boolean> phaseTaskComp{get;set;}
    public Set<String> previousPhases;
    
    
    /**
    *  Description : constructor
    *  @name : IPM_TaskCompCtrl
    */
    public IPM_TaskCompCtrl() {
        IPM_IECompatible.ieFix();
        reactivateProjectFlag = false;
        //initialising variables
        openTasks = 0; 
        closedTasks = 0;
        isAsc = false;
        toggleTask = false;
        isTaskReadOnly = false;
        //current sorting column applies to IPM_Completed__c field, 
        currentSort = new Map<String, String>{IPM_ConstantUtils.THIS_FIELD => 'IPM_Completed__c'};
        phaseTaskComp = new  Map<String,Boolean>();
        
        projectId = ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.TEAM_PROJECTID);
        if(String.isBlank(projectId))
        {
            projectId = ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.IPM_Project_PID);
        }
        projectObj = new IPM_Project__c();
        
        if(String.isNotBlank(projectId))
        {
            string query = IPM_Utils.prepareSOQLQuery('IPM_Project__c' ,false,null,true)+' where id =:projectId ';
            list<IPM_Project__c> projList = Database.query(query);
            projectObj  = projList[0];
            if(projectObj.Is_Archieved__c || projectObj.IPM_PrepareForArchival__c){
            	isTaskReadOnly = true;
            }
             /*** Logic to Display the give edit access for IPM Business Partner on Wizard   
	   			For Stopped project in Ideas phase for 38 months,
	        ***/
	        Integer noOfMonths = Integer.valueOf(Label.IPM_NoOfMonths_ForReactivation);
	        Date dateToCompare = System.today().addMonths(-noOfMonths); 
	        if(projectObj.IPM_EligibleForReactivation__c && projectObj.IPM_Stopped_Date_Time__c > dateToCompare)
	        {
	   	       //security for central team and BP users
	           IPM_CustomPermission custPermission = new IPM_CustomPermission();
	           reactivateProjectFlag = custPermission.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
	           isTaskReadOnly = !reactivateProjectFlag;
	        }
        }
        
        if(projectObj == NULL)
        {
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,IPM_Utils.Invalidproject);
            ApexPages.addMessage(myMsg); 
            
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                'taskCompController',ERROR_STR,null, ERROR_STR, null, null, null,null);
        }
        
        IPM_Project_Type__c associatedProjectType = IPM_Utils.retrieveProjectType(projectObj);
        list<IPM_Project_Type__c> previousPhasesList = IPM_Utils.getPreviousPhases(associatedProjectType,false);
        previousPhases = new Set<String>();
        for(IPM_Project_Type__c projectType : previousPhasesList)
        {
            previousPhases.add(projectType.IPM_Phase__c);
        }
        isExternalApproach = projectObj != null && projectObj.ipm_PM_Approach__c == IPM_ConstantUtils.IPM_APPROACH_EXTERNAL ? true : false;
        initializTask();
        phasesList.sort();
        usersList.sort();
    }
    
    /**
    *  Description : loads the task
    *  @name : initializTask
    */
    public void initializTask(){
        loadTasks();
    }
    
    /**
    *  Description: query all the task, get assignees their profile photos and phases
    *  @name : loadTasks
    *  @return List<sObject> - task record list
    */
    private List<sObject> loadTasks(){
        //initialising variables
        totalTask = 0;
        openTasks = 0; 
        closedTasks = 0;
        Set<String> phasesSet = new Set<String>();//get phases list 
        Set<String> usersSet = new Set<String>();// get assignees list
        Set<Id> userSet = new Set<Id>();// get assignees list
        
        phasesList = new List<String>();
        usersList = new List<String>();
        
        String strQuery = getQuery();
        sourcesObjectList = database.query(strQuery);
        
        if(sourcesObjectList != null && !sourcesObjectList.isEmpty())
        {
            
            totalTask = sourcesObjectList.size();
            //process from all the tasks & process them and add the users associated with it
            for(IPM_Task__c eachTask : (List<IPM_Task__c>)sourcesObjectList) 
            {
                if(eachTask.IPM_Assignee__c != null)
                {
                    userSet.add(eachTask.IPM_Assignee__c);
                    usersSet.add(eachTask.IPM_Assignee__r.Name);
                }
                phasesSet.add(eachTask.IPM_Phase__c);
                //prevoius phase map
                if(!previousPhases.isEmpty() && previousPhases.contains(eachTask.IPM_Phase__c)){
                    phaseTaskComp.put(eachTask.IPM_Phase__c,false);
                }
                else
                {
                    phaseTaskComp.put(eachTask.IPM_Phase__c,true);
                }
                if(eachTask.IPM_Completed__c) 
                {
                   closedTasks++;
                }
                else
                {
                    openTasks++;
                }
            }
            if(!userSet.isEmpty()){
                userMap = IPM_Utils.getUserProfilePhoto(userSet);
                usersList.addAll(usersSet);
            }
            phasesList.addAll(phasesSet);
        }

        return sourcesObjectList;             
    }
    
    /**
    *  Description : query all the task
    *  @name : getQuery
    */
    public override String getQuery(){
        
        String usrRole = IPM_Utils.userRole();
        String soqlWHERE = '' ;
        if(String.isNotBlank(usrRole))
        {
            soqlWHERE = usrRole == IPM_ConstantUtils.PROJECT_LEADER ? ' AND IPM_Function__c IN (\''+ usrRole +'\' , \'BD\')' : 
                                                                             ' AND IPM_Function__c = \'' + usrRole + '\'';
        }
        Boolean showActiveTask = true; // This boolean will be used to show active task 
        Boolean showArchievedProjectTask = false; // This boolean will be used to show archieved project task
        if(reactivateProjectFlag && projectObj.Is_Archieved__c){
        	showActiveTask = false;
        	showArchievedProjectTask = true;
        }
        String soql  =  'SELECT IPM_Task_Name__c, IPM_Phase__c,IPM_Master_Section_Name__c,IPM_Master_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Section_Name__c,IPM_Assignee__c,';
               soql += 'IPM_Project_Document_Section__c,IPM_Project_Document_Section__r.IPM_Project_Document__c,';
               soql += 'IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Document_Status__c,';
               soql += 'IPM_Project_Document_Section__r.IPM_Section_Sequence__c, IPM_Assignee__r.Name, IPM_Project__c,IPM_Project__r.IPM_Current_Document_Status__c,';
               soql += 'IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_GateDocuments__c,IPM_Project__r.IPM_Phase__c,IPM_Project__r.Is_Archieved__c,';
               soql += 'IPM_Section__c,IPM_Section__r.IPM_Section_Sequence__c, IPM_Section__r.IPM_Section_Name__c, ';
               soql += 'IPM_Due_Date1__c, IPM_Completed__c, IPM_Function__c, IPM_Task_Type__c FROM IPM_Task__c ';
               soql += 'WHERE IPM_Active__c = true  AND IPM_Project__r.Is_Archieved__c = false AND IPM_Project__c = \'' + String.escapeSingleQuotes(projectId) + '\'';
               
        if(String.isNotBlank(phase) ) 
        {
            soql += ' AND (IPM_Phase__c IN ' + IPM_Utils.convertStrToSoqlList(String.escapeSingleQuotes(phase))+')';
        }
        if(toggleTask) 
        {
            soql += ' AND IPM_Assignee__c = \'' + UserInfo.getUserId() + '\'';
        }
        if(toggleRole == IPM_ConstantUtils.TEAM_TRUE && String.isNotBlank(soqlWHERE))
        {
            soql += soqlWHERE;
        }
        if(isCompleteTasks == 't') 
        {
            soql += ' AND IPM_Completed__c = true';
        }
        if(isCompleteTasks == 'f') 
        {
            soql += ' AND IPM_Completed__c = false';
        }
        if(String.isNotBlank(user)) 
        {
            soql += ' AND IPM_Assignee__r.Name IN ' + IPM_Utils.convertStrToSoqlList(String.escapeSingleQuotes(user));
        }
        if(isAsc) 
        {
            soql += ' ORDER BY ' + currentSort.get(IPM_ConstantUtils.THIS_FIELD) + ' DESC NULLS LAST';
        } 
        else 
        {
            soql += ' ORDER BY IPM_Completed__c,IPM_Phase__c,IPM_Due_Date1__c,IPM_Project_Document_Section__r.IPM_Section_Sequence__c,IPM_Task_Name__c ASC NULLS LAST';
        }
        soql += ' limit 1000'; 
        return soql;  
        
    }
    
    /**
    *  Description : get task wrapper list
    *  @name : getProjectTasks
    *  @return <sObjectPaginationWrapper> - <task Record  list >
    */
    public List<sObjectPaginationWrapper> getProjectTasks() {
        pageSize = IPM_ConstantUtils.NO_OF_RECORDS;
        totalTask = 0;
        loadTasks();
        getWrapperRecords();
        if(getEndIndexNumber() == 0)
        {
            pagintnDisp = string.format(System.Label.IPM_PaginationUIDisplay, new string[] {string.valueof(getBeginIndexNumber()-1),String.valueof(getEndIndexNumber()),String.valueof(totalTask)});
        }
        else
        {
            pagintnDisp = string.format(System.Label.IPM_PaginationUIDisplay, new string[] {string.valueof(getBeginIndexNumber()),String.valueof(getEndIndexNumber()),String.valueof(totalTask)});
        }
        return  wrapperRecordList;
    }
    
    /**
    *  Description: post process the wrapper and get count for open and completed task
    *  @name : postProcessing
    *  @param : <recordList> <task record list>
    */
    public override void postProcessing(List<sObject> recordList){        
        
        for(IPM_Task__c eachTask : (List<IPM_Task__c>)recordList ) 
        {
            if(!phaseTaskComp.isEmpty())
            {
            	Boolean isEditable = false;
            	if(String.IsNotBlank(eachTask.IPM_Phase__c))
            	{
            		isEditable = phaseTaskComp.get(eachTask.IPM_Phase__c) ? true :false ;
            	}
            	else{
                	isEditable = true;
            	}
                if(eachTask.IPM_Completed__c) {
                    wrapperRecordList.add(new sObjectPaginationWrapper(eachTask, true,isEditable,true));
                }
                if(!eachTask.IPM_Completed__c) 
                {
                	wrapperRecordList.add(new sObjectPaginationWrapper(eachTask, false,isEditable,true)); 
                }
            }
         }
    }
    public pageReference refresh() {
        setCon = null;
        getProjectTasks();
        return null;
    }
    /**
    *  Description : toggling sort with due date and adding back to the currentSort map & ordering the result
    *  @name toggleDueDate
    */
    public void toggleDueDate() {
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Due_Date1__c');
        refresh();
    }
    
    /**
    *  Description: toggling sort with tasks and adding back to the currentSort map & ordering the result
    *  @name : toggleSortTasks
    */
    public void toggleSortTasks() {
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Task_Name__c');
        refresh();
    }
    
    /**
    *  Description :toggling sort with sections assigned and adding back to the currentSort map & ordering the result 
    *  @name : toggleSortSections
    */
    public void toggleSortSections() {
        
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Project_Document_Section__r.IPM_Section_Sequence__c');
        refresh();
    }
    
    /**
    *  Description :toggling sort with phases and adding back to the currentSort map & ordering the result
    *  @name toggleSortPhases
    */
    public void toggleSortPhases() {
        
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Phase__c');
        refresh();
    }
    
    /**
    *  Description : toggling sort with completion and adding back to the currentSort map & ordering the result
    *  @name : toggleSortCompletion
    */
    public void toggleSortCompletion() {
        
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Completed__c');
        refresh();
    }
    
    /**
    *  Description : toggling sort with assignees and adding back to the currentSort map & ordering the result 
    *  @name toggleSortAssignees
    */
    public void toggleSortAssignees() {
        
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Assignee__r.Name');
        refresh();
    }
    
    /**
    *  Description :Filtering method on phases
    *  @name filteredPhase
    */
    public void filteredPhase() {
        setCon = null;
        getProjectTasks();
    }
    
    /**
    *  Description : Filtering method on users
    *  @name filteredUser
    */
    public void filteredUser() {
        setCon = null;
        getProjectTasks();
    }
    
    /**
    *  Description :filtering method to filter by completed or open task
    *  @name :filterCompleteTasks
    */
    public void filterCompleteTasks() {
        setCon = null;
        getProjectTasks();
    }
    
    /**
    *  Description : filtering method to filter by current user assigned task
    *  @name myTasks
    */
    public void myTasks() {
        setCon = null;
        getProjectTasks();
    }
    
    /**
    *  Description : Filtering method on my roles
    *  @name myRole
    */
    public void myRole() {
        getProjectTasks();
    }
    
    /**
    *  Description : To delete the task
    *  @name : deleteTask
    */
    public void deleteTask() {
        setPageNumber();
        if(string.isNotBlank(taskId))
        { 
            try{
                List<IPM_Task__c> tObj = [SELECT Id FROM IPM_Task__c WHERE Id =:taskId];
                if(tObj!=null && !tObj.isEmpty() )
                {
                    delete tObj;
                }
            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                            'deleteTask',ex.getMessage(),ex, ERROR_STR, null, null, null,null);
            }
        }
        // Reset Standard Set after DML to get latest records.
        setCon = null;  
        getProjectTasks();
    }
    
    /**
    *  Description :To update the task as completed or open
    *  @name : markComplete
    */
    public void markComplete() {
        try{
            if(string.isNotBlank(taskId))
            {
                List<IPM_Task__c> updatedTaskList = new  List<IPM_Task__c>();
        	
            	List<IPM_Task__c> tObj = [SELECT IPM_Completed__c, IPM_Completed_Date__c,IPM_Master_Task__c,IPM_Assignee__c,IPM_Project__c FROM IPM_Task__c WHERE Id =:taskId limit 50000];
	            tObj[0].IPM_Completed__c = isChecked == 'true' ? true : false; 
	            tObj[0].IPM_Completed_Date__c = isChecked == 'true' ? system.today() : null;
	            	
	            updatedTaskList = IPM_TaskHelper.completeOtherRelatedTasks(tObj[0]);
	            updatedTaskList.add(tObj[0]);
	            
	            update updatedTaskList;
            }
            
        }catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                            'markComplete',ex.getMessage(),ex, ERROR_STR, null, null, null,null);
        }
        setCon = null; 
        getProjectTasks();
    }
    
    /*
    *  Description : To update the changed complexity of project
    *  @name : SaveIPMApproach
    */
    
    public void saveIPMApproach(){
        
        list<IPM_Project__c> projectUpdateList = new list<IPM_Project__c>();
        
        if(projectObj != null && string.isNotBlank(projectObj.IPM_PM_Approach__c))
        {
            if(projectObj.IPM_PM_Approach__c==IPM_ConstantUtils.IPM_APPROACH_INTERNAL)
            {
                projectObj.IPM_PM_Approach__c=IPM_ConstantUtils.IPM_APPROACH_EXTERNAL;
            }
            else
            {
                projectObj.IPM_PM_Approach__c=IPM_ConstantUtils.IPM_APPROACH_INTERNAL;
            }
            projectUpdateList.add(projectObj);
        }
        try{
            if(!projectUpdateList.isEmpty())
            {
                update projectUpdateList;
            }
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                            'SaveIPMApproach',ex.getMessage(),ex, ERROR_STR, null, null, null,null);
        }
    }    
    
    /********************************************************************************
    *@Description :Method to send the parameters required (i.e the object, fields required for the object and the where condition for the query) 
    for the excel download
    *@return:Returns the IPM_ExportToExcel page 
    *********************************************************************************/
    public pagereference exportToExcel(){
        
        PageReference url = Page.IPM_ExportToExcel;
        url.getParameters().put('currentObjectName','Task');
        url.getParameters().put('currentObject','IPM_Task__c');
        url.getParameters().put('fieldSetName','IPM_Export_List_FieldSet');
        url.getParameters().put('whereClause','where IPM_Project__c =\''+projectId+'\' and IPM_Active__c= true and (NOT IPM_Type_of_Task__c LIKE \'%' + String.escapeSingleQuotes('Future Adhoc') + '%\') AND (NOT IPM_Type_of_Task__c LIKE \'%' + String.escapeSingleQuotes('Future Standard') + '%\')');
        
        url.setRedirect(true);
        return url;
    }    
    
    
}
