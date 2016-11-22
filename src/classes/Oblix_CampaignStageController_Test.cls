@isTest
private class Oblix_CampaignStageController_Test {

    @testSetup static void initCommonData() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {  
            insert Oblix_TestUtils.createOblixCustomSettings();
            insert Oblix_TestUtils.createBoxRangeCalculatorRecords();
            insert Oblix_TestUtils.createCountryCalculatorRecords();
            // Code added by suresh
        Oblix_Check_For_Manual_Edit_Of_Campaign__c me = new Oblix_Check_For_Manual_Edit_Of_Campaign__c(Manual_Edit_Check__c = false);
        insert me;
         
        }
    }

    @isTest static void Oblix_CampaignStageController_TestToggleProjectedStage(){
        //User u = Oblix_TestUtils.createTestUser();
         Profile profile = [Select Id from Profile where Name='System Administrator'];       
         User user = new User(Alias = 'test123', Email = 'standarduser2@unilever.com', 
         EmailEncodingKey = 'UTF-8', LastName = 'af test', LanguageLocaleKey = 'EN_US', 
         LocaleSidKey = 'EN_US', ProfileId = profile.Id,firstname = 'sf test one', 
         TimeZoneSidKey = 'Europe/London',AF_Agency_Fees_User_Type__c = 'Category Finance',isActive = true, 
         UserName = 'testuseradmin2@test123321.com');
         insert user; 
        System.runAs(user) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);
            project.Projected_Stage_CFY__c = 'Briefing;Production';
            project.Completed_Stage_CFY__c = 'Briefing';
            update project;

            Oblix_CampaignStageLogic ctrl = new Oblix_CampaignStageLogic(project.id, true, true);
            Oblix_CampaignStageController componentController = new Oblix_CampaignStageController();
            componentController.b_auto_save = true;
            System.assertEquals(1, componentController.display_mode); //Test that display mode defaults to 1
            componentController.display_mode = 2;
            System.assertEquals(2, componentController.display_mode);
            componentController.stage_identifier = ctrl;


            Test.startTest();

            //Select Stage 4
            componentController.s_projection_stage = 'Creative Execution';
            componentController.setProjectedStageIdentifier();
            
            System.assertEquals(true, ctrl.projected_stages.get(4).selected);
            System.assertEquals(true, ctrl.completed_stages.get(4).selectable);
            System.assertEquals(false, ctrl.completed_stages.get(4).selected);


            Test.stopTest();
            
        }
    }



    @isTest static void Oblix_CampaignStageController_TestToggleCompletedStage(){
        //User u = Oblix_TestUtils.createQA1User();
         Profile profile = [Select Id from Profile where Name='System Administrator'];       
         User user = new User(Alias = 'test123', Email = 'standarduser1@unilever.com', 
         EmailEncodingKey = 'UTF-8', LastName = 'af test', LanguageLocaleKey = 'EN_US', 
         LocaleSidKey = 'EN_US', ProfileId = profile.Id,firstname = 'sf test one', 
         TimeZoneSidKey = 'Europe/London',AF_Agency_Fees_User_Type__c = 'Category Finance',isActive = true, 
         UserName = 'testuseradmin1@test123321.com');
         insert user; 
        System.runAs(user) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);
            project.Projected_Stage_CFY__c = 'Briefing;Production';
            project.Completed_Stage_CFY__c = 'Briefing';
            update project;

            Oblix_CampaignStageLogic ctrl = new Oblix_CampaignStageLogic(project.id, true, true);
            Oblix_CampaignStageController componentController = new Oblix_CampaignStageController();
            componentController.b_auto_save = true;
            componentController.display_mode = 2;
            componentController.stage_identifier = ctrl;


            Test.startTest();

            //Select Stage 5
            componentController.s_completion_stage = 'Production';
            componentController.setCompletionStageIdentifier();
            
            System.assertEquals(true, ctrl.completed_stages.get(5).selected);

            Test.stopTest();
            
        }
    }

}