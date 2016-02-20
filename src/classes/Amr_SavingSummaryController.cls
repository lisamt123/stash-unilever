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
   // public  AggregateResult[] groupedSubmissionResultCurrentMonth {get;set;}
    public  AggregateResult[] groupedSubmissionResultsYearToDate  {get;set;}
    public  AggregateResult[] groupedSubmissionResultsPrevYear  {get;set;}
    
    public  AggregateResult[] groupedSavingResultsCurrentMonth  {get;set;}
   // public  AggregateResult[] groupedSavingResultsYearToDate  {get;set;}
  //  public  AggregateResult[] groupedSavingResultsPrevYear  {get;set;}
    
    
    public  List<SelectOption> listOfSortOptions{get;set;}
    public String selectedSortJobsOption{get;set;}
    public Integer totalSizeForSummaryJobs =0;
    public Integer limitSizeForSummaryJobs=Integer.valueOf(System.Label.Amr_LimitValue);
    public Integer counterForSummaryJobs=0;
    public Boolean showPageButtonForSummary {get;set;}
    public List<Amr_Saving__c>summaryJobsToShow{get;set;}
    
    public Amr_SavingSummaryController(){
        
        savingObject = new Amr_Saving__c();
        jobId = ApexPages.currentPage().getParameters().get('id');
        userId = userinfo.getuserid();
        System.debug('IIDD  -> ' + userId);
        selectedCountry = new List<String> ();
        List<Amr_Country_Cluster__c> countrylst=  Amr_Country_Cluster__c.getall().values();
            shootLocation = new List<SelectOption>();
            for(Amr_Country_Cluster__c countryObj:countrylst){
             shootLocation.add(new SelectOption(countryObj.Country__c,countryObj.Country__c));
            }
           getJobSearchDetails();
           
    }
    public List<SelectOption> getSortOptions(){  
         
         listOfSortOptions = new List<SelectOption>();
          listOfSortOptions.add(new selectOption('--None--','--None--'));
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
         listOfSortOptions.add(new selectOption('Shoot_Location_Multiselect__c','Shoot Location'));
         
         return listOfSortOptions;
     }
    
    public void getDashboardDataForRAP(){
    
    Date startOfMonth = Date.today().toStartOfMonth();
    Date startOfNextMonth = startOfMonth.addMonths(1);
    Date currentDay = Date.today();
    
    
     groupedSavingResultsCurrentMonth = [SELECT count(Id),SUM(Sum_Of_Total_Cost__c) FROM  Amr_Saving__c where (CreatedById = :userId OR LastModifiedById = :userId) AND CreatedDate >= :startOfMonth AND CreatedDate < :startOfNextMonth ];
     //groupedSubmissionResultCurrentMonth = [SELECT count(Id) FROM  Amr_Saving__c where (CreatedById = :userId OR LastModifiedById = :userId) AND CreatedDate >= :startOfMonth AND CreatedDate < :startOfNextMonth ];
     
     groupedSubmissionResultsYearToDate  = [SELECT count(Id),SUM(Sum_Of_Total_Cost__c) FROM  Amr_Saving__c where (CreatedById = :userId OR LastModifiedById = :userId) AND CALENDAR_YEAR(CreatedDate) = :currentDay.year() AND CreatedDate <= :currentDay];
    // groupedSavingResultsYearToDate  = [SELECT SUM(Sum_Of_Total_Cost__c)  FROM  Amr_Saving__c where (CreatedById = :userId OR LastModifiedById = :userId) AND CALENDAR_YEAR(CreatedDate) = :currentDay.year() AND CreatedDate <= :currentDay];
     
     groupedSubmissionResultsPrevYear  = [SELECT count(Id),SUM(Sum_Of_Total_Cost__c)  FROM  Amr_Saving__c where (CreatedById = :userId OR LastModifiedById = :userId) AND CALENDAR_YEAR(CreatedDate) = :currentDay.year()-1];
     //groupedSavingResultsPrevYear  = [SELECT SUM(Sum_Of_Total_Cost__c)  FROM  Amr_Saving__c where (CreatedById = :userId OR LastModifiedById = :userId) AND CALENDAR_YEAR(CreatedDate) = :currentDay.year()-1];
    }
    
    public void getDashboardDataForCAP(){
    
    Date startOfMonth = Date.today().toStartOfMonth();
    Date startOfNextMonth = startOfMonth.addMonths(1);
    Date currentDay = Date.today();
    
    
     groupedSavingResultsCurrentMonth = [SELECT  count(Id),SUM(Sum_Of_Total_Cost__c) FROM  Amr_Saving__c where CreatedDate >= :startOfMonth AND CreatedDate < :startOfNextMonth ];
    // groupedSubmissionResultCurrentMonth = [SELECT count(Id) FROM  Amr_Saving__c where  CreatedDate >= :startOfMonth AND CreatedDate < :startOfNextMonth ];
    
     groupedSubmissionResultsYearToDate  = [SELECT count(Id),SUM(Sum_Of_Total_Cost__c)  FROM  Amr_Saving__c where  CALENDAR_YEAR(CreatedDate) = :currentDay.year() AND CreatedDate <= :currentDay];
    // groupedSavingResultsYearToDate  = [SELECT SUM(Sum_Of_Total_Cost__c)  FROM  Amr_Saving__c where CALENDAR_YEAR(CreatedDate) = :currentDay.year() AND CreatedDate <= :currentDay];
     
     groupedSubmissionResultsPrevYear  = [SELECT count(Id), SUM(Sum_Of_Total_Cost__c) FROM  Amr_Saving__c where  CALENDAR_YEAR(CreatedDate) = :currentDay.year()-1];
      //groupedSavingResultsPrevYear  = [SELECT SUM(Sum_Of_Total_Cost__c)  FROM  Amr_Saving__c where  CALENDAR_YEAR(CreatedDate) = :currentDay.year()-1];
    }
    
     public Pagereference getJobSearchDetails(){
     
     System.debug('Start Date -> ' + startDate + 'END Date -> ' + endDate + 'SAVING OBJ ->  ' + savingObject );
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
      getDashboardDataForRAP();
      soql = 'select Job_Details__r.AdManagerText__c,Shoot_Location_Multiselect__c,CreatedDate,Production_Type__c,No_of_Masters__c,Duration_of_Masters__c,No_of_Additional_Films__c,Duration_of_Additional_Films__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Script_Title__c,Scope_re_brief__c,Folder_Name__c,Shoot_Location__c,Job_Details__r.id,CreatedById,LastModifiedById from Amr_Saving__c where (CreatedById = :userId OR LastModifiedById = :userId )';
      
     } else{
     getDashboardDataForCAP();
      soql = 'select Job_Details__r.AdManagerText__c,Shoot_Location_Multiselect__c,CreatedDate,Production_Type__c ,No_of_Masters__c,Duration_of_Masters__c,No_of_Additional_Films__c,Duration_of_Additional_Films__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Script_Title__c,Scope_re_brief__c,Folder_Name__c,Shoot_Location__c,Job_Details__r.id,CreatedById,LastModifiedById from Amr_Saving__c where CreatedDate!=null';
     
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
    /*
    if(String.isNotBlank(savingObject.Production_Type__c)){
      
    soql += ' and Production_Type__c = \''+String.escapeSingleQuotes(savingObject.Production_Type__c)+'\'';
   
           system.debug('soql4'+soql);
     }
     */
      if(String.isNotBlank(String.valueOf(savingObject.No_of_Masters__c))){
    
    Double noOfMaster = savingObject.No_of_Masters__c;  
    soql += ' and No_of_Masters__c = :noOfMaster ';
   
           system.debug('soql4'+soql);
     }
     if(String.isNotBlank(String.valueOf(savingObject.Duration_of_Masters__c))){
      Double durationOfMasters = savingObject.Duration_of_Masters__c;
    soql += ' and Duration_of_Masters__c = :durationOfMasters ';
   
           system.debug('soql4'+soql);
     }
      if(String.isNotBlank(String.valueOf(savingObject.No_of_Additional_Films__c))){
    
    Double noOfAdditionalFields = savingObject.No_of_Additional_Films__c;  
    soql += ' and No_of_Additional_Films__c = :noOfAdditionalFields ';
   
           system.debug('soql4'+soql);
     }
     if(String.isNotBlank(String.valueOf(savingObject.Duration_of_Additional_Films__c))){
      
     Double durationOfAdditionalFilms = savingObject.Duration_of_Additional_Films__c;
    soql += ' and Duration_of_Additional_Films__c = :durationOfAdditionalFilms ';
   
           system.debug('soql4'+soql);
     }
      if(String.isNotBlank(String.valueOf(savingObject.No_of_shoot_days__c))){
    
    Double noOfShootDays= savingObject.No_of_shoot_days__c;  
    soql += ' and No_of_shoot_days__c= :noOfShootDays';
   
           system.debug('soql4'+soql);
     }
     
     if(String.isNotBlank(savingObject.Stage_RAP_engaged__c)){
      
    soql += ' and Stage_RAP_engaged__c= \''+String.escapeSingleQuotes(savingObject.Stage_RAP_engaged__c)+'\'';
   
           system.debug('soql4'+soql);
     }
     
     if(String.isNotBlank(savingObject.Script_Title__c)){
      
    soql += ' and Script_Title__c LIKE \''+String.escapeSingleQuotes(savingObject.Script_Title__c)+'%\'';
   
           system.debug('soql4'+soql);
     }
     
      if(String.isNotBlank(savingObject.Scope_re_brief__c)){
      
    soql += ' and Scope_re_brief__c= \''+String.escapeSingleQuotes(savingObject.Scope_re_brief__c)+'\'';
   
           system.debug('soql4'+soql);
     }
      if(String.isNotBlank(savingObject.Folder_Name__c)){
      
    soql += ' and Folder_Name__c= \''+String.escapeSingleQuotes(savingObject.Folder_Name__c)+'\'';
   
           system.debug('soql4'+soql);
     }
      if(String.isNotBlank(films)){
      Double noOfFilms= double.valueOf(films);  
    soql += ' and Total_no_of_films__c =:noOfFilms';
   
           system.debug('soql4'+soql);
     }
     system.debug('soql before'+soql);
      if(selectedCountry.size()>0){
         system.debug('selectedCountry'+selectedCountry);
        String str = '';
          for(String s:selectedCountry){
            //str= s+ ';'+str;
            str+='\''+s+'\''+',';
          }
        //str= str = str.substring(0, str.length()-1);
        soql += ' and Shoot_Location_Multiselect__c includes ('+str.subString(0,str.length()-1)+')';
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
        throw Ex;
    }
    
    if(String.isNotBlank(selectedSortJobsOption) && selectedSortJobsOption!='--None--'){
        
         soql += ' ORDER BY '+String.escapeSingleQuotes(selectedSortJobsOption)+' ASC';
           
     }
      system.debug('soql after'+soql);
    savingSummaryList = Database.query(soql);
    system.debug('savingSummaryList !!'+savingSummaryList );
    
    paginationMethodForSummaryJobs(savingSummaryList);
     return null;
     }
    //---------------------------------------------------------------------------------------- 
    /* public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                
                con = new ApexPages.StandardSetController(savingSummaryList);
                // sets the number of records in each page set
                con.setPageSize(5);
            }
            return con;
        }
        set;
    }
    
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
      
       PageReference pageRef = new PageReference('/apex/AM_JobAllocations_bhupendra');
       pageRef.getParameters().put('id',chosenId);
       pageRef.setRedirect(true);
       return pageRef;
   }
   
 

}