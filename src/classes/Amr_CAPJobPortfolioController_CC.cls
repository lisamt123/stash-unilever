/*************************************************************************************************************************************
Name: Amr_CAPJobPortfolioController_CC
Copyright © 2015 Salesforce
======================================================
Purpose:This class has search and sort functionality of CAP User.Also this class holds active and cancel jobs related activities. 
-------
======================================================
History
-------
VERSION     AUTHOR             DATE           DETAIL           Description
1.0         Mindtree           23/12/2015     INITIAL DEV      CSR:
*************************************************************************************************************************************/
global with sharing class Amr_CAPJobPortfolioController_CC {
    public list<Amr_Job_Allocation__c>jobDetailList {get;set;}
    public list<Amr_Job_Allocation__c>jobDetailCancellationList {get;set;}
    public Amr_Job_Allocation__c jobAllocation {get;set;}
    public Amr_Job_Details__c jobDetails {get;set;}
    public String location{get;set;}
    public String projectLeaderEmail{get;set;}
    public String broadcastMarket{get;set;}
    public String productionActivityText{get;set;}
    public String startDate{get;set;}
    public String endDate{get;set;} 
    public String categoryName{get;set;}
    public String brandPos{get;set;}
    public String brandName{get;set;}
    public String allocatedBudget{get;set;}
    public String userName{get;set;}
    public String acceptedString;
    public String cancelledString;
    public String selectedSortJobsOption{get;set;}
    public String selectedSortCancelOption{get;set;}
    public List<SelectOption> listOfCategory{get;set;} 
    public List<SelectOption> listOfBrandPosition{get;set;}
    public  List<SelectOption> listOfBrand{get;set;}
    public  List<SelectOption> listOfSortOptions{get;set;}
    public  List<SelectOption> listOfUser {get;set;}
    transient List<Amr_Project_Details__c> projNameList {get;set;}
    public List<wrapperClass> wrapperList {get;set;}
    public Id chosenId {get; set;}
    public List<Amr_Job_Allocation__c>activeJobsToShow{get;set;}
    public List<WrapperClass>cancelJobsToShow{get;set;}
    public Integer totalSizeForActiveJobs =0;
    public Integer limitSizeForActiveJobs=100;
    public Integer counterForActiveJobs=0;
    public Integer totalSizeForCancelJobs =0;
    public Integer limitSizeForCancelJobs=100;
    public Integer counterForCancelJobs=0;
    public Boolean showPageButtonForCancel {get;set;}
    public Boolean showPageButtonForActive {get;set;}
    public List<Amr_Alert__c> alertList{get;set;}
    public Amr_Alert__c hideAlertObj{get;set;}
    public List<Amr_Alert__c>unHideAlertList{get;set;}
    public static final String NONE = '--None--';
    public static final String PERCENT = '%\'';
    public Id loggedInUserId {get;set;}
    public Integer TotalJobs {get; set;}
    public Integer TotalPendingJobs {get; set;}
    public Integer TotalLiveJobs {get; set;}
    public Integer TotalPriorityJobs {get; set;}
    public Integer TotalDormantJobs  {get; set;}
    public Integer TotalSavingsJobs  {get; set;}
    public Integer TotalActiveJobPages  {get; set;}
    public Integer CurrentActivePageNumber {get;set;}
    public Integer totalCancelJobPages  {get; set;}
    public Integer currentCancelPageNumber {get;set;} 
    public String  projectNameText {get;set;}   
    public String acceptedAndEmailSend{get;set;}
    public List<SelectOption> rapNameList{get;set;} 
    public String selectedRapName{get;set;}
    transient  String[]  listString{get;set;}
    transient  String[]  categoryString{get;set;}
    
   
    public Amr_CAPJobPortfolioController_CC(){
        try{
        jobAllocation =new Amr_Job_Allocation__c();
        jobDetails =new Amr_Job_Details__c();
        alertList = new List<Amr_Alert__c>();
        hideAlertObj = new Amr_Alert__c();
        unHideAlertList = new List<Amr_Alert__c>();
        loggedInUserId = UserInfo.getUserId();
        projNameList= [Select Name from Amr_Project_Details__c ORDER BY Name ASC limit 10000];
        listString= new list<string>();
      //  listString.add(NONE);
        for(Amr_Project_Details__c i : projNameList){
            listString.add(i.name);
        }
        
         Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
        categoryString = new list<string>();
        Set<MDO_Category__c> categorylst = utiltyObj.categoryValues();
        for(MDO_Category__c mdCat : categorylst){
            categoryString.add(mdCat.name);
        }
        
        listOfBrandPosition = new List<SelectOption>();
        listOfBrandPosition.add(new selectOption(NONE,NONE));
        rapNameList = new list<selectoption>();
         rapNameList.add(new SelectOption(Amr_ConstantForAdManager.NONE,Amr_ConstantForAdManager.NONE));
          for(PermissionSetAssignment  userObj :[select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name = :Label.Amr_RAP order by Assignee.name] ){

            SelectOption obj=new SelectOption(userObj.Assignee.id,userObj.Assignee.name);
            rapNameList.add(obj);
  
        }
     getJobSearchDetails();
      
    //cancellation
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            
            system.debug(ex.getMessage());
            
        }
    }
    
/***********************************************************************************************************************************
Purpose: Method to pass category records to page.
Parameters: 
Returns: It will return category records in JSON format.

************************************************************************************************************************************/  
        
   public String getCategoryList(){ 
       return JSON.serialize(categoryString);
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
       
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
            return null;
        }
        return null;

    }
  
