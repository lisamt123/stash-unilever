@isTest
public with sharing class Oblix_SplitHandler_Test {

	@isTest static void Oblix_SplitHandler_Test(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);

            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);
            
            Oblix_Marketing_SOW_Project_Splits__c splits = Oblix_TestUtils.createSowProjectSplits(project.Id);
            System.assertEquals(splits.Project_Splits__c, project.Id, 'split has the same project');
            Oblix_SplitHandler handler = new Oblix_SplitHandler();
            handler.bulkBefore();
            handler.beforeInsert(splits);
            handler.beforeUpdate(splits, splits);
            handler.beforeDelete(splits);
             
            splits.Percentage__c = 50;
            update splits;
            handler.triggerShouldExecute = false;
            delete splits;
            Test.stopTest();
        }
	}
}