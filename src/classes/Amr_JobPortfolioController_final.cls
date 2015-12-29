public class Amr_JobPortfolioController_final{

public Amr_Job_Details__c jobDetails {get;set;}
public list<Amr_Job_Details__c> jobDetailList{get;set;} 
public String projLeaderCluster{get;set; }
public String projLeaderCountry{get;set; }
public String agencyName{get;set;}
public String 
Market{get;set;}
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
    Integer counterForPriorityJobs = 0;//TO track the number of records parsed
    Integer limitSizeForPriorityJobs = 5;//Number of records to be displayed
    Integer totalSizeForPriorityJobs =0; //To Store the total number of records available
    Integer counterForPendingJobs = 0;
    Integer limitSizeForPendingJobs = 5;
    Integer totalSizeForPendingJobs =0;
    Integer counterForDormantJobs = 0;
    Integer limitSizeForDormantJobs = 5;
    Integer totalSizeForDormantJobs =0;
    Integer counterForLiveJobs = 0;
    Integer limitSizeForLiveJobs = 5;
    Integer totalSizeForLiveJobs =0;
    
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

public Amr_JobPortfolioController_final(){
    jobDetails  = new Amr_Job_Details__c();
    getJobDetailSearch();
   
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

public PageReference getJobDetailSearch() {
      
   //brodMarket = jobDetails.Broadcast_Market__c;
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
    
     if (String.isNotBlank(projLeaderCluster)){
     
           soql += ' and Project_Leader_Cluster__c = \''+projLeaderCluster+'\'';
           system.debug('soql1'+soql);
    }
    
     if(String.isNotBlank(projLeaderCountry)){
    soql += ' and Project_Leader_Country__c = \''+projLeaderCountry+'\'';
           system.debug('soql2'+soql);
    }
    
     if(String.isNotBlank(agencyName)){
    soql += ' and Lead_Creative_Agency_name__c = \''+agencyName+'\'';
           system.debug('soql3'+soql);
     
     }
  
      if(String.isNotBlank(categoryName) && categoryName != '--None--'){
      
    soql += ' and Category__r.Id = \''+categoryName+'\'';
           system.debug('soql4'+soql);
     }
      if(String.isNotBlank(brandPos) && brandPos != '--None--'){
      
    soql += ' and Brand_Positioning__r.Id = \''+brandPos+'\'';
           system.debug('soql5'+soql);
     }
      if(String.isNotBlank(brandName) && brandName != '--None--'){
    soql += ' and Brand__r.Id = \''+brandName+'\'';
           system.debug('soql6'+soql);
     }
     if(String.isNotBlank(stageLogged)){
    soql += ' and Stage_of_Production_Activity__c = \''+stageLogged+'\'';
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
    soql += ' and AdManagerText__c LIKE \''+addNumber+'%\'';
           system.debug('soql12'+soql);
     }
     if(String.isNotBlank(projEmail)){
    soql += ' and Unilever_Project_Leader_Email__c LIKE \''+projEmail+'%\'';
           system.debug('soql13'+soql);
     }
     if(String.isNotBlank(projName)){
    soql += ' and Project_Name__c = \''+projName+'\'';
           system.debug('soql14'+soql);
     }
     jobDetailList = Database.query(soql + ' limit 100');
     
     system.debug('*****soql ******'+soql );
     system.debug('*** My List values ' + jobDetailList);
    
        getPriorityJobs(jobDetailList);
        getPendingJobs(jobDetailList);
        getDormantJobs(jobDetailList);
        getLiveJobs(jobDetailList);
       
   return null;
   }
   
   public void getPriorityJobs(List<Amr_Job_Details__c> jobListToDisplay){
       priorityJobList = new List<Amr_Job_Details__c>();
       Set<Id>priorityJobIds = new Set<Id>();
       for(Amr_Job_Details__c jobId:jobListToDisplay){
           if(jobId.Job_Status__c =='Priority'){
               priorityJobIds.add(jobId.Id);
           }
       }
       system.debug('jobListToDisplay!!'+jobListToDisplay+'!!priorityJobIds'+priorityJobIds);
      priorityJobList = [select Id,Project_Name__c,Production_Activity__c,Broadcast_Market__c,Allocated_Budget_euro__c,Job_Status__c,createdDate,AdManagerText__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Lead_Creative_Agency_name__c,Category__r.Name,Brand_Positioning__r.Name,Brand__r.Name,Stage_of_Production_Activity__c,Job_Accepted__c,Job_Started__c,Job_Reported__c,Job_Shared__c from Amr_Job_Details__c where Id IN:priorityJobIds];
      system.debug('priorityJobList !!!'+priorityJobList);
      paginationMethodForPriorityJobs(priorityJobList);
       
   }
   
   public void getPendingJobs(List<Amr_Job_Details__c>jobListToDisplay){
       pendingJobList = new List<Amr_Job_Details__c>();
       Set<Id>pendingJobIds = new Set<Id>();
       for(Amr_Job_Details__c jobId:jobListToDisplay){
           if(jobId.Job_Status__c =='Pending'){
               pendingJobIds.add(jobId.Id);
           }
       }
      pendingJobList = [select Id,Project_Name__c,Production_Activity__c,Broadcast_Market__c,Allocated_Budget_euro__c,Job_Status__c,createdDate,AdManagerText__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Lead_Creative_Agency_name__c,Category__r.Name,Brand_Positioning__r.Name,Brand__r.Name,Stage_of_Production_Activity__c,Job_Accepted__c,Job_Started__c,Job_Reported__c,Job_Shared__c from Amr_Job_Details__c where Id IN:pendingJobIds];
      system.debug('pendingJobList !!!'+pendingJobList);
      paginationMethodForPendingJobs(pendingJobList);
   }
   
   public void getDormantJobs(List<Amr_Job_Details__c>jobListToDisplay){
       dormantJobList = new List<Amr_Job_Details__c>();
       Set<Id>dormantJobIds = new Set<Id>();
       for(Amr_Job_Details__c jobId:jobListToDisplay){
           if(jobId.Job_Status__c =='Dormant'){
               dormantJobIds.add(jobId.Id);
           }
       }
      dormantJobList  = [select Id,Project_Name__c,Production_Activity__c,Broadcast_Market__c,Allocated_Budget_euro__c,Job_Status__c,createdDate,AdManagerText__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Lead_Creative_Agency_name__c,Category__r.Name,Brand_Positioning__r.Name,Brand__r.Name,Stage_of_Production_Activity__c,Job_Accepted__c,Job_Started__c,Job_Reported__c,Job_Shared__c from Amr_Job_Details__c where Id IN:dormantJobIds];
      system.debug('dormantJobList !!!'+dormantJobList);
      paginationMethodForDormantJobs(dormantJobList);
   }
   
   public void getLiveJobs(List<Amr_Job_Details__c>jobListToDisplay){
       liveJobList = new List<Amr_Job_Details__c>();
       Set<Id>liveJobIds = new Set<Id>();
       for(Amr_Job_Details__c jobId:jobListToDisplay){
           if(jobId.Job_Status__c =='Live'){
               liveJobIds.add(jobId.Id);
           }
       }
      liveJobList = [select Id,Project_Name__c,Production_Activity__c,Allocated_Budget_euro__c,Broadcast_Market__c,Job_Status__c,createdDate,AdManagerText__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Lead_Creative_Agency_name__c,Category__r.Name,Brand_Positioning__r.Name,Brand__r.Name,Stage_of_Production_Activity__c,Job_Accepted__c,Job_Started__c,Job_Reported__c,Job_Shared__c from Amr_Job_Details__c where Id IN:liveJobIds];
      system.debug('liveJobList !!!'+liveJobList );
      paginationMethodForLiveJobs(liveJobList);  
   }
   
    //pagination for priority jobs starts here
   public void paginationMethodForPriorityJobs(List<Amr_Job_Details__c>jobListToDisplay){
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
   public void paginationMethodForPendingJobs(List<Amr_Job_Details__c>jobListToDisplay){
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
   public void paginationMethodForDormantJobs(List<Amr_Job_Details__c>jobListToDisplay){
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
   public void paginationMethodForLiveJobs(List<Amr_Job_Details__c>jobListToDisplay){
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
      
       PageReference pageRef = new PageReference('/apex/AM_JobSheetPage');
       pageRef.getParameters().put('id',chosenId);
       pageRef.setRedirect(true);
       return pageRef;
   }


}