/***********************************************************************************************************************************
Purpose: Method to get brand records from utility class.
Parameters: 
Returns: It will return list of brands.

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
        return listOfBrand;
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
            return null;
        }
    }
/***********************************************************************************************************************************
Purpose: Method to get RAP user records.
Parameters: 
Returns: It will return list of RAP users.

************************************************************************************************************************************/     
     public List<SelectOption> getUserList(){
        try{
     listOfUser = new List<SelectOption>();
     listOfUser.add(new selectOption(NONE,NONE));
     List<PermissionSetAssignment> PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name ='RAP' order by Assignee.name limit 50000];
    if(PermissionSetAssignmentList.size()>0){
 
     for(PermissionSetAssignment permissionObj:PermissionSetAssignmentList){
                
             listOfUser.add(new selectOption(permissionObj.Assignee.id,permissionObj.Assignee.Name));
         } 
      }
         return listOfUser;
         }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
            return null;
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
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Project_Leader_Country__c','Location Of Unilever Project Leader(Country)'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.ProductCategory__c','Category'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Brand_Position__c','Brand Positioning'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Brand_Final__c','Brand Name'));
       //  listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Project_Details__c','Project Name'));
       
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Allocated_Budget_euro__c','Allocated Budget(Euro)'));
        // listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Brodcast_Market__c','Broadcast Market'));
        // listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Production_Activity_Type__c','Production activity type'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Campaign_Name__c','Campaign Name'));
         listOfSortOptions.add(new selectOption('User__c','RAP Allocated'));
         listOfSortOptions.add(new selectOption('Job_Status__c','Accepted And Email Sent'));
        /* listOfSortOptions.add(new selectOption('Job_Status__c','Accepted'));
         listOfSortOptions.add(new selectOption('Started__c','Started'));
         listOfSortOptions.add(new selectOption('Reported__c','Reported'));
         listOfSortOptions.add(new selectOption('Job_Shared__c','Shared'));*/
         return listOfSortOptions;
     }
