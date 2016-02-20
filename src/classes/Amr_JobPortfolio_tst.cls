@isTest
private class Amr_JobPortfolio_tst {
    
   /* static testMethod void methodToGetRecords(){
    List<Amr_Job_Details__c> listOptions = new List<Amr_Job_Details__c>();
      List<Amr_Job_Allocation__c> listOptionsAlloc = new List<Amr_Job_Allocation__c>();
    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
         User u = new User(Alias = 'stan321', Email='standuser321@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing321', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stanuser@org.com');
            insert u;
    Amr_Project_Details__c projDetail = new Amr_Project_Details__c(Name='testProject');
    insert projDetail;    
    Amr_Category__c category1 = new Amr_Category__c(Name='testCat');
    insert category1;
    Amr_Brand_Positioning__c brandPos = new Amr_Brand_Positioning__c(Category__c=category1.id,Name='testBrandPos');
    insert brandpos;
    Amr_Brand__c brand = new Amr_Brand__c(Brand_Positioning__c=brandPos.Id,Name='testBrand');
    insert brand;
    Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetail;
    listOptions.add(jobDetail);
    Amr_Job_Details__c jobDetailPending =new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Pending',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName1',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00002',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetailPending;
    system.debug('jobDetail!!'+jobDetail);
   listOptions.add(jobDetailPending);
     Amr_Job_Details__c jobDetailDormant =new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Dormant',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName2',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetailDormant;
   listOptions.add(jobDetailDormant);
    
    Amr_Job_Details__c jobDetailLive =new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Project_Details__c= projDetail.Id,Job_Status__c='Live',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName3',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00004',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetailLive;
   listOptions.add(jobDetailLive);
     Amr_Alert__c alert = new Amr_Alert__c(New_Alert__c=date.newInstance(2015, 11, 21),Alert_Message__c='ABC',Hide__c=true);
    insert alert;
    
    Amr_Job_Allocation__c jobAllocPri = new Amr_Job_Allocation__c(AM_Job_Detail__c = jobDetail.Id,User__c=u.Id,Job_Status__c='Yes',Started__c='Yes',Reported__c='Yes',Job_Shared__c='Yes');
    insert jobAllocPri;
     listOptionsAlloc.add(jobAllocPri);
    Amr_Job_Allocation__c jobAllocPen = new Amr_Job_Allocation__c(AM_Job_Detail__c = jobDetailPending.Id,User__c=u.Id,Job_Status__c='Yes',Started__c='Yes',Reported__c='Yes',Job_Shared__c='Yes');
    insert jobAllocPen;
      listOptionsAlloc.add(jobAllocPen);
    Amr_Job_Allocation__c jobAllocLiv = new Amr_Job_Allocation__c(AM_Job_Detail__c = jobDetailLive.Id,User__c=u.Id,Job_Status__c='Yes',Started__c='Yes',Reported__c='Yes',Job_Shared__c='Yes');
    insert jobAllocLiv;
      listOptionsAlloc.add(jobAllocLiv);
    Amr_Job_Allocation__c jobAllocDor = new Amr_Job_Allocation__c(AM_Job_Detail__c = jobDetailDormant.Id,User__c=u.Id,Job_Status__c='Yes',Started__c='Yes',Reported__c='Yes',Job_Shared__c='Yes');
    insert jobAllocDor;
      listOptionsAlloc.add(jobAllocDor);
    
    
    Amr_JobPortfolioController jobPortFolio = new Amr_JobPortfolioController();
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
    jobPortFolio.brodMarket='testMarket';
    
    jobPortFolio.projLeaderCountry='testCountry';
    jobPortFolio.agencyName='testAgency';
   // jobPortFolio.projName ='testProj';
    jobPortFolio.stageLogged='testStage';
    jobPortFolio.jobAccepted ='yes';
    jobPortFolio.jobStared ='yes';
    jobPortFolio.jobReported ='yes';
    jobPortFolio.jobShared ='yes';
    jobPortFolio.addNumber='ABC/00001';
    jobPortFolio.projEmail='abc@gmail.com';
    jobPortFolio.categoryName=category1.id;
    jobPortFolio.brandPos=brandPos.Id;
    jobPortFolio.brandName=brand.Id;
   // jobPortFolio.hideAlert();
   // jobPortFolio.unHideAlertShow();
   // jobPortFolio.unHideAlertHide();
  //  jobPortFolio.showUnhideRecords=false;
    jobPortFolio.flagForButtons=false;
    jobPortFolio.getCategoryList();
    jobPortFolio.getBrandPositioningList();
    jobPortFolio.getBrandList();
    jobPortFolio.getSortOptions();
    
    List<SelectOption>catList=new List<SelectOption>();
    catList.add(new selectOption(category1.Id,category1.Name));
    
    List<SelectOption>brandposList=new List<SelectOption>();
    brandposList.add(new selectOption(brandpos.Id,brandpos.Name));
    
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
    jobPortFolio.getMethodToPassProjNames();
    } 
  //  }
    jobPortFolio.alertHide();
        system.assert(jobDetailLive!= null);
    } 
   
   static testMethod void method2(){
    Amr_JobPortfolioController jobPortFolio = new Amr_JobPortfolioController();
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
            EmailEncodingKey='UTF-8', LastName='Testing321', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stanuser@org.com');
            insert u;
    Amr_Category__c category1 = new Amr_Category__c(Name='testCat');
    insert category1;
    Amr_Brand_Positioning__c brandPos = new Amr_Brand_Positioning__c(Category__c=category1.id,Name='testBrandPos');
    insert brandpos;
    Amr_Brand__c brand = new Amr_Brand__c(Brand_Positioning__c=brandPos.Id,Name='testBrand');
    insert brand;
    Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Job_Cancelled__c=false,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetail;
    Amr_Job_Details__c jobDetailPending =new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Job_Cancelled__c=false,Job_Status__c='Pending',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName1',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00002',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetailPending;
    Amr_Job_Details__c jobDetailLive=new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Job_Cancelled__c=false,Job_Status__c='Live',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetailLive;
    Amr_Job_Details__c jobDetailDormant =new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Job_Cancelled__c=false,Job_Status__c='Dormant',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName1',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00004',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetailDormant;
    
    Amr_Job_Allocation__c jobAllocation = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetail.Id,User__c=u.Id,Job_Status__c='Yes',Started__c='Yes',Reported__c='Yes',Job_Shared__c='Yes',Name='abc');
    insert jobAllocation;
    Amr_Job_Allocation__c jobAllocation1 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetailPending.Id,User__c=u.Id,Job_Status__c='Yes',Started__c='Yes',Reported__c='Yes',Job_Shared__c='Yes',Name='abc');
    insert jobAllocation1;
     Amr_Job_Allocation__c jobAllocation2 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetailLive.Id,User__c=u.Id,Job_Status__c='Yes',Started__c='Yes',Reported__c='Yes',Job_Shared__c='Yes',Name='abc');
    insert jobAllocation2;
    Amr_Job_Allocation__c jobAllocation3 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetailDormant.Id,User__c=u.Id,Job_Status__c='Yes',Started__c='Yes',Reported__c='Yes',Job_Shared__c='Yes',Name='abc');
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
    
    Amr_JobPortfolioController jobPortFolio = new Amr_JobPortfolioController();
    jobPortFolio.loggedInUserId=u.Id;
    jobPortFolio.jobAlloc=jobAllocation3;
    
    jobPortFolio.liveJobList=jobListLive;
    jobPortFolio.lstLiveJobsNew=jobListLive;
   //   jobPortFolio.liveJobsToShow=jobListLive;
    jobPortFolio.counterForLiveJobs=1;
    jobPortFolio.limitSizeForLiveJobs=1;
    jobPortFolio.totalSizeForLiveJobs=2;
    jobPortFolio.lastForLiveJobs();
    
    jobPortFolio.dormantJobList=jobListDor;
    jobPortFolio.lstDormantJobsNew=jobListDor;
   //   jobPortFolio.dormantJobsToShow=jobListDor;
    jobPortFolio.counterForDormantJobs=1;
    jobPortFolio.limitSizeForDormantJobs=1;
    jobPortFolio.totalSizeForDormantJobs=2;
    jobPortFolio.lastForDormantJobs();
    
    jobPortFolio.pendingJobList=jobListPen;
    jobPortFolio.lstPendingJobsNew=jobListPen;
   //   jobPortFolio.pendingJobsToShow=jobListPen;
    jobPortFolio.counterForPendingJobs=1;
    jobPortFolio.limitSizeForPendingJobs=1;
    jobPortFolio.totalSizeForPendingJobs=2;
    jobPortFolio.lastForPendingJobs();
    
    jobPortFolio.priorityJobList=jobListPri;
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
            EmailEncodingKey='UTF-8', LastName='Testing321', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='stanuser@org.com');
            insert u;
    Amr_Category__c category1 = new Amr_Category__c(Name='testCat');
    insert category1;
    Amr_Brand_Positioning__c brandPos = new Amr_Brand_Positioning__c(Category__c=category1.id,Name='testBrandPos');
    insert brandpos;
    Amr_Brand__c brand = new Amr_Brand__c(Brand_Positioning__c=brandPos.Id,Name='testBrand');
    insert brand;
    Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Job_Cancelled__c=false,Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetail;
    Amr_Job_Details__c jobDetailPending =new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Job_Cancelled__c=false,Job_Status__c='Pending',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName1',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00002',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetailPending;
    Amr_Job_Details__c jobDetailLive=new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Job_Cancelled__c=false,Job_Status__c='Live',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00003',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetailLive;
    Amr_Job_Details__c jobDetailDormant =new Amr_Job_Details__c(OwnerId=u.Id,Start_Date__c=date.newInstance(2015, 11, 21),End_Date__c=date.newInstance(2016, 11, 21),Job_Cancelled__c=false,Job_Status__c='Dormant',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName1',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00004',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetailDormant;
    
    Amr_Job_Allocation__c jobAllocation = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetail.Id,User__c=u.Id,Job_Status__c='Yes',Started__c='Yes',Reported__c='Yes',Job_Shared__c='Yes',Name='abc');
    insert jobAllocation;
    Amr_Job_Allocation__c jobAllocation1 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetailPending.Id,User__c=u.Id,Job_Status__c='Yes',Started__c='Yes',Reported__c='Yes',Job_Shared__c='Yes',Name='abc');
    insert jobAllocation1;
     Amr_Job_Allocation__c jobAllocation2 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetailLive.Id,User__c=u.Id,Job_Status__c='Yes',Started__c='Yes',Reported__c='Yes',Job_Shared__c='Yes',Name='abc');
    insert jobAllocation2;
    Amr_Job_Allocation__c jobAllocation3 = new Amr_Job_Allocation__c(AM_Job_Detail__c=jobDetailDormant.Id,User__c=u.Id,Job_Status__c='Yes',Started__c='Yes',Reported__c='Yes',Job_Shared__c='Yes',Name='abc');
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
    
    Amr_JobPortfolioController jobPortFolio = new Amr_JobPortfolioController();
    jobPortFolio.loggedInUserId=u.Id;
    jobPortFolio.jobAlloc=jobAllocation3;
    
    jobPortFolio.liveJobList=jobListLive;
    jobPortFolio.lstLiveJobsNew=jobListLive;
   //   jobPortFolio.liveJobsToShow=jobListLive;
    jobPortFolio.counterForLiveJobs=1;
    jobPortFolio.limitSizeForLiveJobs=1;
    jobPortFolio.totalSizeForLiveJobs=2;
    jobPortFolio.previousForLiveJobs();
        
    jobPortFolio.dormantJobList=jobListDor;
    jobPortFolio.lstDormantJobsNew=jobListDor;
   //   jobPortFolio.dormantJobsToShow=jobListDor;
    jobPortFolio.counterForDormantJobs=1;
    jobPortFolio.limitSizeForDormantJobs=1;
    jobPortFolio.totalSizeForDormantJobs=2;
    jobPortFolio.previousForDormantJobs();
    
    jobPortFolio.pendingJobList=jobListPen;
    jobPortFolio.lstPendingJobsNew=jobListPen;
   //   jobPortFolio.pendingJobsToShow=jobListPen;
    jobPortFolio.counterForPendingJobs=1;
    jobPortFolio.limitSizeForPendingJobs=1;
    jobPortFolio.totalSizeForPendingJobs=2;
    jobPortFolio.previousForPendingJobs();
    
    jobPortFolio.priorityJobList=jobListPri;
    jobPortFolio.lstpriorityJobsNew=jobListPri;
    //jobPortFolio.priorityJobsToShow=jobListPri;
    jobPortFolio.counterForPriorityJobs=1;
    jobPortFolio.limitSizeForPriorityJobs=1;
    jobPortFolio.totalSizeForPriorityJobs=2;
    jobPortFolio.previousForPriorityJobs();
   }*/
}