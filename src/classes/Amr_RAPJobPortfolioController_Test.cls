@isTest
public class Amr_RAPJobPortfolioController_Test {


   static testMethod void methodToGetRecords(){
    List<Amr_Job_Details__c> listOptions = new List<Amr_Job_Details__c>();
    List<Amr_Job_Allocation__c> listOptionsAlloc = new List<Amr_Job_Allocation__c>();
    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
    User u = new User(Alias = 'stan321', Email='standuser321@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing321', LanguageLocaleKey=Amr_ConstantForAdManager.LOCALSIDEKEY, 
            LocaleSidKey=Amr_ConstantForAdManager.LOCALSIDEKEY, ProfileId = p.Id, 
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
    Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Name_Other__c=Amr_ConstantForAdManager.TESTNAME,Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc1@gmail.com',Broadcast_Market__c=Amr_ConstantForAdManager.TESTMARKET,Name='testName',Project_Leader_Cluster__c=Amr_ConstantForAdManager.TESTCLUSTER,Project_Leader_Country__c=Amr_ConstantForAdManager.TESTCOUNTRY,Lead_Creative_Agency_name__c=Amr_ConstantForAdManager.TESTAGENCY,Project_Name__c=Amr_ConstantForAdManager.TESTPROJECT,Stage_of_Production_Activity__c=Amr_ConstantForAdManager.TESTSTAGE,Job_Started__c=Amr_ConstantForAdManager.NO,Job_Reported__c=Amr_ConstantForAdManager.NO,Job_Shared__c=Amr_ConstantForAdManager.YES,Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c='abc2@gmail.com',Unilever_Finance_Member_Email__c='abc3@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc4@gmail.com',Digital_Agency_Name__c=Amr_ConstantForAdManager.TESTAGENCY,Campaign_Name__c=Amr_ConstantForAdManager.TESTCAMPAINGNAME,Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc5@gmail.com',Any_other_agencies_involved__c=Amr_ConstantForAdManager.YES,ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,Brodcast_Market__c=Amr_ConstantForAdManager.BROADMARKET); 
    insert jobDetail;
    listOptions.add(jobDetail);
    Amr_Job_Details__c jobDetailPending =new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Pending',Unilever_Project_Leader_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Broadcast_Market__c=Amr_ConstantForAdManager.TESTMARKET,Name='testName1',Project_Leader_Cluster__c=Amr_ConstantForAdManager.TESTCLUSTER,Project_Leader_Country__c=Amr_ConstantForAdManager.TESTCOUNTRY,Lead_Creative_Agency_name__c=Amr_ConstantForAdManager.TESTAGENCY,Project_Name__c=Amr_ConstantForAdManager.TESTPROJECT,Stage_of_Production_Activity__c=Amr_ConstantForAdManager.TESTSTAGE,Job_Started__c=Amr_ConstantForAdManager.YES,Job_Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c=Amr_ConstantForAdManager.TESTEMAIL,Unilever_Finance_Member_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Digital_Agency_Name__c=Amr_ConstantForAdManager.TESTAGENCY,Campaign_Name__c=Amr_ConstantForAdManager.TESTCAMPAINGNAME,Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00002',Agency_Contact_Account_Director_Email__c = Amr_ConstantForAdManager.TESTEMAIL,Any_other_agencies_involved__c=Amr_ConstantForAdManager.YES,Brodcast_Market__c=Amr_ConstantForAdManager.BROADMARKET,ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id);
    insert jobDetailPending;
   listOptions.add(jobDetailPending);
     Amr_Job_Details__c jobDetailDormant =new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Dormant',Unilever_Project_Leader_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Broadcast_Market__c=Amr_ConstantForAdManager.TESTMARKET,Name='testName2',Project_Leader_Cluster__c=Amr_ConstantForAdManager.TESTCLUSTER,Project_Leader_Country__c=Amr_ConstantForAdManager.TESTCOUNTRY,Lead_Creative_Agency_name__c=Amr_ConstantForAdManager.TESTAGENCY,Project_Name__c=Amr_ConstantForAdManager.TESTPROJECT,Stage_of_Production_Activity__c=Amr_ConstantForAdManager.TESTSTAGE,Job_Started__c=Amr_ConstantForAdManager.YES,Job_Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c=Amr_ConstantForAdManager.TESTEMAIL,Unilever_Finance_Member_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Digital_Agency_Name__c=Amr_ConstantForAdManager.TESTAGENCY,Campaign_Name__c=Amr_ConstantForAdManager.TESTCAMPAINGNAME,Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = Amr_ConstantForAdManager.TESTEMAIL,Any_other_agencies_involved__c=Amr_ConstantForAdManager.YES,Brodcast_Market__c=Amr_ConstantForAdManager.BROADMARKET,ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id);
    insert jobDetailDormant;
   listOptions.add(jobDetailDormant);
    
