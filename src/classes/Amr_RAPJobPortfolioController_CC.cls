/*************************************************************************************************************************************
Name: Amr_RAPJobPortfolioController_CC
Copyright © 2015 Salesforce
======================================================
Purpose:This class has search and sort functionality of RAP User.Also this class holds pending,live,priority and dormant jobs related activities. 
-------
======================================================
History
-------
VERSION     AUTHOR             DATE           DETAIL           Description
1.0         Mindtree        16/12/2015     INITIAL DEV      CSR:
*************************************************************************************************************************************/
public with sharing class Amr_RAPJobPortfolioController_CC{
    
        public Amr_Job_Details__c jobDetails {get;set;}
        public Amr_Job_Allocation__c advSearchjobDet {get;set;}
        public Amr_Job_Allocation__c jobAlloc {get;set;}
        public list<Amr_Job_Allocation__c> jobDetailList{get;set;} 
        public String projLeaderCluster{get;set; }
        public String projLeaderCountry{get;set; }    
        public String allocatedBudget{get;set; } 
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
        public String productionSupport {get;set;}
        public String projectLeaderEmail{get;set;}
        public String startDate{get;set;}
        public String endDate{get;set;} 
        public String leadAgencyName{get;set;}
        public String permissionSetName {get;set;}
        public String projectLeaderLocation{get;set;}
        public String acceptedAndEmailSend{get;set;}
        public Id chosenId {get; set;}
        public Boolean showPageButtonForPriority{get;set;}
        public Boolean showPageButtonForPending{get;set;}
        public Boolean showPageButtonForLive{get;set;}
        public Boolean showPageButtonForDormant{get;set;}
        public static final String NONE = '--None--';
        public static final String AVERAGE_QUOTE ='averQuote';
        public static final String ACCEPT_QUOTE = 'acceptQuote';
        public static final String DATE_FORMAT = 'yyyy-MM-dd\'T\'hh:mm:ss\'Z\'';
        public static final String PERCENT ='%\'';
       //Navigation variables
        public Integer counterForPriorityJobs = 0;//TO track the number of records parsed
        public Integer limitSizeForPriorityJobs = 100;//Number of records to be displayed
        public Integer totalSizeForPriorityJobs =0; //To Store the total number of records available
        public Integer counterForPendingJobs = 0;
        public Integer limitSizeForPendingJobs = 100;        
        public Integer totalSizeForPendingJobs =0;
        public Integer counterForDormantJobs = 0;
        public Integer limitSizeForDormantJobs = 100;
        public Integer totalSizeForDormantJobs =0;
        public Integer counterForLiveJobs = 0;
        public Integer limitSizeForLiveJobs = 200; 
        public Integer totalSizeForLiveJobs =0;
        public Integer TotalJobs {get; set;}
        public Integer totalAlertCount  {get; set;}
        public Integer totalPendingJobPages {get; set;}
        public Integer totalPriorityJobPages  {get; set;}
        public Integer totalDormantJobPages {get; set;}
        public Integer totalLiveJobPages {get; set;}
        public Integer currentPriorityPageNumber  {get; set;}       
        public Integer currentPendingPageNumber  {get; set;}       
        public Integer currentDormantPageNumber  {get; set;}       
        public Integer currentLivePageNumber  {get; set;}       
        
        public list<Amr_Job_Allocation__c>priorityJobsToShow{get;set;}
        public list<Amr_Job_Allocation__c>pendingJobsToShow{get;set;}
        public list<Amr_Job_Allocation__c>dormantJobsToShow{get;set;}
        public list<Amr_Job_Allocation__c>liveJobsToShow{get;set;}
        
        public List<Amr_Job_Allocation__c> lstLiveJobsNew {get;set;}
        public List<Amr_Job_Allocation__c> lstPendingJobsNew {get;set;}
        public List<Amr_Job_Allocation__c> lstpriorityJobsNew {get;set;}
        public List<Amr_Job_Allocation__c> lstDormantJobsNew {get;set;}
          
        public List<SelectOption> listOfCategory{get;set;} 
        public List<SelectOption> listOfBrandPosition{get;set;}
        public List<SelectOption> listOfBrand{get;set;}
        public List<SelectOption> listOfSortOptions{get;set;}
    
        transient List<Amr_Project_Details__c> projNameList;
        transient String[] listString{get;set;}
        
        public List<Amr_Alert__c> alertList{get;set;}
        public List<Amr_Alert__c> alertListForUnhide{get;set;}
        public String jobIdFromPage{get;set;}
        public Id chosenAlertId{get;set;}
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
        public String selectedUser {get;set;}
        transient  String[]  categoryString{get;set;}
        public Integer closedJob  {get;set;}
        public Integer openJobs {get;set;}
        public Integer totalJobAccepted {get;set;}
        public Integer jobtoAccept {get;set;}
        public String  projectNameText {get;set;}  
        public Integer pendingJob{get;set;}
        public Integer priorityJob{get;set;}
        public Integer liveJob{get;set;}
        public Integer dormantJob{get;set;}
        public Integer pendingJobChart{get;set;}
        public Integer priorityJobChart{get;set;}
        public Integer liveJobChart{get;set;}
        public Integer dormantJobChart{get;set;}
        
        public decimal savingSubmitted {get;set;}
        public decimal savingSubmittedMonth {get;set;}
         public decimal savingSubmittedAll {get;set;}
        transient set<id> jobDetailsId = new set<id> ();
        public Amr_RAPJobPortfolioHelper_CC rapJobPortFolioHelper;
        public Amr_RAPJobPortfolioController_CC(){
          try{
                  pendingJobsToShow = new list<Amr_Job_Allocation__c>();
                  priorityJobsToShow = new list<Amr_Job_Allocation__c>();
                  dormantJobsToShow = new list<Amr_Job_Allocation__c>();
                  liveJobsToShow = new List<Amr_Job_Allocation__c>();
          rapJobPortFolioHelper = new Amr_RAPJobPortfolioHelper_CC();
            loggedInUserId = UserInfo.getUserId();
            jobDetails  = new Amr_Job_Details__c();
            advSearchjobDet = new Amr_Job_Allocation__c();
            jobAlloc = new Amr_Job_Allocation__c();
            alertList = new List<Amr_Alert__c>();
            alertListForUnhide= new List<Amr_Alert__c>();
            hideAlertObj = new Amr_Alert__c();
            hideAlertObjNew= new Amr_Alert__c();
            unHideAlertList = new List<Amr_Alert__c>();
            allocatedBudget = '';
            projNameList= [Select Name from Amr_Project_Details__c ORDER BY Name ASC limit 10000];
            listString= new list<string>();
             
                for(Amr_Project_Details__c i : projNameList){
                        listString.add(i.name);
                }
            jobIdFromPage = ApexPages.currentPage().getParameters().get('id');
            
            getJobDetailSearch();
            getAlertRecords();
            showUnhideRecords = false;
            flagForButtons = false;
           
            User objUser = [Select name From User Where Id = :loggedInUserId limit 50000];
            selectedUser = objUser.Name;
               getTotalJobs();         
            Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
            categoryString = new list<string>();
            Set<MDO_Category__c> categorylst = utiltyObj.categoryValues();
            for(MDO_Category__c mdCat : categorylst){
                categoryString.add(mdCat.name);
            }
        
            listOfBrandPosition = new List<SelectOption>();
            listOfBrandPosition.add(new selectOption(NONE,NONE));
            List<PermissionSetAssignment> userData = [select PermissionSet.Name from PermissionSetAssignment  where Assignee.id = :userinfo.getUserId()];
        
        Set<String> userNameSet = new Set<String>();
        for(PermissionSetAssignment permission : userData){
            userNameSet.add(permission.PermissionSet.Name);
        }
        if(userNameSet.contains(Label.Amr_CAP)){
            permissionSetName = Label.Amr_CAP;
        }else{
            permissionSetName = Label.Amr_RAP;
        }
            }
            catch(exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getmessage());
          }
        
       }
        
/***********************************************************************************************************************************
Purpose: Method to pass project name information to page
Parameters: 
Returns: List of project names in JSON format.

************************************************************************************************************************************/
         public String getMethodToPassProjectNames(){
           return JSON.serialize(listString);
         }

