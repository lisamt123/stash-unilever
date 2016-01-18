public with sharing class Amr_Joballocation_Page {
 
   /* public String getJobDetails() {
        return null;
    }*/


    public String jobStatus{get;set;}
   // public List<selectoption> userName{get;set;}
    public String selectedRapName{get;set;}
    public List<PermissionSetAssignment> userData {get;set;}
    public String profileName {get;set;}
    public Amr_Job_Details__c jobList{ get; set; }      
   // public String getSelectedCountry{get;set;}    
   // public String getCurrencyRecords{get;set;}
    public String selectedProjectName{get;set;}
    public String projectName{get;set;}
    public String brandPosName{get;set;}
    public String brandNameFromPage{get;set;} 
    public List<SelectOption> listOfCategory{get;set;} 
    public List<SelectOption> listOfBrandPosition{get;set;}
    public  List<SelectOption> listOfBrand{get;set;}
    public  List<SelectOption> listOfProjectName {get;set;}
    public String selectedCountry {get;set;}    
    public String categoryName {get;set;}
    public boolean isPrimaryUser {get;set;}
   public list<string> listOfRAPSelected{get;set;}  
    public Integer sharedListSize {get;set;}
    public List<selectOption> currencyRecords{
    get {
        List<selectOption> options = new List<selectOption>();
        for (Amr_CurrencyConversionRate__c currencyConversion: Amr_CurrencyConversionRate__c.getAll().values())
        options.add(new SelectOption(String.valueOf(currencyConversion.Currency_Unit_To_Euro__c),currencyConversion.Name+'-'+currencyConversion.Currency_Unit__c));
        return options;
    }
    set;
  }
   public List<selectoption> selectUsername{get;set;} 
      public List<selectoption> selectJobPriority{get;set;}
   public String priority{get;set;}
   public String selectedRAPUser{get;set;} 
   public String addManagerNumber{get;set;}
   public ID abc{get;set;}
   public Boolean primaryRap{get;set;}
   public Amr_Job_Allocation__c jobAlloc;
   public Id jobId ;  
   public static boolean rapAllocateCheck;
   public List <Amr_Job_Allocation__c > jobSharedList {get;set;}
   public List<SelectOption> sharedRapOption {get;set;}
   public List<Id> selectedUnshareRapName {get;set;}
   public List<Amr_Project_Details__c> projNameList {get;set;}
   public  String[]  listString{get;set;}
   public boolean jobCancelled {get;set;}
   public static String ownerIdOfSelectedJob;
   
    public Amr_Joballocation_Page (){
        //listOfRAPSelected = new List<String>();
        selectUsername= new list<selectoption>();
        try{
            jobId = ApexPages.CurrentPage().getParameters().get('id'); 
       }
       catch(Exception e){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Job Id'));
           return;
       }
        
        if(String.isBlank(jobID)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
            return;
        }
         
        for(PermissionSetAssignment  userObj :[select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name = :Label.Amr_RAP AND Assignee.id != :userInfo.getUserId() order by Assignee.name] ){
        try{
            SelectOption obj=new SelectOption(userObj.Assignee.id,userObj.Assignee.name);
            selectUsername.add(obj);
        }
        catch(Exception e){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid User'));
           return;
       }
        }  
        userData = [select PermissionSet.Name from PermissionSetAssignment  where Assignee.id = :userinfo.getUserId()];
        Set<String> userNameSet = new Set<String>();
        for(PermissionSetAssignment permission : userData){
            userNameSet.add(permission.PermissionSet.Name);
        }
        if(userNameSet.contains(Label.Amr_CAP)){
            profileName = Label.Amr_CAP;
        }else{
            profileName = Label.Amr_RAP;
        }
        System.debug('pRofile ->' + profileName);      
    
      //  userName = new List<SelectOption>();
    
      try{
            if(profileName == Label.Amr_CAP){
                jobAlloc = [Select id,User__c, Job_Allocated__c,Reported__c,Started__c,Job_Status__c,Is_Primary__c  from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId Limit 1];
            }
            else{
                jobAlloc = [Select id,User__c, Job_Allocated__c,Reported__c,Started__c,Job_Status__c,Is_Primary__c  from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId  AND user__c =: userInfo.getUserId() Limit 1 ];
            }
            jobList=[select id,Lead_Agency_Name_Other__c,OwnerId,Job_Cancelled__c,Job_Status__c,Tv_Moving_Image__c,AdManagerText__c,Brand__c, Cinema_Moving_Image__c, Radio_Audio__c, Print_Still_Image__c, Out_Of_Home_Moving_Image__c, Out_Of_Home_Still_Image__c, Out_Of_Home_Audio__c, In_Store_Moving_Image__c, In_Store_Still_Image__c, In_Store_Audio__c, Digital_Moving_Image__c, Digital_Still_Image__c, Digital_Audio__c, Internal_Video_Moving_Image__c, Tv__c,Cinema__c, Radio__c, Print__c, Out_Of_Home__c, In_Store__c, Digital__c, Internal_Video__c, Category__c,Rework_Exisiting_Material__c,Buyouts_Talent__c,Buyouts_Music__c,New_Original_Master__c,Create_Additional_Material__c,Language_Adaptation_Of_Master__c,Require_Music__c,Require_Celebrity_Talent__c,Stage_of_Production_Activity__c,Project_Description__c,Check_With_CMI__c,Production_Activity_Type__c,Target_Air_Date__c,Execution_Name__c,Ad_Manager_Number__c,Campaign_Name__c,Your_Email_Address__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Unilever_Finance_Member_Email__c,Final_Approver_Of_Material_Email__c,Function_You_Are_Part__c,Budget_Responsibility__c,Budget_Allocated_Input_Value__c,Allocated_Budget_euro__c,Brand_Positioning__c,Lead_Creative_Agency_name__c,Lead_Agency_Location_Cluster__c,Lead_Agency_Location_Country__c,Agency_Contact_Account_Director_Email__c,Digital_Agency_Name__c,Any_other_agencies_involved__c,Project_Name__c,Project_Name_Other__c,Project_Location_Cluster__c,Project_Location_Country__c,Project_Details__c,Brodcast_Market__c from Amr_Job_Details__c where id=: jobId];        
            System.debug('PPPRRRRROOOOO  ---> ' + jobAlloc);
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_NoJobFound));
            return;
        }  
        
        if(jobAlloc.is_Primary__c){
            jobSharedList = [ select id, User__c, User__r.Name from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId AND Is_Primary__c = False order by User__r.Name];
            sharedOption(jobSharedList);
            isPrimaryUser = TRUE;
        }
        else{
            isPrimaryUser = false;
        }
      
      selectJobPriority = new List<SelectOption>();
            selectJobPriority.add(new SelectOption('Pending','Pending'));
            selectJobPriority.add(new SelectOption('Priority','Priority'));
            selectJobPriority.add(new SelectOption('Live','Live'));
            selectJobPriority.add(new SelectOption('Dormant','Dormant')); 
      
     /*
        userData = [select PermissionSet.Name from PermissionSetAssignment  where Assignee.id = :userinfo.getUserId()];
        Set<String> userNameSet = new Set<String>();
        for(PermissionSetAssignment permission : userData){
            userNameSet.add(permission.PermissionSet.Name);
        }
        if(userNameSet.contains(Label.Amr_CAP)){
            profileName = Label.Amr_CAP;
        }else{
            profileName = Label.Amr_RAP;
        }
        System.debug('pRofile ->' + profileName);
   // profileName = 'CAP';
        System.debug('PPPRRRRROOOOO  ---> ' + profileName); */
        
        projNameList= [Select Name from Amr_Project_Details__c ORDER BY Name ASC limit 10000];
         listString= new list<string>();
         listString.add('--None--');
        For(Amr_Project_Details__c i : projNameList){
                listString.add(i.name);
        }
        
        
              system.debug('jobList!!'+jobList);      
        selectedProjectName = jobList.Project_Details__c;  
        categoryName = jobList.Category__c;
        brandPosName = jobList.Brand_Positioning__c;
        brandNameFromPage = jobList.Brand__c;
             system.debug('selectedProjectName!!'+selectedProjectName);      
        jobStatus = jobAlloc.Job_Status__c;    
        primaryRap=  jobAlloc.Is_Primary__c;    
        addManagerNumber = jobList.AdManagerText__c;
        jobCancelled = jobList.Job_Cancelled__c;
        ownerIdOfSelectedJob = jobList.OwnerId;
     }
         
         public String getMethodToPassProjectNames(){
        system.debug('serialize!!'+JSON.serialize(listString));
        return JSON.serialize(listString);
    }
    
    public void sharedOption(List<Amr_Job_Allocation__c> jobSharedList ){
           
            sharedRapOption = new List<SelectOption>();     
            sharedListSize = jobSharedList.size();
            if(!jobSharedList.IsEmpty()){
                for(Amr_Job_Allocation__c sharedData : jobSharedList ){
                    SelectOption obj=new SelectOption(sharedData.User__c,sharedData.User__r.Name);
                    sharedRapOption.add(obj);
                }
           }
        }
    
        
     public PageReference reAllocate() {
        
             if(String.isBlank(jobID)){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
                 return null;
             }
          
             else{
                system.debug('selected RAP !!! '+ selectedRAPUser);
                 jobReAllocate(selectedRAPUser,jobId, jobList);
                 if(rapAllocateCheck == TRUE){
                      jobList.OwnerId = selectedRAPUser;
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.Amr_Error_JobAlreadyAllocated));
                      return null;    
                 }
                 else{
                     ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_Success_JobAllocated));
                    return null;
                }
            } 
    }
        
    public static void jobReAllocate(String selectedRap, Id jobId, Amr_Job_Details__c jobDet){
        
        System.debug('List Of RAP ->'+ selectedRap + ' Job ID -> ' + jobId );
        List<Amr_Job_Allocation__c> jobAllocList = [select Id,Name,User__c from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId AND Is_Primary__c = TRUE]; // AND User__c = :userInfo.getUserId()
        List<Amr_Job_Details__Share> jobShare = [Select Id from Amr_Job_Details__Share where id = :jobId];
        for(Amr_Job_Allocation__c jAlloc : jobAllocList ){
            if(jobDet.ownerId == selectedRap){
                rapAllocateCheck = TRUE;        
            }
              else{
                rapAllocateCheck = FALSE; 
            }
        }
        System.debug('CHECK -> ' + rapAllocateCheck  +  'jobAllocate ->   ' +  jobAllocList );
        if(rapAllocateCheck == false){
            if(!jobAllocList.isEmpty()){
                delete jobAllocList;
            }
            if(!jobShare.isEmpty()){
                delete jobShare;
            }
             
          
            Amr_Job_Allocation__c jobAllocObj = new Amr_Job_Allocation__c();
            Amr_Job_Details__Share jobShareObj = new Amr_Job_Details__Share();
       //     Amr_Job_Allocation__Share jobAllocShare = new Amr_Job_Allocation__Share();

                         System.debug('Selected RAP ->' + selectedRap);
            jobAllocObj.AM_Job_Detail__c = jobId;
            jobAllocObj.Is_Primary__c = TRUE;
            jobAllocObj.User__c = selectedRap ;             
            jobAllocObj.Job_Allocated__c = 'Yes';
            
            jobShareObj.ParentId = jobId;
            jobShareObj.UserOrGroupId = selectedRap ;               
            jobShareObj.AccessLevel = 'Edit';
            
    
            User userList = [Select id, email from User where Id = :selectedRap];
            if(!String.isBlank(userList.Email)){
                 jobDet.JobAllocated_Email__c = userList.email;   
            }
  
               
            System.debug('User Email List -> ' + userList );
            
            insert jobShareObj;      
            insert jobAllocObj;               
            
       /*     jobAllocShare.ParentId = jobAllocObj.id;                                          // This part is to be deleted, since we are changing ownerid only
            jobAllocShare.UserOrGroupId = selectedRap;
            jobAllocShare.AccessLevel = 'Read';
            jobAllocShare.RowCause = Schema.Amr_Job_Details__share.RowCause.Manual;  
            
            insert jobAllocShare; */
             jobDet.OwnerId = selectedRap;
            update jobDet;
            
           // Amr_EmailSendingClass.emailSending(jobId , emailAddress, 'Amr_RAPAllocatedJob', new List<Id>());  
         }  
    }
        
         
    public pagereference cancelJob(){
       
        if(String.isBlank(jobID)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
            return null;
        }
        else{
            if(jobList.Job_Cancelled__c == TRUE){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobAlreadyCancelled));  
                return null;
           } 
           else{
               jobCancellation(jobList, jobId, jobAlloc);
               PageReference navPage = Page.Am_CapJobPortfolio;
               navPage.setRedirect(true);
               return navPage;
          }
       }
    }
       
       
    public static void jobCancellation(Amr_Job_Details__c jobDetail, String jobId, Amr_Job_Allocation__c jobAlloc ){
       
        System.debug('Job Details Object ->'+ jobDetail + ' Job ID -> ' + jobId );
        List<String> toEmailAddress = new List<String>();
        jobDetail.Job_Cancelled__c = TRUE;
        jobAlloc.Job_Status__c = Label.Amr_Job_Cancelled;
        update jobAlloc;
        List<Amr_Job_Allocation__c> canceledJobList = [select id from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId And Is_Primary__c = false];
        if(!canceledJobList.isEmpty()){
            delete canceledJobList;
        }
        List<Amr_Job_Details__Share> cancelShareList = [Select Id from Amr_Job_Details__Share where id = :jobId AND  UserOrGroupId != :ownerIdOfSelectedJob];
        System.debug('HELLO ->' + cancelShareList);
        if(!cancelShareList.isEmpty()){
            delete cancelShareList; 
        }
        toEmailAddress.add(jobDetail.Unilever_Project_Leader_Email__c);
        toEmailAddress.add(jobDetail.Unilever_Finance_Member_Email__c);
        toEmailAddress.add(jobDetail.Final_Approver_Of_Material_Email__c);
        toEmailAddress.add(jobDetail.Agency_Contact_Account_Director_Email__c );
        toEmailAddress.add(jobDetail.Your_Email_Address__c);
        update jobDetail;
     //   Amr_EmailSendingClass.emailSending(jobId,toEmailAddress, 'Amr_JobCancellation', new List<Id>() );
     
    }
       
      
    public PageReference acceptJob(){
         
       
        System.debug('Job Id ->'+ jobId);
        if(jobStatus == Label.Amr_Job_Accepted) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobAlreadyAccepted)); 
            return null;
       }
        if(joblist.Job_Cancelled__c == TRUE){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIsCancelled));  
            return null;
        }
       else{
           jobAlloc.Job_Status__c  = Label.Amr_Job_Accepted;
           jobStatus = jobAlloc.Job_Status__c;
           jobAlloc.Job_Status__c= Label.Amr_Job_Accepted;      
           update jobAlloc;
           
           String userEmail = [Select email from User where id = :jobAlloc.User__c].email;
           joblist.Job_Accepted_Email__c = userEmail;
           update joblist;
           
           
           List <String> userEmailList = new List<String>();
           userEmailList.add(userEmail);
           
        //   Amr_EmailSendingClass.emailSending(jobId  , userEmailList , 'Amr_RAPAcceptedJob', new List<Id>() );
           ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_JobAccepted));             
           return null;
       }  
    }  
 
    public PageReference cancelRapJob(){
        
 
        System.debug('Job Id ->'+ jobId);
         
        if(joblist.Job_Cancelled__c == TRUE){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobAlreadyCancelled));  
            return null;
        }
         
        else{
            jobCancellation(jobList, jobId, jobAlloc);
            PageReference navPage = Page.Am_JobPortfolio;
            navPage.setRedirect(true);
            return navPage;
       }
    }
  
       
    public PageReference reAllocateRAP() {
        
        System.debug('Job Id ->'+ jobId);
        if(String.isBlank(jobID)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
            return null;
       }
       else{
           jobReAllocate(selectedRapName, jobId, jobList); 
            if(rapAllocateCheck){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.Amr_Error_JobAlreadyAllocated));
                return null;    
           }
           else{
               ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_Success_JobAllocated));
                PageReference landingPage = Page.Am_JobPortfolio;
                return landingPage;

          }
      }    
        
    }
        
        
    public PageReference changePriority(){
       
       System.debug('Job Id ->'+ jobId);
        if(String.isBlank(jobID)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
            return null;
        }
        else{
            update jobList;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_Success_StatusChanged)); 
            return null;
       }    
    }
        
        
        public List<SelectOption> getCategoryList(){      
        
         listOfCategory = new List<SelectOption>();
         List<Amr_Category__c> categoryList= [Select id,Name from Amr_Category__c];
         listOfCategory.add(new selectOption('Select','Select'));
         for(Amr_Category__c cat : categoryList){
             listOfCategory.add(new selectOption(cat.Id,cat.Name));
         }
        System.debug('Category List -> ' + listOfCategory);
         return listOfCategory;
     }
     
     public List<SelectOption> getProjectNameList(){      
        
         listOfProjectName = new List<SelectOption>();
         List<Amr_Project_Details__c> ProjectNameList= [Select id,Name from Amr_Project_Details__c order by name limit 500];
         listOfProjectName .add(new selectOption('Select','Select'));
         for(Amr_Project_Details__c cat : ProjectNameList){
             listOfProjectName.add(new selectOption(cat.Id,cat.Name));
         }
        
         System.debug('Category List -> ' + listOfProjectName );
         return listOfProjectName ;
     }
     
    public List<SelectOption> getBrandPositioningList(){    
       
        System.debug('Category Name  -> '+ categoryName);  
        listOfBrandPosition = new List<SelectOption>();
        List<Amr_Brand_Positioning__c> brandPosList= [Select id,Name from Amr_Brand_Positioning__c where Category__c =: categoryName];
       
        listOfBrandPosition.add(new selectOption('Select','Select'));
        for(Amr_Brand_Positioning__c bps : brandPosList){
            listOfBrandPosition.add(new selectOption(bps.Id,bps.Name));
        }    
       
        System.debug('Brand Position -> '+ brandPosList);  
        return listOfBrandPosition;
         
    }
     
    public List<SelectOption> getBrandList(){      
       
        System.debug('Brand Position Name  -> '+ brandPosName);
        listOfBrand = new List<SelectOption>();
        List<Amr_Brand__c > brandList= [Select id,Name from Amr_Brand__c where Brand_Positioning__c=: brandPosName];
        listOfBrand.add(new selectOption('Select','Select'));
       
        for(Amr_Brand__c  bp : brandList){
            listOfBrand.add(new selectOption(bp.Id,bp.Name));
        }    
        System.debug('Brand List -> '+ listOfBrand);  
        return listOfBrand;
     }

    public Pagereference updateJob(){
    
        jobList.Project_Details__c = selectedProjectName;
        jobList.Category__c = categoryName ;
        jobList.Brand_Positioning__c = brandPosName ;
        jobList.Brand__c = brandNameFromPage ;
        updateAdManagerText();
       
        
        update jobList;
        
     /*    PageReference pageRef = new PageReference('/apex/Amr_JobSheet');
         pageRef.getParameters().put('id',jobList.Id);
         pageRef.setRedirect(true);
         return pageRef; */
         
         return null;
    }
    
    public void updateAdManagerText(){
        
        
        Amr_Brand__c jobBrand = [select Name from Amr_Brand__c  where Id =: brandNameFromPage];
        system.debug('brandNameFromPage !!'+jobList.Brand__r.Name);
        String adManText = jobList.AdManagerText__c;
        String adManTextUpdatedStr = adManText.Right(6);
        String brandUpdatedNameStr =jobBrand.Name.left(3); 
        String finalAdManagerNumber = brandUpdatedNameStr + adManTextUpdatedStr ;
        system.debug('finalAdManagerNumber !!'+finalAdManagerNumber+'adManText !!'+adManText +'adManTextUpdatedStr !!'+adManTextUpdatedStr +'brandUpdatedNameStr !!'+brandUpdatedNameStr  );
        jobList.AdManagerText__c = finalAdManagerNumber;
        
    }
    

    public pagereference recordShare(){
     
         System.debug('Job Id ->'+ jobId);
        if(String.isBlank(jobID)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_JobIdNotFound));
            return null;
        }
        else{
             List<Amr_Job_Allocation__c> shareCheckList = [Select id, User__r.Name, User__c from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId AND User__c IN :listOfRAPSelected AND Is_Primary__c = false];
             Set<String> rapSet = new Set<String>();
             List<String> finalRapList = new List<String>();
             if(!shareCheckList.isEmpty()){
                for(Amr_Job_Allocation__c rapAlreadyShared : shareCheckList ){
                    String errorMsg = 'Job already Shared with ' + rapAlreadyShared.User__r.Name;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsg));
                    rapSet.add(rapAlreadyShared.User__c);
                }
            }
            System.debug('SET -> ' + rapSet);
            for(String raps : listOfRAPSelected){
                if(!rapSet.contains(raps)){
                    finalRapList.add(raps);
                }
            }
            System.debug('FINAL -> ' + finalRapList);
            List<Amr_Job_Details__share> listOfJobShare = new List<Amr_Job_Details__share>();
            List<Amr_Job_Allocation__c> listOfRAPJob = new List<Amr_Job_Allocation__c>();
            List<Amr_Job_Allocation__Share> listOfSharedAllocatedJob = new List<Amr_Job_Allocation__Share>();
            Amr_Job_Details__Share jobShr; 
            Amr_Job_Allocation__c jobAllocObj;
            Amr_Job_Allocation__Share jobAllocShare;
            
            for (String eachSelectedUser :finalRapList)
            {
                system.debug('Value'+eachSelectedUser);      
                jobShr  = new Amr_Job_Details__share ();
                jobShr.ParentId = jobId;
                jobShr.UserOrGroupId = eachSelectedUser;
                jobShr.AccessLevel = 'Read';
                jobShr.RowCause = Schema.Amr_Job_Details__share.RowCause.Manual;  
                listOfJobShare.add(jobShr);
                
              
               jobAllocObj = new Amr_Job_Allocation__c();
               jobAllocObj.AM_Job_Detail__c = jobId;
               jobAllocObj.Is_Primary__c = FALSE;
               jobAllocObj.User__c = eachSelectedUser;  
               jobAllocObj.Job_Allocated__c= 'Yes';  
               jobAllocObj.Job_Shared__c  = 'Yes';       
               listOfRAPJob.add(jobAllocObj);

          }
          insert listOfJobShare;
          insert listOfRAPJob;
          System.debug('List Of Job Alloc -> ' + listOfRAPJob);
          System.debug('Job SHARE -> ' + listOfJobShare);
          for(Amr_Job_Allocation__c jAlloc : listOfRAPJob){
                 jobAllocShare = new Amr_Job_Allocation__Share();
                jobAllocShare.ParentId = jAlloc.id;
                jobAllocShare.UserOrGroupId = jAlloc.User__c;
                jobAllocShare.AccessLevel = 'Read';
                jobAllocShare.RowCause = Schema.Amr_Job_Details__share.RowCause.Manual;  
                listOfSharedAllocatedJob.add(jobAllocShare); 
          }
          System.debug('SHARING -> ' + listOfSharedAllocatedJob);
          insert listOfSharedAllocatedJob;
                  System.debug('INSERTED');
          List<User> userList = [Select id, email from User where Id IN :listOfRAPSelected];
          List<String> emailAddress = new List<String>();
          for(User userEmail : userList){
              emailAddress.add(userEmail.email);
          }
          List<Amr_Job_Allocation__c> rapNameList = [Select id, User__r.Name, User__c from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId AND User__c IN :finalRapList AND Is_Primary__c = false];
          for(Amr_Job_Allocation__c jAlloc : rapNameList ){
              String successMsg = 'Job shared successfully with '+ jAlloc.User__r.Name ;
              ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,successMsg ));
          }
          jobSharedList = [ select id, User__c, User__r.Name from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId AND Is_Primary__c = False order by User__r.Name];
          sharedListSize = jobSharedList.size();
          sharedOption(jobSharedList );
          system.debug('List Size ->  ' + sharedListSize );
          system.debug('List  ->  ' + jobSharedList );
      
   //  ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_Success_JobShared)); 
  //   Amr_EmailSendingClass.emailSending(jobId, emailAddress, 'Amr_RAPSharedJob', new List<id>());
 
     return null;
    // return null;   
    }  
     
   }
   public PageReference jobUnShare(){
   
       System.debug('Job Id ->'+ jobId);
       
       List<Amr_Job_Details__share> listOfJobDetailShare = [Select Id from Amr_Job_Details__Share where id = :jobId AND UserOrGroupId IN :selectedUnshareRapName AND UserOrGroupId != :userInfo.getUserId()];
       List<Amr_Job_Allocation__Share> listOfSharedAllocatedJob = [Select Id from Amr_Job_Allocation__Share where ParentId = :jobId AND UserOrGroupId IN :selectedUnshareRapName AND UserOrGroupId != :userInfo.getUserId()];
       List<Amr_Job_Allocation__c> listOfSharedJob = [Select Id from Amr_Job_Allocation__c where AM_Job_Detail__c  = :jobId AND User__c IN :selectedUnshareRapName  AND User__c != :userInfo.getUserId() AND Is_Primary__c != TRUE];
       if(!listOfJobDetailShare.IsEmpty()){
           delete listOfJobDetailShare;
       }
       if(!listOfSharedAllocatedJob.isEmpty()){
           delete listOfSharedAllocatedJob;
       } 
       if(!jobSharedList.isEmpty()){
           delete listOfSharedJob;
       }
       new Amr_Joballocation_Page();
       PageReference pageRef = Page.AM_JobAllocations_bhupendra;
     pageRef.getParameters().put('id',jobId);
     pageRef.setRedirect(true);
     return PageRef;
   }
}