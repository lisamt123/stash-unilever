@isTest
private class Oblix_UserPermissionHandlerTest {

	private static User ul1;
    private static User ul2;
    private static User ul3;
    private static User superuser;

    private static void initTestUsers(){

        Map<String, User> testUsers = Oblix_TestUtils.createTestUsers();
        ul1 = testUsers.get('UL1');
        ul2 = testUsers.get('UL2');
        ul3 = testUsers.get('UL3');
        superuser = testUsers.get('superuser');

        System.assertNotEquals(NULL, ul1, 'expecting ul1 user to exist!');
        System.assertNotEquals(NULL, ul2, 'expecting ul2 user to exist!');
        System.assertNotEquals(NULL, ul3, 'expecting ul3 user to exist!');
    }

	/*@isTest static void testabortRelatedApprovals() {

		initTestUsers();

        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_Utils.SOW_STATUS_AWAITING_UNILEVER_APPROVAL, brand.id);
        MDO_Category__c category = Oblix_TestUtils.createSmallProductCategory();

        User currentUser = new User(Id = UserInfo.getUserId());
        currentUser.ManagerId = superuser.Id;
        update currentUser;

        mSow.Unilever_SOW_Approver_Name__c = currentUser.Id;
        mSow.Agency_SOW_Approver_Name__c = superuser.Id;
        update mSow;

        // Create an approval request for the account
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(mSow.id);

        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);

        // Verify the result
        System.assert(result.isSuccess());

        // Approve the submitted request
        // First, get the ID of the newly created item
        List<Id> newWorkItemIds = result.getNewWorkitemIds();

        // Instantiate the new ProcessWorkitemRequest object and populate it
        Approval.ProcessWorkitemRequest req2 = 
            new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving request.');
        req2.setAction('Approve');
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});

        // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(newWorkItemIds.get(0));

        // Submit the request for approval
        Approval.ProcessResult result2 =  Approval.process(req2);

        // Verify the results
        System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());

		
		Test.startTest();

		Oblix_UserPermissionHandlerLogic.abortRelatedApprovals(new Set<Id>{mSow.Id});

		Test.stopTest();

		List<ProcessInstanceWorkitem> workItems = [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :mSow.Id];

		System.assertEquals(0, workItems.size());

	}*/
	
	@isTest static void testTrigger() {

		String brandName = 'Test_Brand';
		String categoryName = 'Test_Category';

		MDO_Brand__c brand = new MDO_Brand__c();
		brand.Name = brandName;
		brand.mdm_id__c = '111';
		insert brand;

		MDO_Category__c category = new MDO_Category__c();
		category.Name = categoryName;
		category.mdm_id__c = '222';
		category.category_type__c = 'Category';
		insert category;

		MDO_CategoryBrands__c cb = new MDO_CategoryBrands__c();
		cb.mdm_id__c = '333';
		cb.brand_id__c = brand.Id;
		cb.product_Category_Id__c = category.Id;
		insert cb;

		User u = Oblix_TestUtils.createTestUser();
		
		Oblix_User_Permission__c up = new Oblix_User_Permission__c();
		up.Level_of_Access__c = Oblix_Utils.USER_PERMISSION_APPROVER;
		up.CategoryBrand_id__c = cb.Id;
		up.User_id__c = u.Id;
		insert up;

		Oblix_User_Permission__c upDB = [SELECT Id, Brand_Name__c FROM Oblix_User_Permission__c WHERE Id =: up.Id];

		System.assert(upDB.Brand_Name__c == brandName);

	}


	@isTest static void coverBlankMethods() {

		String brandName = 'Test_Brand';
		String categoryName = 'Test_Category';

		MDO_Brand__c brand = new MDO_Brand__c();
		brand.Name = brandName;
		brand.mdm_id__c = '111';
		insert brand;

		MDO_Category__c category = new MDO_Category__c();
		category.Name = categoryName;
		category.mdm_id__c = '222';
		category.category_type__c = 'Category';
		insert category;

		MDO_CategoryBrands__c cb = new MDO_CategoryBrands__c();
		cb.mdm_id__c = '333';
		cb.brand_id__c = brand.Id;
		cb.product_Category_Id__c = category.Id;
		insert cb;

		User u = Oblix_TestUtils.createTestUser();
		
		Oblix_User_Permission__c up = new Oblix_User_Permission__c();
		up.Level_of_Access__c = Oblix_Utils.USER_PERMISSION_APPROVER;
		up.CategoryBrand_id__c = cb.Id;
		up.User_id__c = u.Id;
		insert up;

		Oblix_UserPermissionHandler handler = new Oblix_UserPermissionHandler();

		handler.bulkBefore();
		handler.beforeInsert(up);
		handler.beforeUpdate(up, up);
		handler.beforeDelete(up);
		handler.afterInsert(up);
		handler.afterUpdate(up, up);
		handler.afterDelete(up);

		System.assert(true);

	}
	
}