/***********************************************************************************************************************************
Purpose: This method will retrive data related to jobs to display on dashboard.
Parameters: 
Returns: 

************************************************************************************************************************************/      
        public void getTotalJobs() {
        try{
       
        pendingJob =0;
        priorityJob =0;
        liveJob =0;
        dormantJob =0;
        
        pendingJobChart=25;
        priorityJobChart=25;
        liveJobChart=25;
        dormantJobChart=25;
        
        TotalJobs =0;
        TotalJobs = [SELECT count()  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId and User__c = :loggedInUserId)  or  User__c = :loggedInUserId ) and AM_Job_Detail__c != null and Job_Allocated__c = 'Yes'  and AM_Job_Detail__r.Job_Cancelled__c = false  limit 50000];
        List<Amr_Job_Allocation__c> listDisplay =[SELECT AM_Job_Detail__r.Job_Status__c,AM_Job_Detail__c  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId and User__c = :loggedInUserId)  or  User__c = :loggedInUserId ) and AM_Job_Detail__c != null and Job_Allocated__c = 'Yes' and AM_Job_Detail__r.Job_Cancelled__c = false  limit 50000];
        for(Amr_Job_Allocation__c objJobAlloction : [SELECT AM_Job_Detail__c FROM  Amr_Job_Allocation__c where  AM_Job_Detail__c != null and Job_Allocated__c = 'Yes' and AM_Job_Detail__r.Job_Cancelled__c = false limit 50000] ){
               jobDetailsId.add(objJobAlloction.AM_Job_Detail__c);
        }        
        
        pendingJob=[SELECT count()  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId and User__c = :loggedInUserId)  or  User__c = :loggedInUserId ) and AM_Job_Detail__c != null and Job_Allocated__c = 'Yes'  and AM_Job_Detail__r.Job_Status__c = 'Pending' and AM_Job_Detail__r.Job_Cancelled__c = false limit 50000];
         liveJob=[SELECT count()  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId and User__c = :loggedInUserId)  or  User__c = :loggedInUserId ) and AM_Job_Detail__c != null and Job_Allocated__c = 'Yes'  and Job_Status__c = 'Accepted' and AM_Job_Detail__r.Job_Status__c = 'Live' and AM_Job_Detail__r.Job_Cancelled__c = false limit 50000];
          priorityJob=[SELECT count()  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId and User__c = :loggedInUserId)  or  User__c = :loggedInUserId ) and AM_Job_Detail__c != null and Job_Allocated__c = 'Yes'  and Job_Status__c = 'Accepted' and AM_Job_Detail__r.Job_Status__c = 'Priority' and AM_Job_Detail__r.Job_Cancelled__c = false limit 50000];
        dormantJob=[SELECT count()  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId and User__c = :loggedInUserId)  or  User__c = :loggedInUserId ) and AM_Job_Detail__c != null and Job_Allocated__c = 'Yes' and Job_Status__c = 'Accepted' and  AM_Job_Detail__r.Job_Status__c = 'Dormant' and AM_Job_Detail__r.Job_Cancelled__c = false limit 50000];
        
        TotalJobs = pendingJob+liveJob+priorityJob+dormantJob;
                    if(TotalJobs != 0){
                                    
                    
                        
                        
                        pendingJobChart  = pendingJob;
                        priorityJobChart = priorityJob;
                        liveJobChart     = liveJob;
                        dormantJobChart  = dormantJob;
                        
                        Integer TotalJobTest = pendingJobChart + priorityJobChart + liveJobChart + dormantJobChart;
                        
                        liveJobChart            = Integer.valueOf((liveJobChart*100)/TotalJobTest);
                        pendingJobChart         = Integer.valueOf((pendingJobChart*100)/TotalJobTest);
                        priorityJobChart        = Integer.valueOf((priorityJobChart*100)/TotalJobTest);                                           
                        dormantJobChart         = 100 - liveJobChart - pendingJobChart - priorityJobChart;                      
                        
                        liveJobChart = liveJobChart + 20;
                        pendingJobChart = pendingJobChart + 20;
                        priorityJobChart = priorityJobChart + 20;
                        dormantJobChart = dormantJobChart + 20;
                        
                        TotalJobTest = pendingJobChart + priorityJobChart + liveJobChart + dormantJobChart;
                        
                        liveJobChart            = Integer.valueOf((liveJobChart*100)/TotalJobTest);
                        pendingJobChart         = Integer.valueOf((pendingJobChart*100)/TotalJobTest);
                        priorityJobChart        = Integer.valueOf((priorityJobChart*100)/TotalJobTest);                                           
                        dormantJobChart         = 100 - liveJobChart - pendingJobChart - priorityJobChart;
                         
                    }
            }
             catch(exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
               system.debug(ex.getmessage());
          }
     
        }
/***********************************************************************************************************************************
Purpose: Method to get values of Broadcast market picklist field.
Parameters: 
Returns: It will return pisklist values.

************************************************************************************************************************************/         
        
        public List<SelectOption> getTypes(){
            try{
            Schema.sObjectType sobject_type = Amr_Job_Details__c.getSObjectType();
            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
            List<Schema.PicklistEntry> pick_list_values = field_map.get('Brodcast_Market__c').getDescribe().getPickListValues();
            List<selectOption> options = new List<selectOption>();
           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));
          }
            return options;
           }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
            return null;
          }
        }
/***********************************************************************************************************************************
Purpose: Method to get submitted saving data to display on dashboard.
Parameters: 
Returns: It will return submitted saving data.

************************************************************************************************************************************/  
       
      
        public List<PieWedgeData> getPieData(){  
            try{
            List<PieWedgeData> data = new List<PieWedgeData>();
            Integer i = 0;
            Date startOfMonth = Date.today().toStartOfMonth();
            Date startOfNextMonth = startOfMonth.addMonths(1);
            DateTime currentDay = DateTime.now();
            //loggedIn user
            AggregateResult[] groupedResults = [SELECT Sum(Saving_Average_of_Quotes__c)averQuote,Sum(Saving_Accepted_Quote_Euro__c) acceptQuote FROM Amr_Saving__c Where  Display__c = true and Job_Details__c IN : jobDetailsId and (CreatedById = :loggedInUserId OR LastModifiedById = :loggedInUserId) and CALENDAR_YEAR(CreatedDate) = :currentDay.year() AND CreatedDate <= :currentDay];

                    savingSubmitted = 0;
                   
                    if(groupedResults[0].get(AVERAGE_QUOTE) != null ){
                    savingSubmitted = Decimal.valueOf(String.valueOf(groupedResults[0].get(AVERAGE_QUOTE)));
                  
                    }
           //total savings
           AggregateResult[] groupedResultsAll = [SELECT Sum(Saving_Average_of_Quotes__c)averQuote,Sum(Saving_Accepted_Quote_Euro__c) acceptQuote FROM Amr_Saving__c where  Display__c = true and Job_Details__c IN : jobDetailsId and CALENDAR_YEAR(CreatedDate) = :currentDay.year() AND CreatedDate <= :currentDay];
              savingSubmittedAll = 0;
              if(groupedResultsAll[0].get(AVERAGE_QUOTE) != null &&  groupedResultsAll[0].get(ACCEPT_QUOTE) != null){
                    savingSubmittedAll = Decimal.valueOf(String.valueOf(groupedResultsAll[0].get(AVERAGE_QUOTE)));
              }
           data.add(new PieWedgeData('Your YTD Saving',Integer.valueOf(savingSubmitted)));
           data.add(new PieWedgeData('Global Team Saving',Integer.valueOf(savingSubmittedAll)));
          
           return data;  
            }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
            return null;
          }
        } 
/***********************************************************************************************************************************
Purpose: Method to get submitted saving data of current month to display on dashboard.
Parameters: 
Returns: It will return submitted saving data of current month.

************************************************************************************************************************************/  
       
         public List<PieWedgeData> getPieDataSaving(){  
            try{
            List<PieWedgeData> data = new List<PieWedgeData>();
            Integer i = 0;
            
            Date startOfMonth = Date.today().toStartOfMonth();
            Date startOfNextMonth = startOfMonth.addMonths(1);
            AggregateResult[] groupedResults  = [SELECT Sum(Saving_Average_of_Quotes__c)averQuote ,Sum(Saving_Accepted_Quote_Euro__c) acceptQuote FROM Amr_Saving__c Where   Display__c = true and Job_Details__c IN : jobDetailsId and (CreatedById = :loggedInUserId OR LastModifiedById = :loggedInUserId) and  Createddate >= :startOfMonth AND CreatedDate < :startOfNextMonth];
                    savingSubmitted = 0;
                    savingSubmittedMonth = 0;
                    if(groupedResults[0].get(AVERAGE_QUOTE) != null){
                    savingSubmitted = Decimal.valueOf(String.valueOf(groupedResults[0].get(AVERAGE_QUOTE)));
                   }
            AggregateResult[] groupedResultsAll  = [SELECT Sum(Saving_Average_of_Quotes__c)averQuote ,Sum(Saving_Accepted_Quote_Euro__c) acceptQuote FROM Amr_Saving__c Where   Display__c = true and Job_Details__c IN : jobDetailsId and Createddate >= :startOfMonth AND CreatedDate < :startOfNextMonth];
                   savingSubmittedAll = 0;
                    if(groupedResultsAll[0].get(AVERAGE_QUOTE) != null ){
                    
                    savingSubmittedAll = Decimal.valueOf(String.valueOf(groupedResultsAll[0].get(AVERAGE_QUOTE)));
                    }
            data.add(new PieWedgeData('Your Monthly Saving',Integer.valueOf(savingSubmitted)));
             data.add(new PieWedgeData('Global Team Saving',Integer.valueOf(savingSubmittedAll)));
             
            return data; 
           }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
            return null;
          } 
        }  
       
         // Wrapper class  
     public class PieWedgeData 
     {  
      public string name { get; set; }  
      public Integer data { get; set; }  
      public PieWedgeData(string name, integer data) 
      {  
       this.name = name;  
       this.data = data;  
      }  
     }
     
  
