public with sharing class Amr_RAPJobPortfolioController{
    
        public List<Amr_Alert__c> alert  {get; set;}
        public Amr_Job_Details__c jobDetails {get;set;}
        public Amr_Job_Allocation__c jobAlloc {get;set;}
        public list<Amr_Job_Allocation__c> jobDetailList{get;set;} 
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
        public String projectName{get;set;}
        public String startDate{get;set;}
        public String endDate{get;set;} 
        public Id chosenId {get; set;}
        public String testing {get; set;}
        public Boolean showPageButtonForPriority{get;set;}
        public Boolean showPageButtonForPending{get;set;}
        public Boolean showPageButtonForLive{get;set;}
        public Boolean showPageButtonForDormant{get;set;}
        public static final String NONE = '--None--';
    
    
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
        public Integer limitSizeForLiveJobs = 100;
        public Integer totalSizeForLiveJobs =0;
        public Integer TotalJobs {get; set;}
        public Integer TotalOpenJobs {get; set;}
        public Integer TotalJobsAccepted {get; set;}
        public Integer TotalJobstoAccept {get; set;}
        public Integer TotalClosedJob  {get; set;}
        public Integer TotalSavingsJobs  {get; set;}
         public Integer totalAlertCount  {get; set;}
        
        public list<Amr_Job_Allocation__c>priorityJobsToShow{get;set;}
        public list<Amr_Job_Allocation__c>pendingJobsToShow{get;set;}
        public list<Amr_Job_Allocation__c>dormantJobsToShow{get;set;}
        public list<Amr_Job_Allocation__c>liveJobsToShow{get;set;}
        
        public List<Amr_Job_Allocation__c> lstLiveJobsNew {get;set;}
        public  List<Amr_Job_Allocation__c> lstPendingJobsNew {get;set;}
        public List<Amr_Job_Allocation__c> lstpriorityJobsNew {get;set;}
        public List<Amr_Job_Allocation__c> lstDormantJobsNew {get;set;}
           
       // public list<Amr_Job_Allocation__c>priorityJobList{get;set;}
        //public list<Amr_Job_Allocation__c>pendingJobList{get;set;}
       // public list<Amr_Job_Allocation__c>dormantJobList{get;set;}
        //public list<Amr_Job_Allocation__c>liveJobList{get;set;}
        
    
        public List<SelectOption> listOfCategory{get;set;} 
        public List<SelectOption> listOfBrandPosition{get;set;}
        public  List<SelectOption> listOfBrand{get;set;}
        public  List<SelectOption> listOfSortOptions{get;set;}
      //  public  List<SelectOption> listOfProjectName{get;set;}
        transient List<Amr_Project_Details__c> projNameList;
        transient  String[]  listString{get;set;}
        
        public List<Amr_Alert__c> alertList{get;set;}
        public List<Amr_Alert__c> alertListForUnhide{get;set;}
        public String jobIdFromPage{get;set;}
        public Id chosenAlertId{get;set;}
      //  public Id chosenUnHideAlertId{get;set;}
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
        public String selectedUser1 {get;set;}
        transient  String[]  categoryString{get;set;}
    
        public Amr_RAPJobPortfolioController(){
          try{
            loggedInUserId = UserInfo.getUserId();
            jobDetails  = new Amr_Job_Details__c();
            jobAlloc = new Amr_Job_Allocation__c();
            alertList = new List<Amr_Alert__c>();
            alertListForUnhide= new List<Amr_Alert__c>();
            hideAlertObj = new Amr_Alert__c();
            hideAlertObjNew= new Amr_Alert__c();
            unHideAlertList = new List<Amr_Alert__c>();
            projNameList= [Select Name from Amr_Project_Details__c ORDER BY Name ASC limit 10000];
            listString= new list<string>();
              //   listString.add(NONE);
                for(Amr_Project_Details__c i : projNameList){
                        listString.add(i.name);
                }
                            
            jobIdFromPage = ApexPages.currentPage().getParameters().get('id');
            getJobDetailSearch();
            getAlertRecords();
            showUnhideRecords = false;
            flagForButtons = false;
            getTotalJobs();
            User objUser = [Select name From User Where Id = :loggedInUserId ];
            selectedUser = objUser.Name;
            //alert = [SELECT Alert_Message__c,job_Id__r.AdManagerText__c,New_Alert__c,Job_Id__c FROM Amr_Alert__c where New_Alert__c = today and hide__c = false order by New_Alert__c desc];
            
            Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
            categoryString = new list<string>();
             Set<MDO_Category__c> categorylst = utiltyObj.categoryValues();
            for(MDO_Category__c mdCat : categorylst){
                categoryString.add(mdCat.name);
        }
        
        listOfBrandPosition = new List<SelectOption>();
             listOfBrandPosition.add(new selectOption('--None--','--None--'));
          }
          catch(exception ex){
            
            system.debug('ex---'+ex.getmessage());
          }
        
       }
       
       
       
        public Integer closedJob  {get;set;}
        public Integer openJobs {get;set;}
        public Integer totalJobAccepted {get;set;}
        public Integer jobtoAccept {get;set;}
        
        
        public decimal savingSubmitted {get;set;}
        public decimal savingSubmittedMonth {get;set;}
        transient set<id> jobDetailsId = new set<id> ();
            
      
      public String getMethodToPassProjectNames(){
           return JSON.serialize(listString);
    }
      
        public void getTotalJobs() {
            try{
            
             totalJobAccepted  = 0;
         openJobs  = 0;
        closedJob  = 0;
         jobtoAccept  = 0;
        
            TotalJobs = [SELECT count()  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId and User__c = :loggedInUserId)  or  User__c = :loggedInUserId ) and AM_Job_Detail__c != null];
            
             for(Amr_Job_Allocation__c objJobAlloction : [SELECT AM_Job_Detail__c FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId and User__c = :loggedInUserId)  or  User__c = :loggedInUserId ) and AM_Job_Detail__c != null]){
                
                jobDetailsId.add(objJobAlloction.AM_Job_Detail__c);
            }
            system.debug('Value is !!'+TotalJobs); 
            
                if(TotalJobs != 0){
                    Decimal totalJobsNew = 0;
                    /*TotalOpenJobs  = [SELECT count()  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId and User__c = :loggedInUserId)  or  User__c = :loggedInUserId) AND (AM_Job_Detail__r.Job_Status__c = :Label.Amr_Status_Priority OR AM_Job_Detail__r.Job_Status__c = :Label.Amr_Status_Live) AND  Job_Status__c != 'Cancelled'];
                    pending = (TotalOpenJobs * 100)/TotalJobs;
                    
                    
                    TotalJobsAccepted     = [SELECT count()  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId AND User__c = :loggedInUserId) OR User__c = :loggedInUserId) AND AM_Job_Detail__r.Job_Status__c = :Label.Amr_Status_Live AND  Job_Status__c != 'Cancelled' ];
                    Live = (TotalJobsAccepted * 100)/TotalJobs;
                  
                    
                    TotalJobstoAccept = [SELECT count()  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId AND User__c = :loggedInUserId) OR User__c = :loggedInUserId) AND AM_Job_Detail__r.Job_Status__c = :Label.Amr_Status_Priority AND  Job_Status__c != 'Cancelled'];
                    Priority = (TotalJobstoAccept * 100)/TotalJobs;
                    
                    TotalOpenJobs = 0;
                    TotalOpenJobs = TotalJobsAccepted + TotalJobstoAccept;
                     pending = (TotalOpenJobs * 100)/TotalJobs;
                     
                    TotalClosedJob  = [SELECT count()  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId AND User__c = :loggedInUserId) OR User__c = :loggedInUserId) AND AM_Job_Detail__r.Job_Status__c = :Label.Amr_Status_Dormant AND  Job_Status__c != 'Cancelled'];
                    dormant = (TotalClosedJob * 100)/TotalJobs;
                   
                    totalJobsNew = pending + Live+ dormant + Priority;
                    system.debug('****pending***'+pending);
                    system.debug('****Live***'+Live);
                    system.debug('****dormant***'+dormant);
                    system.debug('****Priority***'+Priority);
                    pending = (pending * 100)/totalJobsNew;
                    
                    Live = (Live * 100)/totalJobsNew;
                    dormant = (dormant * 100)/totalJobsNew;
                    Priority = (Priority * 100)/totalJobsNew;*/
                    
                    TotalSavingsJobs  = 0;
                                   
                    
                    //New Dashboard 
                    
                      totalJobAccepted  = [SELECT count()  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId and User__c = :loggedInUserId)  or  User__c = :loggedInUserId ) and AM_Job_Detail__c != null and Job_Allocated__c = 'Yes'  and Job_Status__c = 'Accepted'];
                    openJobs  = [SELECT count()  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId and User__c = :loggedInUserId)  or  User__c = :loggedInUserId ) and AM_Job_Detail__c != null and Job_Allocated__c = 'Yes'  and Job_Status__c = 'Accepted'  and Started__c = 'Yes'];
                    closedJob  = [SELECT count()  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId and User__c = :loggedInUserId)  or  User__c = :loggedInUserId ) and AM_Job_Detail__c != null and Job_Allocated__c = 'Yes'  and AM_Job_Detail__r.Job_Status__c = 'Dormant'];
                    jobtoAccept  = [SELECT count()  FROM  Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId and User__c = :loggedInUserId)  or  User__c = :loggedInUserId ) and AM_Job_Detail__c != null and Job_Allocated__c = 'Yes'  and ( Job_Status__c != 'Accepted' or Job_Status__c != 'Cancelled')];
                    
                    TotalClosedJob = Integer.valueOf( closedJob);
                    TotalOpenJobs = Integer.valueOf(openJobs);
                    TotalJobsAccepted = Integer.valueOf(totalJobAccepted);
                    TotalJobstoAccept = Integer.valueOf(jobtoAccept);
                    
                    totalJobAccepted = (totalJobAccepted * 100)/TotalJobs;
                    openJobs = (openJobs * 100)/TotalJobs;
                    closedJob = (closedJob * 100)/TotalJobs;
                    jobtoAccept = (jobtoAccept * 100)/TotalJobs;
                    
                     totalJobsNew = totalJobAccepted + openJobs+ closedJob + jobtoAccept;
                     
                    totalJobAccepted = Integer.valueOf((totalJobAccepted * 100)/totalJobsNew);
                    
                    openJobs = Integer.valueOf((openJobs * 100)/totalJobsNew);
                    closedJob = Integer.valueOf((closedJob * 100)/totalJobsNew);
                    
                    jobtoAccept = Integer.valueOf((jobtoAccept * 100)/totalJobsNew);
                    AggregateResult[] groupedResults
                                                     = [SELECT Sum(Saving_Average_of_Quotes__c)averQuote ,Sum(Saving_Accepted_Quote_Euro__c) acceptQuote FROM Amr_Saving__c Where  Job_Details__c IN : jobDetailsId];
                    Object avgAmount = groupedResults[0].get('averQuote');
                    Object acceAmount = groupedResults[0].get('acceptQuote');
                    
                    savingSubmitted = Decimal.valueOf(String.valueOf(groupedResults[0].get('avgAmount')));
                    savingSubmittedMonth = Decimal.valueOf(String.valueOf(groupedResults[0].get('acceAmount')));
                                                                    
                                                                    
                    //savingSubmitted = [Select Saving_Accepted_Quote_Euro__c, Saving_Average_of_Quotes__c from Amr_Saving__c Where  Job_Details__c IN : jobDetailsId ];
                   // savingSubmitted = decimal.valueOf(avgAmount);
                  //  savingSubmittedMonth = decimal.valueOf(acceAmount);
                }
            }
             catch(exception ex){
            
            system.debug('ex---'+ex.getmessage());
          }
        
        }
        
        
        public List<SelectOption> getTypes(){
            Schema.sObjectType sobject_type = Amr_Job_Details__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('Brodcast_Market__c').getDescribe().getPickListValues();

            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));
          }
                return options;
        }
 
       
         public List<PieWedgeData> getPieData() 
        {  
            List<PieWedgeData> data = new List<PieWedgeData>();
            Integer amrJobDetails = 0;
            Integer amrJobDetailsUserCount = 0;
            Integer i = 0;
            
            amrJobDetails   = [SELECT count() FROM  Amr_Job_Details__c ];
            amrJobDetailsUserCount = [SELECT count() FROM  Amr_Job_Allocation__c Where (AM_Job_Detail__r.ownerId =:loggedInUserId AND User__c = :loggedInUserId) OR User__c = :loggedInUserId];
            
            //i = (amrJobDetailsUserCount * 100)/amrJobDetails;
            AggregateResult[] groupedResults = [SELECT Sum(Euro_Saving_Average_of_Quotes__c)averQuote ,Sum(Saving_Accepted_Quote_Euro__c) acceptQuote FROM Amr_Saving__c Where  Job_Details__c IN : jobDetailsId];
                    //Object avgAmount = groupedResults[0].get('averQuote');
                    //Object acceAmount = groupedResults[0].get('acceptQuote');
                    savingSubmitted = 0;
                    savingSubmittedMonth = 0;
                    if(groupedResults[0].get('averQuote') != null &&  groupedResults[0].get('acceptQuote') != null){
                    savingSubmitted = Decimal.valueOf(String.valueOf(groupedResults[0].get('averQuote')));
                    savingSubmittedMonth = Decimal.valueOf(String.valueOf(groupedResults[0].get('acceptQuote')));
                    }
                    
            data.add(new PieWedgeData('Total Saving Submitted(Euro)',Integer.valueOf(savingSubmitted)));
            //data.add(new PieWedgeData('Total Saving -  Month',Integer.valueOf(savingSubmittedMonth)));
              
            return data;  
        }  
        
        
        
         public List<PieWedgeData> getPieDataSaving() 
        {  
            List<PieWedgeData> data = new List<PieWedgeData>();
            Integer amrJobDetails = 0;
            Integer amrJobDetailsUserCount = 0;
            Integer i = 0;
            
            //amrJobDetails   = [SELECT count() FROM  Amr_Saving__c ];
           // amrJobDetailsUserCount = [SELECT count() FROM  Amr_Saving__c Where  CreatedById  = :loggedInUserId or LastModifiedById = : loggedInUserId];
            
            //i = (amrJobDetailsUserCount * 100)/amrJobDetails;
            
            Date startOfMonth = Date.today().toStartOfMonth();
Date startOfNextMonth = startOfMonth.addMonths(1);

             AggregateResult[] groupedResults  = [SELECT Sum(Saving_Average_of_Quotes__c)averQuote ,Sum(Saving_Accepted_Quote_Euro__c) acceptQuote FROM Amr_Saving__c Where  Job_Details__c IN : jobDetailsId and  Createddate >= :startOfMonth AND CreatedDate < :startOfNextMonth];
                    //Object avgAmount = groupedResults[0].get('averQuote');
                    //Object acceAmount = groupedResults[0].get('acceptQuote');
                    savingSubmitted = 0;
                    savingSubmittedMonth = 0;
                    if(groupedResults[0].get('averQuote') != null &&  groupedResults[0].get('acceptQuote') != null){
                    savingSubmitted = Decimal.valueOf(String.valueOf(groupedResults[0].get('averQuote')));
                    savingSubmittedMonth = Decimal.valueOf(String.valueOf(groupedResults[0].get('acceptQuote')));
                    }
                    
            //data.add(new PieWedgeData('Total Saving Submitted',Integer.valueOf(savingSubmitted)));
            data.add(new PieWedgeData('Total Saving -  Month(Euro)',Integer.valueOf(savingSubmittedMonth)));
            
            //data.add(new PieWedgeData('Total',amrJobDetails));
           // data.add(new PieWedgeData(selectedUser,amrJobDetailsUserCount));
              
            return data;  
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
      public String getMethodToPassProjNames(){
      
        listString= new list<string>();
          //   listString.add(NONE);
            for(Amr_Project_Details__c i :[Select Name from Amr_Project_Details__c ORDER BY Name ASC limit 10000]){
                    listString.add(i.name);
            }
       return JSON.serialize(listString);
      }
        
        public void getAlertRecords(){
            alertList = [select Id,Alert_Message__c,job_Id__r.AdManagerText__c,New_Alert__c,Job_Id__c from Amr_Alert__c where ownerId =:loggedInUserId AND Hide__c =:false AND New_Alert__c= today];          
            totalAlertCount =  [select count() from Amr_Alert__c where ownerId =:loggedInUserId AND Hide__c =:false AND New_Alert__c= today];
            system.debug('alertList !!'+alertList);
            System.debug('ALert COUNT -> ' + totalAlertCount);
            alertListForUnhide= [select Id,New_Alert__c,Alert_Message__c from Amr_Alert__c where ownerId =:loggedInUserId AND Hide__c =:true];
              system.debug('alertList !!'+alertListForUnhide);
        }
        
      /*  public PageReference hideAlert(){
        
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
        
        public PageReference unhideAlert(){ 
        
        showUnhideRecords = true;
        flagForButtons = false;
        
             system.debug('chosenAlertId !!'+chosenAlertId);
            hideAlertObjNew = [select Id,New_Alert__c,Alert_Message__c from Amr_Alert__c where Id=:chosenUnHideAlertId limit 1];
             system.debug('chosenAlertId!!'+chosenAlertId);
             For(Amr_Alert__c alert:unHideAlertList){
                 if(alert.Id == hideAlertObjNew.Id){
                     alert.Hide__c = false;
                 }
             }
             update unHideAlertList;
             getAlertRecords();
             unHideAlertShow();
             system.debug('alertList inside  new unhide alrert!!'+alertList);
            return null;
        }
        
       
        
         
        public PageReference unHideAlertHide(){
        
           showUnhideRecords =false;
           flagForButtons = false;
           
                    
            return null;
        }*/
        
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
        try{
               Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
              categoryString = new list<string>();
              Set<MDO_Category__c> categorylst = utiltyObj.categoryValues();
              for(MDO_Category__c mdCat : categorylst){
                categoryString.add(mdCat.name);
            }
            System.debug('cATE ->' +  JSON.serialize(categoryString));
            return JSON.serialize(categoryString);
        }
            catch(exception ex){
            
                system.debug('ex---'+ex.getmessage());
                return null;
          }
         return null;
     }
      /*
         public List<SelectOption> getBrandPositioningList(){  
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
             
         }  */
         
      public PageReference  brandPositionListData(){    
          try{
             System.debug('BBBBBBRANDDD ->'+ categoryName);  
             Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
             Set<MDO_BrandPositions__c> brandPositionlst = utiltyObj.brandPostitionValues(categoryName);
              
              system.debug('brandPositionListttoo----->'+brandPositionlst );
             
             listOfBrandPosition = new List<SelectOption>();
             listOfBrandPosition.add(new selectOption('--None--','--None--'));
             Set<String> brnadPosNameSet = new Set<String>();
             for(MDO_BrandPositions__c bps : brandPositionlst){
                 
                 if(!brnadPosNameSet.contains(bps.brand_position_id__r.name)){
                     listOfBrandPosition.add(new selectOption(bps.brand_position_id__r.name,bps.brand_position_id__r.name));
                 
                     brnadPosNameSet.add(bps.brand_position_id__r.name);
                 }
             }
     
            system.debug('brandPositionListtt----->'+listOfBrandPosition);
         }
            catch(exception ex){
            
                system.debug('ex---'+ex.getmessage());
                return null;
          }
            return null;
         
     }
         /*
          public List<SelectOption> getBrandList(){  
          /*system.debug('brand pos!!'+brandPos);    
             listOfBrand = new List<SelectOption>();
             List<Amr_Brand__c> brandList= [Select id,Name from Amr_Brand__c where Brand_Positioning__c =: brandPos Limit 1];                                     //rem
             listOfBrand.add(new selectOption('--None--','--None--'));
             for(Amr_Brand__c bp : brandList)
                 listOfBrand.add(new selectOption(bp.Id,bp.Name));
             return listOfBrand;*/ /*
             
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
    //    system.debug('========>'+brandPosName+'category name=====>'+categoryName);

        listOfBrand.add(new selectOption('--None--','--None--'));

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
        }
        catch(exception ex){
            
                system.debug('ex---'+ex.getmessage());
                return null;
          }
          System.debug(categoryName +'   '+brandPos+ '      '+ listOfBrand);

        return listOfBrand;
    }
         
         /* public List<SelectOption> getProjectNameList(){      
             listOfProjectName = new List<SelectOption>();
             List<Amr_Project_Details__c> ProjectNameList= [Select id,Name from Amr_Project_Details__c];
             listOfProjectName .add(new selectOption('--None--','--None--'));
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
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Project_Leader_Country__c','Location project leader (Country)'));
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.ProductCategory__c','Category'));
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Brand_Final__c','Brand name'));
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Project_Details__c','Project name'));
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Lead_Creative_Agency_name__c','Lead agency name'));
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Allocated_Budget_euro__c','Allocated budget (euro)'));
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Brodcast_Market__c','Broadcast market'));
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Production_Activity_Type__c','Production activity type'));
             listOfSortOptions.add(new selectOption('AM_Job_Detail__r.Campaign_Name__c','Campaign Name'));
             listOfSortOptions.add(new selectOption('Job_Shared__c','Job shared'));
             listOfSortOptions.add(new selectOption('Job_Status__c','Accepted and email sent'));
             listOfSortOptions.add(new selectOption('Started__c','Started'));
             listOfSortOptions.add(new selectOption('Reported__c','Reported'));
             return listOfSortOptions;
         }
    
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
        
        jobDetailList = new list<Amr_Job_Allocation__c>();
         
        string soql ='select AM_Job_Detail__r.Campaign_Name__c,AM_Job_Detail__r.Project_Name_Other__c ,Job_Status__c,User__c,Job_Shared__c,Reported__c,Started__c,Job_Allocated__c,Started_Image__c,Job_Allocated_Image__c,AM_Job_Detail__r.Project_Details__c,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Job_Status__c,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.ProductCategory__c,AM_Job_Detail__r.Brand_Position__c,AM_Job_Detail__r.Brand_Final__c,AM_Job_Detail__r.Stage_of_Production_Activity__c,AM_Job_Detail__r.Job_Accepted__c,AM_Job_Detail__r.Job_Started__c,Job_Status_Image__c,Reported_Image__c,AM_Job_Detail__r.Job_Reported__c,AM_Job_Detail__r.job_Shared__c  From Amr_Job_Allocation__c where Name!=null and AM_Job_Detail__r.Job_Cancelled__c = false';
        if(String.isNotBlank(loggedInUserId)){
        
        soql += ' and ((AM_Job_Detail__r.OwnerId = \''+loggedInUserId+'\' AND User__c = \''+loggedInUserId+'\') or  User__c = \''+loggedInUserId+'\')';
               system.debug('soql loggedInUserId'+soql);
        }
        
       if (String.isNotBlank(String.valueOf(jobDetails.Start_Date__c))){
            Datetime startdate = jobDetails.Start_Date__c;
            String dateTimeFormat = startdate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            
             soql += ' and AM_Job_Detail__r.createdDate'+  ' >= '+ dateTimeFormat ;
              
        }
        
        if (String.isNotBlank(String.valueOf(jobDetails.End_Date__c))){ 
            Datetime endate  = jobDetails.End_Date__c;
             String dateTimeFormat1 = endate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            
              soql += ' and AM_Job_Detail__r.createdDate ' +  ' < '+ dateTimeFormat1 ;
             
        }
        
         if (String.isNotBlank(jobDetails.Project_Leader_Cluster__c)){
         
               soql += ' and AM_Job_Detail__r.Project_Leader_Cluster__c = \''+String.escapeSingleQuotes(projLeaderCluster)+'\'';
              
        }
        
         if(String.isNotBlank(projLeaderCountry)){
        soql += ' and AM_Job_Detail__r.Project_Leader_Country__c = \''+String.escapeSingleQuotes(projLeaderCountry)+'\'';
               
        }
        
         if(String.isNotBlank(agencyName)){
        soql += ' and AM_Job_Detail__r.Lead_Creative_Agency_name__c = \''+String.escapeSingleQuotes(agencyName)+'\'';
               
         
         }
          if(String.isNotBlank(brodMarket)){
       soql += ' and AM_Job_Detail__r.Brodcast_Market__c LIKE \''+String.escapeSingleQuotes(brodMarket)+'%\'';
               
         }
          if(String.isNotBlank(categoryName) && categoryName != NONE){
          
        soql += ' and AM_Job_Detail__r.ProductCategory__r.name = \''+String.escapeSingleQuotes(categoryName)+'\'';
             
         }
          if(String.isNotBlank(brandPos) && brandPos != NONE){
          
        soql += ' and AM_Job_Detail__r.Brand_Position__r.name = \''+String.escapeSingleQuotes(brandPos)+'\'';
               
         }
          if(String.isNotBlank(brandName) && brandName != NONE){
        soql += ' and AM_Job_Detail__r.Brand_Final__r.name = \''+String.escapeSingleQuotes(brandName)+'\'';
              
         }
         if(String.isNotBlank(stageLogged)){
        soql += ' and AM_Job_Detail__r.Stage_of_Production_Activity__c = \''+String.escapeSingleQuotes(stageLogged)+'\'';
              
         }
         if(String.isNotBlank(jobAlloc.Job_Status__c)){
        soql += ' and Job_Status__c = \''+jobAlloc.Job_Status__c+'\'';
              
         }
         if(String.isNotBlank(jobAlloc.Started__c)){
        soql += ' and Started__c = \''+jobAlloc.Started__c+'\'';
              
         }
         if(String.isNotBlank(jobAlloc.Reported__c)){
        soql += ' and Reported__c = \''+jobAlloc.Reported__c+'\'';
              
         }
         system.debug('jobAlloc.Job_Shared__c!!'+jobAlloc.Job_Shared__c);
         if(String.isNotBlank(jobAlloc.Job_Shared__c)){
        soql += ' and Job_Shared__c = \''+jobAlloc.Job_Shared__c+'\'';
              
         }
         if(String.isNotBlank(addNumber)){
        soql += ' and AM_Job_Detail__r.AdManagerText__c LIKE \''+'%'+ String.escapeSingleQuotes(addNumber)+'%\'';
              
         }
         if(String.isNotBlank(projEmail)){
        soql += ' and AM_Job_Detail__r.Unilever_Project_Leader_Email__c LIKE \''+String.escapeSingleQuotes(projEmail)+'%\'';
              
         }
         if(String.isNotBlank(projectName)){
        soql += ' and AM_Job_Detail__r.Project_Details__c = \''+String.escapeSingleQuotes(projectName)+'\'';
              
         }
         if(String.isNotBlank(projectName)){
        soql += ' and AM_Job_Detail__r.Project_Name_Other__c = \''+String.escapeSingleQuotes(jobDetails.Project_Name_Other__c)+'\'';
              
         }
         if(String.isNotBlank(jobDetails.Campaign_Name__c)){
        soql += ' and AM_Job_Detail__r.Campaign_Name__c LIKE \''+String.escapeSingleQuotes(jobDetails.Campaign_Name__c)+'%\'';
            
         }
         
         //soql+=' limit 120';
         jobDetailList = Database.query(soql);
         
         system.debug('*****soql ******'+soql );
         system.debug('*** My List values ' + jobDetailList);
        
            getPriorityJobs();
            getPendingJobs();
            getDormantJobs();
            getLiveJobs();
        }
        catch(exception ex){
            
                system.debug('ex---'+ex.getmessage());
                return null;
       }    
           
       return null;
       
       }
       
       public Void getPriorityJobs(){
           List<Amr_Job_Allocation__c> priorityJobList = new List<Amr_Job_Allocation__c>();
           Set<Id>priorityJobIds = new Set<Id>();
           Set<String> priorityStrings = new Set<String>();
           for(Amr_Job_Allocation__c jobId:jobDetailList){
               if(jobId.AM_Job_Detail__r.Job_Status__c == Label.Amr_Status_Priority){
                   priorityJobIds.add(jobId.AM_Job_Detail__r.Id);
                   priorityStrings.add(jobId.AM_Job_Detail__r.AdManagerText__c);
               }
           }
           system.debug('priorityStrings!!'+priorityStrings+'!!priorityJobIds'+priorityJobIds);
            
          String prioritySoql = 'select AM_Job_Detail__r.Campaign_Name__c,AM_Job_Detail__r.Project_Name_Other__c,Job_Status__c,User__c,Job_Shared__c,Reported__c,Started__c,Job_Allocated__c,Started_Image__c,Job_Allocated_Image__c,AM_Job_Detail__r.Project_Details__r.Name,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Job_Status__c,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.ProductCategory__r.Name,AM_Job_Detail__r.Brand_Position__r.Name,AM_Job_Detail__r.Brand_Final__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,AM_Job_Detail__r.Job_Accepted__c,AM_Job_Detail__r.Job_Started__c,Job_Status_Image__c,Reported_Image__c,AM_Job_Detail__r.Job_Reported__c  From Amr_Job_Allocation__c where AM_Job_Detail__r.Id IN:priorityJobIds  ';
          system.debug('prioritySoql !!!'+prioritySoql );
          if(String.isNotBlank(selectedSortPriorityOption) && selectedSortPriorityOption !=NONE){
               prioritySoql += ' ORDER BY '+String.escapeSingleQuotes(selectedSortPriorityOption)+' ASC';
          
         }
           system.debug('prioritySoql01 !!!'+prioritySoql );
           priorityJobList = Database.query(prioritySoql );
               
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
           List<Amr_Job_Allocation__c> pendingJobList = new List<Amr_Job_Allocation__c>();
           Set<Id>pendingJobIds = new Set<Id>();
           for(Amr_Job_Allocation__c jobId:jobDetailList){
               if( (jobId.AM_Job_Detail__r.Job_Status__c == Label.Amr_Status_Priority || jobId.AM_Job_Detail__r.Job_Status__c == Label.Amr_Status_Live) && jobId.Job_Status__c != 'Accepted' && jobId.Job_Status__c != 'Cancelled'){
                   pendingJobIds.add(jobId.AM_Job_Detail__r.Id);
               }
           }
         // String accepted = 'Accepted';
         // String cancelled = 'Cancelled';
          String pendingSoql ='select AM_Job_Detail__r.Campaign_Name__c,AM_Job_Detail__r.Project_Name_Other__c,Job_Status__c,User__c,Job_Shared__c,Reported__c,Started__c,Job_Allocated__c,Started_Image__c,Job_Allocated_Image__c,AM_Job_Detail__r.Project_Details__r.Name,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Job_Status__c,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.ProductCategory__r.Name,AM_Job_Detail__r.Brand_Position__r.Name,AM_Job_Detail__r.Brand_Final__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,AM_Job_Detail__r.Job_Accepted__c,AM_Job_Detail__r.Job_Started__c,Job_Status_Image__c,Reported_Image__c,AM_Job_Detail__r.Job_Reported__c,AM_Job_Detail__r.job_Shared__c  From Amr_Job_Allocation__c where AM_Job_Detail__r.Id IN:pendingJobIds  and ((AM_Job_Detail__r.ownerId =:loggedInUserId AND User__c = :loggedInUserId) OR User__c = :loggedInUserId) and ( Job_Status__c != \'Accepted\' or Job_Status__c != \'Cancelled \')' ;
          
          system.debug('pendingSoql !!!'+pendingSoql );
          if(String.isNotBlank(selectedSortPendingOption) && selectedSortPendingOption !=NONE){
               pendingSoql += ' ORDER BY '+String.escapeSingleQuotes(selectedSortPendingOption)+' ASC';
               
         }
           system.debug('pendingSoql 01!!!'+pendingSoql );
          pendingJobList = Database.query(pendingSoql);
          paginationMethodForPendingJobs(pendingJobList);
          
       }
       
       //method to get sort pending list
        public pageReference getSortedPendingList(){
            system.debug('selectedSortPendingOption!!!'+selectedSortPendingOption);
            getPendingJobs();
            return null;
        }
        
              //pagination for pending jobs starts here
       public void paginationMethodForPendingJobs(List<Amr_Job_Allocation__c> jobListToDisplay){
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
              removeduplicatePending(lstPending);
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
                system.debug('pendingJobsToShow!!'+pendingJobsToShow.size()+'lstPendingJobsNew!!'+lstPendingJobsNew.size());
          }
            
        public void beginningForPendingJobs(){
            
          
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
        }
       
        public void nextForPendingJobs(){
          /*
              List<Amr_Job_Allocation__c> lstPending = new List<Amr_Job_Allocation__c>();
             String pendingSoql ='select AM_Job_Detail__r.Campaign_Name__c,AM_Job_Detail__r.Project_Name_Other__c,Job_Status__c,User__c,Job_Shared__c,Reported__c,Started__c,Job_Allocated__c,Started_Image__c,Job_Allocated_Image__c,AM_Job_Detail__r.Project_Details__r.Name,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Job_Status__c,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.ProductCategory__r.Name,AM_Job_Detail__r.Brand_Position__r.Name,AM_Job_Detail__r.Brand_Final__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,AM_Job_Detail__r.Job_Accepted__c,AM_Job_Detail__r.Job_Started__c,Job_Status_Image__c,Reported_Image__c,AM_Job_Detail__r.Job_Reported__c,AM_Job_Detail__r.job_Shared__c  From Amr_Job_Allocation__c where ((AM_Job_Detail__r.ownerId =:loggedInUserId AND User__c = :loggedInUserId) OR User__c = :loggedInUserId) and ( Job_Status__c != \'Accepted\' or Job_Status__c != \'Cancelled \')' ;
            lstPending =  Database.query(pendingSoql);
             removeduplicatePending(lstPending);
              lstPendingJobsNew = pendingJobsToShow;*/
              pendingJobsToShow = new List<Amr_Job_Allocation__c>();
            //pendingJobsToShow.clear();
              system.debug('lstPendingJobsNew22222'+lstPendingJobsNew.size()+'pendingJobsToShow2222'+pendingJobsToShow.size());
             counterForPendingJobs = counterForPendingJobs+limitSizeForPendingJobs;
             system.debug('counterForPendingJobs'+counterForPendingJobs+'limitSizeForPendingJobs'+limitSizeForPendingJobs);
            if((counterForPendingJobs+limitSizeForPendingJobs) <= totalSizeForPendingJobs){
                system.debug('counterForPendingJobs'+counterForPendingJobs);
                system.debug('limitSizeForPendingJobs'+limitSizeForPendingJobs);
                
                system.debug('totalSizeForPendingJobs'+totalSizeForPendingJobs);
                
                for(Integer i=counterForPendingJobs;i<(counterForPendingJobs+limitSizeForPendingJobs);i++){
                    system.debug('pendingJobsToShow11111'+pendingJobsToShow.size());
                    pendingJobsToShow.add(lstPendingJobsNew.get(i));
                    system.debug('pendingJobsToShow2222'+pendingJobsToShow.size());
                    
                }
            } else{
                for(Integer i=counterForPendingJobs;i<totalSizeForPendingJobs;i++){
                system.debug('pendingJobsToShow3333'+pendingJobsToShow.size());
                    pendingJobsToShow.add(lstPendingJobsNew.get(i));
                    system.debug('pendingJobsToShow4444'+pendingJobsToShow.size());
                }
            }
        }
       
        public void previousForPendingJobs(){
          
            pendingJobsToShow.clear();
            counterForPendingJobs=counterForPendingJobs-limitSizeForPendingJobs;       
                for(Integer i=counterForPendingJobs;i<(counterForPendingJobs+limitSizeForPendingJobs); i++){
                pendingJobsToShow.add(lstPendingJobsNew.get(i));
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
                    pendingJobsToShow.add(lstPendingJobsNew.get(i));
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
       
       
       public void getDormantJobs(){
           List<Amr_Job_Allocation__c> dormantJobList = new List<Amr_Job_Allocation__c>();
           Set<Id>dormantJobIds = new Set<Id>();
           for(Amr_Job_Allocation__c jobId:jobDetailList){
               if(jobId.AM_Job_Detail__r.Job_Status__c == Label.Amr_Status_Dormant){
                   dormantJobIds.add(jobId.AM_Job_Detail__r.Id);
               }
           }
           String dormantSoql ='select AM_Job_Detail__r.Campaign_Name__c,AM_Job_Detail__r.Project_Name_Other__c,Job_Status__c,User__c,Job_Shared__c,Reported__c,Started__c,Job_Allocated__c,Started_Image__c,Job_Allocated_Image__c,AM_Job_Detail__r.Project_Details__r.name,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Job_Status__c,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.ProductCategory__r.Name,AM_Job_Detail__r.Brand_Position__r.Name,AM_Job_Detail__r.Brand_Final__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,AM_Job_Detail__r.Job_Accepted__c,AM_Job_Detail__r.Job_Started__c,Job_Status_Image__c,Reported_Image__c,AM_Job_Detail__r.Job_Reported__c,AM_Job_Detail__r.job_Shared__c  From Amr_Job_Allocation__c where AM_Job_Detail__r.Id IN:dormantJobIds  and ((AM_Job_Detail__r.ownerId =:loggedInUserId AND User__c = :loggedInUserId) OR User__c = :loggedInUserId) ';
           system.debug('dormantSoql!!!'+dormantSoql);
          
          if(String.isNotBlank(selectedSortDormantOption) && selectedSortDormantOption !=NONE){
               dormantSoql+= ' ORDER BY '+String.escapeSingleQuotes(selectedSortDormantOption)+' ASC';
               
         }
           system.debug('dormantSoql01!!!'+dormantSoql);
          dormantJobList = Database.query(dormantSoql);
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
           list<Amr_Job_Allocation__c> liveJobList = new List<Amr_Job_Allocation__c>();
           Set<Id>liveJobIds = new Set<Id>();
           for(Amr_Job_Allocation__c jobId:jobDetailList){
               if(jobId.AM_Job_Detail__r.Job_Status__c == Label.Amr_Status_Live){
                   liveJobIds.add(jobId.AM_Job_Detail__r.Id);
               }
           }
             
          String liveSoql ='select AM_Job_Detail__r.Campaign_Name__c,AM_Job_Detail__r.Project_Name_Other__c,Job_Status__c,User__c,Job_Shared__c,Reported__c,Started__c,Job_Allocated__c,Started_Image__c,Job_Allocated_Image__c,AM_Job_Detail__r.Production_Activity_Type__c,AM_Job_Detail__r.Brodcast_Market__c,AM_Job_Detail__r.Allocated_Budget_euro__c,AM_Job_Detail__r.Job_Status__c,AM_Job_Detail__r.createdDate,AM_Job_Detail__r.AdManagerText__c,AM_Job_Detail__r.Unilever_Project_Leader_Email__c,AM_Job_Detail__r.Project_Leader_Cluster__c,AM_Job_Detail__r.Project_Leader_Country__c,AM_Job_Detail__r.Lead_Creative_Agency_name__c,AM_Job_Detail__r.ProductCategory__c,AM_Job_Detail__r.ProductCategory__r.Name,AM_Job_Detail__r.Brand_Position__r.Name,AM_Job_Detail__r.Project_Details__r.Name,AM_Job_Detail__r.Brand_Final__r.Name,AM_Job_Detail__r.Stage_of_Production_Activity__c,AM_Job_Detail__r.Job_Accepted__c,AM_Job_Detail__r.Job_Started__c,Job_Status_Image__c,Reported_Image__c,AM_Job_Detail__r.Job_Reported__c,AM_Job_Detail__r.job_Shared__c  From Amr_Job_Allocation__c where AM_Job_Detail__r.Id IN:liveJobIds and ((AM_Job_Detail__r.ownerId =:loggedInUserId AND User__c = :loggedInUserId) OR User__c = :loggedInUserId) ';
          system.debug('liveSoql!!!'+liveSoql);
          if(String.isNotBlank(selectedSortLiveOption) && selectedSortLiveOption != NONE){
               liveSoql+= ' ORDER BY '+String.escapeSingleQuotes(selectedSortLiveOption)+' ASC';
               
         }
           system.debug('liveSoql01!!!'+liveSoql);
          liveJobList = Database.query(liveSoql);
          paginationMethodForLiveJobs(liveJobList);  
       
       }
       
       //method to get sort live list
        public pageReference getSortedLiveList(){
            system.debug('selectedSortLiveOption!!!'+selectedSortLiveOption);
            getLiveJobs();
            return null;
        }
        
        //pagination for priority jobs starts here
       public void paginationMethodForPriorityJobs(List<Amr_Job_Allocation__c> jobListToDisplay){
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
              system.debug('******priorityJobsToShow11'+priorityJobsToShow);    
              lstPriority = jobListToDisplay;
              //priorityJobsToShow = new List<Amr_Job_Allocation__c>();
              removeduplicate(lstPriority);
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
             system.debug('******priorityJobsToShow'+priorityJobsToShow);
          }
            
        public void beginningForPriorityJobs(){
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
        }
       
     
        public void nextForPriorityJobs(){
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
        }
       
        public void previousForPriorityJobs(){
            priorityJobsToShow.clear();
            counterForPriorityJobs=counterForPriorityJobs-limitSizeForPriorityJobs;       
                for(Integer i=counterForPriorityJobs;i<(counterForPriorityJobs+limitSizeForPriorityJobs); i++){
                priorityJobsToShow.add(lstpriorityJobsNew.get(i));
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
                    priorityJobsToShow.add(lstpriorityJobsNew.get(i));
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
        
        
     
      
        
        //pagination for dormant jobs starts here
       public void paginationMethodForDormantJobs(List<Amr_Job_Allocation__c> jobListToDisplay){
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
              removeduplicateDormant(lstDormant);
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
            
          }
            
        public void beginningForDormantJobs(){
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
        }
       
        public void nextForDormantJobs(){
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
        }
       
        public void previousForDormantJobs(){
            dormantJobsToShow.clear();
            counterForDormantJobs=counterForDormantJobs-limitSizeForDormantJobs;       
                for(Integer i=counterForDormantJobs;i<(counterForDormantJobs+limitSizeForDormantJobs); i++){
                dormantJobsToShow.add(lstDormantJobsNew.get(i));
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
                    dormantJobsToShow.add(lstDormantJobsNew.get(i));
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
       public void paginationMethodForLiveJobs(List<Amr_Job_Allocation__c> jobListToDisplay){
           liveJobsToShow = new list<Amr_Job_Allocation__c>();
           lstLiveJobsNew = new List<Amr_Job_Allocation__c>();
           totalSizeForLiveJobs = jobListToDisplay.size();
           system.debug('totalSizeForLiveJobs!!'+totalSizeForLiveJobs+'jobListToDisplay!!'+jobListToDisplay);
           if(limitSizeForLiveJobs < totalSizeForLiveJobs){
           showPageButtonForLive = true;
           }else{
           showPageButtonForLive = false;
           }
                   
             if(!jobListToDisplay.isEmpty()){
              List<Amr_Job_Allocation__c> lstLive = new List<Amr_Job_Allocation__c>();
                
              lstLive = jobListToDisplay;
              //liveJobsToShow = new List<Amr_Job_Allocation__c>();
              removeduplicateLive(lstLive);
              lstLiveJobsNew = liveJobsToShow;
              totalSizeForLiveJobs = lstLiveJobsNew.size();
              system.debug('lstLiveJobsNew!!'+lstLiveJobsNew.size());
              system.debug('totalSizeForLiveJobs!!'+totalSizeForLiveJobs);
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
            
          }
            
        public void beginningForLiveJobs(){
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
            
        }
       
        public void nextForLiveJobs(){
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
        }
       
        public void previousForLiveJobs(){
            liveJobsToShow.clear();
            counterForLiveJobs=counterForLiveJobs-limitSizeForLiveJobs;       
                for(Integer i=counterForLiveJobs;i<(counterForLiveJobs+limitSizeForLiveJobs); i++){
                    system.debug('i!!'+i);
                liveJobsToShow.add(lstLiveJobsNew.get(i));
            }
        }
    
        public void lastForLiveJobs (){
            liveJobsToShow.clear();
            if(math.mod(totalSizeForLiveJobs , limitSizeForLiveJobs) == 0){
                counterForLiveJobs = limitSizeForLiveJobs * ((totalSizeForLiveJobs/limitSizeForLiveJobs)-1);
                system.debug('inside first');
            } else if (math.mod(totalSizeForLiveJobs , limitSizeForLiveJobs) != 0){
                counterForLiveJobs = limitSizeForLiveJobs * ((totalSizeForLiveJobs/limitSizeForLiveJobs));
                 system.debug('inside second');
            }
            system.debug('counterForLiveJobs!'+counterForLiveJobs+'totalSizeForLiveJobs!'+totalSizeForLiveJobs+'liveJobsToShow!'+liveJobsToShow+'lstLiveJobsNew!'+lstLiveJobsNew);
            for(Integer i=counterForLiveJobs-1;i<totalSizeForLiveJobs-1;i++){
                    liveJobsToShow.add(lstLiveJobsNew.get(i));
            }
          }
       
        public Boolean getDisableNextForLiveJobs(){
            system.debug('*c**'+counterForLiveJobs +'*****limitSizeForLiveJobs**'+ limitSizeForLiveJobs +  +'totalSizeForLiveJobs '+totalSizeForLiveJobs);
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
        
           public void removeduplicate(List<Amr_Job_Allocation__c> lstPriorityJobsToShow){
             List<Amr_Job_Allocation__c> lstremoveduplicate = new  List<Amr_Job_Allocation__c>();
             lstremoveduplicate = lstPriorityJobsToShow;
            // lstPriorityJobsToShow = new  List<Amr_Job_Allocation__c>();
             Set<String>jobAllocIds = new Set<String>();
             for(Amr_Job_Allocation__c job:lstremoveduplicate){
              
                if(!jobAllocIds.contains(job.AM_Job_Detail__r.Id )){
                    jobAllocIds.add(job.AM_Job_Detail__r.Id);
                   // lstPriorityJobsToShow.add(job);
                    priorityJobsToShow.add(job);
                }
               system.debug('******priorityJobsToShow'+priorityJobsToShow);
             }
            
        }
        
        
         public void removeduplicatePending(List<Amr_Job_Allocation__c> lstPriorityJobsToShow){
             List<Amr_Job_Allocation__c> lstremoveduplicate = new  List<Amr_Job_Allocation__c>();
             lstremoveduplicate = lstPriorityJobsToShow;
             //lstPriorityJobsToShow = new  List<Amr_Job_Allocation__c>();
             Set<String>jobAllocIds = new Set<String>();
              for(Amr_Job_Allocation__c job:lstremoveduplicate){
                 if(!jobAllocIds.contains(job.AM_Job_Detail__r.Id )){
                    jobAllocIds.add(job.AM_Job_Detail__r.Id);
                    pendingJobsToShow.add(job);
                }
               system.debug('******pendingJobsToShow'+pendingJobsToShow);
             }
            
        }
        
        
         public void removeduplicateDormant(List<Amr_Job_Allocation__c> lstPriorityJobsToShow){
             List<Amr_Job_Allocation__c> lstremoveduplicate = new  List<Amr_Job_Allocation__c>();
             lstremoveduplicate = lstPriorityJobsToShow;
            // lstPriorityJobsToShow = new  List<Amr_Job_Allocation__c>();
             Set<String>jobAllocIds = new Set<String>();
             
              for(Amr_Job_Allocation__c job:lstremoveduplicate){
                if(!jobAllocIds.contains(job.AM_Job_Detail__r.Id )){
                    jobAllocIds.add(job.AM_Job_Detail__r.Id);
                 //   lstPriorityJobsToShow.add(job);
                    dormantJobsToShow.add(job);
                }
               system.debug('******dormantJobsToShow'+dormantJobsToShow);
             }
            
        }
        
         public void removeduplicateLive(List<Amr_Job_Allocation__c> lstPriorityJobsToShow){
             List<Amr_Job_Allocation__c> lstremoveduplicate = new  List<Amr_Job_Allocation__c>();
             lstremoveduplicate = lstPriorityJobsToShow;
           //  lstPriorityJobsToShow = new  List<Amr_Job_Allocation__c>();
             Set<String>jobAllocIds = new Set<String>();
              for(Amr_Job_Allocation__c job:lstremoveduplicate){
                if(!jobAllocIds.contains(job.AM_Job_Detail__r.Id )){
                    jobAllocIds.add(job.AM_Job_Detail__r.Id);
              //      lstPriorityJobsToShow.add(job);
                    liveJobsToShow.add(job);
                }
               system.debug('******liveJobsToShow'+liveJobsToShow.size());
             }
            
        }
    
     public PageReference jobSheetPageTransfer(){
          
           PageReference pageRef = new PageReference('/apex/Amr_JobSheet');
           pageRef.getParameters().put('id',chosenId);
           pageRef.setRedirect(true);
           return pageRef;
       }
    
        public void alertHide(){
            
            System.debug('Alert Id -> ' + selectedAlert);
            
            List<Amr_Alert__c> alertHideList = new List<Amr_Alert__c>();
            alertHideList = [SELECT Alert_Message__c,Hide__c FROM Amr_Alert__c where id = :selectedAlert];
           if(!alertHideList.isEmpty()){
            
            for(Amr_Alert__c alertObj : alertHideList){
                alertObj .Hide__c = TRUE;
            }
            update alertHideList;
           }
           alertList = [select Id,Alert_Message__c,job_Id__r.AdManagerText__c,New_Alert__c,Job_Id__c from Amr_Alert__c where ownerId =:loggedInUserId AND Hide__c =:false AND New_Alert__c= today];          
            totalAlertCount =  [select count() from Amr_Alert__c where ownerId =:loggedInUserId AND Hide__c =:false AND New_Alert__c= today];
        }
    
    }