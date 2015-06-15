/*
 
Version 1.0 : To show the generated tasks for a project  
Date: 4/12/14
Changelog :  [Irfan Khan] Initial constructor
*/ 
public without sharing class IPM_TaskCompCtrl {
    
    
    public Boolean pmApproachMessage{get;set;}
    public String projectId{get;set;}
    public Integer openTasks{get;set;}
    public Integer closedTasks {get; set;}
    public Boolean isAsc{get;set;}
    public Boolean isExternalApproach{get;set;}
    public Map<String, String> currentSort{get;set;}
    public Map<Id, Boolean> lastTasksMap{get;set;}
    public Boolean IsTaskEditable{get;set;}
    public Boolean IsAllEditable{get;set;}
    public String UFunctionRole{get;set;}
    private String taskId = '';
    public void setTaskId(String n) {
        taskId = n;
    }
    private String phase = '';
    public void setPhase(String n) {
        phase = n;
    }
    public String getPhase() {
        return phase;
    }
    
    private String user = '';
    public void setUser(String n) {
        user = n;
    }
    public String getUser() {
        return user;
    }
    
    public String isChecked{get;set;}
    public Map<Id, String> userMap;
    public String toggleTask{get;set;}
    public String toggleRole{get;set;}
    public String[] phasesList{get;set;}
    public String[] usersList{get;set;}
    public List<taskWrapper> projectTasks {get;set;}
    public String isCompleteTasks{get;set;}
    /*
    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                projectId = ApexPages.currentPage().getParameters().get('id');
                con = new ApexPages.StandardSetController(Database.getQueryLocator(
                                        [SELECT IPM_Task_Name__c, IPM_Phase__c, IPM_Project_Document_Section__r.IPM_Section_Name__c,
                                            IPM_Project_Document_Section__r.IPM_Version_Number__c, IPM_Assignee__r.Name, IPM_Project__c,
                                            IPM_Due_Date__c, IPM_Completed__c
                                         FROM IPM_Task__c 
                                         WHERE IPM_Project__c = :projectId]));
                // sets the number of records in each page set
                con.setPageSize(10);
            }
            return con;
        }
        set;
    }
    
    // returns a list of wrapper objects for the sObjects in the current page set
    public List<taskWrapper> getProjectTasks() {
        projectTasks = new List<taskWrapper>();
        for (IPM_Task__c category : (List<IPM_Task__c>)con.getRecords())
            projectTasks.add(new taskWrapper(category, category.IPM_Completed__c));

        return projectTasks;
    }*/
    
    public String getTaskId() {
        return taskId;
    }
    
    public IPM_TaskCompCtrl() {
        
        openTasks = 0; closedTasks = 0;
        phasesList = new List<String>();
        isAsc = false;
        currentSort = new Map<String, String>{'thisFld' => 'IPM_Completed__c,IPM_Due_Date1__c,IPM_Project_Document_Section__r.IPM_Section_Sequence__c'};
        usersList = new List<String>();
        Set<String> phasesSet = new Set<String>();
        Set<String> usersSet = new Set<String>();
        projectId = ApexPages.currentPage().getParameters().get('id');
        if(projectId=='' || projectId ==null){
        projectId = ApexPages.currentPage().getParameters().get('Pid');
        }
        IPM_Project__c projectObj = new IPM_Project__c();
        try{
            projectObj = [SELECT IPM_PM_Approach__c FROM IPM_Project__c WHERE Id =:projectId];
        }catch(QueryException qe) {}
        
        isExternalApproach = projectObj != null && projectObj.ipm_PM_Approach__c == 'External' ? true : false;
        projectTasks = new List<TaskWrapper>();
        Set<Id> userSet = new Set<Id>();
        for(IPM_Task__c eachTask : loadTasks()) {
            userSet.add(eachTask.IPM_Assignee__c);
        }
        userMap = IPM_Utils.getUserProfilePhoto(userSet);
        for(IPM_Task__c eachTask : loadTasks()) {
            phasesSet.add(eachTask.IPM_Phase__c);
            usersSet.add(eachTask.IPM_Assignee__r.Name);
            Boolean isLst = lastTasksMap.containsKey(eachTask.IPM_Project_Document_Section__c) ? 
                                lastTasksMap.get(eachTask.IPM_Project_Document_Section__c) : false;
            if(eachTask.IPM_Completed__c) {
                closedTasks++;
                projectTasks.add(new TaskWrapper(eachTask, userMap.get(eachTask.IPM_Assignee__c), true, isLst));
            }else {
                openTasks++;
                projectTasks.add(new TaskWrapper(eachTask, userMap.get(eachTask.IPM_Assignee__c), false, isLst));
            }
        }
        phasesList.addAll(phasesSet);
        phasesList.sort();
        usersList.addAll(usersSet);
        usersList.sort();
    }
    
    public void toggleDueDate() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Due_Date1__c');
        getProjectTasks();
    }
    
    public void toggleSortTasks() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Task_Name__c');
        getProjectTasks();
    }
    
    public void toggleSortSections() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Project_Document_Section__r.IPM_Section_Sequence__c');
        getProjectTasks();
    }
    
    public void toggleSortPhases() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Phase__c');
        getProjectTasks();
    }
    
    public void toggleSortCompletion() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Completed__c');
        getProjectTasks();
    }
    
    public void toggleSortAssignees() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Assignee__r.Name');
        getProjectTasks();
    }
    
    private List<IPM_Task__c> loadTasks() {
        
        List<IPM_Task__c> tasksToReturn = new List<IPM_Task__c>();
        String usrRole = IPM_Utils.userRole();
        lastTasksMap = new Map<Id, Boolean>();
        
        String soqlWHERE = usrRole == IPM_ConstantUtils.PROJECT_LEADER ? ' AND IPM_Function__c IN (\''+ usrRole +'\' , \'BD\')' : 
                                                                         ' AND IPM_Function__c = \'' + usrRole + '\'';
        String soql  =  'SELECT IPM_Task_Name__c, IPM_Phase__c, IPM_Project_Document_Section__r.IPM_Section_Name__c,';
               soql += 'IPM_Project_Document_Section__c,IPM_Project_Document_Section__r.IPM_Project_Document__c,';
               soql += 'IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Document_Status__c,';
               soql += 'IPM_Project_Document_Section__r.IPM_Section_Sequence__c, IPM_Assignee__r.Name, IPM_Project__c,';
               soql += 'IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_GateDocuments__c,';
               soql += 'IPM_Due_Date1__c, IPM_Completed__c, IPM_Function__c, IPM_Task_Type__c FROM IPM_Task__c ';
               soql += 'WHERE IPM_Active__c = true AND IPM_Project__c = \'' + projectId + '\'';
        if(phase != '') {
            soql += ' AND IPM_Phase__c IN ' + IPM_Utils.convertStrToSoqlList(phase);
        } 
        if(toggleTask == 'true') {
            soql += ' AND IPM_Assignee__c = \'' + UserInfo.getUserId() + '\'';
        }
        if(toggleRole == 'true' && IPM_Utils.userRole() != null) {
            soql += soqlWHERE;
        }
        if(isCompleteTasks == 't') {
            soql += ' AND IPM_Completed__c = true';
        }
        if(isCompleteTasks == 'f') {
            soql += ' AND IPM_Completed__c = false';
        }
        if(user != '') {
            soql += ' AND IPM_Assignee__r.Name IN ' + IPM_Utils.convertStrToSoqlList(user);
        }
        if(isAsc) {
            soql += ' ORDER BY ' + currentSort.get('thisFld') + ' DESC NULLS LAST';
        } else {
            soql += ' ORDER BY ' + currentSort.get('thisFld') + ' ASC NULLS LAST';
        }
        
        system.debug(toggleRole + ' ' + IPM_Utils.userRole() + '** soql : ' + soql);
        tasksToReturn = Database.query(soql);
        
        Set<Id> sectionIds = new Set<Id>();
        for(IPM_Task__c eachTask : tasksToReturn) {
            sectionIds.add(eachTask.IPM_Project_Document_Section__c);
        }
        IPM_Project_Document_Section__c[] sectionList = [SELECT (SELECT Id FROM Tasks__r 
                                                                    WHERE IPM_Project__c = :projectId AND IPM_Task_Type__c = 'Negotiable') 
                                                            FROM IPM_Project_Document_Section__c
                                                            WHERE Id IN :sectionIds];
        for(IPM_Project_Document_Section__c eachSection : sectionList) {
            IPM_Task__c[] tasksList = eachSection.Tasks__r;
            if(tasksList.size() == 1) {
                lastTasksMap.put(eachSection.Id, true);
            }else {
                lastTasksMap.put(eachSection.Id, false);
            }
        }
        return tasksToReturn;                    
    }
    
    public void getProjectTasks() {
        
        openTasks = 0; closedTasks = 0;
        projectTasks = new List<TaskWrapper>();
        for(IPM_Task__c eachTask : loadTasks()) {
            Boolean isLst = lastTasksMap.containsKey(eachTask.IPM_Project_Document_Section__c) ? 
                                lastTasksMap.get(eachTask.IPM_Project_Document_Section__c) : false;
            if(eachTask.IPM_Completed__c) {
                closedTasks++;
                projectTasks.add(new TaskWrapper(eachTask, userMap.get(eachTask.IPM_Assignee__c), true, isLst));
            }else {
                openTasks++;
                projectTasks.add(new TaskWrapper(eachTask, userMap.get(eachTask.IPM_Assignee__c), false, isLst));
            }
        }
    }
    
    public void filteredPhase() {
        
        system.debug('** phase : ' + phase);
        getProjectTasks();
    }
    
    public void filteredUser() {
        
        system.debug('** user : ' + user);
        getProjectTasks();
    }
    
    public void filterCompleteTasks() {
        
        system.debug('** isCompleteTasks : ' + isCompleteTasks);
        getProjectTasks();
    }
    
    public void myTasks() {
        
        getProjectTasks();
    }
    
    public void myRole() {
        
        getProjectTasks();
    }
    
    public void deleteTask() {
        
        system.debug('** taskId : ' + taskId);
        List<IPM_Task__c> tObj = [SELECT Id FROM IPM_Task__c WHERE Id =:taskId];
        delete tObj;
        getProjectTasks();
    }
    
    public void markComplete() {
        
        IPM_Task__c tObj = [SELECT IPM_Completed__c FROM IPM_Task__c WHERE Id =:taskId];
        tObj.IPM_Completed__c = isChecked == 'true' ? true : false; 
        tObj.IPM_Completed_Date__c = isChecked == 'true' ? system.today() : null;
        update tObj;
        getProjectTasks();
    }
    
    public class TaskWrapper {
        
        public Boolean isComplete{get;set;}
        public IPM_Task__c taskObj{get;set;}
        public String profilePhoto{get;set;}
        public Boolean isSectionLast{get;set;}
        
        public TaskWrapper (IPM_Task__c t, String p, Boolean c, Boolean i) {
            isComplete = c;
            taskObj = t;
            profilePhoto = p;
            isSectionLast = i;
        }
    } 
    /*
    // indicates whether there are more records after the current page set.
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
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

    // returns the first page of records
     public void first() {
         con.first();
     }

     // returns the last page of records
     public void last() {
         con.last();
     }

     // returns the previous page of records
     public void previous() {
         con.previous();
     }

     // returns the next page of records
     public void next() {
         con.next();
     }

     // returns the PageReference of the original page, if known, or the home page.
     public void cancel() {
         con.cancel();
     }*/
}