global with sharing class Amr_CAPJobPortfolioController{
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
    public static final String Percentage_str = '%\'';
  //  public boolean showUnhideRecords{get;set;}
  //  public boolean flagForButtons{get;set;}
    public Id loggedInUserId {get;set;}
   // public String selectedAlert {get;set;}
  //  public Id chosenAlertId{get;set;}
    public Integer TotalJobs {get; set;}
    public Integer TotalPendingJobs {get; set;}
    public Integer TotalLiveJobs {get; set;}
    public Integer TotalPriorityJobs {get; set;}
    public Integer TotalDormantJobs  {get; set;}
    public Integer TotalSavingsJobs  {get; set;}
    public Integer TotalActiveJobPages  {get; set;}
        public Integer CurrentActivePageNumber {get;set;}   
    transient  String[]  listString{get;set;}
    transient  String[]  categoryString{get;set;}
    
   
    public Amr_CAPJobPortfolioController(){
        try{
        jobAllocation =new Amr_Job_Allocation__c();
        jobDetails =new Amr_Job_Details__c();
        broadMarket='';
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
        system.debug('listString!!'+listString);
        
         Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
        categoryString = new list<string>();
        Set<MDO_Category__c> categorylst = utiltyObj.categoryValues();
        for(MDO_Category__c mdCat : categorylst){
            categoryString.add(mdCat.name);
        }
        
        listOfBrandPosition = new List<SelectOption>();
        listOfBrandPosition.add(new selectOption(NONE,NONE));
        
     //getAlertRecords();
    getJobSearchDetails();
     getTotalJobs();     
    
    //cancellation
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
    }
    /*
    public List<SelectOption> getCategoryList(){      
         listOfCategory = new List<SelectOption>();
         
         listOfCategory.add(new selectOption(NONE,NONE));
         Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
         
         for(String cat: utiltyObj.categoryBrandPositionMap.keySet()){
             listOfCategory.add(new selectOption(cat,cat));
             system.debug('inside Category==>'+cat);
         }
         return listOfCategory;
     } */
     
   public String getCategoryList(){ 
        System.debug('cATE ->' +  JSON.serialize(categoryString));
        return JSON.serialize(categoryString);
    }
     
     public List<SelectOption> getBrandPositioningList(){ 
        try{ 
         system.debug('categoryName!!'+categoryName);
         Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
         Set<String> brandPositionlst = new Set<String>();
         
         for(String cat:utiltyObj.categoryBrandPositionMap.keySet()){
            if(cat == categoryName){
                brandPositionlst = utiltyObj.categoryBrandPositionMap.get(cat);
            }
            
         }
         
         listOfBrandPosition = new List<SelectOption>();
         listOfBrandPosition.add(new selectOption(NONE,NONE));
         for(String bps : brandPositionlst){
             listOfBrandPosition.add(new selectOption(bps,bps));
         }
 
        system.debug('brandPositionList----->'+listOfBrandPosition);
        return listOfBrandPosition;
        }catch(Exception ex){
            system.debug(ex.getMessage());
            return null;
        }
         
     } 
     
       public PageReference  brandPositionListData(){  
        try{  
        System.debug('BBBBBBRANDDD ->'+ categoryName);  
        Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
        Set<MDO_BrandPositions__c> brandPositionlst = utiltyObj.brandPostitionValues(categoryName);

        system.debug('brandPositionListttoo----->'+brandPositionlst );

        listOfBrandPosition = new List<SelectOption>();
        listOfBrandPosition.add(new selectOption(NONE,NONE));
        Set<String> brnadPosNameSet = new Set<String>();
        for(MDO_BrandPositions__c bps : brandPositionlst){

            if(!brnadPosNameSet.contains(bps.brand_position_id__r.name)){
                listOfBrandPosition.add(new selectOption(bps.brand_position_id__r.name,bps.brand_position_id__r.name));

                brnadPosNameSet.add(bps.brand_position_id__r.name);
            }
        }

        system.debug('brandPositionListtt----->'+listOfBrandPosition);
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
        return null;

    }
    
   /* public pageReference getPage(){
        try{
        userData = [select PermissionSet.Name from PermissionSetAssignment  where Assignee.id = :userinfo.getUserId()];
        Set<String> userNameSet = new Set<String>();
        for(PermissionSetAssignment permission : userData){
            userNameSet.add(permission.PermissionSet.Name);
        }
        if(userNameSet.contains(Label.Amr_CAP)){
        
            permissionSetName = Label.Amr_CAP;
            PageReference pageRef = new PageReference('/apex/am_CAPJobportfolio2');
             pageRef.setRedirect(true);
             return pageRef;
        }else{
        
            permissionSetName = Label.Amr_RAP;
             PageReference pageRef = new PageReference('/apex/am_jobportfolio2');
             pageRef.setRedirect(true);
             return pageRef;
        }
        }catch(Exception ex){
            system.debug(ex.getMessage());
            return null;
        }
      
        
    }*/
   /*  
      public List<SelectOption> getBrandList(){  
          system.debug('brand pos!!'+brandPos);    
          listOfBrand = new List<SelectOption>();
          system.debug('========>'+brandPos+'category name=====>'+categoryName);
         
          listOfBrand.add(new selectOption(NONE,NONE));
         
          Set<String> brandlst = new Set<String>();
          Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
         
          for(String brandPosObj:utiltyObj.BrandPositionAndBrandMap.keySet()){
             List<String> postionCategorylist = brandPosObj.split(',');
             system.debug('bandPostion and Category====>'+postionCategorylist);
             if(postionCategorylist.size()>0){
                if(postionCategorylist[0] == brandPos && postionCategorylist[1] == categoryName){
                    brandlst = utiltyObj.BrandPositionAndBrandMap.get(brandPosObj);
                }
             }
         }
         
          for(String bps : brandlst)
             listOfBrand.add(new selectOption(bps,bps));
         return listOfBrand;
     } */
     
     
       public List<SelectOption> getBrandList(){   
        try{   
        listOfBrand = new List<SelectOption>();
     //   system.debug('========>'+brandPosName+'category name=====>'+categoryName);

        listOfBrand.add(new selectOption(NONE,NONE));

        //Set<String> brandlst = new Set<String>();
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
            system.debug(ex.getMessage());
            return null;
        }
    }
     
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
    system.debug('listOfUser!!'+listOfUser);
         return listOfUser;
         }catch(Exception ex){
            system.debug(ex.getMessage());
            return null;
        }
     
     }
        public String getMethodToPassProjectNames(){
           return JSON.serialize(listString);
    }
    public void getTotalJobs() {
        try{
        TotalJobs = [SELECT count()  FROM  Amr_Job_Details__c limit 50000 ];
        
        system.debug('Value is !!'+TotalJobs); 
        
        
        TotalPendingJobs  = [SELECT count()  FROM  Amr_Job_Details__c where  Amr_Job_Details__c.Job_Status__c = :Label.Amr_Status_Priority ];
        TotalLiveJobs     = [SELECT count()  FROM  Amr_Job_Details__c where  Amr_Job_Details__c.Job_Status__c = :Label.Amr_Status_Live ];
        TotalPriorityJobs = [SELECT count()  FROM  Amr_Job_Details__c where  Amr_Job_Details__c.Job_Status__c = :Label.Amr_Status_Pending ];
        TotalDormantJobs  = [SELECT count()  FROM  Amr_Job_Details__c where  Amr_Job_Details__c.Job_Status__c = :Label.Amr_Status_Dormant ];
        TotalSavingsJobs  = [SELECT count() from Amr_Saving__c limit 50000];
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
    }
    
    
    
    
   /*  public void getAlertRecords(){
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
    }*/
    
    
    
    /*  public List<SelectOption> getProjectNameList(){      
         listOfProjectName = new List<SelectOption>();
         List<Amr_Project_Details__c> ProjectNameList= [Select id,Name from Amr_Project_Details__c limit 500];
         listOfProjectName .add(new selectOption(NONE,NONE));
         for(Amr_Project_Details__c cat : ProjectNameList)
             listOfProjectName.add(new selectOption(cat.Id,cat.Name));
         return listOfProjectName ;
     }*/
     
     //Method to get list in sort options
    public List<SelectOption> getSortOptions(){  
         
         listOfSortOptions = new List<SelectOption>();
          listOfSortOptions.add(new selectOption(NONE,NONE));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.AdManagerText__c','AdManager number'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.CreatedDate','Date logged'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Stage_of_Production_Activity__c','Stage of production activity'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Unilever_Project_Leader_Email__c','Project leader email'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Project_Leader_Country__c','Location of Unilever project leader(country)'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.ProductCategory__c','Category'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Brand_Position__c','Brand positioning'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Brand_Final__c','Brand name'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Project_Details__c','Project name'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Lead_Creative_Agency_name__c','Lead agency name'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Allocated_Budget_euro__c','Allocated budget(euro)'));
       listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Brodcast_Market__c','Broadcast market'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Production_Activity_Type__c','Production activity type'));
         listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Campaign_Name__c','Campaign Name'));
         listOfSortOptions.add(new selectOption('User__c','RAP allocated'));
         listOfSortOptions.add(new selectOption('Job_Allocated__c','Accepted and email sent'));
        /* listOfSortOptions.add(new selectOption('Job_Status__c','Accepted'));
         listOfSortOptions.add(new selectOption('Started__c','Started'));
         listOfSortOptions.add(new selectOption('Reported__c','Reported'));
         listOfSortOptions.add(new selectOption('Job_Shared__c','Shared'));*/
         return listOfSortOptions;
     }
    
    public Pagereference getJobSearchDetails(){
        try{
    system.debug('categoryName!!'+categoryName);
    //job list
    jobDetailList = new list<Amr_Job_Allocation__c>();
    acceptedString='Accepted';
    cancelledString='Cancelled';
    string soql ='select AM_Job_Detail__r.Campaign_Name__c,Started__c,AM_Job_Detail__r.Project_Name_Other__c,Started_Image__c,User__r.email,User__r.Name,Reported__c,Job_Shared__c,Job_Status__c,Job_Allocated_Image__c,Reported_Image__c ,Job_Allocated__c,Job_Status_Image__c,User__c,AM_Job_Detail__r.Project_Details__r.Name,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Job_Status__c ,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.ProductCategory__r.Name,AM_Job_Detail__r.Brand_Position__r.Name,AM_Job_Detail__r.Brand_Final__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,id from Amr_Job_Allocation__c where Job_Status__c != '+'\'Cancelled\' AND AM_Job_Detail__r.Job_Cancelled__c = false ';
    system.debug('soql !!'+soql);
    //cancellation
     jobDetailCancellationList = new list<Amr_Job_Allocation__c>();
    string soqlForCancel ='select AM_Job_Detail__r.Campaign_Name__c,Started__c,AM_Job_Detail__r.Project_Name_Other__c,Started_Image__c,User__r.email,User__r.Name,Reported__c,Job_Shared__c,Job_Status__c,Job_Allocated_Image__c,Reported_Image__c ,Job_Allocated__c,Job_Status_Image__c,User__c,AM_Job_Detail__r.Project_Details__r.Name,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Job_Status__c ,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.ProductCategory__r.Name,AM_Job_Detail__r.Brand_Position__r.Name,AM_Job_Detail__r.Brand_Final__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,id from Amr_Job_Allocation__c where Job_Status__c= '+'\'Cancelled\'AND AM_Job_Detail__r.Job_Cancelled__c = true ';
    system.debug('soqlForCancel !!'+soqlForCancel );
    
    //search
     String   addNumber = jobDetails.AdManagerText__c;
       String  projEmail = jobDetails.Unilever_Project_Leader_Email__c;
       String projectName = jobDetails.Project_Details__c;
   // soqlForCancel = soql;
     
    if (String.isNotBlank(String.valueOf(jobDetails.Start_Date__c))){
        Datetime startdate = jobDetails.Start_Date__c;
        String dateTimeFormat = startdate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
        soql += ' and AM_Job_Detail__r.createdDate ' +  ' >= '+  dateTimeFormat ;
        soqlForCancel +=' and AM_Job_Detail__r.createdDate ' +  ' >= '+ dateTimeFormat;
          
    }
    
    if (String.isNotBlank(String.valueOf(jobDetails.End_Date__c))){ 
        Datetime endate  = jobDetails.End_Date__c;
         String dateTimeFormat1 = endate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        
         soql += ' and AM_Job_Detail__r.createdDate ' +  ' < '+  dateTimeFormat1 ;
         soqlForCancel +=' and AM_Job_Detail__r.createdDate ' +  ' < '+ dateTimeFormat1;
          
    }
    
      if(String.isNotBlank(categoryName) && categoryName != NONE){
      
    soql += ' and AM_Job_Detail__r.ProductCategory__r.Name = \''+String.escapeSingleQuotes(categoryName)+'\'';
    soqlForCancel += ' and AM_Job_Detail__r.ProductCategory__r.Name = \''+String.escapeSingleQuotes(categoryName)+'\'';
         
     }
      if(String.isNotBlank(brandPos) && brandPos != NONE){
      
    soql += ' and AM_Job_Detail__r.Brand_Position__r.name = \''+String.escapeSingleQuotes(brandPos)+'\'';
    soqlForCancel +=' and AM_Job_Detail__r.Brand_Position__r.name = \''+String.escapeSingleQuotes(brandPos)+'\'';
          
     }
      if(String.isNotBlank(brandName) && brandName != NONE){
    soql += ' and AM_Job_Detail__r.Brand_Final__r.name = \''+String.escapeSingleQuotes(brandName)+'\'';
    soqlForCancel += ' and AM_Job_Detail__r.Brand_Final__r.name = \''+String.escapeSingleQuotes(brandName)+'\'';
          
     }
     
     if (String.isNotBlank(jobDetails.Project_Leader_Cluster__c)){
     
           soql += ' and AM_Job_Detail__r.Project_Leader_Cluster__c = \''+String.escapeSingleQuotes(jobDetails.Project_Leader_Cluster__c)+'\'';
            soqlForCancel +=' and AM_Job_Detail__r.Project_Leader_Cluster__c = \''+String.escapeSingleQuotes(jobDetails.Project_Leader_Cluster__c)+'\'';
          
    }
    
     if(String.isNotBlank(jobDetails.Project_Leader_Country__c)){
    soql += ' and AM_Job_Detail__r.Project_Leader_Country__c = \''+String.escapeSingleQuotes(jobDetails.Project_Leader_Country__c)+'\'';
     soqlForCancel +=' and AM_Job_Detail__r.Project_Leader_Country__c = \''+String.escapeSingleQuotes(jobDetails.Project_Leader_Country__c)+'\'';
                      
    }
   
     if(String.isNotBlank(jobDetails.Lead_Creative_Agency_name__c)){
    soql += ' and AM_Job_Detail__r.Lead_Creative_Agency_name__c = \''+String.escapeSingleQuotes(jobDetails.Lead_Creative_Agency_name__c)+'\'';
    soqlForCancel +=' and AM_Job_Detail__r.Lead_Creative_Agency_name__c = \''+String.escapeSingleQuotes(jobDetails.Lead_Creative_Agency_name__c)+'\'';
          
     
     }

      if(String.isNotBlank(jobDetails.Brodcast_Market__c)){
    soql += ' and AM_Job_Detail__r.Brodcast_Market__c LIKE \''+String.escapeSingleQuotes(jobDetails.Brodcast_Market__c)+Percentage_str ;
    soqlForCancel += ' and AM_Job_Detail__r.Brodcast_Market__c LIKE \''+String.escapeSingleQuotes(jobDetails.Brodcast_Market__c)+Percentage_str;
}
    if(String.isNotBlank(jobDetails.Stage_of_Production_Activity__c)){
    soql += ' and AM_Job_Detail__r.Stage_of_Production_Activity__c = \''+String.escapeSingleQuotes(jobDetails.Stage_of_Production_Activity__c)+'\'';
    soqlForCancel +=  ' and AM_Job_Detail__r.Stage_of_Production_Activity__c = \''+String.escapeSingleQuotes(jobDetails.Stage_of_Production_Activity__c)+'\'';
          
     }
   
    if(String.isNotBlank(jobDetails.AdManagerText__c)){
    soql += ' and AM_Job_Detail__r.AdManagerText__c LIKE \''+String.escapeSingleQuotes(jobDetails.AdManagerText__c)+Percentage_str;
    soqlForCancel += ' and AM_Job_Detail__r.AdManagerText__c LIKE \''+'%'+String.escapeSingleQuotes(jobDetails.AdManagerText__c)+Percentage_str;
          
     }
     if(String.isNotBlank(jobDetails.Unilever_Project_Leader_Email__c)){
    soql += ' and AM_Job_Detail__r.Unilever_Project_Leader_Email__c LIKE \''+String.escapeSingleQuotes(jobDetails.Unilever_Project_Leader_Email__c)+Percentage_str;
    soqlForCancel += ' and AM_Job_Detail__r.Unilever_Project_Leader_Email__c LIKE \''+String.escapeSingleQuotes(jobDetails.Unilever_Project_Leader_Email__c)+Percentage_str;
     }
     if(String.isNotBlank(jobDetails.Project_Details__c)){
        system.debug('***jobDetails.Project_Details__c****'+jobDetails.Project_Details__c);
    soql += ' and AM_Job_Detail__r.Project_Details__c = \''+String.escapeSingleQuotes(jobDetails.Project_Details__c)+'\'';
    soqlForCancel +=' and AM_Job_Detail__r.Project_Details__c = \''+String.escapeSingleQuotes(jobDetails.Project_Details__c)+'\'';
           
     }
     
      if(String.isNotBlank(userName) && userName != NONE){
     soql += ' and User__c = \''+String.escapeSingleQuotes(userName)+'\'';
     soqlForCancel +=' and User__c = \''+String.escapeSingleQuotes(userName)+'\'';
          
     }
     
      if(String.isNotBlank(jobAllocation.Job_Allocated__c)){
     soql += ' and Job_Allocated__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Allocated__c)+'\'';
     soqlForCancel +=' and Job_Allocated__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Allocated__c)+'\'';
           
     }
       if(String.isNotBlank(jobAllocation.Job_Shared__c)){
     soql += ' and Job_Shared__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Shared__c)+'\'';
     soqlForCancel +=' and Job_Shared__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Shared__c)+'\'';
           
     }
     if(String.isNotBlank(jobAllocation.Reported__c)){
     soql += ' and Reported__c = \''+String.escapeSingleQuotes(jobAllocation.Reported__c)+'\'';
     soqlForCancel +=' and Reported__c = \''+String.escapeSingleQuotes(jobAllocation.Reported__c)+'\'';
          
     }
      if(String.isNotBlank(jobAllocation.Started__c)){
     soql += ' and Started__c = \''+String.escapeSingleQuotes(jobAllocation.Started__c)+'\'';
     soqlForCancel +=' and Started__c = \''+String.escapeSingleQuotes(jobAllocation.Started__c)+'\'';
          
     }
       if(String.isNotBlank(jobDetails.Project_Name_Other__c)){
     soql += ' and AM_Job_Detail__r.Project_Name_Other__c = \''+String.escapeSingleQuotes(jobDetails.Project_Name_Other__c)+'\'';
     soqlForCancel +=' and AM_Job_Detail__r.Project_Name_Other__c = \''+String.escapeSingleQuotes(jobDetails.Project_Name_Other__c)+'\'';
           
     }
     
        if(String.isNotBlank(jobAllocation.Job_Status__c)){
     soql += ' and Job_Status__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Status__c)+'\'';
     soqlForCancel +=' and Job_Status__c = \''+String.escapeSingleQuotes(jobAllocation.Job_Status__c)+'\'';
           
     }
      if(String.isNotBlank(jobDetails.Campaign_Name__c)){
            
     soql += ' and AM_Job_Detail__r.Campaign_Name__c LIKE \''+String.escapeSingleQuotes(jobDetails.Campaign_Name__c)+Percentage_str;
    soqlForCancel += ' and AM_Job_Detail__r.Campaign_Name__c LIKE \''+String.escapeSingleQuotes(jobDetails.Campaign_Name__c)+Percentage_str;
      }
     
    
     if(String.isNotBlank(addNumber)){
        soql += ' and AM_Job_Detail__r.AdManagerText__c LIKE \''+'%'+ String.escapeSingleQuotes(addNumber)+Percentage_str;
        soqlForCancel += ' and AM_Job_Detail__r.AdManagerText__c LIKE \''+'%'+ String.escapeSingleQuotes(addNumber)+Percentage_str;
              
         }
         if(String.isNotBlank(projEmail)){
        soql += ' and AM_Job_Detail__r.Unilever_Project_Leader_Email__c LIKE \''+String.escapeSingleQuotes(projEmail)+Percentage_str;
         soqlForCancel += ' and AM_Job_Detail__r.Unilever_Project_Leader_Email__c LIKE \''+String.escapeSingleQuotes(projEmail)+Percentage_str;
              
         }
         if(String.isNotBlank(projectName)){
        soql += ' and AM_Job_Detail__r.Project_Details__c = \''+String.escapeSingleQuotes(projectName)+'\'';
         soqlForCancel += ' and AM_Job_Detail__r.Project_Details__c = \''+String.escapeSingleQuotes(projectName)+'\'';
              
         }
         System.debug('Project Name -->>>  ' + projectName);
         if(String.isNotBlank(jobDetails.Project_Name_Other__c)){
        soql += ' and AM_Job_Detail__r.Project_Name_Other__c = \''+String.escapeSingleQuotes(jobDetails.Project_Name_Other__c)+'\'';
        soqlForCancel += ' and AM_Job_Detail__r.Project_Name_Other__c = \''+String.escapeSingleQuotes(jobDetails.Project_Name_Other__c)+'\'';
              
         }
          System.debug('SOQL Till Here -->>>  ' + soql );
         if(String.isNotBlank(jobDetails.Campaign_Name__c)){
        soql += ' and AM_Job_Detail__r.Campaign_Name__c LIKE \''+String.escapeSingleQuotes(jobDetails.Campaign_Name__c)+Percentage_str;
        soqlForCancel += ' and AM_Job_Detail__r.Campaign_Name__c LIKE \''+String.escapeSingleQuotes(jobDetails.Campaign_Name__c)+Percentage_str;
            
         }
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
                DateTime endDateFinal = DateTime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0).addDays(1);
         
               soql += ' and createdDate'+  ' >= '+ startDateFinal.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') + ' and createdDate'+  ' < '+ endDateFinal.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') ;
               soqlForCancel += ' and createdDate'+  ' = '+ startDateFinal.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') ;
             
               
               system.debug('soql created date'+soql);
    }
     if(String.isNotBlank(selectedSortJobsOption) && selectedSortJobsOption!=NONE){
          soql += ' ORDER BY '+String.escapeSingleQuotes(selectedSortJobsOption)+' ASC';
           
     }
     if(String.isNotBlank(selectedSortCancelOption) && selectedSortCancelOption!=NONE){
          soqlForCancel += ' ORDER BY '+String.escapeSingleQuotes(selectedSortCancelOption)+' ASC';
           
     }
     system.debug('soql created date'+soql);
   
     soql+=' limit 50000';
     soqlForCancel+=' limit 50000';
     system.debug('soql !!'+soql +'soqlForCancel!!'+soqlForCancel);
     
    jobDetailList = Database.query(soql);
    system.debug('jobDetailList !!'+jobDetailList );
    Set<String> setJobAllocationId = new Set<String>();
     
    for(Amr_Job_Allocation__c sObj: Database.query(soql) ){
             if(!setJobAllocationId.contains(sObj.AM_Job_Detail__c+''+sObj.User__c)){
                system.debug('sObj.idsObj.User__c!'+sObj.AM_Job_Detail__c+''+sObj.User__c );
                setJobAllocationId.add(sObj.AM_Job_Detail__c+''+sObj.User__c);
                jobDetailList.add(sObj ) ;
             }
     }
    System.debug('Final List -->>  ' + jobDetailList);
    //cancellation
    jobDetailCancellationList = Database.query(soqlForCancel);
    system.debug('jobDetailCancellationList !!'+jobDetailCancellationList );
    
    paginationMethodForActiveJobs(jobDetailList);
       
     wrapperList = new List<wrapperClass>();
     Set<String> setJobAllocation = new Set<String>();
      for(Amr_Job_Allocation__c sObj: jobDetailCancellationList ){
             if(!setJobAllocation.contains(sObj.AM_Job_Detail__c+''+sObj.User__c)){
                setJobAllocation.add(sObj.AM_Job_Detail__c+''+sObj.User__c);
                WrapperList.add( new wrapperClass(false,sObj)) ;
             }
     }
         //sortBySelected();     //return WrapperList;
    paginationMethodForCancelJobs(WrapperList);
    }catch(Exception ex){
            system.debug(ex.getMessage());
    }
    return null;
       
    }
        
  // Wrapper class include Sobject and select box
    @TestVisible public Class wrapperClass{
     
         Amr_CAPJobPortfolioController objCap;
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
      
    
           // To call Cancel button on VF Page
       Public PageReference changwrapperClasseStatus(){
        try{
          List<Amr_Job_Allocation__c> selectList = New List<Amr_Job_Allocation__c>();
          List<Amr_Job_Details__c> selectJobDetailList = New List<Amr_Job_Details__c>();
          for(wrapperclass wc:WrapperList){
              if(wc.SelectBox){
                 selectList.add(wc.sObjRec); }
          }
          if(selectList.size()>0){
            for(Amr_Job_Allocation__c obj : selectList ){
                selectJobDetailList.add(obj.AM_Job_Detail__r);
                
            }
            
            
           List<Amr_Job_Allocation__c> jobdetails1=[select id ,Name,AM_Job_Detail__r.Project_Name_Other__c ,AM_Job_Detail__r.id,Job_Status__c,AM_Job_Detail__c from Amr_Job_Allocation__c where Id IN:selectList];
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
          }catch(Exception ex){
            system.debug(ex.getMessage());
            return null;
        }
     }
    //////
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
        system.debug('activeJobsToShow!!'+activeJobsToShow);
        
        TotalActiveJobPages = (totalSizeForActiveJobs/limitSizeForActiveJobs)+1;
        CurrentActivePageNumber         = (counterForActiveJobs/limitSizeForActiveJobs)+1;
        
         system.debug('Bhupi Total size for active jobs'+totalSizeForActiveJobs);
         system.debug('Bhupi limit of records are'+limitSizeForActiveJobs);
         system.debug('Bhupi pages are'+TotalActiveJobPages);
        
        //getTotalActiveJobPages(totalSizeForActiveJobs/limitSizeForActiveJobs);
        }catch(Exception ex){
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
        
        TotalActiveJobPages = (totalSizeForActiveJobs/limitSizeForActiveJobs)+1;
        CurrentActivePageNumber = (counterForActiveJobs/limitSizeForActiveJobs)+1;
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
    }
   
    public void nextForActiveJobs(){
        try{
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
        
        TotalActiveJobPages = (totalSizeForActiveJobs/limitSizeForActiveJobs)+1;
        CurrentActivePageNumber = (counterForActiveJobs/limitSizeForActiveJobs)+1;
        
         system.debug('activeJobsToShow-----'+activeJobsToShow);
         system.debug('no of page -----'+TotalActiveJobPages);
         system.debug('current page -----'+CurrentActivePageNumber);
        }catch(Exception ex){
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
        
        TotalActiveJobPages = (totalSizeForActiveJobs/limitSizeForActiveJobs)+1;
        CurrentActivePageNumber = (counterForActiveJobs/limitSizeForActiveJobs)+1;
        }catch(Exception ex){
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
        
        TotalActiveJobPages = (totalSizeForActiveJobs/limitSizeForActiveJobs)+1;
        CurrentActivePageNumber = (counterForActiveJobs/limitSizeForActiveJobs)+1;
        }catch(Exception ex){
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
    //pagination for Active jobs ends here
    
      //pagination for active jobs starts here
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
         system.debug('cancelJobsToShow!!'+cancelJobsToShow);
         }catch(Exception ex){
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
        }catch(Exception ex){
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
        }catch(Exception ex){
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
        }catch(Exception ex){
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
        }catch(Exception ex){
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
    //pagination for Cancel jobs ends here
    
     public PageReference jobSheetPageTransfer(){
      try{
       PageReference pageRef = new PageReference('/apex/Amr_JobSheet');
       pageRef.getParameters().put('id',chosenId);
       pageRef.setRedirect(true);
       return pageRef;
       }catch(Exception ex){
            system.debug(ex.getMessage());
            return null;
        }
   }
   
   
}