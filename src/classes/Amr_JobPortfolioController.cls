public with sharing class Amr_JobPortfolioController{

public List<Amr_Alert__c> alert  {get; set;}
public Amr_Job_Details__c jobDetails {get;set;}
public list<Amr_Job_Allocation__c> jobDetailList{get;set;} 
public String projLeaderCluster{get;set; }
public String projLeaderCountry{get;set; }
public String agencyName{get;set;}
public String brodMarket{get;set;}
public String categoryName{get;set;}
public String brandPos{get;set;}
public String brandName{get;set;}
public String stageLogged{get;set;}
public String jobAccepted{get;set;}
public String jobStared{get;set;}
public String jobReported{get;set;}
public String jobShared{get;set;}
public String addNumber{get;set;}
public String projEmail{get;set;}
public String projectName{get;set;}
public String startDate{get;set;}
public String endDate{get;set;} 
public Id chosenId {get; set;}
public String testing {get; set;}
public Boolean showPageButtonForPriority{get;set;}
public Boolean showPageButtonForPending{get;set;}
public Boolean showPageButtonForLive{get;set;}
public Boolean showPageButtonForDormant{get;set;}


//Navigation variables
    public Integer counterForPriorityJobs = 0;//TO track the number of records parsed
    public Integer limitSizeForPriorityJobs = Integer.valueOf(System.Label.Amr_LimitValue);//Number of records to be displayed
    public Integer totalSizeForPriorityJobs =0; //To Store the total number of records available
    public Integer counterForPendingJobs = 0;
    public Integer limitSizeForPendingJobs = Integer.valueOf(System.Label.Amr_LimitValue);
    public Integer totalSizeForPendingJobs =0;
    public Integer counterForDormantJobs = 0;
    public Integer limitSizeForDormantJobs = Integer.valueOf(System.Label.Amr_LimitValue);
    public Integer totalSizeForDormantJobs =0;
    public Integer counterForLiveJobs = 0;
    public Integer limitSizeForLiveJobs = Integer.valueOf(System.Label.Amr_LimitValue);
    public Integer totalSizeForLiveJobs =0;
    public Integer TotalJobs {get; set;}
    public Integer TotalPendingJobs {get; set;}
    public Integer TotalLiveJobs {get; set;}
    public Integer TotalPriorityJobs {get; set;}
    public Integer TotalDormantJobs  {get; set;}
    public Integer TotalSavingsJobs  {get; set;}
    
    public list<Amr_Job_Allocation__c>priorityJobsToShow{get;set;}
    public list<Amr_Job_Allocation__c>pendingJobsToShow{get;set;}
    public list<Amr_Job_Allocation__c>dormantJobsToShow{get;set;}
    public list<Amr_Job_Allocation__c>liveJobsToShow{get;set;}
    
   /* public list<Amr_Job_Allocation__c> priorityJobAllocationList{get;set;}
    public list<Amr_Job_Allocation__c>liveJobAllocationList{get;set;}
    public list<Amr_Job_Allocation__c>dormantJobAllocationList{get;set;}
    public list<Amr_Job_Allocation__c>pendingJobAllocationList{get;set;}*/
    
    public list<Amr_Job_Allocation__c>priorityJobList{get;set;}
    public list<Amr_Job_Allocation__c>pendingJobList{get;set;}
    public list<Amr_Job_Allocation__c>dormantJobList{get;set;}
    public list<Amr_Job_Allocation__c>liveJobList{get;set;}

    public List<SelectOption> listOfCategory{get;set;} 
    public List<SelectOption> listOfBrandPosition{get;set;}
    public  List<SelectOption> listOfBrand{get;set;}
    public  List<SelectOption> listOfSortOptions{get;set;}
    public  List<SelectOption> listOfProjectName{get;set;}
    public List<Amr_Project_Details__c> projNameList {get;set;}
    public  String[]  listString{get;set;}
    
    public List<Amr_Alert__c> alertList{get;set;}
    public List<Amr_Alert__c> alertListForUnhide{get;set;}
    public String jobIdFromPage{get;set;}
    public Id chosenAlertId{get;set;}
    public Id chosenUnHideAlertId{get;set;}
    public Amr_Alert__c hideAlertObj{get;set;}
    public Amr_Alert__c hideAlertObjNew{get;set;}
    public List<Amr_Alert__c>unHideAlertList{get;set;}
    public boolean showUnhideRecords{get;set;}
    public boolean flagForButtons{get;set;}
    public Id loggedInUserId {get;set;}
    public String selectedSortPriorityOption{get;set;}
    public String selectedSortPendingOption{get;set;}
    public String selectedSortDormantOption{get;set;}
    public String selectedSortliveOption{get;set;}
    public String selectedAlert {get;set;}

public Amr_JobPortfolioController(){
    
    loggedInUserId = UserInfo.getUserId();
    jobDetails  = new Amr_Job_Details__c();
   // startDate= '';
    alertList = new List<Amr_Alert__c>();
    alertListForUnhide= new List<Amr_Alert__c>();
    hideAlertObj = new Amr_Alert__c();
    hideAlertObjNew= new Amr_Alert__c();
    unHideAlertList = new List<Amr_Alert__c>();
    projNameList= [Select Name from Amr_Project_Details__c ORDER BY Name ASC limit 10000];
     listString= new list<string>();
         listString.add('--None--');
        For(Amr_Project_Details__c i : projNameList){
                listString.add(i.name);
        }
        system.debug('listString!!'+listString);
        
    jobIdFromPage = ApexPages.currentPage().getParameters().get('id');
    getJobDetailSearch();
    getAlertRecords();
    showUnhideRecords = false;
    flagForButtons = false;
    getTotalJobs();
    alert = [SELECT Alert_Message__c,job_Id__r.AdManagerText__c FROM Amr_Alert__c where createdDate = today and hide__c = false order by New_Alert__c desc ];
   // selectedSortPriorityOption ='AdManagerText__c';
    system.debug('loggedInUserId !!'+loggedInUserId);
   
}
    
    public void getTotalJobs() {
        TotalJobs = [SELECT count()  FROM  Amr_Job_Details__c where ownerId =:loggedInUserId];
        
        system.debug('Value is !!'+TotalJobs); 
        
        
        TotalPendingJobs  = [SELECT count()  FROM  Amr_Job_Allocation__c where (AM_Job_Detail__r.ownerId =:loggedInUserId OR User__c = :loggedInUserId) AND (AM_Job_Detail__r.Job_Status__c = :Label.Amr_Status_Priority OR AM_Job_Detail__r.Job_Status__c = :Label.Amr_Status_Live) AND  Job_Status__c != 'Cancelled'];
        TotalLiveJobs     = [SELECT count()  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId AND User__c = :loggedInUserId) OR User__c = :loggedInUserId) AND AM_Job_Detail__r.Job_Status__c = :Label.Amr_Status_Live AND  Job_Status__c != 'Cancelled' ];
        TotalPriorityJobs = [SELECT count()  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId AND User__c = :loggedInUserId) OR User__c = :loggedInUserId) AND AM_Job_Detail__r.Job_Status__c = :Label.Amr_Status_Priority AND  Job_Status__c != 'Cancelled'];
        TotalDormantJobs  = [SELECT count()  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId AND User__c = :loggedInUserId) OR User__c = :loggedInUserId) AND AM_Job_Detail__r.Job_Status__c = :Label.Amr_Status_Dormant AND  Job_Status__c != 'Cancelled'];
        TotalSavingsJobs  = 0;
    }
    
   
    
    public String getMethodToPassProjNames(){
        system.debug('serialize!!'+JSON.serialize(listString));
        return JSON.serialize(listString);
    }
    
    public void getAlertRecords(){
        alertList = [select Id,New_Alert__c,Alert_Message__c from Amr_Alert__c where ownerId =:loggedInUserId AND Hide__c =:false];
        system.debug('alertList !!'+alertList);
        alertListForUnhide= [select Id,New_Alert__c,Alert_Message__c from Amr_Alert__c where ownerId =:loggedInUserId AND Hide__c =:true];
          system.debug('alertList !!'+alertListForUnhide);
    }
    
    public PageReference hideAlert(){
    
    showUnhideRecords = false;
    flagForButtons = false;
    
         system.debug('chosenAlertId !!'+chosenAlertId);
        hideAlertObj = [select Id,New_Alert__c,Alert_Message__c from Amr_Alert__c where Id=:chosenAlertId limit 1];
         system.debug('chosenAlertId!!'+chosenAlertId);
         For(Amr_Alert__c alert:alertList){
             if(alert.Id == hideAlertObj.Id){
                 alert.Hide__c = true;
             }
         }
         update alertList;
         getAlertRecords();
         system.debug('alertList inside hide alrert!!'+alertList);
        return null;
    }
    
     public PageReference unHideAlertShow(){
       
        unHideAlertList = [select Id,New_Alert__c,Alert_Message__c from Amr_Alert__c where ownerId =:loggedInUserId AND Hide__c =:true];
        if(unHideAlertList.size()>0){
        showUnhideRecords = true;
        flagForButtons = true;
        }
        system.debug('unHideAlertList !!'+unHideAlertList );
        
        return null;
    }
    
    public PageReference unhideAlert(){ 
    
    showUnhideRecords = true;
    flagForButtons = false;
    
         system.debug('chosenAlertId !!'+chosenAlertId);
        hideAlertObjNew = [select Id,New_Alert__c,Alert_Message__c from Amr_Alert__c where Id=:chosenUnHideAlertId limit 1];
         system.debug('chosenAlertId!!'+chosenAlertId);
         For(Amr_Alert__c alert:unHideAlertList){
             if(alert.Id == hideAlertObjNew.Id){
                 alert.Hide__c = false;
             }
         }
         update unHideAlertList;
         getAlertRecords();
         unHideAlertShow();
         system.debug('alertList inside  new unhide alrert!!'+alertList);
        return null;
    }
    
   
    
     
    public PageReference unHideAlertHide(){
    
       showUnhideRecords =false;
       flagForButtons = false;
       
                
        return null;
    }
    

  public List<SelectOption> getCategoryList(){      
     listOfCategory = new List<SelectOption>();
         List<Amr_Category__c> categoryList= [Select id,Name from Amr_Category__c];
         listOfCategory.add(new selectOption('--None--','--None--'));
         for(Amr_Category__c cat : categoryList)
             listOfCategory.add(new selectOption(cat.Id,cat.Name));
         return listOfCategory;
     }
     
     public List<SelectOption> getBrandPositioningList(){  
         system.debug('categoryName!!'+categoryName);
         listOfBrandPosition = new List<SelectOption>();
         List<Amr_Brand_Positioning__c> brandPosList= [Select id,Name from Amr_Brand_Positioning__c where Category__c =: categoryName];
         listOfBrandPosition.add(new selectOption('--None--','--None--'));
         for(Amr_Brand_Positioning__c bps : brandPosList)
             listOfBrandPosition.add(new selectOption(bps.Id,bps.Name));
              return listOfBrandPosition;
         
     }
     
      public List<SelectOption> getBrandList(){  
      system.debug('brand pos!!'+brandPos);    
         listOfBrand = new List<SelectOption>();
         List<Amr_Brand__c> brandList= [Select id,Name from Amr_Brand__c where Brand_Positioning__c =: brandPos];
         listOfBrand.add(new selectOption('--None--','--None--'));
         for(Amr_Brand__c bp : brandList)
             listOfBrand.add(new selectOption(bp.Id,bp.Name));
         return listOfBrand;
     }
     
      public List<SelectOption> getProjectNameList(){      
         listOfProjectName = new List<SelectOption>();
         List<Amr_Project_Details__c> ProjectNameList= [Select id,Name from Amr_Project_Details__c];
         listOfProjectName .add(new selectOption('--None--','--None--'));
         for(Amr_Project_Details__c cat : ProjectNameList)
             listOfProjectName.add(new selectOption(cat.Id,cat.Name));
         return listOfProjectName ;
     }
     
     //Method to get list in sort options
    public List<SelectOption> getSortOptions(){  
         
         listOfSortOptions = new List<SelectOption>();
          listOfSortOptions.add(new selectOption('--None--','--None--'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.AdManagerText__c','AdManager Number'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.CreatedDate','Date Logged'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Stage_of_Production_Activity__c','Stage of production activity'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Unilever_Project_Leader_Email__c','Project Leader Email'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Project_Leader_Country__c','Location of Unilever Project Leader (Country)'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Category__r.Name','Category'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Brand__r.Name','Brand name'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Project_Details__c','Project name'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Lead_Creative_Agency_name__c','Lead agency name'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Allocated_Budget_euro__c','Allocated budget (euro)'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Brodcast_Market__c','Broadcast market'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Production_Activity_Type__c','Production activity Type'));
         listOfSortOptions.add(new selectOption('Job_Shared__c','Job Shared'));
         listOfSortOptions.add(new selectOption('Job_Status__c','Accepted and email sent'));
         listOfSortOptions.add(new selectOption('Started__c','Started'));
         listOfSortOptions.add(new selectOption('Reported__c','Reported'));
         return listOfSortOptions;
     }

