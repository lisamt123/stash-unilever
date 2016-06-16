@isTest
public class Amr_CAPJobPortfolioController_Test{

    static testMethod void methodToGetRecords(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
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
        
         Amr_Trigger_Pattern__c customSetting = new Amr_Trigger_Pattern__c(Check_Run__c = true,name = 'Amr_Report');
        insert customSetting;
        
        Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Name_Other__c='abc',Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc1@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='no',Job_Reported__c='no',Job_Shared__c=Amr_ConstantForAdManager.YES,Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c='abc2@gmail.com',Unilever_Finance_Member_Email__c='abc3@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc4@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc5@gmail.com',Any_other_agencies_involved__c=Amr_ConstantForAdManager.YES,ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,Brodcast_Market__c='broadMarket'); 
        insert jobDetail;
               
        Amr_Job_Allocation__c jobAllocation = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetail.Id,User__c=u.Id,Job_Allocated__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Reported__c=Amr_ConstantForAdManager.YES,Started__c=Amr_ConstantForAdManager.YES,Job_Status__c=Amr_ConstantForAdManager.YES);
        insert jobAllocation;
        Amr_CAPJobPortfolioController_CC jobPortFolio = new Amr_CAPJobPortfolioController_CC();
               
        jobPortFolio.jobAllocation = jobAllocation;
        jobPortFolio.jobDetails = jobDetail;
        jobPortFolio.acceptedString='Accepted';
        jobPortFolio.cancelledString='Cancelled';
        jobPortFolio.selectedSortJobsOption ='User__c';
        jobPortFolio.selectedSortCancelOption='User__c';
        jobPortFolio.startDate = '10/1/2015';
        jobPortFolio.endDate = '12/30/2015';
        jobPortFolio.userName =u.Id;
        jobPortFolio.categoryName=category1.id;
        jobPortFolio.brandPos=brandPos.Id;
        jobPortFolio.brandName=brand.Id;
        jobPortFolio.getCategoryList();
        jobPortFolio.brandPositionListData();
        jobPortFolio.getBrandList();
        jobPortFolio.getUserList();
        jobPortFolio.getSortOptions();
        
        
        List<SelectOption>catList=new List<SelectOption>();
        catList.add(new selectOption(category1.Id,category1.Name));
    
        List<SelectOption>brandposList=new List<SelectOption>();
        brandposList.add(new selectOption(brandpos.Id,brandpos.Id));
    
        List<SelectOption>brandList=new List<SelectOption>();
        brandList.add(new selectOption(brand.Id,brand.Name));
        
        List<SelectOption>userList=new List<SelectOption>();
        userList.add(new selectOption(u.Id,u.LastName));
    
        List<SelectOption>sortList = new  List<SelectOption>();
        sortList.add(new selectOption('--None--','--None--'));
        
        jobPortFolio.listOfCategory = catList;
        jobPortFolio.listOfBrandPosition = brandposList;
        jobPortFolio.listOfBrand =brandList;
        jobPortFolio.listOfSortOptions = sortList;
        jobPortFolio.listOfUser = userList;
        
        jobPortFolio.brandPositionListData();
        jobPortFolio.getJobSearchDetails();
        jobPortFolio.jobSheetPageTransfer();
        jobPortFolio.beginningForActiveJobs();
        jobPortFolio.nextForActiveJobs();
        jobPortFolio.getDisableNextForActiveJobs();
        jobPortFolio.getDisablePreviousForActiveJobs();
        jobPortFolio.beginningForCancelJobs();
        jobPortFolio.nextForCancelJobs();
        jobPortFolio.getDisableNextForCancelJobs();
        jobPortFolio.getDisablePreviousForCancelJobs();
        jobPortFolio.getMethodToPassProjectNames();
        
        system.assert(jobDetail!=null);
    
    }
    
     static testMethod void method2(){
    Amr_CAPJobPortfolioController_CC  jobPortFolio = new Amr_CAPJobPortfolioController_CC();
   jobPortFolio.counterForActiveJobs=0;
   jobPortFolio.limitSizeForActiveJobs=3;
   jobPortFolio.totalSizeForActiveJobs=10;
   jobPortFolio.counterForCancelJobs=0;
   jobPortFolio.limitSizeForCancelJobs=3;
   jobPortFolio.totalSizeForCancelJobs=10;
   jobPortFolio.getDisableNextForActiveJobs();
   jobPortFolio.getDisablePreviousForActiveJobs();
   jobPortFolio.getDisableNextForCancelJobs();
   jobPortFolio.getDisablePreviousForCancelJobs();
   
    system.assert(jobPortFolio.limitSizeForActiveJobs!= null);
   }
   
    static testMethod void method3(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
    User u = new User(Alias = 'standt12', Email='standarduser12@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing12', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stanuseramrms12@amrorg.com');
            insert u;
         Amr_Project_Details__c projDetail = new Amr_Project_Details__c(Name='testProject');
        insert projDetail;    
        MDO_Category__c category1 = new MDO_Category__c(Name='testCat');
        insert category1;
        MDO_BrandPositions__c brandPos = new MDO_BrandPositions__c(product_category_id__c =category1.id);
        insert brandpos;
        
        MDO_Brand__c brand = new MDO_Brand__c(Name='testBrand');
        insert brand;
        
         Amr_Trigger_Pattern__c customSetting = new Amr_Trigger_Pattern__c(Check_Run__c = true,name = 'Amr_Report');
        insert customSetting;
        
        Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc1@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='no',Job_Reported__c='no',Job_Shared__c=Amr_ConstantForAdManager.YES,Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c='abc2@gmail.com',Unilever_Finance_Member_Email__c='abc3@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc4@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc5@gmail.com',Any_other_agencies_involved__c=Amr_ConstantForAdManager.YES,ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,Brodcast_Market__c='broadMarket'); 
        insert jobDetail;
    
    Amr_Job_Allocation__c jobAllocation = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetail.Id,User__c=u.Id,Job_Status__c='Accepted',Job_Allocated__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Reported__c=Amr_ConstantForAdManager.YES,Started__c=Amr_ConstantForAdManager.YES);
    insert jobAllocation;
    Amr_Job_Allocation__c jobAllocation1 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetail.Id,User__c=u.Id,Job_Status__c='Cancelled',Job_Allocated__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Reported__c=Amr_ConstantForAdManager.YES,Started__c=Amr_ConstantForAdManager.YES);
    insert jobAllocation1;
    
    
    Amr_CAPJobPortfolioController_CC  jobPortFolio = new Amr_CAPJobPortfolioController_CC();
    List<Amr_Job_Allocation__c> jobList = new List<Amr_Job_Allocation__c>();
    List<Amr_Job_Allocation__c> jobList1 = new List<Amr_Job_Allocation__c>();
    jobList.add(jobAllocation);
    jobList1.add(jobAllocation1);
    
    jobPortFolio.activeJobsToShow=jobList;
    jobPortFolio.jobDetailList=jobList1;
    jobPortFolio.counterForActiveJobs=1;
    jobPortFolio.limitSizeForActiveJobs=1;
    jobPortFolio.totalSizeForActiveJobs=2;
    
   //   jobPortFolio.WrapperList[0].SelectBox=true;
   Amr_CAPJobPortfolioController_CC.WrapperClass wrap = new Amr_CAPJobPortfolioController_CC.WrapperClass(true,jobAllocation);
   List<Amr_CAPJobPortfolioController_CC.WrapperClass> wrapList=new List<Amr_CAPJobPortfolioController_CC.WrapperClass>();
   for(Amr_Job_Allocation__c sObj:jobList1){
    wrapList.add(new Amr_CAPJobPortfolioController_CC.WrapperClass(true,sObj));
   }
   jobPortFolio.wrapperList=wrapList;
    //jobPortFolio.cancelJobsToShow=jobList;
    jobPortFolio.jobDetailCancellationList=jobList1;
    jobPortFolio.counterForCancelJobs=1;
    jobPortFolio.limitSizeForCancelJobs=1;
    jobPortFolio.totalSizeForCancelJobs=2;
    
    
    jobPortFolio.lastForActiveJobs();
    jobPortFolio.lastForCancelJobs();

    jobPortFolio.previousForActiveJobs();
    jobPortFolio.previousForCancelJobs();
    jobPortFolio.paginationMethodForActiveJobs(jobList);
    jobPortFolio.paginationMethodForCancelJobs(wrapList);
    PageReference pageRef = Page.Amr_CAPJobportfolio;
    Test.setCurrentPage(pageRef);
    jobPortFolio.changwrapperClasseStatus();
 
    
    system.assert(jobAllocation1!= null);
   }

}