/***********************************************************************************************************************************
Purpose: Method to get alert records.
Parameters: 
Returns: 

************************************************************************************************************************************/  
        
        public void getAlertRecords(){
            try{
            alertList = [select Id,Alert_Message__c,job_Id__r.AdManagerText__c,New_Alert__c,Job_Id__c from Amr_Alert__c where ownerId =:loggedInUserId AND Hide__c =:false AND New_Alert__c= today limit 50000];          
            totalAlertCount =  [select count() from Amr_Alert__c where ownerId =:loggedInUserId AND Hide__c =:false AND New_Alert__c= today limit 50000];
            alertListForUnhide= [select Id,New_Alert__c,Alert_Message__c from Amr_Alert__c where ownerId =:loggedInUserId AND Hide__c =:true limit 50000];
              }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
        }
/***********************************************************************************************************************************
Purpose: Method to get category records from utility class.
Parameters: 
Returns: It will return category records in JSON format.

************************************************************************************************************************************/  
   
     public String getCategoryList(){ 
        try{
               Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
              categoryString = new list<string>();
              Set<MDO_Category__c> categorylst = utiltyObj.categoryValues();
              for(MDO_Category__c mdCat : categorylst){
                categoryString.add(mdCat.name);
            }
            return JSON.serialize(categoryString);
        }
            catch(exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
                system.debug(ex.getmessage());
                return null;
          }
        
     }
/***********************************************************************************************************************************
Purpose: Method to get brand position records from utility class.
Parameters: 
Returns: 

************************************************************************************************************************************/      
      public PageReference  brandPositionListData(){    
          try{
             Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
             Set<MDO_BrandPositions__c> brandPositionlst = utiltyObj.brandPostitionValues(categoryName);
             listOfBrandPosition = new List<SelectOption>();
             listOfBrandPosition.add(new selectOption(NONE,NONE));
             Set<String> brnadPosNameSet = new Set<String>();
             for(MDO_BrandPositions__c bps : brandPositionlst){
                 
                 if(!brnadPosNameSet.contains(bps.brand_position_id__r.name)){
                     listOfBrandPosition.add(new selectOption(bps.brand_position_id__r.name,bps.brand_position_id__r.name));
                 
                     brnadPosNameSet.add(bps.brand_position_id__r.name);
                 }
             }
     
         }
            catch(exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
                system.debug(ex.getmessage());
                return null;
          }
            return null;
         
     }
 /***********************************************************************************************************************************
Purpose: Method to get brand records from utility class.
Parameters: 
Returns: It will return brand records.

************************************************************************************************************************************/        
          public List<SelectOption> getBrandList(){      
          try{
        listOfBrand = new List<SelectOption>();
        listOfBrand.add(new selectOption(NONE,NONE));
        Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
        Set<MDO_BrandPositions__c> brandlst = utiltyObj.brandValues(categoryName,brandPos);
        Set<String> brnadNameSet = new Set<String>();
        for(MDO_BrandPositions__c bps : brandlst){
            if(!brnadNameSet.contains(bps.brand_id__r.name)){
                listOfBrand.add(new selectOption(bps.brand_id__r.name,bps.brand_id__r.name));

                brnadNameSet.add(bps.brand_id__r.name);
            }
        }
        }
        catch(exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
                system.debug(ex.getmessage());
                return null;
          }

        return listOfBrand;
    }
