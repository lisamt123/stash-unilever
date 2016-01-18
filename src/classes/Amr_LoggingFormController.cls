public with sharing class Amr_LoggingFormController{

    public Amr_Job_Details__c jobDetails{get;set;}
    public Amr_Logging_Form_Setting__c r  {get; set;}
    public List<Amr_CurrencyConversionRate__c> currencyConversion {get;set;}
    public String selectedCountry {get;set;}
    public String projectNameFromPage{get;set;}
   
    public List<selectOption> currencyRecords {
    get {
      List<selectOption> options = new List<selectOption>();
      options.add(new SelectOption('--None--','--None--'));
      List<Amr_CurrencyConversionRate__c> lstcov = Amr_CurrencyConversionRate__c.getAll().values();
      //lstcov.sort();
      for (Amr_CurrencyConversionRate__c cc: lstcov)
        options.add(new SelectOption(String.valueOf(cc.Currency_Unit_To_Euro__c),cc.Name+'-'+cc.Currency_Unit__c));
      return options;

    }
    set;
  }

  public String projectName{get;set;}
  public String categoryName{get;set;}
  public String brandPosName{get;set;}
  public String brandNameFromPage{get;set;} 
  public List<SelectOption> listOfCategory{get;set;} 
  public List<SelectOption> listOfBrandPosition{get;set;}
  public List<SelectOption> listOfBrand{get;set;}
  public  List<SelectOption> listOfProjectName {get;set;}
  public List<Amr_Project_Details__c> projNameList {get;set;}
  public  String[]  listString{get;set;}
    public String UserLoginId{get;set;}
    public List<PermissionSetAssignment> PermissionSetAssignmentList{get;set;}
    public boolean flag{get;set;}
    public boolean display{get;set;}
    public boolean displayRap{get;set;}
  

    public Amr_LoggingFormController(){
        jobDetails = new Amr_Job_Details__c();
        r = [SELECT Introduction__c, Header__c, Footer__c, Allocation__c, Automatic_Allocation_On__c FROM Amr_Logging_Form_Setting__c LIMIT 1];
        projNameList= [Select Name from Amr_Project_Details__c ORDER BY Name ASC limit 10000];
         listString= new list<string>();
         listString.add('--None--');
        For(Amr_Project_Details__c i : projNameList){
                listString.add(i.name);
        }
        system.debug('listString!!'+listString);
         getProjectNameList();
       
   }
   
   public void updateSetting(){
        update r;       
   }
   
 
   
   public List<SelectOption> getCategoryList(){      
         listOfCategory = new List<SelectOption>();
         List<Amr_Category__c> categoryList= [Select id,Name from Amr_Category__c];
         listOfCategory.add(new selectOption('--None--','--None--'));
         system.debug('****'+listOfCategory);
         for(Amr_Category__c cat : categoryList)
             listOfCategory.add(new selectOption(cat.Id,cat.Name));
         return listOfCategory;
     }
     
     public List<SelectOption> getProjectNameList(){      
         listOfProjectName = new List<SelectOption>();
         List<Amr_Project_Details__c> ProjectNameList= [Select id,Name from Amr_Project_Details__c limit 500];
         listOfProjectName .add(new selectOption('--None--','--None--'));
         for(Amr_Project_Details__c cat : ProjectNameList)
             listOfProjectName.add(new selectOption(cat.Id,cat.Name));
         return listOfProjectName ;
     }
     
     public String getMethodToPassProjectNames(){
        system.debug('serialize!!'+JSON.serialize(listString));
        return JSON.serialize(listString);
    }
     
       public List<SelectOption> getBrandPositioningList(){    
       System.debug('BBBBBBRANDDD ->'+ categoryName);  
    listOfBrandPosition = new List<SelectOption>();
         List<Amr_Brand_Positioning__c> brandPosList= [Select id,Name from Amr_Brand_Positioning__c where Category__c =: categoryName];
         listOfBrandPosition.add(new selectOption('--None--','--None--'));
         for(Amr_Brand_Positioning__c bps : brandPosList)
             listOfBrandPosition.add(new selectOption(bps.Id,bps.Name));
        System.debug('BBBBBBRANDDDLSIT ->'+ brandPosList);  
         return listOfBrandPosition;
         
     }
     
      public List<SelectOption> getBrandList(){      
    	 listOfBrand = new List<SelectOption>();
    	 system.debug('========>'+brandPosName);
         List<Amr_Brand__c> brandList= [Select id,Name from Amr_Brand__c where Brand_Positioning__c=: brandPosName];
         listOfBrand.add(new selectOption('--None--','--None--'));
        /* list<SelectOption> listOfBrandNew =  new List<SelectOption>();
         system.debug('=====listSize'+listOfBrandNew);
         for(Amr_Brand__c bp : brandList){
         	 if(listOfBrandNew.size()<=0){
         	       	 listOfBrandNew.add(new selectOption(bp.Id,bp.Name));
         	 }
         	for(selectOption obj:listOfBrandNew){
         			
         	       
	         		if(obj.getLabel() != bp.Name){
	         			system.debug('===>'+listOfBrand);
	             		listOfBrandNew.add(new selectOption(bp.Id,bp.Name));
	             		
	         		}
         		
         	}
         }
         system.debug('===>FinalList'+listOfBrandNew);
         listOfBrand.addAll(listOfBrandNew);*/
          for(Amr_Brand__c bps : brandList)
             listOfBrand.add(new selectOption(bps.Id,bps.Name));
        //listOfBrand.add(new selectOption('--None--','--None--'));
         return listOfBrand;
     }
   
 
 
    public Pagereference getSubmitForm(){
    
       Boolean okayToSave = true;
        
        system.debug('hii!!'+categoryName+'!!'+brandPosName+'!!'+brandNameFromPage);
         system.debug('job detail checkboxes=======>'+jobDetails.Project_Details__c  );
          system.debug('projectNameFromPage=======>'+projectNameFromPage);
       //----   
        system.debug('jobDetails.Check_With_CMI__c!!'+jobDetails.Check_With_CMI__c);
        if(jobDetails.Check_With_CMI__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Have you checked with CMI if there is an existing asset in the Millward Brown TV Ad Vitality Bank that could be utilised for this JTBD? : a radio button must be selected'));
        okayToSave =false;
        
        }
        
         if(jobDetails.Your_Email_Address__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Your email address : must follow the standard format of an email address, e.g. txt@txt.com'));
       okayToSave =false;
        } 
        if(jobDetails.Unilever_Finance_Member_Email__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unilever finance member email : must follow the standard format of an email address, e.g. txt@txt.com'));
        okayToSave =false;
        }
        if(jobDetails.Final_Approver_Of_Material_Email__c== null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Final approver of material email : must follow the standard format of an email address, e.g. txt@txt.com'));
       okayToSave =false;
        }
        if((String.isBlank(selectedCountry)|| selectedCountry == '--None--')){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Budget allocated for this activity(enter all digits): option must be selected from drop down'));
       okayToSave =false;
        }
        
        if(jobDetails.Budget_Allocated_Input_Value__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Budget allocated for this activity(enter all digits) : number must be entered'));
       okayToSave =false;
        }
        
         if(categoryName == '--None--'){
         system.debug('inside category'+categoryName);
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Category > Brand Positioning > Brand : option must be selected from all drop downs - Category, Brand Position & Brand Name'));
        okayToSave =false;
        }
         if(brandPosName == '--None--'){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Category > Brand Positioning > Brand : option must be selected from all drop downs - Category, Brand Position & Brand Name'));
        okayToSave =false;
        }
         if(brandNameFromPage == '--None--'){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Category > Brand Positioning > Brand : option must be selected from all drop downs - Category, Brand Position & Brand Name'));
        okayToSave =false;
        }
        
        if(jobDetails.Agency_Contact_Account_Director_Email__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Agency contact or account director email : must follow the standard format of an email address, e.g. txt@txt.com'));
       okayToSave =false;
        }
        if(jobDetails.Project_Description__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Project description : text must be entered'));
       okayToSave =false;
        }
        if(jobDetails.Campaign_Name__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Campaign name : text must be entered'));
       okayToSave =false;
        }
        if(jobDetails.Target_Air_Date__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Target air date : a date must be selected from the calendar'));
       okayToSave =false;
        }
     //----     
       
       
        if(jobDetails.Project_Leader_Cluster__c == null || jobDetails.Project_Leader_Country__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Location of Unilever project leader : option must be selected from both market cluster and country drop downs'));
        okayToSave =false;
        }
        
        if(jobDetails.Function_You_Are_Part__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Which function are you part of (BD/BB/Other) : option must be selected from drop down'));
       okayToSave =false;
        }
        
        if(jobDetails.Budget_Responsibility__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Budget responsibility (BD, BB, Other) : option must be selected from drop down'));
        okayToSave =false;
        }
        if(jobDetails.Lead_Creative_Agency_name__c == null && jobDetails.Lead_Agency_Name_Other__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Lead agency name : option must be selected from the drop down menu OR a name must be entered in the "Other" text box'));
       okayToSave =false;
        }
        if(jobDetails.Lead_Agency_Location_Cluster__c == null || jobDetails.Lead_Agency_Location_Country__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Lead agency location : option must be selected from both market cluster and country drop downs'));
       okayToSave =false;
        }
       if(jobDetails.Project_Details__c == NULL  && jobDetails.Project_Name_Other__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Project name (e.g. Apollo) : option must be selected from the drop down menu OR a name must be entered in the "Other" text box'));
      okayToSave =false;
        }
        if(jobDetails.Project_Location_Cluster__c == null || jobDetails.Project_Location_Country__c==null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Project location : option must be selected from both market cluster and country drop downs'));
       okayToSave =false;
        }
        if(jobDetails.Production_Activity_Type__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'What type of activity will this production support? : one option must be selected from the drop down menu'));
       okayToSave =false;
        }
           // system.debug('jobDetails.Project_Description__c!!'+jobDetails.Project_Description__c+'jobDetails.Execution_Name__c!!'+jobDetails.Execution_Name__c);  
        
        if(String.isBlank(jobDetails.Project_Description__c)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Project description : text must be entered'));
       okayToSave =false;
        }
        
        if(String.isBlank(jobDetails.Execution_Name__c)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Execution name  : text must be entered'));
      okayToSave =false;
        }
         if(String.isBlank(jobDetails.Brodcast_Market__c)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Broadcast market  : text must be entered'));
      okayToSave =false;
        }
        
        
        if(jobDetails.Require_Music__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Do you anticipate that your production will require Music? : a radio button must be selected'));
       okayToSave =false;
        }
        
        if(jobDetails.Require_Celebrity_Talent__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Do you anticipate that your production will require Celebrity Talent? : a radio button must be selected'));
       okayToSave =false;
        }
        if(jobDetails.Stage_of_Production_Activity__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Current stage of your production activity : option must be selected from drop down'));
       okayToSave =false;
        }
        
        if(jobDetails.Tv__c == false && jobDetails.Cinema__c == false && jobDetails.Radio__c==false && jobDetails.Print__c==false && jobDetails.Out_Of_Home__c==false && jobDetails.In_Store__c==false && jobDetails.Digital__c==false &&jobDetails.Internal_Video__c==false ){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Production activity types : at least one option must be selected'));
       okayToSave =false;
        }
        
        if(jobDetails.Out_Of_Home__c == true){
       	 if(jobDetails.Out_Of_Home_Moving_Image__c == false && jobDetails.Out_Of_Home_Audio__c==false && jobDetails.Out_Of_Home_Still_Image__c==false){
        		system.debug('inside!!!');
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Production activity types : select at least one media for selected media channel'));
        	 okayToSave =false;
        	}
        }
        if(jobDetails.In_Store__c==true){
        if(jobDetails.In_Store_Moving_Image__c == false && jobDetails.In_Store_Audio__c==false && jobDetails.In_Store_Still_Image__c==false){
        	system.debug('inside!!!');
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Production activity types : select at least one media for selected media channel'));
        	 okayToSave =false;
        	}
        }
          if(jobDetails.Digital__c==true){
       	 if(jobDetails.Digital_Moving_Image__c == false && jobDetails.Digital_Audio__c == false && jobDetails.Digital_Still_Image__c==false && jobDetails.Digital_Editorial__c == false){
        		system.debug('inside!!!');
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Production activity types : select at least one media for selected media channel'));
        	 okayToSave =false;
        	}
        }
        
        if( !okayToSave ) {
        return null;
        }
        
         system.debug('job detail checkboxes=======>'+jobDetails.Project_Details__c  );
          system.debug('jprojectName=======>'+projectName  );
        
       /*if(projectName != null && projectName != '' && projectName != 'Select')
            jobDetails.Project_Details__c= projectName;*/
            
            
      
        Amr_CurrencyConversionRate__c currencyObject =[SELECT Currency_Unit__c,Name FROM Amr_CurrencyConversionRate__c WHERE Currency_Unit_To_Euro__c =:double.valueOf(selectedCountry) limit 1];
         
         String currencyFinalString = currencyObject.Name+'-'+currencyObject.Currency_Unit__c;
         system.debug('selectedCountry !!!'+selectedCountry +'currencyObject !!!'+currencyObject +'currencyFinalString !!'+currencyFinalString );
            
        jobDetails.Category__c = categoryName;
        jobDetails.Brand_Positioning__c = brandPosName;
        jobDetails.Brand__c = brandNameFromPage;
        jobDetails.Currency_Conversion_Country_List__c = currencyFinalString;
        system.debug('job detail checkboxes=======>'+jobDetails);
        system.debug('values!@@!!'+jobDetails.Category__c+'!!'+jobDetails.Brand_Positioning__c+'!!'+jobDetails.Brand__c);
        adManagerNumberCreation();
        
        jobDetails.Is_Submitt__c = true;

         
         compareThresold(jobDetails, categoryName,brandPosName,brandNameFromPage);
         userNotificationSendEmail();
         agencyNotificationSendEmail();
         capEmailNotification();
         jobDetails.GBVM_Email__c = gbvmEmail;
         jobDetails.Threshold_Amount__c = thresholdValue ;
         
         System.debug('HELLO ->' + jobDetails.GBVM_Email__c);   
         insert jobDetails;
        
          getCategoryList();
         InnerJobDetail innerClassObj = new InnerJobDetail(jobDetails.Project_Leader_Cluster__c,jobDetails.Project_Leader_Country__c,jobDetails.id,jobDetails.AdManagerText__c);
        
         String obj = JSON.serialize(innerClassObj);
         automaticJobAllocation(obj);
         
         jobDetails = new Amr_Job_Details__c();
         selectedCountry ='--None--';
         categoryName ='--None--';
         brandPosName ='--None--';
         brandNameFromPage ='--None--';
         
         PageReference pageRef = new PageReference('/apex/Amr_AdManager');
           
         ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Thank you for submitting the job successfully, shortly you will receive the email confirmation'));
         listOfBrand = new List<SelectOption>();
         pageRef.setRedirect(false);
         return pageRef;
    
        return null;
    }
    
    
    public static void insertJobAllocationData(String jobId, String userId){
    
        Amr_Job_Allocation__c jobAlloc = new Amr_Job_Allocation__c();
        jobAlloc.AM_Job_Detail__c = jobId;
        jobAlloc.Is_Primary__c = TRUE ; 
        jobAlloc.User__c = userId;
        jobAlloc.Job_Allocated__c = 'Yes';
        insert jobAlloc;
        
        
        Amr_Job_Details__c jobDetails = new Amr_Job_Details__c(Id= jobId , ownerId = userId);
        update jobDetails; 
    
    }
    
    
     @future
     static void automaticJobAllocation(String JobObject){
      InnerJobDetail jobDetailsNew = (InnerJobDetail)JSON.deserialize(JobObject, InnerJobDetail.class);
      system.debug(jobDetailsNew.Cluster+'----'+jobDetailsNew.Country+'-----'+jobDetailsNew.JobId);
     //Autometic assigment
             if(jobDetailsNew.Cluster!=null && jobDetailsNew.Country!=null){
             
                 system.debug(jobDetailsNew.Cluster+'======>'+jobDetailsNew.Country);
                
                 List<Amr_Country_Cluster__c> countryClusterLst = Amr_Country_Cluster__c.getAll().values(); 
                 List<String> emailIds = new List<String>();
                 
                 system.debug(jobDetailsNew.Cluster +'======country===='+jobDetailsNew.Country);
                 for(Amr_Country_Cluster__c obj:countryClusterLst){
                    if(obj.Cluster__c == jobDetailsNew.Cluster && obj.Country__c ==  jobDetailsNew.Country){
                        system.debug('inside===>'+obj.Primary_RAP_Email__c);
                        emailIds.add(obj.Primary_RAP_Email__c); 
                        
                    }
                 }
                 system.debug('EEEMMMAAAAIIILLL  -> ' + emailIds);
                 List<PermissionSetAssignment> userList =  [SELECT Id,Assignee.Name,Assignee.id,Assignee.Email FROM PermissionSetAssignment where PermissionSet.Name ='RAP' AND Assignee.Email = :emailIds ];
               //  List<User> userList = [select id,name,ProfileId from User where Email in :emailIds AND PermissionId  = :profile.id];
                 system.debug('===========>'+userList[0].Assignee.Email +'==jobId'+jobDetailsNew.JobId);
                  system.debug('===========>'+userList[0].Assignee.id +'==jobId'+jobDetailsNew.JobId);
                 if(userList.size()>0){
                 
                // Amr_Job_Details__c objamrjobdetails = new Amr_Job_Details__c(Id=jobDetailsNew.JobId, ownerId = userList[0].Assignee.id );
                 //update objamrjobdetails ;
                 Amr_Job_Details__Share jobShareObj  = new Amr_Job_Details__Share();
                 jobShareObj.ParentId = jobDetailsNew.JobId;
                 jobShareObj.UserOrGroupId = userList[0].Assignee.id;               
               jobShareObj.AccessLevel = 'Edit';
                     insert jobShareObj;
                 
                 insertJobAllocationData(jobDetailsNew.JobId,userList[0].Assignee.id);
                 /*if(jobShareObj.id !=null){
                        system.debug('inside job share---');
                        sendNotificationToRap(jobDetailsNew.AdManagerText,jobDetailsNew.JobId,emailIds[0]);
                 }*/
                  }
             }
    }
    
   /*public static  void sendNotificationToRap(String adMangerNumber,String Job,String emailIdValue){
          
          system.debug(adMangerNumber+'---'+Job+'---'+emailIdValue);
          
          Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
          String subject = 'New Job '+'"'+adMangerNumber+'"' +'is allocated to you';
          String[] toAddresses = new String[] {};
          toAddresses.add(emailIdValue);
          //toAddresses.add('anjali.nigam@mindtree.com');  
          email.setSubject( subject );
       
          email.setToAddresses( toAddresses );
          String body ='New Job is created with AD Manager Number'+adMangerNumber+'is allocated to you</br></br></br>';
          body+='In order to access Job go to following link given</br></br></br>';
          body+='</br></br>Job Detail Page :<br/>'+'https://unilever--chazwa--c.cs14.visual.force.com/apex/AM_JobAllocations?id='+Job+'<br/><br/>';
          body+='<br/><br/>Please contact Advertising.Production@unilever.com if you require any further assistance or visit http://adproduction.unilever.com/ for supporting documentation.';
          email.setHtmlBody(body);
          Messaging.SendEmailResult [] r =
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});  
    
    }*/
    
  public class InnerJobDetail{
        public String Cluster{get;set;}
        public String Country{get;set;}
        public String JobId{get;set;}
         public String AdManagerText{get;set;}
        public InnerJobDetail(String Clust,String Count,String Id,String AdManagertxt){
           
            Cluster = Clust;
            Country = Count;
            JobId = Id;
            AdManagerText = AdManagertxt;
        }
        
    
    }
    
    
