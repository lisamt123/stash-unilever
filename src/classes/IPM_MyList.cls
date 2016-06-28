/******************************************** 
*@Author:Cognizant
*@Date:October 2014
*@Description : To display user tasks on Home page for Current Day , Next day , 7 days and Overdue Tasks.
*To display tasks to know the due dayes for the assigned tasks.
*Referring in Component IPM_MyList
*********************************************/
public with sharing class IPM_MyList{ 
    /********************************************************************************
    *@Description:To get the current projectID via Page parameters
    *********************************************************************************/
    public String projectId{get;set;}
    /********************************************************************************
    *@Description:To get the open Tasks for the user 
    *********************************************************************************/
    public Integer openTasks{get;set;}
    /********************************************************************************
    *@Description:To get the Closed Tasks for the user assigned to the projects
    *********************************************************************************/
    public Integer closedTasks {get; set;}
    /********************************************************************************
    *@Description:To Sort the level of tasks
    *********************************************************************************/
    public Boolean isAsc{get;set;}
    /********************************************************************************
    *@Description:To describe the tasks to be editable
    *********************************************************************************/
    public Boolean IsTaskEditable{get;set;}
    /********************************************************************************
    *@Description: To display the tasks on the UI only for the projects tasks which are maintained Internal
    *********************************************************************************/
    public Boolean isExternalApproach{get;set;}
    /********************************************************************************
    *@Description:This describe the sorting for current tasks
    *********************************************************************************/
    public Map<String, String> currentSort{get;set;}
    /********************************************************************************
    *@Description: LastTaskMap is to display all the Tasks based on the user
    *********************************************************************************/
    public Map<Id, Boolean> lastTasksMap{get;set;}
    /********************************************************************************
    *@Description: To set the Tasks for different types of tasks on the Page
    *********************************************************************************/
    public ApexPages.StandardSetController standardSetCon {get;set;}
    /********************************************************************************
    *@Description: Total Pages contains the No of pages 
    *********************************************************************************/
    public integer totalpages{get;set;}
    public List<IPM_Project__c> lstExtProj{get;set;}
    public String searchValue{get;set;}
    
    public static final String BLANK_STR = '';
    /********************************************************************************
    *@Description: To describe the TaskId and set the Tasks on the page
    *********************************************************************************/
    
    private String taskId = BLANK_STR;
    public void setTaskId(String n) {
        taskId = n;
    }
    /********************************************************************************
    *@Description: To describe the phases for the tasks
    *********************************************************************************/
    private String phase = BLANK_STR;
    public void setPhase(String n) {
        phase = n;
    }
    /********************************************************************************
    *@Description: To get the phases for the tasks
    *********************************************************************************/
    public String getPhase() {
        return phase;
    }
    /********************************************************************************
    *@Description: To get the Assignee for the Tasks
    *********************************************************************************/    
    private String user = BLANK_STR;
    public void setUser(String n) {
        user = n;
    }
    /********************************************************************************
    *@Description: To get the Users and display them on Page
    *********************************************************************************/
    public String getUser() {
        return user;
    }    
    /********************************************************************************
    *@Description: Ischecked is to determine for the Completed Tasks
    *********************************************************************************/
    public String isChecked{get;set;}
    /********************************************************************************
    *@Description: To get the User for all the projects they are assigned
    *********************************************************************************/
    public Map<Id, String> userMap;
    /********************************************************************************
    *@Description: To sort the TaskName
    *********************************************************************************/
    public String toggleTask{get;set;}
    /********************************************************************************
    *@Description: To sort the Role of the User
    *********************************************************************************/
    public String toggleRole{get;set;}
    /********************************************************************************
    *@Description: To sort the Phases for the Tasks
    *********************************************************************************/
    public String[] phasesList{get;set;}
    /********************************************************************************
    *@Description: To display the Brand of the project
    *********************************************************************************/
    public String[] brandlist{get;set;}
    /********************************************************************************
    *@Description: To display the Category List
    *********************************************************************************/
    public String[] CategoryList{get;set;}
    /********************************************************************************
    *@Description: To display the project assigned to the Task
    *********************************************************************************/
    public String[] projectlist{get;set;}
    /********************************************************************************
    *@Description: To determine the Users
    *********************************************************************************/
    public String[] usersList{get;set;}
    /********************************************************************************
    *@Description: To determine the completed tasks
    *********************************************************************************/
    public String isCompleteTasks{get;set;}
    public String getTaskId(){
        return taskId;
    }
    /********************************************************************************
    *@Description: To hold value of the project searched in project filter
    *********************************************************************************/
    public String searchedProject{get;set;}
    public Set<String> projectsSet;
    /*String literals replaced*/
    public static final String IPMCOMPLETED_STR = ' AND IPM_Completed__c = false';
    public static final String ORDERBY_STR = ' ORDER BY ';
    public static final String DESCNULLSLAST_STR = ' DESC NULLS LAST';
    public static final String ASCNULLSLAST_STR = ' ASC NULLS LAST';
    public static final String IPM_MYLIST_STR = IPM_MyList.class.getName();
    public static final String SELECTQUERY_STR = 'select ipm_completed__c,ipm_project__r.ipm_category_icon__c,ipm_project_document_section__r.ipm_section_sequence__c,ipm_project_document_section__r.ipm_section_name__c,';
    public static final String QUERY_FIELDS_STR = 'IPM_Function__c,IPM_Project_Document_Section__c,IPM_Assignee__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Document_Status__c,';
    public static final String QUERY_FIELDS1_STR = 'IPM_Project__r.Name,IPM_Project__r.IPM_Phase__c,IPM_Project__r.IPM_Category_Text__c,IPM_Section__r.Name,IPM_Project__r.IPM_Brand_Positioning__c, IPM_Project__r.IPM_Project_Type__c, IPM_Task_Type__c,IPM_Task_Name__c,IPM_Phase__c,IPM_Due_Date1__c FROM IPM_Task__c';
    public static final String QUERY_WHERE_PROJECTNAME_STR = ' and IPM_Project__r.Name IN';
    public static final String QUERY_WHERE_PHASE_STR =  ' and ipm_project__r.ipm_phase__c in';
    public static final String QUERY_WHERE_CATEGORYTEXT_STR = ' and ipm_project__r.ipm_category_text__c in';
    public static final String QUERY_WHERE_BRAND_STR = ' and ipm_project__r.IPM_Brand_Positioning__c in';
    public static final String LOAD_TASKS = 'loadTasks';
    public static final String ERROR_STR = 'Error';
    public static final String ISARCHIEVED_FALSE_STR =' AND IPM_Project__r.Is_Archieved__c = false AND IPM_Project__r.IPM_PM_Approach__c =  \'Internal\' ';
    public static final String QUERY_WHERE_ASSIGNEE_STR=' WHERE IPM_Assignee__c = ';
    private static final String LIMIT_STR=' LIMIT 2000 ';
    public List<IPM_Task__c> lstTasks{get;set;}
    public String taskcountValue;
    private final Integer DAY_VALUE = 7;
    /********************************************************************************
    *@Description :For getting Tasks Value.
    *@Param: NA
    *@return:This method returns the list and which contains the all the tasks
    *********************************************************************************/
    public IPM_MyList(){
        openTasks = 0; closedTasks = 0;
        phasesList = new List<String>();
        brandlist= new List<String>();
        categoryList= new List<String>();
        projectlist =new List<String>();
        isAsc = false;
        currentSort = new Map<String, String>{IPM_ConstantUtils.THIS_FIELD => 'IPM_Completed__c,IPM_Due_Date1__c,IPM_Project_Document_Section__r.IPM_Section_Sequence__c'};
        usersList = new List<String>();
        Set<String> brandsSet =new Set<String>();
        Set<String> CategorysSet =new Set<String>();
        Set<String> usersSet = new Set<String>();
        isExternalApproach =true;
        Set<Id> userSet = new Set<Id>();
        lstExtProj = new List<IPM_Project__c>();
        
        //Added this line to prevent future method running in for loop.
        List<IPM_Task__c> taskList = loadTasks();
        for(IPM_Task__c eachTask : taskList) {
            
            userSet.add(eachTask.IPM_Assignee__c);
            brandsSet.add(eachTask.IPM_Project__r.IPM_Brand_Positioning__c);
            CategorysSet.add(eachTask.IPM_Project__r.IPM_Category_Text__c);            
            usersSet.add(eachTask.IPM_Assignee__r.Name);
            
            if(eachTask.IPM_Completed__c) {
                closedTasks++;                
            }else {
                openTasks++;                
            }
        }
        
        List<IPM_Project__c> lstProject=[SELECT Id,IPM_Parent_Project__c,IPM_PM_Approach__c,IPM_Project_Leader__c,IPM_Project_Name__c FROM IPM_Project__c 
                                                                WHERE ( IPM_Project_Leader__c =: UserInfo.getUserId() OR Deputy_Project_Leader__c =: UserInfo.getUserId()  OR IPM_Technical_Project_Leader__c =: UserInfo.getUserId() ) AND IPM_PM_Approach__c = : IPM_ConstantUtils.IPM_APPROACH_EXTERNAL LIMIT 10000];
        if(lstProject != null && !lstProject.isEmpty()){
            for(IPM_Project__c project:lstProject){
                lstExtProj.add(project);
            }
        }
        
        List<IPM_Project_Resource__c> lstResource=[SELECT IPM_Project__c FROM IPM_Project_Resource__c WHERE IPM_User__c = : UserInfo.getUserId() AND IPM_Project_Role_Owner__c = true LIMIT 50000];
        List<String> projectIds=new List<String>();
        for(IPM_Project_Resource__c res:lstResource){
            projectIds.add(res.IPM_Project__c);
        }
        
        List<IPM_Project__c> lstProjects=[SELECT Id,IPM_Project_Name__c FROM IPM_Project__c WHERE Id IN : projectIds AND IPM_PM_Approach__c = : IPM_ConstantUtils.IPM_APPROACH_EXTERNAL LIMIT 10000];
        if(!lstProjects.isEmpty()){
            for(IPM_Project__c proj:lstProjects){
                lstExtProj.add(proj);
            }
            
        }
        
        categoryList.addAll(CategorysSet);
        categoryList.sort();        
        usersList.addAll(usersSet);
        usersList.sort();
    }
    
     public String getTaskcountValue(){
        Integer taskcount =[SELECT count() FROM IPM_Task__c WHERE IPM_Assignee__c =: UserInfo.getUserId() AND IPM_Project__r.Is_Archieved__c = false AND IPM_Project__r.IPM_PM_Approach__c =: IPM_ConstantUtils.IPM_APPROACH_INTERNAL AND IPM_Completed__c = false LIMIT 50000];
        String taskcountValue =String.valueOf(taskcount);
        return taskcountValue;
    }
    
    /********************************************************************************
    *@Description :For getting the Assignee for the tasks
    *@Param: NA
    *@return:This method returns the list and which contains all the assignee for the tasks
    *********************************************************************************/
    
    public void toggleSortAssignees() {
        
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Assignee__r.Name');
        
    }
    
    /********************************************************************************
    *@Description : Getting the tasks and display on the UI
    *@Param: NA
    *@return:This method returns the list and which contains all the tasks
    *********************************************************************************/
    
    @TestVisible private List<IPM_Task__c> loadTasks() {
        
        String utilUserRole = IPM_Utils.userRole();
        List<IPM_Task__c> tasksToReturn = new List<IPM_Task__c>();
        String usrRole = utilUserRole != null?utilUserRole:BLANK_STR;
        lastTasksMap = new Map<Id, Boolean>();
        toggleTask ='true'; 
        brandlist= new List<String>();
        Set<String> brandsSet =new Set<String>();
        
        String soqlWHERE = usrRole == IPM_ConstantUtils.PROJECT_LEADER ? ' AND IPM_Function__c IN (\''+ String.escapeSingleQuotes(usrRole) +'\' , \'BD\')' : 
        ' AND IPM_Function__c = \'' + String.escapeSingleQuotes(usrRole) + '\'';
        String soql  =  'SELECT IPM_Task_Name__c, IPM_Phase__c, IPM_Project_Document_Section__r.IPM_Section_Name__c,';
        soql += 'IPM_Section__r.IPM_Section_Sequence__c,IPM_Project__r.Name,IPM_Project__r.IPM_Phase__c,IPM_Project__r.IPM_Category_Text__c,IPM_Project__r.IPM_Category_Icon__c,IPM_Section__r.Name,IPM_Project__r.IPM_Brand_Positioning__c, IPM_Project__r.Is_Archieved__c,IPM_Project__r.IPM_Project_Type__c , ';
        soql += 'IPM_Project_Document_Section__c,IPM_Project_Document_Section__r.IPM_Project_Document__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Document_Status__c,';
        soql += 'IPM_Project_Document_Section__r.IPM_Section_Sequence__c, IPM_Assignee__r.Name, IPM_Project__c,  ';
        soql += 'IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_GateDocuments__c,';
        soql += 'IPM_Due_Date1__c, IPM_Completed__c, IPM_Function__c, IPM_Task_Type__c  FROM IPM_Task__c ';
        soql += 'WHERE ( IPM_Due_Date1__c != NULL OR IPM_Completed__c = true ) AND IPM_Project__r.IPM_PM_Approach__c = \'Internal\'  AND';        
        
        if(toggleTask == IPM_Utils.truevalue) {
            soql += ' IPM_Assignee__c = \'' + UserInfo.getUserId() + '\'';
        }        
        if(phase != BLANK_STR) {
            phase = IPM_Utils.convertStrToSoqlList(String.escapeSingleQuotes(phase));
            soql += ' AND IPM_Phase__c IN :phase ' ;
        } 
        if(toggleRole == IPM_Utils.truevalue && utilUserRole != null) {
            soql += soqlWHERE;
        }
        if(isCompleteTasks == IPM_Utils.t) {
            soql += ' AND IPM_Completed__c = true';
        }
        if(isCompleteTasks == IPM_Utils.f) {
            soql += IPMCOMPLETED_STR;
        }
        if(user != BLANK_STR) {
            user = String.escapeSingleQuotes(user);
            soql += ' AND IPM_Assignee__r.Name IN ' + IPM_Utils.convertStrToSoqlList(user);
        }
        
        soql += ' AND IPM_Project__r.Is_Archieved__c = false';
        
        if(isAsc) {
            soql += ORDERBY_STR + currentSort.get(IPM_ConstantUtils.THIS_FIELD) + DESCNULLSLAST_STR;
        } else {
            soql += ORDERBY_STR + currentSort.get(IPM_ConstantUtils.THIS_FIELD) + ASCNULLSLAST_STR ;
        }
        soql +=' Limit 1000';
        try{
            tasksToReturn = Database.query(soql);
            standardSetCon = new ApexPages.StandardSetController(tasksToReturn);
        }catch(Exception ex){  catchBlockContent(LOAD_TASKS,ex);  }        
        
        projectsSet =new Set<String>();
        Set<String> phasesSet =new Set<String>();
        Set<Id> sectionIds = new Set<Id>();
        if(tasksToReturn != NULL && !tasksToReturn.isEmpty()){
            for(IPM_Task__c eachTask : tasksToReturn) {
                sectionIds.add(eachTask.IPM_Project_Document_Section__c);
                projectsSet.add(eachTask.IPM_Project__r.Name);
                phasesSet.add(eachTask.IPM_Project__r.IPM_Phase__c);
                brandsSet.add(eachTask.IPM_Project__r.IPM_Brand_Positioning__c);
            }            
            projectlist.addAll(projectsSet);
            projectlist.sort();
            phasesList.addAll(phasesSet);
            phasesList.sort();
            brandlist.addAll(brandsSet);
            brandlist.sort();
        }
        if(!sectionIds.isEmpty()){
            try{
                IPM_Project_Document_Section__c[] sectionList = [SELECT (SELECT Id FROM Tasks__r) 
                                                                 FROM IPM_Project_Document_Section__c
                                                                 WHERE Id IN :sectionIds];
                for(IPM_Project_Document_Section__c eachSection : sectionList) {
                    IPM_Task__c[] tasksList = eachSection.Tasks__r;
                }
            }catch(Exception ex){ catchBlockContent(LOAD_TASKS,ex);  }
        }
        
        return standardSetCon.getRecords();        
    }    
    
    /*******************************************************************************
    *@Description:To query the Next Tasks
    *********************************************************************************/
    Public Boolean HasNext{ get{ return standardSetCon.getHasNext();} set; }
    
    /*******************************************************************************
    *@Description:To query the previous tasks 
    *********************************************************************************/
    Public Boolean HasPrevious{ get{ return standardSetCon.getHasPrevious();}set;}
    
    //Delete Tasks  
    public void deleteTask() {
        try 
        {
            delete [SELECT Id FROM IPM_Task__c WHERE Id =:taskId];
        }catch(Exception ex){   catchBlockContent('deleteTask',ex);  }
    }

    /********************************************************************************
    *@Description : To mark the task as completed
    *@Param: NA
    *@return:This method returns the list and which contains the completed tasks
    *********************************************************************************/
    
    public void markComplete() {
        try{
			List<IPM_Task__c> updatedTaskList = new  List<IPM_Task__c>();
        	
            List<IPM_Task__c> tObj = [SELECT IPM_Completed__c, IPM_Completed_Date__c,IPM_Master_Task__c,IPM_Assignee__c,IPM_Project__c FROM IPM_Task__c WHERE Id =:taskId limit 50000];

            tObj[0].IPM_Completed__c = isChecked == 'true' ? true : false; 
            tObj[0].IPM_Completed_Date__c = isChecked == 'true' ? system.today() : null;
            	
            updatedTaskList = IPM_TaskHelper.completeOtherRelatedTasks(tObj[0]);
            updatedTaskList.add(tObj[0]);
            
            update updatedTaskList;
   
        }catch(Exception ex){   catchBlockContent('markComplete',ex);  }
        resetall();
    }    
    
    /********************************************************************************
    *@Description : To query and get all the tasks as a wrapper
    *@Param: NA
    *@return:This method returns the list and which contains all the tasks
    *********************************************************************************/
    public Boolean isBosscard {get; set;}
    
    public Integer size{get;set;}
    public Integer overduesize{get;set;}   
    public Integer overduesize1{get;set;}    
    
    /********************************************************************************
    *@Description :For getting the overdue tasks
    *@Param: NA
    *@return:This method returns the list and which contains tasks which are overdue
    *********************************************************************************/
    public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null){
                if(overduesize == null){
                    overduesize = 5;
                }
                
                String query =SELECTQUERY_STR;
                query +=QUERY_FIELDS_STR;
                query +=QUERY_FIELDS1_STR;
                query +=QUERY_WHERE_ASSIGNEE_STR+ '\'' + UserInfo.getUserId() + '\'' + ' AND IPM_Due_Date1__c < ' + System.now().format(IPM_ConstantUtils.DATE_FORMAT) +IPMCOMPLETED_STR;
                query +=String.IsNotEmpty(projectName)?QUERY_WHERE_PROJECTNAME_STR+ IPM_Utils.convertStrToSoqlList(projectName ):'';
                query +=String.IsNotEmpty(phase)?QUERY_WHERE_PHASE_STR+ IPM_Utils.convertStrToSoqlList(phase):'';
                query +=String.IsNotEmpty(categoryName)?QUERY_WHERE_CATEGORYTEXT_STR+IPM_Utils.convertStrToSoqlList(categoryName):'';
                query +=String.IsNotEmpty(brandName)?QUERY_WHERE_BRAND_STR+IPM_Utils.convertStrToSoqlList(brandName):'';
                query +=String.IsNotEmpty(searchValue)?' and IPM_Project__r.Name LIKE \'%' + searchValue + '%\'':'';
                query +=ISARCHIEVED_FALSE_STR;
                
                if(isAsc) {
                    query += ORDERBY_STR + currentSort.get(IPM_ConstantUtils.THIS_FIELD) + DESCNULLSLAST_STR;
                } else {
                    query += ORDERBY_STR + currentSort.get(IPM_ConstantUtils.THIS_FIELD) + ASCNULLSLAST_STR;
                }
                query += LIMIT_STR;
                try{
                    setCon = new ApexPages.StandardSetController(DataBase.getqueryLocator(query));
                    if(isCompleteTasks != IPM_Utils.Yes){
                        setCon.setPageSize(overduesize);
                    }else{
                        setCon.setPageSize(0);
                    }
                    
                    totalpages= Integer.valueof(math.ceil((double)setCon.getResultSize()/(double)setCon.getPageSize()));
                }catch(Exception ex){   catchBlockContent('setCon',ex);  }
            }
            return setCon;
        }set;
    }    
    
    /********************************************************************************
    *@Description : To show all the OverDue Takss
    *@Param: NA
    *@return:This method returns the list and which contains overdue tasks
    *********************************************************************************/
    
    public void showAllOverDue() {
        overduesize=setCon.getResultSize();
        setCon=null;
    }
    
    Public List<IPM_Task__c> getOverduetasksSample(){
        try{
             lstTasks = new List<IPM_Task__c>();
            if(setCon != null && isCompleteTasks != IPM_Utils.Yes){
                for(IPM_Task__c a : (List<IPM_Task__c>)setCon.getRecords()){
                    lstTasks.add(a);
                }
            }
            return lstTasks;
        }catch(Exception ex){  catchBlockContent('getOverduetasksSample',ex);  return null;  }
    }
    
    /********************************************************************************
    *@Description : To show all the Today Takss
    *@Param: NA
    *@return:This method returns the list and which contains today tasks
    *********************************************************************************/
    public integer showtodaySize {get;set;}
    public integer totaltodaypages{get;set;}
    public ApexPages.StandardSetController setControl {
        get{
            try{
                if(setControl == null){
                    if(showtodaySize == null) {
                        showtodaySize = 5;
                    }                    
                    String query =SELECTQUERY_STR;
                    query +=QUERY_FIELDS_STR;
                    query +=QUERY_FIELDS1_STR;
                    query +=QUERY_WHERE_ASSIGNEE_STR+ '\'' + UserInfo.getUserId() + '\'' + ' AND  IPM_Due_Date1__c = ' + System.now().format(IPM_ConstantUtils.DATE_FORMAT) +IPMCOMPLETED_STR;
                    query +=String.IsNotEmpty(projectName)?QUERY_WHERE_PROJECTNAME_STR+ IPM_Utils.convertStrToSoqlList(projectName ):'';
                    query +=String.IsNotEmpty(categoryName)?QUERY_WHERE_CATEGORYTEXT_STR+IPM_Utils.convertStrToSoqlList(categoryName):'';
                    query +=String.IsNotEmpty(brandName)?QUERY_WHERE_BRAND_STR+IPM_Utils.convertStrToSoqlList(brandName):'';
                    query +=String.IsNotEmpty(phase)?QUERY_WHERE_PHASE_STR+IPM_Utils.convertStrToSoqlList(phase):'';
                    query +=String.IsNotEmpty(searchValue)?QUERY_WHERE_PROJECTNAME_STR+IPM_Utils.convertStrToSoqlList(searchValue):'';
                    query += ISARCHIEVED_FALSE_STR;
                                        
                    if(isAsc) {
                        query += ORDERBY_STR + currentSort.get(IPM_ConstantUtils.THIS_FIELD) + DESCNULLSLAST_STR;
                    } else {
                        query += ORDERBY_STR + currentSort.get(IPM_ConstantUtils.THIS_FIELD) + ASCNULLSLAST_STR;
                    }
                    query += LIMIT_STR;
                    setControl = new ApexPages.StandardSetController(DataBase.getqueryLocator(query));
                    setControl.setPageSize(showtodaySize);
                    
                    totaltodaypages= Integer.valueof(math.ceil((double)setControl.getResultSize()/(double)setControl.getPageSize()));
                }
                return setControl;
            }catch(Exception ex){  catchBlockContent('setControl',ex); return null; }
        }set;
    }
    
    public void todayTasksize() {
        try{
            showtodaySize =setControl.getResultSize();
            setControl =null;
        }catch(Exception ex){ catchBlockContent('todayTasksize',ex); }
    }
 
    /********************************************************************************
    *@Description: To query all the Tasks for the project
    *********************************************************************************/
    
    public List<IPM_Task__c> getprojectTaskssample() {
        try {
            List<IPM_Task__c> lstTasks= new List<IPM_Task__c>();
            if(setControl != null && isCompleteTasks != IPM_Utils.Yes){
                for(IPM_Task__c a : (List<IPM_Task__c>)setControl.getRecords()){
                    lstTasks.add(a);
                }
            }
            return lstTasks;
        }catch(Exception ex){ catchBlockContent('getprojectTaskssample',ex); return null; }
        
    }
    
    /********************************************************************************
    *@Description : To show all the Tasks which are overdue in next 7 days
    *@Param: NA
    *@return:This method returns the list and which contains tasks which are overdue in next 7 days
    *********************************************************************************/
    public Integer nextSevensize{get;set;}
    public Integer nextSevenpagesize{get;set;}
    public ApexPages.StandardSetController setCont {
        get{
            try {
                if(setCont == null){
                    if(nextSevensize == null){
                        nextSevensize = 5;
                    }
                    String query =SELECTQUERY_STR;
                    query +=QUERY_FIELDS_STR;
                    query +=QUERY_FIELDS1_STR;
                    query +=QUERY_WHERE_ASSIGNEE_STR+ '\'' + UserInfo.getUserId() + '\'' + ' AND  IPM_Due_Date1__c <= ' + (System.now().addDays(DAY_VALUE)).format(IPM_ConstantUtils.DATE_FORMAT) +' AND  IPM_Due_Date1__c > ' + System.now().format(IPM_ConstantUtils.DATE_FORMAT) +IPMCOMPLETED_STR;
                    query +=String.IsNotEmpty(projectName)?QUERY_WHERE_PROJECTNAME_STR+ IPM_Utils.convertStrToSoqlList(projectName ):'';
                    query +=String.IsNotEmpty(categoryName)?QUERY_WHERE_CATEGORYTEXT_STR+IPM_Utils.convertStrToSoqlList(categoryName):'';
                    query +=String.IsNotEmpty(brandName)?QUERY_WHERE_BRAND_STR+IPM_Utils.convertStrToSoqlList(brandName):'';
                    query +=String.IsNotEmpty(phase)?QUERY_WHERE_PHASE_STR+IPM_Utils.convertStrToSoqlList(phase):'';
                    query +=String.IsNotEmpty(searchValue)?QUERY_WHERE_PROJECTNAME_STR+IPM_Utils.convertStrToSoqlList(searchValue):'';
                    query +=ISARCHIEVED_FALSE_STR;
                                        
                    if(isAsc) {
                        query += ORDERBY_STR + currentSort.get(IPM_ConstantUtils.THIS_FIELD) + DESCNULLSLAST_STR;
                    } else {
                        query += ORDERBY_STR + currentSort.get(IPM_ConstantUtils.THIS_FIELD) + ASCNULLSLAST_STR;
                    }
                    query += LIMIT_STR;
                    setCont = new ApexPages.StandardSetController(DataBase.getqueryLocator(query));
                    setCont.setPageSize(nextSevensize);
                    
                    nextSevenpagesize=Integer.valueof(math.ceil((double)setCont.getResultSize()/(double)setCont.getPageSize()));
                }
                return setCont;
            }catch(Exception ex){  catchBlockContent('setCont',ex); return null; }
        }set;
    }
    
    public void showAllNextSevenDays() {
        try {
            nextSevensize =setCont.getResultSize();
            setCont=null;
        }catch(Exception ex) { catchBlockContent('showAllNextSevenDays',ex); }
    }
    
    /********************************************************************************
    *@Description : To show all the Next 7  Tasks
    *@Param: NA
    *@return:This method returns the list and which contains next 7 Tasks
    *********************************************************************************/
    public List<IPM_Task__c> getNextSevenTasks(){
        try{
            List<IPM_Task__c> lstTasks= new List<IPM_Task__c>();
            
            if(setCont !=null && isCompleteTasks != IPM_Utils.Yes){
                for(IPM_Task__c a : (List<IPM_Task__c>)setCont.getRecords())
                {
                   lstTasks.add(a);
                }   
                return lstTasks;
            }else 
            {
                return null;
            }
        }catch(Exception ex) { catchBlockContent('getNextSevenTasks',ex); return null; }
    }    
    
    /********************************************************************************
    *@Description : To show all the Later Tasks after Next 7 days
    *@Param: NA
    *@return:This method returns the list and which contains Later Tasks after 7 days
    *********************************************************************************/
    public integer totallatertaskpages {get;set;}
    public integer laterSize {get;set;}
    public ApexPages.StandardSetController setContr {
        get{
            try { 
                if(setContr == null){
                    if(laterSize == null) {
                        laterSize = 5;
                    }
                    String query =SELECTQUERY_STR;
                    query +=QUERY_FIELDS_STR;
                    query +=QUERY_FIELDS1_STR;
                    query +=QUERY_WHERE_ASSIGNEE_STR+ '\'' + UserInfo.getUserId() + '\'' + ' AND  (IPM_Due_Date1__c > ' + (System.now()+DAY_VALUE).format(IPM_ConstantUtils.DATE_FORMAT) +' OR IPM_Due_Date1__c = NULL) '+IPMCOMPLETED_STR;
                    query +=String.IsNotEmpty(projectName)?QUERY_WHERE_PROJECTNAME_STR+ IPM_Utils.convertStrToSoqlList(projectName ):'';
                    query +=String.IsNotEmpty(categoryName)?QUERY_WHERE_CATEGORYTEXT_STR+IPM_Utils.convertStrToSoqlList(categoryName):'';
                    query +=String.IsNotEmpty(brandName)?QUERY_WHERE_BRAND_STR+IPM_Utils.convertStrToSoqlList(brandName):'';
                    query +=String.IsNotEmpty(phase)?QUERY_WHERE_PHASE_STR+IPM_Utils.convertStrToSoqlList(phase):'';
                    query +=String.IsNotEmpty(searchValue)?QUERY_WHERE_PROJECTNAME_STR+IPM_Utils.convertStrToSoqlList(searchValue):'';
                    query +=ISARCHIEVED_FALSE_STR;
                    
                    if(isAsc) {
                        query += ORDERBY_STR + currentSort.get(IPM_ConstantUtils.THIS_FIELD) + DESCNULLSLAST_STR;
                    } else {
                        query += ORDERBY_STR + currentSort.get(IPM_ConstantUtils.THIS_FIELD) + ASCNULLSLAST_STR;
                    }
                    query += LIMIT_STR;
                    setContr = new ApexPages.StandardSetController(DataBase.getqueryLocator(query));
                    setContr.setPageSize(laterSize);
                    totallatertaskpages= Integer.valueof(math.ceil((double)setContr.getResultSize()/(double)setContr.getPageSize()));
                }
                return setContr;
            }catch(Exception ex) { catchBlockContent('setContr',ex); return null; }
        }set;
    }
        
    // To query the Later Tasks
    public List<IPM_Task__c> getLaterTasks(){
        try{
            List<IPM_Task__c> lstTasks= new List<IPM_Task__c>();
            if(setContr != null && isCompleteTasks != IPM_Utils.Yes){
                for(IPM_Task__c a : (List<IPM_Task__c>)setContr.getRecords())
                {
                    lstTasks.add(a);
                }    
                return lstTasks;
            }else{
                return null;
            }
        }catch(Exception ex) { catchBlockContent('getLaterTasks',ex); return null; }
    }
    
    public void showAllLaterTasks() {
        try{
            laterSize =setContr.getResultSize();
            setContr=null;
        }catch(Exception ex) { catchBlockContent('showAllLaterTasks',ex); }
    }
    
    /********************************************************************************
    *@Description : To show all the Completed Takss
    *@Param: NA
    *@return:This method returns the list and which contains all the Completed Tasks
    *********************************************************************************/
    public integer totalcompletedpages{get;set;}
    public integer completedSize {get;set;}
    public ApexPages.StandardSetController setController {
        get{
            try {
                if(setController == null){
                    if(completedSize == null) {
                        completedSize = 5;
                    }
                    String query ='SELECT IPM_Completed__c,IPM_Project_Document_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Section_Name__c,';
                    query +=QUERY_FIELDS_STR;
                    query +='IPM_Project__r.Name,IPM_Project__r.IPM_Phase__c,IPM_Project__r.IPM_Category_Text__c,IPM_Project__r.IPM_Category_Icon__c,IPM_Section__r.Name,IPM_Project__r.IPM_Brand_Positioning__c, IPM_Project__r.IPM_Project_Type__c, IPM_Task_Type__c,IPM_Task_Name__c,IPM_Phase__c,IPM_Due_Date1__c FROM IPM_Task__c';
                    query +=QUERY_WHERE_ASSIGNEE_STR+ '\'' + UserInfo.getUserId() + '\'' +' And IPM_Completed__c = true';
                    query +=String.IsNotEmpty(projectName)?QUERY_WHERE_PROJECTNAME_STR+ IPM_Utils.convertStrToSoqlList(projectName ):'';
                    query +=String.IsNotEmpty(categoryName)?QUERY_WHERE_CATEGORYTEXT_STR+IPM_Utils.convertStrToSoqlList(categoryName):'';
                    query +=String.IsNotEmpty(brandName)?QUERY_WHERE_BRAND_STR+IPM_Utils.convertStrToSoqlList(brandName):'';
                    query +=String.IsNotEmpty(phase)?QUERY_WHERE_PHASE_STR+IPM_Utils.convertStrToSoqlList(phase):'';
                    query +=String.IsNotEmpty(searchValue)?QUERY_WHERE_PROJECTNAME_STR+IPM_Utils.convertStrToSoqlList(searchValue):'';
                    query +=ISARCHIEVED_FALSE_STR;
                    
                    if(isAsc) {
                        query += ORDERBY_STR + currentSort.get(IPM_ConstantUtils.THIS_FIELD) + DESCNULLSLAST_STR;
                    } else {
                        query += ORDERBY_STR + currentSort.get(IPM_ConstantUtils.THIS_FIELD) + ASCNULLSLAST_STR;
                    }
                    query += LIMIT_STR;
                    setController= new ApexPages.StandardSetController(DataBase.getqueryLocator(query));
                    setController.setPageSize(completedSize);
                    totalcompletedpages= Integer.valueof(math.ceil((double)setController.getResultSize()/(double)setController.getPageSize()));
                }
                return setController;
            }catch(Exception ex) {  catchBlockContent('setController',ex); return null; }
        }set;
    }
    
    public void showCompletedTasks() {
        try{
            completedSize =setController.getResultSize();
            setController=null;
        }catch(Exception ex) { catchBlockContent('showCompletedTasks',ex); }
    }
    
    /********************************************************** 
    Type Name  : getcompletedTasks()
    Author     : 
    Parameter(s)
    ReturnType: List
    Reason: For getting the completed tasks
    ****************************************************************/
    
    public List<IPM_Task__c> getcompletedTasks(){
        try{
            List<IPM_Task__c> lstTasks= new List<IPM_Task__c>();
            if(setController != null && isCompleteTasks != IPM_Utils.No){
                for(IPM_Task__c a : (List<IPM_Task__c>)setController.getRecords())
                {
                    lstTasks.add(a);
                }            
                return lstTasks;
            }else{
                return null;
            }
        }catch(Exception ex) { catchBlockContent('getcompletedTasks',ex); return null;  }
    }    
    
    /********************************************************************************
    *@Description: To get the project name for the Tasks
    *********************************************************************************/
    
    private String projectName = BLANK_STR;
    public void setprojectName(String n) {
        projectName = n;
    }
    
    /********************************************************************************
    *@Description: To display the Project Name
    *********************************************************************************/
    public String getprojectName() {
        return projectName;
    }
    
    /********************************************************************************
    *@Description: To determine the filtered Project on Reset button click
    *********************************************************************************/
    public void filteredProjectReset() {
        projectlist =new List<String>();
        projectName = searchedProject = BLANK_STR;
        projectlist.addAll(projectsSet);
        projectlist.sort();
    }
    
    /********************************************************************************
    *@Description: To determine the Category Name for the project Task
    *********************************************************************************/
    private String categoryName= BLANK_STR;
    public void setcategoryName(String n) {
        categoryName= n;
    }    
    
    /********************************************************************************
    *@Description: To get the category Name
    *********************************************************************************/
    public String getcategoryName() {
        return categoryName;
    }
    
    /********************************************************************************
    *@Description: To determine the filtered categories
    *********************************************************************************/
    
 /*   public void filteredCategory() {
        resetall();
    }    */
    
    /********************************************************************************
    *@Description: To get the brand names
    *********************************************************************************/
    
    private String brandName= BLANK_STR;
    public void setbrandName(String n) {
        brandName= n;
    }    
    
    /********************************************************************************
    *@Description: To display the brand for the tasks
    *********************************************************************************/
    public String getbrandName() {
        return brandName;
    }
        
    /********************************************************************************
    *@Description: To get the due dates for the tasks
    *********************************************************************************/
    public void toggleDueDate() {
        
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Due_Date1__c');
        resetall();
    }    
    
    public void reset(){
        setCon =null;
        setController =null;
        setControl=null;
        setContr=null;
        setCont=null;
    }
    
    /********************************************************************************
    *@Description: To reset all the sections based on the sorting
    *********************************************************************************/
    public void resetall(){
        setCon =null;
        setController =null;
        setControl=null;
        setContr=null;
        setCont=null;
        getOverduetasksSample();
        getprojectTaskssample();
        getNextSevenTasks();
        getLaterTasks();
        getcompletedTasks();
    }
    
    /********************************************************************************
    *@Description : To reset isCompleteTasks variable
    *@Param: NA
    *@return:This method reset isCompleteTasks variable.
    *********************************************************************************/
    
    public void filterCompleteTasksReset() {
        isCompleteTasks = BLANK_STR;
        reset();
    }
    
    /********************************************************************************
    *@Description : To show all the sorted tasks
    *@Param: NA
    *@return:This method returns the list and which contains sorted tasks
    *********************************************************************************/
    
    public void toggleSortTasks() {
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Task_Name__c');
        resetall();
    }
    
    /********************************************************************************
    *@Description : To show all the sorted sections
    *@Param: NA
    *@return:This method returns the list and which contains sorted sections
    *********************************************************************************/
    
    public void toggleSortSections() {
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Project_Document_Section__r.IPM_Section_Sequence__c');
        resetall();
    }
    
    /********************************************************************************
    *@Description : To show all the sorted phases
    *@Param: NA
    *@return:This method returns the list and which contains sorted phases
    *********************************************************************************/
    
    public void toggleSortPhases() {
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Project__r.IPM_Phase__c');
    }    
    
    /********************************************************************************
    *@Description : To show all the Completed tasks
    *@Param: NA
    *@return:This method returns the list and which contains completed tasks
    *********************************************************************************/
    
    public void toggleSortCompletion() {
        isAsc = isAsc? false : true;
        currentSort.put(IPM_ConstantUtils.THIS_FIELD, 'IPM_Completed__c');
    }
    
    /********************************************************************************
    *@Description : To filter the projects
    *@Param: NA
    *@return:This method will filter the projects in project filter based on searched project text
    *********************************************************************************/
    public void filterProject(){
        projectlist =new List<String>();
        if(String.IsNotEmpty(searchedProject)){
            for(String sProjectName : projectsSet)
            {
                if(String.IsNotEmpty(sProjectName) && sProjectName.startsWithIgnoreCase(searchedProject))
                {
                    projectlist.add(sProjectName);
                }
            }    
        }else{
            projectlist.addAll(projectsSet);
        }
        projectlist.sort();
    }
    /********************************************************************************
    *@Description : To get content of catch block
    *@Param: NA
    *@return:This method will contain the content of catch block
    *********************************************************************************/
    public void catchBlockContent(string methodName,Exception ex){
    	ApexPages.addMessage(new  ApexPages.Message(ApexPages.Severity.ERROR,Label.IPM_Generic_ErrorMessage)); 
        //ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_MYLIST_STR,methodName,ex.getMessage(),ex, ERROR_STR, null, null, null,null);
    }
    
    
}