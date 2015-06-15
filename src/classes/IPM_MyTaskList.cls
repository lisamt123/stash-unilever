public with sharing class IPM_MyTaskList 
{ 
 public String projectId{get;set;}
    public Integer openTasks{get;set;}
    public Integer closedTasks {get; set;}
    public Boolean isAsc{get;set;}
    public Boolean isExternalApproach{get;set;}
    public Map<String, String> currentSort{get;set;}
    public Map<Id, Boolean> lastTasksMap{get;set;}
    public ApexPages.StandardSetController standardSetCon {get;set;}
    public integer totalpages{get;set;}
    public String externalApproach{get;set;}
    public String searchValue{get;set;}
    
    
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
    public String[] brandlist{get;set;}
    public String[] CategoryList{get;set;}
    public String[] projectlist{get;set;}
    
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
    
    
    
    public IPM_MyTaskList() {
        
        openTasks = 0; closedTasks = 0;
        phasesList = new List<String>();
        brandlist= new List<String>();
        categoryList= new List<String>();
        projectlist =new List<String>();
        isAsc = false;
        currentSort = new Map<String, String>{'thisFld' => 'IPM_Completed__c,IPM_Due_Date1__c,IPM_Project_Document_Section__r.IPM_Section_Sequence__c'};
        usersList = new List<String>();
        Set<String> phasesSet =new Set<String>();
        Set<String> brandsSet =new Set<String>();
        Set<String> CategorysSet =new Set<String>();
        Set<String> projectsSet =new Set<String>();
        
        Set<String> usersSet = new Set<String>();
        projectId = ApexPages.currentPage().getParameters().get('id');
       // IPM_Project__c projectObj = [SELECT IPM_PM_Approach__c FROM IPM_Project__c WHERE Id =:projectId];
       // isExternalApproach = projectObj != null && projectObj.ipm_PM_Approach__c == 'External' ? true : false;
        isExternalApproach =true;
        projectTasks = new List<TaskWrapper>();
        Set<Id> userSet = new Set<Id>();
        for(IPM_Task__c eachTask : loadTasks()) {
            userSet.add(eachTask.IPM_Assignee__c);
        }
        userMap = IPM_Utils.getUserProfilePhoto(userSet);
        for(IPM_Task__c eachTask : loadTasks()) {
            phasesSet.add(eachTask.IPM_Phase__c);
            brandsSet.add(eachTask.IPM_Project__r.IPM_Brand__c);
            CategorysSet.add(eachTask.IPM_Project__r.IPM_Category_Text__c);
            System.debug('\n Project Name:'+eachTask.IPM_Project__r.IPM_Project_Name__c);
            projectsSet.add(eachTask.IPM_Project__r.IPM_Project_Name__c);
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
        
        List<IPM_Project__c> lstProject=[SELECT Id,IPM_Parent_Project__c,IPM_PM_Approach__c,IPM_Project_Leader__c,IPM_Project_Name__c FROM IPM_Project__c WHERE IPM_Project_Leader__c =: UserInfo.getUserId() AND IPM_PM_Approach__c = 'External'];
        if(lstProject.size() >0){
            externalApproach ='';
            for(IPM_Project__c project:lstProject){
            externalApproach +=project.IPM_Project_Name__c+',';
            }
            externalApproach=externalApproach.removeEnd(',');
        }
        List<IPM_Project_Resource__c> lstResource=[SELECT IPM_Project__c FROM IPM_Project_Resource__c WHERE IPM_User__c = : UserInfo.getUserId() AND IPM_Project_Role_Owner__c = true];
        List<String> projectIds=new List<String>();
        for(IPM_Project_Resource__c res:lstResource){
            projectIds.add(res.IPM_Project__c);
        }
        List<IPM_Project__c> lstProjects=[SELECT Id,IPM_Project_Name__c FROM IPM_Project__c WHERE Id IN : projectIds AND IPM_PM_Approach__c = 'External'];
        if(!lstProjects.isEmpty()){
                System.debug('\n External:'+externalApproach);
                externalApproach=externalApproach != null?externalApproach+',':'';
                for(IPM_Project__c proj:lstProjects){
                externalApproach += proj.IPM_Project_Name__c+',';
                }
                externalApproach=externalApproach.removeEnd(',');
                System.debug('\n External:'+externalApproach);
        }
        
        
        phasesList.addAll(phasesSet);
        phasesList.sort();
        brandlist.addAll(brandsSet);
        brandlist.sort();
        categoryList.addAll(CategorysSet);
        categoryList.sort();
        System.debug('\n Project Set Value:'+projectsSet);
        projectlist.addAll(projectsSet);
        projectlist.sort();
        usersList.addAll(usersSet);
        usersList.sort();
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
        toggleTask ='true'; 
        
        String soqlWHERE = usrRole == IPM_ConstantUtils.PROJECT_LEADER ? ' AND IPM_Function__c IN (\''+ usrRole +'\' , \'BD\')' : 
                                                                         ' AND IPM_Function__c = \'' + usrRole + '\'';
        String soql  =  'SELECT IPM_Task_Name__c, IPM_Phase__c, IPM_Project_Document_Section__r.IPM_Section_Name__c,';
               soql += 'IPM_Section__r.IPM_Section_Sequence__c,IPM_Project__r.IPM_Project_Name__c,IPM_Project__r.IPM_Category_Text__c,IPM_Project__r.IPM_Category_Icon__c,IPM_Section__r.Name,IPM_Project__r.IPM_Brand__c,';
               soql += 'IPM_Project_Document_Section__c,IPM_Project_Document_Section__r.IPM_Project_Document__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Document_Status__c,';
               soql += 'IPM_Project_Document_Section__r.IPM_Section_Sequence__c, IPM_Assignee__r.Name, IPM_Project__c,';
               soql += 'IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_GateDocuments__c,';
               soql += 'IPM_Due_Date1__c, IPM_Completed__c, IPM_Function__c, IPM_Task_Type__c FROM IPM_Task__c ';
               soql += 'WHERE ';
               //IPM_Due_Date1__c < : System.today AND
        
        if(toggleTask == 'true') {
            soql += ' IPM_Assignee__c = \'' + UserInfo.getUserId() + '\'';
        }
        
        if(phase != '') {
            soql += ' AND IPM_Phase__c IN ' + IPM_Utils.convertStrToSoqlList(phase);
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
        standardSetCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
        
        //standardSetCon.setPageSize(5);
        
        
        Set<Id> sectionIds = new Set<Id>();
        for(IPM_Task__c eachTask : tasksToReturn) {
            sectionIds.add(eachTask.IPM_Project_Document_Section__c);
        }
        IPM_Project_Document_Section__c[] sectionList = [SELECT (SELECT Id FROM Tasks__r) 
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
        System.debug('\n User Role:'+usrRole);
        //return tasksToReturn;            
        return standardSetCon.getRecords();        
    }
    
    Public Boolean HasNext{ get{ return standardSetCon.getHasNext();} set; }
    Public Boolean HasPrevious{ get{ return standardSetCon.getHasPrevious();}set;}
    Public Void First() { standardSetCon.First(); }
    Public Void Last(){ standardSetCon.Last(); }
    Public Void Previous(){ standardSetCon.Previous(); }
    Public Void Next()
    {
        standardSetCon.Next();
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
        resetall();
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
     
     
     
     
     
     
     
     /*public List<IPM_Task__c> getOverDueTasks(){
        
        List<IPM_Task__c> lstTasks=[SELECT IPM_Project_Document_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Section_Name__c,IPM_Function__c,IPM_Project_Document_Section__c,
        IPM_Assignee__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Document_Status__c,IPM_Project__r.Name,IPM_Project__r.IPM_Category_Text__c,
        IPM_Section__r.Name,IPM_Project__r.IPM_Brand__c,IPM_Task_Type__c,IPM_Task_Name__c,IPM_Phase__c,IPM_Due_Date1__c FROM IPM_Task__c WHERE IPM_Assignee__c =: UserInfo.getUserId() AND  
        IPM_Due_Date1__c <: System.today() And IPM_Completed__c = false];
          standardSetCon = new ApexPages.StandardSetController(lstTasks);
          standardSetCon.setPageSize(5);
          return standardSetCon.getRecords();
     }*/

    

public Boolean isBosscard {get; set;}
/*public IPM_HomePageController()
{
Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=9');
isBosscard=false;
}*/
public PageReference project()
{
PageReference page=new PageReference('/apex/ipmproject_1');
return page;
}
public PageReference bosscard()
{
isBosscard=true;
PageReference page=new PageReference('/apex/ipmbosscard_1');
return page;
} 

    Public Integer size{get;set;}
    Public Integer overduesize{get;set;}
    
     //Over Due Tasks
     public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null){
                if(overduesize == null){
                    overduesize = 5;
                }
                
                String query ='SELECT IPM_Completed__c,IPM_Project__r.IPM_Category_Icon__c,IPM_Project_Document_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Section_Name__c,';
                       query +='IPM_Function__c,IPM_Project_Document_Section__c,IPM_Assignee__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Document_Status__c,';
                       query +='IPM_Project__r.IPM_Project_Name__c,IPM_Project__r.IPM_Category_Text__c,IPM_Section__r.Name,IPM_Project__r.IPM_Brand__c,IPM_Task_Type__c,IPM_Task_Name__c,IPM_Phase__c,IPM_Due_Date1__c FROM IPM_Task__c';
                       query +=' WHERE IPM_Assignee__c = '+ '\'' + UserInfo.getUserId() + '\'' + ' AND IPM_Due_Date1__c < ' + System.now().format('YYYY-MM-dd') +' And IPM_Completed__c = false';
                       query +=String.IsNotEmpty(projectName)?' and IPM_Project__r.IPM_Project_Name__c IN'+ IPM_Utils.convertStrToSoqlList(projectName ):'';
                       query +=String.IsNotEmpty(categoryName)?' and IPM_Project__r.IPM_Category_Text__c IN'+IPM_Utils.convertStrToSoqlList(categoryName):'';
                       query +=String.IsNotEmpty(brandName)?' and IPM_Project__r.IPM_Brand__c IN'+IPM_Utils.convertStrToSoqlList(brandName):'';
                       query +=String.IsNotEmpty(searchValue)?' and IPM_Project__r.IPM_Project_Name__c LIKE \'%' + searchValue + '%\'':'';
                       
                if(isAsc) {
                    query += ' ORDER BY ' + currentSort.get('thisFld') + ' DESC NULLS LAST';
                } else {
                    query += ' ORDER BY ' + currentSort.get('thisFld') + ' ASC NULLS LAST';
                }
                System.debug('Query Value:'+query);
               // List<IPM_Task__c> lstTasks;
               /* if(projectName == null){
                    lstTasks=[SELECT IPM_Project_Document_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.
                    IPM_Section_Name__c,IPM_Function__c,IPM_Project_Document_Section__c,IPM_Assignee__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Document_Status__c,
                    IPM_Project__r.Name,IPM_Project__r.IPM_Category_Text__c,IPM_Section__r.Name,IPM_Project__r.IPM_Brand__c,IPM_Task_Type__c,IPM_Task_Name__c,IPM_Phase__c,IPM_Due_Date1__c FROM IPM_Task__c WHERE IPM_Assignee__c =: UserInfo.getUserId() 
                    AND  IPM_Due_Date1__c <: System.today() And IPM_Completed__c = false ];
                */
                //setCon = new ApexPages.StandardSetController(lstTasks);
                setCon = new ApexPages.StandardSetController(DataBase.getqueryLocator(query));
                if(isCompleteTasks != 'Yes'){
                setCon.setPageSize(overduesize);
                }else{
                    setCon.setPageSize(0);
                }
                 //return setCon.getRecords();
                totalpages= Integer.valueof(math.ceil((double)setCon.getResultSize()/(double)setCon.getPageSize()));
            }
            return setCon;
        }set;
    }
    
    public void showAllOverDue() {
        overduesize=setCon.getResultSize();
        setCon=null;
    }
     
    Public List<IPM_Task__c> getOverduetasksSample(){
        System.debug('\n Project Name overDue:'+projectName);
        List<IPM_Task__c> lstTasks= new List<IPM_Task__c>();
        if(setCon != null && isCompleteTasks != 'Yes'){
            for(IPM_Task__c a : (List<IPM_Task__c>)setCon.getRecords()){
                lstTasks.add(a);
            }
        }
        return lstTasks;
    }
    
    //Today Tasks
     public integer showtodaySize {get;set;}
     public integer totaltodaypages{get;set;}
     public ApexPages.StandardSetController setControl {
        get{
            if(setControl == null){
                if(showtodaySize == null) {
                    showtodaySize = 5;
                }
                
                String query ='SELECT IPM_Completed__c,IPM_Project__r.IPM_Category_Icon__c,IPM_Project_Document_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Section_Name__c,';
                       query +='IPM_Function__c,IPM_Project_Document_Section__c,IPM_Assignee__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Document_Status__c,';
                       query +='IPM_Project__r.IPM_Project_Name__c,IPM_Project__r.IPM_Category_Text__c,IPM_Section__r.Name,IPM_Project__r.IPM_Brand__c,IPM_Task_Type__c,IPM_Task_Name__c,IPM_Phase__c,IPM_Due_Date1__c FROM IPM_Task__c';
                       query +=' WHERE IPM_Assignee__c = '+ '\'' + UserInfo.getUserId() + '\'' + ' AND  IPM_Due_Date1__c = ' + System.now().format('YYYY-MM-dd') +' And IPM_Completed__c = false';
                       query +=String.IsNotEmpty(projectName)?' and IPM_Project__r.IPM_Project_Name__c IN'+ IPM_Utils.convertStrToSoqlList(projectName ):'';
                       query +=String.IsNotEmpty(categoryName)?' and IPM_Project__r.IPM_Category_Text__c IN'+IPM_Utils.convertStrToSoqlList(categoryName):'';
                       query +=String.IsNotEmpty(brandName)?' and IPM_Project__r.IPM_Brand__c IN'+IPM_Utils.convertStrToSoqlList(brandName):'';
                       query +=String.IsNotEmpty(phase)?' and IPM_Project__r.IPM_Brand__c IN'+IPM_Utils.convertStrToSoqlList(phase):'';
                       query +=String.IsNotEmpty(searchValue)?' and IPM_Project__r.IPM_Project_Name__c IN'+IPM_Utils.convertStrToSoqlList(searchValue):'';
                System.debug('Query Value:'+query);
                /*List<IPM_Task__c> lstTasks=[SELECT IPM_Project_Document_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Section_Name__c,IPM_Function__c,IPM_Project_Document_Section__c,
                IPM_Assignee__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Document_Status__c,IPM_Project__r.Name,IPM_Project__r.IPM_Category_Text__c,
                IPM_Section__r.Name,IPM_Project__r.IPM_Brand__c,IPM_Task_Type__c,IPM_Task_Name__c,IPM_Phase__c,IPM_Due_Date1__c FROM IPM_Task__c WHERE IPM_Assignee__c =: UserInfo.getUserId() 
                and IPM_Due_Date1__c =: System.today() And IPM_Completed__c = false];
                setControl = new ApexPages.StandardSetController(lstTasks);*/
                setControl = new ApexPages.StandardSetController(DataBase.getqueryLocator(query));
                setControl.setPageSize(showtodaySize);
                 //return setCon.getRecords();
                totaltodaypages= Integer.valueof(math.ceil((double)setControl.getResultSize()/(double)setControl.getPageSize()));
            }
            return setControl;
        }set;
    }
    
    public void todayTasksize() {
        showtodaySize =setControl.getResultSize();
        setControl =null;
    }
    
    public List<IPM_Task__c> getprojectTaskssample() {
        System.debug('\n Today Tasks'+setControl);
        List<IPM_Task__c> lstTasks= new List<IPM_Task__c>();
        if(setControl != null && isCompleteTasks != 'Yes'){
            for(IPM_Task__c a : (List<IPM_Task__c>)setControl.getRecords()){
                lstTasks.add(a);
            }
        }
        return lstTasks;
        
    }
    
    //Next Seven Tasks
    Public Integer nextSevensize{get;set;}
    Public Integer nextSevenpagesize{get;set;}
    public ApexPages.StandardSetController setCont {
        get{
            if(setCont == null){
                 if(nextSevensize == null){
                    nextSevensize = 5;
                }
                String query ='SELECT IPM_Completed__c,IPM_Project__r.IPM_Category_Icon__c,IPM_Project_Document_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Section_Name__c,';
                       query +='IPM_Function__c,IPM_Project_Document_Section__c,IPM_Assignee__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Document_Status__c,';
                       query +='IPM_Project__r.IPM_Project_Name__c,IPM_Project__r.IPM_Category_Text__c,IPM_Section__r.Name,IPM_Project__r.IPM_Brand__c,IPM_Task_Type__c,IPM_Task_Name__c,IPM_Phase__c,IPM_Due_Date1__c FROM IPM_Task__c';
                       query +=' WHERE IPM_Assignee__c = '+ '\'' + UserInfo.getUserId() + '\'' + ' AND  IPM_Due_Date1__c < ' + (System.now()+7).format('YYYY-MM-dd') +' AND  IPM_Due_Date1__c > ' + System.now().format('YYYY-MM-dd') +' And IPM_Completed__c = false';
                       query +=String.IsNotEmpty(projectName)?' and IPM_Project__r.IPM_Project_Name__c IN'+ IPM_Utils.convertStrToSoqlList(projectName ):'';
                       query +=String.IsNotEmpty(categoryName)?' and IPM_Project__r.IPM_Category_Text__c IN'+IPM_Utils.convertStrToSoqlList(categoryName):'';
                       query +=String.IsNotEmpty(brandName)?' and IPM_Project__r.IPM_Brand__c IN'+IPM_Utils.convertStrToSoqlList(brandName):'';
                       query +=String.IsNotEmpty(phase)?' and IPM_Project__r.IPM_Brand__c IN'+IPM_Utils.convertStrToSoqlList(phase):'';
                       query +=String.IsNotEmpty(searchValue)?' and IPM_Project__r.IPM_Project_Name__c IN'+IPM_Utils.convertStrToSoqlList(searchValue):'';
                System.debug('Query Value:'+query);
                /*List<IPM_Task__c> lstTasks=[SELECT IPM_Project_Document_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Section_Name__c,IPM_Function__c,IPM_Project_Document_Section__c,
                IPM_Assignee__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Document_Status__c,IPM_Project__r.Name,IPM_Project__r.IPM_Category_Text__c,
                IPM_Section__r.Name,IPM_Project__r.IPM_Brand__c,IPM_Task_Type__c,IPM_Task_Name__c,IPM_Phase__c,IPM_Due_Date1__c FROM IPM_Task__c WHERE IPM_Assignee__c =: UserInfo.getUserId() and 
                IPM_Due_Date1__c <: System.today()+7 and IPM_Due_Date1__c > : System.today()];
                setCont= new ApexPages.StandardSetController(lstTasks);*/
                setCont = new ApexPages.StandardSetController(DataBase.getqueryLocator(query));
                setCont.setPageSize(nextSevensize);
                 //return setCon.getRecords();
                nextSevenpagesize=Integer.valueof(math.ceil((double)setCont.getResultSize()/(double)setCont.getPageSize()));
            }
            return setCont;
        }set;
    }
    
    public void showAllNextSevenDays() {
        nextSevensize =setCont.getResultSize();
        setCont=null;
    }
    
    
    public List<IPM_Task__c> getNextSevenTasks(){
        
        List<IPM_Task__c> lstTasks= new List<IPM_Task__c>();
        
        if(setCont !=null && isCompleteTasks != 'Yes'){
        for(IPM_Task__c a : (List<IPM_Task__c>)setCont.getRecords())
            lstTasks.add(a);
        return lstTasks;
        }else 
            return null;
     }
    
    
    //Later Tasks
    public integer totallatertaskpages {get;set;}
    public integer laterSize {get;set;}
    public ApexPages.StandardSetController setContr {
        get{
            if(setContr == null){
                if(laterSize == null) {
                    laterSize = 5;
                }
                 String query ='SELECT IPM_Completed__c,IPM_Project__r.IPM_Category_Icon__c,IPM_Project_Document_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Section_Name__c,';
                       query +='IPM_Function__c,IPM_Project_Document_Section__c,IPM_Assignee__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Document_Status__c,';
                       query +='IPM_Project__r.IPM_Project_Name__c,IPM_Project__r.IPM_Category_Text__c,IPM_Section__r.Name,IPM_Project__r.IPM_Brand__c,IPM_Task_Type__c,IPM_Task_Name__c,IPM_Phase__c,IPM_Due_Date1__c FROM IPM_Task__c';
                       query +=' WHERE IPM_Assignee__c = '+ '\'' + UserInfo.getUserId() + '\'' + ' AND  IPM_Due_Date1__c > ' + (System.now()+7).format('YYYY-MM-dd') +' And IPM_Completed__c = false';
                       query +=String.IsNotEmpty(projectName)?' and IPM_Project__r.IPM_Project_Name__c IN'+ IPM_Utils.convertStrToSoqlList(projectName ):'';
                       query +=String.IsNotEmpty(categoryName)?' and IPM_Project__r.IPM_Category_Text__c IN'+IPM_Utils.convertStrToSoqlList(categoryName):'';
                       query +=String.IsNotEmpty(brandName)?' and IPM_Project__r.IPM_Brand__c IN'+IPM_Utils.convertStrToSoqlList(brandName):'';
                       query +=String.IsNotEmpty(phase)?' and IPM_Project__r.IPM_Brand__c IN'+IPM_Utils.convertStrToSoqlList(phase):'';
                       query +=String.IsNotEmpty(searchValue)?' and IPM_Project__r.IPM_Project_Name__c IN'+IPM_Utils.convertStrToSoqlList(searchValue):'';
                System.debug('Query Value:'+query);
                /*List<IPM_Task__c> lstTasks=[SELECT IPM_Project_Document_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Section_Name__c,IPM_Function__c,IPM_Project_Document_Section__c,
                IPM_Assignee__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Document_Status__c,IPM_Project__r.Name,IPM_Project__r.IPM_Category_Text__c,
                IPM_Section__r.Name,IPM_Project__r.IPM_Brand__c,IPM_Task_Type__c,IPM_Task_Name__c,IPM_Phase__c,IPM_Due_Date1__c FROM IPM_Task__c WHERE IPM_Assignee__c =: UserInfo.getUserId() and 
                IPM_Due_Date1__c >: System.today()+7 And IPM_Completed__c = false];
                setContr = new ApexPages.StandardSetController(lstTasks);*/
                setContr = new ApexPages.StandardSetController(DataBase.getqueryLocator(query));
                setContr.setPageSize(laterSize);
                 //return setCon.getRecords();
                totallatertaskpages= Integer.valueof(math.ceil((double)setContr.getResultSize()/(double)setContr.getPageSize()));
            }
            return setContr;
        }set;
    }
    
    public List<IPM_Task__c> getLaterTasks(){
        
        List<IPM_Task__c> lstTasks= new List<IPM_Task__c>();
        if(setContr != null && isCompleteTasks != 'Yes'){
        for(IPM_Task__c a : (List<IPM_Task__c>)setContr.getRecords())
            lstTasks.add(a);
        return lstTasks;
        }else{
            return null;
        }
     }
     
     public void showAllLaterTasks() {
        laterSize =setContr.getResultSize();
        setContr=null;
    }
    
    //Completed Tasks
    public integer totalcompletedpages{get;set;}
    public integer completedSize {get;set;}
    public ApexPages.StandardSetController setController {
        get{
            if(setController == null){
                if(completedSize == null) {
                    completedSize = 5;
                }
                String query ='SELECT IPM_Completed__c,IPM_Project_Document_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Section_Name__c,';
                       query +='IPM_Function__c,IPM_Project_Document_Section__c,IPM_Assignee__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Document_Status__c,';
                       query +='IPM_Project__r.IPM_Project_Name__c,IPM_Project__r.IPM_Category_Text__c,IPM_Project__r.IPM_Category_Icon__c,IPM_Section__r.Name,IPM_Project__r.IPM_Brand__c,IPM_Task_Type__c,IPM_Task_Name__c,IPM_Phase__c,IPM_Due_Date1__c FROM IPM_Task__c';
                       query +=' WHERE IPM_Assignee__c = '+ '\'' + UserInfo.getUserId() + '\'' +' And IPM_Completed__c = true';
                       query +=String.IsNotEmpty(projectName)?' and IPM_Project__r.IPM_Project_Name__c IN'+ IPM_Utils.convertStrToSoqlList(projectName ):'';
                       query +=String.IsNotEmpty(categoryName)?' and IPM_Project__r.IPM_Category_Text__c IN'+IPM_Utils.convertStrToSoqlList(categoryName):'';
                       query +=String.IsNotEmpty(brandName)?' and IPM_Project__r.IPM_Brand__c IN'+IPM_Utils.convertStrToSoqlList(brandName):'';
                       query +=String.IsNotEmpty(phase)?' and IPM_Project__r.IPM_Brand__c IN'+IPM_Utils.convertStrToSoqlList(phase):'';
                       query +=String.IsNotEmpty(searchValue)?' and IPM_Project__r.IPM_Project_Name__c IN'+IPM_Utils.convertStrToSoqlList(searchValue):'';
                System.debug('Query Value:'+query);
                /*List<IPM_Task__c> lstTasks=[SELECT IPM_Project_Document_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Section_Name__c,IPM_Function__c,IPM_Project_Document_Section__c,
                IPM_Assignee__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Document_Status__c,IPM_Project__r.Name,IPM_Project__r.IPM_Category_Text__c,
                IPM_Section__r.Name,IPM_Project__r.IPM_Brand__c,IPM_Task_Type__c,IPM_Task_Name__c,IPM_Phase__c,IPM_Due_Date1__c FROM IPM_Task__c WHERE IPM_Assignee__c =: UserInfo.getUserId() and IPM_Completed__c = true ];
                setController = new ApexPages.StandardSetController(lstTasks);*/
                setController= new ApexPages.StandardSetController(DataBase.getqueryLocator(query));
                setController.setPageSize(completedSize);
                totalcompletedpages= Integer.valueof(math.ceil((double)setController.getResultSize()/(double)setController.getPageSize()));
            }
            return setController;
        }set;
    }
    
     public void showCompletedTasks() {
        completedSize =setController.getResultSize();
        setController=null;
    }
    
    public List<IPM_Task__c> getcompletedTasks(){
        List<IPM_Task__c> lstTasks= new List<IPM_Task__c>();
        if(setController != null && isCompleteTasks != 'No'){
        for(IPM_Task__c a : (List<IPM_Task__c>)setController.getRecords())
            lstTasks.add(a);
            
        return lstTasks;
        }else{
            return null;
        }
     }
     
    private String projectName = '';
    public void setprojectName(String n) {
        projectName = n;
    }
    public String getprojectName() {
        return projectName;
    }
     
    public void filteredProject() {
        System.debug('Project Name Value:'+projectName);
        resetall();
    }
    
    private String categoryName= '';
    public void setcategoryName(String n) {
        categoryName= n;
    }
    public String getcategoryName() {
        return categoryName;
    }
    
     public void filteredCategory() {
        resetall();
    }
    
    private String brandName= '';
    public void setbrandName(String n) {
        brandName= n;
    }
    public String getbrandName() {
        return brandName;
    }
    
    public void toggleDueDate() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Due_Date1__c');
        resetall();
    }
    
    public void projectSearch() {
        resetall();
    }
    
    public void reset(){
        setCon =null;
        setController =null;
        setControl=null;
        setContr=null;
        setCont=null;
    }
    
    public void resetall(){
        setCon =null;
        setController =null;
        setControl=null;
        setContr=null;
        setCont=null;
        //return null;
        getOverduetasksSample();
        getprojectTaskssample();
        getNextSevenTasks();
        getLaterTasks();
        getcompletedTasks();
    }
    
    public void filterCompleteTasks() {
        
        system.debug('** isCompleteTasks : ' + isCompleteTasks);
        resetall();
        //getProjectTasks();
    }
    
    public void toggleSortTasks() {
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Task_Name__c');
        resetall();
    }
    
    public void toggleSortSections() {
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Project_Document_Section__r.IPM_Section_Sequence__c');
        resetall();
    }

    public void filteredBrand() {
        resetall();
    }
}