/***********************************************************************************************************************************
Purpose: Method to create options for sort by functionality.
Parameters: 
Returns: It will return list of options.

************************************************************************************************************************************/        
        public List<SelectOption> getSortOptions(){  
             
             listOfSortOptions = new List<SelectOption>();
             listOfSortOptions.add(new selectOption(NONE,NONE));
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.AdManagerText__c','AdManager Number'));
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.CreatedDate','Date Logged'));
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Stage_of_Production_Activity__c','Stage Of Production Activity'));
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Unilever_Project_Leader_Email__c','Project Leader Email'));
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Project_Leader_Country__c','Location Project Leader (Country)'));
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.ProductCategory__c','Category'));
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Brand_Final__c','Brand Name'));
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Allocated_Budget_euro__c','Allocated Budget (Euro)'));
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Campaign_Name__c','Campaign Name'));
             listOfSortOptions.add(new selectOption('Job_Shared__c','Job Shared'));
             listOfSortOptions.add(new selectOption('Job_Status__c','Accepted And Email Sent'));
             listOfSortOptions.add(new selectOption('Started__c','Started'));
             listOfSortOptions.add(new selectOption('Reported__c','Reported'));
             return listOfSortOptions;
         }
 /***********************************************************************************************************************************
Purpose: Method holds search functionality.
Parameters: 
Returns: 
N-Path:
Search functionality is implemented and SOQL is built dynamically so can not break 'if' decision points from this method, 
************************************************************************************************************************************/    
        public PageReference getJobDetailSearch() {
        
        try{
      
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
        productionSupport = jobDetails.Production_Activity_Type__c;
                
        jobDetailList = new list<Amr_Job_Allocation__c>();
         
        string soql ='select AM_Job_Detail__r.Lead_Agency_Name_Other__c,AM_Job_Detail__r.Campaign_Name__c,AM_Job_Detail__r.ProductionActivityTextArea__c,AM_Job_Detail__r.Project_Name_Other__c ,Job_Status__c,User__c,Job_Shared__c,Reported__c,Started__c,Job_Allocated__c,Started_Image__c,Job_Allocated_Image__c,AM_Job_Detail__r.Project_Details__c,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Job_Status__c,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.ProductCategory__c,AM_Job_Detail__r.Brand_Position__c,AM_Job_Detail__r.Brand_Final__c,AM_Job_Detail__r.Stage_of_Production_Activity__c,AM_Job_Detail__r.Job_Accepted__c,AM_Job_Detail__r.Job_Started__c,Job_Status_Image__c,Reported_Image__c,AM_Job_Detail__r.Job_Reported__c,AM_Job_Detail__r.job_Shared__c  From Amr_Job_Allocation__c where Name!=null and AM_Job_Detail__r.Job_Cancelled__c = false';
        if(String.isNotBlank(loggedInUserId)){
        
        soql += ' and ((AM_Job_Detail__r.OwnerId = \''+loggedInUserId+'\' AND User__c = \''+loggedInUserId+'\') or  User__c = \''+loggedInUserId+'\')';
        }
        
      /*
      N-Path:
     SOQL is built dynamically, to search the records that user provided values on search fields in 'Search and Filter' section on Job Portfolio Page
     There are around 15 fields on which user can search the records within AdManager tool
     */
       if (String.isNotBlank(String.valueOf(jobDetails.Start_Date__c))){
            Datetime startdate = jobDetails.Start_Date__c;
            String dateTimeFormat = startdate.format(DATE_FORMAT);
            
             soql += ' and AM_Job_Detail__r.createdDate'+  ' >= '+ dateTimeFormat ;
              
        }
        
        if (String.isNotBlank(String.valueOf(jobDetails.End_Date__c))){ 
            Datetime endate  = jobDetails.End_Date__c;
             String dateTimeFormat1 = endate.format(DATE_FORMAT);
            
              soql += ' and AM_Job_Detail__r.createdDate ' +  ' < '+ dateTimeFormat1 ;
             
        }
        
         if (String.isNotBlank(jobDetails.Project_Leader_Cluster__c)){
         
               soql += ' and AM_Job_Detail__r.Project_Leader_Cluster__c = \''+String.escapeSingleQuotes(projLeaderCluster)+Amr_ConstantForAdManager.SLASH;
              
        }
         if(String.isNotBlank(productionSupport)){
        soql += ' and AM_Job_Detail__r.Production_Activity_Type__c = \''+String.escapeSingleQuotes(productionSupport)+Amr_ConstantForAdManager.SLASH;
               
        }
        
         if(String.isNotBlank(projLeaderCountry)){
        soql += ' and AM_Job_Detail__r.Project_Leader_Country__c = \''+String.escapeSingleQuotes(projLeaderCountry)+Amr_ConstantForAdManager.SLASH;
               
        }
          if(String.isNotBlank(leadAgencyName )){
        soql += ' and AM_Job_Detail__r.Lead_Creative_Agency_name__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+ String.escapeSingleQuotes(leadAgencyName)+Amr_ConstantForAdManager.PERCENTAGESLASH;
               
         
         }
          if(String.isNotBlank(brodMarket)){
       soql += ' and AM_Job_Detail__r.Brodcast_Market__c LIKE \''+String.escapeSingleQuotes(brodMarket)+PERCENT;
               
         }
          if(String.isNotBlank(categoryName)){
          
        soql += ' and AM_Job_Detail__r.ProductCategory__r.name LIKE \''+Amr_ConstantForAdManager.PERCENTAGE +String.escapeSingleQuotes(categoryName)+Amr_ConstantForAdManager.PERCENTAGESLASH;
             
         }
          if(String.isNotBlank(brandPos)){
          
        soql += ' and AM_Job_Detail__r.Brand_Position__r.name LIKE \''+Amr_ConstantForAdManager.PERCENTAGE +String.escapeSingleQuotes(brandPos)+Amr_ConstantForAdManager.PERCENTAGESLASH;
               
         }
          if(String.isNotBlank(brandName)){
        soql += ' and AM_Job_Detail__r.Brand_Final__r.name LIKE \''+Amr_ConstantForAdManager.PERCENTAGE +String.escapeSingleQuotes(brandName)+Amr_ConstantForAdManager.PERCENTAGESLASH;
              
         }
         if(String.isNotBlank(stageLogged)){
        soql += ' and AM_Job_Detail__r.Stage_of_Production_Activity__c = \''+String.escapeSingleQuotes(stageLogged)+Amr_ConstantForAdManager.SLASH;
              
         }
         if(String.isNotBlank(jobAlloc.Job_Status__c) && jobAlloc.Job_Status__c != Amr_ConstantForAdManager.NONE){
        soql += ' and Job_Status__c = \''+jobAlloc.Job_Status__c+Amr_ConstantForAdManager.SLASH;
              
         }
         if(String.isNotBlank(jobAlloc.Started__c) && jobAlloc.Started__c != Amr_ConstantForAdManager.NONE){
        soql += ' and Started__c = \''+jobAlloc.Started__c+Amr_ConstantForAdManager.SLASH;
              
         }
         if(String.isNotBlank(jobAlloc.Reported__c) && jobAlloc.Reported__c != Amr_ConstantForAdManager.NONE){
        soql += ' and Reported__c = \''+jobAlloc.Reported__c+Amr_ConstantForAdManager.SLASH;
              
         }

         if(String.isNotBlank(jobAlloc.Job_Shared__c)  && jobAlloc.Job_Shared__c != Amr_ConstantForAdManager.NONE){
        soql += ' and Job_Shared__c = \''+jobAlloc.Job_Shared__c+Amr_ConstantForAdManager.SLASH;
              
         }
         if(String.isNotBlank(addNumber)){
        soql += ' and AM_Job_Detail__r.AdManagerText__c LIKE \''+'%'+ String.escapeSingleQuotes(addNumber)+PERCENT;
              
         }
         
          if(String.isNotBlank(projectLeaderLocation)){
        soql += ' and AM_Job_Detail__r.Project_Leader_Country__c  LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+ String.escapeSingleQuotes(projectLeaderLocation)+Amr_ConstantForAdManager.PERCENTAGESLASH;
              
         }
   
        if(String.isNotBlank(allocatedBudget) ){
             soql += ' and AM_Job_Detail__r.Allocated_Budget_Euro_Text__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+ String.escapeSingleQuotes(allocatedBudget)+Amr_ConstantForAdManager.PERCENTAGESLASH;
        }
        
        if(String.isNotBlank(acceptedAndEmailSend) &&  acceptedAndEmailSend != Amr_ConstantForAdManager.NONE){
        
            if(acceptedAndEmailSend == 'Yes'){
                soql += ' and Job_Status__c = \''+String.escapeSingleQuotes(Label.Amr_Accepted)+Amr_ConstantForAdManager.SLASH;
            }
            else{
                soql += ' and Job_Status__c != \''+String.escapeSingleQuotes(Label.Amr_Accepted)+Amr_ConstantForAdManager.SLASH;
            }
        }
        
         
          if(String.isNotBlank(projectNameText)){
        soql += ' and AM_Job_Detail__r.Project_Details__r.Name LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(projectNameText)+Amr_ConstantForAdManager.PERCENTAGESLASH;
                     
         }
         if(String.isNotBlank(projectLeaderEmail)){
        soql += ' and AM_Job_Detail__r.Unilever_Project_Leader_Email__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(projectLeaderEmail)+Amr_ConstantForAdManager.PERCENTAGESLASH;
                     
         }
                 
         if(String.isNotBlank(jobDetails.Campaign_Name__c)){
        soql += ' and AM_Job_Detail__r.Campaign_Name__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE +String.escapeSingleQuotes(jobDetails.Campaign_Name__c)+Amr_ConstantForAdManager.PERCENTAGESLASH;
            
         }
         if (String.isNotBlank(startDate)){
   //start date creation
               String[] startDateSplitQuote = startDate.split(' ');
               String[] startDateSplitSlash = startDateSplitQuote[0].split('/');
               Integer myIntDate = integer.valueOf(startDateSplitSlash[0]);
               Integer myIntMonth = integer.valueOf(startDateSplitSlash[1]);
               Integer myIntYear = integer.valueOf(startDateSplitSlash[2]);
               Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
               DateTime startDateFinal = DateTime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0);
               DateTime refDate2 = startDateFinal.addDays(1);
       //        soql += ' and AM_Job_Detail__r.createdDate '+  ' >= '+ startDateFinal.formatGMT(Amr_ConstantForAdManager.SECDATEFORMAT) ;
         //      soql += ' and AM_Job_Detail__r.createdDate '+  '< '+ refDate2.formatGMT(Amr_ConstantForAdManager.SECDATEFORMAT);
          soql += ' and AM_Job_Detail__r.createdDate'+  ' >= '+ startDateFinal.formatGMT(Amr_ConstantForAdManager.SECDATEFORMAT) ; 
               
    }
    
       
   // END DATE
   
   if (String.isNotBlank(endDate)){
    //end date creation
   String[] endDateSplitQuote = endDate.split(' ');
   String[] endDateSplitSlash = endDateSplitQuote[0].split(Amr_ConstantForAdManager.BACK_SLASH);
   Integer myIntDate1 = integer.valueOf(endDateSplitSlash[0]);
   Integer myIntMonth1 = integer.valueOf(endDateSplitSlash[1]);
   Integer myIntYear1 = integer.valueOf(endDateSplitSlash[2]);
   Date d1 = Date.newInstance(myIntYear1, myIntMonth1, myIntDate1);
   DateTime endDateDateFinal = DateTime.newInstance(d1.year(), d1.month(), d1.day(), 0, 0, 0);
  
           soql += ' and AM_Job_Detail__r.createdDate ' +  ' < '+ endDateDateFinal.addDays(1).formatGMT(Amr_ConstantForAdManager.SECDATEFORMAT );
           
    }
    
        
         jobDetailList = Database.query(soql);
            getPriorityJobs();
            getPendingJobs();
            getDormantJobs();
            getLiveJobs();
        }
        catch(exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
                system.debug(ex.getmessage());
                return null;
       }    
           
       return null;
       
       }
