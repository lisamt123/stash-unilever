@isTest
private class Oblix_CampaignAddAssetController_Test {
	private static final String NOT_NULL_MESSAGE = 'Page Reference should not be null';
    private static final String PROJECT_TXT = 'Project';
    private static final String PROJECTID_TXT = 'projectId';

    @isTest static void initTest() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
            MDO_Geography__c geographyRegion = new MDO_Geography__c();
            geographyRegion.Name = 'Europe';
            geographyRegion.geography_type__c = 'Region';
            insert geographyRegion;

            MDO_Geography__c geographyCountry = new MDO_Geography__c();
            geographyCountry.Name = 'France';
            geographyCountry.geography_type__c = 'Country Cluste';
            geographyCountry.parent_L5__c = geographyRegion.Id;
            insert geographyCountry;

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);
            System.assert(project.Id != null, 'project not null');
            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

            Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);

            Oblix_CampaignAddAssetController controller = new Oblix_CampaignAddAssetController();
            string complexity = controller.complexity;
            string idSplit = controller.idSplit;
            Set<Oblix_Project_Assets__c> ClearList = controller.ClearList;
            String selectedCountry = controller.selectedCountry;
            controller.subCat = 'Adaptation';
            controller.recordType = 'Experiential';
            controller.AddToProjectAction();
            controller.exitSwop();
            controller.setCampaignScale();
            controller.addOneMoreProjectSplitInstance();
            controller.finishBasket();
            controller.ReInitializeInstance();
            Oblix_CampaignAddAssetController.removeAsset(asset.name, project.Id);
            
            Test.stopTest();

            System.assert(controller.userConnected != null, 'User should be set');
        }
    }

    @istest static void backActionWithProjectTest() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);

<<<<<<< HEAD
            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

            Oblix_SOWCampaignCreateController controller = new Oblix_SOWCampaignCreateController();

            Test.stopTest();

            System.assert(controller.BackAction() != null, NOT_NULL_MESSAGE);
        }
