public class Amr_Joballocation_Page {
 
    public String getJobDetails() {
        return null;
    }


    public String jobStatus{get;set;}
    public List<selectoption> userName{get;set;}
    public List<String> selectedRapName{get;set;}
    public User userData {get;set;}
    public String profileName {get;set;}
    public Amr_Job_Details__c joblist{ get; set; }      
    public String getSelectedCountry{get;set;}    
    public String getCurrencyRecords{get;set;}
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
    public list<User> userStr = new list<User>();
    public list<string> leftselected{get;set;}   
    public List<selectOption> currencyRecords{
    get {
        List<selectOption> options = new List<selectOption>();
        for (Amr_CurrencyConversionRate__c cc: Amr_CurrencyConversionRate__c.getAll().values())
        options.add(new SelectOption(String.valueOf(cc.Currency_Unit_To_Euro__c),cc.Name+'-'+cc.Currency_Unit__c));
        return options;
    }
    set;
  }
   public List<selectoption> usernam{get;set;} 
   public String selectusernameStr{get;set;}
   public String priority{get;set;}
   public List<String> selectusernamelst{get;set;}
   public Boolean primaryRap{get;set;}
   Amr_Job_Allocation__c jobAlloc;
   Id jobId ;  
   Map<String,String> mapUserNametoEmail = new   Map<String,String>();  
  
  
    public Amr_Joballocation_Page (){
        leftselected = new List<String>();
        usernam = new list<selectoption>();
        try{
            jobId = ApexPages.CurrentPage().getParameters().get('id'); 
       }
       catch(Exception e){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Job Id'));
           return;
       }
       
       
        if(ApexPages.CurrentPage().getParameters().get('id') == null || jobId == null  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'JobId not found'));
            return;
        }
         
        for(user usr :[Select name, Profile.Name,email, ProfileId,  Id From User  where  profile.name='RAP' order by name] ){
            selectoption obj=new selectoption(usr.id,usr.name);
            usernam.add(obj);
            mapUserNametoEmail.put(usr.id,usr.email);
        }        
    
        userName = new list<selectoption>();
    
        userData = [Select id, profile.Name, name from User where id = :userinfo.getUserId()];
        profileName = userData.profile.Name;
        System.debug('pRofile ->' + proFileName);
        proFileName = 'RAP';
        try{
            jobAlloc = [Select id,User__c, Job_Status__c,Is_Primary__c  from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId Limit 1 ]; // user__c = userInfo.getUserId();
            jobList=[select id,Job_Cancelled__c,Tv_Moving_Image__c,AdManagerText__c,Brand__c, Cinema_Moving_Image__c, Radio_Audio__c, Print_Still_Image__c, Out_Of_Home_Moving_Image__c, Out_Of_Home_Still_Image__c, Out_Of_Home_Audio__c, In_Store_Moving_Image__c, In_Store_Still_Image__c, In_Store_Audio__c, Digital_Moving_Image__c, Digital_Still_Image__c, Digital_Audio__c, Internal_Video_Moving_Image__c, Tv__c,Cinema__c, Radio__c, Print__c, Out_Of_Home__c, In_Store__c, Digital__c, Internal_Video__c, Category__c,Rework_Exisiting_Material__c,Buyouts_Talent__c,Buyouts_Music__c,New_Original_Master__c,Create_Additional_Material__c,Language_Adaptation_Of_Master__c,Require_Music__c,Require_Celebrity_Talent__c,Stage_of_Production_Activity__c,Project_Description__c,Check_With_CMI__c,Production_Activity_Type__c,Target_Air_Date__c,Execution_Name__c,Ad_Manager_Number__c,Campaign_Name__c,Your_Email_Address__c,Unilever_Project_Leader_Email__c,Project_Leader_Cluster__c,Project_Leader_Country__c,Unilever_Finance_Member_Email__c,Final_Approver_Of_Material_Email__c,Function_You_Are_Part__c,Budget_Responsibility__c,Budget_Allocated_Input_Value__c,Allocated_Budget_euro__c,Brand_Positioning__c,Lead_Creative_Agency_name__c,Lead_Agency_Location_Cluster__c,Lead_Agency_Location_Country__c,Agency_Contact_Account_Director_Email__c,Digital_Agency_Name__c,Any_other_agencies_involved__c,Project_Name__c,Project_Name_Other__c,Project_Location_Cluster__c,Project_Location_Country__c,Project_Details__c,Brodcast_Market__c from Amr_Job_Details__c where id=: jobId];        
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There\'s no job for given job id'));
            return;
        }  
                    
        selectedProjectName = jobList.Project_Details__c;  
        categoryName = jobList.Category__c;
        brandPosName = jobList.Brand_Positioning__c;
        brandNameFromPage = jobList.Brand__c;
                  
        jobStatus = jobAlloc.Job_Status__c;    
        primaryRap=  jobAlloc.Is_Primary__c;    
     }
        
        
     public PageReference reAllocate() {
        
         jobId = ApexPages.CurrentPage().getParameters().get('id'); 
             if(String.isBlank(jobID)){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'JobId not found'));
                 return null;
             }
          
             else{
                 jobReAllocate(selectusernamelst,jobId); 
                 ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Job has been successfully allocated to the seleted RAP/RAPs'));
                 return null;
            } 
    }
        
    public static void jobReAllocate(List<String> selectedRapList, Id jobId){
        
        List<Amr_Job_Allocation__c> jobAllocList = [select Id,Name from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobId AND Is_Primary__c = TRUE];
        List<Amr_Job_Details__Share> jobShare = [Select Id from Amr_Job_Details__Share where id = :jobId];
        System.debug('Delete List ->'+ jobAllocList);
        System.debug('Delete List ->'+ jobShare);
        if(jobAllocList.size() > 0){
            delete jobAllocList;
        }
        if(jobShare.size()>0){
            delete jobShare;
        }
             
        List<Amr_Job_Allocation__c> jobRAPList = new List<Amr_Job_Allocation__c>();
        List<Amr_Job_Details__Share > jobShareRAPList = new List<Amr_Job_Details__Share >();
        Amr_Job_Allocation__c jobAllocObj;
        Amr_Job_Details__Share jobShareObj;
        System.debug('selectusernamelst->' + selectedRapList);
 
        for(String selectedRap : selectedRapList) {
            jobAllocObj = new Amr_Job_Allocation__c();
            jobAllocObj.AM_Job_Detail__c = jobId;
            jobAllocObj.Is_Primary__c = TRUE;
            jobAllocObj.User__c = selectedRap ;             
            System.debug('selectedRap ->' + selectedRap );
            jobRAPList.add(jobAllocObj);
            
            
            jobShareObj  = new Amr_Job_Details__Share();
            jobShareObj.ParentId = jobId;
            jobShareObj.UserOrGroupId = selectedRap ;               
            jobShareObj.AccessLevel = 'Edit';
            jobShareRAPList.add(jobShareObj);
               
        }
        List<User> userList = [Select id, email from User where Id IN :selectedRapList];
        List<String> emailAddress = new List<String>();
        for(User userEmail : userList){
            emailAddress.add(userEmail.email);
        }
           
        System.debug('UUUSSSERRRR EEMMMAAAIIILLL -> ' + emailAddress);
        System.debug('UUUSSSERRRR LLIIISSSSTTTTT -> ' + userList );
        insert jobRAPList;               
        insert jobShareObj;
        Amr_EmailSendingClass.rapJobAllocation(jobId , emailAddress);    
    }
        
         
    public pagereference cancelJob(){
        System.debug('CANCELLL');
              
        Id jobId = ApexPages.CurrentPage().getParameters().get('id'); 
        if(String.isBlank(jobID)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'JobId not found'));
            return null;
        }
        else{
            if(jobList.Job_Cancelled__c == TRUE){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Job already cancelled'));  
                return null;
           } 
           else{
               jobCancellation(jobList, jobId);
               PageReference navPage = Page.Amr_JobUnCancel;
               navPage.setRedirect(true);
               return navPage;
          }
       }
    }
       
       
    public static void jobCancellation(Amr_Job_Details__c jobDetail, String jobId ){
       
        System.debug('LIST > ' + jobDetail);
        List<String> toEmailAddress = new List<String>();
        jobDetail.Job_Cancelled__c = TRUE;
        toEmailAddress.add(jobDetail.Unilever_Project_Leader_Email__c);
        toEmailAddress.add(jobDetail.Unilever_Finance_Member_Email__c);
        toEmailAddress.add(jobDetail.Final_Approver_Of_Material_Email__c);
        toEmailAddress.add(jobDetail.Agency_Contact_Account_Director_Email__c );
        toEmailAddress.add(jobDetail.Your_Email_Address__c);
        update jobDetail;
        Amr_EmailSendingClass.jobCancellationEmail(jobId,toEmailAddress );
     
    }
       
      
    public PageReference acceptJob(){
         
        Id jobId = ApexPages.CurrentPage().getParameters().get('id');
        System.debug('IDD ->'+ jobId);
        if(jobStatus == 'Accepted') {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Job already accepted')); 
            return null;
       }
       else{
           jobAlloc.Job_Status__c  = 'Accepted';
           jobStatus = 'Accepted';
           update jobAlloc;
           String userEmail = [Select email from User where id = :jobAlloc.User__c].email;
           Amr_EmailSendingClass.rapEmailSending(jobId  , userEmail );
           ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Job accepted'));             
           return null;
       }  
    }  
 
    public PageReference cancelRapJob(){
        
        Id jobId = ApexPages.CurrentPage().getParameters().get('id');
        System.debug('IDD ->'+ jobId);
         
        if(joblist.Job_Cancelled__c == TRUE){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Job already cancelled'));  
            return null;
        }
         
        else{
            jobCancellation(jobList, jobId);
            PageReference navPage = Page.Amr_JobUnCancel;
            navPage.setRedirect(true);
            return navPage;
       }
    }
  
       
    public PageReference reallocateRAP() {
        

        jobId = ApexPages.CurrentPage().getParameters().get('id'); 
        if(String.isBlank(jobID)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'JobId not found'));
            return null;
       }
       else{
           jobReAllocate(selectedRapName, jobId); 
           ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Job has been successfully allocated to the seleted RAP/RAPs'));
           return null;
      }    
        
    }
        
        
    public PageReference changePriority(){
        jobId = ApexPages.CurrentPage().getParameters().get('id'); 
        if(String.isBlank(jobID)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'JobId not found'));
            return null;
        }
        else{
            joblist.Job_Status__c = priority;
            update joblist;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Job status successfully changed')); 
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
         return listOfCategory;
     }
     
     public List<SelectOption> getProjectNameList(){      
         listOfProjectName = new List<SelectOption>();
         List<Amr_Project_Details__c> ProjectNameList= [Select id,Name from Amr_Project_Details__c order by name limit 500];
         listOfProjectName .add(new selectOption('Select','Select'));
         for(Amr_Project_Details__c cat : ProjectNameList){
             listOfProjectName.add(new selectOption(cat.Id,cat.Name));
         }
         return listOfProjectName ;
     }
     
    public List<SelectOption> getBrandPositioningList(){    
        System.debug('BBBBBBRANDDD ->'+ categoryName);  
        listOfBrandPosition = new List<SelectOption>();
        List<Amr_Brand_Positioning__c> brandPosList= [Select id,Name from Amr_Brand_Positioning__c where Category__c =: categoryName];
        listOfBrandPosition.add(new selectOption('Select','Select'));
        for(Amr_Brand_Positioning__c bps : brandPosList){
            listOfBrandPosition.add(new selectOption(bps.Id,bps.Name));
        }    
        System.debug('BBBBBBRANDDDLSIT ->'+ brandPosList);  
        return listOfBrandPosition;
         
    }
     
    public List<SelectOption> getBrandList(){      
        listOfBrand = new List<SelectOption>();
        List<Amr_Brand__c > brandList= [Select id,Name from Amr_Brand__c where Brand_Positioning__c=: brandPosName];
        listOfBrand.add(new selectOption('Select','Select'));
        for(Amr_Brand__c  bp : brandList){
            listOfBrand.add(new selectOption(bp.Id,bp.Name));
        }    
        return listOfBrand;
     }

    public Pagereference UpdateJob(){
    
        joblist.Project_Details__c = selectedProjectName;
        joblist.Category__c = categoryName ;
        joblist.Brand_Positioning__c = brandPosName ;
        joblist.Brand__c = brandNameFromPage ;
        updateAdManagerText();
       
        
        update joblist;
        
         PageReference pageRef = new PageReference('/apex/Amr_JobSheet');
         pageRef.getParameters().put('id',joblist.Id);
         pageRef.setRedirect(true);
         return pageRef;
    }
    
    public void updateAdManagerText(){
        
        
        Amr_Brand__c jobBrand = [select Name from Amr_Brand__c  where Id =: brandNameFromPage];
        system.debug('brandNameFromPage !!'+jobList.Brand__r.Name);
        String adManText = joblist.AdManagerText__c;
        String adManTextUpdatedStr = adManText.Right(6);
        String brandUpdatedNameStr =jobBrand.Name.left(3); 
        String finalAdManagerNumber = brandUpdatedNameStr + adManTextUpdatedStr ;
        system.debug('finalAdManagerNumber !!'+finalAdManagerNumber+'adManText !!'+adManText +'adManTextUpdatedStr !!'+adManTextUpdatedStr +'brandUpdatedNameStr !!'+brandUpdatedNameStr  );
        joblist.AdManagerText__c = finalAdManagerNumber;
        
    }
    

    public pagereference recordShare(){
       jobId = ApexPages.CurrentPage().getParameters().get('id');
        if(String.isBlank(jobID)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'JobId not found'));
            return null;
        }
        else{
            List<Amr_Job_Details__share> jobShrList = new List<Amr_Job_Details__share>();
            List<Amr_Job_Allocation__c> jobRAPList = new List<Amr_Job_Allocation__c>();
            Amr_Job_Details__share jobShr; 
            Amr_Job_Allocation__c jobAllocObj;
            for (String eachSelectedUser :leftselected  )
            {
                system.debug('Value'+eachSelectedUser);      
                jobShr  = new Amr_Job_Details__share ();
                jobShr.ParentId = jobId;
                jobShr.UserOrGroupId = eachSelectedUser;
                jobShr.AccessLevel = 'Read';
                jobShr.RowCause = Schema.Amr_Job_Details__share.RowCause.Manual;  
                jobShrList.add(jobShr);
                
              
               jobAllocObj = new Amr_Job_Allocation__c();
               jobAllocObj.AM_Job_Detail__c = jobId;
               jobAllocObj.Is_Primary__c = FALSE;
               jobAllocObj.User__c = eachSelectedUser;             
               jobRAPList.add(jobAllocObj);
          }
          insert jobShrList;
          insert jobRAPList;
          List<User> userList = [Select id, email from User where Id IN :leftselected ];
          List<String> emailAddress = new List<String>();
          for(User userEmail : userList){
              emailAddress.add(userEmail.email);
          }
     ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Job has been successfully Shared with seleted RAP/RAPs')); 
     Amr_EmailSendingClass.jobShared(jobId, emailAddress);
     return null;     
    }  
     
   }
}