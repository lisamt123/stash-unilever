@isTest
public Class Amr_SavingSummaryController_Test{

        static testMethod void methodToGetSortOption(){
        
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
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
        
         Amr_Trigger_Pattern__c customSetting = new Amr_Trigger_Pattern__c(Check_Run__c = true,name = 'Amr_Report');
        insert customSetting;
        
       Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(Project_Details__c= projDetail.Id,Job_Cancelled__c = False, Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc1@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',
                                        Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c=Amr_ConstantForAdManager.YES,Job_Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c='no',Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c='abc2@gmail.com',Unilever_Finance_Member_Email__c='abc3@gmail.com',
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
         Amr_SavingSummaryController_CC obj1 = new Amr_SavingSummaryController_CC();  
        
       obj1.savingObject.Name = 'Ex Test Saving';
       obj1.savingObject.Job_Details__c = jobDetail.id;
       obj1.savingObject.Production_Type__c = 'Tv';
       obj1.savingObject.No_of_Masters__c = 2;
       obj1.savingObject.Duration_of_Masters__c = '3';
       obj1.savingObject.No_of_Additional_Films__c = 2;
       obj1.savingObject.Duration_of_Additional_Films__c = '1';
       obj1.savingObject.No_of_shoot_days__c = 5;
       obj1.savingObject.Stage_RAP_engaged__c = 'Before briefing the agency';
       obj1.savingObject.Script_Title__c = 'Test Script';
       obj1.savingObject.Scope_re_brief__c = 'no';
       obj1.savingObject.Folder_Name__c = 'Brief';
       obj1.savingObject.Shoot_Location_Multiselect__c = 'None';
        insert obj1.savingObject;
        
        Amr_Quote__c quoteObj = new Amr_Quote__c(Name = 'testQuote');
        quoteObj.Name = 'Testobj1';
        quoteObj.Saving__c =obj1.savingObject.id;
        insert quoteObj;
            
       Amr_SavingSummaryController_CC obj2 = new Amr_SavingSummaryController_CC();  
        PageReference pageRef = Page.Amr_SavingSummary;
        Test.setCurrentPage(pageRef);
        obj2.savingObject = obj1.savingObject;
          
       obj2.savingObject.Name = 'Ex Test Saving';
       //obj2.savingObject.Job_Details__c = jobDetail.id;
       obj2.savingObject.Production_Type__c = 'Tv';
       obj2.savingObject.No_of_Masters__c = 2;
       obj2.savingObject.Duration_of_Masters__c = '3';
       obj2.savingObject.No_of_Additional_Films__c = 2;
       obj2.savingObject.Duration_of_Additional_Films__c = '1';
       obj2.savingObject.No_of_shoot_days__c = 5;
       obj2.savingObject.Stage_RAP_engaged__c = 'Before briefing the agency';
       obj2.savingObject.Script_Title__c = 'Test Script';
       obj2.savingObject.Scope_re_brief__c = 'no';
       obj2.savingObject.Folder_Name__c = 'Brief';
       obj2.savingObject.Shoot_Location_Multiselect__c = 'None';
       obj2.totalAcceptedFinalCost = '12';
       obj2.savingAverageOfQuotes = '12';
       obj2.savingAcceptedQuotes = '12';
        obj2.getCategoryList();
        obj2.getJobSearchDetails();
                obj2.brandPositionListData();
                  obj2.jobDetailObj = jobDetail;
        obj2.jobDetailObj.AdManagerText__c = '12';
         obj2.categoryName = 'testCat';
          obj2.brandPosName = 'testBrandPos';
           obj2.brandNameFromPage = 'testBrand';
           obj2.selectedCountry = new List<String>{'test','test1'};
                   obj2.getBrandList();
            obj2.startdate = '12/1/2016';   
            obj2.endDate = '12/1/2016';             
      
           obj2.getJobSearchDetails();
        obj2.getSortOptions();
        obj2.getPieDataRAP();
         obj2.getpieSavingDataRaps();
        //obj2.beginningForSummaryJobs();
         obj2.nextForSummaryJobs();
          //obj2.previousForSummaryJobs();
           //obj2.beginningForSummaryJobs();
              //obj2.lastForSummaryJobs();
              obj2.getDisablePreviousForSummaryJobs();
              obj2.getDisableNextForSummaryJobs();
              obj2.jobSheetPageTransfer();
        
        Test.stopTest(); 
        
      
      
       system.assert(quoteObj !=null); 
        
    }
    
    
     static testMethod void checkPermissionSet()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
       
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',     UserName='testpermissionsetuser@testorg.com');
        insert u;
       
        // Query your permission set name from Organization that your want to test.
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'RAP'];
       
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;
       
        // Run your code with inserted user.
        System.runAs(u)
        {
             Test.startTest();
             
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
        
         Amr_Trigger_Pattern__c customSetting = new Amr_Trigger_Pattern__c(Check_Run__c = true,name = 'Amr_Report');
        insert customSetting;
        
       Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(Project_Details__c= projDetail.Id,Job_Cancelled__c = False, Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc1@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',
                                        Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c=Amr_ConstantForAdManager.YES,Job_Reported__c=Amr_ConstantForAdManager.YES,Job_Shared__c='no',Job_Accepted__c=Amr_ConstantForAdManager.YES,Your_Email_Address__c='abc2@gmail.com',Unilever_Finance_Member_Email__c='abc3@gmail.com',
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
         Amr_SavingSummaryController_CC obj1 = new Amr_SavingSummaryController_CC();  
        
       obj1.savingObject.Name = 'Ex Test Saving';
       obj1.savingObject.Job_Details__c = jobDetail.id;
       obj1.savingObject.Production_Type__c = 'Tv';
       obj1.savingObject.No_of_Masters__c = 2;
       obj1.savingObject.Duration_of_Masters__c = '3';
       obj1.savingObject.No_of_Additional_Films__c = 2;
       obj1.savingObject.Duration_of_Additional_Films__c = '1';
       obj1.savingObject.No_of_shoot_days__c = 5;
       obj1.savingObject.Stage_RAP_engaged__c = 'Before briefing the agency';
       obj1.savingObject.Script_Title__c = 'Test Script';
       obj1.savingObject.Scope_re_brief__c = 'no';
       obj1.savingObject.Folder_Name__c = 'Brief';
       obj1.savingObject.Shoot_Location_Multiselect__c = 'None';
        insert obj1.savingObject;
        
        Amr_Quote__c quoteObj = new Amr_Quote__c(Name = 'testQuote');
        quoteObj.Name = 'Testobj1';
        quoteObj.Saving__c =obj1.savingObject.id;
        insert quoteObj;
            
       Amr_SavingSummaryController_CC obj2 = new Amr_SavingSummaryController_CC();  
        PageReference pageRef = Page.Amr_SavingSummary;
        Test.setCurrentPage(pageRef);
        obj2.savingObject = obj1.savingObject;
          
       obj2.savingObject.Name = 'Ex Test Saving';
       //obj2.savingObject.Job_Details__c = jobDetail.id;
       obj2.savingObject.Production_Type__c = 'Tv';
       obj2.savingObject.No_of_Masters__c = 2;
       obj2.savingObject.Duration_of_Masters__c = '3';
       obj2.savingObject.No_of_Additional_Films__c = 2;
       obj2.savingObject.Duration_of_Additional_Films__c = '1';
       obj2.savingObject.No_of_shoot_days__c = 5;
       obj2.savingObject.Stage_RAP_engaged__c = 'Before briefing the agency';
       obj2.savingObject.Script_Title__c = 'Test Script';
       obj2.savingObject.Scope_re_brief__c = 'no';
       obj2.savingObject.Folder_Name__c = 'Brief';
       obj2.savingObject.Shoot_Location_Multiselect__c = 'None';
       obj2.totalAcceptedFinalCost = '12';
       obj2.savingAverageOfQuotes = '12';
       obj2.savingAcceptedQuotes = '12';
       obj2.getCategoryList();
       obj2.getJobSearchDetails();
       obj2.brandPositionListData();
       obj2.jobDetailObj = jobDetail;
       obj2.jobDetailObj.AdManagerText__c = '12';
       obj2.categoryName = 'testCat';
       obj2.brandPosName = 'testBrandPos';
       obj2.brandNameFromPage = 'testBrand';
       obj2.selectedCountry = new List<String>{'test','test1'};
       obj2.getBrandList();
       obj2.startdate = '12/1/2016';   
       obj2.endDate = '12/1/2016'; 
       obj2.jobDetailObj.Budget_Responsibility__c='BB';
       obj2.selectedRapName   =u.Id;
       obj2.films='78';         
       obj2.getJobSearchDetails();
       obj2.getSortOptions();
       obj2.getPieDataRAP();
       obj2.getpieSavingDataRaps();
        //obj2.beginningForSummaryJobs();
         obj2.nextForSummaryJobs();
          //obj2.previousForSummaryJobs();
           //obj2.beginningForSummaryJobs();
              //obj2.lastForSummaryJobs();
              obj2.getDisablePreviousForSummaryJobs();
              obj2.getDisableNextForSummaryJobs();
              obj2.jobSheetPageTransfer();
              obj2.clearJob();
             Test.stopTest(); 
              system.assert(quoteObj !=null); 
        }
    }   
}