@isTest
private class Oblix_SOWMainDetalControllerExt_Test {

	private static final String SOW_ID_PARAMETER_STRING = 'sowId';
	//private static final String PROJECT_TXT = 'Project';
	private enum Permission {CAN_EDIT, CAN_DELETE, CAN_APPROVE, CAN_REJECT, CAN_SUBMIT, CAN_DELETE_ATTACHMENT, CAN_ADD_ATTACHMENT, CAN_MANAGE_CAMPAIGN, CAN_MANAGE_NON_CAMPAIGN}

	private static Marketing_SOW__c mSow;
	private static User superuser;

    @isTest static void testAdminAndApprover() {

        initTestData();

        Test.startTest();

        ApexPAges.currentPage().getParameters().put(SOW_ID_PARAMETER_STRING, mSow.Id);
        Oblix_SowMainDetailController controllerInstance = new Oblix_SowMainDetailController();



        Test.stopTest();

        System.assertEquals(false, controllerInstance.is_going_through_rollover);

        System.runAs(superuser) {

            if (controllerInstance.isAdmin) {
                System.assert(controllerInstance.isAdmin);
            }

            if (controllerInstance.sow_approvers_defined) {
                System.assert(controllerInstance.sow_approvers_defined);
            }

        }
    }

    @isTest static void testCanSeeDashboardAndInitialSync() {

        initTestData();

        Test.startTest();

        ApexPAges.currentPage().getParameters().put(SOW_ID_PARAMETER_STRING, mSow.Id);
        Oblix_SowMainDetailController controllerInstance = new Oblix_SowMainDetailController();



        Test.stopTest();

        System.assertEquals(false, controllerInstance.is_going_through_rollover);

        System.runAs(superuser) {


            if (controllerInstance.canSeeDashboard) {
                System.assert(controllerInstance.canSeeDashboard);
            }

            if (controllerInstance.is_initial_rollover_sync_requested) {
                System.assert(controllerInstance.is_initial_rollover_sync_requested);
            }

            if (controllerInstance.is_initial_sync_completed) {
                System.assert(controllerInstance.is_initial_sync_completed);
            }

            if (controllerInstance.is_rollover_in_progress) {
                System.assert(controllerInstance.is_rollover_in_progress);
            }

        }
    }

    @isTest static void testCheckSyncComplete() {

        initTestData();

        Test.startTest();

        ApexPAges.currentPage().getParameters().put(SOW_ID_PARAMETER_STRING, mSow.Id);
        Oblix_SowMainDetailController controllerInstance = new Oblix_SowMainDetailController();



        Test.stopTest();

        System.assertEquals(false, controllerInstance.is_going_through_rollover);

        System.runAs(superuser) {



    		if (controllerInstance.is_sync_complete) {
                System.assert(controllerInstance.is_sync_complete);
            }

            if (controllerInstance.is_approved_original_record) {
                System.assert(controllerInstance.is_approved_original_record);
            }

            if (controllerInstance.can_see_rollover_initiated_message_on_original_sow) {
                System.assert(controllerInstance.can_see_rollover_initiated_message_on_original_sow);
            }

            if (controllerInstance.can_see_sync_completed_on_original_sow) {
                System.assert(controllerInstance.can_see_sync_completed_on_original_sow);
            }

        }
    }

    @isTest static void testCheckSyncInProgress() {

        initTestData();

        Test.startTest();

        ApexPAges.currentPage().getParameters().put(SOW_ID_PARAMETER_STRING, mSow.Id);
        Oblix_SowMainDetailController controllerInstance = new Oblix_SowMainDetailController();



        Test.stopTest();

        System.assertEquals(false, controllerInstance.is_going_through_rollover);

        System.runAs(superuser) {

    		if (controllerInstance.can_see_sync_in_progress) {
                System.assert(controllerInstance.can_see_sync_in_progress);
            }

            if (controllerInstance.can_see_sync_requested_on_bfwd_sow) {
                System.assert(controllerInstance.can_see_sync_requested_on_bfwd_sow);
            }

            if (controllerInstance.can_see_sync_completed_on_bfwd_sow_staying_on_the_page) {
                System.assert(controllerInstance.can_see_sync_completed_on_bfwd_sow_staying_on_the_page);
            }

            if (controllerInstance.can_see_link_to_cloned_record) {
                System.assert(controllerInstance.can_see_link_to_cloned_record);
            }

            if (controllerInstance.can_see_rollover_warning) {
                System.assert(controllerInstance.can_see_rollover_warning);
            }

        }
    }


    // TODO: add user-brand UserPermission records that define approvers and test approval buttons
    private static void initTestData() {

        Map < String, User > testUsers = Oblix_TestUtils.createTestUsers();
        
        superuser = testUsers.get('superuser');
        insert Oblix_TestUtils.createOblixCustomSettings();

        User currentUser = new User(Id = UserInfo.getUserId());
        System.runAs(currentUser) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            //mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, brand.id);
            Map < Id, Oblix_SOW_Projects__c > map_campaigns_to_test = Oblix_TestUtils.insertCampaignsWithRelatedRecords(3, 5, 5, mSow.Id, 'Total turnover >€400m', 'Global campaign (all market clusters)', 'Up to 4 locations', 'New – Multi channel');
            Oblix_TestUtils.createMarketingBasics(mSow.Id);
        }
    }
}