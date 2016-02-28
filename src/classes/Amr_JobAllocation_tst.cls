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
    }
}