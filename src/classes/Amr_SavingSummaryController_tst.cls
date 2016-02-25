@isTest
public Class Amr_SavingSummaryController_tst{

    
    
        static testMethod void methodToGetSortOption(){
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='AMR']; 
        User u = new User(Alias = 'sumSav', Email= 'saving@gml.com', 
        EmailEncodingKey='UTF-8', LastName='Testing21', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName= 'savind@Xvr.com');
        insert u;
        
         Amr_Project_Details__c projDetail = new Amr_Project_Details__c(Name = 'Test Project');
        insert projDetail;
        
        Amr_CurrencyConversionRate__c currencyConversion = new Amr_CurrencyConversionRate__c(Name='testName',Currency_Unit__c='testUnit',Currency_Unit_To_Euro__c=1234);
        insert currencyConversion;
        MDO_Category__c category1 = new MDO_Category__c(Name='testCat');
        insert category1;
        MDO_BrandPosition__c brandPos = new MDO_BrandPosition__c(Name='testBrandPos');
       insert brandpos;
       MDO_Brand__c brand = new MDO_Brand__c(Name='testBrand');
        insert brand;
        
        MDO_BrandPositions__c brandPosJunction = new MDO_BrandPositions__c(product_category_id__c=category1.id,brand_position_id__c =brandPos.Id,brand_id__c = brand.id);
        insert brandPosJunction;
       Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(Project_Details__c= projDetail.Id,Job_Cancelled__c = False, Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc1@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',
                                        Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='no',Job_Accepted__c='yes',Your_Email_Address__c='abc2@gmail.com',Unilever_Finance_Member_Email__c='abc3@gmail.com',
                                        Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc4@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc6@gmail.com',Any_other_agencies_involved__c='no',
                                        Brodcast_Market__c='broadMarket', ProductCategory__c= category1.Id,Brand_Position__c=brandPos.Id,Brand_Final__c=brand.Id,ownerId=u.Id );
      
      
        insert jobDetail;
        
       
       Amr_Saving__c savingObj;
       
       
        
        List<Amr_Saving__c> saving = new List<Amr_Saving__c>();
        for(Integer i = 0; i<=7; i++){
            savingObj = new Amr_Saving__c();
            savingObj.Name = 'Test Saving' + i;
            savingObj.Job_Details__c = jobDetail.id;
            saving.add(savingObj);
        }
            insert saving;
         
        Amr_Saving__c savObj = new Amr_Saving__c();
        savObj.Name = 'Ex Test Saving';
        savObj.Job_Details__c = jobDetail.id;
        savObj.Production_Type__c = 'Tv';
        savObj.No_of_Masters__c = 2;
        savObj.Duration_of_Masters__c = 3;
        savObj.No_of_Additional_Films__c = 2;
        savObj.Duration_of_Additional_Films__c = 1;
        savObj.No_of_shoot_days__c = 5;
        savObj.Stage_RAP_engaged__c = 'Before briefing the agency';
        savObj.Script_Title__c = 'Test Script';
        savObj.Scope_re_brief__c = 'no';
        savObj.Folder_Name__c = 'Brief';
        savObj.Shoot_Location_Multiselect__c = 'None';
        insert savObj;
        
        Amr_Quote__c quoteObj = new Amr_Quote__c(Name = 'testQuote');
        quoteObj.Name = 'Test Obj';
        quoteObj.Saving__c = savObj.id;
        insert quoteObj;
            
        Test.stopTest(); 
        
        PageReference pageRef = Page.Amr_NewSaving;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',jobDetail.id); 
         
         Amr_NewSavingController savingSummaryObj = new Amr_NewSavingController();   
         Amr_NewSavingController.InnerSavingClass innerObj  = new Amr_NewSavingController.InnerSavingClass(1, true, quoteObj);

       
        DateTime startDate =DateTime.now();
        DateTime endDate = startDate.addMonths(1);
        String stringDate = String.valueOf(startDate.formatGMT('yyyy/MM/dd hh:mm:ss') );
        String endDateString = String.valueOf(endDate.formatGMT('yyyy/MM/dd hh:mm:ss') );
      
       List<Amr_NewSavingController.InnerSavingClass> innerObjList= new  List<Amr_NewSavingController.InnerSavingClass>();
       innerObjList.add(innerObj); 
       String listConv = JSON.serialize(Amr_CurrencyConversionRate__c.getAll().values());
       List<String> selectedCountry = new List<String>();
       selectedCountry.add('Burundi');
       Blob bodyData = Blob.valueOf('Test data');
       
       Document doc = new Document();
       doc.body = bodyData;
      
       List<String> selectedProdType = new List<String>();
       selectedProdType.add('After Completion');
       
       
       
       
     /*  
       Test.setCurrentPageReference(new PageReference('Page.Amr_NewSaving')); 
       System.currentPageReference().getParameters().put('id', jobDetail.id); */
        
       savingSummaryObj.jobId = jobDetail.id;
       savingSummaryObj.savingObj = savObj;
       savingSummaryObj.docAndQuoteLst = innerObjList;
       savingSummaryObj.lstcov = listConv;
       savingSummaryObj.adManagerNumber = 'Ego/00018';
       savingSummaryObj.selectedCountry = selectedCountry;
       savingSummaryObj.document = doc;
       savingSummaryObj.jobDetailObj = jobDetail;
       savingSummaryObj.selectedProductionType = selectedProdType;
       savingSummaryObj.QuoteNumber = 1;
       savingSummaryObj.pcTimeMangCategoryValue =3;
       savingSummaryObj.pcCostMangCategoryValue  = 3;
       savingSummaryObj.pcProcessMangCategoryValue  = 4;
       savingSummaryObj.pcOutputQualityCategoryValue =1;
       savingSummaryObj.pccTimeMangCategoryValue =2;
       savingSummaryObj.pccCostMangCategoryValue  = 5;
       savingSummaryObj.pccProcessMangCategoryValue =2;
       savingSummaryObj.pccOutputQualityCategoryValue =3;
       savingSummaryObj.caTimeMangCategoryValue = 1;       
       savingSummaryObj.caCostMangCategoryValue = 5;       
       savingSummaryObj.caProcessMangCategoryValue = 3;    
       savingSummaryObj.caOutputQualityCategoryValue = 4;     
       
       // Methods Calling 
       
       savingSummaryObj.addRowQuote();
       savingSummaryObj.SaveAllData(); 
       savingSummaryObj.SaveSaving(); 
       savingSummaryObj.uploadQuoteDocument(quoteObj, doc);
       savingSummaryObj.UpdateAcceptedQuote();
       savingSummaryObj.uploadDocument(savObj);
       savingSummaryObj.AllValues();
    /*    
      //  savingSummaryObj.userId = userinfo.getuserid();
      //  savingSummaryObj.summaryJobsToShow =  new List<Amr_Saving__c>();
        savingSummaryObj.summaryJobsToShow= saving;
        savingSummaryObj.counterForSummaryJobs = 0;
        savingSummaryObj.limitSizeForSummaryJobs=Integer.valueOf(System.Label.Amr_LimitValue);
        savingSummaryObj.totalSizeForSummaryJobs = saving.size();
        savingSummaryObj.startDate = stringDate;
        savingSummaryObj.endDate = endDateString;
        savingSummaryObj.chosenId = jobDetail.id;
        savingSummaryObj.savingObject = savObj;
        savingSummaryObj.films = '23';
        
        savingSummaryObj.getSortOptions();
        savingSummaryObj.getDashboardDataForRAP();
        savingSummaryObj.getDashboardDataForCAP();
        
        savingSummaryObj.savingSummaryList = saving;
      
        savingSummaryObj.beginningForSummaryJobs();
        savingSummaryObj.nextForSummaryJobs();
        savingSummaryObj.previousForSummaryJobs();
        savingSummaryObj.lastForSummaryJobs();
        savingSummaryObj.paginationMethodForSummaryJobs(saving);
        savingSummaryObj.getJobSearchDetails();
        savingSummaryObj.getDisableNextForSummaryJobs();
        savingSummaryObj.getDisablePreviousForSummaryJobs();
        savingSummaryObj.jobSheetPageTransfer(); */
       system.assert(quoteObj !=null); 
        
    }

}