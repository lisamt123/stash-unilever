//S.M. 2016-03-12 - THIS CLASS IS NO LONGER USED!! 
    //Replaced by Oblix_CalculatorLogic as part of code refactoring

@isTest 
private class Oblix_TR04ProjectBusDriverScore_Test {

   //static testMethod void myUnitTest() {
   //     // TO DO: implement unit test
   //     Profile p=[Select Id from Profile where Name='System Administrator' or Name='Système Administrateur'];       
     
   //      //Insert User 
   //      User u= new User(Alias = 'test123', Email='standarduser@unilever.com', 
   //       EmailEncodingKey='UTF-8', LastName='af test', LanguageLocaleKey='en_US', 
   //       LocaleSidKey='en_US', ProfileId = p.Id,firstname='sf test one', 
   //       TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
   //       UserName='testuser@test123321.com');//,AF_Brand__c='Test Brand1',AF_Category__c='Test Beverages1'
   //      insert u; 
          
   //      System.runAs(u){
   //         Oblix_Calculator__c calculatorRange = new Oblix_Calculator__c();
   //             calculatorRange.RecordTypeId = Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Box_Range');
   //             calculatorRange.Name = 'Box Range #1';
   //             calculatorRange.Points_HigH__c = 5;
   //             calculatorRange.Points_Low__c = 1;
   //             calculatorRange.Box_Range__c = 'Box 2';
   //             insert calculatorRange;
            
   //         Oblix_Calculator__c calculatorCountry = new Oblix_Calculator__c();  
   //             calculatorCountry.Name = 'France';
   //             calculatorCountry.Box_2__c = 150;
   //             calculatorCountry.RecordTypeId = Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Country_Box_Number');
   //             insert calculatorCountry;
                
   //         Marketing_SOW__c marketingSow = new Marketing_SOW__c();
   //             marketingSow.Active__c = true;
   //             marketingSow.Name = 'Marketinf Sow Approval Test';
   //             marketingSow.SOW_Status__c = 'Open';
   //             insert marketingSow;
            
   //         MDO_Geography__c geography = new MDO_Geography__c();
   //             geography.Name = 'France';
   //             geography.geography_type__c = 'Country Cluste';
   //             insert geography;
                
            
            
   //         Oblix_SOW_Projects__c project = new Oblix_SOW_Projects__c();
   //             project.Name = 'Project #2';
   //             project.Campaign_Countries__c = 'France';
   //             project.Financial_Year__c = marketingSow.Id;
   //             project.Innovation_Projects__c = Oblix_Constants.Innovation_Projects_Innovation;
   //             project.Brand_Led_Growth__c    = Oblix_Constants.BrandLedGrowth_IncremTurnoverLess10;
   //             project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market1;
   //             project.Project_Scale_2__c = Oblix_Constants.Innovation_Projects_HubsPartners1;
   //             project.Campaign_Idea__c = Oblix_Constants.Innovation_Projects_Existing;
   //             project.ProjectTotalAssetScore__c = 100;                
   //             insert project;     
   //             Oblix_SOW_Projects__c projectView = [Select Id, Name, Oblix_ProjectBoxNumber__c, Total_Fees_for_Project__c from Oblix_SOW_Projects__c where Id=:project.Id];
   //             System.assertequals(projectView.Oblix_ProjectBoxNumber__c, calculatorRange.Box_Range__c);
   //             System.assertequals(calculatorCountry.Box_2__c, (Decimal)calculatorCountry.get((projectView.Oblix_ProjectBoxNumber__c).replace(' ','_')+'__c'));
                
   //             Oblix_Marketing_SOW_Project_Splits__c projectSplit = new Oblix_Marketing_SOW_Project_Splits__c();
               
   //             projectSplit.Project_Splits__c = project.Id;
   //             projectSplit.Percentage__c = 50;
   //             projectSplit.OblixCountry__c = geography.Id;
   //             insert projectSplit;
                
