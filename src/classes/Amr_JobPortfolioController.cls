public class Amr_JobPortfolioController{

public Amr_Job_Details__c jobDetails {get;set;}
public list<Amr_Job_Details__c> jobDetailList{get;set;} 
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
public String projName{get;set;}
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
    public Integer limitSizeForPriorityJobs = 5;//Number of records to be displayed
    public Integer totalSizeForPriorityJobs =0; //To Store the total number of records available
    public Integer counterForPendingJobs = 0;
    public Integer limitSizeForPendingJobs = 5;
    public Integer totalSizeForPendingJobs =0;
    public Integer counterForDormantJobs = 0;
    public Integer limitSizeForDormantJobs = 5;
    public Integer totalSizeForDormantJobs =0;
    public Integer counterForLiveJobs = 0;
    public Integer limitSizeForLiveJobs = 5;
    public Integer totalSizeForLiveJobs =0;
    
    public list<Amr_Job_Details__c>priorityJobsToShow{get;set;}
    public list<Amr_Job_Details__c>pendingJobsToShow{get;set;}
    public list<Amr_Job_Details__c>dormantJobsToShow{get;set;}
    public list<Amr_Job_Details__c>liveJobsToShow{get;set;}
    
    public list<Amr_Job_Details__c>priorityJobList{get;set;}
    public list<Amr_Job_Details__c>pendingJobList{get;set;}
    public list<Amr_Job_Details__c>dormantJobList{get;set;}
    public list<Amr_Job_Details__c>liveJobList{get;set;}

    public List<SelectOption> listOfCategory{get;set;} 
    public List<SelectOption> listOfBrandPosition{get;set;}
    public  List<SelectOption> listOfBrand{get;set;}
     public  List<SelectOption> listOfSortOptions{get;set;}
    
    public List<Amr_Alert__c> alertList{get;set;}
    public String jobIdFromPage{get;set;}
    public Id chosenAlertId{get;set;}
    public Amr_Alert__c hideAlertObj{get;set;}
    public List<Amr_Alert__c>unHideAlertList{get;set;}
    public boolean showUnhideRecords{get;set;}
    public boolean flagForButtons{get;set;}
    public Id loggedInUserId {get;set;}
    public String selectedSortPriorityOption{get;set;}
    public String selectedSortPendingOption{get;set;}
    public String selectedSortDormantOption{get;set;}
    public String selectedSortliveOption{get;set;}

public Amr_JobPortfolioController(){
    
    loggedInUserId = UserInfo.getUserId();
    jobDetails  = new Amr_Job_Details__c();
   // startDate= '';
    alertList = new List<Amr_Alert__c>();
    hideAlertObj = new Amr_Alert__c();
    unHideAlertList = new List<Amr_Alert__c>();
    jobIdFromPage = ApexPages.currentPage().getParameters().get('id');
    getJobDetailSearch();
    getAlertRecords();
    showUnhideRecords = false;
    flagForButtons = false;
   // selectedSortPriorityOption ='AdManagerText__c';
    system.debug('loggedInUserId !!'+loggedInUserId);
   
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
     
     //Method to get list in sort options
    public List<SelectOption> getSortOptions(){  
         
         listOfSortOptions = new List<SelectOption>();
          listOfSortOptions.add(new selectOption('--None--','--None--'));
         listOfSortOptions.add(new selectOption('AdManagerText__c','ADManager Number'));
         listOfSortOptions.add(new selectOption('CreatedDate','Date Logged'));
         listOfSortOptions.add(new selectOption('Stage_of_Production_Activity__c','Stage Of production Activity'));
         listOfSortOptions.add(new selectOption('Unilever_Project_Leader_Email__c','Project Leader Email'));
         listOfSortOptions.add(new selectOption('Project_Leader_Country__c','Location of Unilever Project Leader (Country)'));
         listOfSortOptions.add(new selectOption('AMCategory__c','Category'));
         listOfSortOptions.add(new selectOption('Am_Brand__c','Brand Name'));
         listOfSortOptions.add(new selectOption('Project_Name__c','Project Name'));
         listOfSortOptions.add(new selectOption('Lead_Creative_Agency_name__c','Lead/Creative Agency Name'));
         listOfSortOptions.add(new selectOption('Allocated_Budget_euro__c','Allocated Budget (Euro)'));
         listOfSortOptions.add(new selectOption('Broadcast_Market__c','Broadcast market'));
         listOfSortOptions.add(new selectOption('Production_Activity__c','Production Activity Type'));
         listOfSortOptions.add(new selectOption('Job_Shared__c','Job Shared'));
         listOfSortOptions.add(new selectOption('Job_Accepted__c','Accepted And Email Sent'));
         listOfSortOptions.add(new selectOption('Job_Started__c','Started'));
         listOfSortOptions.add(new selectOption('Job_Reported__c','Reported'));
         return listOfSortOptions;
     }

public PageReference getJobDetailSearch() {
   
     
   // brodMarket = jobDetails.Broadcast_Market__c;
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
    projName = jobDetails.Project_Name__c;
    
    jobDetailList = new list<Amr_Job_Details__c>();
    system.debug('projLeaderCluster!!!'+projLeaderCluster+'!!projLeaderCountry!!'+projLeaderCountry+'!!agencyName!!'+agencyName+'!!testing !!'+testing );
    system.debug('category!!'+categoryName+'!!brandPos!!!'+brandPos+'!!brandName!!'+brandName);
    system.debug('start date!!'+startDate+'!!end date!!'+endDate +'!!jobDetails!!'+jobDetails);
         
    string soql = 'select Project_Name__c,Production_Activity__c,Allocated_Budget_euro__c,Broadcast_Market__c,Job_Status__c ,createdDate,AdManagerText__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Lead_Creative_Agency_name__c,Category__r.Name,Brand_Positioning__r.Name,Brand__r.Name,Stage_of_Production_Activity__c,Job_Accepted__c,Job_Started__c,Job_Reported__c,Job_Shared__c,id from Amr_Job_Details__c where Name !=null ';
    
    if(String.isNotBlank(loggedInUserId)){
    
    soql += ' and OwnerId = \''+loggedInUserId+'\'';
           system.debug('soql loggedInUserId'+soql);
    }
    
    if (String.isNotBlank(startDate)){
   //start date creation
   String[] startDateSplitQuote = startDate.split(' ');
   String[] startDateSplitSlash = startDateSplitQuote[0].split('/');
   Integer myIntDate = integer.valueOf(startDateSplitSlash[1]);
   Integer myIntMonth = integer.valueOf(startDateSplitSlash[0]);
   Integer myIntYear = integer.valueOf(startDateSplitSlash[2]);
   Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
   DateTime startDateFinal = DateTime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0);
     
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
    
     if (String.isNotBlank(jobDetails.Project_Leader_Cluster__c)){
     
           soql += ' and Project_Leader_Cluster__c = \''+String.escapeSingleQuotes(projLeaderCluster)+'\'';
           system.debug('soql1'+soql);
    }
    
     if(String.isNotBlank(projLeaderCountry)){
    soql += ' and Project_Leader_Country__c = \''+String.escapeSingleQuotes(projLeaderCountry)+'\'';
           system.debug('soql2'+soql);
    }
    
     if(String.isNotBlank(agencyName)){
    soql += ' and Lead_Creative_Agency_name__c = \''+String.escapeSingleQuotes(agencyName)+'\'';
           system.debug('soql3'+soql);
     
     }
      if(String.isNotBlank(brodMarket)){
    soql += ' and Broadcast_Market__c LIKE \''+String.escapeSingleQuotes(brodMarket)+'%\'';
           system.debug('soql3'+soql);
     }
      if(String.isNotBlank(categoryName) && categoryName != '--None--'){
      
    soql += ' and Category__r.Id = \''+String.escapeSingleQuotes(categoryName)+'\'';
           system.debug('soql4'+soql);
     }
      if(String.isNotBlank(brandPos) && brandPos != '--None--'){
      
    soql += ' and Brand_Positioning__r.Id = \''+String.escapeSingleQuotes(brandPos)+'\'';
           system.debug('soql5'+soql);
     }
      if(String.isNotBlank(brandName) && brandName != '--None--'){
    soql += ' and Brand__r.Id = \''+String.escapeSingleQuotes(brandName)+'\'';
           system.debug('soql6'+soql);
     }
     if(String.isNotBlank(stageLogged)){
    soql += ' and Stage_of_Production_Activity__c = \''+String.escapeSingleQuotes(stageLogged)+'\'';
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
    soql += ' and AdManagerText__c LIKE \''+String.escapeSingleQuotes(addNumber)+'%\'';
           system.debug('soql12'+soql);
     }
     if(String.isNotBlank(projEmail)){
    soql += ' and Unilever_Project_Leader_Email__c LIKE \''+String.escapeSingleQuotes(projEmail)+'%\'';
           system.debug('soql13'+soql);
     }
     if(String.isNotBlank(projName)){
    soql += ' and Project_Name__c = \''+String.escapeSingleQuotes(projName)+'\'';
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
       priorityJobList = new List<Amr_Job_Details__c>();
       Set<Id>priorityJobIds = new Set<Id>();
       for(Amr_Job_Details__c jobId:jobDetailList){
           if(jobId.Job_Status__c =='Priority'){
               priorityJobIds.add(jobId.Id);
           }
       }
       system.debug('jobListToDisplay!!'+jobDetailList+'!!priorityJobIds'+priorityJobIds);
        
      String prioritySoql = 'select Id,Project_Name__c,Production_Activity__c,Broadcast_Market__c,Allocated_Budget_euro__c,Job_Status__c,createdDate,AdManagerText__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Lead_Creative_Agency_name__c,Category__r.Name,Brand_Positioning__r.Name,Brand__r.Name,Stage_of_Production_Activity__c,Job_Accepted__c,Job_Started__c,Job_Reported__c,Job_Shared__c from Amr_Job_Details__c where Id IN:priorityJobIds'; 
      system.debug('prioritySoql !!!'+prioritySoql );
      if(String.isNotBlank(selectedSortPriorityOption) && selectedSortPriorityOption !='--None--'){
           prioritySoql += ' ORDER BY '+String.escapeSingleQuotes(selectedSortPriorityOption)+' ASC';
           
     }
       system.debug('prioritySoql01 !!!'+prioritySoql );
      priorityJobList = Database.query(prioritySoql + ' limit 150');
    //  priorityJobList = [select Id,Project_Name__c,Production_Activity__c,Broadcast_Market__c,Allocated_Budget_euro__c,Job_Status__c,createdDate,AdManagerText__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Lead_Creative_Agency_name__c,AMCategory__r.Name,Am_Brand_Positioning__r.Name,Am_Brand__r.Name,Stage_of_Production_Activity__c,Job_Accepted__c,Job_Started__c,Job_Reported__c,Job_Shared__c from Amr_Job_Details__c where Id IN:priorityJobIds ];
      system.debug('priorityJobList !!!'+priorityJobList);
     
      paginationMethodForPriorityJobs(priorityJobList);
      
    }
    
    //method to get sort priority list
    public pageReference getSortedPriorityList(){
        system.debug('selectedSortPriorityOption!!!'+selectedSortPriorityOption);
        getPriorityJobs();
        return null;
    }
   
   
   
   public void getPendingJobs(){
       pendingJobList = new List<Amr_Job_Details__c>();
       Set<Id>pendingJobIds = new Set<Id>();
       for(Amr_Job_Details__c jobId:jobDetailList){
           if(jobId.Job_Status__c =='Pending'){
               pendingJobIds.add(jobId.Id);
           }
       }
      String pendingSoql = 'select Id,Project_Name__c,Production_Activity__c,Broadcast_Market__c,Allocated_Budget_euro__c,Job_Status__c,createdDate,AdManagerText__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Lead_Creative_Agency_name__c,Category__r.Name,Brand_Positioning__r.Name,Brand__r.Name,Stage_of_Production_Activity__c,Job_Accepted__c,Job_Started__c,Job_Reported__c,Job_Shared__c from Amr_Job_Details__c where Id IN:pendingJobIds';
      system.debug('pendingSoql !!!'+pendingSoql );
      
      if(String.isNotBlank(selectedSortPendingOption) && selectedSortPendingOption !='--None--'){
           pendingSoql += ' ORDER BY '+String.escapeSingleQuotes(selectedSortPendingOption)+' ASC';
           
     }
       system.debug('pendingSoql 01!!!'+pendingSoql );
      pendingJobList = Database.query(pendingSoql + ' limit 150');
      
      paginationMethodForPendingJobs(pendingJobList);
   }
   
   //method to get sort pending list
    public pageReference getSortedPendingList(){
        system.debug('selectedSortPendingOption!!!'+selectedSortPendingOption);
        getPendingJobs();
        return null;
    }
   
   public void getDormantJobs(){
       dormantJobList = new List<Amr_Job_Details__c>();
       Set<Id>dormantJobIds = new Set<Id>();
       for(Amr_Job_Details__c jobId:jobDetailList){
           if(jobId.Job_Status__c =='Dormant'){
               dormantJobIds.add(jobId.Id);
           }
       }
      String dormantSoql= 'select Id,Project_Name__c,Production_Activity__c,Broadcast_Market__c,Allocated_Budget_euro__c,Job_Status__c,createdDate,AdManagerText__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Lead_Creative_Agency_name__c,Category__r.Name,Brand_Positioning__r.Name,Brand__r.Name,Stage_of_Production_Activity__c,Job_Accepted__c,Job_Started__c,Job_Reported__c,Job_Shared__c from Amr_Job_Details__c where Id IN:dormantJobIds';
       system.debug('dormantSoql!!!'+dormantSoql);
      
      if(String.isNotBlank(selectedSortDormantOption) && selectedSortDormantOption !='--None--'){
           dormantSoql+= ' ORDER BY '+String.escapeSingleQuotes(selectedSortDormantOption)+' ASC';
           
     }
       system.debug('dormantSoql01!!!'+dormantSoql);
      dormantJobList = Database.query(dormantSoql+ ' limit 150');
      
      system.debug('dormantJobList !!!'+dormantJobList);
      paginationMethodForDormantJobs(dormantJobList);
   }
   
   //method to get sort dormant list
    public pageReference getSortedDormantList(){
        system.debug('selectedSortDormantOption!!!'+selectedSortDormantOption);
        getDormantJobs();
        return null;
    }
    
   
   public void getLiveJobs(){
       liveJobList = new List<Amr_Job_Details__c>();
       Set<Id>liveJobIds = new Set<Id>();
       for(Amr_Job_Details__c jobId:jobDetailList){
           if(jobId.Job_Status__c =='Live'){
               liveJobIds.add(jobId.Id);
           }
       }
      String liveSoql= 'select Id,Project_Name__c,Production_Activity__c,Allocated_Budget_euro__c,Broadcast_Market__c,Job_Status__c,createdDate,AdManagerText__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Lead_Creative_Agency_name__c,Category__r.Name,Brand_Positioning__r.Name,Brand__r.Name,Stage_of_Production_Activity__c,Job_Accepted__c,Job_Started__c,Job_Reported__c,Job_Shared__c from Amr_Job_Details__c where Id IN:liveJobIds';
     
      system.debug('liveSoql!!!'+liveSoql);
      
      if(String.isNotBlank(selectedSortLiveOption) && selectedSortLiveOption !='--None--'){
           liveSoql+= ' ORDER BY '+String.escapeSingleQuotes(selectedSortLiveOption)+' ASC';
           
     }
       system.debug('liveSoql01!!!'+liveSoql);
      liveJobList = Database.query(liveSoql+ ' limit 150');
      system.debug('liveJobList !!!'+liveJobList );
      paginationMethodForLiveJobs(liveJobList);  
   }
   
   //method to get sort live list
    public pageReference getSortedLiveList(){
        system.debug('selectedSortLiveOption!!!'+selectedSortLiveOption);
        getLiveJobs();
        return null;
    }
    
    //pagination for priority jobs starts here
   public void paginationMethodForPriorityJobs(List<Amr_Job_Details__c> jobListToDisplay){
       priorityJobsToShow = new list<Amr_Job_Details__c>();
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
   public void paginationMethodForPendingJobs(List<Amr_Job_Details__c> jobListToDisplay){
       pendingJobsToShow = new list<Amr_Job_Details__c>();
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
   public void paginationMethodForDormantJobs(List<Amr_Job_Details__c> jobListToDisplay){
       dormantJobsToShow = new list<Amr_Job_Details__c>();
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
   public void paginationMethodForLiveJobs(List<Amr_Job_Details__c> jobListToDisplay){
       liveJobsToShow = new list<Amr_Job_Details__c>();
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
        } else if (math.mod(totalSizeForDormantJobs , limitSizeForLiveJobs) != 0){
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
      
       PageReference pageRef = new PageReference('/apex/Amr_JobSheetPage_Final');
       pageRef.getParameters().put('id',chosenId);
       pageRef.setRedirect(true);
       return pageRef;
   }


}