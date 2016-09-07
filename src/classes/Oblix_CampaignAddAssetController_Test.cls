@isTest
private class Oblix_CampaignAddAssetController_Test {

    private static final String CAMPAIGN_TOTAL_TURNOVER = 'Total turnover >€400m';
    private static final String CAMPAIGN_GLOBAL_CAMPAIGN = 'Global campaign (all market clusters)';
    private static final String CAMPAIGN_LOCATIONS = 'Up to 4 locations';
    private static final String CAMPAIGN_MULTICHANNEL = 'New – Multi channel';
    private static final String CAMPAIGN_PROJECT_ID_FIELD_NAME = 'projectid';
    private static final String ASSET_NOTES_VALUE = 'test';
    
    
    private static List<Asset_Scoring__c> assetScorings;
    @testSetup static void initCommonData() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {  
            assetScorings = Oblix_TestUtils.createAssetScoringRecords(10);
            insert assetScorings;
            insert Oblix_TestUtils.createOblixCustomSettings();
            insert Oblix_TestUtils.createBoxRangeCalculatorRecords();
            insert Oblix_TestUtils.createCountryCalculatorRecords();
        }
    }


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

        System.assertEquals(3 ,controller.helper.map_assets_in_basket.keySet().size());
        System.assertEquals(3 ,controller.helper.list_order_added.size());
        
    }



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
        system.assert(asset_scoring!=null,'asset_scoring inserted');
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

    }




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
        

    }


    @isTest
    static void testFinishWithBasketUpdateAssets()
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

        // When - imitate loss of sync between controll basket map and DB
        //Pick first asset in basket to change
        Test.startTest();
        Oblix_AssetOfferingWrapper.AssetWrapper asset_to_change = controller.helper.map_assets_in_basket.values()[0];
        Integer newQuantity = asset_to_change.quantity_in_basket + 5;
        String newDescription = 'New test description';
        asset_to_change.quantity_in_basket = newQuantity;
        asset_to_change.other_description_info = newDescription;
        
        controller.finishWithBasket();
        //String nextPage = controller.finishWithBasket().getUrl();
        Test.stopTest();

        // Then
        Oblix_Project_Assets__c changedAsset = [SELECT Id, 
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
                                                            mdm_id__c = :asset_to_change.mdm_id
                                                      LIMIT 1];

        System.assertNotEquals(null, changedAsset);
        System.assertEquals(newDescription, changedAsset.Additional_Description__c);
        System.assertEquals(newQuantity, changedAsset.Quantity__c);


    }


    @isTest
    static void testFinishWithBasketRemoveAssets()
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
        //Pick first asset in basket to remove
        Test.startTest();
        Oblix_AssetOfferingWrapper.AssetWrapper asset_to_remove = controller.helper.map_assets_in_basket.values()[0];
        controller.helper.map_assets_in_basket.remove(asset_to_remove.mdm_id);
        
        controller.finishWithBasket();
        //String nextPage = controller.finishWithBasket().getUrl();
        Test.stopTest();

        // Then
        List<Oblix_Project_Assets__c> removedAssets = [SELECT Id, 
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
                                                            mdm_id__c = :asset_to_remove.mdm_id
                                                      LIMIT 1];

        System.assertEquals(0, removedAssets.size());

    }



    @isTest
    static void testFinishWithBasketInsertUpdateDelete()
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
        //Insert
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


        //Update
        //Pick first asset in basket to change
        Oblix_AssetOfferingWrapper.AssetWrapper asset_to_change = controller.helper.map_assets_in_basket.values()[1];
        Integer newQuantity = asset_to_change.quantity_in_basket + 5;
        String newDescription = 'New test description';
        asset_to_change.quantity_in_basket = newQuantity;
        asset_to_change.other_description_info = newDescription;


        //Delete
        //Pick first asset in basket to remove
        Oblix_AssetOfferingWrapper.AssetWrapper asset_to_remove = controller.helper.map_assets_in_basket.values()[0];
        controller.helper.map_assets_in_basket.remove(asset_to_remove.mdm_id);
        
        controller.finishWithBasket();
        //String nextPage = controller.finishWithBasket().getUrl();
        Test.stopTest();

        // Then


        //Check inserted asset
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

        //Check updated asset
        Oblix_Project_Assets__c changedAsset = [SELECT Id, 
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
                                                            mdm_id__c = :asset_to_change.mdm_id
                                                      LIMIT 1];

        System.assertNotEquals(null, changedAsset);
        System.assertEquals(newDescription, changedAsset.Additional_Description__c);
        System.assertEquals(newQuantity, changedAsset.Quantity__c);


        //Check removed asset
        List<Oblix_Project_Assets__c> removedAssets = [SELECT Id, 
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
                                                            mdm_id__c = :asset_to_remove.mdm_id
                                                      LIMIT 1];

        System.assertEquals(0, removedAssets.size());


        //Check overall count
        List<Oblix_Project_Assets__c> projectAssets = [SELECT Id
                                                      FROM 
                                                            Oblix_Project_Assets__c 
                                                      WHERE 
                                                            Agency_Projects__c = :campaign.Id];
        System.assertEquals(3, projectAssets.size());


    } 
}