/***********************************************************************************************************************************
Purpose: Method to identify priority jobs with sort functionality.
Parameters: 
Returns: 

************************************************************************************************************************************/        
         
       public Void getPriorityJobs(){
        try{
           List<Amr_Job_Allocation__c> priorityJobList = new List<Amr_Job_Allocation__c>();
           Set<Id>priorityJobIds = new Set<Id>();
           Set<String> priorityStrings = new Set<String>();
           for(Amr_Job_Allocation__c jobId:jobDetailList){
               if((jobId.AM_Job_Detail__r.Job_Status__c == Label.Amr_Status_Priority) && (jobId.Job_Status__c == 'Accepted')){
                   priorityJobIds.add(jobId.AM_Job_Detail__r.Id);
                   priorityStrings.add(jobId.AM_Job_Detail__r.AdManagerText__c);
               }
           }
                     
          String prioritySoql = 'select AM_Job_Detail__r.Lead_Agency_Name_Other__c,AM_Job_Detail__r.ProductionActivityTextArea__c,AM_Job_Detail__r.Campaign_Name__c,AM_Job_Detail__r.Project_Name_Other__c,Job_Status__c,User__c,Job_Shared__c,Reported__c,Started__c,Job_Allocated__c,Started_Image__c,Job_Allocated_Image__c,AM_Job_Detail__r.Project_Details__r.Name,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Job_Status__c,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.ProductCategory__r.Name,AM_Job_Detail__r.Brand_Position__r.Name,AM_Job_Detail__r.Brand_Final__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,AM_Job_Detail__r.Job_Accepted__c,AM_Job_Detail__r.Job_Started__c,Job_Status_Image__c,Reported_Image__c,AM_Job_Detail__r.Job_Reported__c  From Amr_Job_Allocation__c where AM_Job_Detail__r.Id IN:priorityJobIds  ';
             if(String.isNotBlank(selectedSortPriorityOption) && selectedSortPriorityOption !=NONE){
             
                    if(selectedSortPriorityOption == Label.Amr_Query_Category){
                        prioritySoql += ' ORDER BY AM_Job_Detail__r.ProductCategory__r.Name ASC';   
                    }else
                    if(selectedSortPriorityOption == Label.Amr_Query_BrandPosition){
                        prioritySoql += ' ORDER BY AM_Job_Detail__r.Brand_Position__r.Name ASC'; 
                    }
                    else
                    if(selectedSortPriorityOption == Label.Amr_Query_BrandName){
                        prioritySoql += ' ORDER BY AM_Job_Detail__r.Brand_Final__r.Name ASC'; 
                    }
                    else
                    if(selectedSortPriorityOption == Label.Amr_Query_Project_Detail){
                        prioritySoql += ' ORDER BY AM_Job_Detail__r.Project_Details__r.Name ASC'; 
                    }
                    else
                    if(selectedSortPriorityOption == Label.Amr_Query_User){
                        prioritySoql += ' ORDER BY User__r.Name ASC'; 
                    }
                    else{
                       prioritySoql += ' ORDER BY '+String.escapeSingleQuotes(selectedSortPriorityOption)+' ASC';
                   }
          
         }
           priorityJobList = Database.query(prioritySoql );
           paginationMethodForPriorityJobs(priorityJobList);
          
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
        }
        
       
        //method to get sort priority list
        public pageReference getSortedPriorityList(){
            getPriorityJobs();
            return null;
        }
 /***********************************************************************************************************************************
Purpose: Method to identify pending jobs with sort functionality.
Parameters: 
Returns: 

************************************************************************************************************************************/      
       public void getPendingJobs(){
           
        try{
           List<Amr_Job_Allocation__c> pendingJobList = new List<Amr_Job_Allocation__c>();
           Set<Id>pendingJobIds = new Set<Id>();
           for(Amr_Job_Allocation__c jobId : jobDetailList){
               if((jobId.AM_Job_Detail__r.Job_Status__c == 'Pending')  && jobId.Job_Status__c != 'Cancelled')
               {
                   pendingJobIds.add(jobId.AM_Job_Detail__r.Id);
               }
           }
     
          String pendingSoql ='select AM_Job_Detail__r.Lead_Agency_Name_Other__c,AM_Job_Detail__r.ProductionActivityTextArea__c,AM_Job_Detail__r.Campaign_Name__c,AM_Job_Detail__r.Project_Name_Other__c,Job_Status__c,User__c,Job_Shared__c,Reported__c,Started__c,Job_Allocated__c,Started_Image__c,Job_Allocated_Image__c,AM_Job_Detail__r.Project_Details__r.Name,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Job_Status__c,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.ProductCategory__r.Name,AM_Job_Detail__r.Brand_Position__r.Name,AM_Job_Detail__r.Brand_Final__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,AM_Job_Detail__r.Job_Accepted__c,AM_Job_Detail__r.Job_Started__c,Job_Status_Image__c,Reported_Image__c,AM_Job_Detail__r.Job_Reported__c,AM_Job_Detail__r.job_Shared__c  From Amr_Job_Allocation__c where AM_Job_Detail__r.Id IN:pendingJobIds  and ((AM_Job_Detail__r.ownerId =:loggedInUserId AND User__c = :loggedInUserId) OR User__c = :loggedInUserId) ';
         
          if(String.isNotBlank(selectedSortPendingOption) && selectedSortPendingOption !=NONE){
                   
                    if(selectedSortPendingOption == Label.Amr_Query_Category){
                        pendingSoql += ' ORDER BY AM_Job_Detail__r.ProductCategory__r.Name ASC';   
                    }else
                    if(selectedSortPendingOption == Label.Amr_Query_BrandPosition){
                        pendingSoql += ' ORDER BY AM_Job_Detail__r.Brand_Position__r.Name ASC'; 
                    }
                    else
                    if(selectedSortPendingOption == Label.Amr_Query_BrandName){
                        pendingSoql += ' ORDER BY AM_Job_Detail__r.Brand_Final__r.Name ASC'; 
                    }
                    else
                    if(selectedSortPendingOption == Label.Amr_Query_Project_Detail){
                        pendingSoql += ' ORDER BY AM_Job_Detail__r.Project_Details__r.Name ASC'; 
                    }
                    else
                    if(selectedSortPendingOption == Label.Amr_Query_User){
                        pendingSoql += ' ORDER BY User__r.Name ASC'; 
                    }
                   else{
                       pendingSoql += ' ORDER BY '+String.escapeSingleQuotes(selectedSortPendingOption )+' ASC';
                   }              
         }
          pendingJobList = Database.query(pendingSoql);
          paginationMethodForPendingJobs(pendingJobList);
          }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
          
       }
       
       //method to get sort pending list
        public pageReference getSortedPendingList(){
           
            getPendingJobs();
            return null;
        }
/***********************************************************************************************************************************
Purpose: Method to identify dormant jobs with sort functionality.
Parameters: 
Returns: 

************************************************************************************************************************************/         
         
       public void getDormantJobs(){
        try{
           List<Amr_Job_Allocation__c> dormantJobList = new List<Amr_Job_Allocation__c>();
           Set<Id>dormantJobIds = new Set<Id>();
           for(Amr_Job_Allocation__c jobId:jobDetailList){
               if((jobId.AM_Job_Detail__r.Job_Status__c == Label.Amr_Status_Dormant) && (jobId.Job_Status__c == 'Accepted')){
                   dormantJobIds.add(jobId.AM_Job_Detail__r.Id);
               }
           }
           String dormantSoql ='select AM_Job_Detail__r.Lead_Agency_Name_Other__c,AM_Job_Detail__r.ProductionActivityTextArea__c,AM_Job_Detail__r.Campaign_Name__c,AM_Job_Detail__r.Project_Name_Other__c,Job_Status__c,User__c,Job_Shared__c,Reported__c,Started__c,Job_Allocated__c,Started_Image__c,Job_Allocated_Image__c,AM_Job_Detail__r.Project_Details__r.name,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Job_Status__c,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.ProductCategory__r.Name,AM_Job_Detail__r.Brand_Position__r.Name,AM_Job_Detail__r.Brand_Final__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,AM_Job_Detail__r.Job_Accepted__c,AM_Job_Detail__r.Job_Started__c,Job_Status_Image__c,Reported_Image__c,AM_Job_Detail__r.Job_Reported__c,AM_Job_Detail__r.job_Shared__c  From Amr_Job_Allocation__c where AM_Job_Detail__r.Id IN:dormantJobIds  and AM_Job_Detail__r.Job_Cancelled__c = false and ((AM_Job_Detail__r.ownerId =:loggedInUserId AND User__c = :loggedInUserId) OR User__c = :loggedInUserId) ';
           if(String.isNotBlank(selectedSortDormantOption) && selectedSortDormantOption !=NONE){
           
                   if(selectedSortDormantOption == Label.Amr_Query_Category){
                        dormantSoql += ' ORDER BY AM_Job_Detail__r.ProductCategory__r.Name ASC';   
                    }else
                    if(selectedSortDormantOption == Label.Amr_Query_BrandPosition){
                        dormantSoql += ' ORDER BY AM_Job_Detail__r.Brand_Position__r.Name ASC'; 
                    }
                    else
                    if(selectedSortDormantOption == Label.Amr_Query_BrandName){
                        dormantSoql += ' ORDER BY AM_Job_Detail__r.Brand_Final__r.Name ASC'; 
                    }
                    else
                    if(selectedSortDormantOption == Label.Amr_Query_Project_Detail){
                        dormantSoql += ' ORDER BY AM_Job_Detail__r.Project_Details__r.Name ASC'; 
                    }
                    else
                    if(selectedSortDormantOption== Label.Amr_Query_User){
                        dormantSoql += ' ORDER BY User__r.Name ASC'; 
                    }
                   else{
                       dormantSoql += ' ORDER BY '+String.escapeSingleQuotes(selectedSortDormantOption )+' ASC';
                   }               
         }
          dormantJobList = Database.query(dormantSoql);
          paginationMethodForDormantJobs(dormantJobList);
         }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
         }
          
        }
       
       //method to get sort dormant list
        public pageReference getSortedDormantList(){
           
            getDormantJobs();
            return null;
        }
 /***********************************************************************************************************************************
Purpose: Method to identify live jobs with sort functionality.
Parameters: 
Returns: 

************************************************************************************************************************************/          
       
       public void getLiveJobs(){
        try{

           list<Amr_Job_Allocation__c> liveJobList = new List<Amr_Job_Allocation__c>();
           Set<Id>liveJobIds = new Set<Id>();
           for(Amr_Job_Allocation__c jobId:jobDetailList){
               if((jobId.AM_Job_Detail__r.Job_Status__c == Label.Amr_Status_Live) && jobId.Job_Status__c == 'Accepted' && jobId.Job_Status__c != 'Cancelled')  
               {
                   liveJobIds.add(jobId.AM_Job_Detail__r.Id);
               }
           }
             
          String liveSoql ='select AM_Job_Detail__r.Lead_Agency_Name_Other__c,AM_Job_Detail__r.ProductionActivityTextArea__c,AM_Job_Detail__r.Campaign_Name__c,AM_Job_Detail__r.Project_Name_Other__c,Job_Status__c,User__c,Job_Shared__c,Reported__c,Started__c,Job_Allocated__c,Started_Image__c,Job_Allocated_Image__c,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Job_Status__c,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.ProductCategory__c,AM_Job_Detail__r.ProductCategory__r.Name,AM_Job_Detail__r.Brand_Position__r.Name,AM_Job_Detail__r.Project_Details__r.Name,AM_Job_Detail__r.Brand_Final__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,AM_Job_Detail__r.Job_Accepted__c,AM_Job_Detail__r.Job_Started__c,Job_Status_Image__c,Reported_Image__c,AM_Job_Detail__r.Job_Reported__c,AM_Job_Detail__r.job_Shared__c  From Amr_Job_Allocation__c where AM_Job_Detail__r.Id IN:liveJobIds and ((AM_Job_Detail__r.ownerId =:loggedInUserId AND User__c = :loggedInUserId) OR User__c = :loggedInUserId) ';
          if(String.isNotBlank(selectedSortLiveOption) && selectedSortLiveOption != NONE){
                   if(selectedSortLiveOption == Label.Amr_Query_Category){
                        liveSoql += ' ORDER BY AM_Job_Detail__r.ProductCategory__r.Name ASC';   
                    }else
                    if(selectedSortLiveOption == Label.Amr_Query_BrandPosition){
                        liveSoql += ' ORDER BY AM_Job_Detail__r.Brand_Position__r.Name ASC'; 
                    }
                    else
                    if(selectedSortLiveOption == Label.Amr_Query_BrandName){
                        liveSoql += ' ORDER BY AM_Job_Detail__r.Brand_Final__r.Name ASC'; 
                    }
                    else
                    if(selectedSortLiveOption == Label.Amr_Query_Project_Detail){
                        liveSoql += ' ORDER BY AM_Job_Detail__r.Project_Details__r.Name ASC'; 
                    }
                    else
                    if(selectedSortLiveOption == Label.Amr_Query_User){
                        liveSoql += ' ORDER BY User__r.Name ASC'; 
                    }
                   else{
                       liveSoql += ' ORDER BY '+String.escapeSingleQuotes(selectedSortLiveOption)+' ASC';
                   }
         }
          liveJobList = Database.query(liveSoql);
          paginationMethodForLiveJobs(liveJobList);  
       }catch(Exception ex){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
       }
       
       }
       
       //method to get sort live list
        public pageReference getSortedLiveList(){
            getLiveJobs();
            return null;
        }
        