/***********************************************************************************************************************************
Purpose: Method holds search functionality.
Parameters: 
Returns: 
N-Path :
Search functionality is implemented and SOQL is built dynamically so can not break 'if' decision points from this method
************************************************************************************************************************************/   
    public Pagereference getJobSearchDetails(){
        try{

    //job list
    jobDetailList = new list<Amr_Job_Allocation__c>();
    acceptedString='Accepted';
    cancelledString='Cancelled';
    string soql ='select AM_Job_Detail__r.Lead_Agency_Name_Other__c,AM_Job_Detail__r.ProductionActivityTextArea__c,AM_Job_Detail__r.Campaign_Name__c,Started__c,AM_Job_Detail__r.Project_Name_Other__c,Started_Image__c,User__r.email,User__r.Name,Reported__c,Job_Shared__c,Job_Status__c,Job_Allocated_Image__c,Reported_Image__c ,Job_Allocated__c,Job_Status_Image__c,User__c,AM_Job_Detail__r.Project_Details__r.Name,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Job_Status__c ,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.ProductCategory__r.Name,AM_Job_Detail__r.Brand_Position__r.Name,AM_Job_Detail__r.Brand_Final__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,id from Amr_Job_Allocation__c where Job_Status__c != '+'\'Cancelled\' AND AM_Job_Detail__r.Job_Cancelled__c = false ';
    
    //cancellation
    jobDetailCancellationList = new list<Amr_Job_Allocation__c>();
    string soqlForCancel ='select AM_Job_Detail__r.Lead_Agency_Name_Other__c,AM_Job_Detail__r.ProductionActivityTextArea__c,AM_Job_Detail__r.Campaign_Name__c,Started__c,AM_Job_Detail__r.Project_Name_Other__c,Started_Image__c,User__r.email,User__r.Name,Reported__c,Job_Shared__c,Job_Status__c,Job_Allocated_Image__c,Reported_Image__c ,Job_Allocated__c,Job_Status_Image__c,User__c,AM_Job_Detail__r.Project_Details__r.Name,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Job_Status__c ,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.ProductCategory__r.Name,AM_Job_Detail__r.Brand_Position__r.Name,AM_Job_Detail__r.Brand_Final__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,id from Amr_Job_Allocation__c where Job_Status__c= '+'\'Cancelled\'AND AM_Job_Detail__r.Job_Cancelled__c = true ';

    
    //search
     String   addNumber = jobDetails.AdManagerText__c;
       String  projEmail = jobDetails.Unilever_Project_Leader_Email__c;
       String projectName = jobDetails.Project_Details__c;
   // soqlForCancel = soql;
     
     /*
     N-Path:
     SOQL is built dynamically, to search the records that user provided values on search fields in 'Search and Filter' section on Job Portfolio Page
     There are around 15 fields on which user can search the records within AdManager tool
     */
    if (String.isNotBlank(String.valueOf(jobDetails.Start_Date__c))){
        Datetime startdate = jobDetails.Start_Date__c;
        String dateTimeFormat = startdate.format(Amr_ConstantForAdManager.DATEFORMAT);
        
        soql += Amr_ConstantForAdManager.CREATED_DATE +  ' >= '+  dateTimeFormat ;
        soqlForCancel += Amr_ConstantForAdManager.CREATED_DATE +  ' >= '+ dateTimeFormat;
          
    }
    
    if (String.isNotBlank(String.valueOf(jobDetails.End_Date__c))){ 
        Datetime endate  = jobDetails.End_Date__c;
         String dateTimeFormat1 = endate.format(Amr_ConstantForAdManager.DATEFORMAT);
        
         soql += Amr_ConstantForAdManager.CREATED_DATE +  ' < '+  dateTimeFormat1 ;
         soqlForCancel += Amr_ConstantForAdManager.CREATED_DATE +  ' < '+ dateTimeFormat1;
          
    }
    
      if(String.isNotBlank(categoryName)){
      
    soql += ' and AM_Job_Detail__r.ProductCategory__r.Name LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(categoryName)+Amr_ConstantForAdManager.PERCENTAGESLASH;
    soqlForCancel += ' and AM_Job_Detail__r.ProductCategory__r.Name LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(categoryName)+Amr_ConstantForAdManager.PERCENTAGESLASH;
         
     }
      if(String.isNotBlank(brandPos)){
      
    soql += ' and AM_Job_Detail__r.Brand_Position__r.name LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(brandPos)+Amr_ConstantForAdManager.PERCENTAGESLASH;
    soqlForCancel +=' and AM_Job_Detail__r.Brand_Position__r.name LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(brandPos)+Amr_ConstantForAdManager.PERCENTAGESLASH;
          
     }
      if(String.isNotBlank(brandName) ){
    soql += ' and AM_Job_Detail__r.Brand_Final__r.name LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(brandName)+Amr_ConstantForAdManager.PERCENTAGESLASH;
    soqlForCancel += ' and AM_Job_Detail__r.Brand_Final__r.name LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(brandName)+Amr_ConstantForAdManager.PERCENTAGESLASH;
          
     }
     
     if (String.isNotBlank(jobDetails.Project_Leader_Cluster__c)){
     
           soql += ' and AM_Job_Detail__r.Project_Leader_Cluster__c = \''+String.escapeSingleQuotes(jobDetails.Project_Leader_Cluster__c)+Amr_ConstantForAdManager.SLASH;
            soqlForCancel +=' and AM_Job_Detail__r.Project_Leader_Cluster__c = \''+String.escapeSingleQuotes(jobDetails.Project_Leader_Cluster__c)+Amr_ConstantForAdManager.SLASH;
          
    }
    
     if(String.isNotBlank(jobDetails.Project_Leader_Country__c)){
    soql += ' and AM_Job_Detail__r.Project_Leader_Country__c = \''+String.escapeSingleQuotes(jobDetails.Project_Leader_Country__c)+Amr_ConstantForAdManager.SLASH;
     soqlForCancel +=' and AM_Job_Detail__r.Project_Leader_Country__c = \''+String.escapeSingleQuotes(jobDetails.Project_Leader_Country__c)+Amr_ConstantForAdManager.SLASH;
                      
    }
   
     if(String.isNotBlank(jobDetails.Lead_Creative_Agency_name__c)){
    soql += ' and AM_Job_Detail__r.Lead_Creative_Agency_name__c = \''+String.escapeSingleQuotes(jobDetails.Lead_Creative_Agency_name__c)+Amr_ConstantForAdManager.SLASH;
    soqlForCancel +=' and AM_Job_Detail__r.Lead_Creative_Agency_name__c = \''+String.escapeSingleQuotes(jobDetails.Lead_Creative_Agency_name__c)+Amr_ConstantForAdManager.SLASH;
          
     
     }

      if(String.isNotBlank(broadcastMarket)){
      String broadcastData = broadcastMarket.replace(';',Amr_ConstantForAdManager.COMMA);
    soql += ' and AM_Job_Detail__r.BroadcastMarketText__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(broadcastData)+Amr_ConstantForAdManager.PERCENTAGESLASH;
    soqlForCancel += ' and AM_Job_Detail__r.BroadcastMarketText__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(broadcastData)+Amr_ConstantForAdManager.PERCENTAGESLASH;
}
    if(String.isNotBlank(jobDetails.Stage_of_Production_Activity__c)){
    soql += ' and AM_Job_Detail__r.Stage_of_Production_Activity__c = \''+String.escapeSingleQuotes(jobDetails.Stage_of_Production_Activity__c)+Amr_ConstantForAdManager.SLASH;
    soqlForCancel +=  ' and AM_Job_Detail__r.Stage_of_Production_Activity__c = \''+String.escapeSingleQuotes(jobDetails.Stage_of_Production_Activity__c)+Amr_ConstantForAdManager.SLASH;
          
     }
   
    if(String.isNotBlank(jobDetails.AdManagerText__c)){
    soql += ' and AM_Job_Detail__r.AdManagerText__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(jobDetails.AdManagerText__c)+Amr_ConstantForAdManager.PERCENTAGESLASH;
    soqlForCancel += ' and AM_Job_Detail__r.AdManagerText__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(jobDetails.AdManagerText__c)+Amr_ConstantForAdManager.PERCENTAGESLASH;
          
     }
     if(String.isNotBlank(jobDetails.Unilever_Project_Leader_Email__c)){
    soql += ' and AM_Job_Detail__r.Unilever_Project_Leader_Email__c LIKE \''+String.escapeSingleQuotes(jobDetails.Unilever_Project_Leader_Email__c)+PERCENT;
    soqlForCancel += ' and AM_Job_Detail__r.Unilever_Project_Leader_Email__c LIKE \''+String.escapeSingleQuotes(jobDetails.Unilever_Project_Leader_Email__c)+PERCENT;
     }
     if(String.isNotBlank(jobDetails.Project_Details__c)){
    soql += ' and AM_Job_Detail__r.Project_Details__c = \''+String.escapeSingleQuotes(jobDetails.Project_Details__c)+Amr_ConstantForAdManager.SLASH;
    soqlForCancel +=' and AM_Job_Detail__r.Project_Details__c = \''+String.escapeSingleQuotes(jobDetails.Project_Details__c)+Amr_ConstantForAdManager.SLASH;
           
     }
     
      if(String.isNotBlank(userName) && userName != NONE){
     soql += ' and User__c = \''+String.escapeSingleQuotes(userName)+Amr_ConstantForAdManager.SLASH;
     soqlForCancel +=' and User__c = \''+String.escapeSingleQuotes(userName)+Amr_ConstantForAdManager.SLASH;
          
     }
     
      if(String.isNotBlank(jobAllocation.Job_Allocated__c)){
     soql += ' and Job_Allocated__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Allocated__c)+Amr_ConstantForAdManager.SLASH;
     soqlForCancel +=' and Job_Allocated__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Allocated__c)+Amr_ConstantForAdManager.SLASH;
           
     }
       if(String.isNotBlank(jobAllocation.Job_Shared__c)){
     soql += ' and Job_Shared__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Shared__c)+Amr_ConstantForAdManager.SLASH;
     soqlForCancel +=' and Job_Shared__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Shared__c)+Amr_ConstantForAdManager.SLASH;
           
     }
     if(String.isNotBlank(jobAllocation.Reported__c)){
     soql += ' and Reported__c = \''+String.escapeSingleQuotes(jobAllocation.Reported__c)+Amr_ConstantForAdManager.SLASH;
     soqlForCancel +=' and Reported__c = \''+String.escapeSingleQuotes(jobAllocation.Reported__c)+Amr_ConstantForAdManager.SLASH;
          
     }
      if(String.isNotBlank(jobAllocation.Started__c)){
     soql += ' and Started__c = \''+String.escapeSingleQuotes(jobAllocation.Started__c)+Amr_ConstantForAdManager.SLASH;
     soqlForCancel +=' and Started__c = \''+String.escapeSingleQuotes(jobAllocation.Started__c)+Amr_ConstantForAdManager.SLASH;
          
     }
       if(String.isNotBlank(jobDetails.Project_Name_Other__c)){
     soql += ' and AM_Job_Detail__r.Project_Name_Other__c = \''+String.escapeSingleQuotes(jobDetails.Project_Name_Other__c)+Amr_ConstantForAdManager.SLASH;
     soqlForCancel +=' and AM_Job_Detail__r.Project_Name_Other__c = \''+String.escapeSingleQuotes(jobDetails.Project_Name_Other__c)+Amr_ConstantForAdManager.SLASH;
           
     }
     /*
        if(String.isNotBlank(jobAllocation.Job_Status__c)){
     soql += ' and Job_Status__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Status__c)+'\'';
     soqlForCancel +=' and Job_Status__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Status__c)+'\'';
           
     }
     */
      if(String.isNotBlank(jobDetails.Campaign_Name__c)){
            
     soql += ' and AM_Job_Detail__r.Campaign_Name__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(jobDetails.Campaign_Name__c)+Amr_ConstantForAdManager.PERCENTAGESLASH;
    soqlForCancel += ' and AM_Job_Detail__r.Campaign_Name__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(jobDetails.Campaign_Name__c)+Amr_ConstantForAdManager.PERCENTAGESLASH;
      }
       if(String.isNotBlank(selectedRapName) ){
           soql += ' and AM_Job_Detail__r.owner.Name LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(selectedRapName)+Amr_ConstantForAdManager.PERCENTAGESLASH;
           soqlForCancel += ' and AM_Job_Detail__r.owner.Name LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(selectedRapName)+Amr_ConstantForAdManager.PERCENTAGESLASH; 
       }
       
       if(String.isNotBlank(jobAllocation.Job_Allocated__c) && jobAllocation.Job_Allocated__c != Amr_ConstantForAdManager.NONE){
           soql += ' and Job_Allocated__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Allocated__c)+Amr_ConstantForAdManager.SLASH;
           soqlForCancel += ' and Job_Allocated__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Allocated__c)+Amr_ConstantForAdManager.SLASH; 
       }
       /*
       if(String.isNotBlank(jobAllocation.Job_Status__c) && jobAllocation.Job_Status__c != Amr_ConstantForAdManager.NONE){
           soql += ' and Job_Status__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Status__c)+Amr_ConstantForAdManager.SLASH;
           soqlForCancel += ' and Job_Status__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Status__c)+Amr_ConstantForAdManager.SLASH; 
       }
       */
       
       if(String.isNotBlank(location)){
            
     soql += ' and AM_Job_Detail__r.Project_Leader_Country__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(location)+Amr_ConstantForAdManager.PERCENTAGESLASH;
    soqlForCancel += ' and AM_Job_Detail__r.Project_Leader_Country__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(location)+Amr_ConstantForAdManager.PERCENTAGESLASH;
      }
      if(String.isNotBlank(projectLeaderEmail)){
        soql += ' and AM_Job_Detail__r.Unilever_Project_Leader_Email__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(projectLeaderEmail)+Amr_ConstantForAdManager.PERCENTAGESLASH;  //Amr_ConstantForAdManager.SLASH;
        soqlForCancel += ' and AM_Job_Detail__r.Unilever_Project_Leader_Email__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(projectLeaderEmail)+Amr_ConstantForAdManager.PERCENTAGESLASH;            
         }
     
     if(String.isNotBlank(addNumber)){
        soql += ' and AM_Job_Detail__r.AdManagerText__c LIKE \''+'%'+ String.escapeSingleQuotes(addNumber)+PERCENT;
        soqlForCancel += ' and AM_Job_Detail__r.AdManagerText__c LIKE \''+'%'+ String.escapeSingleQuotes(addNumber)+PERCENT;
              
         } /*
         if(String.isNotBlank(projEmail)){
        soql += ' and AM_Job_Detail__r.Unilever_Project_Leader_Email__c LIKE \''+String.escapeSingleQuotes(projEmail)+Percentage_str;
         soqlForCancel += ' and AM_Job_Detail__r.Unilever_Project_Leader_Email__c LIKE \''+String.escapeSingleQuotes(projEmail)+Percentage_str;
              
         } */ /* to project name dropdown
         if(String.isNotBlank(projectName)){
        soql += ' and AM_Job_Detail__r.Project_Details__c = \''+String.escapeSingleQuotes(projectName)+'\'';
         soqlForCancel += ' and AM_Job_Detail__r.Project_Details__c = \''+String.escapeSingleQuotes(projectName)+'\'';
              
         }
         */
         if(String.isNotBlank(projectNameText)){
        soql += ' and AM_Job_Detail__r.Project_Details__r.Name LIKE \''+'%'+String.escapeSingleQuotes(projectNameText)+PERCENT;  //'\'';
         soqlForCancel += ' and AM_Job_Detail__r.Project_Details__r.Name LIKE \''+'%'+String.escapeSingleQuotes(projectNameText)+PERCENT; //'\'';
              
         }

         if(String.isNotBlank(jobDetails.Project_Name_Other__c)){
        soql += ' and AM_Job_Detail__r.Project_Name_Other__c = \''+String.escapeSingleQuotes(jobDetails.Project_Name_Other__c)+Amr_ConstantForAdManager.SLASH;
        soqlForCancel += ' and AM_Job_Detail__r.Project_Name_Other__c = \''+String.escapeSingleQuotes(jobDetails.Project_Name_Other__c)+Amr_ConstantForAdManager.SLASH;
              
         }
         
         if(String.isNotBlank(acceptedAndEmailSend) &&  acceptedAndEmailSend != Amr_ConstantForAdManager.NONE){
        
            if(acceptedAndEmailSend == 'Yes'){
                soql += ' and Job_Status__c = \''+String.escapeSingleQuotes(Label.Amr_Accepted)+Amr_ConstantForAdManager.SLASH;
                soqlForCancel += ' and Job_Status__c = \''+String.escapeSingleQuotes(Label.Amr_Accepted)+Amr_ConstantForAdManager.SLASH;
            }
            else{
                soql += ' and Job_Status__c != \''+String.escapeSingleQuotes(Label.Amr_Accepted)+Amr_ConstantForAdManager.SLASH;
                soqlForCancel += ' and Job_Status__c != \''+String.escapeSingleQuotes(Label.Amr_Accepted)+Amr_ConstantForAdManager.SLASH;
            }
        }
          /*
          if(String.isNotBlank(String.valueOf(jobDetails.Allocated_Budget_euro__c))){
          String allocatedBudget = String.valueOf(jobDetails.Allocated_Budget_euro__c).replace(',','');

        soql += ' and AM_Job_Detail__r.Allocated_Budget_euro__c = '+Double.valueOf(allocatedBudget);
        soqlForCancel += ' and AM_Job_Detail__r.Allocated_Budget_euro__c = '+Double.valueOf(allocatedBudget);
            
         }    */
         
         if(String.isNotBlank(allocatedBudget) ){
             soql += ' and AM_Job_Detail__r.Allocated_Budget_Euro_Text__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+ String.escapeSingleQuotes(allocatedBudget)+Amr_ConstantForAdManager.PERCENTAGESLASH;
             soqlForCancel += ' and AM_Job_Detail__r.Allocated_Budget_Euro_Text__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+ String.escapeSingleQuotes(allocatedBudget)+Amr_ConstantForAdManager.PERCENTAGESLASH;
        }
         
         /*
         if(String.isNotBlank(broadcastMarket)){
       
        soql += ' and AM_Job_Detail__r.Brodcast_Market__c = \''+String.escapeSingleQuotes(broadcastMarket)+Amr_ConstantForAdManager.SLASH ;  //'\'';
         soqlForCancel += ' and AM_Job_Detail__r.Brodcast_Market__c = \''+String.escapeSingleQuotes(broadcastMarket)+Amr_ConstantForAdManager.SLASH ; //'\'';      
        
         }    */
         if (String.isNotBlank(startDate)){
   //start date creation
               String[] startDateSplitQuote = startDate.split(' ');
               String[] startDateSplitSlash = startDateSplitQuote[0].split('/');
               Integer myIntDate = integer.valueOf(startDateSplitSlash[0]);
               Integer myIntMonth = integer.valueOf(startDateSplitSlash[1]);
               Integer myIntYear = integer.valueOf(startDateSplitSlash[2]);
               Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
               DateTime startDateFinal = DateTime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0);
                DateTime endDateFinal = DateTime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0).addDays(1);
         
      //         soql += ' and createdDate'+  ' >= '+ startDateFinal.formatGMT(Amr_ConstantForAdManager.SECDATEFORMAT) + ' and createdDate'+  ' < '+ endDateFinal.formatGMT(Amr_ConstantForAdManager.SECDATEFORMAT) ;
        //       soqlForCancel += ' and createdDate'+  ' = '+ startDateFinal.formatGMT(Amr_ConstantForAdManager.DATEFORMAT) ;
          soql += Amr_ConstantForAdManager.CREATED_DATE +  ' >= '+ startDateFinal.formatGMT(Amr_ConstantForAdManager.SECDATEFORMAT) ; 
          soqlForCancel += Amr_ConstantForAdManager.CREATED_DATE +  ' >= '+ startDateFinal.formatGMT(Amr_ConstantForAdManager.SECDATEFORMAT) ;   
               
    }
    
    //END DATE
    
    
    if (String.isNotBlank(endDate)){
    //end date creation
   String[] endDateSplitQuote = endDate.split(' ');
   String[] endDateSplitSlash = endDateSplitQuote[0].split(Amr_ConstantForAdManager.BACK_SLASH);
   Integer myIntDate1 = integer.valueOf(endDateSplitSlash[0]);
   Integer myIntMonth1 = integer.valueOf(endDateSplitSlash[1]);
   Integer myIntYear1 = integer.valueOf(endDateSplitSlash[2]);
   Date d1 = Date.newInstance(myIntYear1, myIntMonth1, myIntDate1);
   DateTime endDateDateFinal = DateTime.newInstance(d1.year(), d1.month(), d1.day(), 0, 0, 0);
  
           soql += Amr_ConstantForAdManager.CREATED_DATE +  ' < '+ endDateDateFinal.addDays(1).formatGMT(Amr_ConstantForAdManager.SECDATEFORMAT );
           soqlForCancel += Amr_ConstantForAdManager.CREATED_DATE +  ' < '+ endDateDateFinal.addDays(1).formatGMT(Amr_ConstantForAdManager.SECDATEFORMAT );
           
    }
    
    
     if(String.isNotBlank(selectedSortJobsOption) && selectedSortJobsOption!=NONE){
         if(selectedSortJobsOption == Label.Amr_Query_Category){
              soql += ' ORDER BY AM_Job_Detail__r.ProductCategory__r.Name ASC';   
         }else
         if(selectedSortJobsOption == Label.Amr_Query_BrandPosition){
            soql += ' ORDER BY AM_Job_Detail__r.Brand_Position__r.Name ASC'; 
         }
         else
         if(selectedSortJobsOption == Label.Amr_Query_BrandName){
            soql += ' ORDER BY AM_Job_Detail__r.Brand_Final__r.Name ASC'; 
         }
         else
         if(selectedSortJobsOption == Label.Amr_Query_Project_Detail){
            soql += ' ORDER BY AM_Job_Detail__r.Project_Details__r.Name ASC'; 
         }
         else
         if(selectedSortJobsOption == Label.Amr_Query_User){
            soql += ' ORDER BY User__r.Name ASC'; 
         }
         
         else{
          soql += ' ORDER BY '+String.escapeSingleQuotes(selectedSortJobsOption)+' ASC';
         }  
     }
     if(String.isNotBlank(selectedSortCancelOption) && selectedSortCancelOption!=NONE){
         if(selectedSortCancelOption == Label.Amr_Query_Category){
              soqlForCancel += ' ORDER BY AM_Job_Detail__r.ProductCategory__r.Name ASC';   
         }else
         if(selectedSortCancelOption == Label.Amr_Query_BrandPosition){
            soqlForCancel += ' ORDER BY AM_Job_Detail__r.Brand_Position__r.Name ASC'; 
         }
         else
         if(selectedSortCancelOption == Label.Amr_Query_BrandName){
            soqlForCancel += ' ORDER BY AM_Job_Detail__r.Brand_Final__r.Name ASC'; 
         }
         else
         if(selectedSortCancelOption == Label.Amr_Query_Project_Detail){
            soqlForCancel += ' ORDER BY AM_Job_Detail__r.Project_Details__r.Name ASC'; 
         }
         else
         if(selectedSortCancelOption == Label.Amr_Query_User){
            soqlForCancel += ' ORDER BY User__r.Name ASC'; 
         }
         else{
          soqlForCancel += ' ORDER BY '+String.escapeSingleQuotes(selectedSortCancelOption)+' ASC';
         }  
     }
   
     soql+=' limit 50000';
     soqlForCancel+=' limit 50000';
      
    Set<String> setJobAllocationId = new Set<String>();
     
    for(Amr_Job_Allocation__c sObj: Database.query(soql) ){
             if(!setJobAllocationId.contains(sObj.AM_Job_Detail__c+''+sObj.User__c)){
                setJobAllocationId.add(sObj.AM_Job_Detail__c+''+sObj.User__c);
                jobDetailList.add(sObj ) ;
             }
     }
   
    //cancellation
    jobDetailCancellationList = Database.query(soqlForCancel);
     paginationMethodForActiveJobs(jobDetailList);
       
     wrapperList = new List<wrapperClass>();
     Set<String> setJobAllocation = new Set<String>();
      for(Amr_Job_Allocation__c sObj: jobDetailCancellationList ){
             if(!setJobAllocation.contains(sObj.AM_Job_Detail__c+''+sObj.User__c)){
                setJobAllocation.add(sObj.AM_Job_Detail__c+''+sObj.User__c);
                WrapperList.add( new wrapperClass(false,sObj)) ;
             }
     }
        
    paginationMethodForCancelJobs(WrapperList);
    }catch(Exception ex){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
             return null;
            system.debug(ex.getMessage());
    }
    return null;
       
    }
        
  // Wrapper class include Sobject and select box
    @TestVisible public Class wrapperClass{
     
         Amr_CAPJobPortfolioController_CC objCap;
         Public Boolean SelectBox{get;set;}
         Public Amr_Job_Allocation__c sObjRec{get;set;}
        // Public Amr_Job_Details__c sObjRec{get;set;}
                
         Public wrapperClass(){
         }
         
         Public wrapperClass(Boolean checkbx, Amr_Job_Allocation__c sObjRecord){
            SelectBox = checkbx;
            sObjRec = sObjRecord;
         }
        }
 /***********************************************************************************************************************************
Purpose: Method to change status of cancel jobs to active jobs.
Parameters: 
Returns: 

************************************************************************************************************************************/      
    
       Public PageReference changwrapperClasseStatus(){
        try{
          List<Amr_Job_Allocation__c> selectList = New List<Amr_Job_Allocation__c>();
          List<Amr_Job_Details__c> selectJobDetailList = New List<Amr_Job_Details__c>();
          for(wrapperclass wc:WrapperList){
              if(wc.SelectBox){
                 selectList.add(wc.sObjRec); }
          }
          
          if(selectList.size() == 0){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Uncancel_Error));
             return null; 
          }
          
          if(selectList.size()>0){
            for(Amr_Job_Allocation__c obj : selectList ){
                selectJobDetailList.add(obj.AM_Job_Detail__r);
                
            }
           
           List<Amr_Job_Allocation__c> jobdetails1=[select id ,AM_Job_Detail__r.Lead_Agency_Name_Other__c,Name,AM_Job_Detail__r.Project_Name_Other__c ,AM_Job_Detail__r.id,Job_Status__c,AM_Job_Detail__c from Amr_Job_Allocation__c where Id IN:selectList];
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
           pageRef.getParameters().put('defaultSection','CancelList');
           pageRef.setRedirect(true);
           return pageRef;
           }
          else{
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Please_Select_Any_Value));
                return null;
          } 
          }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
            return null;
        }
     }
