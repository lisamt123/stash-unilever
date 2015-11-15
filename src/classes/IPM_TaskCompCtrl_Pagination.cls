/*
 
Version 1.0 : To show the generated Regional Rollouts  
Date: 4/12/14
Changelog :  [Irfan Khan] Initial constructor
*/ 
public with sharing class IPM_TaskCompCtrl_Pagination{

    public String projectId{get;set;}
    public Integer openTasks{get;set;}
    public Integer closedTasks {get; set;}
    public Boolean isAsc{get;set;}
    public Boolean isExternalApproach{get;set;}
    public Map<String, String> currentSort{get;set;}
    
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}

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
    public List<taskWrapper> projectTasks;
    public String isCompleteTasks{get;set;}

    
    public String getTaskId() {
        return taskId;
    }
    
    public IPM_TaskCompCtrl_Pagination() {
        
        openTasks = 0; closedTasks = 0;
        phasesList = new List<String>();
        isAsc = true;
        currentSort = new Map<String, String>{IPM_ConstantUtils.THIS_FIELD => 'IPM_Completed__c'};
        usersList = new List<String>();
        Set<String> phasesSet = new Set<String>();
        Set<String> usersSet = new Set<String>();
        projectId = ApexPages.currentPage().getParameters().get('id');
        IPM_Project__c projectObj = [SELECT IPM_PM_Approach__c FROM IPM_Project__c WHERE Id =:projectId];
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
        }
        phasesList.addAll(phasesSet);
        phasesList.sort();
        usersList.addAll(usersSet);
        usersList.sort();
    }
    
    public void toggleDueDate() {
        
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Due_Date1__c');
        getProjectTasks();
        refresh();
    }
    
    public void toggleSortTasks() {
        
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Task_Name__c');
        getProjectTasks();
        refresh();
    }
    
    public void toggleSortSections() {
        
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Project_Document_Section__r.IPM_Section_Sequence__c');
        getProjectTasks();
        refresh();
    }
    
    public void toggleSortPhases() {
        
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Phase__c');
        getProjectTasks();
        refresh();
    }
    
    public void toggleSortCompletion() {
        
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Completed__c');
        getProjectTasks();
        refresh();
    }
    
    public void toggleSortAssignees() {
        
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Assignee__r.Name');
        getProjectTasks();
        refresh();
    }
    
    private String query(){
    
        String usrRole = IPM_Utils.userRole();
        String soqlWHERE = usrRole == IPM_ConstantUtils.PROJECT_LEADER ? ' AND IPM_Function__c IN (\''+ usrRole +'\' , \'BD\')' : 
                                                                         ' AND IPM_Function__c = \'' + usrRole + '\'';
        String soql  =  'SELECT IPM_Task_Name__c, IPM_Phase__c, IPM_Project_Document_Section__r.IPM_Section_Name__c,';
               soql += 'IPM_Project_Document_Section__c,';
               soql += 'IPM_Project_Document_Section__r.IPM_Section_Sequence__c, IPM_Assignee__r.Name, IPM_Project__c,';
               soql += 'IPM_Due_Date1__c, IPM_Completed__c, IPM_Function__c, IPM_Task_Type__c FROM IPM_Task__c ';
               soql += 'WHERE IPM_Project__c = \'' + String.escapeSingleQuotes(projectId) + '\'';
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
            soql += ' ORDER BY ' + currentSort.get(IPM_ConstantUtils.THIS_FIELD) + ' DESC NULLS LAST';
        } else {
            soql += ' ORDER BY ' + currentSort.get(IPM_ConstantUtils.THIS_FIELD) + ' ASC NULLS LAST';
        }
        
    //    system.debug(toggleRole + ' ' + IPM_Utils.userRole() + '** soql : ' + soql);

        return soql;
    }
    
    private List<IPM_Task__c> loadTasks() {
        
        List<IPM_Task__c> tasksToReturn = new List<IPM_Task__c>();
                                                                

        String soql = query();
        
        //system.debug(toggleRole + ' ' + IPM_Utils.userRole() + '** soql : ' + soql);
        tasksToReturn = Database.query(soql);
        
        return tasksToReturn;                    
    }
    
    
    public List<TaskWrapper> getProjectTasks() {
       projectTasks = new List<TaskWrapper>();
       for(IPM_Task__c  eachTask  : (List<IPM_Task__c>)setCon.getRecords())
        {
                     if(eachTask.IPM_Completed__c) {
                         //closedTasks++;
                         projectTasks.add(new TaskWrapper(eachTask, userMap.get(eachTask.IPM_Assignee__c), true));
                    }else {
                        //openTasks++;
                        projectTasks.add(new TaskWrapper(eachTask, userMap.get(eachTask.IPM_Assignee__c), false));
                    }
        }
       return projectTasks;  
    }
    
    /*
    public void getProjectTasks() {
        
        //openTasks = 0; closedTasks = 0;
        projectTasks = new List<TaskWrapper>();
        for(IPM_Task__c eachTask :  (List<IPM_Task__c>)setCon.getRecords()) {
            if(eachTask.IPM_Completed__c) {
                //closedTasks++;
                projectTasks.add(new TaskWrapper(eachTask, userMap.get(eachTask.IPM_Assignee__c), true));
            }else {
                //openTasks++;
                projectTasks.add(new TaskWrapper(eachTask, userMap.get(eachTask.IPM_Assignee__c), false));
            }
        }
    }
    */
    
    
    public void filteredPhase() {
        
      ///  system.debug('** phase : ' + phase);
        getProjectTasks();
        refresh();
    }
    
    public void filteredUser() {
        
    //    system.debug('** user : ' + user);
        getProjectTasks();
        refresh();
    }
    
    public void filterCompleteTasks() {
        
     //   system.debug('** isCompleteTasks : ' + isCompleteTasks);
        getProjectTasks();
        refresh();
    }
    
    public void myTasks() {
        
        getProjectTasks();
        refresh();
    }
    
    public void myRole() {
        
        getProjectTasks();
        refresh();
    }
    
    public void deleteTask() {
        
     //   system.debug('** taskId : ' + taskId);
        List<IPM_Task__c> tObj = [SELECT Id FROM IPM_Task__c WHERE Id =:taskId];
        try
        {
            if(tObj != null && !tObj.isEmpty())
            {
                delete tObj;
            }
        
        getProjectTasks();
        refresh();
        }
        
        catch(Exception e)
        {
            getProjectTasks();
            refresh();
        }
        
    }
    
    public void markComplete() {
        
        IPM_Task__c tObj = [SELECT IPM_Completed__c FROM IPM_Task__c WHERE Id =:taskId];
        tObj.IPM_Completed__c = isChecked == 'true' ? true : false; 
        tObj.IPM_Completed_Date__c = system.today();
        update tObj;
        getProjectTasks();
        refresh();
    }
    
    public class TaskWrapper {
        
        public Boolean isComplete{get;set;}
        public IPM_Task__c taskObj{get;set;}
        public String profilePhoto{get;set;}
        
        public TaskWrapper (IPM_Task__c t, String p, Boolean c) {
            isComplete = c;
            taskObj = t;
            profilePhoto = p;
        }
    } 
    public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null){
                size = 5;
                openTasks = 0; closedTasks = 0;
                                
                string queryString = query();
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                
                for(IPM_Task__c  eachTask  : (List<IPM_Task__c>)setCon.getRecords())
                    {
                                 if(eachTask.IPM_Completed__c) {
                                    closedTasks++;
                                }else {
                                    openTasks++;
                                }
                    
                    }
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();

            }
            return setCon;
        }set;
    }
   
   public pageReference refresh() {
        setCon = null;
        getProjectTasks();
        setCon.setPageNumber(1);
        return null;
    }
     
    public Boolean hasNext {
        get {
        
        //    System.debug('before next ');
            return setCon.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }
  
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
  
    public void first() {
        setCon.first();
    }
  
    public void last() {
        setCon.last();
    }
  
    public void previous() {
        setCon.previous();
    }
  
    public void next() {
        setCon.next();
    }
}