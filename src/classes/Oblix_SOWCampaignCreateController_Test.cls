@isTest
private class Oblix_SOWCampaignCreateController_Test {

    //private static final String NOT_NULL_MESSAGE = 'Page Reference should not be null';
    private static final String PROJECT_TXT = 'Project';
    private static final String PROJECT_TXT_1 = 'Project1';
    private static final String PROJECTID_TXT = 'projectId';
    private static final String SOWID_TXT = 'sowId';
    private static final String GLOBAL_REGION = 'Global';
    private static final String COUNTRY_TYPE = 'Country';

    @isTest static void SOWCampaignCreateControllerTest_addOneMoreProjectSplitInstance_isSplitInstanceAdded() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);
            ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);
            Oblix_SOWCampaignCreateController campaignCreateController = new Oblix_SOWCampaignCreateController();
            Test.startTest();
                // check there are 5 instances already
                System.assertEquals(campaignCreateController.campaignHelper.numberOfAgencyHubSplits, 5);
                campaignCreateController.addOneMoreProjectSplitInstance();  
                // check to see another instance is added
                System.assertEquals(campaignCreateController.campaignHelper.agencySplitHubs.size(), 6);
            Test.stopTest();
        }
    }  

    @isTest static void SOWCampaignCreateControllerTest_createFiveInstancesOFMarketingSplits_isFiveInstancesOFMarketingSplitsCreated() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
            Oblix_SOWCampaignCreateController campaignCreateController = new Oblix_SOWCampaignCreateController();
            Test.startTest();
                // check there are 5 instances already
                System.assertEquals(campaignCreateController.campaignHelper.agencySplitHubs.size(), 5);
                campaignCreateController.addOneMoreProjectSplitInstance();  
                // check to see another instance is added
                System.assertEquals(campaignCreateController.campaignHelper.agencySplitHubs.size(), 6);
            Test.stopTest();
        }
    }  


    @isTest static void SOWCampaignCreateControllerTest_setInfoCountries_isInfoCountriesSet() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);
            ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);
            Oblix_SOWCampaignCreateController campaignCreateController = new Oblix_SOWCampaignCreateController();
            
            Test.startTest();
                campaignCreateController.campaignHelper.selectedProject.Campaign_Countries__c = Oblix_TestUtils.createCountries(1);
                campaignCreateController.setInfoCountries();
                System.assertEquals(campaignCreateController.campaignHelper.selectedProject.Project_Scale_1__c,Oblix_Constants.Innovation_Projects_Market1);

                campaignCreateController.campaignHelper.selectedProject.Campaign_Countries__c = Oblix_TestUtils.createCountries(4);
                campaignCreateController.setInfoCountries();
                System.assertEquals(campaignCreateController.campaignHelper.selectedProject.Project_Scale_1__c,Oblix_Constants.Innovation_Projects_Market2);

                campaignCreateController.campaignHelper.selectedProject.Campaign_Countries__c = Oblix_TestUtils.createCountries(8);
                campaignCreateController.setInfoCountries();
                System.assertEquals(campaignCreateController.campaignHelper.selectedProject.Project_Scale_1__c,Oblix_Constants.Innovation_Projects_Market3);

                campaignCreateController.campaignHelper.selectedProject.Campaign_Countries__c = Oblix_TestUtils.createCountries(13);
                campaignCreateController.setInfoCountries();
                System.assertEquals(campaignCreateController.campaignHelper.selectedProject.Project_Scale_1__c,Oblix_Constants.Innovation_Projects_Market4);

                campaignCreateController.campaignHelper.selectedProject.Campaign_Countries__c = Oblix_TestUtils.createCountries(20);
                campaignCreateController.setInfoCountries();
                System.assertEquals(campaignCreateController.campaignHelper.selectedProject.Project_Scale_1__c,Oblix_Constants.Innovation_Projects_Market5);

                campaignCreateController.selectedMainRegions = '1region';
                campaignCreateController.campaignHelper.selectedProject.Campaign_Countries__c = '';
                campaignCreateController.setInfoCountries();
                System.assertEquals(campaignCreateController.campaignHelper.selectedProject.Project_Scale_1__c,null);
            Test.stopTest();


            
        }
    } 

    @isTest static void SOWCampaignCreateControllerTest_setCampaignScaleOneSetToGlobal_isCampaignScaleOneSetToGlobal() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);
            ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);
            Oblix_SOWCampaignCreateController campaignCreateController = new Oblix_SOWCampaignCreateController();
            
            Test.startTest();
                campaignCreateController.setCampaignScaleOneGlobal();
                System.assertEquals(campaignCreateController.campaignHelper.selectedProject.Project_Scale_1__c,Oblix_Constants.Innovation_Projects_Market5);
                System.assertEquals(campaignCreateController.campaignHelper.selectedProject.OblixRegion__c,'Global');
                System.assertEquals(campaignCreateController.campaignHelper.selectedProject.Campaign_Countries__c,'Global');
                
            Test.stopTest();      
        }
    } 

    @isTest static void SOWCampaignCreateControllerTest_setCampaignScale_isCampaignScaleSet() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);
            ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);
            Oblix_SOWCampaignCreateController campaignCreateController = new Oblix_SOWCampaignCreateController();
            
            Test.startTest();
                campaignCreateController.campaignHelper.numberOFSelectedCountries = 1;
                campaignCreateController.setCampaignScale();
                System.assertEquals(campaignCreateController.campaignHelper.selectedProject.Project_Scale_2__c,'1 location');

                campaignCreateController.campaignHelper.numberOFSelectedCountries = 2;
                campaignCreateController.setCampaignScale();
                System.assertEquals(campaignCreateController.campaignHelper.selectedProject.Project_Scale_2__c,'Up to 2 locations');

                campaignCreateController.campaignHelper.numberOFSelectedCountries = 3;
                campaignCreateController.setCampaignScale();
                System.assertEquals(campaignCreateController.campaignHelper.selectedProject.Project_Scale_2__c,'Up to 3 locations');

                campaignCreateController.campaignHelper.numberOFSelectedCountries = 4;
                campaignCreateController.setCampaignScale();
                System.assertEquals(campaignCreateController.campaignHelper.selectedProject.Project_Scale_2__c,'Up to 4 locations');

                campaignCreateController.campaignHelper.numberOFSelectedCountries = 5;
                campaignCreateController.setCampaignScale();
                System.assertEquals(campaignCreateController.campaignHelper.selectedProject.Project_Scale_2__c,'Up to 5 locations');

                /*campaignCreateController.campaignHelper.numberOFSelectedCountries = 6;
                campaignCreateController.setCampaignScale();
                System.assertEquals(campaignCreateController.campaignHelper.selectedProject.Project_Scale_2__c,'More than 5 locations');*/
            Test.stopTest();      
        }
    } 

    @isTest static void SOWCampaignCreateControllerTest_setInfoDrivers_isInfoDriversSet() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);
            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);
            Oblix_SOWCampaignCreateController campaignCreateController = new Oblix_SOWCampaignCreateController();
            
            Test.startTest();
                campaignCreateController.campaignHelper.selectedProject.Innovation_Projects__c = Label.Oblix_Lbl_Innovation_Projects_Innovation;
                campaignCreateController.campaignHelper.selectedBrandInnovation = 'test';
                campaignCreateController.setInfoDrivers();
                System.assertEquals(campaignCreateController.campaignHelper.selectedProject.Brand_Led_Growth__c,'test');
                
            Test.stopTest();      
        }
    } 

    @isTest static void SOWCampaignCreateControllerTest_setAgencyHubSplit_isAgencyHubSplitSet() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);
            Oblix_SOW_Projects__c project1 = Oblix_TestUtils.createSowProjects(PROJECT_TXT_1, mSow.id);
            MDO_Geography__c testGeography = new MDO_Geography__c(name=PROJECT_TXT);
            Oblix_Marketing_SOW_Project_Splits__c testSplit = new Oblix_Marketing_SOW_Project_Splits__c(Project_Splits__c=project.Id);
            Oblix_Marketing_SOW_Project_Splits__c testSplit1 = new Oblix_Marketing_SOW_Project_Splits__c(Project_Splits__c=project1.Id);
            insert testSplit1;
            insert testSplit;
            insert testGeography;
            ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);
            Oblix_SOWCampaignCreateController campaignCreateController = new Oblix_SOWCampaignCreateController();
            
            Test.startTest();
                campaignCreateController.agencyHubSplitWrapperListJSONString = '[{"existingId":"","countryId":"'+testGeography.Id+'","splitPercentage":"10"},{"existingId":"","countryId":"'+testGeography.Id+'","splitPercentage":"90"}]';
                campaignCreateController.setAgencyHubSplit();
                System.assertEquals(campaignCreateController.agencyHubSplitListToInsertOnEdit.size(),2);
                
                campaignCreateController.agencyHubSplitWrapperListJSONString = '[{"existingId":"'+testSplit.id+'","countryId":"'+testGeography.Id+'","splitPercentage":"10"},{"existingId":"'+testSplit1.id+'","countryId":"'+testGeography.Id+'","splitPercentage":"90"}]';
                campaignCreateController.setAgencyHubSplit();
                System.assertEquals(campaignCreateController.agencyHubSplitListToUpdate.size(),2);
                
            Test.stopTest();      
        }
    } 

    @isTest static void SOWCampaignCreateControllerTest_setAgencyHubSplit_isAgencyHubSplitSetOnInsert() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            MDO_Geography__c testGeography = new MDO_Geography__c(name=PROJECT_TXT);
            
            insert testGeography;
            ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
            Oblix_SOWCampaignCreateController campaignCreateController = new Oblix_SOWCampaignCreateController();
            
            Test.startTest();
                campaignCreateController.agencyHubSplitWrapperListJSONString = '[{"existingId":"","countryId":"'+testGeography.Id+'","splitPercentage":"10"},{"existingId":"","countryId":"'+testGeography.Id+'","splitPercentage":"90"}]';
                campaignCreateController.setAgencyHubSplit();
                System.assertEquals(campaignCreateController.agencyHubSplitListToInsert.size(),2);
                System.assertEquals(campaignCreateController.campaignHelper.isGlobalCampaign, false);
            Test.stopTest();      
        }
    } 

    @isTest static void SOWCampaignCreateControllerTest_GlobalCampaign_isGobalCampaignSet() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);
            project.OblixRegion__c = GLOBAL_REGION;
            update project;
            
            ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);
            Oblix_SOWCampaignCreateController campaignCreateController = new Oblix_SOWCampaignCreateController();
            
            Test.startTest();
                System.assertEquals(campaignCreateController.campaignHelper.isEdit, true);
                System.assertEquals(campaignCreateController.campaignHelper.isGlobalCampaign, true);
                
            Test.stopTest();      
        }
    } 

    @isTest static void SOWCampaignCreateControllerTest_FinancialYear_isFinancialYearSetinCreateMode() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            
            ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
            Oblix_SOWCampaignCreateController campaignCreateController = new Oblix_SOWCampaignCreateController();
            
            Test.startTest();
                System.assertEquals(campaignCreateController.campaignHelper.financialYear, 'FY2015');
                
            Test.stopTest();      
        }
    } 

     @isTest static void SOWCampaignCreateControllerTest_FinancialYear_isFinancialYearSetinEditMode() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);

            ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);
            Oblix_SOWCampaignCreateController campaignCreateController = new Oblix_SOWCampaignCreateController();
            
            Test.startTest();
                System.assertEquals(campaignCreateController.campaignHelper.financialYear, 'FY2015');
                
            Test.stopTest();      
        }
    } 

    @isTest static void SOWCampaignCreateControllerTest_countriesByFinancialYear_isCountriesByFinancialYearSet() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);
            
            ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);
            Oblix_SOWCampaignCreateController campaignCreateController = new Oblix_SOWCampaignCreateController();
            
            Test.startTest();
                System.assert(campaignCreateController.campaignHelper.countriesByFinancialYear!=null);
                
            Test.stopTest();      
        }
    } 

    @isTest static void SOWCampaignCreateControllerTest_countriesRegions_isCountriesRegionsArtefactsSet() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);
            MDO_Geography__c testGeography = new MDO_Geography__c(name=PROJECT_TXT,geography_type__c = COUNTRY_TYPE);
            insert testGeography;
            MDO_Geography__c testGeography1 = new MDO_Geography__c(name=PROJECT_TXT,geography_type__c = COUNTRY_TYPE);
            insert testGeography1;
            ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);
            Oblix_SOWCampaignCreateController campaignCreateController = new Oblix_SOWCampaignCreateController();
            
            Test.startTest();
                System.assert(campaignCreateController.campaignHelper.countriesMap!=null);
                System.assert(campaignCreateController.campaignHelper.regionsWithCountriesMap!=null);
                System.assert(campaignCreateController.campaignHelper.countriesWithRegionsMap!=null);
                System.assert(campaignCreateController.campaignHelper.allCountries!=null);
                System.assert(campaignCreateController.campaignHelper.unileverRegions!=null);
                System.assert(campaignCreateController.campaignHelper.regionsWithCountriesMapJSON!=null);
                System.assert(campaignCreateController.campaignHelper.selectedCountriesJSON!=null);
                System.assert(campaignCreateController.campaignHelper.selectedMainRegionJSON!=null);
                System.assert(campaignCreateController.campaignHelper.countryIdsMap!=null);
                System.assert(campaignCreateController.campaignHelper.countryOptions!=null);
            Test.stopTest();      
        }
    }

    @isTest static void SOWCampaignCreateControllerTest_brandAndInnovationOptions_isbrandAndInnovationOptionsSet() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);
            MDO_Geography__c testGeography = new MDO_Geography__c(name=PROJECT_TXT,geography_type__c = COUNTRY_TYPE);
            insert testGeography;
            MDO_Geography__c testGeography1 = new MDO_Geography__c(name=PROJECT_TXT,geography_type__c = COUNTRY_TYPE);
            insert testGeography1;
            ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);
            Oblix_SOWCampaignCreateController campaignCreateController = new Oblix_SOWCampaignCreateController();
            
            Test.startTest();
                System.assert(campaignCreateController.campaignHelper.innovationOptions!=null);
                System.assert(campaignCreateController.campaignHelper.brandOptions!=null);
            Test.stopTest();      
        }
    }
