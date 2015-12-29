@isTest
private class Amr_JobPortfolio_tst {
    
    static testMethod void methodToGetRecords(){
    List<Amr_Job_Details__c> listOptions = new List<Amr_Job_Details__c>();    
    Amr_Category__c category1 = new Amr_Category__c(Name='testCat');
    insert category1;
    Amr_Brand_Positioning__c brandPos = new Amr_Brand_Positioning__c(Category__c=category1.id,Name='testBrandPos');
    insert brandpos;
    Amr_Brand__c brand = new Amr_Brand__c(Brand_Positioning__c=brandPos.Id,Name='testBrand');
    insert brand;
    Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetail;
    listOptions.add(jobDetail);
    Amr_Job_Details__c jobDetailPending =new Amr_Job_Details__c(Job_Status__c='Pending',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName1',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetailPending;
    system.debug('jobDetail!!'+jobDetail);
     listOptions.add(jobDetailPending);
     Amr_Job_Details__c jobDetailDormant =new Amr_Job_Details__c(Job_Status__c='Dormant',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName2',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetailDormant;
    listOptions.add(jobDetailDormant);
    
    Amr_Job_Details__c jobDetailLive =new Amr_Job_Details__c(Job_Status__c='Live',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName3',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetailLive;
    listOptions.add(jobDetailLive);
     Amr_Alert__c alert = new Amr_Alert__c(New_Alert__c=date.newInstance(2015, 11, 21),Alert_Message__c='ABC',Hide__c=true);
    insert alert;
    
    Amr_JobPortfolioController jobPortFolio = new Amr_JobPortfolioController();
    jobPortFolio.loggedInUserId=UserInfo.getUserId();
    
    for(Amr_Job_Details__c job:listOptions){
    
    jobPortFolio.jobDetails = job;
    jobPortFolio.chosenId = job.Id;
    jobPortFolio.chosenAlertId = alert.Id;
    jobPortFolio.selectedSortPriorityOption='AdManagerText__c';
    jobPortFolio.selectedSortPendingOption='AdManagerText__c';
    jobPortFolio.selectedSortDormantOption='AdManagerText__c';
    jobPortFolio.selectedSortLiveOption='AdManagerText__c';
    jobPortFolio.startDate = '10/1/2015';
    jobPortFolio.endDate = '12/30/2015';
    jobPortFolio.projLeaderCluster =jobDetail.Project_Leader_Cluster__c;
    jobPortFolio.brodMarket='testMarket';
    
    jobPortFolio.projLeaderCountry='testCountry';
    jobPortFolio.agencyName='testAgency';
    jobPortFolio.projName ='testProj';
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
    jobPortFolio.hideAlert();
    jobPortFolio.unHideAlertShow();
    jobPortFolio.unHideAlertHide();
    jobPortFolio.showUnhideRecords=false;
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
    //jobPortFolio.previousForPriorityJobs();
    //jobPortFolio.lastForPriorityJobs();
    jobPortFolio.getDisableNextForPriorityJobs();
    jobPortFolio.getDisablePreviousForPriorityJobs();
    jobPortFolio.beginningForPendingJobs();
    jobPortFolio.nextForPendingJobs();
   // jobPortFolio.previousForPendingJobs();
   // jobPortFolio.lastForPendingJobs();
    jobPortFolio.getDisableNextForPendingJobs();
    jobPortFolio.getDisablePreviousForPendingJobs();
    jobPortFolio.beginningForDormantJobs();
    jobPortFolio.nextForDormantJobs();
    //jobPortFolio.previousForDormantJobs();
    //jobPortFolio.lastForDormantJobs();
    jobPortFolio.getDisableNextForDormantJobs();
    jobPortFolio.getDisablePreviousForDormantJobs();
    jobPortFolio.beginningForLiveJobs();
    jobPortFolio.nextForLiveJobs();
    //jobPortFolio.previousForLiveJobs();
    //jobPortFolio.lastForLiveJobs();
    jobPortFolio.getDisableNextForLiveJobs();
    jobPortFolio.getDisablePreviousForLiveJobs();
    } 
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
   	Amr_Category__c category1 = new Amr_Category__c(Name='testCat');
    insert category1;
    Amr_Brand_Positioning__c brandPos = new Amr_Brand_Positioning__c(Category__c=category1.id,Name='testBrandPos');
    insert brandpos;
    Amr_Brand__c brand = new Amr_Brand__c(Brand_Positioning__c=brandPos.Id,Name='testBrand');
    insert brand;
   	Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetail;
    Amr_Job_Details__c jobDetailPending =new Amr_Job_Details__c(Job_Status__c='Pending',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName1',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
    insert jobDetailPending;
    
   	Amr_JobPortfolioController jobPortFolio = new Amr_JobPortfolioController();
   	List<Amr_Job_Details__c> jobList = new List<Amr_Job_Details__c>();
   	List<Amr_Job_Details__c> jobList1 = new List<Amr_Job_Details__c>();
   	jobList1.add(jobDetail);
   	jobList1.add(jobDetailPending);
   	
   	jobPortFolio.liveJobsToShow=jobList;
   	jobPortFolio.liveJobList=jobList1;
   	jobPortFolio.counterForLiveJobs=1;
   	jobPortFolio.limitSizeForLiveJobs=1;
   	jobPortFolio.totalSizeForLiveJobs=2;
   	
   	jobPortFolio.dormantJobsToShow=jobList;
   	jobPortFolio.dormantJobList=jobList1;
   	jobPortFolio.counterForDormantJobs=1;
   	jobPortFolio.limitSizeForDormantJobs=1;
   	jobPortFolio.totalSizeForDormantJobs=2;
   	
   	jobPortFolio.pendingJobsToShow=jobList;
   	jobPortFolio.pendingJobList=jobList1;
   	jobPortFolio.counterForPendingJobs=1;
   	jobPortFolio.limitSizeForPendingJobs=1;
   	jobPortFolio.totalSizeForPendingJobs=2;
   	
   	jobPortFolio.priorityJobsToShow=jobList;
   	jobPortFolio.priorityJobList=jobList1;
   	jobPortFolio.counterForPriorityJobs=1;
   	jobPortFolio.limitSizeForPriorityJobs=1;
   	jobPortFolio.totalSizeForPriorityJobs=2;
   	
   	jobPortFolio.lastForLiveJobs();
   	jobPortFolio.lastForPendingJobs();
   	jobPortFolio.lastForPriorityJobs();
   	jobPortFolio.lastForDormantJobs();
   	jobPortFolio.previousForDormantJobs();
   	jobPortFolio.previousForLiveJobs();
   	jobPortFolio.previousForPendingJobs();
   	jobPortFolio.previousForPriorityJobs();
   	
   	system.assert(jobDetail!= null);
   }

}