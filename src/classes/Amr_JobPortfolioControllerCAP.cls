global with sharing class Amr_JobPortfolioControllerCAP{
    public list<Amr_Job_Allocation__c>jobDetailList {get;set;}
    public list<Amr_Job_Allocation__c>jobDetailCancellationList {get;set;}
    public Amr_Job_Allocation__c jobAllocation {get;set;}
    public Amr_Job_Details__c jobDetails {get;set;}
    public String startDate{get;set;}
    public String endDate{get;set;} 
    public String categoryName{get;set;}
    public String brandPos{get;set;}
    public String brandName{get;set;}
    String broadMarket;
    public String userName{get;set;}
   // public String projectName{get;set;}
    public String acceptedString;
    public String cancelledString;
    public String selectedSortJobsOption{get;set;}
    public String selectedSortCancelOption{get;set;}
    
    public List<SelectOption> listOfCategory{get;set;} 
    public List<SelectOption> listOfBrandPosition{get;set;}
    public  List<SelectOption> listOfBrand{get;set;}
    public  List<SelectOption> listOfSortOptions{get;set;}
    public  List<SelectOption> listOfUser {get;set;}
   // public  List<SelectOption> listOfProjectName {get;set;}
    public List<Amr_Project_Details__c> projNameList {get;set;}
    
    public List<wrapperClass> wrapperList {get;set;}
    public Id chosenId {get; set;}
    
    public List<Amr_Job_Allocation__c>activeJobsToShow{get;set;}
    public List<WrapperClass>cancelJobsToShow{get;set;}
    public Integer totalSizeForActiveJobs =0;
    public Integer limitSizeForActiveJobs=Integer.valueOf(System.Label.Amr_LimitValue);
    public Integer counterForActiveJobs=0;
    public Integer totalSizeForCancelJobs =0;
    public Integer limitSizeForCancelJobs=Integer.valueOf(System.Label.Amr_LimitValue);
    public Integer counterForCancelJobs=0;
    public Boolean showPageButtonForCancel {get;set;}
    public Boolean showPageButtonForActive {get;set;}
    public List<Amr_Alert__c> alertList{get;set;}
    public Amr_Alert__c hideAlertObj{get;set;}
    public List<Amr_Alert__c>unHideAlertList{get;set;}
    public boolean showUnhideRecords{get;set;}
    public boolean flagForButtons{get;set;}
    public Id loggedInUserId {get;set;}
    public String selectedAlert {get;set;}
    public Id chosenAlertId{get;set;}
    public Integer TotalJobs {get; set;}
    public Integer TotalPendingJobs {get; set;}
    public Integer TotalLiveJobs {get; set;}
    public Integer TotalPriorityJobs {get; set;}
    public Integer TotalDormantJobs  {get; set;}
    public Integer TotalSavingsJobs  {get; set;}
    public  String[]  listString{get;set;}
   
    public Amr_JobPortfolioControllerCAP(){
     jobAllocation =new Amr_Job_Allocation__c();
     jobDetails =new Amr_Job_Details__c();
     broadMarket='';
    alertList = new List<Amr_Alert__c>();
    hideAlertObj = new Amr_Alert__c();
    unHideAlertList = new List<Amr_Alert__c>();
    loggedInUserId = UserInfo.getUserId();
     projNameList= [Select Name from Amr_Project_Details__c ORDER BY Name ASC limit 10000];
     listString= new list<string>();
         listString.add('--None--');
        For(Amr_Project_Details__c i : projNameList){
                listString.add(i.name);
        }
        system.debug('listString!!'+listString);
        
     getAlertRecords();
    getJobSearchDetails();
     getTotalJobs();
    
    //cancellation
   
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
     
     public List<SelectOption> getUserList(){
     listOfUser = new List<SelectOption>();
     listOfUser.add(new selectOption('--None--','--None--'));
     List<PermissionSetAssignment> PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name ='RAP' order by Assignee.name];
    if(PermissionSetAssignmentList.size()>0){
 
     for(PermissionSetAssignment permissionObj:PermissionSetAssignmentList){
     	     	
             listOfUser.add(new selectOption(permissionObj.Assignee.id,permissionObj.Assignee.Name));
         } 
      }
    system.debug('listOfUser!!'+listOfUser);
         
         
         return listOfUser;
     
     }
        public String getMethodToPassProjectNames(){
        system.debug('serialize!!'+JSON.serialize(listString));
        return JSON.serialize(listString);
    }
    public void getTotalJobs() {
        TotalJobs = [SELECT count()  FROM  Amr_Job_Details__c ];
        
        system.debug('Value is !!'+TotalJobs); 
        
        
        TotalPendingJobs  = [SELECT count()  FROM  Amr_Job_Details__c where  Amr_Job_Details__c.Job_Status__c = :Label.Amr_Status_Priority ];
        TotalLiveJobs     = [SELECT count()  FROM  Amr_Job_Details__c where  Amr_Job_Details__c.Job_Status__c = :Label.Amr_Status_Live ];
        TotalPriorityJobs = [SELECT count()  FROM  Amr_Job_Details__c where  Amr_Job_Details__c.Job_Status__c = :Label.Amr_Status_Pending ];
        TotalDormantJobs  = [SELECT count()  FROM  Amr_Job_Details__c where  Amr_Job_Details__c.Job_Status__c = :Label.Amr_Status_Dormant ];
        TotalSavingsJobs  = [SELECT count() from Amr_Saving__c];
    }
    
    
     public void getAlertRecords(){
        alertList = [select Id,New_Alert__c,Alert_Message__c from Amr_Alert__c where ownerId =:loggedInUserId AND Hide__c =:false];
        system.debug('alertList !!'+alertList);
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
    
     
    public PageReference unHideAlertHide(){
    
       showUnhideRecords =false;
       flagForButtons = false;
       
                
        return null;
    }
    
    
    
    /*  public List<SelectOption> getProjectNameList(){      
         listOfProjectName = new List<SelectOption>();
         List<Amr_Project_Details__c> ProjectNameList= [Select id,Name from Amr_Project_Details__c limit 500];
         listOfProjectName .add(new selectOption('--None--','--None--'));
         for(Amr_Project_Details__c cat : ProjectNameList)
             listOfProjectName.add(new selectOption(cat.Id,cat.Name));
         return listOfProjectName ;
     }*/
     
     //Method to get list in sort options
    public List<SelectOption> getSortOptions(){  
         
         listOfSortOptions = new List<SelectOption>();
          listOfSortOptions.add(new selectOption('--None--','--None--'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.AdManagerText__c','ADManager Number'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.CreatedDate','Date Logged'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Stage_of_Production_Activity__c','Stage Of production Activity'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Unilever_Project_Leader_Email__c','Project Leader Email'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Project_Leader_Country__c','Location of Unilever Project Leader (Country)'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Category__c','Category'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Brand__c','Brand Name'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Project_Details__c','Project Name'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Lead_Creative_Agency_name__c','Lead/Creative Agency Name'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Allocated_Budget_euro__c','Allocated Budget (Euro)'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Brodcast_Market__c','Broadcast market'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Production_Activity_Type__c','Production Activity Type'));
         listOfSortOptions.add(new selectOption('User__c','RAP Allocated'));
         listOfSortOptions.add(new selectOption('Job_Allocated__c','Allocated'));
         listOfSortOptions.add(new selectOption('Job_Status__c','Accepted'));
         listOfSortOptions.add(new selectOption('Started__c','Started'));
         listOfSortOptions.add(new selectOption('Reported__c','Reported'));
         listOfSortOptions.add(new selectOption('Job_Shared__c','Shared'));
         return listOfSortOptions;
     }
    
    public Pagereference getJobSearchDetails(){
    // system.debug('startDate!!'+jobDetails.Start_Date__c+'endDate!!'+endDate);
     
    
      
    //job list
    jobDetailList = new list<Amr_Job_Allocation__c>();
    acceptedString='Accepted';
    cancelledString='Cancelled';
    string soql = 'select Started__c,Started_Image__c,Reported__c,Job_Shared__c,Job_Status__c,Job_Allocated_Image__c,Reported_Image__c ,Job_Allocated__c,Job_Status_Image__c,User__c,AM_Job_Detail__r.Project_Details__c,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Job_Status__c ,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.Category__r.Name,AM_Job_Detail__r.Brand_Positioning__r.Name,AM_Job_Detail__r.Brand__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,id from Amr_Job_Allocation__c where Job_Status__c != '+'\'Cancelled\' AND AM_Job_Detail__r.Job_Cancelled__c = false ';
    system.debug('soql !!'+soql);
    //cancellation
     jobDetailCancellationList = new list<Amr_Job_Allocation__c>();
    string soqlForCancel = 'select Started__c,Started_Image__c,Reported__c,Job_Shared__c,Job_Status__c,Job_Allocated_Image__c,Reported_Image__c ,Job_Allocated__c,Job_Status_Image__c,User__c,AM_Job_Detail__r.Project_Details__c,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Job_Status__c ,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.Category__r.Name,AM_Job_Detail__r.Brand_Positioning__r.Name,AM_Job_Detail__r.Brand__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,id from Amr_Job_Allocation__c where Job_Status__c= '+'\'Cancelled\'AND AM_Job_Detail__r.Job_Cancelled__c = true ';
    system.debug('soqlForCancel !!'+soqlForCancel );
    
    //search
  /*  if (String.isNotBlank(startDate)){
   //start date creation
   system.debug('inside start date');
   String[] startDateSplitQuote = startDate.split(' ');
   String[] startDateSplitSlash = startDateSplitQuote[0].split('/');
   Integer myIntDate = integer.valueOf(startDateSplitSlash[1]);
   Integer myIntMonth = integer.valueOf(startDateSplitSlash[0]);
   Integer myIntYear = integer.valueOf(startDateSplitSlash[2]);
   Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
   DateTime startDateFinal = DateTime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0);
     
           soql += ' and AM_Job_Detail__r.createdDate'+  ' >= '+ startDateFinal.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') ;
           soqlForCancel += ' and AM_Job_Detail__r.createdDate'+  ' >= '+ startDateFinal.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') ;
           
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
     
           soql += ' and AM_Job_Detail__r.createdDate ' +  ' < '+ endDateDateFinal.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
           soqlForCancel +=' and AM_Job_Detail__r.createdDate ' +  ' < '+ endDateDateFinal.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
           system.debug('soql01'+soql);
    }*/
    
    if (String.isNotBlank(String.valueOf(jobDetails.Start_Date__c))){
        Datetime startdate = jobDetails.Start_Date__c;
        String dateTimeFormat = startdate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
        soql += ' and AM_Job_Detail__r.createdDate ' +  ' >= '+  dateTimeFormat ;
        soqlForCancel +=' and AM_Job_Detail__r.createdDate ' +  ' >= '+ dateTimeFormat;
           system.debug('soql0'+soql);
    }
    
    if (String.isNotBlank(String.valueOf(jobDetails.End_Date__c))){ 
        Datetime endate  = jobDetails.End_Date__c;
         String dateTimeFormat1 = endate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
         soql += ' and AM_Job_Detail__r.createdDate ' +  ' < '+  dateTimeFormat1 ;
         soqlForCancel +=' and AM_Job_Detail__r.createdDate ' +  ' < '+ dateTimeFormat1;
           system.debug('soql0'+soql);
    }
    
      if(String.isNotBlank(categoryName) && categoryName != '--None--'){
      
    soql += ' and AM_Job_Detail__r.Category__r.Id = \''+String.escapeSingleQuotes(categoryName)+'\'';
    soqlForCancel += ' and AM_Job_Detail__r.Category__r.Id = \''+String.escapeSingleQuotes(categoryName)+'\'';
           system.debug('soql4'+soql);
     }
      if(String.isNotBlank(brandPos) && brandPos != '--None--'){
      
    soql += ' and AM_Job_Detail__r.Brand_Positioning__r.Id = \''+String.escapeSingleQuotes(brandPos)+'\'';
    soqlForCancel +=' and AM_Job_Detail__r.Brand_Positioning__r.Id = \''+String.escapeSingleQuotes(brandPos)+'\'';
           system.debug('soql5'+soql);
     }
      if(String.isNotBlank(brandName) && brandName != '--None--'){
    soql += ' and AM_Job_Detail__r.Brand__r.Id = \''+String.escapeSingleQuotes(brandName)+'\'';
    soqlForCancel += ' and AM_Job_Detail__r.Brand__r.Id = \''+String.escapeSingleQuotes(brandName)+'\'';
           system.debug('soql6'+soql);
     }
     
     if (String.isNotBlank(jobDetails.Project_Leader_Cluster__c)){
     
           soql += ' and AM_Job_Detail__r.Project_Leader_Cluster__c = \''+String.escapeSingleQuotes(jobDetails.Project_Leader_Cluster__c)+'\'';
            soqlForCancel +=' and AM_Job_Detail__r.Project_Leader_Cluster__c = \''+String.escapeSingleQuotes(jobDetails.Project_Leader_Cluster__c)+'\'';
           system.debug('soql1'+soql);
    }
    
     if(String.isNotBlank(jobDetails.Project_Leader_Country__c)){
    soql += ' and AM_Job_Detail__r.Project_Leader_Country__c = \''+String.escapeSingleQuotes(jobDetails.Project_Leader_Country__c)+'\'';
     soqlForCancel +=' and AM_Job_Detail__r.Project_Leader_Country__c = \''+String.escapeSingleQuotes(jobDetails.Project_Leader_Country__c)+'\'';
           system.debug('soql2'+soql);
           system.debug('soqlForCancel !!!!!!'+soqlForCancel );
           
    }
   
     if(String.isNotBlank(jobDetails.Lead_Creative_Agency_name__c)){
    soql += ' and AM_Job_Detail__r.Lead_Creative_Agency_name__c = \''+String.escapeSingleQuotes(jobDetails.Lead_Creative_Agency_name__c)+'\'';
    soqlForCancel +=' and AM_Job_Detail__r.Lead_Creative_Agency_name__c = \''+String.escapeSingleQuotes(jobDetails.Lead_Creative_Agency_name__c)+'\'';
           system.debug('soql3'+soql);
     
     }
      if(String.isNotBlank(jobDetails.Brodcast_Market__c)){
    soql += ' and AM_Job_Detail__r.Brodcast_Market__c LIKE \''+String.escapeSingleQuotes(jobDetails.Brodcast_Market__c)+'%\'';
    soqlForCancel += ' and AM_Job_Detail__r.Brodcast_Market__c LIKE \''+String.escapeSingleQuotes(jobDetails.Brodcast_Market__c)+'%\'';
           system.debug('soql3'+soql);
     }
    if(String.isNotBlank(jobDetails.Stage_of_Production_Activity__c)){
    soql += ' and AM_Job_Detail__r.Stage_of_Production_Activity__c = \''+String.escapeSingleQuotes(jobDetails.Stage_of_Production_Activity__c)+'\'';
    soqlForCancel +=  ' and AM_Job_Detail__r.Stage_of_Production_Activity__c = \''+String.escapeSingleQuotes(jobDetails.Stage_of_Production_Activity__c)+'\'';
           system.debug('soql7'+soql);
     }
   
    if(String.isNotBlank(jobDetails.AdManagerText__c)){
    soql += ' and AM_Job_Detail__r.AdManagerText__c LIKE \''+String.escapeSingleQuotes(jobDetails.AdManagerText__c)+'%\'';
    soqlForCancel += ' and AM_Job_Detail__r.AdManagerText__c LIKE \''+String.escapeSingleQuotes(jobDetails.AdManagerText__c)+'%\'';
           system.debug('soql12'+soql);
     }
     if(String.isNotBlank(jobDetails.Unilever_Project_Leader_Email__c)){
    soql += ' and AM_Job_Detail__r.Unilever_Project_Leader_Email__c LIKE \''+String.escapeSingleQuotes(jobDetails.Unilever_Project_Leader_Email__c)+'%\'';
    soqlForCancel += ' and AM_Job_Detail__r.Unilever_Project_Leader_Email__c LIKE \''+String.escapeSingleQuotes(jobDetails.Unilever_Project_Leader_Email__c)+'%\'';
           system.debug('soql13'+soql);
     }
     if(String.isNotBlank(jobDetails.Project_Details__c)){
    soql += ' and AM_Job_Detail__r.Project_Details__c = \''+String.escapeSingleQuotes(jobDetails.Project_Details__c)+'\'';
    soqlForCancel +=' and AM_Job_Detail__r.Project_Details__c = \''+String.escapeSingleQuotes(jobDetails.Project_Details__c)+'\'';
           system.debug('soql14'+soql);
     }
     
      if(String.isNotBlank(userName) && userName != '--None--'){
     soql += ' and User__c = \''+String.escapeSingleQuotes(userName)+'\'';
     soqlForCancel +=' and User__c = \''+String.escapeSingleQuotes(userName)+'\'';
           system.debug('soql14'+soql);
     }
     
      if(String.isNotBlank(jobAllocation.Job_Allocated__c)){
     soql += ' and Job_Allocated__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Allocated__c)+'\'';
     soqlForCancel +=' and Job_Allocated__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Allocated__c)+'\'';
           system.debug('soql14'+soql);
     }
       if(String.isNotBlank(jobAllocation.Job_Shared__c)){
     soql += ' and Job_Shared__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Shared__c)+'\'';
     soqlForCancel +=' and Job_Shared__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Shared__c)+'\'';
           system.debug('soql14'+soql);
     }
     if(String.isNotBlank(jobAllocation.Reported__c)){
     soql += ' and Reported__c = \''+String.escapeSingleQuotes(jobAllocation.Reported__c)+'\'';
     soqlForCancel +=' and Reported__c = \''+String.escapeSingleQuotes(jobAllocation.Reported__c)+'\'';
           system.debug('soql14'+soql);
     }
      if(String.isNotBlank(jobAllocation.Started__c)){
     soql += ' and Started__c = \''+String.escapeSingleQuotes(jobAllocation.Started__c)+'\'';
     soqlForCancel +=' and Started__c = \''+String.escapeSingleQuotes(jobAllocation.Started__c)+'\'';
           system.debug('soql14'+soql);
     }
       if(String.isNotBlank(jobAllocation.Job_Status__c)){
     soql += ' and Job_Status__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Status__c)+'\'';
     soqlForCancel +=' and Job_Status__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Status__c)+'\'';
           system.debug('soql14'+soql);
     }
     
     if(String.isNotBlank(selectedSortJobsOption) && selectedSortJobsOption!='--None--'){
          soql += ' ORDER BY '+String.escapeSingleQuotes(selectedSortJobsOption)+' ASC';
           
     }
     if(String.isNotBlank(selectedSortCancelOption) && selectedSortCancelOption!='--None--'){
          soqlForCancel += ' ORDER BY '+String.escapeSingleQuotes(selectedSortCancelOption)+' ASC';
           
     }
     
     system.debug('soql !!'+soql );
     
    //jobDetailList = Database.query(soql);
    system.debug('jobDetailList !!'+jobDetailList );
    Set<String> setJobAllocationId = new Set<String>();
     
    for(Amr_Job_Allocation__c sObj: Database.query(soql) ){
     	     if(!setJobAllocationId.contains(sObj.id+''+sObj.User__c)){
     	     	system.debug('sObj.idsObj.User__c!'+sObj.id+''+sObj.User__c );
     		 	setJobAllocationId.add(sObj.id+''+sObj.User__c);
             	jobDetailList.add(sObj ) ;
     	     }
     }
    
    //cancellation
    jobDetailCancellationList = Database.query(soqlForCancel);
    system.debug('jobDetailCancellationList !!'+jobDetailCancellationList );
    
    paginationMethodForActiveJobs(jobDetailList);
   
    
     wrapperList = new List<wrapperClass>();
     Set<String> setJobAllocation = new Set<String>();
     
     
     for(Amr_Job_Allocation__c sObj: jobDetailCancellationList ){
     	     if(!setJobAllocation.contains(sObj.id+''+sObj.User__c)){
     		 	setJobAllocation.add(sObj.id+''+sObj.User__c);
             	WrapperList.add( new wrapperClass(false,sObj)) ;
     	     }
     }
      
     //sortBySelected();     //return WrapperList;
    paginationMethodForCancelJobs(WrapperList);
    return null;
    
    
    }
    
    
  // Wrapper class include Sobject and select box
     global Class wrapperClass{
     
         Amr_JobPortfolioControllerCAP objCap;
         Public Boolean SelectBox{get;set;}
         Public Amr_Job_Allocation__c sObjRec{get;set;}
        // Public Amr_Job_Details__c sObjRec{get;set;}
        
          
         Public wrapperClass(){
         }
         
         Public wrapperClass(Boolean checkbx, Amr_Job_Allocation__c sObjRecord){
            SelectBox = checkbx;
            sObjRec = sObjRecord;
         }
         
       /*  
           // Implement the compareTo() method
        public Integer compareTo(Object compareTo) {
            WrapperClass compareToEmp = (WrapperClass)compareTo;
            if(Amr_JobPortfolioControllerCAP.selectedSortJobsOption == 'Amr_Job_Details__r.AdManagerText__c'){
            if (sObjRec.Amr_Job_Details__r.AdManagerText__c == compareToEmp.sObjRec.Amr_Job_Details__r.AdManagerText__c) return 0;
            if (sObjRec.Amr_Job_Details__r.AdManagerText__c > compareToEmp.sObjRec.Amr_Job_Details__r.AdManagerText__c) return 1;
            return -1;      
           }  
           return 100;
        }*/
       }
       
    /*   public void sortBySelected(){
       
       
       List<WrapperClass> tempLst = new List<WrapperClass>();
       tempLst.addAll(WrapperList);
       WrapperList.clear();
       for(WrapperClass wrapper : tempLst){
            WrapperClass finalSelected = new WrapperClass();
            for(WrapperClass wrap2 : tempLst){
                Amr_Job_Allocation__c amrJob = new Amr_Job_Allocation__c();
                Amr_Job_Allocation__c amrJob2 = new Amr_Job_Allocation__c();
                amrJob = wrapper.sObjRec;
                amrJob2 = wrapper.sObjRec;
                system.debug('---selectedSortCancelOption-----'+selectedSortCancelOption);
                system.debug('---amrJob.AM_Job_Detail__r.AdManagerText__c-----'+amrJob.AM_Job_Detail__r.AdManagerText__c    );
                if(selectedSortCancelOption == 'AM_Job_Detail__r.AdManagerText__c'){
                    if(amrJob.AM_Job_Detail__r.AdManagerText__c.compareTo(amrJob2.AM_Job_Detail__r.AdManagerText__c) < 0){
                        finalSelected = wrapper;
                        system.debug('*****wrapper'+wrapper);
                        
                    }
                    else{
                        finalSelected = wrap2;
                        system.debug('*****wrap2'+wrap2);
                    }
                }
            }
            WrapperList.add(finalSelected);
            system.debug('*****WrapperList'+WrapperList);
       }
   }
    */
           // To call Cancel button on VF Page
       Public PageReference changwrapperClasseStatus(){
          List<Amr_Job_Allocation__c> selectList = New List<Amr_Job_Allocation__c>();
          List<Amr_Job_Details__c> selectJobDetailList = New List<Amr_Job_Details__c>();
          for(wrapperclass wc:WrapperList){
              if(wc.SelectBox  == true)
                 selectList.add(wc.sObjRec); 
          }
          if(selectList.size()>0){
            for(Amr_Job_Allocation__c obj : selectList ){
                selectJobDetailList.add(obj.AM_Job_Detail__r);
                
            }
            
            
           List<Amr_Job_Allocation__c> jobdetails1=[select id ,Name,AM_Job_Detail__r.id,Job_Status__c,AM_Job_Detail__c from Amr_Job_Allocation__c where Id IN:selectList];
           List<Amr_Job_Allocation__c> jobdList=new List<Amr_Job_Allocation__c>();
           List<Amr_Job_Details__c> jobDetailsList=new List<Amr_Job_Details__c>();
           
           for(Amr_Job_Allocation__c jd:jobdetails1){
           	   Id objId = jd.AM_Job_Detail__r.id;
           	   Amr_Job_Details__c objJobDetails = new Amr_Job_Details__c(ID= objId);//Job_Cancelled__c
           	   objJobDetails.Job_Cancelled__c = false;
           	   jobDetailsList.add(objJobDetails);
               jd.Job_Status__c='Accepted';
               jobdList.add(jd);
           }
          
           update jobdList;
           update jobDetailsList;
           
           PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
          
           pageRef.setRedirect(true);
           return pageRef;
             
          }
          
          else{
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select any value'));
                return null;
          } 
     }
    //////
      //pagination for active jobs starts here
   public void paginationMethodForActiveJobs(List<Amr_Job_Allocation__c> jobListToDisplay){
       activeJobsToShow = new list<Amr_Job_Allocation__c>();
       totalSizeForActiveJobs = jobListToDisplay.size();
       if(limitSizeForActiveJobs < totalSizeForActiveJobs ){
       showPageButtonForActive = true;
       }else{
       showPageButtonForActive = false;
       }
        //Intial adding
        //check the total records are more than limitSizeForPriorityJobs and assign the records
        if((counterForActiveJobs+limitSizeForActiveJobs) <= totalSizeForActiveJobs ){
            for(Integer i=0;i<limitSizeForActiveJobs;i++){
                activeJobsToShow.add(jobListToDisplay.get(i));
            }
        }else{
            for(Integer i=0;i<totalSizeForActiveJobs ;i++){
                activeJobsToShow.add(jobListToDisplay.get(i));
            }
        }
        system.debug('activeJobsToShow!!'+activeJobsToShow);
      }
        
    public void beginningForActiveJobs(){
        activeJobsToShow.clear();
        counterForActiveJobs=0;
        if((counterForActiveJobs + limitSizeForActiveJobs) <= totalSizeForActiveJobs ){
            for(Integer i=0;i<limitSizeForActiveJobs;i++){
                activeJobsToShow.add(jobDetailList.get(i));
            }   
        }else{
            for(Integer i=0;i<totalSizeForActiveJobs ;i++){
                activeJobsToShow.add(jobDetailList.get(i));
            }       
        }
    }
   
    public void nextForActiveJobs(){
        activeJobsToShow.clear();
        counterForActiveJobs=counterForActiveJobs+limitSizeForActiveJobs;
        system.debug('limitSizeForActiveJobs-----'+limitSizeForActiveJobs);
        system.debug('totalSizeForActiveJobs-----'+totalSizeForActiveJobs);
        system.debug('counterForActiveJobs-----'+counterForActiveJobs);
        
        if((counterForActiveJobs+limitSizeForActiveJobs) <= totalSizeForActiveJobs ){
            for(Integer i=counterForActiveJobs;i<(counterForActiveJobs+limitSizeForActiveJobs);i++){
                activeJobsToShow.add(jobDetailList.get(i));
            }
        } else{
            for(Integer i=counterForActiveJobs;i<totalSizeForActiveJobs ;i++){
                activeJobsToShow.add(jobDetailList.get(i));
            }
        }
         system.debug('activeJobsToShow-----'+activeJobsToShow);
    }
   
    public void previousForActiveJobs(){
        activeJobsToShow.clear();
        counterForActiveJobs=counterForActiveJobs-limitSizeForActiveJobs;       
            for(Integer i=counterForActiveJobs;i<(counterForActiveJobs+limitSizeForActiveJobs); i++){
            activeJobsToShow.add(jobDetailList.get(i));
        }
    }

    public void lastForActiveJobs (){
        activeJobsToShow.clear();
        if(math.mod(totalSizeForActiveJobs , limitSizeForActiveJobs) == 0){
            counterForActiveJobs = limitSizeForActiveJobs* ((totalSizeForActiveJobs /limitSizeForActiveJobs)-1);
        } else if (math.mod(totalSizeForActiveJobs , limitSizeForActiveJobs) != 0){
            counterForActiveJobs = limitSizeForActiveJobs* ((totalSizeForActiveJobs /limitSizeForActiveJobs));
        }
        for(Integer i=counterForActiveJobs -1;i<totalSizeForActiveJobs -1;i++){
                activeJobsToShow.add(jobDetailList.get(i));
        }
      }
   
    public Boolean getDisableNextForActiveJobs(){
        if((counterForActiveJobs + limitSizeForActiveJobs) >= totalSizeForActiveJobs )
            return true ;
        else
            return false ;
    }
   
    public Boolean getDisablePreviousForActiveJobs(){
        if(counterForActiveJobs  == 0)
            return true ;
        else
            return false ;
    } 
    //pagination for Active jobs ends here
    
      //pagination for active jobs starts here
   public void paginationMethodForCancelJobs(List<WrapperClass> jobListToDisplay){
       cancelJobsToShow = new list<WrapperClass>();
       totalSizeForCancelJobs = jobListToDisplay.size();
       if(limitSizeForCancelJobs< totalSizeForCancelJobs ){
       showPageButtonForCancel = true;
       }else{
       showPageButtonForCancel = false;
       }
        //Intial adding
        //check the total records are more than limitSizeForPriorityJobs and assign the records
        if((counterForCancelJobs +limitSizeForCancelJobs) <= totalSizeForCancelJobs ){
            for(Integer i=0;i<limitSizeForCancelJobs;i++){
                cancelJobsToShow.add(jobListToDisplay.get(i));
            }
        }else{
            for(Integer i=0;i<totalSizeForCancelJobs;i++){
                cancelJobsToShow.add(jobListToDisplay.get(i));
            }
           
        }
         system.debug('cancelJobsToShow!!'+cancelJobsToShow);
      }
        
    public void beginningForCancelJobs(){
        cancelJobsToShow.clear();
        counterForCancelJobs =0;
        if((counterForCancelJobs + limitSizeForCancelJobs) <= totalSizeForCancelJobs ){
            for(Integer i=0;i<limitSizeForCancelJobs;i++){
                cancelJobsToShow.add(WrapperList.get(i));
            }   
        }else{
            for(Integer i=0;i<totalSizeForCancelJobs;i++){
                cancelJobsToShow.add(WrapperList.get(i));
            }       
        }
    }
   
    public void nextForCancelJobs(){
        cancelJobsToShow.clear();
        counterForCancelJobs =counterForCancelJobs +limitSizeForCancelJobs;
        if((counterForCancelJobs +limitSizeForCancelJobs) <= totalSizeForCancelJobs ){
            for(Integer i=counterForCancelJobs;i<(counterForCancelJobs +limitSizeForCancelJobs);i++){
                cancelJobsToShow.add(WrapperList.get(i));
            }
        } else{
            for(Integer i=counterForCancelJobs ;i<totalSizeForCancelJobs ;i++){
                cancelJobsToShow.add(WrapperList.get(i));
            }
        }
    }
   
    public void previousForCancelJobs(){
        cancelJobsToShow.clear();
        counterForCancelJobs  =counterForCancelJobs -limitSizeForCancelJobs;       
            for(Integer i=counterForCancelJobs;i<(counterForCancelJobs +limitSizeForCancelJobs); i++){
            cancelJobsToShow.add(WrapperList.get(i));
        }
    }

    public void lastForCancelJobs (){
        cancelJobsToShow.clear();
        if(math.mod(totalSizeForCancelJobs , limitSizeForCancelJobs) == 0){
            counterForCancelJobs = limitSizeForCancelJobs* ((totalSizeForCancelJobs /limitSizeForCancelJobs)-1);
        } else if (math.mod(totalSizeForCancelJobs , limitSizeForCancelJobs) != 0){
            counterForCancelJobs = limitSizeForCancelJobs* ((totalSizeForCancelJobs /limitSizeForCancelJobs));
        }
        for(Integer i=counterForCancelJobs -1;i<totalSizeForCancelJobs -1;i++){
                cancelJobsToShow.add(WrapperList.get(i));
        }
      }
   
    public Boolean getDisableNextForCancelJobs(){
        if((counterForCancelJobs + limitSizeForCancelJobs) >= totalSizeForCancelJobs )
            return true ;
        else
            return false ;
    }
   
    public Boolean getDisablePreviousForCancelJobs(){
        if(counterForCancelJobs == 0)
            return true ;
        else
            return false ;
    } 
    //pagination for Cancel jobs ends here
    
    
    
    //////
    
    public PageReference jobSheetPageTransfer(){
      
       PageReference pageRef = new PageReference('/apex/AM_JobAllocations_bhupendra');
       pageRef.getParameters().put('id',chosenId);
       pageRef.setRedirect(true);
       return pageRef;
   }
   
   public PageReference jobAllocationPageTransfer(){
      
       PageReference pageRef = new PageReference('/apex/AM_JobAllocations_bhupendra');
       pageRef.getParameters().put('id',chosenId);
       pageRef.setRedirect(true);
       return pageRef;
   }
   
   
 
   
   
   
}