<<<<<<< HEAD
=======

    @isTest static void SOWCampaignCreateControllerTest_cloneTest_isCampaignClonedAndUserRedirected() {
        User u = Oblix_TestUtils.createTestUser();
        
        System.runAs(u) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);
            MDO_Geography__c testGeography = new MDO_Geography__c(name=PROJECT_TXT,geography_type__c = COUNTRY_TYPE);
            insert testGeography;
            MDO_Geography__c testGeography1 = new MDO_Geography__c(name=PROJECT_TXT,geography_type__c = COUNTRY_TYPE);
            insert testGeography1;
            ApexPages.currentPage().getParameters().put(SOWID_TXT, mSow.id);
            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);
            ApexPages.currentPage().getParameters().put(CLONE_TXT, 'true');
            Oblix_SOWCampaignCreateController campaignCreateController = new Oblix_SOWCampaignCreateController();
            campaignCreateController.cloneName =  'Clone campaign name';
            
            Test.startTest();
                campaignCreateController.agencyHubSplitWrapperListJSONString = '[{"existingId":"","countryId":"'+testGeography.Id+'","splitPercentage":"10"},{"existingId":"","countryId":"'+testGeography.Id+'","splitPercentage":"90"}]';
                PageReference redirectPage = campaignCreateController.setAgencyHubSplit();
            Test.stopTest();      

            // S.M. added limit to pass sonar test
            List<Oblix_SOW_Projects__c> projects = [SELECT Id FROM Oblix_SOW_Projects__c LIMIT 1000];
            System.assertEquals(2, projects.size());
            System.assertEquals((new PageReference('/apex/oblix_campaignsummary?projectId=' + campaignCreateController.selected_Project.Id)).getUrl(), redirectPage.getUrl());

        }
    }
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
    
       
}