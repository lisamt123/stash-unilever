@isTest
private class Oblix_CampaignStageLogic_Test {

    private static final String PROJECT_NAME = 'Project';
    private static final String BRIEFING_AND_PRODUCTION = 'Briefing;Production';
    private static final String BRIEFING = 'Briefing';

    @testSetup static void initCommonData() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {  
            insert Oblix_TestUtils.createOblixCustomSettings();
            insert Oblix_TestUtils.createBoxRangeCalculatorRecords();
            insert Oblix_TestUtils.createCountryCalculatorRecords();
        }
    }


    @isTest static void Oblix_CampaignStageLogic_TestNewCampaignController(){
        User u = Oblix_TestUtils.createQA1User();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Test.startTest();

            Oblix_CampaignStageLogic ctrl = new Oblix_CampaignStageLogic(mSow.id);

            Test.stopTest();

            for (Integer i = 1; i < 6; i++) {
                System.assertEquals(true, ctrl.projected_stages.get(i).selectable);
                System.assertEquals(true, ctrl.projected_stages.get(i).selected);
                System.assertEquals(true, ctrl.completed_stages.get(i).selectable);
                System.assertEquals(false, ctrl.completed_stages.get(i).selected);
            }
            
        }
    }


    @isTest static void Oblix_CampaignStageLogic_TestPercentOverrideController(){
        User u = Oblix_TestUtils.createQA1User();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_NAME, mSow.id);
            project.Stage_Projected_CFY__c = BRIEFING_AND_PRODUCTION;
            project.Stage_Completed_CFY__c = BRIEFING;
            update project;

            Test.startTest();

            Oblix_CampaignStageLogic ctrl = new Oblix_CampaignStageLogic(project, 66, true, true);

            Test.stopTest();

            System.assertEquals(66, ctrl.i_percentage_of_fee_this_year);
            
        }
    }



    @isTest static void Oblix_CampaignStageLogic_TestInitStages(){
        User u = Oblix_TestUtils.createQA1User();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_NAME, mSow.id);
            project.Stage_Projected_CFY__c = BRIEFING_AND_PRODUCTION;
            project.Stage_Completed_CFY__c = BRIEFING;
            update project;

            Test.startTest();

            Oblix_CampaignStageLogic ctrl = new Oblix_CampaignStageLogic(project.id, true, true);

            Test.stopTest();

            //Test: all projected stages are selectable
            for (Integer i = 1; i < 6; i++) {
                System.assertEquals(true, ctrl.projected_stages.get(i).selectable);
            }

            //Test: only some comepleted stages are selectable
            System.assertEquals(true, ctrl.completed_stages.get(1).selectable); //TRUE
            System.assertEquals(false, ctrl.completed_stages.get(2).selectable);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(3).selectable);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(4).selectable);//FALSE
            System.assertEquals(true, ctrl.completed_stages.get(5).selectable); //TRUE

            //Test: only some projected stages are selected
            System.assertEquals(true, ctrl.projected_stages.get(1).selected); //TRUE
            System.assertEquals(false, ctrl.projected_stages.get(2).selected);//FALSE
            System.assertEquals(false, ctrl.projected_stages.get(3).selected);//FALSE
            System.assertEquals(false, ctrl.projected_stages.get(4).selected);//FALSE
            System.assertEquals(true, ctrl.projected_stages.get(5).selected); //TRUE

            //Test: only some completed stages are selected
            System.assertEquals(true, ctrl.completed_stages.get(1).selected); //TRUE
            System.assertEquals(false, ctrl.completed_stages.get(2).selected);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(3).selected);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(4).selected);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(5).selected);//FALSE
            
        }
    }



    @isTest static void Oblix_CampaignStageLogic_TestInitStages_ProjectedNotSelectabe(){
        User u = Oblix_TestUtils.createQA1User();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_NAME, mSow.id);
            project.Stage_Projected_CFY__c = BRIEFING_AND_PRODUCTION;
            project.Stage_Completed_CFY__c = BRIEFING;
            update project;

            Test.startTest();

            /***
            *
            *   Passing FALSE parameter to Oblix_CampaignStageLogic controller to ensure that all projected stages are disabled (not clickable)
            *   but user can still change completed stages
            *
            */
            Oblix_CampaignStageLogic ctrl = new Oblix_CampaignStageLogic(project.id, false, true);

            Test.stopTest();

            //Test: all projected stages are selectable
            for (Integer i = 1; i < 6; i++) {
                System.assertEquals(false, ctrl.projected_stages.get(i).selectable);
            }

            //Test: only some comepleted stages are selectable
            System.assertEquals(true, ctrl.completed_stages.get(1).selectable); //TRUE
            System.assertEquals(false, ctrl.completed_stages.get(2).selectable);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(3).selectable);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(4).selectable);//FALSE
            System.assertEquals(true, ctrl.completed_stages.get(5).selectable); //TRUE

            //Test: only some projected stages are selected
            System.assertEquals(true, ctrl.projected_stages.get(1).selected); //TRUE
            System.assertEquals(false, ctrl.projected_stages.get(2).selected);//FALSE
            System.assertEquals(false, ctrl.projected_stages.get(3).selected);//FALSE
            System.assertEquals(false, ctrl.projected_stages.get(4).selected);//FALSE
            System.assertEquals(true, ctrl.projected_stages.get(5).selected); //TRUE

            //Test: only some completed stages are selected
            System.assertEquals(true, ctrl.completed_stages.get(1).selected); //TRUE
            System.assertEquals(false, ctrl.completed_stages.get(2).selected);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(3).selected);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(4).selected);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(5).selected);//FALSE
            
        }
    }



    @isTest static void Oblix_CampaignStageLogic_TestToggleProjectedStage(){
        User u = Oblix_TestUtils.createQA1User();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_NAME, mSow.id);
            project.Stage_Projected_CFY__c = BRIEFING_AND_PRODUCTION;
            project.Stage_Completed_CFY__c = BRIEFING;
            update project;

            Oblix_CampaignStageLogic ctrl = new Oblix_CampaignStageLogic(project.id, true, true);
            Oblix_CampaignStageController componentController = new Oblix_CampaignStageController();
            componentController.b_auto_save = true;
            componentController.display_mode = 2;
            componentController.stage_identifier = ctrl;

            //Test: all projected stages are selectable
            for (Integer i = 1; i < 6; i++) {
                System.assertEquals(true, ctrl.projected_stages.get(i).selectable);
            }

            //Test: only some comepleted stages are selectable
            System.assertEquals(true, ctrl.completed_stages.get(1).selectable); //TRUE
            System.assertEquals(false, ctrl.completed_stages.get(2).selectable);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(3).selectable);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(4).selectable);//FALSE
            System.assertEquals(true, ctrl.completed_stages.get(5).selectable); //TRUE

            //Test: only some projected stages are selected
            System.assertEquals(true, ctrl.projected_stages.get(1).selected); //TRUE
            System.assertEquals(false, ctrl.projected_stages.get(2).selected);//FALSE
            System.assertEquals(false, ctrl.projected_stages.get(3).selected);//FALSE
            System.assertEquals(false, ctrl.projected_stages.get(4).selected);//FALSE
            System.assertEquals(true, ctrl.projected_stages.get(5).selected); //TRUE

            //Test: only some completed stages are selected
            System.assertEquals(true, ctrl.completed_stages.get(1).selected); //TRUE
            System.assertEquals(false, ctrl.completed_stages.get(2).selected);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(3).selected);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(4).selected);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(5).selected);//FALSE

            Test.startTest();

            //Select Stage 4
            componentController.s_projection_stage = 'Creative Execution';
            componentController.setProjectedStageIdentifier();
            
            System.assertEquals(true, ctrl.projected_stages.get(4).selected);
            System.assertEquals(true, ctrl.completed_stages.get(4).selectable);
            System.assertEquals(false, ctrl.completed_stages.get(4).selected);

            //Deselect Stage 5
            componentController.s_projection_stage = 'Production';
            componentController.setProjectedStageIdentifier();
            
            System.assertEquals(false, ctrl.projected_stages.get(5).selected);
            System.assertEquals(false, ctrl.completed_stages.get(5).selectable);
            System.assertEquals(false, ctrl.completed_stages.get(5).selected);

            Test.stopTest();
            
        }
    }



    @isTest static void Oblix_CampaignStageLogic_TestToggleCompletedStage(){
        User u = Oblix_TestUtils.createQA1User();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_NAME, mSow.id);
            project.Stage_Projected_CFY__c = BRIEFING_AND_PRODUCTION;
            project.Stage_Completed_CFY__c = BRIEFING;
            update project;

            Oblix_CampaignStageLogic ctrl = new Oblix_CampaignStageLogic(project.id, true, true);
            Oblix_CampaignStageController componentController = new Oblix_CampaignStageController();
            componentController.b_auto_save = true;
            componentController.display_mode = 2;
            componentController.stage_identifier = ctrl;

            //Test: all projected stages are selectable
            for (Integer i = 1; i < 6; i++) {
                System.assertEquals(true, ctrl.projected_stages.get(i).selectable);
            }

            //Test: only some comepleted stages are selectable
            System.assertEquals(true, ctrl.completed_stages.get(1).selectable); //TRUE
            System.assertEquals(false, ctrl.completed_stages.get(2).selectable);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(3).selectable);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(4).selectable);//FALSE
            System.assertEquals(true, ctrl.completed_stages.get(5).selectable); //TRUE

            //Test: only some projected stages are selected
            System.assertEquals(true, ctrl.projected_stages.get(1).selected); //TRUE
            System.assertEquals(false, ctrl.projected_stages.get(2).selected);//FALSE
            System.assertEquals(false, ctrl.projected_stages.get(3).selected);//FALSE
            System.assertEquals(false, ctrl.projected_stages.get(4).selected);//FALSE
            System.assertEquals(true, ctrl.projected_stages.get(5).selected); //TRUE

            //Test: only some completed stages are selected
            System.assertEquals(true, ctrl.completed_stages.get(1).selected); //TRUE
            System.assertEquals(false, ctrl.completed_stages.get(2).selected);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(3).selected);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(4).selected);//FALSE
            System.assertEquals(false, ctrl.completed_stages.get(5).selected);//FALSE

            Test.startTest();

            //Select Stage 5
            componentController.s_completion_stage = 'Production';
            componentController.setCompletionStageIdentifier();
            
            System.assertEquals(true, ctrl.completed_stages.get(5).selected);

            //Deselect Stage 1
            componentController.s_completion_stage = BRIEFING;
            componentController.setCompletionStageIdentifier();
            
            System.assertEquals(false, ctrl.completed_stages.get(1).selected);

            Test.stopTest();
            
        }
    }

	
	
}