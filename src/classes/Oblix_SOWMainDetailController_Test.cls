@isTest
private class Oblix_SOWMainDetailController_Test {

	private static final String PROJECT_TXT = 'Project';
	private enum Permission {CAN_EDIT, CAN_DELETE, CAN_APPROVE, CAN_REJECT, CAN_SUBMIT}

	private static Marketing_SOW__c mSow;
	private static User ul1;
	private static User ul2;
	private static User ul3;
	private static User superuser;

	@isTest static void testCampaignNonCampaignList() {

		initTestData();

        ApexPAges.currentPage().getParameters().put('sowId', mSow.Id);
        Oblix_SowMainDetailController controllerInstance = new Oblix_SowMainDetailController();

        Test.startTest();

        Integer numberOfSOWItems = controllerInstance.li_campaign_and_non_campaign_items.size();
        Boolean canEditSOW = controllerInstance.can_edit;
        Boolean canDeleteSOW = controllerInstance.can_delete_sow;
        Boolean canApproveSOW = controllerInstance.can_approve_sow;
        Boolean canRejectSOW = controllerInstance.can_reject_sow;
        Boolean canSubmitSOW = controllerInstance.can_submit_for_approval;
        Boolean showSubmit = controllerInstance.show_submit;
            
        Test.stopTest();

        System.assertEquals(4, numberOfSOWItems);


    }

    private static Map<String, Boolean> getUserPermissions(){
    	Map<String, Boolean> up = new Map<String, Boolean>();

    	return up;
    }

    private static void initTestData(){

    	Map<String, User> testUsers = Oblix_TestUtils.createTestUsers();
    	ul1 = testUsers.get('UL1');
    	ul2 = testUsers.get('UL2');
    	ul3 = testUsers.get('UL3');
    	superuser = testUsers.get('superuser');

        insert Oblix_TestUtils.createOblixCustomSettings();

        User currentUser = new User(Id = UserInfo.getUserId());
        System.runAs(currentUser) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_test = Oblix_TestUtils.insertCampaignsWithRelatedRecords(3,5,5,mSow.Id,'Total turnover >€400m', 'Global campaign (all market clusters)', 'Up to 4 locations', 'New – Multi channel');
            Oblix_TestUtils.createMarketingBasics(mSow.Id);
        }
    }


}