=======
    @isTest
    static void testAddAsset()
    {
        // Given
        //Pre-create asset scores

        assetScorings = Oblix_TestUtils.createAssetScoringRecords(10);

        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
        
        List<Oblix_SOW_Projects__c> list_campaigns_to_test = Oblix_TestUtils.createCampaigns(1, mSow.Id,CAMPAIGN_TOTAL_TURNOVER, CAMPAIGN_GLOBAL_CAMPAIGN, CAMPAIGN_LOCATIONS, CAMPAIGN_MULTICHANNEL);
        insert list_campaigns_to_test;
        Oblix_SOW_Projects__c campaign = [SELECT Id FROM Oblix_SOW_Projects__c LIMIT 1];
        List<Oblix_Project_Assets__c> list_campaign_assets = Oblix_TestUtils.createLimitedNumberOfProjectAssets(campaign.Id, 3);
        insert list_campaign_assets;
        

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_CampaignAddAsset;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(CAMPAIGN_PROJECT_ID_FIELD_NAME, campaign.Id);
        Oblix_CampaignAddAssetController controller = new Oblix_CampaignAddAssetController();

        //Check whether controller was initiated with 3 campaign assets to begin with
        System.assertEquals(3 ,controller.helper.map_assets_in_basket.keySet().size());
        System.assertEquals(true ,controller.can_manage_asset);
        

        // When
        Test.startTest();
        //Pick asset scoring that isn't in the basket already
        Asset_Scoring__c asset_scoring = assetScorings[assetScorings.size()-1];
        //Populate VF page fields
        //controller.projectId = campaign.Id;
        controller.helper.selectedAssetName = asset_scoring.Asset_name__c;
        controller.helper.selectedAssetOtherName = '';
        controller.helper.selectedAssetMDMId = asset_scoring.mdm_id__c;
        controller.helper.selectedAssetQuantity = 5;
        controller.helper.selectedAssetNotes = ASSET_NOTES_VALUE;


        controller.addAssetToBasket();
        
        //String nextPage = controller.finishWithBasket().getUrl();
        Test.stopTest();

        System.assertEquals(4 ,controller.helper.map_assets_in_basket.keySet().size());

        // Then
        Oblix_Project_Assets__c newAsset = [SELECT Id, 
                                                             Asset_Name__c,
                                                             Agency_Projects__c,
                                                             Asset_Score__c,
                                                             Quantity__c,
                                                             Additional_Description__c,
                                                             Option_Name__c,
                                                             Sub_Category__c,
                                                             Asset_Type__c,
                                                             mdm_id__c
                                                      FROM 
                                                            Oblix_Project_Assets__c 
                                                      WHERE 
                                                            Agency_Projects__c = :campaign.Id
                                                      AND
                                                            mdm_id__c = :asset_scoring.mdm_id__c
                                                      LIMIT 1];

        System.assertNotEquals(null, newAsset);
        System.assertEquals(asset_scoring.Asset_name__c, newAsset.Asset_Name__c);
        System.assertEquals(5, newAsset.Quantity__c);

        List<Oblix_Project_Assets__c> projectAssets = [SELECT Id
                                                      FROM 
                                                            Oblix_Project_Assets__c 
                                                      WHERE 
                                                            Agency_Projects__c = :campaign.Id];
        System.assertEquals(4, projectAssets.size());

    }



    @isTest
    static void testAddAssetException()
    {
        // Given
        //Pre-create asset scores

        assetScorings = Oblix_TestUtils.createAssetScoringRecords(10);

        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
        
        List<Oblix_SOW_Projects__c> list_campaigns_to_test = Oblix_TestUtils.createCampaigns(1, mSow.Id,CAMPAIGN_TOTAL_TURNOVER, CAMPAIGN_GLOBAL_CAMPAIGN, CAMPAIGN_LOCATIONS, CAMPAIGN_MULTICHANNEL);
        insert list_campaigns_to_test;
        Oblix_SOW_Projects__c campaign = [SELECT Id FROM Oblix_SOW_Projects__c LIMIT 1];
        List<Oblix_Project_Assets__c> list_campaign_assets = Oblix_TestUtils.createLimitedNumberOfProjectAssets(campaign.Id, 3);
        insert list_campaign_assets;
        

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_CampaignAddAsset;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(CAMPAIGN_PROJECT_ID_FIELD_NAME, campaign.Id);
        Oblix_CampaignAddAssetController controller = new Oblix_CampaignAddAssetController();

        //Check whether controller was initiated with 3 campaign assets to begin with
        System.assertEquals(3 ,controller.helper.map_assets_in_basket.keySet().size());
        System.assertEquals(true ,controller.can_manage_asset);
        

        // When
        Test.startTest();
        //Pick asset scoring that isn't in the basket already
        Asset_Scoring__c asset_scoring = assetScorings[assetScorings.size()-1];
        //Populate VF page fields
        //controller.projectId = campaign.Id;
        controller.helper.selectedAssetName = asset_scoring.Asset_name__c;
        controller.helper.selectedAssetOtherName = null;
        controller.helper.selectedAssetMDMId = asset_scoring.mdm_id__c;
        controller.helper.selectedAssetQuantity = 5;
        controller.helper.selectedAssetNotes = ASSET_NOTES_VALUE;

        controller.addAssetToBasket();
        
        //String nextPage = controller.finishWithBasket().getUrl();
        Test.stopTest();
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

        System.assertEquals(3 ,controller.helper.map_assets_in_basket.keySet().size());
        System.assertEquals(3 ,controller.helper.list_order_added.size());
        
    }

    @istest static void backActionWithoutProjectTest() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {

            Test.startTest();

<<<<<<< HEAD
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            ApexPages.currentPage().getParameters().put('sowId', mSow.id);

            Oblix_SOWCampaignCreateController controller = new Oblix_SOWCampaignCreateController();

            Test.stopTest();

            System.assert(controller.BackAction() != null, NOT_NULL_MESSAGE);
        }

    }

    @isTest static void AddAgencySplitTest() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);

            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);
