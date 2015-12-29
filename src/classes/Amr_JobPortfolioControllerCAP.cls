public class Amr_JobPortfolioControllerCAP{
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
    public String projectName{get;set;}
    public String selectedSortJobsOption{get;set;}
    public String selectedSortCancelOption{get;set;}
    
    public List<SelectOption> listOfCategory{get;set;} 
    public List<SelectOption> listOfBrandPosition{get;set;}
    public  List<SelectOption> listOfBrand{get;set;}
    public  List<SelectOption> listOfSortOptions{get;set;}
    public  List<SelectOption> listOfUser {get;set;}
    public  List<SelectOption> listOfProjectName {get;set;}
    
    public Id chosenId {get; set;}

   
    public Amr_JobPortfolioControllerCAP(){
     jobAllocation =new Amr_Job_Allocation__c();
     jobDetails =new Amr_Job_Details__c();
     broadMarket='';
    getJobSearchDeatils();
    
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
     List<User> userList= [SELECT Id,Name FROM User where profile.name='RAP' ];
         listOfUser.add(new selectOption('--None--','--None--'));
         for(User user1: userList)
             listOfUser.add(new selectOption(user1.Id,user1.Name));
         return listOfUser;
     
     }
      public List<SelectOption> getProjectNameList(){      
         listOfProjectName = new List<SelectOption>();
         List<Amr_Project_Details__c> ProjectNameList= [Select id,Name from Amr_Project_Details__c limit 500];
         listOfProjectName .add(new selectOption('--None--','--None--'));
         for(Amr_Project_Details__c cat : ProjectNameList)
             listOfProjectName.add(new selectOption(cat.Id,cat.Name));
         return listOfProjectName ;
     }
     
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
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Broadcast_Market__c','Broadcast market'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Production_Activity__c','Production Activity Type'));
         listOfSortOptions.add(new selectOption('User__c','RAP Allocated'));
         listOfSortOptions.add(new selectOption('Job_Allocated__c','Allocated'));
         listOfSortOptions.add(new selectOption('Job_Status__c','Accepted'));
         return listOfSortOptions;
     }
    
    public Pagereference getJobSearchDeatils(){
     system.debug('startDate!!'+startDate+'endDate!!'+endDate);
     
    
    
      
    //job list
    jobDetailList = new list<Amr_Job_Allocation__c>();
    String acceptedString='Accepted';
    string soql = 'select Job_Status__c,Job_Allocated__c,User__c,AM_Job_Detail__r.Project_Details__c,AM_Job_Detail__r.Production_Activity__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Broadcast_Market__c,AM_Job_Detail__r.Job_Status__c ,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.Category__r.Name,AM_Job_Detail__r.Brand_Positioning__r.Name,AM_Job_Detail__r.Brand__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,id from Amr_Job_Allocation__c where Job_Status__c=: acceptedString';
    system.debug('soql !!'+soql);
    //cancellation
     jobDetailCancellationList = new list<Amr_Job_Allocation__c>();
    String cancelledString='Cancelled';
    string soqlForCancel = 'select Job_Status__c,Job_Allocated__c,User__c,AM_Job_Detail__r.Project_Details__c,AM_Job_Detail__r.Production_Activity__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Broadcast_Market__c,AM_Job_Detail__r.Job_Status__c ,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.Category__r.Name,AM_Job_Detail__r.Brand_Positioning__r.Name,AM_Job_Detail__r.Brand__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,id from Amr_Job_Allocation__c where Job_Status__c=: cancelledString';
    system.debug('soqlForCancel !!'+soqlForCancel );
    
    //search
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
      if(String.isNotBlank(jobDetails.Broadcast_Market__c)){
    soql += ' and AM_Job_Detail__r.Broadcast_Market__c LIKE \''+String.escapeSingleQuotes(jobDetails.Broadcast_Market__c)+'%\'';
    soqlForCancel += ' and AM_Job_Detail__r.Broadcast_Market__c LIKE \''+String.escapeSingleQuotes(jobDetails.Broadcast_Market__c)+'%\'';
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
     if(String.isNotBlank(projectName) && projectName != '--None--'){
    soql += ' and AM_Job_Detail__r.Project_Details__c = \''+String.escapeSingleQuotes(projectName)+'\'';
    soqlForCancel +=' and AM_Job_Detail__r.Project_Details__c = \''+String.escapeSingleQuotes(projectName)+'\'';
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
     
     if(String.isNotBlank(selectedSortJobsOption) && selectedSortJobsOption!='--None--'){
          soql += ' ORDER BY '+String.escapeSingleQuotes(selectedSortJobsOption)+' ASC';
           
     }
     if(String.isNotBlank(selectedSortCancelOption) && selectedSortCancelOption!='--None--'){
          soqlForCancel += ' ORDER BY '+String.escapeSingleQuotes(selectedSortCancelOption)+' ASC';
           
     }
     
     
     
    jobDetailList = Database.query(soql);
    system.debug('jobDetailList !!'+jobDetailList );
    
    //cancellation
    jobDetailCancellationList = Database.query(soqlForCancel);
    system.debug('jobDetailCancellationList !!'+jobDetailCancellationList );
   
    return null;
    }
    
    public PageReference jobSheetPageTransfer(){
      
       PageReference pageRef = new PageReference('/apex/Amr_JobSheetPage');
       pageRef.getParameters().put('id',chosenId);
       pageRef.setRedirect(true);
       return pageRef;
   }
}