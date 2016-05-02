@isTest
public with sharing class Oblix_ProjectHandler_Test {
	private static final String FINANCIAL_YEAR = 'Same Financial Year';
	@isTest static void Oblix_ProjectHandler_Test(){
		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);

            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);
            System.assertEquals(project.Financial_Year__c,mSow.id,FINANCIAL_YEAR);
            Oblix_ProjectHandler handler = new Oblix_ProjectHandler();
            
            handler.bulkAfter();
            handler.beforeDelete(project);
            handler.afterInsert(project);
            handler.afterUpdate(project, project);
            handler.afterDelete(project);
            handler.andFinally();
            
            project.name = 'change';
            update project;
            Oblix_ProjectHandler.triggerShouldExecute = false;
            Test.stopTest();
        }
	}

}