/***********************************************************************************************************************************
Purpose: Method to paginate active jobs.
Parameters: list of active jobs.
Returns: 

************************************************************************************************************************************/
      //pagination for active jobs starts here
   public void paginationMethodForActiveJobs(List<Amr_Job_Allocation__c> jobListToDisplay){
    try{
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
        
        TotalActiveJobPages = Math.ceil((decimal.valueOf(totalSizeForActiveJobs))/(decimal.valueOf(limitSizeForActiveJobs))).intValue();
        CurrentActivePageNumber         = (counterForActiveJobs/limitSizeForActiveJobs)+1;
                       
        //getTotalActiveJobPages(totalSizeForActiveJobs/limitSizeForActiveJobs);
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
      }
        
    public void beginningForActiveJobs(){
        try{
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
        
        TotalActiveJobPages = Math.ceil((decimal.valueOf(totalSizeForActiveJobs))/(decimal.valueOf(limitSizeForActiveJobs))).intValue();
        CurrentActivePageNumber = (counterForActiveJobs/limitSizeForActiveJobs)+1;
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
    }
   
    public void nextForActiveJobs(){
        try{
        activeJobsToShow.clear();
        counterForActiveJobs=counterForActiveJobs+limitSizeForActiveJobs;
               
        if((counterForActiveJobs+limitSizeForActiveJobs) <= totalSizeForActiveJobs ){
            for(Integer i=counterForActiveJobs;i<(counterForActiveJobs+limitSizeForActiveJobs);i++){
                activeJobsToShow.add(jobDetailList.get(i));
            }
        } else{
            for(Integer i=counterForActiveJobs;i<totalSizeForActiveJobs ;i++){
                activeJobsToShow.add(jobDetailList.get(i));
            }
        }
        
        TotalActiveJobPages = Math.ceil((decimal.valueOf(totalSizeForActiveJobs))/(decimal.valueOf(limitSizeForActiveJobs))).intValue();
        CurrentActivePageNumber = (counterForActiveJobs/limitSizeForActiveJobs)+1;
        
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        } 
    }
   
    public void previousForActiveJobs(){
        try{
        activeJobsToShow.clear();
        counterForActiveJobs=counterForActiveJobs-limitSizeForActiveJobs;       
            for(Integer i=counterForActiveJobs;i<(counterForActiveJobs+limitSizeForActiveJobs); i++){
            activeJobsToShow.add(jobDetailList.get(i));
        }
        
        TotalActiveJobPages = Math.ceil((decimal.valueOf(totalSizeForActiveJobs))/(decimal.valueOf(limitSizeForActiveJobs))).intValue();
        CurrentActivePageNumber = (counterForActiveJobs/limitSizeForActiveJobs)+1;
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
    }

    public void lastForActiveJobs (){
        try{
        activeJobsToShow.clear();
        if(math.mod(totalSizeForActiveJobs , limitSizeForActiveJobs) == 0){
            counterForActiveJobs = limitSizeForActiveJobs* ((totalSizeForActiveJobs /limitSizeForActiveJobs)-1);
        } else if (math.mod(totalSizeForActiveJobs , limitSizeForActiveJobs) != 0){
            counterForActiveJobs = limitSizeForActiveJobs* ((totalSizeForActiveJobs /limitSizeForActiveJobs));
        }
        for(Integer i=counterForActiveJobs -1;i<totalSizeForActiveJobs -1;i++){
                activeJobsToShow.add(jobDetailList.get(i));
        }
        
        TotalActiveJobPages = Math.ceil((decimal.valueOf(totalSizeForActiveJobs))/(decimal.valueOf(limitSizeForActiveJobs))).intValue();
        CurrentActivePageNumber = (counterForActiveJobs/limitSizeForActiveJobs)+1;
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
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
/***********************************************************************************************************************************
Purpose: Method to paginate cancel jobs.
Parameters: list of cancel jobs.
Returns: 

************************************************************************************************************************************/ 
    
   public void paginationMethodForCancelJobs(List<WrapperClass> jobListToDisplay){
    try{
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
        totalCancelJobPages = Math.ceil((decimal.valueOf(totalSizeForCancelJobs))/(decimal.valueOf(limitSizeForCancelJobs))).intValue();
        currentCancelPageNumber =(counterForCancelJobs / limitSizeForCancelJobs)+1;
         }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
      }
        
    public void beginningForCancelJobs(){
        try{
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
        totalCancelJobPages = Math.ceil((decimal.valueOf(totalSizeForCancelJobs))/(decimal.valueOf(limitSizeForCancelJobs))).intValue();
        currentCancelPageNumber =(counterForCancelJobs / limitSizeForCancelJobs)+1;
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
    }
   
    public void nextForCancelJobs(){
        try{
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
        totalCancelJobPages = Math.ceil((decimal.valueOf(totalSizeForCancelJobs))/(decimal.valueOf(limitSizeForCancelJobs))).intValue();
        currentCancelPageNumber =(counterForCancelJobs / limitSizeForCancelJobs)+1;
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
    }
   
    public void previousForCancelJobs(){
        try{
        cancelJobsToShow.clear();
        counterForCancelJobs  =counterForCancelJobs -limitSizeForCancelJobs;       
            for(Integer i=counterForCancelJobs;i<(counterForCancelJobs +limitSizeForCancelJobs); i++){
            cancelJobsToShow.add(WrapperList.get(i));
        }
        totalCancelJobPages = Math.ceil((decimal.valueOf(totalSizeForCancelJobs))/(decimal.valueOf(limitSizeForCancelJobs))).intValue();
        currentCancelPageNumber =(counterForCancelJobs / limitSizeForCancelJobs)+1;
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
    }

    public void lastForCancelJobs (){
        try{
        cancelJobsToShow.clear();
        if(math.mod(totalSizeForCancelJobs , limitSizeForCancelJobs) == 0){
            counterForCancelJobs = limitSizeForCancelJobs* ((totalSizeForCancelJobs /limitSizeForCancelJobs)-1);
        } else if (math.mod(totalSizeForCancelJobs , limitSizeForCancelJobs) != 0){
            counterForCancelJobs = limitSizeForCancelJobs* ((totalSizeForCancelJobs /limitSizeForCancelJobs));
        }
        for(Integer i=counterForCancelJobs -1;i<totalSizeForCancelJobs -1;i++){
                cancelJobsToShow.add(WrapperList.get(i));
        }
        totalCancelJobPages = Math.ceil((decimal.valueOf(totalSizeForCancelJobs))/(decimal.valueOf(limitSizeForCancelJobs))).intValue();
        currentCancelPageNumber =(counterForCancelJobs / limitSizeForCancelJobs)+1;
        }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
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
   public pageReference clearJob(){
         try{   
            PageReference pageRef = new PageReference(Label.Amr_CApJobPortFolio);
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