@isTest
public class Amr_JobAllocation_tst {
    
   static testMethod void methodToGetRecords(){
        
    
        Profile p = [SELECT Id FROM Profile WHERE Name='AMR']; 
        User u = new User(Alias = 'stan21', Email='standuser21@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing21', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standuser@org.com');
        
        User selectedUser = new User(Alias = 'selUsr', Email='selectedstanduser21@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='selectedTesting21', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='selectedUserr@org.com');
        
         User sharedJobUser = new User(Alias = 'shrUsr', Email='sharestanduser21@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='shareTesting21', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='shareUserr@org.com');
            
            insert u;
            insert selectedUser;
            insert sharedJobUser;
          Id permissionSetId =  [select id, PermissionSet.Name from PermissionSet  where Name = 'RAP' Limit 1].Id;  
          Id usharedRap = sharedJobUser.Id;
      PermissionSetAssignment permission= new PermissionSetAssignment(PermissionSetId = permissionSetId, AssigneeId = u.id);
       PermissionSetAssignment selectedPermission= new PermissionSetAssignment(PermissionSetId = permissionSetId, AssigneeId = selectedUser.id);
      insert permission; 
      insert selectedPermission;
      
      system.debug('********permission*****'+permission);
       
     
       
  
      System.runAs(u){
      
         List<PermissionSetAssignment> psList = new List<PermissionSetAssignment>();
         psList.add(permission);
      
        Amr_Project_Details__c projDetail = new Amr_Project_Details__c(Name='testProject');
        insert projDetail;
        
        Amr_CurrencyConversionRate__c currencyConversion = new Amr_CurrencyConversionRate__c(Name='testName',Currency_Unit__c='testUnit',Currency_Unit_To_Euro__c=1234);
        insert currencyConversion;
        MDO_Category__c category1 = new MDO_Category__c(Name='testCat');
        insert category1;
        MDO_BrandPosition__c brandPos = new MDO_BrandPosition__c(Name='testBrandPos');
        insert brandpos;
        MDO_Brand__c brand = new MDO_Brand__c(Name='testBrand');
        insert brand;
        
        MDO_BrandPositions__c MDOBrandPositions = new MDO_BrandPositions__c(brand_id__c = brand.id,brand_position_id__c = brandPos.id,product_category_id__c = category1.id);
        
        Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(Project_Details__c= projDetail.Id,Job_Cancelled__c = False, Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.Id,Brand_Final__c=brand.Id,ownerId=u.id,Job_Notes__c= 'abbbbbcc');
        insert jobDetail;
                        
      
        Amr_Job_Allocation__c jobAllocation1 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetail.Id,User__c=u.Id,Is_Primary__c=true);
        Amr_Job_Allocation__c jobSharedDet = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetail.Id,User__c=u.Id,Is_Primary__c=false);
        insert jobAllocation1;
        insert jobSharedDet;
      
         List <Amr_Job_Allocation__c > jobSharedDetailList = [ select id, User__c, User__r.Name from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobDetail.id AND Is_Primary__c = False ];
         List<String> sharedRapList = new List<String>();
         sharedRapList.add(sharedJobUser.id);
      
       Test.setCurrentPageReference(new PageReference('Page.AM_Jobsheet_bhupendra')); 
        System.currentPageReference().getParameters().put('id', jobDetail.id);
            
        Amr_JobSheetController jobAllocation = new Amr_JobSheetController();
        jobAllocation.jobAlloc=jobAllocation1;
        jobAllocation.jobList=jobDetail;
        List<SelectOption> selusers = new List<SelectOption>();
        selusers.add(new SelectOption(u.id,u.LastName));
        List<String>userStr=new List<String>();
        userStr.add(u.Id);
        String selRap = selectedUser.Id;
        List<selectOption> options = new List<selectOption>();
        options.add(new SelectOption(String.valueOf(currencyConversion.Currency_Unit_To_Euro__c),currencyConversion.Name+'-'+currencyConversion.Currency_Unit__c));
        
        Amr_JobSheetController.rapAllocateCheck = false;
        jobAllocation.jobId=jobDetail.Id;
        jobAllocation.jobSharedList = jobSharedDetailList;
        jobAllocation.selectUsername=selusers;
        jobAllocation.listOfRAPSelected = sharedRapList;
        jobAllocation.userData=psList;
        jobAllocation.selectedRAPUser = selRap;
        jobAllocation.profileName='RAP';
        jobAllocation.selectedCountry = String.valueOf(currencyConversion.Currency_Unit_To_Euro__c);
        jobAllocation.selectedRapName=selRap;
        jobAllocation.currencyRecords=options;
        Amr_JobSheetController job = new Amr_JobSheetController();
        jobAllocation.changePriority();
        jobAllocation.acceptJob();
        jobAllocation.updateJob();
        jobAllocation.updateJobForNotes();
        jobAllocation.reallocateRAP(); 
        jobAllocation.recordShare();
        jobAllocation.jobUnShare();
        
        
      //  jobAllocation.cancelRapJob();    
      //  jobAllocation.cancelJob();
        
      //  jobAllocation.recordShare();
        
        jobAllocation.getCategoryList();
        jobAllocation.selectedCategory = 'testCat';
        //jobAllocation.getBrandPositioningList();
        jobAllocation.brandPositionListData();
        jobAllocation.selectedBrandPosName = 'testBrandPos';
        jobAllocation.getBrandList();
        jobAllocation.getProjectNameList();
        jobAllocation.getMethodToPassProjectNames();
        jobAllocation.brandNameFromPage ='testBrand';
        jobAllocation.updateAdManagerText();
        List<SelectOption>catList=new List<SelectOption>();
        catList.add(new selectOption(category1.Id,category1.Name));
    
        List<SelectOption>brandposList=new List<SelectOption>();
        brandposList.add(new selectOption(brandpos.Id,brandpos.Name));
    
        List<SelectOption>brandList=new List<SelectOption>();
        brandList.add(new selectOption(brand.Id,brand.Name));
               
        jobAllocation.listOfCategory = catList;
        jobAllocation.listOfBrandPosition = brandposList;
        jobAllocation.listOfBrand =brandList;
       
      //  jobAllocation.listOfSelectedUsername=userStr;
        jobAllocation.reAllocate();
        jobAllocation.validateJobList();
        
        FeedItem FI = new FeedItem();
        FI.ParentId = jobDetail.id;
        FI.Body = 'Attachment added';
       // FI.ContentData = document.body;
       // FI.ContentFileName = document.Name;
        insert FI;
        jobAllocation.jobIdFromPage = jobDetail.id;
        jobAllocation.chosenDocId = FI.id;
        jobAllocation.deleteDocuments();
        system.assert(jobAllocation!= null);
    }
    }
    
    
    static testMethod void methodToGetRecords2(){
        
         Profile p = [SELECT Id FROM Profile WHERE Name='AMR']; 
            User u = new User(Alias = 'newtest1', Email='newcanceluser21@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='cancelTest', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='cancelUser@org.com');
            insert u;
        
        User selectedUser = new User(Alias = 'selUsr', Email='selectedstanduser21@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='selectedTesting21', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='selectedUserr@org.com');
            
            insert selectedUser;
        
        Amr_Project_Details__c projDetail = new Amr_Project_Details__c(Name='testProject');
        insert projDetail;
        Amr_CurrencyConversionRate__c currencyConversion = new Amr_CurrencyConversionRate__c(Name='testName',Currency_Unit__c='testUnit',Currency_Unit_To_Euro__c=1234);
        insert currencyConversion;
        MDO_Category__c category1 = new MDO_Category__c(Name='testCat');
        insert category1;
        MDO_BrandPosition__c brandPos = new MDO_BrandPosition__c(Name='testBrandPos');
        insert brandpos;
        MDO_Brand__c brand = new MDO_Brand__c(Name='testBrand');
        insert brand;
        
        MDO_BrandPositions__c MDOBrandPositions = new MDO_BrandPositions__c(brand_id__c = brand.id,brand_position_id__c = brandPos.id,product_category_id__c = category1.id);
        Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(Project_Details__c= projDetail.Id,Job_Cancelled__c = False, Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.Id,Brand_Final__c=brand.Id,ownerId=u.id);
        insert jobDetail;
                        
      
        Amr_Job_Allocation__c jobAllocation1 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetail.Id,User__c=u.Id,Is_Primary__c=true);
     //   Amr_Job_Allocation__c jobSharedDet = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetail.Id,User__c=u.Id,Is_Primary__c=false);
        insert jobAllocation1;
      //  insert jobSharedDet;
      
         List <Amr_Job_Allocation__c > jobSharedDetailList = [ select id, User__c, User__r.Name from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobDetail.id AND Is_Primary__c = False ];
      
       Test.setCurrentPageReference(new PageReference('Page.AM_Jobsheet_bhupendra')); 
        System.currentPageReference().getParameters().put('id', jobDetail.id);
            
        Amr_JobSheetController jobAllocation = new Amr_JobSheetController();   
        
       jobAllocation.jobAlloc=jobAllocation1;
        jobAllocation.jobList=jobDetail;
        Amr_JobSheetController.rapAllocateCheck = false;
        jobAllocation.jobId=jobDetail.Id;
        jobAllocation.cancelRapJob();   
        system.assert(jobAllocation!= null);
    }
    
    
    static testMethod void methodToGetRecords3(){
        
         Profile p = [SELECT Id FROM Profile WHERE Name='AMR']; 
            User u = new User(Alias = 'ntest1', Email='capcanceluser21@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='capcancelTest', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='capcancelUser@org.com');
            insert u;
        
        
        
        Amr_Project_Details__c projDetail = new Amr_Project_Details__c(Name='testProject');
        insert projDetail;
        Amr_CurrencyConversionRate__c currencyConversion = new Amr_CurrencyConversionRate__c(Name='testName',Currency_Unit__c='testUnit',Currency_Unit_To_Euro__c=1234);
        insert currencyConversion;
        MDO_Category__c category1 = new MDO_Category__c(Name='testCat');
        insert category1;
        MDO_BrandPosition__c brandPos = new MDO_BrandPosition__c(Name='testBrandPos');
        insert brandpos;
        MDO_Brand__c brand = new MDO_Brand__c(Name='testBrand');
        insert brand;
        
        MDO_BrandPositions__c MDOBrandPositions = new MDO_BrandPositions__c(brand_id__c = brand.id,brand_position_id__c = brandPos.id,product_category_id__c = category1.id);
        Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(Project_Details__c= projDetail.Id,Job_Cancelled__c = False, Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.Id,Brand_Final__c=brand.Id,ownerId=u.id);
        insert jobDetail;
                        
      
        Amr_Job_Allocation__c jobAllocation1 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetail.Id,User__c=u.Id,Is_Primary__c=true);
     //   Amr_Job_Allocation__c jobSharedDet = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetail.Id,User__c=u.Id,Is_Primary__c=false);
        insert jobAllocation1;
      //  insert jobSharedDet;
      
         List <Amr_Job_Allocation__c > jobSharedDetailList = [ select id, User__c, User__r.Name from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobDetail.id AND Is_Primary__c = False ];
      
       Test.setCurrentPageReference(new PageReference('Page.AM_Jobsheet_bhupendra')); 
        System.currentPageReference().getParameters().put('id', jobDetail.id);
            
        Amr_JobSheetController jobAllocation = new Amr_JobSheetController();   
        
       jobAllocation.jobAlloc=jobAllocation1;
        jobAllocation.jobList=jobDetail;
       
        Amr_JobSheetController.rapAllocateCheck = false;
        jobAllocation.jobId=jobDetail.Id;
        jobAllocation.cancelJob(); 
        
      
        system.assert(jobAllocation!= null);
    }
    
    
    
     static testMethod void methodToGetRecords4(){
        
         Profile p = [SELECT Id FROM Profile WHERE Name='AMR']; 
            User u = new User(Alias = 'relest1', Email='relocanceluser21@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='capcancelTest', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='relocatecancelUser@org.com');
            insert u;
            
            
            User selectedUser = new User(Alias = 'selUsr', Email='selectedstanduser21@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='selectedTesting21', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='selectedUserr@org.com');
            
            insert selectedUser;
        
        
        
        Amr_Project_Details__c projDetail = new Amr_Project_Details__c(Name='testProject');
        Amr_Project_Details__c projDetail2 = new Amr_Project_Details__c(Name='SecondTestProject');
        insert projDetail;
        insert projDetail2;
        Amr_CurrencyConversionRate__c currencyConversion = new Amr_CurrencyConversionRate__c(Name='testName',Currency_Unit__c='testUnit',Currency_Unit_To_Euro__c=1234);
        insert currencyConversion;
       MDO_Category__c category1 = new MDO_Category__c(Name='testCat');
        insert category1;
        MDO_BrandPosition__c brandPos = new MDO_BrandPosition__c(Name='testBrandPos');
        insert brandpos;
        MDO_Brand__c brand = new MDO_Brand__c(Name='testBrand');
        insert brand;
        
        MDO_BrandPositions__c MDOBrandPositions = new MDO_BrandPositions__c(brand_id__c = brand.id,brand_position_id__c = brandPos.id,product_category_id__c = category1.id);
        Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(Project_Details__c= projDetail.Id,Job_Cancelled__c = true, Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.Id,Brand_Final__c=brand.Id,ownerId=u.id);
         Amr_Job_Details__c jobDetailSec =new Amr_Job_Details__c(Project_Details__c= projDetail2.Id,Job_Cancelled__c = true, Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.Id,Brand_Final__c=brand.Id,ownerId=u.id);
        insert jobDetail;
        insert jobDetailSec;
                        
      
        Amr_Job_Allocation__c jobAllocation1 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetail.Id,User__c=u.Id,Is_Primary__c=false);
     //   Amr_Job_Allocation__c jobSharedDet = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetail.Id,User__c=u.Id,Is_Primary__c=false);
        insert jobAllocation1;
      //  insert jobSharedDet;
      
         List <Amr_Job_Allocation__c > jobSharedDetailList = [ select id, User__c, User__r.Name from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobDetail.id AND Is_Primary__c = False ];
      
       Test.setCurrentPageReference(new PageReference('Page.AM_Jobsheet_bhupendra')); 
        System.currentPageReference().getParameters().put('id', jobDetail.id);
            
        Amr_JobSheetController jobAllocation = new Amr_JobSheetController();   
        
       jobAllocation.jobAlloc=jobAllocation1;
        jobAllocation.jobList=jobDetail;
       
        Amr_JobSheetController.rapAllocateCheck = false;
        jobAllocation.jobId=jobDetail.Id;
        jobAllocation.selectedRAPUser = selectedUser.id;
        jobAllocation.reAllocate();
        Document dummyDocument = new Document();
        dummyDocument.name = 'test';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        dummyDocument.body=bodyBlob;
        jobAllocation.document = dummyDocument;
        jobAllocation.uploadDocument();
        system.assert(jobAllocation!= null);
    }
    
     static testMethod void methodToGetRecords5(){
        
         Profile p = [SELECT Id FROM Profile WHERE Name='AMR']; 
            User u = new User(Alias = 'relest2', Email='relocancelrapuser21@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='rapcancelTest', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='relocateRAPcancelUser@org.com');
            insert u;
            
            
            User selectedUser = new User(Alias = 'selUsr', Email='selectedstanduser21@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='selectedTesting21', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='selectedUserr@org.com');
            
            insert selectedUser;
        
        
        
        Amr_Project_Details__c projDetail = new Amr_Project_Details__c(Name='testProject');
        Amr_Project_Details__c projDetail2 = new Amr_Project_Details__c(Name='SecondTestProject');
        insert projDetail;
        insert projDetail2;
        Amr_CurrencyConversionRate__c currencyConversion = new Amr_CurrencyConversionRate__c(Name='testName',Currency_Unit__c='testUnit',Currency_Unit_To_Euro__c=1234);
        insert currencyConversion;
        MDO_Category__c category1 = new MDO_Category__c(Name='testCat');
        insert category1;
        MDO_BrandPosition__c brandPos = new MDO_BrandPosition__c(Name='testBrandPos');
        insert brandpos;
        MDO_Brand__c brand = new MDO_Brand__c(Name='testBrand');
        insert brand;
        
        MDO_BrandPositions__c MDOBrandPositions = new MDO_BrandPositions__c(brand_id__c = brand.id,brand_position_id__c = brandPos.id,product_category_id__c = category1.id);
        Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(Project_Details__c= projDetail.Id,Job_Cancelled__c = true, Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.Id,Brand_Final__c=brand.Id,ownerId=u.id);
         
        insert jobDetail;
       
                        
      
        Amr_Job_Allocation__c jobAllocation1 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetail.Id,User__c=u.Id,Is_Primary__c=false);
     //   Amr_Job_Allocation__c jobSharedDet = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetail.Id,User__c=u.Id,Is_Primary__c=false);
        insert jobAllocation1;
      //  insert jobSharedDet;
      
         List <Amr_Job_Allocation__c > jobSharedDetailList = [ select id, User__c, User__r.Name from Amr_Job_Allocation__c where AM_Job_Detail__c = :jobDetail.id AND Is_Primary__c = False ];
      
       Test.setCurrentPageReference(new PageReference('Page.AM_Jobsheet_bhupendra')); 
        System.currentPageReference().getParameters().put('id', jobDetail.id);
            
        Amr_JobSheetController jobAllocation = new Amr_JobSheetController();   
        
       jobAllocation.jobAlloc=jobAllocation1;
        jobAllocation.jobList=jobDetail;
       
        Amr_JobSheetController.rapAllocateCheck = false;
        jobAllocation.jobId=jobDetail.Id;
        jobAllocation.selectedRapName = selectedUser.id;
        
        jobAllocation.reAllocateRAP();
        system.assert(jobAllocation!= null);
    }
    
   static testMethod  void testMehod2(){
    	  List<Amr_Job_Allocation__c> listOptionsAlloc = new List<Amr_Job_Allocation__c>();
         Profile p = [SELECT Id FROM Profile WHERE Name='AMR']; 
         User u = new User(Alias = 'stan321', Email='standuser321@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing321', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stanuser@org.com');
            insert u;
            
    Amr_Project_Details__c projDetail = new Amr_Project_Details__c(Name='testProject');
    insert projDetail;    
   MDO_Category__c category1 = new MDO_Category__c(Name='testCat');
    insert category1;
    MDO_BrandPositions__c brandPos = new MDO_BrandPositions__c(product_category_id__c =category1.id);
    insert brandpos;
 
    MDO_Brand__c brand = new MDO_Brand__c(Name='testBrand');
    insert brand;
    list<Amr_Job_Details__c> jobList = new list<Amr_Job_Details__c>();
    Amr_Job_Details__c jobDetail1=new Amr_Job_Details__c(NewOriginalMasterCinema__c=false,NewOriginalMasterTv__c=false,GBVM_Email__c='abc12@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Name__c='testProj',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Digital_Agency_Name__c='testAgency',AdManagerText__c ='ABC/00001',Any_other_agencies_involved__c='Yes',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMasterRadio__c=false,NewOriginalMasterPrint__c=false,NewOriginalMasterOutofHome__c=false,NewOriginalMasterInStore__c=false,NewOriginalMasterDigital__c=false,NewOriginalMasterInternalVideo__c=false);
    insert jobDetail1;
     jobList.add(jobDetail1);
    Amr_Job_Details__c jobDetail2=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=true,NewOriginalMasterCinema__c=false,NewOriginalMasterTv__c=false,NewOriginalMasterRadio__c=false,NewOriginalMasterPrint__c=false,NewOriginalMasterOutofHome__c=false,NewOriginalMasterInStore__c=false,NewOriginalMasterDigital__c=false,NewOriginalMasterInternalVideo__c=false);
    insert jobDetail2;
     jobList.add(jobDetail2);
     Amr_Job_Details__c jobDetail3=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,NewOriginalMasterOutofHome__c=true,NewOriginalMasterOutofHomeMovingImage__c=false,NewOriginalMasterOutofHomeAudio__c=false,NewOriginalMasterOutofHomeStillImage__c=false);
    insert jobDetail3;
     jobList.add(jobDetail3);
     Amr_Job_Details__c jobDetail4=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=true,NewOriginalMasterInStore__c=true,NewOriginalMasterInStoreMovingImage__c=false,NewOriginalMasterInStoreAudio__c=false,NewOriginalMasterInStoreStillImage__c=false);
    insert jobDetail4;
     jobList.add(jobDetail4);
    Amr_Job_Details__c jobDetail5=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=true,NewOriginalMasterOutofHomeMovingImage__c=false,NewOriginalMasterOutofHomeAudio__c=false,NewOriginalMasterOutofHomeStillImage__c=false,NewOriginalMasterOutofHome__c=true);
    insert jobDetail5;
     jobList.add(jobDetail5);
    Amr_Job_Details__c jobDetail6=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=true,NewOriginalMasterInStore__c=true,NewOriginalMasterInStoreMovingImage__c=false,NewOriginalMasterInStoreAudio__c=false,NewOriginalMasterInStoreStillImage__c=false);
    insert jobDetail6;
     jobList.add(jobDetail6);
     Amr_Job_Details__c jobDetail7=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=true,NewOriginalMasterDigitalMovingImage__c=false,NewOriginalMasterDigitalAudio__c=false,NewOriginalMasterDigitalStillImage__c=false,NewOriginalMasterDigital__c=true,New_Original_Master_Digital_ED__c=false);
    insert jobDetail7;
     jobList.add(jobDetail7);
     Amr_Job_Details__c jobDetail8=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,LanguageAdaptionMaster__c=true,LanguageAdaptionMasterTv__c=false,LanguageAdaptionMasterCinema__c=false,LanguageAdaptionMasterRadio__c=false,LanguageAdaptionMasterPrint__c=false,LanguageAdaptionMasterOutofHome__c=false,LanguageAdaptionMasterInStore__c=false,LanguageAdaptionMasterDigital__c=false,LanguageAdaptionMasterInternalVideo__c=false);
    insert jobDetail8;
     jobList.add(jobDetail8);
    Amr_Job_Details__c jobDetail9=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,LanguageAdaptionMaster__c=true,LanguageAdaptionMasterOutofHome__c=true,LanguageAdaptionMasterOutofHomeAudio__c=false,LanguageAdaptionMasterOutHomeStillImage__c=false,LanguageAdaptionMasterOutHomeMovingImage__c=false);
    insert jobDetail9;
     jobList.add(jobDetail9);
    Amr_Job_Details__c jobDetail10=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,LanguageAdaptionMaster__c=true,LanguageAdaptionMasterInStore__c=true,LanguageAdaptionMasterInStoreAudio__c=false,LanguageAdaptionMasterInStoreMovingImage__c=false,LanguageAdaptionMasterInStoreStillImage__c=false);
    insert jobDetail10;
     jobList.add(jobDetail10);
    Amr_Job_Details__c jobDetail11=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,LanguageAdaptionMaster__c=true,LanguageAdaptionMasterDigital__c=true,LanguageAdaptionMasterDigitalAudio__c=false,LanguageAdaptionMasterDigitalMovingImage__c=false,LanguageAdaptionMasterDigitalStillImage__c=false,Language_Adaptation_of_Master_Digital_ED__c=false);
    insert jobDetail11;
     jobList.add(jobDetail11);
    Amr_Job_Details__c jobDetail12=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,Create_Additional_Material__c=true,AdditionalSupplementaryNewMaterialOOH__c=true,AdditionalSupplementaryNewMaterialOofHMI__c=false,AdditionalSupplementaryNewMaterialOofHSI__c=false,AdditionalSupplementaryNewMaterialOofHA__c=false);
    insert jobDetail12;
     jobList.add(jobDetail12);
    Amr_Job_Details__c jobDetail13=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,Create_Additional_Material__c=true,AdditionalSupplementaryNewMaterialStore__c=true,AdditionalSupplementaryNewMaterialInSMI__c=false,AdditionalSupplementaryNewMaterialInSA__c=false,AdditionalSupplementaryNewMaterialInSSI__c=false);
    insert jobDetail13;
     jobList.add(jobDetail13);
     Amr_Job_Details__c jobDetail14=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,Create_Additional_Material__c=true,AdditionalSupplementaryNewMaterialDigi__c=true,AdditionalSupplementaryNewMaterialDigiMI__c=false,AdditionalSupplementaryNewMaterialDigiA__c=false,AdditionalSupplementaryNewMaterialDigiSI__c=false,Additional_Supplementary_NM_Digital_ED__c=false);
    insert jobDetail14;
     jobList.add(jobDetail14);
    Amr_Job_Details__c jobDetail15=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,Create_Additional_Material__c=true,AdditionalSupplementaryNewMaterialStore__c=false,AdditionalSupplementaryNewMaterialDigi__c=false,AdditionalSupplementaryNewMaterialTv__c=false,AdditionalSupplementaryNewMaterialCinema__c=false,AdditionalSupplementaryNewMaterialRadio__c=false,AdditionalSupplementaryNewMaterialOOH__c=false,AdditionalSupplementaryNewMaterialIVideo__c=false);
    insert jobDetail15;
     jobList.add(jobDetail15);
     Amr_Job_Details__c jobDetail16=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,ReworkExistingMaterial__c=true,ReworkExistingMaterialOutofHome__c=true,ReworkExistingMaterialOutHomeMovingImage__c=false,ReworkExistingMaterialOutofHomeAudio__c=false,ReworkExistingMaterialOutHomeStillImage__c=false);
    insert jobDetail16;
     jobList.add(jobDetail16);
     Amr_Job_Details__c jobDetail17=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,ReworkExistingMaterial__c=true,ReworkExistingMaterialInStore__c=true,ReworkExistingMaterialInStoreMovingImage__c=false,ReworkExistingMaterialInStoreAudio__c=false,In_Store_Still_Image__c=false);
    insert jobDetail17;
     jobList.add(jobDetail17);
      Amr_Job_Details__c jobDetail18=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,ReworkExistingMaterial__c=true,ReworkExistingMaterialDigital__c=true,ReworkExistingMaterialDigitalMovingImage__c=false,ReworkExistingMaterialDigitalAudio__c=false,ReworkExistingMaterialDigitalStillImage__c=false,Rework_Exisiting_Material_Digital_ED__c=false);
    insert jobDetail18;
     jobList.add(jobDetail18);
     Amr_Job_Details__c jobDetail19=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,ReworkExistingMaterial__c=true,ReworkExistingMaterialOutofHome__c=false,ReworkExistingMaterialInStore__c=false,ReworkExistingMaterialDigital__c=false);
    insert jobDetail19;
     jobList.add(jobDetail19);
     Amr_Job_Details__c jobDetail20=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,BuyoutsTalent__c=true,BuyoutsTalentOutofHome__c=true,BuyoutsTalentOutofHomeMovingImage__c=false,BuyoutsTalentOutofHomeAudio__c=false,BuyoutsTalentOutofHomeStillImage__c=false);
    insert jobDetail20;
     jobList.add(jobDetail20);
    Amr_Job_Details__c jobDetail21=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,BuyoutsTalent__c=true,BuyoutsTalentDigital__c=true,BuyoutsTalentDigitalMovingImage__c=false,BuyoutsTalentDigitalAudio__c=false,BuyoutsTalentDigitalStillImage__c=false,Buyouts_Talent_Digital_ED__c=false);
    insert jobDetail21;
     jobList.add(jobDetail21);
    Amr_Job_Details__c jobDetail22=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,BuyoutsTalent__c=true,BuyoutsTalentOutofHome__c=false,BuyoutsTalentInStore__c=false,BuyoutsTalentDigital__c=false);
    insert jobDetail22;
     jobList.add(jobDetail22);
     Amr_Job_Details__c jobDetail23=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,BuyoutsMusic__c=true,BuyoutsMusicOutofHome__c=true,BuyoutsMusicOutofHomeMovingImage__c=false,BuyoutsMusicOutofHomeAudio__c=false,BuyoutsMusicOutofHomeStillImage__c=false);
    insert jobDetail23;
     jobList.add(jobDetail23);
    Amr_Job_Details__c jobDetail24=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,BuyoutsMusic__c=true,BuyoutsMusicInStore__c=false,BuyoutsMusicDigital__c=false,BuyoutsMusicTv__c=false,BuyoutsMusicCinema__c=false,BuyoutsMusicRadio__c=false,BuyoutsMusicInternalVideo__c=false,BuyoutsMusicOutofHome__c=false);
    insert jobDetail24;
     jobList.add(jobDetail24);
    Amr_Job_Details__c jobDetail25=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,BuyoutsMusic__c=true,BuyoutsMusicInStore__c=true,BuyoutsMusicInStoreAudio__c=false,BuyoutsMusicInStoreMovingImage__c=false,BuyoutsMusicInStoreStillImage__c=false);
    insert jobDetail25;
    jobList.add(jobDetail25);
    Amr_Job_Details__c jobDetail26=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,BuyoutsMusic__c=true,BuyoutsMusicDigital__c=true,BuyoutsMusicDigitalMovingImage__c=false,BuyoutsMusicDigitalAudio__c=false,BuyoutsMusicDigitalStillImage__c=false,Buyouts_Music_Digital_ED__c=false);
    insert jobDetail26;
    jobList.add(jobDetail26);
    Amr_Job_Details__c jobDetail27=new Amr_Job_Details__c(Require_Celebrity_Talent__c='yes',Lead_Agency_Location_Cluster__c='africa12',Lead_Agency_Location_Country__c='leadCon12',Project_Location_Country__c='testCont',Budget_Responsibility__c='BB',Require_Music__c='yes',Execution_Name__c='testEx',Production_Activity_Type__c='testActivityAb',Project_Location_Cluster__c='testClusterAb',Function_You_Are_Part__c='BB',Project_Description__c='abc',Check_With_CMI__c='yes',GBVM_Email__c='abc@gmail.com',Threshold_Amount__c=12.34,Is_Submitt__c=true,OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testNameAb',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,NewOriginalMaster__c=false,BuyoutsTalent__c=true,BuyoutsTalentInStore__c=true,BuyoutsTalentInStoreMovingImage__c=false,BuyoutsTalentInStoreAudio__c=false,BuyoutsTalentInStoreStillImage__c=false);
    insert jobDetail27;
    jobList.add(jobDetail27);
    Amr_Logging_Form_Setting__c setting = new Amr_Logging_Form_Setting__c(Allocation__c='manual',Footer__c='testFooter',Header__c='testHeader',Introduction__c='testIntro');
    insert setting;
    Amr_JobSheetController controller = new Amr_JobSheetController();
    controller.jobList = jobDetail27;
    controller.updateJob();
     
    }
    
    
     static testMethod  void showAndHideAlert(){
	    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'relest2', Email='relocancelrapuser21@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='rapcancelTest', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='relocateRAPcancelUser@org.com');
        insert u;
        
        
        User selectedUser = new User(Alias = 'selUsr', Email='selectedstanduser21@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='selectedTesting21', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='selectedUserr@org.com');
        
        insert selectedUser;

        Amr_Project_Details__c projDetail = new Amr_Project_Details__c(Name='testProject');
        Amr_Project_Details__c projDetail2 = new Amr_Project_Details__c(Name='SecondTestProject');
        insert projDetail;
        insert projDetail2;
        Amr_CurrencyConversionRate__c currencyConversion = new Amr_CurrencyConversionRate__c(Name='testName',Currency_Unit__c='testUnit',Currency_Unit_To_Euro__c=1234);
        insert currencyConversion;
        MDO_Category__c category1 = new MDO_Category__c(Name='testCat');
        insert category1;
        MDO_BrandPosition__c brandPos = new MDO_BrandPosition__c(Name='testBrandPos');
        insert brandpos;
        MDO_Brand__c brand = new MDO_Brand__c(Name='testBrand');
        insert brand;
        
        MDO_BrandPositions__c MDOBrandPositions = new MDO_BrandPositions__c(brand_id__c = brand.id,brand_position_id__c = brandPos.id,product_category_id__c = category1.id);
        Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(Project_Details__c= projDetail.Id,Job_Cancelled__c = true, Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',ProductCategory__c = category1.Id,Brand_Position__c =brandPos.Id,Brand_Final__c=brand.Id,ownerId=u.id);
         
        insert jobDetail;
        
        Amr_Alert__c alert = new Amr_Alert__c(New_Alert__c = Date.today(),Alert_Message__c ='abc');
        
        Amr_JobSheetController controller = new Amr_JobSheetController();
        controller.alertObj = alert;      
        controller.jobIdFromPage = jobDetail.id;
        controller.addNewAlert();
        controller.selectedAlert = controller.alertObj.id;
        controller.alertHide();
        controller.chosenId = jobDetail.id;
        controller.jobSheetPageTransfer();
        
      
        
    }
    
    
}