//public String Brand{get;set;}
//public String Categorty{get;set;}
//public String BrandPostion{get;set;}
public double amountEntered{get;set;}
public String ToUserEmailId{get;set;}
public String gbvmEmail  {get;set;}
public Double thresholdValue  {get;set;}

// For Thresold Reach
public void compareThresold(Amr_Job_Details__c jobDetailObj, String Categorty ,String BrandPostion , String Brand ){
    
  //  Amr_Job_Details__c jobDetailObj = [select Allocated_Budget_euro__c,Category__r.name,Brand_Positioning__r.name,Brand__r.name from Amr_Job_Details__c where id =:jobDetailId];
 //   Brand = jobDetailObj.Brand__r.name;
  //  Categorty = jobDetailObj.Category__r.name;
  //  BrandPostion = jobDetailObj.Brand_Positioning__r.name;
    amountEntered = jobDetailObj.Allocated_Budget_euro__c;
    system.debug(Brand +'==='+Categorty+'===='+BrandPostion+'===='+amountEntered);
    List<Amr_JobBudgetThreshold__c> jobBudgetThresoldList = [select id,Am_Brand_Positioning__r.name,Am_Brand__r.name, Am_Brand__r.Id, Am_Category__r.Id,Am_Brand_Positioning__r.Id,
                                                                      BrandCategoryPosition__c,Budget_Limit__c,Am_Category__r.name,
                                                                      UserEmailId__c from Amr_JobBudgetThreshold__c];
    String brandCategoryPosition = BrandPostion+Brand+Categorty;
    system.debug('=======>'+brandCategoryPosition);                                                      
    
    for(Amr_JobBudgetThreshold__c jobBudgetThresoldObj:jobBudgetThresoldList){
         system.debug('=======>'+jobBudgetThresoldObj.BrandCategoryPosition__c);  
         String thresholdCompareId = jobBudgetThresoldObj.Am_Brand_Positioning__r.Id +''+ jobBudgetThresoldObj.Am_Brand__r.Id + jobBudgetThresoldObj.Am_Category__r.Id ;
        System.debug('Thre ->' + thresholdCompareId);
         if(thresholdCompareId == brandCategoryPosition){ 
            
              System.debug('Threshold -> ' + jobBudgetThresoldObj.Budget_Limit__c + 'Entered Ampunt -> ' + amountEntered);
          
            if(jobBudgetThresoldObj.Budget_Limit__c < amountEntered){
                
                ToUserEmailId = jobBudgetThresoldObj.UserEmailId__c;
                system.debug('to email Addresss====>'+ToUserEmailId);
                ToUserEmailId = String.valueOf(ToUserEmailId);
                gbvmEmail  = ToUserEmailId;
                thresholdValue  = jobBudgetThresoldObj.Budget_Limit__c;
                
                System.debug('HELLO ->' + jobDetails.GBVM_Email__c);
            //    sendEmailOnThresoldReached(ToUserEmailId);
            }
         }
    }
    
  }

 public void sendEmailOnThresoldReached(String toEmailId){
    
    /*    Contact con = new Contact();
        con.LastName = 'CAP';
        con.email = 'advertising.production@testunilever.com';
        insert con;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Id eTemp = [select id from EmailTemplate where developername = 'Amr_ThresholdNotification'].Id;
        
        String whatid;
        
       
        mail.setTargetObjectId(con.id);
        mail.setTemplateId(eTemp);
        mail.setSaveAsActivity(false);
        mail.setWhatId(jobDetails.id);
        mail.setTreatTargetObjectAsRecipient(false);
        //mail.setTreatTargetObjectAsRecipient = false;
       

             
        system.debug('job toAddresses!!'+toAddresses);
        mail.setToAddresses( toAddresses );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        System.debug('Mail Sent'+mail); 
        delete con;
        System.debug('Id ->' + eTemp); */
         String[] toAddresses = new String[] {};
        toAddresses.add(toEmailId);  
        
        if(jobDetails.Unilever_Project_Leader_Email__c !=null){  
        toAddresses.add(jobDetails.Unilever_Project_Leader_Email__c);
        }
        Amr_EmailSendingClass.emailSending(jobDetails.id,toAddresses, Label.Amr_Email_ThresholdNotification ,new List<Id>());
  }
  
  //---------------------------- anjali End Section------------------------------------
  
    public void capEmailNotification(){
        Contact con = new Contact();
        con.LastName = 'CAP';
        con.email = 'advertising.production@unilevertest.com';
        insert con;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Id eTemp = [select id from EmailTemplate where developername = 'Amr_CAPNotification'].Id;
        
        String whatid;
     
       
        mail.setTargetObjectId(con.id);
        mail.setTemplateId(eTemp);
        mail.setSaveAsActivity(false);
        mail.setWhatId(jobDetails.id);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        System.debug('Mail Sent'+mail); 
        delete con;
        System.debug('Id ->' + eTemp);
  }
  
  