=======

    @isTest
    static void testUpdateAsset()
    {
        // Given
        //Pre-create asset scores

        assetScorings = Oblix_TestUtils.createAssetScoringRecords(10);

        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
        
        List<Oblix_SOW_Projects__c> list_campaigns_to_test = Oblix_TestUtils.createCampaigns(1, mSow.Id,CAMPAIGN_TOTAL_TURNOVER, CAMPAIGN_GLOBAL_CAMPAIGN, CAMPAIGN_LOCATIONS, CAMPAIGN_MULTICHANNEL);
        insert list_campaigns_to_test;
        Oblix_SOW_Projects__c campaign = [SELECT Id FROM Oblix_SOW_Projects__c LIMIT 1];
        List<Oblix_Project_Assets__c> list_campaign_assets = Oblix_TestUtils.createLimitedNumberOfProjectAssets(campaign.Id, 3);
        insert list_campaign_assets;
        

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_CampaignAddAsset;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(CAMPAIGN_PROJECT_ID_FIELD_NAME, campaign.Id);
        Oblix_CampaignAddAssetController controller = new Oblix_CampaignAddAssetController();

        //Check whether controller was initiated with 3 campaign assets to begin with
        System.assertEquals(3 ,controller.helper.map_assets_in_basket.keySet().size());

        //Pick asset scoring that isn't in the basket already
        Asset_Scoring__c asset_scoring = assetScorings[assetScorings.size()-1];
        //Populate VF page fields
        //controller.projectId = campaign.Id;
        controller.helper.selectedAssetName = asset_scoring.Asset_name__c;
        controller.helper.selectedAssetOtherName = '';
        controller.helper.selectedAssetMDMId = asset_scoring.mdm_id__c;
        controller.helper.selectedAssetQuantity = 5;
        controller.helper.selectedAssetNotes = ASSET_NOTES_VALUE;

        controller.addAssetToBasket();

        System.assertEquals(4 ,controller.helper.map_assets_in_basket.keySet().size());

        // When
        Test.startTest();

        controller.helper.selectedAssetQuantity = 15;
        controller.helper.selectedAssetNotes = 'test123';

        controller.updateAssetInBasket();
        
        Test.stopTest();

        

        // Then
        Oblix_AssetOfferingWrapper.AssetWrapper wrapper = controller.helper.map_assets_in_basket.get(asset_scoring.mdm_id__c);
        System.assertEquals(15, wrapper.quantity_in_basket);
        System.assertEquals('test123', wrapper.other_description_info);

        Oblix_Project_Assets__c newAsset = [SELECT Id, 
                                                             Asset_Name__c,
                                                             Agency_Projects__c,
                                                             Asset_Score__c,
                                                             Quantity__c,
                                                             Additional_Description__c,
                                                             Option_Name__c,
                                                             Sub_Category__c,
                                                             Asset_Type__c,
                                                             mdm_id__c
                                                      FROM 
                                                            Oblix_Project_Assets__c 
                                                      WHERE 
                                                            Agency_Projects__c = :campaign.Id
                                                      AND
                                                            mdm_id__c = :asset_scoring.mdm_id__c
                                                      LIMIT 1];

        System.assertNotEquals(null, newAsset);
        System.assertEquals('test123', newAsset.Additional_Description__c);
        System.assertEquals(15, newAsset.Quantity__c);

    }


    @isTest
    static void testUpdateAssetException()
    {
        // Given
        //Pre-create asset scores

        assetScorings = Oblix_TestUtils.createAssetScoringRecords(10);

        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
        
        List<Oblix_SOW_Projects__c> list_campaigns_to_test = Oblix_TestUtils.createCampaigns(1, mSow.Id,CAMPAIGN_TOTAL_TURNOVER, CAMPAIGN_GLOBAL_CAMPAIGN, CAMPAIGN_LOCATIONS, CAMPAIGN_MULTICHANNEL);
        insert list_campaigns_to_test;
        Oblix_SOW_Projects__c campaign = [SELECT Id FROM Oblix_SOW_Projects__c LIMIT 1];
        List<Oblix_Project_Assets__c> list_campaign_assets = Oblix_TestUtils.createLimitedNumberOfProjectAssets(campaign.Id, 3);
        insert list_campaign_assets;
        

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_CampaignAddAsset;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(CAMPAIGN_PROJECT_ID_FIELD_NAME, campaign.Id);
        Oblix_CampaignAddAssetController controller = new Oblix_CampaignAddAssetController();

        //Check whether controller was initiated with 3 campaign assets to begin with
        System.assertEquals(3 ,controller.helper.map_assets_in_basket.keySet().size());

        //Pick asset scoring that isn't in the basket already
        Asset_Scoring__c asset_scoring = assetScorings[assetScorings.size()-1];
        //Populate VF page fields
        //controller.projectId = campaign.Id;
        controller.helper.selectedAssetName = asset_scoring.Asset_name__c;
        controller.helper.selectedAssetOtherName = '';
        controller.helper.selectedAssetMDMId = asset_scoring.mdm_id__c;
        controller.helper.selectedAssetQuantity = 5;
        controller.helper.selectedAssetNotes = ASSET_NOTES_VALUE;

        controller.addAssetToBasket();

        System.assertEquals(4 ,controller.helper.map_assets_in_basket.keySet().size());

        // When
        Test.startTest();

        controller.helper.selectedAssetOtherName = null;

        controller.updateAssetInBasket();
        
        Test.stopTest();

        System.assertEquals(4 ,controller.helper.map_assets_in_basket.keySet().size());

        // Then
        Oblix_AssetOfferingWrapper.AssetWrapper wrapper = controller.helper.map_assets_in_basket.get(asset_scoring.mdm_id__c);
        System.assertEquals(5, wrapper.quantity_in_basket);
        System.assertEquals(ASSET_NOTES_VALUE, wrapper.other_description_info);

        Oblix_Project_Assets__c newAsset = [SELECT Id, 
                                                             Asset_Name__c,
                                                             Agency_Projects__c,
                                                             Asset_Score__c,
                                                             Quantity__c,
                                                             Additional_Description__c,
                                                             Option_Name__c,
                                                             Sub_Category__c,
                                                             Asset_Type__c,
                                                             mdm_id__c
                                                      FROM 
                                                            Oblix_Project_Assets__c 
                                                      WHERE 
                                                            Agency_Projects__c = :campaign.Id
                                                      AND
                                                            mdm_id__c = :asset_scoring.mdm_id__c
                                                      LIMIT 1];

        System.assertNotEquals(null, newAsset);
        System.assertEquals(ASSET_NOTES_VALUE, newAsset.Additional_Description__c);
        System.assertEquals(5, newAsset.Quantity__c);

    }


    @isTest
    static void testRemoveAsset()
    {
        // Given
        //Pre-create asset scores

        assetScorings = Oblix_TestUtils.createAssetScoringRecords(10);

        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
        
        List<Oblix_SOW_Projects__c> list_campaigns_to_test = Oblix_TestUtils.createCampaigns(1, mSow.Id,CAMPAIGN_TOTAL_TURNOVER, CAMPAIGN_GLOBAL_CAMPAIGN, CAMPAIGN_LOCATIONS, CAMPAIGN_MULTICHANNEL);
        insert list_campaigns_to_test;
        Oblix_SOW_Projects__c campaign = [SELECT Id FROM Oblix_SOW_Projects__c LIMIT 1];
        List<Oblix_Project_Assets__c> list_campaign_assets = Oblix_TestUtils.createLimitedNumberOfProjectAssets(campaign.Id, 3);
        insert list_campaign_assets;
        

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_CampaignAddAsset;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(CAMPAIGN_PROJECT_ID_FIELD_NAME, campaign.Id);
        Oblix_CampaignAddAssetController controller = new Oblix_CampaignAddAssetController();

        //Check whether controller was initiated with 3 campaign assets to begin with
        System.assertEquals(3 ,controller.helper.map_assets_in_basket.keySet().size());

        //Pick asset scoring that isn't in the basket already
        Asset_Scoring__c asset_scoring = assetScorings[assetScorings.size()-1];
        
        // When
        Test.startTest();

        String mdm_id = controller.helper.list_order_added[0];

        //Populate VF page fields
        //controller.projectId = campaign.Id;
        controller.helper.selectedAssetMDMId = mdm_id;
        
        controller.removeAssetFromBasket();
        
        Test.stopTest();

        

        // Then

        List<Oblix_Project_Assets__c> newAsset = [SELECT Id, 
                                                             Asset_Name__c,
                                                             Agency_Projects__c,
                                                             Asset_Score__c,
                                                             Quantity__c,
                                                             Additional_Description__c,
                                                             Option_Name__c,
                                                             Sub_Category__c,
                                                             Asset_Type__c,
                                                             mdm_id__c
                                                      FROM 
                                                            Oblix_Project_Assets__c 
                                                      WHERE 
                                                            Agency_Projects__c = :campaign.Id
                                                      AND
                                                            mdm_id__c = :mdm_id
                                                      LIMIT 1];

        System.assertEquals(0, newAsset.size());

        List<Oblix_Project_Assets__c> projectAssets = [SELECT Id
                                                      FROM 
                                                            Oblix_Project_Assets__c 
                                                      WHERE 
                                                            Agency_Projects__c = :campaign.Id];
        System.assertEquals(2, projectAssets.size());
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

            Oblix_CampaignAddAssetController controller = new Oblix_CampaignAddAssetController();

            controller.lstProjectSplitHubs = new List<Oblix_Marketing_SOW_Project_Splits__c>();

            controller.AddAgencySplit();

            Test.stopTest();

            System.assert(!controller.lstProjectSplitHubs.isEmpty(), 'Collection should not be empty');
        }
    }