   //             Test.startTest();
   //             project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market2;
   //             project.Innovation_Projects__c = Oblix_Constants.Innovation_Projects_BrandLedGrowth;
   //             project.Brand_Led_Growth__c    = Oblix_Constants.BrandLedGrowth_IncremTurnoverLess2030;
   //             project.Project_Scale_2__c = Oblix_Constants.Innovation_Projects_HubsPartners2;
   //             project.Campaign_Idea__c = Oblix_Constants.Innovation_Projects_NewMulti;
   //             update project;
                
   //             project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market3;
   //             project.Innovation_Projects__c = Oblix_Constants.Innovation_Projects_Innovation;
   //             project.Brand_Led_Growth__c    = Oblix_Constants.BrandLedGrowth_IncremTurnover1020;
   //             project.Project_Scale_2__c = Oblix_Constants.Innovation_Projects_HubsPartners3;
   //             project.Campaign_Idea__c = Oblix_Constants.Innovation_Projects_NewOne;
   //             update project;
                
   //             project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market4;
   //             project.Innovation_Projects__c = Oblix_Constants.Innovation_Projects_Innovation;
   //             project.Brand_Led_Growth__c    = Oblix_Constants.BrandLedGrowth_IncremTurnover200_300;
   //             project.Project_Scale_2__c = Oblix_Constants.Innovation_Projects_HubsPartners4;
   //             project.Campaign_Idea__c = Oblix_Constants.Innovation_Projects_NewOne;
   //             update project;
                
   //             project.Project_Scale_1__c = Oblix_Constants.Innovation_Projects_Market5;
   //             project.Innovation_Projects__c = Oblix_Constants.Innovation_Projects_Innovation;
   //             project.Brand_Led_Growth__c    = Oblix_Constants.BrandLedGrowth_IncremTurnoverLess3040;
   //             project.Project_Scale_2__c = Oblix_Constants.Innovation_Projects_HubsPartners5;
   //             update project;
                
   //             project.Innovation_Projects__c = Oblix_Constants.Innovation_Projects_Innovation;
   //             project.Brand_Led_Growth__c    = Oblix_Constants.BrandLedGrowth_IncremTurnoverLessAbove40;
   //             update project;
                
   //             project.Innovation_Projects__c = Oblix_Constants.Innovation_Projects_Innovation;
   //             project.Brand_Led_Growth__c    = Oblix_Constants.BrandLedGrowth_IncremTurnoverLess2030;
   //             update project;
                
   //             project.Innovation_Projects__c = Oblix_Constants.Innovation_Projects_BrandLedGrowth;
   //             project.Brand_Led_Growth__c    = Oblix_Constants.BrandLedGrowth_Less100;
   //             update project;
                
   //             project.Innovation_Projects__c = Oblix_Constants.Innovation_Projects_BrandLedGrowth;
   //             project.Brand_Led_Growth__c    = Oblix_Constants.BrandLedGrowth_100_200;
   //             update project;
                
   //             project.Innovation_Projects__c = Oblix_Constants.Innovation_Projects_BrandLedGrowth;
   //             project.Brand_Led_Growth__c    = Oblix_Constants.BrandLedGrowth_IncremTurnover200_300;
   //             update project;
                
   //             project.Innovation_Projects__c = Oblix_Constants.Innovation_Projects_BrandLedGrowth;
   //             project.Brand_Led_Growth__c    = Oblix_Constants.BrandLedGrowth_IncremTurnoverLess300_400;
   //             update project;
                
   //             project.Innovation_Projects__c = Oblix_Constants.Innovation_Projects_BrandLedGrowth;
   //             project.Brand_Led_Growth__c    = Oblix_Constants.BrandLedGrowth_IncremTurnoverLessAbove400;
   //             update project;
               
   //            Test.stopTest(); 
   //      }
   // }
    
   
}