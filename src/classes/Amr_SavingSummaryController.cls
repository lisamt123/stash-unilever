public with sharing class Amr_SavingSummaryController{

    public Amr_Saving__c savingObject {get;set;}
    public List<SelectOption> shootLocation{get;set;}
    public List<String> selectedCountry{get;set;}
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
    public static final String NONE ='--None--';
    public List<SelectOption> listOfBrandPosition{get;set;}
    public List<SelectOption> listOfBrand{get;set;}
   // public  AggregateResult[] groupedSubmissionResultCurrentMonth {get;set;}
    public  AggregateResult[] groupedSubmissionResultsYearToDate  {get;set;}
    public  AggregateResult[] groupedSubmissionResultsPrevYear  {get;set;}
    
    public  AggregateResult[] groupedSavingResultsCurrentMonth  {get;set;}
    
     public  AggregateResult[] groupedSubmissionResultsYearToDate1  {get;set;}
    public  AggregateResult[] groupedSubmissionResultsPrevYear1  {get;set;}
    
    public  AggregateResult[] groupedSavingResultsCurrentMonth1  {get;set;}
    
   // public  AggregateResult[] groupedSavingResultsYearToDate  {get;set;}
  //  public  AggregateResult[] groupedSavingResultsPrevYear  {get;set;}
    
   // public  List<PieWedgeData>  pieSavingDataRap{get;set;}
    public  List<SelectOption> listOfSortOptions{get;set;}
    public String selectedSortJobsOption{get;set;}
    public Integer totalSizeForSummaryJobs =0;
    public Integer limitSizeForSummaryJobs=100; //Integer.valueOf(System.Label.Amr_LimitValue);
    public Integer counterForSummaryJobs=0;
    public Boolean showPageButtonForSummary {get;set;}
    public List<Amr_Saving__c>summaryJobsToShow{get;set;}
    public String totalAcceptedFinalCost {get;set;} 
    public String savingAverageOfQuotes {get;set;}
    public String savingAcceptedQuotes {get;set;}
    public Amr_Job_Details__c jobDetailObj {get;set;}
    public final double defaultValue = 0.0;
    
    public Amr_SavingSummaryController(){
        System.debug('HELLO00000000000');
        
      try{
       Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
        savingObject = new Amr_Saving__c();
        jobDetailObj = new Amr_Job_Details__c();
        jobId = ApexPages.currentPage().getParameters().get('id');
        userId = userinfo.getuserid();
        
        System.debug('IIDD  -> ' + userId); 
        selectedCountry = new List<String> (); 
        getJobSearchDetails();
        
        List<Amr_Country_Cluster__c> countrylst=  Amr_Country_Cluster__c.getall().values();
            shootLocation = new List<SelectOption>();
            for(Amr_Country_Cluster__c countryObj:countrylst){
             shootLocation.add(new SelectOption(countryObj.Country__c,countryObj.Country__c));
            }
           
           categoryString = new list<string>();
         Set<MDO_Category__c> categorylst = utiltyObj.categoryValues();
        for(MDO_Category__c mdCat : categorylst){
            categoryString.add(mdCat.name);
        }
        listOfBrandPosition = new List<SelectOption>();
        listOfBrandPosition.add(new selectOption(NONE,NONE));   
        }catch(Exception e){
        system.debug(e.getMessage());
        }
           
    }
    public List<SelectOption> getSortOptions(){  
         
         listOfSortOptions = new List<SelectOption>();
          listOfSortOptions.add(new selectOption(NONE,NONE));
         listOfSortOptions.add(new selectOption('Job_Details__r.AdManagerText__c','ADManager Number'));
         listOfSortOptions.add(new selectOption('CreatedDate','Date Savings Submitted'));
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
    
  
     public Pagereference getJobSearchDetails(){
     System.debug('HELLO');
    
     try{
  System.debug('total ->  '+ totalAcceptedFinalCost  + 'SAv ->  ' + savingAverageOfQuotes +'SAVE ->   ' + savingAcceptedQuotes );
     String addNumber = jobDetailObj.AdManagerText__c;
     System.debug('Start Date -> ' + startDate + 'END Date -> ' + endDate + 'SAVING OBJ ->  ' + savingObject + 'Add Number -> ' + addNumber);
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
     if(setFlag == false){
     
      soql = 'select Cost_per_master_per_shoot_day__c,Cost_Per_Master__c,Saving_Accepted_Quote_Euro__c ,Percentage_Saving_Accepted_Quote__c,Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quotes__c,Job_Details__r.AdManagerText__c,Total_Accepted_FinalCost__c,Shoot_Location_Multiselect__c,CreatedDate,Production_Type__c,No_of_Masters__c,Duration_of_Masters__c,No_of_Additional_Films__c,Duration_of_Additional_Films__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Script_Title__c,Scope_re_brief__c,Folder_Name__c,Shoot_Location__c,Job_Details__r.id,CreatedById,LastModifiedById ,(select Total_Cost__c,Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c from Quotes__r where Is_Accepted__c =true) from Amr_Saving__c where (CreatedById = :userId OR LastModifiedById = :userId )';
      
     } else{
    
      soql = 'select Cost_per_master_per_shoot_day__c,Cost_Per_Master__c,Saving_Accepted_Quote_Euro__c ,Percentage_Saving_Accepted_Quote__c,Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quotes__c,Job_Details__r.AdManagerText__c,Total_Accepted_FinalCost__c,Shoot_Location_Multiselect__c,CreatedDate,Production_Type__c ,No_of_Masters__c,Duration_of_Masters__c,No_of_Additional_Films__c,Duration_of_Additional_Films__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Script_Title__c,Scope_re_brief__c,Folder_Name__c,Shoot_Location__c,Job_Details__r.id,CreatedById,LastModifiedById ,(select Total_Cost__c,Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c from Quotes__r where Is_Accepted__c = true) from Amr_Saving__c where CreatedDate!=null';
     
     }
      system.debug('soql !!'+soql);
      system.debug('films!!'+films+'savingObject!!'+savingObject);
      
      if (String.isNotBlank(startDate)){
   //start date creation
   system.debug('inside start date');
   String[] startDateSplitQuote = startDate.split(' ');
   String[] startDateSplitSlash = startDateSplitQuote[0].split('/');
   Integer myIntDate = integer.valueOf(startDateSplitSlash[1]);
   Integer myIntMonth = integer.valueOf(startDateSplitSlash[0]);
   Integer myIntYear = integer.valueOf(startDateSplitSlash[2]);
   Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
   DateTime startDateFinal = DateTime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0);
     
           soql += ' and createdDate'+  ' >= '+ startDateFinal.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') ;
         
           
           system.debug('soql created date'+soql);
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
           
           system.debug('soql end date'+soql);
    }
   
    if(String.isNotBlank(savingObject.Production_Type__c)){
      
    soql += ' and Production_Type__c = \''+String.escapeSingleQuotes(savingObject.Production_Type__c)+'\'';
   
           system.debug('soql prod type'+soql);
     }
   
      if(String.isNotBlank(String.valueOf(savingObject.No_of_Masters__c))){
    
    Double noOfMaster = savingObject.No_of_Masters__c;  
    soql += ' and No_of_Masters__c = :noOfMaster ';
   
           system.debug('soql no of masters'+soql);
     }
     if(String.isNotBlank(String.valueOf(savingObject.Duration_of_Masters__c))){
      Double durationOfMasters = savingObject.Duration_of_Masters__c;
    soql += ' and Duration_of_Masters__c = :durationOfMasters ';
   
           system.debug('soql duration of masters'+soql);
     }
      if(String.isNotBlank(String.valueOf(savingObject.No_of_Additional_Films__c))){
    
    Double noOfAdditionalFields = savingObject.No_of_Additional_Films__c;  
    soql += ' and No_of_Additional_Films__c = :noOfAdditionalFields ';
   
           system.debug('soql no of additional films'+soql);
     }
     if(String.isNotBlank(String.valueOf(savingObject.Duration_of_Additional_Films__c))){
      
     Double durationOfAdditionalFilms = savingObject.Duration_of_Additional_Films__c;
    soql += ' and Duration_of_Additional_Films__c = :durationOfAdditionalFilms ';
   
           system.debug('soql duration of additional films'+soql);
     }
      if(String.isNotBlank(String.valueOf(savingObject.No_of_shoot_days__c))){
    
    Double noOfShootDays= savingObject.No_of_shoot_days__c;  
    soql += ' and No_of_shoot_days__c= :noOfShootDays';
   
           system.debug('soql no of shoot days'+soql);
     }
     
     if(String.isNotBlank(savingObject.Stage_RAP_engaged__c)){
      
    soql += ' and Stage_RAP_engaged__c= \''+String.escapeSingleQuotes(savingObject.Stage_RAP_engaged__c)+'\'';
   
           system.debug('soql stage RAP engaged'+soql);
     }
     
     if(String.isNotBlank(savingObject.Script_Title__c)){
      
    soql += ' and Script_Title__c LIKE \''+String.escapeSingleQuotes(savingObject.Script_Title__c)+'%\'';
   
           system.debug('soql script title'+soql);
     }
     
      if(String.isNotBlank(savingObject.Scope_re_brief__c)){
      
    soql += ' and Scope_re_brief__c= \''+String.escapeSingleQuotes(savingObject.Scope_re_brief__c)+'\'';
   
           system.debug('soql scope rebrief'+soql);
     }
      if(String.isNotBlank(savingObject.Folder_Name__c)){
      
    soql += ' and Folder_Name__c= \''+String.escapeSingleQuotes(savingObject.Folder_Name__c)+'\'';
   
           system.debug('soql folder name'+soql);
     }
      if(String.isNotBlank(films)){
      Double noOfFilms= double.valueOf(films);  
    soql += ' and Total_no_of_films__c =:noOfFilms';
   
           system.debug('soql total no of films'+soql);
     }
     system.debug('soql before'+soql);
      if(selectedCountry.size()>0){
         system.debug('selectedCountry'+selectedCountry);
        String str = '';
          for(String s:selectedCountry){
            //str= s+ ';'+str;
          //  str+='\''+s+'\''+';';
              str += s+ ',';
          }
          String shLocString = '\'' + str.subString(0,str.length()-1) + '\'';
        //  System.debug('Shoot LOCATEN -> ' + shLocString);
        //str= str = str.substring(0, str.length()-1);
        soql += ' and Shoot_Location__c IN ('+shLocString+')';
        System.debug('Str -> ' + shLocString);
        System.debug('SOQL -> ' + soql);
     }
     try{
    List<AMR_Saving__c> tempLst = new List<AMR_Saving__c>();
    system.debug('***soql*****'+soql);
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
    
    if(String.isNotBlank(selectedSortJobsOption) && selectedSortJobsOption!=NONE){
        
         soql += ' ORDER BY '+String.escapeSingleQuotes(selectedSortJobsOption)+' ASC';
           
     }
     
     if(String.isNotBlank(addNumber)){
        soql += ' and Job_Details__r.AdManagerText__c LIKE \''+'%'+ String.escapeSingleQuotes(addNumber)+'%\'';
              
       } 
     if(String.isNotBlank(totalAcceptedFinalCost) ){
         List<String> splittedValue = totalAcceptedFinalCost.split(',');
         String finalTotalString;
         System.debug(splittedValue);
         for(String totalVal : splittedValue){
             finalTotalString += totalVal;
         }
        soql += ' and Total_Accepted_FinalCost__c = '+ Double.valueOf(finalTotalString);          // ''+'%'+ String.valueOf(totalAcceptedFinalCost)+'%\'';
              
       }
        if(String.isNotBlank(savingAverageOfQuotes)){
        soql += ' and Saving_Average_of_Quotes__c = '+ Double.valueOf(savingAverageOfQuotes);        //  \''+'%'+ String.valueOf(savingAverageOfQuotes) +'%\'';  
              
       }
        if(String.isNotBlank(savingAcceptedQuotes)){
        soql += ' and Saving_Accepted_Quote_Euro__c = '+ Double.valueOf(savingAcceptedQuotes);        //   \''+'%'+ String.valueOf(savingAcceptedQuotes) +'%\''; 
              
       } 
     
      system.debug('soql after'+soql);
    savingSummaryList = Database.query(soql);
    system.debug('savingSummaryList !!'+savingSummaryList );
    
    paginationMethodForSummaryJobs(savingSummaryList);  
     }catch(Exception e){
    system.debug( e.getMessage() + 'Stack trace -> ' + e.getCause() + ' STACK ->  ' +e.getTypeName()  );
     }
     return null;
     }
        
    //----------------------------------------------------------------------------------------
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
      }
        
    public void beginningForSummaryJobs(){
        
        summaryJobsToShow = new List<Amr_Saving__c>();
        
        counterForSummaryJobs=0;
        System.debug('Size ->' + savingSummaryList.size());
         System.debug('S->' + counterForSummaryJobs + 'SSS -> ' + limitSizeForSummaryJobs);
                
        if((counterForSummaryJobs + limitSizeForSummaryJobs) <= totalSizeForSummaryJobs ){
            for(Integer i=0;i<limitSizeForSummaryJobs;i++){
                
                summaryJobsToShow.add(savingSummaryList.get(i));
            }   
            
        }else{
            for(Integer i=0;i<totalSizeForSummaryJobs ;i++){
                summaryJobsToShow.add(savingSummaryList.get(i));
            }       
        }
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
    }
   
    public void previousForSummaryJobs(){
         summaryJobsToShow = new List<Amr_Saving__c>();
        System.debug('Sizooo ->' + savingSummaryList.size());
                System.debug('Siii-> ' + counterForSummaryJobs + ' Seeee -> ' + limitSizeForSummaryJobs);
        counterForSummaryJobs=counterForSummaryJobs-limitSizeForSummaryJobs;       
            for(Integer i=counterForSummaryJobs;i<(counterForSummaryJobs+limitSizeForSummaryJobs); i++){
            summaryJobsToShow.add(savingSummaryList.get(i));
        }
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
     
     public PageReference jobSheetPageTransfer(){
      
       PageReference pageRef = new PageReference('/apex/amr_jobsheet');
       pageRef.getParameters().put('id',chosenId);
       pageRef.setRedirect(true);
       return pageRef;
   }
   
      public String getCategoryList(){ 
        System.debug('cATE ->' +  JSON.serialize(categoryString));
        return JSON.serialize(categoryString);
    }
    
     public PageReference  brandPositionListData(){    
       try{
        Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
        Set<MDO_BrandPositions__c> brandPositionlst = utiltyObj.brandPostitionValues(categoryName);
        system.debug('brandPositionListttoo----->'+brandPositionlst );
        Set<String> brnadPosNameSet = new Set<String>();
        for(MDO_BrandPositions__c bps : brandPositionlst){

            if(!brnadPosNameSet.contains(bps.brand_position_id__r.name)){
                listOfBrandPosition.add(new selectOption(bps.brand_position_id__r.name,bps.brand_position_id__r.name));

                brnadPosNameSet.add(bps.brand_position_id__r.name);
            }
        }

        system.debug('brandPositionListtt----->'+listOfBrandPosition);
       }catch(Exception e){
       system.debug(e.getMessage());
       }
        return null;

    }
    public List<SelectOption> getBrandList(){ 
        try{     
        listOfBrand = new List<SelectOption>();
        system.debug('========>'+brandPosName+'category name=====>'+categoryName);

        listOfBrand.add(new selectOption(NONE,NONE));

        //Set<String> brandlst = new Set<String>();
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
    
       public List<PieWedgeData> getPieDataRAP(){ 
        
        try{ 
            List<PieWedgeData> data = new List<PieWedgeData>();
           // pieSavingDataRap = new List<PieWedgeData>();
            Date startOfMonth = Date.today().toStartOfMonth();
            Date startOfNextMonth = startOfMonth.addMonths(1);
            Date currentDay = Date.today();
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
     if(setFlag == false){    
     groupedSavingResultsCurrentMonth = [SELECT count(Id) savCurrentMonth ,SUM(Sum_Of_Total_Cost__c) savCostmonth FROM  Amr_Saving__c where (CreatedById = :userId OR LastModifiedById = :userId) AND CreatedDate >= :startOfMonth AND CreatedDate < :startOfNextMonth ];
          
     groupedSubmissionResultsYearToDate  = [SELECT count(Id) savCurrentYearToDate,SUM(Sum_Of_Total_Cost__c) savCurrentCostYTD FROM  Amr_Saving__c where (CreatedById = :userId OR LastModifiedById = :userId) AND CALENDAR_YEAR(CreatedDate) = :currentDay.year() AND CreatedDate <= :currentDay];
        
     groupedSubmissionResultsPrevYear  = [SELECT count(Id) savCurrentPrevYear,SUM(Sum_Of_Total_Cost__c)  savCostPrevYear FROM  Amr_Saving__c where (CreatedById = :userId OR LastModifiedById = :userId) AND CALENDAR_YEAR(CreatedDate) = :currentDay.year()-1];
     }else{
        groupedSavingResultsCurrentMonth = [SELECT count(Id) savCurrentMonth ,SUM(Sum_Of_Total_Cost__c) savCostmonth FROM  Amr_Saving__c where  CreatedDate >= :startOfMonth AND CreatedDate < :startOfNextMonth ];
          
     groupedSubmissionResultsYearToDate  = [SELECT count(Id) savCurrentYearToDate,SUM(Sum_Of_Total_Cost__c) savCurrentCostYTD FROM  Amr_Saving__c where  CALENDAR_YEAR(CreatedDate) = :currentDay.year() AND CreatedDate <= :currentDay];
        
     groupedSubmissionResultsPrevYear  = [SELECT count(Id) savCurrentPrevYear,SUM(Sum_Of_Total_Cost__c)  savCostPrevYear FROM  Amr_Saving__c where  CALENDAR_YEAR(CreatedDate) = :currentDay.year()-1];
     }    
     data.add(new PieWedgeData('Current Month',Integer.valueOf(groupedSavingResultsCurrentMonth[0].get('savCurrentMonth'))));
     data.add(new PieWedgeData('YTD',Integer.valueOf(groupedSubmissionResultsYearToDate[0].get('savCurrentYearToDate'))));
     data.add(new PieWedgeData('Prev Year',Integer.valueOf(groupedSubmissionResultsPrevYear[0].get('savCurrentPrevYear'))));
          
      return data;  
      }catch(Exception e){
       system.debug(e.getMessage());
       return null;
       }
    }
    
    
     public List<PieWedgeData> getpieSavingDataRaps() {  
        
        try{
            List<PieWedgeData> data = new List<PieWedgeData>();
            Date startOfMonth = Date.today().toStartOfMonth();
            Date startOfNextMonth = startOfMonth.addMonths(1);
            Date currentDay = Date.today();
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
    if(setFlag == false){
    
     groupedSavingResultsCurrentMonth1 = [SELECT count(Id) savCurrentMonth ,SUM(Sum_Of_Total_Cost__c) savCostmonth FROM  Amr_Saving__c where (CreatedById = :userId OR LastModifiedById = :userId) AND CreatedDate >= :startOfMonth AND CreatedDate < :startOfNextMonth ];
       
     groupedSubmissionResultsYearToDate1  = [SELECT count(Id) savCurrentYearToDate,SUM(Sum_Of_Total_Cost__c) savCurrentCostYTD FROM  Amr_Saving__c where (CreatedById = :userId OR LastModifiedById = :userId) AND CALENDAR_YEAR(CreatedDate) = :currentDay.year() AND CreatedDate <= :currentDay];
         
     groupedSubmissionResultsPrevYear1  = [SELECT count(Id) savCurrentPrevYear,SUM(Sum_Of_Total_Cost__c)  savCostPrevYear FROM  Amr_Saving__c where (CreatedById = :userId OR LastModifiedById = :userId) AND CALENDAR_YEAR(CreatedDate) = :currentDay.year()-1];
    }else{
     groupedSavingResultsCurrentMonth1 = [SELECT count(Id) savCurrentMonth ,SUM(Sum_Of_Total_Cost__c) savCostmonth FROM  Amr_Saving__c where  CreatedDate >= :startOfMonth AND CreatedDate < :startOfNextMonth ];
       
     groupedSubmissionResultsYearToDate1  = [SELECT count(Id) savCurrentYearToDate,SUM(Sum_Of_Total_Cost__c) savCurrentCostYTD FROM  Amr_Saving__c where  CALENDAR_YEAR(CreatedDate) = :currentDay.year() AND CreatedDate <= :currentDay];
         
     groupedSubmissionResultsPrevYear1  = [SELECT count(Id) savCurrentPrevYear,SUM(Sum_Of_Total_Cost__c)  savCostPrevYear FROM  Amr_Saving__c where  CALENDAR_YEAR(CreatedDate) = :currentDay.year()-1];
    }    
     Integer aa = 0;
     aa = Integer.valueOf(groupedSubmissionResultsPrevYear1[0].get('savCostPrevYear')) != null ? Integer.valueOf(groupedSubmissionResultsPrevYear1[0].get('savCostPrevYear')): aa;
     
     System.debug('*****groupedSavingResultsCurrentMonth1*****'+groupedSavingResultsCurrentMonth1[0].get('savCostmonth'));
     data.add(new PieWedgeData('Current Month',Integer.valueOf(groupedSavingResultsCurrentMonth1[0].get('savCostmonth'))));
     data.add(new PieWedgeData('YTD',Integer.valueOf(groupedSubmissionResultsYearToDate1[0].get('savCurrentCostYTD'))));
     data.add(new PieWedgeData('Prev Year',aa));
     
     System.debug('*****data1*****'+data);
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
         
           
         
        

}