public PageReference getJobDetailSearch() {
   
     
    brodMarket = jobDetails.Brodcast_Market__c;
   projLeaderCluster = jobDetails.Project_Leader_Cluster__c;
    projLeaderCountry = jobDetails.Project_Leader_Country__c;
    agencyName = jobDetails.Lead_Creative_Agency_name__c;
    stageLogged = jobDetails.Stage_of_Production_Activity__c;
    jobStared = jobDetails.Job_Started__c;
    jobReported = jobDetails.Job_Reported__c;
    jobShared = jobDetails.Job_Shared__c;
    jobAccepted = jobDetails.Job_Accepted__c;
    addNumber = jobDetails.AdManagerText__c;
    projEmail = jobDetails.Unilever_Project_Leader_Email__c;
    projectName = jobDetails.Project_Details__c;
    
    jobDetailList = new list<Amr_Job_Allocation__c>();
    system.debug('projLeaderCluster!!!'+projLeaderCluster+'!!projLeaderCountry!!'+projLeaderCountry+'!!agencyName!!'+agencyName+'!!testing !!'+testing );
    system.debug('category!!'+categoryName+'!!brandPos!!!'+brandPos+'!!brandName!!'+brandName);
   // system.debug('start date!!'+startDate+'!!end date!!'+jobDetails.End_Date__c +'!!jobDetails!!'+jobDetails);
         
   /* string soql = 'select Project_Details__c,Production_Activity__c,Allocated_Budget_euro__c,Broadcast_Market__c,Job_Status__c ,createdDate,AdManagerText__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Lead_Creative_Agency_name__c,Category__r.Name,Brand_Positioning__r.Name,Brand__r.Name,Stage_of_Production_Activity__c,Job_Accepted__c,Job_Started__c,Job_Reported__c,Job_Shared__c,id from Amr_Job_Details__c where Name !=null ';*/
    
    string soql = 'select User__c,Started_Image__c,Job_Allocated_Image__c,AM_Job_Detail__r.Project_Details__c,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Job_Status__c,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.Category__c,AM_Job_Detail__r.Brand_Positioning__c,AM_Job_Detail__r.Brand__c,AM_Job_Detail__r.Stage_of_Production_Activity__c,AM_Job_Detail__r.Job_Accepted__c,AM_Job_Detail__r.Job_Started__c,Job_Status_Image__c,Reported_Image__c,Job_Shared__c,AM_Job_Detail__r.Job_Reported__c,AM_Job_Detail__r.job_Shared__c  From Amr_Job_Allocation__c where Name!=null and AM_Job_Detail__r.Job_Cancelled__c = false';
    if(String.isNotBlank(loggedInUserId)){
    
    soql += ' and (AM_Job_Detail__r.OwnerId = \''+loggedInUserId+'\' or  User__c = \''+loggedInUserId+'\')';
           system.debug('soql loggedInUserId'+soql);
    }
    
   /* if (String.isNotBlank(startDate)){
   //start date creation
   String[] startDateSplitQuote = startDate.split(' ');
   String[] startDateSplitSlash = startDateSplitQuote[0].split('/');
   Integer myIntDate = integer.valueOf(startDateSplitSlash[1]);
   Integer myIntMonth = integer.valueOf(startDateSplitSlash[0]);
   Integer myIntYear = integer.valueOf(startDateSplitSlash[2]);
   Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
   DateTime startDateFinal = DateTime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0);
     system.debug('start date!!-----------'+startDateFinal);
           soql += ' and createdDate'+  ' >= '+ startDateFinal.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') ;
           system.debug('soql0'+soql);
    }
    if (String.isNotBlank(endDate)){
    //end date creation
   String[] endDateSplitQuote = endDate.split(' ');
   String[] endDateSplitSlash = endDateSplitQuote[0].split('/');
   Integer myIntDate1 = integer.valueOf(endDateSplitSlash[1]);
   Integer myIntMonth1 = integer.valueOf(endDateSplitSlash[0]);
   Integer myIntYear1 = integer.valueOf(endDateSplitSlash[2]);
   Date d1 = Date.newInstance(myIntYear1, myIntMonth1, myIntDate1);
   DateTime endDateDateFinal = DateTime.newInstance(d1.year(), d1.month(), d1.day(), 0, 0, 0);
     
           soql += ' and createdDate ' +  ' < '+ endDateDateFinal.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
           system.debug('soql01'+soql);
    }
    */
    if (String.isNotBlank(String.valueOf(jobDetails.Start_Date__c))){
        Datetime startdate = jobDetails.Start_Date__c;
        String dateTimeFormat = startdate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
         soql += ' and AM_Job_Detail__r.createdDate'+  ' >= '+ dateTimeFormat ;
           system.debug('soql0'+soql);
    }
    
    if (String.isNotBlank(String.valueOf(jobDetails.End_Date__c))){ 
        Datetime endate  = jobDetails.End_Date__c;
         String dateTimeFormat1 = endate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
          soql += ' and AM_Job_Detail__r.createdDate ' +  ' < '+ dateTimeFormat1 ;
           system.debug('soql0'+soql);
    }
    
     if (String.isNotBlank(jobDetails.Project_Leader_Cluster__c)){
     
           soql += ' and AM_Job_Detail__r.Project_Leader_Cluster__c = \''+String.escapeSingleQuotes(projLeaderCluster)+'\'';
           system.debug('soql1'+soql);
    }
    
     if(String.isNotBlank(projLeaderCountry)){
    soql += ' and AM_Job_Detail__r.Project_Leader_Country__c = \''+String.escapeSingleQuotes(projLeaderCountry)+'\'';
           system.debug('soql2'+soql);
    }
    
     if(String.isNotBlank(agencyName)){
    soql += ' and AM_Job_Detail__r.Lead_Creative_Agency_name__c = \''+String.escapeSingleQuotes(agencyName)+'\'';
           system.debug('soql3'+soql);
     
     }
      if(String.isNotBlank(brodMarket)){
    soql += ' and AM_Job_Detail__r.Brodcast_Market__c LIKE \''+String.escapeSingleQuotes(brodMarket)+'%\'';
           system.debug('soql3'+soql);
     }
      if(String.isNotBlank(categoryName) && categoryName != '--None--'){
      
    soql += ' and AM_Job_Detail__r.Category__r.Id = \''+String.escapeSingleQuotes(categoryName)+'\'';
           system.debug('soql4'+soql);
     }
      if(String.isNotBlank(brandPos) && brandPos != '--None--'){
      
    soql += ' and AM_Job_Detail__r.Brand_Positioning__r.Id = \''+String.escapeSingleQuotes(brandPos)+'\'';
           system.debug('soql5'+soql);
     }
      if(String.isNotBlank(brandName) && brandName != '--None--'){
    soql += ' and AM_Job_Detail__r.Brand__r.Id = \''+String.escapeSingleQuotes(brandName)+'\'';
           system.debug('soql6'+soql);
     }
     if(String.isNotBlank(stageLogged)){
    soql += ' and AM_Job_Detail__r.Stage_of_Production_Activity__c = \''+String.escapeSingleQuotes(stageLogged)+'\'';
           system.debug('soql7'+soql);
     }
     if(String.isNotBlank(jobAccepted)){
    soql += ' and Job_Accepted__c = \''+jobAccepted+'\'';
           system.debug('soql8'+soql);
     }
     if(String.isNotBlank(jobStared)){
    soql += ' and Job_Started__c = \''+jobStared+'\'';
           system.debug('soql9'+soql);
     }
     if(String.isNotBlank(jobReported)){
    soql += ' and Job_Reported__c = \''+jobReported+'\'';
           system.debug('soql10'+soql);
     }
     if(String.isNotBlank(jobShared)){
    soql += ' and Job_Shared__c = \''+jobShared+'\'';
           system.debug('soql11'+soql);
     }
     if(String.isNotBlank(addNumber)){
    soql += ' and AM_Job_Detail__r.AdManagerText__c LIKE \''+String.escapeSingleQuotes(addNumber)+'%\'';
           system.debug('soql12'+soql);
     }
     if(String.isNotBlank(projEmail)){
    soql += ' and AM_Job_Detail__r.Unilever_Project_Leader_Email__c LIKE \''+String.escapeSingleQuotes(projEmail)+'%\'';
           system.debug('soql13'+soql);
     }
     if(String.isNotBlank(projectName)){
    soql += ' and AM_Job_Detail__r.Project_Details__c = \''+String.escapeSingleQuotes(projectName)+'\'';
           system.debug('soql14'+soql);
     }
     jobDetailList = Database.query(soql);
     
     system.debug('*****soql ******'+soql );
     system.debug('*** My List values ' + jobDetailList);
    
        getPriorityJobs();
        getPendingJobs();
        getDormantJobs();
        getLiveJobs();
       
   return null;
   }
   
   public Void getPriorityJobs(){
       priorityJobList = new List<Amr_Job_Allocation__c>();
       Set<Id>priorityJobIds = new Set<Id>();
       Set<String> priorityStrings = new Set<String>();
       for(Amr_Job_Allocation__c jobId:jobDetailList){
           if(jobId.AM_Job_Detail__r.Job_Status__c == Label.Amr_Status_Priority){
               priorityJobIds.add(jobId.AM_Job_Detail__r.Id);
               priorityStrings.add(jobId.AM_Job_Detail__r.AdManagerText__c);
           }
       }
       system.debug('priorityStrings!!'+priorityStrings+'!!priorityJobIds'+priorityJobIds);
        
      //String prioritySoql = 'select Id,Project_Details__c,Production_Activity__c,Broadcast_Market__c,Allocated_Budget_euro__c,Job_Status__c,createdDate,AdManagerText__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Lead_Creative_Agency_name__c,Category__r.Name,Brand_Positioning__r.Name,Brand__r.Name,Stage_of_Production_Activity__c,Job_Accepted__c,Job_Started__c,Job_Reported__c,Job_Shared__c from Amr_Job_Details__c where Id IN:priorityJobIds'; 
      String prioritySoql = 'select User__c,Started_Image__c,Job_Allocated_Image__c,AM_Job_Detail__r.Project_Details__c,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Job_Status__c,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.Category__r.Name,AM_Job_Detail__r.Brand_Positioning__r.Name,AM_Job_Detail__r.Brand__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,AM_Job_Detail__r.Job_Accepted__c,AM_Job_Detail__r.Job_Started__c,Job_Status_Image__c,Reported_Image__c,Job_Shared__c,AM_Job_Detail__r.Job_Reported__c  From Amr_Job_Allocation__c where AM_Job_Detail__r.Id IN:priorityJobIds';
      system.debug('prioritySoql !!!'+prioritySoql );
      if(String.isNotBlank(selectedSortPriorityOption) && selectedSortPriorityOption !='--None--'){
           prioritySoql += ' ORDER BY '+String.escapeSingleQuotes(selectedSortPriorityOption)+' ASC';
      
     }
     
       system.debug('prioritySoql01 !!!'+prioritySoql );
       priorityJobList = Database.query(prioritySoql );
           
      //  priorityJobList = [select Id,Project_Name__c,Production_Activity__c,Broadcast_Market__c,Allocated_Budget_euro__c,Job_Status__c,createdDate,AdManagerText__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Lead_Creative_Agency_name__c,AMCategory__r.Name,Am_Brand_Positioning__r.Name,Am_Brand__r.Name,Stage_of_Production_Activity__c,Job_Accepted__c,Job_Started__c,Job_Reported__c,Job_Shared__c from Amr_Job_Details__c where Id IN:priorityJobIds ];
      system.debug('priorityJobList !!!'+priorityJobList);
     /* priorityJobAllocationList = new List<Amr_Job_Allocation__c>();
      priorityJobAllocationList = getJobAllocation(priorityJobIds);*/
      paginationMethodForPriorityJobs(priorityJobList);
      
    }
    
    public List<Amr_Job_Allocation__c> getJobAllocation(Set<Id> JobIds){
        
        return [Select User__c, Started_Image__c, 
                                Job_Allocated_Image__c,
                                AM_Job_Detail__r.Project_Details__c,
                                AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Brodcast_Market__c,
                                AM_Job_Detail__r.Allocated_Budget_euro__c,Job_Status__c,createdDate,
                                AM_Job_Detail__r.AdManagerText__c,
                                AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,
                                AM_Job_Detail__r.Project_Leader_Country__c,
                                
                                AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.Category__r.Name,
                                AM_Job_Detail__r.Brand_Positioning__r.Name,AM_Job_Detail__r.Brand__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,
                                AM_Job_Detail__r.Job_Accepted__c,AM_Job_Detail__r.Job_Started__c,
                                Job_Status_Image__c,Reported_Image__c,Job_Shared__c,
                                AM_Job_Detail__r.Job_Reported__c,AM_Job_Detail__r.job_Shared__c  
                                From Amr_Job_Allocation__c where AM_Job_Detail__c IN:JobIds and AM_Job_Detail__r.OwnerId =:loggedInUserId ];
        
    }
    
    //method to get sort priority list
    public pageReference getSortedPriorityList(){
        system.debug('selectedSortPriorityOption!!!'+selectedSortPriorityOption);
        getPriorityJobs();
        return null;
    }
   
   
   
   public void getPendingJobs(){
       pendingJobList = new List<Amr_Job_Allocation__c>();
       Set<Id>pendingJobIds = new Set<Id>();
       for(Amr_Job_Allocation__c jobId:jobDetailList){
           if(jobId.AM_Job_Detail__r.Job_Status__c == Label.Amr_Status_Priority || jobId.AM_Job_Detail__r.Job_Status__c == Label.Amr_Status_Live){
               pendingJobIds.add(jobId.AM_Job_Detail__r.Id);
           }
       }
     // String pendingSoql = 'select Id,Project_Details__c,Production_Activity__c,Broadcast_Market__c,Allocated_Budget_euro__c,Job_Status__c,createdDate,AdManagerText__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Lead_Creative_Agency_name__c,Category__r.Name,Brand_Positioning__r.Name,Brand__r.Name,Stage_of_Production_Activity__c,Job_Accepted__c,Job_Started__c,Job_Reported__c,Job_Shared__c from Amr_Job_Details__c where Id IN:pendingJobIds';
      String pendingSoql = 'select User__c,Started_Image__c,Job_Allocated_Image__c,AM_Job_Detail__r.Project_Details__c,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Job_Status__c,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.Category__r.Name,AM_Job_Detail__r.Brand_Positioning__r.Name,AM_Job_Detail__r.Brand__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,AM_Job_Detail__r.Job_Accepted__c,AM_Job_Detail__r.Job_Started__c,Job_Status_Image__c,Reported_Image__c,Job_Shared__c,AM_Job_Detail__r.Job_Reported__c,AM_Job_Detail__r.job_Shared__c  From Amr_Job_Allocation__c where AM_Job_Detail__r.Id IN:pendingJobIds';
      system.debug('pendingSoql !!!'+pendingSoql );
      
      if(String.isNotBlank(selectedSortPendingOption) && selectedSortPendingOption !='--None--'){
           pendingSoql += ' ORDER BY '+String.escapeSingleQuotes(selectedSortPendingOption)+' ASC';
           
     }
       system.debug('pendingSoql 01!!!'+pendingSoql );
      pendingJobList = Database.query(pendingSoql);
     /* pendingJobAllocationList = new List<Amr_Job_Allocation__c>();
      pendingJobAllocationList = getJobAllocation(pendingJobIds);*/
      paginationMethodForPendingJobs(pendingJobList);
      
   }
   
   //method to get sort pending list
    public pageReference getSortedPendingList(){
        system.debug('selectedSortPendingOption!!!'+selectedSortPendingOption);
        getPendingJobs();
        return null;
    }
   
   public void getDormantJobs(){
       dormantJobList = new List<Amr_Job_Allocation__c>();
       Set<Id>dormantJobIds = new Set<Id>();
       for(Amr_Job_Allocation__c jobId:jobDetailList){
           if(jobId.AM_Job_Detail__r.Job_Status__c == Label.Amr_Status_Dormant){
               dormantJobIds.add(jobId.AM_Job_Detail__r.Id);
           }
       }
     // String dormantSoql= 'select Id,Project_Details__c,Production_Activity__c,Broadcast_Market__c,Allocated_Budget_euro__c,Job_Status__c,createdDate,AdManagerText__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Lead_Creative_Agency_name__c,Category__r.Name,Brand_Positioning__r.Name,Brand__r.Name,Stage_of_Production_Activity__c,Job_Accepted__c,Job_Started__c,Job_Reported__c,Job_Shared__c from Amr_Job_Details__c where Id IN:dormantJobIds';
       String dormantSoql = 'select User__c,Started_Image__c,Job_Allocated_Image__c,AM_Job_Detail__r.Project_Details__c,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Job_Status__c,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.Category__r.Name,AM_Job_Detail__r.Brand_Positioning__r.Name,AM_Job_Detail__r.Brand__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,AM_Job_Detail__r.Job_Accepted__c,AM_Job_Detail__r.Job_Started__c,Job_Status_Image__c,Reported_Image__c,Job_Shared__c,AM_Job_Detail__r.Job_Reported__c,AM_Job_Detail__r.job_Shared__c  From Amr_Job_Allocation__c where AM_Job_Detail__r.Id IN:dormantJobIds';
       system.debug('dormantSoql!!!'+dormantSoql);
      
      if(String.isNotBlank(selectedSortDormantOption) && selectedSortDormantOption !='--None--'){
           dormantSoql+= ' ORDER BY '+String.escapeSingleQuotes(selectedSortDormantOption)+' ASC';
           
     }
       system.debug('dormantSoql01!!!'+dormantSoql);
      dormantJobList = Database.query(dormantSoql);
     /* dormantJobAllocationList = new List<Amr_Job_Allocation__c>();
      dormantJobAllocationList = getJobAllocation(dormantJobIds);*/
      system.debug('dormantJobList !!!'+dormantJobList);
      paginationMethodForDormantJobs(dormantJobList);
      
      //removeduplicateDormant(dormantJobList);
   }
   
   //method to get sort dormant list
    public pageReference getSortedDormantList(){
        system.debug('selectedSortDormantOption!!!'+selectedSortDormantOption);
        getDormantJobs();
        return null;
    }
    
   
   public void getLiveJobs(){
       liveJobList = new List<Amr_Job_Allocation__c>();
       Set<Id>liveJobIds = new Set<Id>();
       for(Amr_Job_Allocation__c jobId:jobDetailList){
           if(jobId.AM_Job_Detail__r.Job_Status__c == Label.Amr_Status_Live){
               liveJobIds.add(jobId.AM_Job_Detail__r.Id);
           }
       }
       String str= Label.Amr_Status_Live;
      //String liveSoql= 'select Id,Project_Details__c,Production_Activity__c,Allocated_Budget_euro__c,Broadcast_Market__c,Job_Status__c,createdDate,AdManagerText__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Lead_Creative_Agency_name__c,Category__r.Name,Brand_Positioning__r.Name,Brand__r.Name,Stage_of_Production_Activity__c,Job_Accepted__c,Job_Started__c,Job_Reported__c,Job_Shared__c from Amr_Job_Details__c where Id IN:liveJobIds';
     // String liveSoql= 'select Id,Project_Details__c,Production_Activity__c,Allocated_Budget_euro__c,Broadcast_Market__c,Job_Status__c,createdDate,AdManagerText__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Lead_Creative_Agency_name__c,Category__r.Name,Brand_Positioning__r.Name,Brand__r.Name,Stage_of_Production_Activity__c,Job_Accepted__c,Job_Started__c,Job_Reported__c,Job_Shared__c from Amr_Job_Details__c where Job_Status__c =: str';
      String liveSoql = 'select User__c,Started_Image__c,Job_Allocated_Image__c,AM_Job_Detail__r.Project_Details__c,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Job_Status__c,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.Category__r.Name,AM_Job_Detail__r.Brand_Positioning__r.Name,AM_Job_Detail__r.Project_Details__r.Name,AM_Job_Detail__r.Brand__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,AM_Job_Detail__r.Job_Accepted__c,AM_Job_Detail__r.Job_Started__c,Job_Status_Image__c,Reported_Image__c,Job_Shared__c,AM_Job_Detail__r.Job_Reported__c,AM_Job_Detail__r.job_Shared__c  From Amr_Job_Allocation__c where AM_Job_Detail__r.Id IN:liveJobIds';
      system.debug('liveSoql!!!'+liveSoql);
      
      if(String.isNotBlank(selectedSortLiveOption) && selectedSortLiveOption !='--None--'){
           liveSoql+= ' ORDER BY '+String.escapeSingleQuotes(selectedSortLiveOption)+' ASC';
           
     }
       system.debug('liveSoql01!!!'+liveSoql);
      liveJobList = Database.query(liveSoql);
     /*  for(Amr_Job_Details__c jobId:liveJobList){
           if(jobId.Job_Status__c == Label.Amr_Status_Live){
               liveJobIds.add(jobId.Id);
           }
       }
      system.debug('liveJobList !!!'+liveJobList );
      liveJobAllocationList = new List<Amr_Job_Allocation__c>();
      liveJobAllocationList = getJobAllocation(liveJobIds);
      
      system.debug('liveJobAllocationList !!!'+liveJobAllocationList );*/
      paginationMethodForLiveJobs(liveJobList);  
   }
   
   //method to get sort live list
    public pageReference getSortedLiveList(){
        system.debug('selectedSortLiveOption!!!'+selectedSortLiveOption);
        getLiveJobs();
        return null;
    }
    
    //pagination for priority jobs starts here
   public void paginationMethodForPriorityJobs(List<Amr_Job_Allocation__c> jobListToDisplay){
       priorityJobsToShow = new list<Amr_Job_Allocation__c>();
       totalSizeForPriorityJobs = jobListToDisplay.size();
       if(limitSizeForPriorityJobs < totalSizeForPriorityJobs){
       showPageButtonForPriority = true;
       }else{
       showPageButtonForPriority = false;
       }
        //Intial adding
        //check the total records are more than limitSizeForPriorityJobs and assign the records
        if((counterForPriorityJobs+limitSizeForPriorityJobs) <= totalSizeForPriorityJobs){
            for(Integer i=0;i<limitSizeForPriorityJobs;i++){
                priorityJobsToShow.add(jobListToDisplay.get(i));
            }
        }else{
            for(Integer i=0;i<totalSizeForPriorityJobs;i++){
                priorityJobsToShow.add(jobListToDisplay.get(i));
            }
        }
        
        if(!priorityJobsToShow.isEmpty()){
          List<Amr_Job_Allocation__c> lstPriorityNew = new List<Amr_Job_Allocation__c>();
          system.debug('******priorityJobsToShow11'+priorityJobsToShow);    
          lstPriorityNew = priorityJobsToShow;
          priorityJobsToShow = new List<Amr_Job_Allocation__c>();
          removeduplicate(lstPriorityNew);
        }
         
         system.debug('******priorityJobsToShow'+priorityJobsToShow);
      }
        
    public void beginningForPriorityJobs(){
        priorityJobsToShow.clear();
        counterForPriorityJobs=0;
        if((counterForPriorityJobs + limitSizeForPriorityJobs) <= totalSizeForPriorityJobs){
            for(Integer i=0;i<limitSizeForPriorityJobs;i++){
                priorityJobsToShow.add(priorityJobList.get(i));
            }   
        }else{
            for(Integer i=0;i<totalSizeForPriorityJobs;i++){
                priorityJobsToShow.add(priorityJobList.get(i));
            }       
        }
    }
   
    public void removeduplicate(List<Amr_Job_Allocation__c> lstPriorityJobsToShow){
         List<Amr_Job_Allocation__c> lstremoveduplicate = new  List<Amr_Job_Allocation__c>();
         lstremoveduplicate = lstPriorityJobsToShow;
          system.debug('******lstremoveduplicate'+lstremoveduplicate);
           system.debug('******lstPriorityJobsToShow'+lstPriorityJobsToShow);
         lstPriorityJobsToShow = new  List<Amr_Job_Allocation__c>();
         Set<String>jobAllocIds = new Set<String>();
         
        
           system.debug('****1111**lstPriorityJobsToShow'+lstPriorityJobsToShow);
           
          system.debug('*****222*lstremoveduplicate'+lstremoveduplicate);
          for(Amr_Job_Allocation__c job:lstremoveduplicate){
            
             system.debug('******ob.AM_Job_Detail__r.Id'+Job.AM_Job_Detail__r.Id);
               system.debug('******jobAllocIds'+jobAllocIds);
            if(!jobAllocIds.contains(job.AM_Job_Detail__r.Id )){
                jobAllocIds.add(job.AM_Job_Detail__r.Id);
                lstPriorityJobsToShow.add(job);
                priorityJobsToShow.add(job);
            }
           system.debug('******priorityJobsToShow'+priorityJobsToShow);
         }
        
    }
    
    
     public void removeduplicatePending(List<Amr_Job_Allocation__c> lstPriorityJobsToShow){
         List<Amr_Job_Allocation__c> lstremoveduplicate = new  List<Amr_Job_Allocation__c>();
         lstremoveduplicate = lstPriorityJobsToShow;
          system.debug('******lstremoveduplicate'+lstremoveduplicate);
           system.debug('******lstPriorityJobsToShow'+lstPriorityJobsToShow);
         lstPriorityJobsToShow = new  List<Amr_Job_Allocation__c>();
         Set<String>jobAllocIds = new Set<String>();
         
        
           system.debug('****1111**lstPriorityJobsToShow'+lstPriorityJobsToShow);
           
          system.debug('*****222*lstremoveduplicate'+lstremoveduplicate);
          for(Amr_Job_Allocation__c job:lstremoveduplicate){
            
             system.debug('******ob.AM_Job_Detail__r.Id'+Job.AM_Job_Detail__r.Id);
               system.debug('******jobAllocIds'+jobAllocIds);
            if(!jobAllocIds.contains(job.AM_Job_Detail__r.Id )){
                jobAllocIds.add(job.AM_Job_Detail__r.Id);
                lstPriorityJobsToShow.add(job);
                pendingJobsToShow.add(job);
            }
           system.debug('******priorityJobsToShow'+priorityJobsToShow);
         }
        
    }
    
    
     public void removeduplicateDormant(List<Amr_Job_Allocation__c> lstPriorityJobsToShow){
         List<Amr_Job_Allocation__c> lstremoveduplicate = new  List<Amr_Job_Allocation__c>();
         lstremoveduplicate = lstPriorityJobsToShow;
          system.debug('******lstremoveduplicate'+lstremoveduplicate);
           system.debug('******lstPriorityJobsToShow'+lstPriorityJobsToShow);
         lstPriorityJobsToShow = new  List<Amr_Job_Allocation__c>();
         Set<String>jobAllocIds = new Set<String>();
         
        
           system.debug('****1111**lstPriorityJobsToShow'+lstPriorityJobsToShow);
           
          system.debug('*****222*lstremoveduplicate'+lstremoveduplicate);
          for(Amr_Job_Allocation__c job:lstremoveduplicate){
            
             system.debug('******ob.AM_Job_Detail__r.Id'+Job.AM_Job_Detail__r.Id);
               system.debug('******jobAllocIds'+jobAllocIds);
            if(!jobAllocIds.contains(job.AM_Job_Detail__r.Id )){
                jobAllocIds.add(job.AM_Job_Detail__r.Id);
                lstPriorityJobsToShow.add(job);
                dormantJobsToShow.add(job);
            }
           system.debug('******priorityJobsToShow'+priorityJobsToShow);
         }
        
    }
    
     public void removeduplicateLive(List<Amr_Job_Allocation__c> lstPriorityJobsToShow){
         List<Amr_Job_Allocation__c> lstremoveduplicate = new  List<Amr_Job_Allocation__c>();
         lstremoveduplicate = lstPriorityJobsToShow;
          system.debug('******lstremoveduplicate'+lstremoveduplicate);
           system.debug('******lstPriorityJobsToShow'+lstPriorityJobsToShow);
         lstPriorityJobsToShow = new  List<Amr_Job_Allocation__c>();
         Set<String>jobAllocIds = new Set<String>();
         
        
           system.debug('****1111**lstPriorityJobsToShow'+lstPriorityJobsToShow);
           
          system.debug('*****222*lstremoveduplicate'+lstremoveduplicate);
          for(Amr_Job_Allocation__c job:lstremoveduplicate){
            
             system.debug('******ob.AM_Job_Detail__r.Id'+Job.AM_Job_Detail__r.Id);
               system.debug('******jobAllocIds'+jobAllocIds);
            if(!jobAllocIds.contains(job.AM_Job_Detail__r.Id )){
                jobAllocIds.add(job.AM_Job_Detail__r.Id);
                lstPriorityJobsToShow.add(job);
                liveJobsToShow.add(job);
            }
           system.debug('******priorityJobsToShow'+priorityJobsToShow);
         }
        
    }
    public void nextForPriorityJobs(){
        priorityJobsToShow.clear();
        counterForPriorityJobs=counterForPriorityJobs+limitSizeForPriorityJobs;
        if((counterForPriorityJobs+limitSizeForPriorityJobs) <= totalSizeForPriorityJobs){
            for(Integer i=counterForPriorityJobs;i<(counterForPriorityJobs+limitSizeForPriorityJobs);i++){
                priorityJobsToShow.add(priorityJobList.get(i));
            }
        } else{
            for(Integer i=counterForPriorityJobs;i<totalSizeForPriorityJobs;i++){
                priorityJobsToShow.add(priorityJobList.get(i));
            }
        }
    }
   
    public void previousForPriorityJobs(){
        priorityJobsToShow.clear();
        counterForPriorityJobs=counterForPriorityJobs-limitSizeForPriorityJobs;       
            for(Integer i=counterForPriorityJobs;i<(counterForPriorityJobs+limitSizeForPriorityJobs); i++){
            priorityJobsToShow.add(priorityJobList.get(i));
        }
    }

    public void lastForPriorityJobs (){
        priorityJobsToShow.clear();
        if(math.mod(totalSizeForPriorityJobs , limitSizeForPriorityJobs) == 0){
            counterForPriorityJobs = limitSizeForPriorityJobs * ((totalSizeForPriorityJobs/limitSizeForPriorityJobs)-1);
        } else if (math.mod(totalSizeForPriorityJobs , limitSizeForPriorityJobs) != 0){
            counterForPriorityJobs = limitSizeForPriorityJobs * ((totalSizeForPriorityJobs/limitSizeForPriorityJobs));
        }
        for(Integer i=counterForPriorityJobs-1;i<totalSizeForPriorityJobs-1;i++){
                priorityJobsToShow.add(priorityJobList.get(i));
        }
      }
   
    public Boolean getDisableNextForPriorityJobs(){
        if((counterForPriorityJobs + limitSizeForPriorityJobs) >= totalSizeForPriorityJobs )
            return true ;
        else
            return false ;
    }
   
    public Boolean getDisablePreviousForPriorityJobs(){
        if(counterForPriorityJobs == 0)
            return true ;
        else
            return false ;
    } 
    //pagination for priority jobs ends here
    
    
       //pagination for pending jobs starts here
   public void paginationMethodForPendingJobs(List<Amr_Job_Allocation__c> jobListToDisplay){
       pendingJobsToShow = new list<Amr_Job_Allocation__c>();
       totalSizeForPendingJobs = jobListToDisplay.size();
       if(limitSizeForPendingJobs < totalSizeForPendingJobs){
       showPageButtonForPending = true;
       }else{
       showPageButtonForPending = false;
       }
        //Intial adding
        //check the total records are more than limitSizeForPriorityJobs and assign the records
        if((counterForPendingJobs+limitSizeForPendingJobs) <= totalSizeForPendingJobs){
            for(Integer i=0;i<limitSizeForPendingJobs;i++){
                pendingJobsToShow.add(jobListToDisplay.get(i));
            }
        }else{
            for(Integer i=0;i<totalSizeForPendingJobs;i++){
                pendingJobsToShow.add(jobListToDisplay.get(i));
            }
        }
        
          
        if(!pendingJobsToShow.isEmpty()){
          List<Amr_Job_Allocation__c> lstPriorityNew = new List<Amr_Job_Allocation__c>();
            
          lstPriorityNew = pendingJobsToShow;
          pendingJobsToShow = new List<Amr_Job_Allocation__c>();
          removeduplicatePending(lstPriorityNew);
        }
         
      }
        
    public void beginningForPendingJobs(){
        
        system.debug('limitSizeForPendingJobs!!'+limitSizeForPendingJobs+'totalSizeForPendingJobs!!'+totalSizeForPendingJobs);
        pendingJobsToShow.clear();
        counterForPendingJobs=0;
        if((counterForPendingJobs + limitSizeForPendingJobs) <= totalSizeForPendingJobs){
            for(Integer i=0;i<limitSizeForPendingJobs;i++){
                pendingJobsToShow.add(pendingJobList.get(i));
            }   
        }else{
            for(Integer i=0;i<totalSizeForPendingJobs;i++){
                pendingJobsToShow.add(pendingJobList.get(i));
            }       
        }
    }
   
    public void nextForPendingJobs(){
        pendingJobsToShow.clear();
        counterForPendingJobs = counterForPendingJobs+limitSizeForPendingJobs;
        if((counterForPendingJobs+limitSizeForPendingJobs) <= totalSizeForPendingJobs){
            for(Integer i=counterForPendingJobs;i<(counterForPendingJobs+limitSizeForPendingJobs);i++){
                pendingJobsToShow.add(pendingJobList.get(i));
            }
        } else{
            for(Integer i=counterForPendingJobs;i<totalSizeForPendingJobs;i++){
                pendingJobsToShow.add(pendingJobList.get(i));
            }
        }
    }
   
    public void previousForPendingJobs(){
        pendingJobsToShow.clear();
        counterForPendingJobs=counterForPendingJobs-limitSizeForPendingJobs;       
            for(Integer i=counterForPendingJobs;i<(counterForPendingJobs+limitSizeForPendingJobs); i++){
            pendingJobsToShow.add(pendingJobList.get(i));
        }
    }

    public void lastForPendingJobs (){
        pendingJobsToShow.clear();
        if(math.mod(totalSizeForPendingJobs , limitSizeForPendingJobs) == 0){
            counterForPendingJobs = limitSizeForPendingJobs * ((totalSizeForPendingJobs/limitSizeForPendingJobs)-1);
        } else if (math.mod(totalSizeForPendingJobs , limitSizeForPriorityJobs) != 0){
            counterForPendingJobs = limitSizeForPendingJobs * ((totalSizeForPendingJobs/limitSizeForPendingJobs));
        }
        for(Integer i=counterForPendingJobs-1;i<totalSizeForPendingJobs-1;i++){
                pendingJobsToShow.add(pendingJobList.get(i));
        }
      }
   
    public Boolean getDisableNextForPendingJobs(){
        if((counterForPendingJobs + limitSizeForPendingJobs) >= totalSizeForPendingJobs )
            return true ;
        else
            return false ;
    }
   
    public Boolean getDisablePreviousForPendingJobs(){
        if(counterForPendingJobs == 0)
            return true ;
        else
            return false ;
    } 
    //pagination for pending jobs ends here
    
    //pagination for dormant jobs starts here
   public void paginationMethodForDormantJobs(List<Amr_Job_Allocation__c> jobListToDisplay){
       dormantJobsToShow = new list<Amr_Job_Allocation__c>();
       totalSizeForDormantJobs = jobListToDisplay.size();
       if(limitSizeForDormantJobs < totalSizeForDormantJobs){
       showPageButtonForDormant = true;
       }else{
       showPageButtonForDormant = false;
       }
        //Intial adding
        //check the total records are more than limitSizeForPriorityJobs and assign the records
        if((counterForDormantJobs+limitSizeForDormantJobs) <= totalSizeForDormantJobs){
            for(Integer i=0;i<limitSizeForDormantJobs;i++){
                dormantJobsToShow.add(jobListToDisplay.get(i));
            }
        }else{
            for(Integer i=0;i<totalSizeForDormantJobs;i++){
                dormantJobsToShow.add(jobListToDisplay.get(i));
            }
        }
        
        if(!dormantJobsToShow.isEmpty()){
          List<Amr_Job_Allocation__c> lstPriorityNew = new List<Amr_Job_Allocation__c>();
            
          lstPriorityNew = dormantJobsToShow;
          dormantJobsToShow = new List<Amr_Job_Allocation__c>();
          removeduplicateDormant(lstPriorityNew);
        }
         
      }
        
    public void beginningForDormantJobs(){
        dormantJobsToShow.clear();
        counterForDormantJobs=0;
        if((counterForDormantJobs + limitSizeForDormantJobs) <= totalSizeForDormantJobs){
            for(Integer i=0;i<limitSizeForDormantJobs;i++){
                dormantJobsToShow.add(dormantJobList.get(i));
            }   
        }else{
            for(Integer i=0;i<totalSizeForDormantJobs;i++){
                dormantJobsToShow.add(dormantJobList.get(i));
            }       
        }
    }
   
    public void nextForDormantJobs(){
        dormantJobsToShow.clear();
        counterForDormantJobs = counterForDormantJobs+limitSizeForDormantJobs;
        if((counterForDormantJobs+limitSizeForDormantJobs) <= totalSizeForDormantJobs){
            for(Integer i=counterForDormantJobs;i<(counterForDormantJobs+limitSizeForDormantJobs);i++){
                dormantJobsToShow.add(dormantJobList.get(i));
            }
        } else{
            for(Integer i=counterForDormantJobs;i<totalSizeForDormantJobs;i++){
                dormantJobsToShow.add(dormantJobList.get(i));
            }
        }
    }
   
    public void previousForDormantJobs(){
        dormantJobsToShow.clear();
        counterForDormantJobs=counterForDormantJobs-limitSizeForDormantJobs;       
            for(Integer i=counterForDormantJobs;i<(counterForDormantJobs+limitSizeForDormantJobs); i++){
            dormantJobsToShow.add(dormantJobList.get(i));
        }
    }

    public void lastForDormantJobs (){
        dormantJobsToShow.clear();
        if(math.mod(totalSizeForDormantJobs , limitSizeForDormantJobs) == 0){
            counterForDormantJobs = limitSizeForDormantJobs * ((totalSizeForDormantJobs/limitSizeForDormantJobs)-1);
        } else if (math.mod(totalSizeForDormantJobs , limitSizeForPriorityJobs) != 0){
            counterForDormantJobs = limitSizeForDormantJobs * ((totalSizeForDormantJobs/limitSizeForDormantJobs));
        }
        for(Integer i=counterForDormantJobs-1;i<totalSizeForDormantJobs-1;i++){
                dormantJobsToShow.add(dormantJobList.get(i));
        }
      }
   
    public Boolean getDisableNextForDormantJobs(){
        if((counterForDormantJobs + limitSizeForDormantJobs) >= totalSizeForDormantJobs )
            return true ;
        else
            return false ;
    }
   
    public Boolean getDisablePreviousForDormantJobs(){
        if(counterForDormantJobs == 0)
            return true ;
        else
            return false ;
    } 
    //pagination for dormant jobs ends here
    
        //pagination for live jobs starts here
   public void paginationMethodForLiveJobs(List<Amr_Job_Allocation__c> jobListToDisplay){
       liveJobsToShow = new list<Amr_Job_Allocation__c>();
       totalSizeForLiveJobs = jobListToDisplay.size();
       if(limitSizeForLiveJobs < totalSizeForLiveJobs){
       showPageButtonForLive = true;
       }else{
       showPageButtonForLive = false;
       }
        //Intial adding
        //check the total records are more than limitSizeForPriorityJobs and assign the records
        if((counterForLiveJobs+limitSizeForLiveJobs) <= totalSizeForLiveJobs){
            for(Integer i=0;i<limitSizeForLiveJobs;i++){
                liveJobsToShow.add(jobListToDisplay.get(i));
            }
        }else{
            for(Integer i=0;i<totalSizeForLiveJobs;i++){
                liveJobsToShow.add(jobListToDisplay.get(i));
            }
        }
        
         if(!liveJobsToShow.isEmpty()){
          List<Amr_Job_Allocation__c> lstPriorityNew = new List<Amr_Job_Allocation__c>();
            
          lstPriorityNew = liveJobsToShow;
          liveJobsToShow = new List<Amr_Job_Allocation__c>();
          removeduplicateLive(lstPriorityNew);
        }
        
      }
        
    public void beginningForLiveJobs(){
        liveJobsToShow.clear();
        counterForLiveJobs=0;
        if((counterForLiveJobs + limitSizeForLiveJobs) <= totalSizeForLiveJobs){
            for(Integer i=0;i<limitSizeForLiveJobs;i++){
                liveJobsToShow.add(liveJobList.get(i));
            }   
        }else{
            for(Integer i=0;i<totalSizeForLiveJobs;i++){
                liveJobsToShow.add(liveJobList.get(i));
            }       
        }
    }
   
    public void nextForLiveJobs(){
        liveJobsToShow.clear();
        counterForLiveJobs = counterForLiveJobs+limitSizeForLiveJobs;
        if((counterForLiveJobs+limitSizeForLiveJobs) <= totalSizeForLiveJobs){
            for(Integer i=counterForLiveJobs;i<(counterForLiveJobs+limitSizeForLiveJobs);i++){
                liveJobsToShow.add(liveJobList.get(i));
            }
        } else{
            for(Integer i=counterForLiveJobs;i<totalSizeForLiveJobs;i++){
                liveJobsToShow.add(liveJobList.get(i));
            }
        }
    }
   
    public void previousForLiveJobs(){
        liveJobsToShow.clear();
        counterForLiveJobs=counterForLiveJobs-limitSizeForLiveJobs;       
            for(Integer i=counterForLiveJobs;i<(counterForLiveJobs+limitSizeForLiveJobs); i++){
                system.debug('i!!'+i);
            liveJobsToShow.add(liveJobList.get(i));
        }
    }

    public void lastForLiveJobs (){
        liveJobsToShow.clear();
        if(math.mod(totalSizeForLiveJobs , limitSizeForLiveJobs) == 0){
            counterForLiveJobs = limitSizeForLiveJobs * ((totalSizeForLiveJobs/limitSizeForLiveJobs)-1);
        } else if (math.mod(totalSizeForLiveJobs , limitSizeForLiveJobs) != 0){
            counterForLiveJobs = limitSizeForLiveJobs * ((totalSizeForLiveJobs/limitSizeForLiveJobs));
        }
        for(Integer i=counterForLiveJobs-1;i<totalSizeForLiveJobs-1;i++){
                liveJobsToShow.add(liveJobList.get(i));
        }
      }
   
    public Boolean getDisableNextForLiveJobs(){
        if((counterForLiveJobs + limitSizeForLiveJobs) >= totalSizeForLiveJobs )
            return true ;
        else
            return false ;
    }
   
    public Boolean getDisablePreviousForLiveJobs(){
        if(counterForLiveJobs == 0)
            return true ;
        else
            return false ;
    } 
    //pagination for live jobs ends here

 public PageReference jobSheetPageTransfer(){
      
       PageReference pageRef = new PageReference('/apex/AM_JobAllocations_bhupendra');
       pageRef.getParameters().put('id',chosenId);
       pageRef.setRedirect(true);
       return pageRef;
   }

    public void alertHide(){
        
        System.debug('Alert Id -> ' + selectedAlert);
        
        List<Amr_Alert__c> alertHideList = new List<Amr_Alert__c>();
        alertHideList = [SELECT Alert_Message__c,Hide__c FROM Amr_Alert__c where id = :selectedAlert];
       if(!alertHideList.isEmpty()){
        
        for(Amr_Alert__c alertObj : alertHideList){
            alertObj .Hide__c = TRUE;
        }
        update alertHideList;
       }
    }

}