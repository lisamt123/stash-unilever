/*************************************************************************************************************************************
Name: Amr_SavingSummaryController_CC
Copyright © 2015 Salesforce
======================================================
Purpose:This class has search and sort functionality on submitted Savings.
-------
======================================================
History
-------
VERSION     AUTHOR             DATE           DETAIL           Description
1.0         Varuna Nikam       5/01/2016     INITIAL DEV      CSR:
*************************************************************************************************************************************/
public with sharing class Amr_SavingSummaryController_CC{

    public Amr_Saving__c savingObject {get;set;}
    public Amr_Quote__c quotesObj {get;set;}
    public List<SelectOption> shootLocation{get;set;}
    public List<String> selectedCountry{get;set;}
    public String numberOfAdditionalFilm{get;set;}
    public String savingPercentageAverageOfQuotes{get;set;}
    public String costPerMaster{get;set;}    
    public String costPerMasterPerShootDays{get;set;}
    public String startDate{get;set;}
    public String endDate{get;set;} 
    public List<Amr_Saving__c> savingSummaryList{get;set;}
    public  string userId;
    public String jobId ;
    public String films{get;set;}
    public Id chosenId {get; set;}
     public  String[]  categoryString{get;set;}
     public String categoryName{get;set;}
    public String brandPosName{get;set;}
    public String brandNameFromPage{get;set;} 
    //public static final String NONE ='--None--';
    public List<SelectOption> listOfBrandPosition{get;set;}
    public List<SelectOption> listOfBrand{get;set;}
    public  AggregateResult[] groupedSubmissionResultsCurrentMonth {get;set;}
     public  AggregateResult[] groupedSubmissionResultsYearToDate  {get;set;}
    public  AggregateResult[] groupedSubmissionResultsPrevYearToDate  {get;set;}
     public  AggregateResult[] groupedSubmissionResultsPrevYearCurrentMonth  {get;set;}
    public  AggregateResult[] groupedSavingResultsYearToDate1  {get;set;}
     public  AggregateResult[] groupedSavingResultsPrevYearToDate1  {get;set;}
     public  AggregateResult[] groupedSavingResultsPrevYearCurrentMonth1  {get;set;}
    public  AggregateResult[] groupedSavingResultsCurrentMonth  {get;set;}
    
   
    public AggregateResult[] yourYTDSpend{get;set;}
    public AggregateResult[] globalYTDSpend{get;set;}
    public AggregateResult[] savingActivitiesSubmitted{get;set;}
     public Id loggedInUserId {get;set;}
     set<id> jobDetailsId = new set<id> ();
    public  AggregateResult[] groupedSavingResultsCurrentMonth1  {get;set;}
  //  public  AggregateResult[] groupedSavingResultsPrevYear  {get;set;}
    
   // public  List<PieWedgeData>  pieSavingDataRap{get;set;}
    public  List<SelectOption> listOfSortOptions{get;set;}
    public String selectedSortJobsOption{get;set;}
    public Integer totalSizeForSummaryJobs =0;
    public Integer limitSizeForSummaryJobs=100; 
    public Integer counterForSummaryJobs=0;
    public Integer TotalActiveJobPages  {get; set;}
    public Integer CurrentActivePageNumber {get;set;}
    public Boolean showPageButtonForSummary {get;set;}
    public List<Amr_Saving__c>summaryJobsToShow{get;set;}
    public String totalAcceptedFinalCost {get;set;} 
    public String savingAverageOfQuotes {get;set;}
    public String savingAcceptedQuotes {get;set;}
    public Amr_Job_Details__c jobDetailObj {get;set;}
    public final double defaultValue = 0.0;    
    public String permissionSetName {get;set;}
    public List<SelectOption> rapNameList{get;set;} 
    public String percentageAcceptedSavingQuote{get;set;}
    public String selectedRapName{get;set;}
    public Decimal savingCurrentMonth {get;set;}
    public Decimal savingYTD {get;set;}
    public Amr_SavingSummaryController_CC(){
        
      try{
       Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
        loggedInUserId = UserInfo.getUserId();
        savingObject = new Amr_Saving__c();
        jobDetailObj = new Amr_Job_Details__c();
        quotesObj   = new Amr_Quote__c();
        jobId = ApexPages.currentPage().getParameters().get('id');
        userId = userinfo.getuserid();
        
        
        selectedCountry = new List<String> (); 
         for(Amr_Job_Allocation__c objJobAlloction : [SELECT AM_Job_Detail__c FROM  Amr_Job_Allocation__c where AM_Job_Detail__c != null and Job_Allocated__c = 'Yes' and AM_Job_Detail__r.Job_Cancelled__c = false limit 50000] ){
               jobDetailsId.add(objJobAlloction.AM_Job_Detail__c);
        } 
        getJobSearchDetails();
        
        List<Amr_Country_Cluster__c> countrylst=  Amr_Country_Cluster__c.getall().values();
            shootLocation = new List<SelectOption>();

            for(Amr_Country_Cluster__c countryObj:countrylst){
             shootLocation.add(new SelectOption(countryObj.Country__c,countryObj.Country__c));
            }
             shootLocation.sort();          
           categoryString = new list<string>();
         Set<MDO_Category__c> categorylst = utiltyObj.categoryValues();
        for(MDO_Category__c mdCat : categorylst){
            categoryString.add(mdCat.name);
        }
        listOfBrandPosition = new List<SelectOption>();
        listOfBrandPosition.add(new selectOption(Amr_ConstantForAdManager.NONE,Amr_ConstantForAdManager.NONE));
        
        
         rapNameList = new list<selectoption>();
         rapNameList.add(new SelectOption(Amr_ConstantForAdManager.NONE,Amr_ConstantForAdManager.NONE));
          for(PermissionSetAssignment  userObj :[select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name = :Label.Amr_RAP order by Assignee.name] ){

            SelectOption obj=new SelectOption(userObj.Assignee.id,userObj.Assignee.name);
            rapNameList.add(obj);
  
            }
        }
        catch(Exception e){
        system.debug(e.getMessage());
        }
        
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
           
        //dashboard

        DateTime currentDay = DateTime.now();
       
        yourYTDSpend  = [SELECT count(Id) savCurrentYearToDate,SUM(Sum_Of_Total_Cost_of_Accepted_Quotes__c) savCurrentCostYTD FROM  Amr_Saving__c where Display__c = true and Job_Details__c IN : jobDetailsId and (CreatedById = :loggedInUserId OR LastModifiedById = :loggedInUserId) AND CALENDAR_YEAR(CreatedDate) = :currentDay.year() AND CreatedDate <= :currentDay];
        globalYTDSpend  = [SELECT count(Id) savCurrentYearToDate,SUM(Sum_Of_Total_Cost_of_Accepted_Quotes__c) savCurrentCostYTD FROM  Amr_Saving__c where Display__c = true and Job_Details__c IN : jobDetailsId and CALENDAR_YEAR(CreatedDate) = :currentDay.year() AND CreatedDate <= :currentDay];   
        savingActivitiesSubmitted = [SELECT count(Id) savCurrentYearToDate,SUM(Sum_Of_Total_Cost_of_Accepted_Quotes__c) savCurrentCostYTD FROM  Amr_Saving__c where Display__c = true and Job_Details__c IN : jobDetailsId and CALENDAR_YEAR(CreatedDate) = :currentDay.year() AND CreatedDate <= :currentDay];
    }
/***********************************************************************************************************************************
Purpose: Method to create options for sort by functionality.
Parameters: 
Returns: It will return list of options.

************************************************************************************************************************************/ 
    public List<SelectOption> getSortOptions(){  
         
         listOfSortOptions = new List<SelectOption>();
          listOfSortOptions.add(new selectOption(Amr_ConstantForAdManager.NONE,Amr_ConstantForAdManager.NONE));
         listOfSortOptions.add(new selectOption('Job_Details__r.AdManagerText__c','ADManager Number'));
         listOfSortOptions.add(new selectOption('CreatedDateAmr_ConstantFor','Date Savings Submitted'));
         listOfSortOptions.add(new selectOption('No_of_Masters__c','No Of Masters'));
         listOfSortOptions.add(new selectOption('Duration_of_Masters__c','Duration Of Masters'));
         listOfSortOptions.add(new selectOption('No_of_Additional_Films__c','No of Additional Films'));
         listOfSortOptions.add(new selectOption('Duration_of_Additional_Films__c','Duration of Additional Films'));
         listOfSortOptions.add(new selectOption('Total_no_of_films__c','Total No of Films'));
         listOfSortOptions.add(new selectOption('No_of_shoot_days__c','No Of Shoot Days'));
         listOfSortOptions.add(new selectOption('Stage_RAP_engaged__c','Stage RAP Engaged'));
         listOfSortOptions.add(new selectOption('Script_Title__c','Script Title'));
         listOfSortOptions.add(new selectOption('Scope_re_brief__c','Scope Re Brief'));
         listOfSortOptions.add(new selectOption('Folder_Name__c','Folder Name'));
        
         
         return listOfSortOptions;
     }
/***********************************************************************************************************************************
Purpose: Method holds search functionality.
Parameters: 
Returns: 

************************************************************************************************************************************/    
  
     public Pagereference getJobSearchDetails(){

     try{
    
     String addNumber = jobDetailObj.AdManagerText__c;
     String region = jobDetailObj.Project_Leader_Cluster__c;
     String country = jobDetailObj.Project_Leader_Country__c;
     String budgetReponse = jobDetailObj.Budget_Responsibility__c;
     
     String pcFinalCostCurrency =  quotesObj.Accepted_Final_Cost_PC_only_Currency__c;
     String pcFinalCostLocalAmount = String.valueOf(quotesObj.Accepted_Final_Cost_PC_only_Local_Amo__c);
     String pcFinalCostEuroAmount = String.valueOf(quotesObj.Accepted_Final_Cost_PC_Euro_Amou__c);
     String ppcFinalCostCurrency = String.valueOf(quotesObj.Accepted_Final_Cost_PPC_only_Currency__c);
     String ppcFinalLocalAmount = String.valueOf(quotesObj.Accepted_Final_Cost_PPC_only_Local_Am__c);
     String ppcFinalEuroAmount = String.valueOf(quotesObj.Accepted_Final_Cost_PPC_Euro_Amount__c);
     String caFinalCostCurrency = String.valueOf(quotesObj.Accepted_Final_Cost_CA_only_Currency__c);
     String caFinalCostLocalAmount = String.valueOf(quotesObj.Accepted_Final_Cost_CA_Local_Amount__c);
     String caFinalCostEuroAmount = String.valueOf(quotesObj.Accepted_Final_Cost_CA_Euro_Amount__c);
     
     
     savingSummaryList = new List<Amr_Saving__c>();
     Boolean setFlag = false;
     String soql;
     List<PermissionSetAssignment> PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name ='CAP' order by Assignee.name];
    if(PermissionSetAssignmentList.size()>0){
     for(PermissionSetAssignment permissionObj:PermissionSetAssignmentList){
         if(userId == permissionObj.Assignee.id){
             setFlag = true;
             break;
         }
     }
     }
     if(!setFlag){
   
    
      soql = 'select Average_Total_Opening_Quotes__c,Number_Of_Quotes__c,Cost_per_master_per_shoot_day__c,Cost_Per_Master__c,Saving_Accepted_Quote_Euro__c ,Percentage_Saving_Accepted_Quote__c,Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quotes__c,Job_Details__r.AdManagerText__c,Job_Details__r.Budget_Responsibility__c,Total_Accepted_FinalCost__c,Shoot_Location_Multiselect__c,CreatedDate,Production_Type__c,No_of_Masters__c,No_of_Masters_List__c,No_of_Additional_Films__c,No_of_Additional_Films_List__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Script_Title__c,Scope_re_brief__c,Folder_Name__c,Duration_of_Additional_Films__c,Duration_of_Masters__c,Shoot_Location__c,Job_Details__r.id,CreatedById,LastModifiedById ,(select Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c'
               +',Is_PC_part_of_the_Roster__c,PC_name__c,PC_Country__c,Service_Company_Name__c,Local_Currency_of_PC_Costs__c,Local_Amount_of_PC__c,PC_Costs_Euro_Amount__c,Is_the_PPC_part_of_the_Roster__c,PPC_Name__c,PPC_Country__c,Local_Currency_of_PPC_Costs__c,Local_Amount_of_PPC__c,PPC_Costs_Euro_Amount__c,CA_Additional_agency_Name__c,CA_Location__c,Local_Currency_of_CA_Costs__c,Local_Amount_of_CA__c,CA_Costs_Euro_Amount__c,Total_Cost__c,Accepted_Final_Cost_PC_only_Currency__c,Accepted_Final_Cost_PC_only_Local_Amo__c,Accepted_Final_Cost_PC_Euro_Amou__c,Accepted_Final_Cost_PPC_only_Currency__c,Accepted_Final_Cost_PPC_only_Local_Am__c,Accepted_Final_Cost_PPC_Euro_Amount__c,Accepted_Final_Cost_CA_only_Currency__c'
                +',Accepted_Final_Cost_CA_Local_Amount__c,Accepted_Final_Cost_CA_Euro_Amount__c,Accepted_Final_Cost_Editors_name__c,Accepted_Final_Cost_Total_editing_cost__c,Accepted_Final_Cost_Sound_Studio_Name__c,Accepted_Final_Cost_Total_Sound_Studio__c,Accepted_Final_Cost_Travel_Costs__c,Accepted_Final_Cost_props_wardrobe__c,Saving_Type__c from Quotes__r ORDER BY Quote_Number__c) from Amr_Saving__c where (CreatedById = :userid OR LastModifiedById = :userid) AND Display__c = true'; //and Job_Details__c IN :accountNumbers
     
     } else{
    
      soql = 'select Average_Total_Opening_Quotes__c,Number_Of_Quotes__c,Cost_per_master_per_shoot_day__c,Cost_Per_Master__c,Saving_Accepted_Quote_Euro__c ,Percentage_Saving_Accepted_Quote__c,Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quotes__c,Job_Details__r.AdManagerText__c,Job_Details__r.Budget_Responsibility__c,Total_Accepted_FinalCost__c,Shoot_Location_Multiselect__c,CreatedDate,Production_Type__c ,No_of_Masters__c,No_of_Masters_List__c,No_of_Additional_Films__c,No_of_Additional_Films_List__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Script_Title__c,Scope_re_brief__c,Duration_of_Additional_Films__c,Duration_of_Masters__c,Folder_Name__c,Shoot_Location__c,Job_Details__r.id,CreatedById,LastModifiedById ,(select Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c' 
              +',Is_PC_part_of_the_Roster__c,PC_name__c,Service_Company_Name__c,PC_Country__c,Local_Currency_of_PC_Costs__c,Local_Amount_of_PC__c,PC_Costs_Euro_Amount__c,Is_the_PPC_part_of_the_Roster__c,PPC_Name__c,PPC_Country__c,Local_Currency_of_PPC_Costs__c,Local_Amount_of_PPC__c,PPC_Costs_Euro_Amount__c,CA_Additional_agency_Name__c,CA_Location__c,Local_Currency_of_CA_Costs__c,Local_Amount_of_CA__c,CA_Costs_Euro_Amount__c,Total_Cost__c,Accepted_Final_Cost_PC_only_Currency__c,Accepted_Final_Cost_PC_only_Local_Amo__c,Accepted_Final_Cost_PC_Euro_Amou__c,Accepted_Final_Cost_PPC_only_Currency__c,Accepted_Final_Cost_PPC_only_Local_Am__c,Accepted_Final_Cost_PPC_Euro_Amount__c'
               +',Accepted_Final_Cost_CA_only_Currency__c,Accepted_Final_Cost_CA_Local_Amount__c,Accepted_Final_Cost_CA_Euro_Amount__c,Accepted_Final_Cost_Editors_name__c,Accepted_Final_Cost_Total_editing_cost__c,Accepted_Final_Cost_Sound_Studio_Name__c,Accepted_Final_Cost_Total_Sound_Studio__c,Accepted_Final_Cost_Travel_Costs__c,Accepted_Final_Cost_props_wardrobe__c,Saving_Type__c from Quotes__r ORDER BY Quote_Number__c) from Amr_Saving__c where CreatedDate!=null AND Display__c = true';  
     
     }

      
      if (String.isNotBlank(startDate)){
   //start date creation

   String[] startDateSplitQuote = startDate.split(' ');
   String[] startDateSplitSlash = startDateSplitQuote[0].split(Amr_ConstantForAdManager.BACK_SLASH);
   Integer myIntDate = integer.valueOf(startDateSplitSlash[0]);
   Integer myIntMonth = integer.valueOf(startDateSplitSlash[1]);
   Integer myIntYear = integer.valueOf(startDateSplitSlash[2]);
   Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
   DateTime startDateFinal = DateTime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0);

soql += ' and createdDate'+  ' >= '+ startDateFinal.formatGMT(Amr_ConstantForAdManager.SECDATEFORMAT) ;

    }
    if (String.isNotBlank(endDate)){
    //end date creation
   String[] endDateSplitQuote = endDate.split(' ');
   String[] endDateSplitSlash = endDateSplitQuote[0].split(Amr_ConstantForAdManager.BACK_SLASH);
   Integer myIntDate1 = integer.valueOf(endDateSplitSlash[0]);
   Integer myIntMonth1 = integer.valueOf(endDateSplitSlash[1]);
   Integer myIntYear1 = integer.valueOf(endDateSplitSlash[2]);
   Date d1 = Date.newInstance(myIntYear1, myIntMonth1, myIntDate1);
   DateTime endDateDateFinal = DateTime.newInstance(d1.year(), d1.month(), d1.day(), 0, 0, 0);
  
           soql += ' and createdDate ' +  ' < '+ endDateDateFinal.addDays(1).formatGMT(Amr_ConstantForAdManager.SECDATEFORMAT );
           
          
    }
    
 
   
    if(String.isNotBlank(savingObject.Production_Type__c)){
      
    soql += ' and Production_Type__c = \''+String.escapeSingleQuotes(savingObject.Production_Type__c)+Amr_ConstantForAdManager.SLASH;
   
           
     }
   
      if(String.isNotBlank(String.valueOf(savingObject.No_of_Masters__c))){
    
    String noOfMaster = String.valueOf(savingObject.No_of_Masters__c);  
    soql += ' and No_of_Masters_List__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(noOfMaster)+Amr_ConstantForAdManager.PERCENTAGESLASH ;
   
     } 
     if(String.isNotBlank(String.valueOf(savingObject.Duration_of_Masters__c))){
      String durationOfMasters = String.valueOf(savingObject.Duration_of_Masters__c);
    soql += ' and Duration_of_Masters__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(durationOfMasters)+Amr_ConstantForAdManager.PERCENTAGESLASH ;
   
        
     } 
      if(String.isNotBlank(String.valueOf(savingObject.No_of_Additional_Films__c))){
    
    Double noOfAdditionalFields = savingObject.No_of_Additional_Films__c;  
    soql += ' and No_of_Additional_Films__c = :noOfAdditionalFields ';
   
           
     } 
      if(String.isNotBlank(String.valueOf(savingObject.No_of_shoot_days__c))){
    
    String noOfShootDays= String.valueOf(savingObject.No_of_shoot_days__c);  
    soql += ' and No_Of_Shoot_Days_Text__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(noOfShootDays)+Amr_ConstantForAdManager.PERCENTAGESLASH ;
   
   
           
     }
     
     if(String.isNotBlank(savingObject.Stage_RAP_engaged__c)){
      
    soql += ' and Stage_RAP_engaged__c= \''+String.escapeSingleQuotes(savingObject.Stage_RAP_engaged__c)+Amr_ConstantForAdManager.SLASH;
   
          
     }
     
     if(String.isNotBlank(savingObject.Script_Title__c)){
      
    soql += ' and Script_Title__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(savingObject.Script_Title__c)+Amr_ConstantForAdManager.PERCENTAGESLASH ;
   
           
     }
     
      if(String.isNotBlank(savingObject.Scope_re_brief__c)){
      
    soql += ' and Scope_re_brief__c= \''+String.escapeSingleQuotes(savingObject.Scope_re_brief__c)+Amr_ConstantForAdManager.SLASH;
   
           
     }
      if(String.isNotBlank(savingObject.Folder_Name__c)){
      
    soql += ' and Folder_Name__c= \''+String.escapeSingleQuotes(savingObject.Folder_Name__c)+Amr_ConstantForAdManager.SLASH;
   
           
     }
     
     
     if(String.isNotBlank(addNumber)){
        soql += ' and Job_Details__r.AdManagerText__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+ String.escapeSingleQuotes(addNumber)+Amr_ConstantForAdManager.PERCENTAGESLASH ;
              
       } 
     if(String.isNotBlank(totalAcceptedFinalCost) ){
        
        soql += ' and Total_Accepted_Final_Cost_Text__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(totalAcceptedFinalCost)+Amr_ConstantForAdManager.PERCENTAGESLASH ;          // ''+Amr_ConstantForAdManager.PERCENTAGE+ String.valueOf(totalAcceptedFinalCost)+Amr_ConstantForAdManager.PERCENTAGESLASH ;
              
       }
        if(String.isNotBlank(savingAverageOfQuotes)){
       
        soql += ' and Saving_Average_Of_Quote_Text__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(savingAverageOfQuotes)+Amr_ConstantForAdManager.PERCENTAGESLASH ;         //  \''+Amr_ConstantForAdManager.PERCENTAGE+ String.valueOf(savingAverageOfQuotes) +Amr_ConstantForAdManager.PERCENTAGESLASH ;  
              
       }
        if(String.isNotBlank(savingAcceptedQuotes)){
      
        soql += ' and Saving_Accepted_Quote_Euro_Text__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(savingAcceptedQuotes)+Amr_ConstantForAdManager.PERCENTAGESLASH ;         //   \''+Amr_ConstantForAdManager.PERCENTAGE+ String.valueOf(savingAcceptedQuotes) +Amr_ConstantForAdManager.PERCENTAGESLASH ; 
              
       } 
       
       if(String.isNotBlank(categoryName)){
           soql += ' and Job_Details__r.ProductCategory__r.Name LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(categoryName)+Amr_ConstantForAdManager.PERCENTAGESLASH ;       //   \''+Amr_ConstantForAdManager.PERCENTAGE+ String.valueOf(savingAcceptedQuotes) +Amr_ConstantForAdManager.PERCENTAGESLASH ;               
       }
       
       if(String.isNotBlank(brandPosName)){
           soql += ' and Job_Details__r.Brand_Position__r.Name LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(brandPosName)+Amr_ConstantForAdManager.PERCENTAGESLASH ;       //   \''+Amr_ConstantForAdManager.PERCENTAGE+ String.valueOf(savingAcceptedQuotes) +Amr_ConstantForAdManager.PERCENTAGESLASH ;               
       } 

       if(String.isNotBlank(brandNameFromPage)){
           soql += ' and Job_Details__r.Brand_Final__r.Name LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(brandNameFromPage)+Amr_ConstantForAdManager.PERCENTAGESLASH ;       //   \''+Amr_ConstantForAdManager.PERCENTAGE+ String.valueOf(savingAcceptedQuotes) +Amr_ConstantForAdManager.PERCENTAGESLASH ;               
       }

       if(String.isNotBlank(numberOfAdditionalFilm)){
           String finalNumberOfFilms = numberOfAdditionalFilm.replace(Amr_ConstantForAdManager.COMMA,Amr_ConstantForAdManager.SINGLE_QUOTE);
           soql += ' and No_of_Additional_Films_List__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(numberOfAdditionalFilm)+Amr_ConstantForAdManager.PERCENTAGESLASH ;       //   \''+Amr_ConstantForAdManager.PERCENTAGE+ String.valueOf(savingAcceptedQuotes) +Amr_ConstantForAdManager.PERCENTAGESLASH ;               
       } 
       if(String.isNotBlank(savingObject.Duration_of_Additional_Films__c)){
           soql += ' and Duration_of_Additional_Films__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(savingObject.Duration_of_Additional_Films__c)+Amr_ConstantForAdManager.PERCENTAGESLASH ;       //   \''+Amr_ConstantForAdManager.PERCENTAGE+ String.valueOf(savingAcceptedQuotes) +Amr_ConstantForAdManager.PERCENTAGESLASH ;               
       } 
       if(String.isNotBlank(String.valueOf(percentageAcceptedSavingQuote))){
           soql += ' and Percentage_Saving_Accepted_Quote_Text__c  LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(percentageAcceptedSavingQuote)+Amr_ConstantForAdManager.PERCENTAGESLASH ;       //   \''+Amr_ConstantForAdManager.PERCENTAGE+ String.valueOf(savingAcceptedQuotes) +Amr_ConstantForAdManager.PERCENTAGESLASH ;               
       }
           
        if(String.isNotBlank(String.valueOf(savingPercentageAverageOfQuotes))){
           soql += ' and Percentage_Saving_Average_Quote_Text__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(savingPercentageAverageOfQuotes)+Amr_ConstantForAdManager.PERCENTAGESLASH ;      //   \''+Amr_ConstantForAdManager.PERCENTAGE+ String.valueOf(savingAcceptedQuotes) +Amr_ConstantForAdManager.PERCENTAGESLASH ;               
       }


        if(String.isNotBlank(region) && region != Amr_ConstantForAdManager.NONE){
           soql += ' and Job_Details__r.Project_Leader_Cluster__c = \''+String.escapeSingleQuotes(region)+Amr_ConstantForAdManager.SLASH;       //   \''+Amr_ConstantForAdManager.PERCENTAGE+ String.valueOf(savingAcceptedQuotes) +Amr_ConstantForAdManager.PERCENTAGESLASH ;               
       }
       
       if(String.isNotBlank(country) && country != Amr_ConstantForAdManager.NONE){
           soql += ' and Job_Details__r.Project_Leader_Country__c = \''+String.escapeSingleQuotes(country)+Amr_ConstantForAdManager.SLASH;       //   \''+Amr_ConstantForAdManager.PERCENTAGE+ String.valueOf(savingAcceptedQuotes) +Amr_ConstantForAdManager.PERCENTAGESLASH ;               
       }
       
       System.debug('Country ->  ' + country);
       System.debug('SQl HERE ->  ' + soql);
       
       if(String.isNotBlank(costPerMaster)){
         
           soql += ' and Cost_Per_Master_Text__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(costPerMaster)+Amr_ConstantForAdManager.PERCENTAGESLASH ;       //   \''+Amr_ConstantForAdManager.PERCENTAGE+ String.valueOf(savingAcceptedQuotes) +Amr_ConstantForAdManager.PERCENTAGESLASH ;               
       }
       if(String.isNotBlank(costPerMasterPerShootDays)){
          
           soql += ' and Cost_Per_Master_Per_Shoot_Day_Text__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(costPerMasterPerShootDays)+Amr_ConstantForAdManager.PERCENTAGESLASH ;               
       }
       if(String.isNotBlank(pcFinalCostLocalAmount) && pcFinalCostLocalAmount != Amr_ConstantForAdManager.NONE){
           soql += ' and Job_Details__r.Accepted_Final_Cost_PC_only_Local_Amo__c = \''+String.escapeSingleQuotes(pcFinalCostLocalAmount)+Amr_ConstantForAdManager.SLASH;       //   \''+Amr_ConstantForAdManager.PERCENTAGE+ String.valueOf(savingAcceptedQuotes) +Amr_ConstantForAdManager.PERCENTAGESLASH ;               
       } 
       if(String.isNotBlank(pcFinalCostCurrency ) && pcFinalCostCurrency  != Amr_ConstantForAdManager.NONE){
           soql += ' and Amr_Quote__r.Accepted_Final_Cost_PC_only_Currency__c= \''+String.escapeSingleQuotes(pcFinalCostCurrency)+Amr_ConstantForAdManager.SLASH;       //   \''+Amr_ConstantForAdManager.PERCENTAGE+ String.valueOf(savingAcceptedQuotes) +Amr_ConstantForAdManager.PERCENTAGESLASH ;               
       }    
       
       if(String.isNotBlank(budgetReponse) && budgetReponse != Amr_ConstantForAdManager.NONE){
           soql += ' and Job_Details__r.Budget_Responsibility__c = \''+String.escapeSingleQuotes(budgetReponse)+Amr_ConstantForAdManager.SLASH;       //   \''+Amr_ConstantForAdManager.PERCENTAGE+ String.valueOf(savingAcceptedQuotes) +Amr_ConstantForAdManager.PERCENTAGESLASH ;               
       }    
       
       if(String.isNotBlank(selectedRapName) && selectedRapName != Amr_ConstantForAdManager.NONE){
           soql += ' and Job_Details__r.ownerId = \''+String.escapeSingleQuotes(selectedRapName)+Amr_ConstantForAdManager.SLASH;       //   \''+Amr_ConstantForAdManager.PERCENTAGE+ String.valueOf(savingAcceptedQuotes) +Amr_ConstantForAdManager.PERCENTAGESLASH ;               
       }
       
       
       
      if(String.isNotBlank(films)){
      String noOfFilms= String.valueOf(films);  
    soql += ' and Total_No_Of_Films_Text__c LIKE \''+Amr_ConstantForAdManager.PERCENTAGE+String.escapeSingleQuotes(noOfFilms)+Amr_ConstantForAdManager.PERCENTAGESLASH ;
   
         
     }
    
      if(selectedCountry.size()>0){
         
        String str = '';
          for(String s:selectedCountry){
              str += s+ Amr_ConstantForAdManager.COMMA;
          }
          String shLocString = Amr_ConstantForAdManager.SLASH + str.subString(0,str.length()-1) + Amr_ConstantForAdManager.SLASH;
        soql += ' and Shoot_Location__c IN ('+shLocString+')';
       
     }
     try{
    List<AMR_Saving__c> tempLst = new List<AMR_Saving__c>();
    tempLst =  Database.query(soql);
    Set<String> countries = new set<String>();
    countries.addAll(selectedCountry);
    for(AMR_Saving__c saving : tempLst){
        if(saving.Shoot_Location_Multiselect__c != null){
        String tempstr = saving.Shoot_Location_Multiselect__c;
        
        for(String str2 : tempStr.Split(';')){
            if(countries.contains(str2)){                
                savingSummaryList.add(saving);
                break;
            }
        }}
    }
    }
    catch(Exception Ex){
       system.debug(Ex.getMessage());
    }

    if(String.isNotBlank(selectedSortJobsOption) && selectedSortJobsOption!=Amr_ConstantForAdManager.NONE){
        
         soql += ' ORDER BY '+String.escapeSingleQuotes(selectedSortJobsOption)+' ASC';

     }

    savingSummaryList = Database.query(soql);

     List<Amr_Saving__c> dummyList = new List<Amr_Saving__c>();
    dummyList = savingSummaryList;
    savingSummaryList = new List<Amr_Saving__c>();
    for(Amr_Saving__c savObj:dummyList){
        for(Id idObj:jobDetailsId){
            if(savObj.Job_Details__c == idObj){
            savingSummaryList.add(savObj);
            }
        }

    }

    paginationMethodForSummaryJobs(savingSummaryList);  
     }catch(Exception e){
    system.debug( e.getMessage() + 'Stack trace -> ' + e.getCause() + ' STACK ->  ' +e.getTypeName()  );
     }
     return null;
     }
        
  /***********************************************************************************************************************************
Purpose: Method to paginate summary records.
Parameters: list of saving records.
Returns: 

************************************************************************************************************************************/
        public void paginationMethodForSummaryJobs(List<Amr_Saving__c> jobListToDisplay){
       summaryJobsToShow = new list<Amr_Saving__c>();
       totalSizeForSummaryJobs = jobListToDisplay.size();
       if(limitSizeForSummaryJobs < totalSizeForSummaryJobs ){
       showPageButtonForSummary = true;
       }else{
       showPageButtonForSummary = false;
       }
        //Intial adding
        //check the total records are more than limitSizeForPriorityJobs and assign the records
        if((counterForSummaryJobs+limitSizeForSummaryJobs) <= totalSizeForSummaryJobs ){
            for(Integer i=0;i<limitSizeForSummaryJobs;i++){
                summaryJobsToShow.add(jobListToDisplay.get(i));
            }
        }else{
            for(Integer i=0;i<totalSizeForSummaryJobs ;i++){
                summaryJobsToShow.add(jobListToDisplay.get(i));
            }
        }
        
        TotalActiveJobPages     = Math.ceil((decimal.valueOf(totalSizeForSummaryJobs))/(decimal.valueOf(limitSizeForSummaryJobs))).intValue();
        CurrentActivePageNumber = (counterForSummaryJobs/limitSizeForSummaryJobs)+1;
        
      }
        
    public void beginningForSummaryJobs(){
        
        summaryJobsToShow = new List<Amr_Saving__c>();
        
        counterForSummaryJobs=0;

                
        if((counterForSummaryJobs + limitSizeForSummaryJobs) <= totalSizeForSummaryJobs ){
            for(Integer i=0;i<limitSizeForSummaryJobs;i++){
                
                summaryJobsToShow.add(savingSummaryList.get(i));
            }   
            
        }else{
            for(Integer i=0;i<totalSizeForSummaryJobs ;i++){
                summaryJobsToShow.add(savingSummaryList.get(i));
            }       
        }
        
        TotalActiveJobPages     = Math.ceil((decimal.valueOf(totalSizeForSummaryJobs))/(decimal.valueOf(limitSizeForSummaryJobs))).intValue();
        CurrentActivePageNumber = (counterForSummaryJobs/limitSizeForSummaryJobs)+1;
    }
   
    public void nextForSummaryJobs(){
         summaryJobsToShow = new List<Amr_Saving__c>();
        counterForSummaryJobs=counterForSummaryJobs+limitSizeForSummaryJobs;
        if((counterForSummaryJobs+limitSizeForSummaryJobs) <= totalSizeForSummaryJobs ){
            for(Integer i=counterForSummaryJobs;i<(counterForSummaryJobs+limitSizeForSummaryJobs);i++){
                summaryJobsToShow.add(savingSummaryList.get(i));
            }
        } else{
            for(Integer i=counterForSummaryJobs;i<totalSizeForSummaryJobs ;i++){
                summaryJobsToShow.add(savingSummaryList.get(i));
            }
        }
        
        TotalActiveJobPages     = Math.ceil((decimal.valueOf(totalSizeForSummaryJobs))/(decimal.valueOf(limitSizeForSummaryJobs))).intValue();
        CurrentActivePageNumber = (counterForSummaryJobs/limitSizeForSummaryJobs)+1;
    }
   
    public void previousForSummaryJobs(){
         summaryJobsToShow = new List<Amr_Saving__c>();
        counterForSummaryJobs=counterForSummaryJobs-limitSizeForSummaryJobs;       
            for(Integer i=counterForSummaryJobs;i<(counterForSummaryJobs+limitSizeForSummaryJobs); i++){
            summaryJobsToShow.add(savingSummaryList.get(i));
        }
        
        TotalActiveJobPages     = Math.ceil((decimal.valueOf(totalSizeForSummaryJobs))/(decimal.valueOf(limitSizeForSummaryJobs))).intValue();
        CurrentActivePageNumber = (counterForSummaryJobs/limitSizeForSummaryJobs)+1;
    }

    public void lastForSummaryJobs (){
         summaryJobsToShow = new List<Amr_Saving__c>();
        if(math.mod(totalSizeForSummaryJobs , limitSizeForSummaryJobs) == 0){
            counterForSummaryJobs = limitSizeForSummaryJobs* ((totalSizeForSummaryJobs /limitSizeForSummaryJobs)-1);
        } else if (math.mod(totalSizeForSummaryJobs , limitSizeForSummaryJobs) != 0){
            counterForSummaryJobs = limitSizeForSummaryJobs* ((totalSizeForSummaryJobs /limitSizeForSummaryJobs));
        }
        for(Integer i=counterForSummaryJobs -1;i<totalSizeForSummaryJobs -1;i++){
                summaryJobsToShow.add(savingSummaryList.get(i));
        }
        
        TotalActiveJobPages     = Math.ceil((decimal.valueOf(totalSizeForSummaryJobs))/(decimal.valueOf(limitSizeForSummaryJobs))).intValue();
        CurrentActivePageNumber = (counterForSummaryJobs/limitSizeForSummaryJobs)+1;
      }
   
    public Boolean getDisableNextForSummaryJobs(){
        if((counterForSummaryJobs + limitSizeForSummaryJobs) >= totalSizeForSummaryJobs )
            return true ;
        else
            return false ;
    }
   
    public Boolean getDisablePreviousForSummaryJobs(){
        if(counterForSummaryJobs  == 0)
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
      
       PageReference pageRef = new PageReference('/apex/amr_jobsheet');
       pageRef.getParameters().put('id',chosenId);
       pageRef.setRedirect(true);
       return pageRef;
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

        Set<String> brnadPosNameSet = new Set<String>();
        for(MDO_BrandPositions__c bps : brandPositionlst){

            if(!brnadPosNameSet.contains(bps.brand_position_id__r.name)){
                listOfBrandPosition.add(new selectOption(bps.brand_position_id__r.name,bps.brand_position_id__r.name));

                brnadPosNameSet.add(bps.brand_position_id__r.name);
            }
        }

       }catch(Exception e){
       system.debug(e.getMessage());
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

        listOfBrand.add(new selectOption(Amr_ConstantForAdManager.NONE,Amr_ConstantForAdManager.NONE));
        Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
        Set<MDO_BrandPositions__c> brandlst = utiltyObj.brandValues(categoryName,brandPosName);
        Set<String> brnadNameSet = new Set<String>();
        for(MDO_BrandPositions__c bps : brandlst){

            if(!brnadNameSet.contains(bps.brand_id__r.name)){
                listOfBrand.add(new selectOption(bps.brand_id__r.name,bps.brand_id__r.name));

                brnadNameSet.add(bps.brand_id__r.name);
            }
        }
                
        return listOfBrand;
        }catch(Exception e){
       system.debug(e.getMessage());
       return null;
       }
    }
 /***********************************************************************************************************************************
Purpose: Method to get submitted saving data to display on dashboard.
Parameters: 
Returns: It will return submitted saving data.

************************************************************************************************************************************/   
       public List<PieWedgeData> getPieDataRAP(){ 
        
        try{ 
            List<PieWedgeData> data = new List<PieWedgeData>();
           // pieSavingDataRap = new List<PieWedgeData>();
            Date startOfMonth = Date.today().toStartOfMonth();
            Date startOfNextMonth = startOfMonth.addMonths(1);
            DateTime currentDay = DateTime.now();
            DateTime prevYearCurrentday= DateTime.newInstance(currentDay.Year()-1, currentDay.month(), currentDay.day());
      Boolean setFlag = false;
      List<PermissionSetAssignment> PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name ='CAP' order by Assignee.name];
      if(PermissionSetAssignmentList.size()>0){
      for(PermissionSetAssignment permissionObj:PermissionSetAssignmentList){
         if(userId == permissionObj.Assignee.id){
             setFlag = true;
             break;
         }
     }
     } 
     if(!setFlag){    
     groupedSubmissionResultsCurrentMonth = [SELECT count(Id) savCurrentMonth ,SUM(Saving_Average_of_Quotes__c) savCostmonth FROM  Amr_Saving__c where  Display__c = true and Job_Details__c IN : jobDetailsId and (CreatedById = :loggedInUserId OR LastModifiedById = :loggedInUserId) AND CreatedDate >= :startOfMonth AND CreatedDate < :startOfNextMonth ];
          
     groupedSubmissionResultsYearToDate  = [SELECT count(Id) savCurrentYearToDate,SUM(Saving_Average_of_Quotes__c) savCurrentCostYTD FROM  Amr_Saving__c where Display__c = true and Job_Details__c IN : jobDetailsId and (CreatedById = :loggedInUserId OR LastModifiedById = :loggedInUserId) AND CALENDAR_YEAR(CreatedDate) = :currentDay.year() AND CreatedDate <= :currentDay];
        
     groupedSubmissionResultsPrevYearToDate  = [SELECT count(Id) savCurrentPrevYearYTD,SUM(Saving_Average_of_Quotes__c)  savCostPrevYear FROM  Amr_Saving__c where Display__c = true and Job_Details__c IN : jobDetailsId and (CreatedById = :loggedInUserId OR LastModifiedById = :loggedInUserId) AND CALENDAR_YEAR(CreatedDate) = :currentDay.year()-1 AND CreatedDate <=:prevYearCurrentday];
     
     groupedSubmissionResultsPrevYearCurrentMonth  = [SELECT count(Id) savCurrentPrevYearMonth,SUM(Saving_Average_of_Quotes__c)  savCostPrevYearMonth FROM  Amr_Saving__c where Display__c = true and Job_Details__c IN : jobDetailsId and (CreatedById = :loggedInUserId OR LastModifiedById = :loggedInUserId) and CALENDAR_YEAR(CreatedDate) = :currentDay.year()-1 AND CALENDAR_MONTH(CreatedDate) =:currentDay.month()];
     }else{
     groupedSubmissionResultsCurrentMonth = [SELECT count(Id) savCurrentMonth ,SUM(Saving_Average_of_Quotes__c) savCostmonth FROM  Amr_Saving__c where Display__c = true and Job_Details__c IN : jobDetailsId and CreatedDate >= :startOfMonth AND CreatedDate < :startOfNextMonth ];
          
     groupedSubmissionResultsYearToDate  = [SELECT count(Id) savCurrentYearToDate,SUM(Saving_Average_of_Quotes__c) savCurrentCostYTD FROM  Amr_Saving__c where Display__c = true and Job_Details__c IN : jobDetailsId and CALENDAR_YEAR(CreatedDate) = :currentDay.year() AND CreatedDate <= :currentDay];
        
     groupedSubmissionResultsPrevYearToDate  = [SELECT count(Id) savCurrentPrevYearYTD,SUM(Saving_Average_of_Quotes__c)  savCostPrevYear FROM  Amr_Saving__c where Display__c = true and Job_Details__c IN : jobDetailsId and CALENDAR_YEAR(CreatedDate) = :currentDay.year()-1 AND CreatedDate <=:prevYearCurrentday];
     
     groupedSubmissionResultsPrevYearCurrentMonth  = [SELECT count(Id) savCurrentPrevYearMonth,SUM(Saving_Average_of_Quotes__c)  savCostPrevYearMonth FROM  Amr_Saving__c where Display__c = true and Job_Details__c IN : jobDetailsId and CALENDAR_YEAR(CreatedDate) = :currentDay.year()-1 AND CALENDAR_MONTH(CreatedDate) =:currentDay.month()];
     }        
     data.add(new PieWedgeData('Prev Year YTD',Integer.valueOf(groupedSubmissionResultsPrevYearToDate[0].get('savCurrentPrevYearYTD'))));
    data.add(new PieWedgeData('Prev Year month',Integer.valueOf(groupedSubmissionResultsPrevYearCurrentMonth[0].get('savCurrentPrevYearMonth'))));
      data.add(new PieWedgeData('YTD',Integer.valueOf(groupedSubmissionResultsYearToDate[0].get('savCurrentYearToDate'))));   
      data.add(new PieWedgeData('Current Month',Integer.valueOf(groupedSubmissionResultsCurrentMonth[0].get('savCurrentMonth'))));  
      
      return data;  
      }catch(Exception e){
       system.debug(e.getMessage());
       return null;
       }
    }
 /***********************************************************************************************************************************
Purpose: Method to get submitted saving data to display on dashboard.
Parameters: 
Returns: It will return submitted saving data.

************************************************************************************************************************************/   
    
     public List<PieWedgeData> getpieSavingDataRaps() {  
        
        try{
            List<PieWedgeData> data = new List<PieWedgeData>();
            Date startOfMonth = Date.today().toStartOfMonth();
            Date startOfNextMonth = startOfMonth.addMonths(1);
            
            DateTime currentDay = DateTime.now();
            DateTime prevYearCurrentday= DateTime.newInstance(currentDay.Year()-1, currentDay.month(), currentDay.day());
      Boolean setFlag = false;
      List<PermissionSetAssignment> PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name ='CAP' order by Assignee.name];
      if(PermissionSetAssignmentList.size()>0){
      for(PermissionSetAssignment permissionObj:PermissionSetAssignmentList){
         if(userId == permissionObj.Assignee.id){
             setFlag = true;
             break;
         }
     }
     }      
    if(!setFlag){
    
     groupedSavingResultsCurrentMonth1 = [SELECT count(Id) savCurrentMonth ,SUM(Saving_Average_of_Quotes__c) savCostmonth FROM  Amr_Saving__c where  Display__c = true and Job_Details__c IN : jobDetailsId and (CreatedById = :loggedInUserId OR LastModifiedById = :loggedInUserId) AND CreatedDate >=:startOfMonth  AND CreatedDate < :startOfNextMonth ];
       
     groupedSavingResultsYearToDate1  = [SELECT count(Id) savCurrentYearToDate,SUM(Saving_Average_of_Quotes__c) savCurrentCostYTD FROM  Amr_Saving__c where  Display__c = true and Job_Details__c IN : jobDetailsId and (CreatedById = :loggedInUserId OR LastModifiedById = :loggedInUserId) AND CALENDAR_YEAR(CreatedDate) = :currentDay.year() AND CreatedDate <= :currentDay];
         
     groupedSavingResultsPrevYearToDate1  = [SELECT count(Id) savCurrentPrevYear,SUM(Saving_Average_of_Quotes__c)  savCostPrevYearYTD FROM  Amr_Saving__c where  Display__c = true and Job_Details__c IN : jobDetailsId and (CreatedById = :loggedInUserId OR LastModifiedById = :loggedInUserId) AND CALENDAR_YEAR(CreatedDate) = :currentDay.year()-1 AND CreatedDate <=:prevYearCurrentday];
     
     groupedSavingResultsPrevYearCurrentMonth1  = [SELECT count(Id) savCurrentPrevYear,SUM(Saving_Average_of_Quotes__c)  savCostPrevYearMonth FROM  Amr_Saving__c where  Display__c = true and Job_Details__c IN : jobDetailsId and (CreatedById = :loggedInUserId OR LastModifiedById = :loggedInUserId) and CALENDAR_YEAR(CreatedDate) = :currentDay.year()-1 AND CALENDAR_MONTH(CreatedDate) =:currentDay.month()];

     Integer aa = 0;
     Integer prevYrMonth =0;
     savingCurrentMonth =0;
     savingYTD =0;
     aa = Integer.valueOf(groupedSavingResultsPrevYearToDate1[0].get('savCostPrevYearYTD')) !=null ? Integer.valueOf(groupedSavingResultsPrevYearToDate1[0].get('savCostPrevYearYTD')):aa;
     prevYrMonth = Integer.valueOf(groupedSavingResultsPrevYearCurrentMonth1[0].get('savCostPrevYearMonth')) != null ? Integer.valueOf(groupedSavingResultsPrevYearCurrentMonth1[0].get('savCostPrevYearMonth')): prevYrMonth;
      
     savingCurrentMonth = Decimal.valueOf(String.valueOf(groupedSavingResultsCurrentMonth1[0].get('savCostmonth')));
     savingYTD = Decimal.valueOf(String.valueOf(groupedSavingResultsYearToDate1[0].get('savCurrentCostYTD')));
     data.add(new PieWedgeData('Prev Year YTD',aa));
     data.add(new PieWedgeData('Prev Year month',prevYrMonth));
     data.add(new PieWedgeData('YTD',Integer.valueOf(savingYTD)));
     data.add(new PieWedgeData('Current Month',Integer.valueof(savingCurrentMonth)));
     
      
    }else{
     groupedSavingResultsCurrentMonth1 = [SELECT count(Id) savCurrentMonth ,SUM(Saving_Average_of_Quotes__c) savCostmonth FROM  Amr_Saving__c where  Display__c = true and Job_Details__c IN : jobDetailsId and CreatedDate >= :startOfMonth AND CreatedDate < :startOfNextMonth ];
       
     groupedSavingResultsYearToDate1  = [SELECT count(Id) savCurrentYearToDate,SUM(Saving_Average_of_Quotes__c) savCurrentCostYTD FROM  Amr_Saving__c where   Display__c = true and Job_Details__c IN : jobDetailsId and CALENDAR_YEAR(CreatedDate) = :currentDay.year() AND CreatedDate <= :currentDay];
         
    // groupedSubmissionResultsPrevYear1  = [SELECT count(Id) savCurrentPrevYear,SUM(Saving_Average_of_Quotes__c)  savCostPrevYear FROM  Amr_Saving__c where  CALENDAR_YEAR(CreatedDate) = :currentDay.year()-1];
   
     data.add(new PieWedgeData('Global YTD Saving',Integer.valueOf(groupedSavingResultsYearToDate1[0].get('savCurrentCostYTD'))));
     data.add(new PieWedgeData('Global this month saving',Integer.valueOf(groupedSavingResultsCurrentMonth1[0].get('savCostmonth'))));
    }    

     return data;  
     }catch(Exception e){
         system.debug(e.getMessage());
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
         
       public pageReference clearJob(){
                
                PageReference pageRef = Page.Amr_SavingSummary;
                pageRef.setRedirect(true);
                return pageRef;
                
        return null;
        }
        
         
        

}