public List<SelectOption> getProductionActivityValues()
{
  List<SelectOption> options = new List<SelectOption>();
        
  Schema.DescribeFieldResult fieldResult = Amr_Job_Details__c.Production_Activity__c.getDescribe();
 List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
 system.debug('values!!'+ple);
        
   for( Schema.PicklistEntry f : ple)
   {
      options.add(new SelectOption(f.getLabel(), f.getValue()));
   }       
   return options;
}

      public String[] ActivityItems { 
     get {
        String[] selected = new List<String>();
        List<SelectOption> sos = getProductionActivityValues();
        for(SelectOption s : sos) {
        if (jobDetails.Production_Activity__c !=null && jobDetails.Production_Activity__c.contains(s.getValue()))
           selected.add(s.getValue());
        }
        return selected;
     }public set {
        String selectedCheckBox = '';
        for(String s : value) {
         if (selectedCheckBox == '') 
           selectedCheckBox += s;
         else selectedCheckBox += ';' + s;
        }
        jobDetails.Production_Activity__c = selectedCheckBox;
     }
}

    public void adManagerNumberCreation(){
    
    Amr_Job_Details__c[] jobDetailList=[select Id,AdManagerText__c from Amr_Job_Details__c order by CreatedDate desc limit 1];
    
    system.debug('job details!!'+jobDetailList);
    Id id = jobDetails.Brand__c ;
    system.debug('id!!'+id+'lookup!!!'+jobDetails.Brand__c);
    Amr_Brand__c jobBrand = [select Name from Amr_Brand__c  where Id =: id];
   
    String brandStr = jobBrand.Name;
    String brandName = brandStr.Left(3);
    
    if(jobDetailList.size()>0){
    
    String textStr = jobDetailList[0].AdManagerText__c;
    String adNumber = textStr.Right(5);
    
        if(adNumber =='99999'){
        jobDetails.AdManagerText__c = brandName+'/'+'00001';
        }else{
        Integer num = integer.valueOf(adNumber)+1;
        String numStr =string.valueof(num);
      Integer i;
       for(i=0;numStr.length()<5;i++){
           numstr='0'+numStr;
          system.debug('num string!!'+numStr); 
       }
        
        jobDetails.AdManagerText__c =brandName+'/'+numstr;}
    }else{
    jobDetails.AdManagerText__c =brandName+'/'+'00001';
    }
     system.debug('job details!!'+jobDetails);
     
    
    }
    
    public void userNotificationSendEmail(){
    
   /*     Contact con = new Contact();
        con.LastName = 'CAP';
        con.email = 'test@unilever.com';
        insert con;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Id eTemp = [select id from EmailTemplate where developername = 'Amr_UserNotification'].Id;  */
        
        String whatid;
        
        List<String> attachment= new List<String>();
        attachment.add(Label.Amr_Attachment_Talent_Executive);
        attachment.add(Label.Amr_Attachment_Animatics_Executive);
        attachment.add(Label.Amr_Attachment_Music_Executive);
        attachment.add(Label.Amr_Attachment_Executive_Summary);
        
        List<Document> doc = [select id, name, body, contenttype, developername, type from Document where name IN :attachment];
        
        List<Id> attachId = new List<Id>();
        
        for(Document docObj : doc){
            if(docObj.name == Label.Amr_Attachment_Executive_Summary){
                system.debug('inside General Executive Summary');
               attachId.add(docObj.id);
            }
        }
        
        if(jobDetails.New_Original_Master__c == true &&(jobDetails.Tv__c == true || jobDetails.Cinema__c == true)){
            for(Document docObj : doc){
                if(docObj.name == Label.Amr_Attachment_Animatics_Executive){
                    system.debug('inside Animatics Executive Summary');
                    attachId.add(docObj.id);
                }
            }
        
        }
        
        if(jobDetails.Require_Music__c == 'Yes' ){
            for(Document docObj : doc){
                if(docObj.name == Label.Amr_Attachment_Music_Executive){
                    system.debug('inside Music Executive Summary');
                    attachId.add(docObj.id);
                }
            }
        }
        
        if(jobDetails.Require_Celebrity_Talent__c == 'No' ){
            for(Document docObj : doc){
                if(docObj.name == Label.Amr_Attachment_Talent_Executive){
                    system.debug('inside Talent Executive Summary');
                    attachId.add(docObj.id);
                }
            }
        }
        
        String[] toAddresses = new String[] {};
        toAddresses.add(jobDetails.Agency_Contact_Account_Director_Email__c);   
        
        Amr_EmailSendingClass.emailSending(jobDetails.id,toAddresses, Label.Amr_Email_UserNotification ,attachId);
        
    /*    system.debug('=========>'+attachId);
        mail.setDocumentAttachments(attachId);
        mail.setTargetObjectId(con.id);
        mail.setTemplateId(eTemp);
        mail.setSaveAsActivity(false);
        mail.setWhatId(jobDetails.id);
        mail.setTreatTargetObjectAsRecipient(false);
        
        if(jobDetails.Unilever_Project_Leader_Email__c !=null){  
        toAddresses.add(jobDetails.Unilever_Project_Leader_Email__c);
        }
        toAddresses.add(jobDetails.Unilever_Finance_Member_Email__c);
        toAddresses.add(jobDetails.Final_Approver_Of_Material_Email__c); 
        system.debug('job toAddresses!!'+toAddresses);
        mail.setToAddresses( toAddresses );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        System.debug('Mail Sent'+mail); 
        delete con;
        System.debug('Id ->' + eTemp);
        
     */   
        
    
    }
    
    public void agencyNotificationSendEmail(){
    /*    Contact con = new Contact();
        con.LastName = 'CAP';
        con.email = 'advertising.production@testunilever.com';
        insert con;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Id eTemp = [select id from EmailTemplate where developername = 'Amr_AgencyNotification'].Id;
        
        String whatid;
    */    
        List<String> attachment= new List<String>();
        attachment.add(Label.Amr_Attachment_Talent_Executive);
        attachment.add(Label.Amr_Attachment_Animatics_Executive);
        attachment.add(Label.Amr_Attachment_Music_Executive);
        attachment.add(Label.Amr_Attachment_Executive_Summary);
        
        List<Document> doc = [select id, name, body, contenttype, developername, type from Document where name IN :attachment];
        
        List<Id> attachId = new List<Id>();
        
        for(Document docObj : doc){
            if(docObj.name == Label.Amr_Attachment_Executive_Summary){
                system.debug('inside General Executive Summary');
               attachId.add(docObj.id);
            }
        }
        
        if(jobDetails.New_Original_Master__c == true &&(jobDetails.Tv__c == true || jobDetails.Cinema__c == true)){
            for(Document docObj : doc){
                if(docObj.name == Label.Amr_Attachment_Animatics_Executive){
                    system.debug('inside Animatics Executive Summary');
                    attachId.add(docObj.id);
                }
            }
        
        }
        system.debug('talent----------'+jobDetails.Require_Music__c);
        if(jobDetails.Require_Music__c == 'Yes' ){
            for(Document docObj : doc){
                if(docObj.name == Label.Amr_Attachment_Music_Executive){
                    system.debug('inside Music Executive Summary');
                    attachId.add(docObj.id);
                }
            }
        }
        system.debug('talent----------'+jobDetails.Require_Celebrity_Talent__c);
        if(jobDetails.Require_Celebrity_Talent__c == 'Yes' ){
            for(Document docObj : doc){
                if(docObj.name == Label.Amr_Attachment_Talent_Executive){
                    system.debug('inside Talent Executive Summary');
                    attachId.add(docObj.id);
                }
            }
        }
        
        String[] toAddresses = new String[] {};
        toAddresses.add(jobDetails.Agency_Contact_Account_Director_Email__c);   
        
        Amr_EmailSendingClass.emailSending(jobDetails.id,toAddresses, Label.Amr_Email_AgencyNotification,attachId);
    /*    system.debug('=========>'+attachId);
        mail.setDocumentAttachments(attachId);
        mail.setTargetObjectId(con.id);
        mail.setTemplateId(eTemp);
        mail.setSaveAsActivity(false);
        mail.setWhatId(jobDetails.id);
        mail.setTreatTargetObjectAsRecipient(false);
        
        system.debug('job toAddresses!!'+toAddresses);
        mail.setToAddresses( toAddresses );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        System.debug('Mail Sent'+mail); 
        delete con;
        System.debug('Id ->' + eTemp);
       */ 
    
    }
    
    public PageReference Redirect(){
         String sessionIdVal = userinfo.getSessionId();
         UserLoginId = userinfo.getuserid();  
         User userObj = [select id,SessionId__c from User where id = :UserLoginId];
       // PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name = :Label.Amr_CAP order by Assignee.name];
        PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id,PermissionSet.Name from PermissionSetAssignment where (PermissionSet.Name = :Label.Amr_CAP OR PermissionSet.Name = 'RAP' OR PermissionSet.Name = 'AdManager') order by Assignee.name];
        system.debug('------>PermissionSetAssignmentList=='+PermissionSetAssignmentList );
        PageReference pageRef ;
        flag = false;
        display = false;
        displayRap = false;
       system.debug(userObj.SessionId__c +'======'+sessionIdVal);
        for(PermissionSetAssignment permissionObject:PermissionSetAssignmentList ){
               system.debug('=======>'+permissionObject.PermissionSet.Name);
               if(permissionObject.PermissionSet.Name == Label.Amr_CAP && permissionObject.Assignee.id == UserLoginId && (userObj.SessionId__c == null || userObj.SessionId__c != sessionIdVal)){
                   system.debug('inside cap==>');
                   pageRef = new PageReference('/apex/Am_CAPJobportfolio');
                   pageRef.setRedirect(true);
                   userObj.SessionId__c = sessionIdVal;
                  // update userObj;
                   
                  
                   
               } 
               if(permissionObject.PermissionSet.Name == 'RAP' && permissionObject.Assignee.id == UserLoginId && (userObj.SessionId__c == null || userObj.SessionId__c != sessionIdVal)){
                  system.debug('inside RAP==>');
                    pageRef = new PageReference('/apex/Am_JobPortfolio');
                    pageRef.setRedirect(true);
                    userObj.SessionId__c = sessionIdVal;
                    
                   
                  
                   
               }
               
               /*if(permissionObject.PermissionSet.Name == 'AdManager' && permissionObject.Assignee.id == UserLoginId  && userObj.SessionId__c == null){
                   system.debug('inside AdManager==>');
                   PageReference pageRef = new PageReference('/apex/Amr_AdManager');
                   pageRef.setRedirect(true);
                   return null;
                       
               }*/
            
        }
        update userObj;
        if(pageRef != null){
            return pageRef;
        }
        PageReference pageRef1 = new PageReference('/apex/Amr_AdManager');
        pageRef1.setRedirect(true);
        return null;
    }

}