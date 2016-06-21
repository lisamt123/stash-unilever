@isTest
public with sharing class Oblix_AssetHandler_Test {
      private static List<Asset_Scoring__c> list_of_asset_scoring;

	@isTest static void Oblix_AssetHandler_Test(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            list_of_asset_scoring = Oblix_TestUtils.createAssetScoringRecords(10);  
            insert list_of_asset_scoring;

            insert Oblix_TestUtils.createOblixCustomSettings();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);

            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);
             
            Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
            System.assertEquals(asset.Agency_Projects__c, project.Id, 'Asset has the same project');
            Oblix_AssetHandler handler = new Oblix_AssetHandler();
            handler.bulkBefore();
            handler.beforeInsert(asset);
            handler.beforeUpdate(asset, asset);
            handler.beforeDelete(asset);
            handler.afterInsert(asset);
            handler.afterUpdate(asset, asset);
            handler.afterDelete(asset);
            
            asset.Location__c = 'change';
            update asset;
            handler.triggerShouldExecute = false;
            delete asset;
            Test.stopTest();
        }
	}
}