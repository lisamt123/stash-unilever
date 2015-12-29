public class Amr_LoggingFormController{

    public Amr_Job_Details__c jobDetails{get;set;}
    public Amr_Logging_Form_Setting__c r  {get; set;}
    public List<Amr_CurrencyConversionRate__c> currencyConversion {get;set;}
    public String selectedCountry {get;set;}
    public List<selectOption> currencyRecords {
    get {
      List<selectOption> options = new List<selectOption>();
      
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
  public  List<SelectOption> listOfBrand{get;set;}
  public  List<SelectOption> listOfProjectName {get;set;}
  

    public Amr_LoggingFormController(){
        jobDetails = new Amr_Job_Details__c();
        r = [SELECT Introduction__c, Header__c, Footer__c FROM Amr_Logging_Form_Setting__c LIMIT 1];
       
         getProjectNameList();
           
   }
   
   public List<SelectOption> getCategoryList(){      
         listOfCategory = new List<SelectOption>();
         List<Amr_Category__c> categoryList= [Select id,Name from Amr_Category__c];
         listOfCategory.add(new selectOption('Select','Select'));
         for(Amr_Category__c cat : categoryList)
             listOfCategory.add(new selectOption(cat.Id,cat.Name));
         return listOfCategory;
     }
     
     public List<SelectOption> getProjectNameList(){      
         listOfProjectName = new List<SelectOption>();
         List<Amr_Project_Details__c> ProjectNameList= [Select id,Name from Amr_Project_Details__c limit 500];
         listOfProjectName .add(new selectOption('Select','Select'));
         for(Amr_Project_Details__c cat : ProjectNameList)
             listOfProjectName.add(new selectOption(cat.Id,cat.Name));
         return listOfProjectName ;
     }
     
       public List<SelectOption> getBrandPositioningList(){    
       System.debug('BBBBBBRANDDD ->'+ categoryName);  
    listOfBrandPosition = new List<SelectOption>();
         List<Amr_Brand_Positioning__c> brandPosList= [Select id,Name from Amr_Brand_Positioning__c where Category__c =: categoryName];
         listOfBrandPosition.add(new selectOption('Select','Select'));
         for(Amr_Brand_Positioning__c bps : brandPosList)
             listOfBrandPosition.add(new selectOption(bps.Id,bps.Name));
        System.debug('BBBBBBRANDDDLSIT ->'+ brandPosList);  
         return listOfBrandPosition;
         
     }
     
      public List<SelectOption> getBrandList(){      
    listOfBrand = new List<SelectOption>();
         List<Amr_Brand__c> brandList= [Select id,Name from Amr_Brand__c where Brand_Positioning__c=: brandPosName];
         listOfBrand.add(new selectOption('Select','Select'));
         for(Amr_Brand__c bp : brandList)
             listOfBrand.add(new selectOption(bp.Id,bp.Name));
         return listOfBrand;
     }
   
 
 
    public Pagereference SubmitForm(){
        
        system.debug('hii!!'+categoryName+'!!'+brandPosName+'!!'+brandNameFromPage);
         system.debug('job detail checkboxes=======>'+jobDetails.Project_Details__c  );
          system.debug('jprojectName=======>'+projectName  );
        if(categoryName == 'Select'){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter category'));
        return null;
        }else if(brandPosName == 'Select'){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Brand Position'));
        return null;
        }else if(brandNameFromPage == 'Select'){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Brand Name'));
        return null;
        }
        system.debug('jobDetails.Check_With_CMI__c!!'+jobDetails.Check_With_CMI__c);
        if(jobDetails.Check_With_CMI__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select CMI from Before you Start Section'));
        return null;
        }
        if(jobDetails.Project_Leader_Cluster__c == null || jobDetails.Project_Leader_Country__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Project Leader Location'));
        return null;
        }
        
        if(jobDetails.Function_You_Are_Part__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Function you are part'));
        return null;
        }
        
        if(jobDetails.Budget_Responsibility__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Budget Responsibility'));
        return null;
        }
        if(jobDetails.Lead_Creative_Agency_name__c == null && jobDetails.Lead_Agency_Name_Other__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Lead creative Agency Name'));
        return null;
        }
        if(jobDetails.Lead_Agency_Location_Cluster__c == null || jobDetails.Lead_Agency_Location_Country__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Lead Location'));
        return null;
        }
      if( (projectName == NULL || projectName == 'Select') && jobDetails.Project_Name_Other__c == null ){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Project Name'));
        return null;
        }
        if(jobDetails.Project_Location_Cluster__c == null || jobDetails.Project_Location_Country__c==null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Project Location'));
        return null;
        }
        if(jobDetails.Production_Activity_Type__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter activity for production support'));
        return null;
        }
           // system.debug('jobDetails.Project_Description__c!!'+jobDetails.Project_Description__c+'jobDetails.Execution_Name__c!!'+jobDetails.Execution_Name__c);  
        
        if(String.isBlank(jobDetails.Project_Description__c)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Project Description'));
        return null;
        }
        
        if(String.isBlank(jobDetails.Execution_Name__c)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Execution Name'));
        return null;
        }
        
        if(jobDetails.Require_Music__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Require Music'));
        return null;
        }
        
        if(jobDetails.Require_Celebrity_Talent__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Celebrity Talent'));
        return null;
        }
        if(jobDetails.Stage_of_Production_Activity__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter stage of production activity'));
        return null;
        }
        
        if(jobDetails.New_Original_Master__c == false && jobDetails.Language_Adaptation_Of_Master__c == false && jobDetails.Create_Additional_Material__c==false && jobDetails.Rework_Exisiting_Material__c==false && jobDetails.Buyouts_Talent__c==false && jobDetails.Buyouts_Music__c==false){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Production activity Type'));
        return null;
        }
        
         system.debug('job detail checkboxes=======>'+jobDetails.Project_Details__c  );
          system.debug('jprojectName=======>'+projectName  );
        
        if(projectName != null && projectName != '' && projectName != 'Select')
            jobDetails.Project_Details__c= projectName;
            
            
      
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
        system.debug('jobDetails=id=======>'+jobDetails.id);
        insert jobDetails;

         system.debug('jobDetails=id=======>'+jobDetails.id);
        
         
         compareThresold(jobDetails.id);
         userNotificationSendEmail();
         agencyNotificationSendEmail();
         capEmailNotification();
         InnerJobDetail innerClassObj = new InnerJobDetail(jobDetails.Project_Leader_Cluster__c,jobDetails.Project_Leader_Country__c,jobDetails.id,jobDetails.AdManagerText__c);
        
         String obj = JSON.serialize(innerClassObj);
         automaticJobAllocation(obj);
         
         jobDetails = new Amr_Job_Details__c();
         
         PageReference pageRef = new PageReference('/apex/Amr_AdManager');
         ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Thank you for submitting the job successfully, Shortly you will receive the email confirmation'));
         
         pageRef.setRedirect(false);
         return pageRef;
    
        return null;
    }
    
    
    public static void insertJobAllocationData(String jobId, String userId){
    
        Amr_Job_Allocation__c jobAlloc = new Amr_Job_Allocation__c();
        jobAlloc.AM_Job_Detail__c = jobId;
        jobAlloc.Is_Primary__c = TRUE ; 
        jobAlloc.User__c = userId;
        insert jobAlloc;
    
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
                 Profile profile =  [SELECT Id FROM Profile where name = 'RAP'];
                 List<User> userList = [select id,name,ProfileId from User where Email in :emailIds AND ProfileId  = :profile.id];
                 system.debug('===========>'+userList+'==jobId'+jobDetailsNew.JobId);
                 if(userList.size()>0){
                 Amr_Job_Details__Share jobShareObj  = new Amr_Job_Details__Share();
                 jobShareObj.ParentId = jobDetailsNew.JobId;
                 jobShareObj.UserOrGroupId = userList[0].id;               
               jobShareObj.AccessLevel = 'Edit';
                 insert jobShareObj;
                 
                 insertJobAllocationData(jobDetailsNew.JobId,userList[0].id);
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
    
    
public String Brand{get;set;}
public String Categorty{get;set;}
public String BrandPostion{get;set;}
public double amountEntered{get;set;}
public String ToUserEmailId{get;set;}

// For Thresold Reach
public void compareThresold(String jobDetailId){
    
    Amr_Job_Details__c jobDetailObj = [select Allocated_Budget_euro__c,Category__r.name,Brand_Positioning__r.name,Brand__r.name from Amr_Job_Details__c where id =:jobDetailId];
    Brand = jobDetailObj.Brand__r.name;
    Categorty = jobDetailObj.Category__r.name;
    BrandPostion = jobDetailObj.Brand_Positioning__r.name;
    amountEntered = jobDetailObj.Allocated_Budget_euro__c;
    system.debug(Brand +'==='+Categorty+'===='+BrandPostion+'===='+amountEntered);
    List<Amr_JobBudgetThreshold__c> jobBudgetThresoldList = [select id,Am_Brand_Positioning__r.name,Am_Brand__r.name,
                                                                      BrandCategoryPosition__c,Budget_Limit__c,Am_Category__r.name,
                                                                      UserEmailId__c from Amr_JobBudgetThreshold__c];
    String brandCategoryPosition = BrandPostion+Brand+Categorty;
    system.debug('=======>'+brandCategoryPosition);                                                      
    
    for(Amr_JobBudgetThreshold__c jobBudgetThresoldObj:jobBudgetThresoldList){
         system.debug('=======>'+jobBudgetThresoldObj.BrandCategoryPosition__c);  
         
         if(jobBudgetThresoldObj.BrandCategoryPosition__c == brandCategoryPosition){ 
            
            if(jobBudgetThresoldObj.Budget_Limit__c < amountEntered){
                
                ToUserEmailId = jobBudgetThresoldObj.UserEmailId__c;
                system.debug('to email Addresss====>'+ToUserEmailId);
                ToUserEmailId = String.valueOf(ToUserEmailId);
                sendEmailOnThresoldReached(ToUserEmailId);
            }
         }
    }
    
  }

 public void sendEmailOnThresoldReached(String toEmailId){
    
        Contact con = new Contact();
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
        String[] toAddresses = new String[] {};
        toAddresses.add(toEmailId); 
        
        if(jobDetails.Unilever_Project_Leader_Email__c !=null){  
        toAddresses.add(jobDetails.Unilever_Project_Leader_Email__c);
        }

             
        system.debug('job toAddresses!!'+toAddresses);
        mail.setToAddresses( toAddresses );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        System.debug('Mail Sent'+mail); 
        delete con;
        System.debug('Id ->' + eTemp);
        
  
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
    
        Contact con = new Contact();
        con.LastName = 'CAP';
        con.email = 'test@unilever.com';
        insert con;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Id eTemp = [select id from EmailTemplate where developername = 'Amr_UserNotification'].Id;
        
        String whatid;
        
        List<String> attachment= new List<String>();
        attachment.add('Talent Executive Summary');
        attachment.add('Animatics Executive Summary');
        attachment.add('Music Executive Summary');
        attachment.add('General Executive Summary');
        
        List<Document> doc = [select id, name, body, contenttype, developername, type from Document where name IN :attachment];
        
        List<Id> attachId = new List<Id>();
        
        for(Document docObj : doc){
            if(docObj.name == 'General Executive Summary'){
                system.debug('inside General Executive Summary');
               attachId.add(docObj.id);
            }
        }
        
        if(jobDetails.New_Original_Master__c == true &&(jobDetails.Tv__c == true || jobDetails.Cinema__c == true)){
            for(Document docObj : doc){
                if(docObj.name == 'Animatics Executive Summary'){
                    system.debug('inside Animatics Executive Summary');
                    attachId.add(docObj.id);
                }
            }
        
        }
        
        if(jobDetails.Require_Music__c == 'Yes' ){
            for(Document docObj : doc){
                if(docObj.name == 'Music Executive Summary'){
                    system.debug('inside Music Executive Summary');
                    attachId.add(docObj.id);
                }
            }
        }
        
        if(jobDetails.Require_Celebrity_Talent__c == 'No' ){
            for(Document docObj : doc){
                if(docObj.name == 'Talent Executive Summary'){
                    system.debug('inside Talent Executive Summary');
                    attachId.add(docObj.id);
                }
            }
        }
        
        system.debug('=========>'+attachId);
        mail.setDocumentAttachments(attachId);
        mail.setTargetObjectId(con.id);
        mail.setTemplateId(eTemp);
        mail.setSaveAsActivity(false);
        mail.setWhatId(jobDetails.id);
        mail.setTreatTargetObjectAsRecipient(false);
        String[] toAddresses = new String[] {};
        toAddresses.add(jobDetails.Your_Email_Address__c);
        
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
        
        
        
    
    }
    
    public void agencyNotificationSendEmail(){
        Contact con = new Contact();
        con.LastName = 'CAP';
        con.email = 'advertising.production@testunilever.com';
        insert con;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Id eTemp = [select id from EmailTemplate where developername = 'Amr_AgencyNotification'].Id;
        
        String whatid;
        
        List<String> attachment= new List<String>();
        attachment.add('Talent Executive Summary');
        attachment.add('Animatics Executive Summary');
        attachment.add('Music Executive Summary');
        attachment.add('General Executive Summary');
        
        List<Document> doc = [select id, name, body, contenttype, developername, type from Document where name IN :attachment];
        
        List<Id> attachId = new List<Id>();
        
        for(Document docObj : doc){
            if(docObj.name == 'General Executive Summary'){
                system.debug('inside General Executive Summary');
               attachId.add(docObj.id);
            }
        }
        
        if(jobDetails.New_Original_Master__c == true &&(jobDetails.Tv__c == true || jobDetails.Cinema__c == true)){
            for(Document docObj : doc){
                if(docObj.name == 'Animatics Executive Summary'){
                    system.debug('inside Animatics Executive Summary');
                    attachId.add(docObj.id);
                }
            }
        
        }
        system.debug('talent----------'+jobDetails.Require_Music__c);
        if(jobDetails.Require_Music__c == 'Yes' ){
            for(Document docObj : doc){
                if(docObj.name == 'Music Executive Summary'){
                    system.debug('inside Music Executive Summary');
                    attachId.add(docObj.id);
                }
            }
        }
        system.debug('talent----------'+jobDetails.Require_Celebrity_Talent__c);
        if(jobDetails.Require_Celebrity_Talent__c == 'Yes' ){
            for(Document docObj : doc){
                if(docObj.name == 'Talent Executive Summary'){
                    system.debug('inside Talent Executive Summary');
                    attachId.add(docObj.id);
                }
            }
        }
        
        system.debug('=========>'+attachId);
        mail.setDocumentAttachments(attachId);
        mail.setTargetObjectId(con.id);
        mail.setTemplateId(eTemp);
        mail.setSaveAsActivity(false);
        mail.setWhatId(jobDetails.id);
        mail.setTreatTargetObjectAsRecipient(false);
        String[] toAddresses = new String[] {};
        toAddresses.add(jobDetails.Agency_Contact_Account_Director_Email__c);   
        system.debug('job toAddresses!!'+toAddresses);
        mail.setToAddresses( toAddresses );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        System.debug('Mail Sent'+mail); 
        delete con;
        System.debug('Id ->' + eTemp);
        
    
    }


}