    Amr_Job_Details__c jobDetailLive =new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Live',Unilever_Project_Leader_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Broadcast_Market__c=Amr_ConstantForAdManager.TESTMARKET,Name='testName3',Project_Leader_Cluster__c=Amr_ConstantForAdManager.TESTCLUSTER,Project_Leader_Country__c=Amr_ConstantForAdManager.TESTCOUNTRY,Lead_Creative_Agency_name__c=Amr_ConstantForAdManager.TESTAGENCY,Project_Name__c=Amr_ConstantForAdManager.TESTPROJECT,Stage_of_Production_Activity__c=Amr_ConstantForAdManager.TESTSTAGE,Job_Started__c=Amr_ConstantForAdManager.YES,Job_Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c=Amr_ConstantForAdManager.TESTEMAIL,Unilever_Finance_Member_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Digital_Agency_Name__c=Amr_ConstantForAdManager.TESTAGENCY,Campaign_Name__c=Amr_ConstantForAdManager.TESTCAMPAINGNAME,Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00004',Agency_Contact_Account_Director_Email__c = Amr_ConstantForAdManager.TESTEMAIL,Any_other_agencies_involved__c=Amr_ConstantForAdManager.YES,Brodcast_Market__c=Amr_ConstantForAdManager.BROADMARKET,ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id);
    insert jobDetailLive;
   listOptions.add(jobDetailLive);
   Date todayDate = system.today() ;
   
     Amr_Alert__c alert = new Amr_Alert__c(New_Alert__c=todayDate,Alert_Message__c=Amr_ConstantForAdManager.TESTNAME,Hide__c=false);
    insert alert;
    
    Amr_Job_Allocation__c jobAllocPri = new Amr_Job_Allocation__c(Job_Allocated__c=Amr_ConstantForAdManager.YES,AM_Job_Detail__c = jobDetail.Id,User__c=u.Id,Job_Status__c=Amr_ConstantForAdManager.YES,Started__c=Amr_ConstantForAdManager.YES,Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES);
    insert jobAllocPri;
     listOptionsAlloc.add(jobAllocPri);
    Amr_Job_Allocation__c jobAllocPen = new Amr_Job_Allocation__c(Job_Allocated__c=Amr_ConstantForAdManager.YES,AM_Job_Detail__c = jobDetailPending.Id,User__c=u.Id,Job_Status__c=Amr_ConstantForAdManager.YES,Started__c=Amr_ConstantForAdManager.YES,Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES);
    insert jobAllocPen;
      listOptionsAlloc.add(jobAllocPen);
    Amr_Job_Allocation__c jobAllocLiv = new Amr_Job_Allocation__c(Job_Allocated__c=Amr_ConstantForAdManager.YES,AM_Job_Detail__c = jobDetailLive.Id,User__c=u.Id,Job_Status__c=Amr_ConstantForAdManager.YES,Started__c=Amr_ConstantForAdManager.YES,Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES);
    insert jobAllocLiv;
      listOptionsAlloc.add(jobAllocLiv);
    Amr_Job_Allocation__c jobAllocDor = new Amr_Job_Allocation__c(Job_Allocated__c=Amr_ConstantForAdManager.YES,AM_Job_Detail__c = jobDetailDormant.Id,User__c=u.Id,Job_Status__c=Amr_ConstantForAdManager.YES,Started__c=Amr_ConstantForAdManager.YES,Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES);
    insert jobAllocDor;
      listOptionsAlloc.add(jobAllocDor);
    Amr_Saving__c savingObj = new Amr_Saving__c(Duration_of_Additional_Films__c = '12.4', Duration_of_Masters__c = '5',Job_Details__c = jobDetail.id,
                                  Monthly_Submitted__c = 'January' ); 
                                  
    insert savingObj;
    
    Amr_RAPJobPortfolioController_CC jobPortFolio = new Amr_RAPJobPortfolioController_CC();
    jobPortFolio.loggedInUserId=u.Id;
    jobPortFolio.jobAlloc=jobAllocPri;
    jobPortFolio.selectedAlert=alert.Id;
    //for(Amr_Job_Allocation__c jobAlloc:listOptionsAlloc){
    for(Amr_Job_Details__c job:listOptions){
    
    jobPortFolio.jobDetails = job;
    
   // jobPortFolio.chosenId = job.Id;
    jobPortFolio.chosenAlertId = alert.Id;
    jobPortFolio.selectedSortPriorityOption='Job_Shared__c';
    jobPortFolio.selectedSortPendingOption='Job_Shared__c';
    jobPortFolio.selectedSortDormantOption='Job_Shared__c';
    jobPortFolio.selectedSortLiveOption='Job_Shared__c';
    jobPortFolio.startDate = '10/1/2015';
    jobPortFolio.endDate = '12/30/2015';
    jobPortFolio.projLeaderCluster =jobDetail.Project_Leader_Cluster__c;
    jobPortFolio.brodMarket=Amr_ConstantForAdManager.TESTMARKET;
    
    jobPortFolio.projLeaderCountry=Amr_ConstantForAdManager.TESTCOUNTRY;
    jobPortFolio.agencyName=Amr_ConstantForAdManager.TESTAGENCY;
   // jobPortFolio.projName =Amr_ConstantForAdManager.TESTPROJECT;
    jobPortFolio.stageLogged=Amr_ConstantForAdManager.TESTSTAGE;
    jobPortFolio.jobAccepted =Amr_ConstantForAdManager.YES;
    jobPortFolio.jobStared =Amr_ConstantForAdManager.YES;
    jobPortFolio.jobReported =Amr_ConstantForAdManager.YES;
    jobPortFolio.jobShared =Amr_ConstantForAdManager.YES;
    jobPortFolio.addNumber='ABC/00001';
    jobPortFolio.projEmail=Amr_ConstantForAdManager.TESTEMAIL;
    jobPortFolio.categoryName=category1.id;
    jobPortFolio.brandPos=brandPos.Id;
    jobPortFolio.brandName=brand.Id;
   // jobPortFolio.hideAlert();
   // jobPortFolio.unHideAlertShow();
   // jobPortFolio.unHideAlertHide();
  //  jobPortFolio.showUnhideRecords=false;
    jobPortFolio.flagForButtons=false;
    jobPortFolio.getCategoryList();
    
    jobPortFolio.getBrandList();
    jobPortFolio.getSortOptions();
    
    List<SelectOption>catList=new List<SelectOption>();
    catList.add(new selectOption(category1.Id,category1.Name));
    
    List<SelectOption>brandposList=new List<SelectOption>();
    brandposList.add(new selectOption(brandpos.Id,brandpos.Id));
    
    List<SelectOption>brandList=new List<SelectOption>();
    brandList.add(new selectOption(brand.Id,brand.Name));
    
    List<SelectOption>sortList = new  List<SelectOption>();
    sortList.add(new selectOption('--None--','--None--'));
    
       
    jobPortFolio.listOfCategory = catList;
    jobPortFolio.listOfBrandPosition = brandposList;
    jobPortFolio.listOfBrand =brandList;
    jobPortFolio.listOfSortOptions = sortList;
    //ApexPages.currentPage().getParameters().put('id',jobDetail.Id);
    jobPortFolio.getJobDetailSearch();
    jobPortFolio.brandPositionListData();
    jobPortFolio.jobSheetPageTransfer();
    jobPortFolio.getSortedPriorityList();
    jobPortFolio.getSortedPendingList();
    jobPortFolio.getSortedDormantList();
    jobPortFolio.getSortedLiveList();
    jobPortFolio.beginningForPriorityJobs();
    jobPortFolio.nextForPriorityJobs();
    jobPortFolio.getDisableNextForPriorityJobs();
    jobPortFolio.getDisablePreviousForPriorityJobs();
    jobPortFolio.beginningForPendingJobs();
    jobPortFolio.nextForPendingJobs();
    jobPortFolio.getDisableNextForPendingJobs();
    jobPortFolio.getDisablePreviousForPendingJobs();
    jobPortFolio.beginningForDormantJobs();
    jobPortFolio.nextForDormantJobs();
    jobPortFolio.getDisableNextForDormantJobs();
    jobPortFolio.getDisablePreviousForDormantJobs();
    jobPortFolio.beginningForLiveJobs();
    jobPortFolio.nextForLiveJobs();
    jobPortFolio.getDisableNextForLiveJobs();
    jobPortFolio.getDisablePreviousForLiveJobs();
    jobPortFolio.getMethodToPassProjectNames();
    
    } 
   // jobPortFolio.getTotalJobs(); //commented by me
    jobPortFolio.getTypes();
   // jobPortFolio.getPieData();
  //  jobPortFolio.getPieDataSaving();
   // jobPortFolio.getMethodToPassProjNames();
    jobPortFolio.getAlertRecords();
  //  }
    jobPortFolio.alertHide();
        system.assert(jobDetailLive!= null);
    } 
   
   static testMethod void method2(){
    Amr_RAPJobPortfolioController_CC jobPortFolio = new Amr_RAPJobPortfolioController_CC();
   jobPortFolio.counterForLiveJobs=0;
   jobPortFolio.limitSizeForLiveJobs=3;
   jobPortFolio.totalSizeForLiveJobs=10;
   jobPortFolio.counterForDormantJobs=0;
   jobPortFolio.limitSizeForDormantJobs=3;
   jobPortFolio.totalSizeForDormantJobs=10;
   jobPortFolio.counterForPendingJobs=0;
   jobPortFolio.limitSizeForPendingJobs=3;
   jobPortFolio.totalSizeForPendingJobs=10;
   jobPortFolio.counterForPriorityJobs=0;
   jobPortFolio.limitSizeForPriorityJobs=3;
   jobPortFolio.totalSizeForPriorityJobs=10;
   jobPortFolio.getDisableNextForPriorityJobs();
   jobPortFolio.getDisablePreviousForPriorityJobs();
   jobPortFolio.getDisableNextForPendingJobs();
   jobPortFolio.getDisablePreviousForPendingJobs();
   jobPortFolio.getDisableNextForDormantJobs();
   jobPortFolio.getDisablePreviousForDormantJobs();
   jobPortFolio.getDisableNextForLiveJobs();
   jobPortFolio.getDisablePreviousForLiveJobs();
    system.assert(jobPortFolio.limitSizeForPriorityJobs!= null);
   }
   
   static testMethod void method3(){
    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
         User u = new User(Alias = 'stan321', Email='standuser321@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing321', LanguageLocaleKey=Amr_ConstantForAdManager.LOCALSIDEKEY, 
            LocaleSidKey=Amr_ConstantForAdManager.LOCALSIDEKEY, ProfileId = p.Id, 
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
    Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Name_Other__c=Amr_ConstantForAdManager.TESTNAME,Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc1@gmail.com',Broadcast_Market__c=Amr_ConstantForAdManager.TESTMARKET,Name='testName',Project_Leader_Cluster__c=Amr_ConstantForAdManager.TESTCLUSTER,Project_Leader_Country__c=Amr_ConstantForAdManager.TESTCOUNTRY,Lead_Creative_Agency_name__c=Amr_ConstantForAdManager.TESTAGENCY,Project_Name__c=Amr_ConstantForAdManager.TESTPROJECT,Stage_of_Production_Activity__c=Amr_ConstantForAdManager.TESTSTAGE,Job_Started__c=Amr_ConstantForAdManager.NO,Job_Reported__c=Amr_ConstantForAdManager.NO,Job_Shared__c=Amr_ConstantForAdManager.YES,Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c='abc2@gmail.com',Unilever_Finance_Member_Email__c='abc3@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc4@gmail.com',Digital_Agency_Name__c=Amr_ConstantForAdManager.TESTAGENCY,Campaign_Name__c=Amr_ConstantForAdManager.TESTCAMPAINGNAME,Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc5@gmail.com',Any_other_agencies_involved__c=Amr_ConstantForAdManager.YES,ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,Brodcast_Market__c=Amr_ConstantForAdManager.BROADMARKET); 
    insert jobDetail;
   
    Amr_Job_Details__c jobDetailPending =new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Pending',Unilever_Project_Leader_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Broadcast_Market__c=Amr_ConstantForAdManager.TESTMARKET,Name='testName1',Project_Leader_Cluster__c=Amr_ConstantForAdManager.TESTCLUSTER,Project_Leader_Country__c=Amr_ConstantForAdManager.TESTCOUNTRY,Lead_Creative_Agency_name__c=Amr_ConstantForAdManager.TESTAGENCY,Project_Name__c=Amr_ConstantForAdManager.TESTPROJECT,Stage_of_Production_Activity__c=Amr_ConstantForAdManager.TESTSTAGE,Job_Started__c=Amr_ConstantForAdManager.YES,Job_Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c=Amr_ConstantForAdManager.TESTEMAIL,Unilever_Finance_Member_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Digital_Agency_Name__c=Amr_ConstantForAdManager.TESTAGENCY,Campaign_Name__c=Amr_ConstantForAdManager.TESTCAMPAINGNAME,Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00002',Agency_Contact_Account_Director_Email__c = Amr_ConstantForAdManager.TESTEMAIL,Any_other_agencies_involved__c=Amr_ConstantForAdManager.YES,Brodcast_Market__c=Amr_ConstantForAdManager.BROADMARKET,ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id);
    insert jobDetailPending;
  
     Amr_Job_Details__c jobDetailDormant =new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Dormant',Unilever_Project_Leader_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Broadcast_Market__c=Amr_ConstantForAdManager.TESTMARKET,Name='testName2',Project_Leader_Cluster__c=Amr_ConstantForAdManager.TESTCLUSTER,Project_Leader_Country__c=Amr_ConstantForAdManager.TESTCOUNTRY,Lead_Creative_Agency_name__c=Amr_ConstantForAdManager.TESTAGENCY,Project_Name__c=Amr_ConstantForAdManager.TESTPROJECT,Stage_of_Production_Activity__c=Amr_ConstantForAdManager.TESTSTAGE,Job_Started__c=Amr_ConstantForAdManager.YES,Job_Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c=Amr_ConstantForAdManager.TESTEMAIL,Unilever_Finance_Member_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Digital_Agency_Name__c=Amr_ConstantForAdManager.TESTAGENCY,Campaign_Name__c=Amr_ConstantForAdManager.TESTCAMPAINGNAME,Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = Amr_ConstantForAdManager.TESTEMAIL,Any_other_agencies_involved__c=Amr_ConstantForAdManager.YES,Brodcast_Market__c=Amr_ConstantForAdManager.BROADMARKET,ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id);
    insert jobDetailDormant;
  
    
    Amr_Job_Details__c jobDetailLive =new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Live',Unilever_Project_Leader_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Broadcast_Market__c=Amr_ConstantForAdManager.TESTMARKET,Name='testName3',Project_Leader_Cluster__c=Amr_ConstantForAdManager.TESTCLUSTER,Project_Leader_Country__c=Amr_ConstantForAdManager.TESTCOUNTRY,Lead_Creative_Agency_name__c=Amr_ConstantForAdManager.TESTAGENCY,Project_Name__c=Amr_ConstantForAdManager.TESTPROJECT,Stage_of_Production_Activity__c=Amr_ConstantForAdManager.TESTSTAGE,Job_Started__c=Amr_ConstantForAdManager.YES,Job_Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c=Amr_ConstantForAdManager.TESTEMAIL,Unilever_Finance_Member_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Digital_Agency_Name__c=Amr_ConstantForAdManager.TESTAGENCY,Campaign_Name__c=Amr_ConstantForAdManager.TESTCAMPAINGNAME,Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00004',Agency_Contact_Account_Director_Email__c = Amr_ConstantForAdManager.TESTEMAIL,Any_other_agencies_involved__c=Amr_ConstantForAdManager.YES,Brodcast_Market__c=Amr_ConstantForAdManager.BROADMARKET,ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id);
    insert jobDetailLive;
  
    
    Amr_Job_Allocation__c jobAllocation = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetail.Id,User__c=u.Id,Job_Status__c=Amr_ConstantForAdManager.YES,Started__c=Amr_ConstantForAdManager.YES,Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Name=Amr_ConstantForAdManager.TESTNAME);
    insert jobAllocation;
    Amr_Job_Allocation__c jobAllocation1 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetailPending.Id,User__c=u.Id,Job_Status__c=Amr_ConstantForAdManager.YES,Started__c=Amr_ConstantForAdManager.YES,Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Name=Amr_ConstantForAdManager.TESTNAME);
    insert jobAllocation1;
     Amr_Job_Allocation__c jobAllocation2 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetailLive.Id,User__c=u.Id,Job_Status__c=Amr_ConstantForAdManager.YES,Started__c=Amr_ConstantForAdManager.YES,Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Name=Amr_ConstantForAdManager.TESTNAME);
    insert jobAllocation2;
    Amr_Job_Allocation__c jobAllocation3 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetailDormant.Id,User__c=u.Id,Job_Status__c=Amr_ConstantForAdManager.YES,Started__c=Amr_ConstantForAdManager.YES,Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Name=Amr_ConstantForAdManager.TESTNAME);
    insert jobAllocation3;
    
    
    List<Amr_Job_Allocation__c> jobListPri = new List<Amr_Job_Allocation__c>();
    List<Amr_Job_Allocation__c> jobListPen = new List<Amr_Job_Allocation__c>();
    List<Amr_Job_Allocation__c> jobListLive = new List<Amr_Job_Allocation__c>();
    List<Amr_Job_Allocation__c> jobListDor = new List<Amr_Job_Allocation__c>();
    jobListPri.add(jobAllocation);
    jobListPri.add(jobAllocation1);
    jobListPen.add(jobAllocation1);
    jobListPen.add(jobAllocation);
    jobListLive.add(jobAllocation2);
    jobListLive.add(jobAllocation1);
    jobListDor.add(jobAllocation3);
    jobListDor.add(jobAllocation2);
    
    Amr_RAPJobPortfolioController_CC jobPortFolio = new Amr_RAPJobPortfolioController_CC();
    jobPortFolio.loggedInUserId=u.Id;
    jobPortFolio.jobAlloc=jobAllocation3;
    
    //jobPortFolio.liveJobList=jobListLive;
    jobPortFolio.lstLiveJobsNew=jobListLive;
   //   jobPortFolio.liveJobsToShow=jobListLive;
    jobPortFolio.counterForLiveJobs=1;
    jobPortFolio.limitSizeForLiveJobs=1;
    jobPortFolio.totalSizeForLiveJobs=2;
    jobPortFolio.lastForLiveJobs();
    
   // jobPortFolio.dormantJobList=jobListDor;
    jobPortFolio.lstDormantJobsNew=jobListDor;
   //   jobPortFolio.dormantJobsToShow=jobListDor;
    jobPortFolio.counterForDormantJobs=1;
    jobPortFolio.limitSizeForDormantJobs=1;
    jobPortFolio.totalSizeForDormantJobs=2;
    jobPortFolio.lastForDormantJobs();
    
   // jobPortFolio.pendingJobList=jobListPen;
    jobPortFolio.lstPendingJobsNew=jobListPen;
   //   jobPortFolio.pendingJobsToShow=jobListPen;
    jobPortFolio.counterForPendingJobs=1;
    jobPortFolio.limitSizeForPendingJobs=1;
    jobPortFolio.totalSizeForPendingJobs=2;
    jobPortFolio.lastForPendingJobs();
    
    //jobPortFolio.priorityJobList=jobListPri;
    jobPortFolio.lstpriorityJobsNew=jobListPri;
    //jobPortFolio.priorityJobsToShow=jobListPri;
    jobPortFolio.counterForPriorityJobs=1;
    jobPortFolio.limitSizeForPriorityJobs=1;
    jobPortFolio.totalSizeForPriorityJobs=2;
    jobPortFolio.lastForPriorityJobs();
    
    jobPortFolio.paginationMethodForPriorityJobs(jobListPri);
    jobPortFolio.paginationMethodForPendingJobs(jobListPen);
    jobPortFolio.paginationMethodForDormantJobs(jobListDor);
    jobPortFolio.paginationMethodForLiveJobs(jobListLive);
    
    
    system.assert(jobDetail!= null);
   }
   
   static testMethod void method4(){
    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
         User u = new User(Alias = 'stan321', Email='standuser321@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing321', LanguageLocaleKey=Amr_ConstantForAdManager.LOCALSIDEKEY, 
            LocaleSidKey=Amr_ConstantForAdManager.LOCALSIDEKEY, ProfileId = p.Id, 
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
    Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Name_Other__c=Amr_ConstantForAdManager.TESTNAME,Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc1@gmail.com',Broadcast_Market__c=Amr_ConstantForAdManager.TESTMARKET,Name='testName',Project_Leader_Cluster__c=Amr_ConstantForAdManager.TESTCLUSTER,Project_Leader_Country__c=Amr_ConstantForAdManager.TESTCOUNTRY,Lead_Creative_Agency_name__c=Amr_ConstantForAdManager.TESTAGENCY,Project_Name__c=Amr_ConstantForAdManager.TESTPROJECT,Stage_of_Production_Activity__c=Amr_ConstantForAdManager.TESTSTAGE,Job_Started__c=Amr_ConstantForAdManager.NO,Job_Reported__c=Amr_ConstantForAdManager.NO,Job_Shared__c=Amr_ConstantForAdManager.YES,Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c='abc2@gmail.com',Unilever_Finance_Member_Email__c='abc3@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc4@gmail.com',Digital_Agency_Name__c=Amr_ConstantForAdManager.TESTAGENCY,Campaign_Name__c=Amr_ConstantForAdManager.TESTCAMPAINGNAME,Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc5@gmail.com',Any_other_agencies_involved__c=Amr_ConstantForAdManager.YES,ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id,Brodcast_Market__c=Amr_ConstantForAdManager.BROADMARKET); 
    insert jobDetail;
   
    Amr_Job_Details__c jobDetailPending =new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Pending',Unilever_Project_Leader_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Broadcast_Market__c=Amr_ConstantForAdManager.TESTMARKET,Name='testName1',Project_Leader_Cluster__c=Amr_ConstantForAdManager.TESTCLUSTER,Project_Leader_Country__c=Amr_ConstantForAdManager.TESTCOUNTRY,Lead_Creative_Agency_name__c=Amr_ConstantForAdManager.TESTAGENCY,Project_Name__c=Amr_ConstantForAdManager.TESTPROJECT,Stage_of_Production_Activity__c=Amr_ConstantForAdManager.TESTSTAGE,Job_Started__c=Amr_ConstantForAdManager.YES,Job_Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c=Amr_ConstantForAdManager.TESTEMAIL,Unilever_Finance_Member_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Digital_Agency_Name__c=Amr_ConstantForAdManager.TESTAGENCY,Campaign_Name__c=Amr_ConstantForAdManager.TESTCAMPAINGNAME,Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00002',Agency_Contact_Account_Director_Email__c = Amr_ConstantForAdManager.TESTEMAIL,Any_other_agencies_involved__c=Amr_ConstantForAdManager.YES,Brodcast_Market__c=Amr_ConstantForAdManager.BROADMARKET,ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id);
    insert jobDetailPending;
 
     Amr_Job_Details__c jobDetailDormant =new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Dormant',Unilever_Project_Leader_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Broadcast_Market__c=Amr_ConstantForAdManager.TESTMARKET,Name='testName2',Project_Leader_Cluster__c=Amr_ConstantForAdManager.TESTCLUSTER,Project_Leader_Country__c=Amr_ConstantForAdManager.TESTCOUNTRY,Lead_Creative_Agency_name__c=Amr_ConstantForAdManager.TESTAGENCY,Project_Name__c=Amr_ConstantForAdManager.TESTPROJECT,Stage_of_Production_Activity__c=Amr_ConstantForAdManager.TESTSTAGE,Job_Started__c=Amr_ConstantForAdManager.YES,Job_Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c=Amr_ConstantForAdManager.TESTEMAIL,Unilever_Finance_Member_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Digital_Agency_Name__c=Amr_ConstantForAdManager.TESTAGENCY,Campaign_Name__c=Amr_ConstantForAdManager.TESTCAMPAINGNAME,Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = Amr_ConstantForAdManager.TESTEMAIL,Any_other_agencies_involved__c=Amr_ConstantForAdManager.YES,Brodcast_Market__c=Amr_ConstantForAdManager.BROADMARKET,ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id);
    insert jobDetailDormant;
 
    
    Amr_Job_Details__c jobDetailLive =new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Live',Unilever_Project_Leader_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Broadcast_Market__c=Amr_ConstantForAdManager.TESTMARKET,Name='testName3',Project_Leader_Cluster__c=Amr_ConstantForAdManager.TESTCLUSTER,Project_Leader_Country__c=Amr_ConstantForAdManager.TESTCOUNTRY,Lead_Creative_Agency_name__c=Amr_ConstantForAdManager.TESTAGENCY,Project_Name__c=Amr_ConstantForAdManager.TESTPROJECT,Stage_of_Production_Activity__c=Amr_ConstantForAdManager.TESTSTAGE,Job_Started__c=Amr_ConstantForAdManager.YES,Job_Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c=Amr_ConstantForAdManager.TESTEMAIL,Unilever_Finance_Member_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c=Amr_ConstantForAdManager.TESTEMAIL,Digital_Agency_Name__c=Amr_ConstantForAdManager.TESTAGENCY,Campaign_Name__c=Amr_ConstantForAdManager.TESTCAMPAINGNAME,Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00004',Agency_Contact_Account_Director_Email__c = Amr_ConstantForAdManager.TESTEMAIL,Any_other_agencies_involved__c=Amr_ConstantForAdManager.YES,Brodcast_Market__c=Amr_ConstantForAdManager.BROADMARKET,ProductCategory__c = category1.Id,Brand_Position__c =brandPos.brand_position_id__c,Brand_Final__c=brand.Id);
    insert jobDetailLive;
  
    
    Amr_Job_Allocation__c jobAllocation = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetail.Id,User__c=u.Id,Job_Status__c=Amr_ConstantForAdManager.YES,Started__c=Amr_ConstantForAdManager.YES,Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Name=Amr_ConstantForAdManager.TESTNAME);
    insert jobAllocation;
    Amr_Job_Allocation__c jobAllocation1 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetailPending.Id,User__c=u.Id,Job_Status__c=Amr_ConstantForAdManager.YES,Started__c=Amr_ConstantForAdManager.YES,Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Name=Amr_ConstantForAdManager.TESTNAME);
    insert jobAllocation1;
     Amr_Job_Allocation__c jobAllocation2 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetailLive.Id,User__c=u.Id,Job_Status__c=Amr_ConstantForAdManager.YES,Started__c=Amr_ConstantForAdManager.YES,Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Name=Amr_ConstantForAdManager.TESTNAME);
    insert jobAllocation2;
    Amr_Job_Allocation__c jobAllocation3 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetailDormant.Id,User__c=u.Id,Job_Status__c=Amr_ConstantForAdManager.YES,Started__c=Amr_ConstantForAdManager.YES,Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c=Amr_ConstantForAdManager.YES,Name=Amr_ConstantForAdManager.TESTNAME);
    insert jobAllocation3;
    
    
    List<Amr_Job_Allocation__c> jobListPri = new List<Amr_Job_Allocation__c>();
    List<Amr_Job_Allocation__c> jobListPen = new List<Amr_Job_Allocation__c>();
    List<Amr_Job_Allocation__c> jobListLive = new List<Amr_Job_Allocation__c>();
    List<Amr_Job_Allocation__c> jobListDor = new List<Amr_Job_Allocation__c>();
    jobListPri.add(jobAllocation);
    jobListPri.add(jobAllocation1);
    jobListPen.add(jobAllocation1);
    jobListPen.add(jobAllocation);
    jobListLive.add(jobAllocation2);
    jobListLive.add(jobAllocation1);
    jobListDor.add(jobAllocation3);
    jobListDor.add(jobAllocation2);
    
    Amr_RAPJobPortfolioController_CC jobPortFolio = new Amr_RAPJobPortfolioController_CC();
    jobPortFolio.loggedInUserId=u.Id;
    jobPortFolio.jobAlloc=jobAllocation3;
    
   // jobPortFolio.liveJobList=jobListLive;
    jobPortFolio.lstLiveJobsNew=jobListLive;
   //   jobPortFolio.liveJobsToShow=jobListLive;
    jobPortFolio.counterForLiveJobs=1;
    jobPortFolio.limitSizeForLiveJobs=1;
    jobPortFolio.totalSizeForLiveJobs=2;
    jobPortFolio.previousForLiveJobs();
        
    //jobPortFolio.dormantJobList=jobListDor;
    jobPortFolio.lstDormantJobsNew=jobListDor;
   //   jobPortFolio.dormantJobsToShow=jobListDor;
    jobPortFolio.counterForDormantJobs=1;
    jobPortFolio.limitSizeForDormantJobs=1;
    jobPortFolio.totalSizeForDormantJobs=2;
    jobPortFolio.previousForDormantJobs();
    
    //jobPortFolio.pendingJobList=jobListPen;
    jobPortFolio.lstPendingJobsNew=jobListPen;
   //   jobPortFolio.pendingJobsToShow=jobListPen;
    jobPortFolio.counterForPendingJobs=1;
    jobPortFolio.limitSizeForPendingJobs=1;
    jobPortFolio.totalSizeForPendingJobs=2;
    jobPortFolio.previousForPendingJobs();
    
    //jobPortFolio.priorityJobList=jobListPri;
    jobPortFolio.lstpriorityJobsNew=jobListPri;
    //jobPortFolio.priorityJobsToShow=jobListPri;
    jobPortFolio.counterForPriorityJobs=1;
    jobPortFolio.limitSizeForPriorityJobs=1;
    jobPortFolio.totalSizeForPriorityJobs=2;
    jobPortFolio.previousForPriorityJobs();
    system.assert(jobDetail!=null);
   }
    
}