<<<<<<< HEAD
    @isTest static void setInfoSplitHubTest() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);

            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

            Oblix_CampaignAddAssetController controller = new Oblix_CampaignAddAssetController();

            controller.listItems = 'null_null_1.0,null_null_2.0,';
=======


    @isTest
    static void testFinishWithBasketInsertMissingAssets()
    {
        // Given
        //Pre-create asset scores

        assetScorings = Oblix_TestUtils.createAssetScoringRecords(10);

        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
        
        List<Oblix_SOW_Projects__c> list_campaigns_to_test = Oblix_TestUtils.createCampaigns(1, mSow.Id,CAMPAIGN_TOTAL_TURNOVER, CAMPAIGN_GLOBAL_CAMPAIGN, CAMPAIGN_LOCATIONS, CAMPAIGN_MULTICHANNEL);
        insert list_campaigns_to_test;
        Oblix_SOW_Projects__c campaign = [SELECT Id FROM Oblix_SOW_Projects__c LIMIT 1];
        List<Oblix_Project_Assets__c> list_campaign_assets = Oblix_TestUtils.createLimitedNumberOfProjectAssets(campaign.Id, 3);
        insert list_campaign_assets;
        

        //Init controller with existing assets
        PageReference pageRef = Page.Oblix_CampaignAddAsset;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put(CAMPAIGN_PROJECT_ID_FIELD_NAME, campaign.Id);
        Oblix_CampaignAddAssetController controller = new Oblix_CampaignAddAssetController();

        //Check whether controller was initiated with 3 campaign assets to begin with
        System.assertEquals(3 ,controller.helper.map_assets_in_basket.keySet().size());

        // When
        Test.startTest();
        //Pick asset scoring that isn't in the basket already
        Asset_Scoring__c asset_scoring = assetScorings[assetScorings.size()-1];
        //Create new asset wrapper
        Oblix_AssetOfferingWrapper.AssetWrapper asset_to_add_to_basket = 
            Oblix_AssetOfferingWrapper.initialiseAssetWrapper(campaign.Id,
                                                     ASSET_NOTES_VALUE, 
                                                     '',
                                                     asset_scoring.mdm_id__c, 
                                                     3, 
                                                     ASSET_NOTES_VALUE);
        controller.helper.map_assets_in_basket.put(asset_scoring.mdm_id__c, asset_to_add_to_basket);
        
        controller.finishWithBasket();
        //String nextPage = controller.finishWithBasket().getUrl();
        Test.stopTest();

        System.assertEquals(4 ,controller.helper.map_assets_in_basket.keySet().size());

        // Then
        Oblix_Project_Assets__c newAsset = [SELECT Id, 
                                                             Asset_Name__c,
                                                             Agency_Projects__c,
                                                             Asset_Score__c,
                                                             Quantity__c,
                                                             Additional_Description__c,
                                                             Option_Name__c,
                                                             Sub_Category__c,
                                                             Asset_Type__c,
                                                             mdm_id__c
                                                      FROM 
                                                            Oblix_Project_Assets__c 
                                                      WHERE 
                                                            Agency_Projects__c = :campaign.Id
                                                      AND
                                                            mdm_id__c = :asset_scoring.mdm_id__c
                                                      LIMIT 1];

        System.assertNotEquals(null, newAsset);
        System.assertEquals(ASSET_NOTES_VALUE, newAsset.Asset_Name__c);
        System.assertEquals(3, newAsset.Quantity__c);

        List<Oblix_Project_Assets__c> projectAssets = [SELECT Id
                                                      FROM 
                                                            Oblix_Project_Assets__c 
                                                      WHERE 
                                                            Agency_Projects__c = :campaign.Id];
        System.assertEquals(4, projectAssets.size());

        System.assertNotEquals(null, controller.helper.assetOtherNameLabel);
        System.assertNotEquals(null, controller.helper.assetOfferingWrapper);
        
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

            controller.setInfoSplitHub();

            System.assert(controller.agencySplitInstanceJS != null, 'Object should not be null');

            //controller.ValueDriversUpdate();
            //controller.getAssetRecordType();

            Test.stopTest();
        }
    }

    @isTest static void setInfoMethodTest() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);

            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

            Oblix_CampaignAddAssetController controller = new Oblix_CampaignAddAssetController();

            controller.setInfoDrivers();
            controller.setInfoStages();
            controller.setInfoCountries();
            controller.setInfoTimeLine();
            controller.EditAction();
            //controller.setAgencyHubOnComplete();
            controller.setMoreDetails();
            controller.saveSubCatAsset();
            controller.SaveProjectAction();

            Test.stopTest();

            System.assert(project != null, 'Project should not be null');
            System.assert(controller.isEdit, 'Edit flag should be set');
        }
    }

    static testMethod void ValueDriversProjectTest() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);

            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects(PROJECT_TXT, mSow.id);

            ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);

            Oblix_CampaignAddAssetController controller = new Oblix_CampaignAddAssetController();

            controller.project = project;

            controller.ValueDriversProject('c1,c2,c4,c4');
            controller.ValueDriversProject('c1,c2,c4,c4,c5,c6');
            controller.ValueDriversProject('c1,c2,c4,c4,c5,c6,c7,c8,c9,c10,c11');
            controller.ValueDriversProject('c1,c2,c4,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16');

            Test.stopTest();

            System.assertEquals(controller.project.Project_Scale_1__c , Oblix_Constants.Innovation_Projects_Market5, 'Field should not be empty');

        }

    }

    private static Oblix_SOW_Projects__c initSaveProjectActionData() {
        Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('test_project',
                                        Oblix_TestUtils.createTestMarketingSow(null, null,
                                                Oblix_TestUtils.createBrand('test_brand', 'test').Id).Id);

        ApexPages.currentPage().getParameters().put(PROJECTID_TXT, project.id);
        return project;
    }

    @isTest static void SaveProjectAction_Error_Test() {
        System.runAs(Oblix_TestUtils.createTestUser()) {
            Oblix_SOW_Projects__c project = initSaveProjectActionData();

            Oblix_CampaignAddAssetController ctrl = new Oblix_CampaignAddAssetController();

            ctrl.project = project;
            ctrl.project.Name = null;
            ctrl.projectId = project.Id;

            Test.startTest();
            System.assertEquals(null, ctrl.SaveProjectAction());
            Test.stopTest();
            
        }
    }

    @isTest static void SaveProjectAction_Error2_Test() {
        System.runAs(Oblix_TestUtils.createTestUser()) {
            Oblix_SOW_Projects__c project = initSaveProjectActionData();
            Oblix_CampaignAddAssetController ctrl = new Oblix_CampaignAddAssetController();
            ctrl.project = project;
            ctrl.project.Name = null;
            ctrl.projectId = null;

            Test.startTest();
            System.assertEquals(null, ctrl.SaveProjectAction());
            Test.stopTest();
        }
    }

    @isTest static void SaveProjectAction_Error3_Test(){
        System.runAs(Oblix_TestUtils.createTestUser()) {
            Oblix_SOW_Projects__c project = initSaveProjectActionData();
            Oblix_CampaignAddAssetController ctrl = new Oblix_CampaignAddAssetController();
            ctrl.project = project;
            ctrl.projectId = null;

            Test.startTest();
            System.assertEquals(null, ctrl.SaveProjectAction());
            Test.stopTest();
        }
    }
    
    @isTest static void setAsGlobal_Test(){
    
        System.runAs(Oblix_TestUtils.createTestUser()) {
            Oblix_SOW_Projects__c project = initSaveProjectActionData();
            Oblix_CampaignAddAssetController ctrl = new Oblix_CampaignAddAssetController();
            ctrl.project = project;
            ctrl.projectId = project.Id;
            
            Test.startTest();
            ctrl.setAsGlobal();
            Test.stopTest();
            
            Oblix_SOW_Projects__c result = [select OblixRegion__c from Oblix_SOW_Projects__c where id = :project.Id];
            System.assertEquals('World',result.OblixRegion__c);
        }
    }
    /*
    @isTest static void removeAsset_Test(){
    
        System.runAs(Oblix_TestUtils.createTestUser()) {
            
            Oblix_SOW_Projects__c project = initSaveProjectActionData();
            Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
            
            Test.startTest();
            Oblix_CampaignAddAssetController.removeAsset(asset.Id);
            Test.stopTest();
            
            List<Oblix_Project_Assets__c> result = [select Id from Oblix_Project_Assets__c where id = :asset.Id];
            System.assert(result.isEmpty());
        }
    }
    */
    
    @isTest static void refresh_Test(){
    
        System.runAs(Oblix_TestUtils.createTestUser()) {
            
            Oblix_SOW_Projects__c project = initSaveProjectActionData();
            project.Total_Fees_for_Project__c  = 1000;
            update project;
            Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
            Oblix_CampaignAddAssetController ctrl = new Oblix_CampaignAddAssetController();
            
            Test.startTest();
            ctrl.refresh();
            Test.stopTest();
            System.assertEquals(1,ctrl.countAssetNumberForCampaign);
        }
    }
    
    @isTest static void getAbreviationForCardAssets_Test(){
    
        System.runAs(Oblix_TestUtils.createTestUser()) {
            
            Oblix_SOW_Projects__c project = initSaveProjectActionData();
            Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
            
            Test.startTest();
            Map<String, String> result = Oblix_CampaignAddAssetController.getAbreViationByRTBySubCatgForCardAssets();
            Test.stopTest();
            
            System.assert(!result.isEmpty());
        }
    }    
    
    
     @isTest static void getAssetDetails_Test(){
    
        System.runAs(Oblix_TestUtils.createTestUser()) {
            
            Oblix_SOW_Projects__c project = initSaveProjectActionData();
            Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
            
            Test.startTest();
            Oblix_Utils.AssetDetailWrapper result = Oblix_CampaignAddAssetController.getAssetDetails(asset.Id);
            Test.stopTest();
            
            System.assert(result != null);
        }
    }       
    
    @isTest static void UpdateProjectAction_Test(){
    
        System.runAs(Oblix_TestUtils.createTestUser()) {
            
            Oblix_SOW_Projects__c project = initSaveProjectActionData();
            Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
            asset.Asset_Title__c = 'test X title';
            update asset;
            Oblix_CampaignAddAssetController ctrl = new Oblix_CampaignAddAssetController();
            Map<String, Object> details = new Map<String, Object>();
            details.put('quantity', '50');
            
            Test.startTest();
            Oblix_CampaignAddAssetController.UpdateProjectAction(asset.Id, details) ;
            Test.stopTest();
            
            Oblix_Project_Assets__c result = [select quantity__c from Oblix_Project_Assets__c where id =: asset.Id];
            System.assertEquals(50, Integer.valueOf(result.quantity__c));
        }
    }      
}