/***********************************************************************************************************************************
Purpose: Method to paginate pending jobs.
Parameters: list of pending jobs.
Returns: 

************************************************************************************************************************************/        
        public void paginationMethodForPendingJobs(List<Amr_Job_Allocation__c> jobListToDisplay){
        try{
           pendingJobsToShow = new list<Amr_Job_Allocation__c>();
           lstPendingJobsNew = new List<Amr_Job_Allocation__c>();
           totalSizeForPendingJobs = jobListToDisplay.size();
           if(limitSizeForPendingJobs < totalSizeForPendingJobs){
           showPageButtonForPending = true;
           }else{
           showPageButtonForPending = false;
           }
                 
            if(!jobListToDisplay.isEmpty()){
              List<Amr_Job_Allocation__c> lstPending = new List<Amr_Job_Allocation__c>();
              lstPending = jobListToDisplay;
              pendingJobsToShow = new List<Amr_Job_Allocation__c>();
              rapJobPortFolioHelper.removeDuplicatePending(lstPending,pendingJobsToShow);
              lstPendingJobsNew= pendingJobsToShow;
              totalSizeForPendingJobs = pendingJobsToShow.size();
            }
            pendingJobsToShow = new List<Amr_Job_Allocation__c>();
            //Intial adding
            //check the total records are more than limitSizeForPriorityJobs and assign the records
            if((counterForPendingJobs+limitSizeForPendingJobs) <= totalSizeForPendingJobs){
                for(Integer i=0;i<limitSizeForPendingJobs;i++){
                    pendingJobsToShow.add(lstPendingJobsNew.get(i));
                }
            }else{
                for(Integer i=0;i<totalSizeForPendingJobs;i++){
                    pendingJobsToShow.add(lstPendingJobsNew.get(i));
                }
            }
           
         totalPendingJobPages = Math.ceil((decimal.valueOf(totalSizeForPendingJobs))/(decimal.valueOf(limitSizeForPendingJobs))).intValue();
        currentPendingPageNumber         = (counterForPendingJobs/limitSizeForPendingJobs)+1;
          }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
          }
            
        public void beginningForPendingJobs(){
            try{
          
            pendingJobsToShow.clear();
        
            counterForPendingJobs=0;
            if((counterForPendingJobs + limitSizeForPendingJobs) <= totalSizeForPendingJobs){
                for(Integer i=0;i<limitSizeForPendingJobs;i++){
                    pendingJobsToShow.add(lstPendingJobsNew.get(i));
                }   
            }else{
                for(Integer i=0;i<totalSizeForPendingJobs;i++){
                    pendingJobsToShow.add(lstPendingJobsNew.get(i));
                }       
            }
             totalPendingJobPages = Math.ceil((decimal.valueOf(totalSizeForPendingJobs))/(decimal.valueOf(limitSizeForPendingJobs))).intValue();
        currentPendingPageNumber  = (counterForPendingJobs/limitSizeForPendingJobs)+1;
       }catch(Exception ex){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
        }
       
        public void nextForPendingJobs(){
      
              try{
              pendingJobsToShow = new List<Amr_Job_Allocation__c>();
           
            
             counterForPendingJobs = counterForPendingJobs+limitSizeForPendingJobs;
             
            if((counterForPendingJobs+limitSizeForPendingJobs) <= totalSizeForPendingJobs){
                             
                for(Integer i=counterForPendingJobs;i<(counterForPendingJobs+limitSizeForPendingJobs);i++){
                  pendingJobsToShow.add(lstPendingJobsNew.get(i));
                            
                }
            } else{
                for(Integer i=counterForPendingJobs;i<totalSizeForPendingJobs;i++){
                   pendingJobsToShow.add(lstPendingJobsNew.get(i));
                  
                }
            }
             totalPendingJobPages = Math.ceil((decimal.valueOf(totalSizeForPendingJobs))/(decimal.valueOf(limitSizeForPendingJobs))).intValue();
        currentPendingPageNumber         = (counterForPendingJobs/limitSizeForPendingJobs)+1;
         }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
        }
       
        public void previousForPendingJobs(){
          try{
            pendingJobsToShow.clear();
            counterForPendingJobs=counterForPendingJobs-limitSizeForPendingJobs;       
                for(Integer i=counterForPendingJobs;i<(counterForPendingJobs+limitSizeForPendingJobs); i++){
                pendingJobsToShow.add(lstPendingJobsNew.get(i));
            }
             totalPendingJobPages = Math.ceil((decimal.valueOf(totalSizeForPendingJobs))/(decimal.valueOf(limitSizeForPendingJobs))).intValue();
        currentPendingPageNumber         = (counterForPendingJobs/limitSizeForPendingJobs)+1;
          }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
        }
    
        public void lastForPendingJobs (){
            try{
            pendingJobsToShow.clear();
            if(math.mod(totalSizeForPendingJobs , limitSizeForPendingJobs) == 0){
                counterForPendingJobs = limitSizeForPendingJobs * ((totalSizeForPendingJobs/limitSizeForPendingJobs)-1);
            } else if (math.mod(totalSizeForPendingJobs , limitSizeForPriorityJobs) != 0){
                counterForPendingJobs = limitSizeForPendingJobs * ((totalSizeForPendingJobs/limitSizeForPendingJobs));
            }
            for(Integer i=counterForPendingJobs-1;i<totalSizeForPendingJobs-1;i++){
                    pendingJobsToShow.add(lstPendingJobsNew.get(i));
            }
             totalPendingJobPages = Math.ceil((decimal.valueOf(totalSizeForPendingJobs))/(decimal.valueOf(limitSizeForPendingJobs))).intValue();
        currentPendingPageNumber         = (counterForPendingJobs/limitSizeForPendingJobs)+1;
           }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
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
 /***********************************************************************************************************************************
Purpose: Method to paginate priority jobs.
Parameters: list of priority jobs.
Returns: 

************************************************************************************************************************************/       
      
        //pagination for priority jobs starts here
       public void paginationMethodForPriorityJobs(List<Amr_Job_Allocation__c> jobListToDisplay){
        try{
           priorityJobsToShow = new list<Amr_Job_Allocation__c>();
           lstpriorityJobsNew = new List<Amr_Job_Allocation__c>();
           totalSizeForPriorityJobs = jobListToDisplay.size();
           if(limitSizeForPriorityJobs < totalSizeForPriorityJobs){
           showPageButtonForPriority = true;
           }else{
           showPageButtonForPriority = false;
           }
                  
            if(!jobListToDisplay.isEmpty()){
              List<Amr_Job_Allocation__c> lstPriority = new List<Amr_Job_Allocation__c>();
              
              lstPriority = jobListToDisplay;
             
              rapJobPortFolioHelper.removeDuplicatePriority(lstPriority,priorityJobsToShow);
              totalSizeForPriorityJobs = priorityJobsToShow.size();
              lstpriorityJobsNew = priorityJobsToShow;
            }
              priorityJobsToShow = new List<Amr_Job_Allocation__c>();
             
               //Intial adding
            //check the total records are more than limitSizeForPriorityJobs and assign the records
            if((counterForPriorityJobs+limitSizeForPriorityJobs) <= totalSizeForPriorityJobs){
                for(Integer i=0;i<limitSizeForPriorityJobs;i++){
                    priorityJobsToShow.add(lstpriorityJobsNew.get(i));
                }
            }else{
                for(Integer i=0;i<totalSizeForPriorityJobs;i++){
                    priorityJobsToShow.add(lstpriorityJobsNew.get(i));
                }
            }
             totalPriorityJobPages = Math.ceil((decimal.valueOf(totalSizeForPriorityJobs))/(decimal.valueOf(limitSizeForPriorityJobs))).intValue();
        currentPriorityPageNumber         = (counterForPriorityJobs/limitSizeForPriorityJobs)+1;
           }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
          }
            
        public void beginningForPriorityJobs(){
            try{
            priorityJobsToShow.clear();
            counterForPriorityJobs=0;
            if((counterForPriorityJobs + limitSizeForPriorityJobs) <= totalSizeForPriorityJobs){
                for(Integer i=0;i<limitSizeForPriorityJobs;i++){
                    priorityJobsToShow.add(lstpriorityJobsNew.get(i));
                }   
            }else{
                for(Integer i=0;i<totalSizeForPriorityJobs;i++){
                    priorityJobsToShow.add(lstpriorityJobsNew.get(i));
                }       
            }
            totalPriorityJobPages = Math.ceil((decimal.valueOf(totalSizeForPriorityJobs))/(decimal.valueOf(limitSizeForPriorityJobs))).intValue();
        currentPriorityPageNumber         = (counterForPriorityJobs/limitSizeForPriorityJobs)+1;
           }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
        }
       
     
        public void nextForPriorityJobs(){
            try{
            priorityJobsToShow.clear();
            counterForPriorityJobs=counterForPriorityJobs+limitSizeForPriorityJobs;
            if((counterForPriorityJobs+limitSizeForPriorityJobs) <= totalSizeForPriorityJobs){
                for(Integer i=counterForPriorityJobs;i<(counterForPriorityJobs+limitSizeForPriorityJobs);i++){
                    priorityJobsToShow.add(lstpriorityJobsNew.get(i));
                }
            } else{
                for(Integer i=counterForPriorityJobs;i<totalSizeForPriorityJobs;i++){
                    priorityJobsToShow.add(lstpriorityJobsNew.get(i));
                }
            }
            totalPriorityJobPages = Math.ceil((decimal.valueOf(totalSizeForPriorityJobs))/(decimal.valueOf(limitSizeForPriorityJobs))).intValue();
        currentPriorityPageNumber         = (counterForPriorityJobs/limitSizeForPriorityJobs)+1;
          }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
        }
       
        public void previousForPriorityJobs(){
            try{
            priorityJobsToShow.clear();
            counterForPriorityJobs=counterForPriorityJobs-limitSizeForPriorityJobs;       
                for(Integer i=counterForPriorityJobs;i<(counterForPriorityJobs+limitSizeForPriorityJobs); i++){
                priorityJobsToShow.add(lstpriorityJobsNew.get(i));
            }
            totalPriorityJobPages = Math.ceil((decimal.valueOf(totalSizeForPriorityJobs))/(decimal.valueOf(limitSizeForPriorityJobs))).intValue();
        currentPriorityPageNumber         = (counterForPriorityJobs/limitSizeForPriorityJobs)+1;
           }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
        }
    
        public void lastForPriorityJobs (){
            try{
            priorityJobsToShow.clear();
            if(math.mod(totalSizeForPriorityJobs , limitSizeForPriorityJobs) == 0){
                counterForPriorityJobs = limitSizeForPriorityJobs * ((totalSizeForPriorityJobs/limitSizeForPriorityJobs)-1);
            } else if (math.mod(totalSizeForPriorityJobs , limitSizeForPriorityJobs) != 0){
                counterForPriorityJobs = limitSizeForPriorityJobs * ((totalSizeForPriorityJobs/limitSizeForPriorityJobs));
            }
            for(Integer i=counterForPriorityJobs-1;i<totalSizeForPriorityJobs-1;i++){
                    priorityJobsToShow.add(lstpriorityJobsNew.get(i));
            }
            totalPriorityJobPages = Math.ceil((decimal.valueOf(totalSizeForPriorityJobs))/(decimal.valueOf(limitSizeForPriorityJobs))).intValue();
        currentPriorityPageNumber         = (counterForPriorityJobs/limitSizeForPriorityJobs)+1;
           }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
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
 /***********************************************************************************************************************************
Purpose: Method to paginate dormant jobs.
Parameters: list of dormant jobs
Returns: 

************************************************************************************************************************************/       
  
       public void paginationMethodForDormantJobs(List<Amr_Job_Allocation__c> jobListToDisplay){
        try{
           dormantJobsToShow = new list<Amr_Job_Allocation__c>();
           lstDormantJobsNew = new List<Amr_Job_Allocation__c>();
           totalSizeForDormantJobs = jobListToDisplay.size();
           if(limitSizeForDormantJobs < totalSizeForDormantJobs){
           showPageButtonForDormant = true;
           }else{
           showPageButtonForDormant = false;
           }
            
            if(!jobListToDisplay.isEmpty()){
              List<Amr_Job_Allocation__c> lstDormant = new List<Amr_Job_Allocation__c>();
                
              lstDormant = jobListToDisplay;
              dormantJobsToShow = new List<Amr_Job_Allocation__c>();
              rapJobPortFolioHelper.removeDuplicateDormant(lstDormant,dormantJobsToShow);
              lstDormantJobsNew = dormantJobsToShow;
              totalSizeForDormantJobs = dormantJobsToShow.size();
            }
              dormantJobsToShow = new List<Amr_Job_Allocation__c>();
             //Intial adding
            //check the total records are more than limitSizeForPriorityJobs and assign the records
            if((counterForDormantJobs+limitSizeForDormantJobs) <= totalSizeForDormantJobs){
                for(Integer i=0;i<limitSizeForDormantJobs;i++){
                    dormantJobsToShow.add(lstDormantJobsNew.get(i));
                }
            }else{
                for(Integer i=0;i<totalSizeForDormantJobs;i++){
                    dormantJobsToShow.add(lstDormantJobsNew.get(i));
                }
            }
            totalDormantJobPages = Math.ceil((decimal.valueOf(totalSizeForDormantJobs))/(decimal.valueOf(limitSizeForDormantJobs))).intValue();
        currentDormantPageNumber         = (counterForDormantJobs/limitSizeForDormantJobs)+1;
         }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }   
          }
            
        public void beginningForDormantJobs(){
            try{
            dormantJobsToShow.clear();
            counterForDormantJobs=0;
            if((counterForDormantJobs + limitSizeForDormantJobs) <= totalSizeForDormantJobs){
                for(Integer i=0;i<limitSizeForDormantJobs;i++){
                    dormantJobsToShow.add(lstDormantJobsNew.get(i));
                }   
            }else{
                for(Integer i=0;i<totalSizeForDormantJobs;i++){
                    dormantJobsToShow.add(lstDormantJobsNew.get(i));
                }       
            }
             totalDormantJobPages = Math.ceil((decimal.valueOf(totalSizeForDormantJobs))/(decimal.valueOf(limitSizeForDormantJobs))).intValue();
        currentDormantPageNumber         = (counterForDormantJobs/limitSizeForDormantJobs)+1;
           }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
        }
       
        public void nextForDormantJobs(){
            try{
            dormantJobsToShow.clear();
            counterForDormantJobs = counterForDormantJobs+limitSizeForDormantJobs;
            if((counterForDormantJobs+limitSizeForDormantJobs) <= totalSizeForDormantJobs){
                for(Integer i=counterForDormantJobs;i<(counterForDormantJobs+limitSizeForDormantJobs);i++){
                    dormantJobsToShow.add(lstDormantJobsNew.get(i));
                }
            } else{
                for(Integer i=counterForDormantJobs;i<totalSizeForDormantJobs;i++){
                    dormantJobsToShow.add(lstDormantJobsNew.get(i));
                }
            }
             totalDormantJobPages = Math.ceil((decimal.valueOf(totalSizeForDormantJobs))/(decimal.valueOf(limitSizeForDormantJobs))).intValue();
        currentDormantPageNumber         = (counterForDormantJobs/limitSizeForDormantJobs)+1;
           }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
        }
       
        public void previousForDormantJobs(){
            try{
            dormantJobsToShow.clear();
            counterForDormantJobs=counterForDormantJobs-limitSizeForDormantJobs;       
                for(Integer i=counterForDormantJobs;i<(counterForDormantJobs+limitSizeForDormantJobs); i++){
                dormantJobsToShow.add(lstDormantJobsNew.get(i));
            }
             totalDormantJobPages = Math.ceil((decimal.valueOf(totalSizeForDormantJobs))/(decimal.valueOf(limitSizeForDormantJobs))).intValue();
        currentDormantPageNumber         = (counterForDormantJobs/limitSizeForDormantJobs)+1;
           }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
        }
    
        public void lastForDormantJobs (){
            try{
            dormantJobsToShow.clear();
            if(math.mod(totalSizeForDormantJobs , limitSizeForDormantJobs) == 0){
                counterForDormantJobs = limitSizeForDormantJobs * ((totalSizeForDormantJobs/limitSizeForDormantJobs)-1);
            } else if (math.mod(totalSizeForDormantJobs , limitSizeForPriorityJobs) != 0){
                counterForDormantJobs = limitSizeForDormantJobs * ((totalSizeForDormantJobs/limitSizeForDormantJobs));
            }
            for(Integer i=counterForDormantJobs-1;i<totalSizeForDormantJobs-1;i++){
                    dormantJobsToShow.add(lstDormantJobsNew.get(i));
            }
             totalDormantJobPages = Math.ceil((decimal.valueOf(totalSizeForDormantJobs))/(decimal.valueOf(limitSizeForDormantJobs))).intValue();
        currentDormantPageNumber         = (counterForDormantJobs/limitSizeForDormantJobs)+1;
            }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
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
 /***********************************************************************************************************************************
Purpose: Method to paginate live jobs.
Parameters: list of live jobs.
Returns: 

************************************************************************************************************************************/ 
 
       public void paginationMethodForLiveJobs(List<Amr_Job_Allocation__c> jobListToDisplay){
        try{
           liveJobsToShow = new list<Amr_Job_Allocation__c>();
           lstLiveJobsNew = new List<Amr_Job_Allocation__c>();
           totalSizeForLiveJobs = jobListToDisplay.size();
        
           if(limitSizeForLiveJobs < totalSizeForLiveJobs){
           showPageButtonForLive = true;
           }else{
           showPageButtonForLive = false;
           }
                   
             if(!jobListToDisplay.isEmpty()){
              List<Amr_Job_Allocation__c> lstLive = new List<Amr_Job_Allocation__c>();
                
              lstLive = jobListToDisplay;
              
              rapJobPortFolioHelper.removeDuplicateLive(lstLive,liveJobsToShow);
              lstLiveJobsNew = liveJobsToShow;
              totalSizeForLiveJobs = lstLiveJobsNew.size();
              
            }
             liveJobsToShow = new List<Amr_Job_Allocation__c>();
             //Intial adding
            //check the total records are more than limitSizeForPriorityJobs and assign the records
            if((counterForLiveJobs+limitSizeForLiveJobs) <= totalSizeForLiveJobs){
                for(Integer i=0;i<limitSizeForLiveJobs;i++){
                    liveJobsToShow.add(lstLiveJobsNew.get(i));
                }
            }else{
                for(Integer i=0;i<totalSizeForLiveJobs;i++){
                    liveJobsToShow.add(lstLiveJobsNew.get(i));
                }
            }
             totalLiveJobPages = Math.ceil((decimal.valueOf(totalSizeForLiveJobs))/(decimal.valueOf(limitSizeForLiveJobs))).intValue();
        currentLivePageNumber         = (counterForLiveJobs/limitSizeForLiveJobs)+1;
          }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }  
          }
            
        public void beginningForLiveJobs(){
            try{
            liveJobsToShow.clear();
            counterForLiveJobs=0;
            if((counterForLiveJobs + limitSizeForLiveJobs) <= totalSizeForLiveJobs){
                for(Integer i=0;i<limitSizeForLiveJobs;i++){
                    liveJobsToShow.add(lstLiveJobsNew.get(i));
                }   
            }else{
                for(Integer i=0;i<totalSizeForLiveJobs;i++){
                    liveJobsToShow.add(lstLiveJobsNew.get(i));
                }       
            }
             totalLiveJobPages = Math.ceil((decimal.valueOf(totalSizeForLiveJobs))/(decimal.valueOf(limitSizeForLiveJobs))).intValue();
        currentLivePageNumber         = (counterForLiveJobs/limitSizeForLiveJobs)+1;
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }    
        }
       
        public void nextForLiveJobs(){
            try{
            liveJobsToShow.clear();
            counterForLiveJobs = counterForLiveJobs+limitSizeForLiveJobs;
            if((counterForLiveJobs+limitSizeForLiveJobs) <= totalSizeForLiveJobs){
                for(Integer i=counterForLiveJobs;i<(counterForLiveJobs+limitSizeForLiveJobs);i++){
                    liveJobsToShow.add(lstLiveJobsNew.get(i));
                }
            } else{
                for(Integer i=counterForLiveJobs;i<totalSizeForLiveJobs;i++){
                    liveJobsToShow.add(lstLiveJobsNew.get(i));
                }
            }
             totalLiveJobPages = Math.ceil((decimal.valueOf(totalSizeForLiveJobs))/(decimal.valueOf(limitSizeForLiveJobs))).intValue();
        currentLivePageNumber         = (counterForLiveJobs/limitSizeForLiveJobs)+1;
           }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
        }
       
        public void previousForLiveJobs(){
            try{
            liveJobsToShow.clear();
            counterForLiveJobs=counterForLiveJobs-limitSizeForLiveJobs;       
                for(Integer i=counterForLiveJobs;i<(counterForLiveJobs+limitSizeForLiveJobs); i++){
                liveJobsToShow.add(lstLiveJobsNew.get(i));
            }
             totalLiveJobPages = Math.ceil((decimal.valueOf(totalSizeForLiveJobs))/(decimal.valueOf(limitSizeForLiveJobs))).intValue();
        currentLivePageNumber         = (counterForLiveJobs/limitSizeForLiveJobs)+1;
          }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
        }
    
        public void lastForLiveJobs (){
            try{
            liveJobsToShow.clear();
            if(math.mod(totalSizeForLiveJobs , limitSizeForLiveJobs) == 0){
                counterForLiveJobs = limitSizeForLiveJobs * ((totalSizeForLiveJobs/limitSizeForLiveJobs)-1);
                
            } else if (math.mod(totalSizeForLiveJobs , limitSizeForLiveJobs) != 0){
                counterForLiveJobs = limitSizeForLiveJobs * ((totalSizeForLiveJobs/limitSizeForLiveJobs));
                
            }
          
            for(Integer i=counterForLiveJobs-1;i<totalSizeForLiveJobs-1;i++){
                    liveJobsToShow.add(lstLiveJobsNew.get(i));
            }
             totalLiveJobPages = Math.ceil((decimal.valueOf(totalSizeForLiveJobs))/(decimal.valueOf(limitSizeForLiveJobs))).intValue();
        currentLivePageNumber         = (counterForLiveJobs/limitSizeForLiveJobs)+1;
           }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
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
 
 /***********************************************************************************************************************************
Purpose: Method to redirect selected job to jobsheet page.
Parameters: 
Returns: pageRef.

************************************************************************************************************************************/   
     public PageReference jobSheetPageTransfer(){
          try{
           PageReference pageRef = new PageReference(Label.Amr_JobSheet);
           pageRef.getParameters().put('id',chosenId);
           pageRef.setRedirect(true);
           return pageRef;
           }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
            return null;
          }
       }
 /***********************************************************************************************************************************
Purpose: Method to get alert records.Also it will retrive today's alert count.
Parameters: 
Returns: 

************************************************************************************************************************************/   
        public void alertHide(){
            try{
            
            List<Amr_Alert__c> alertHideList = new List<Amr_Alert__c>();
            alertHideList = [SELECT Alert_Message__c,Hide__c FROM Amr_Alert__c where id = :selectedAlert limit 50000];
           if(!alertHideList.isEmpty()){
            
            for(Amr_Alert__c alertObj : alertHideList){
                alertObj .Hide__c = TRUE;
            }
            update alertHideList;
           }
           alertList = [select Id,Alert_Message__c,job_Id__r.AdManagerText__c,New_Alert__c,Job_Id__c from Amr_Alert__c where ownerId =:loggedInUserId AND Hide__c =:false AND New_Alert__c= today limit 50000];          
           totalAlertCount =  [select count() from Amr_Alert__c where ownerId =:loggedInUserId AND Hide__c =:false AND New_Alert__c= today limit 50000];
          }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
          }
        }
        
        public pageReference clearJob(){
             try{   
                PageReference pageRef = new PageReference(Label.Amr_RAPJobPortFolio);
                pageRef.setRedirect(true);
                return pageRef;
             }catch(Exception ex){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
             system.debug(ex.getMessage());
             return null;
             }     
        return null;
        }
    
    }