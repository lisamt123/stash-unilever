@isTest
private class Oblix_SOWMainDetailController_Test {

<<<<<<< HEAD
	//private static final String TWO_ELEMENTS_MESSSAGE = 'There should be two elements';
    private static final String NOT_NULL_MESSSAGE = 'Page reference should not be null';
    private static final String FINAL_TEST = 'test';
/*
@isTest static void getthousandBlocksTest() {
=======
    private static final String SOW_ID_PARAMETER_STRING = 'sowId';

	//private static final String PROJECT_TXT = 'Project';
	private enum Permission {CAN_EDIT, CAN_DELETE, CAN_APPROVE, CAN_REJECT, CAN_SUBMIT, CAN_DELETE_ATTACHMENT, CAN_ADD_ATTACHMENT, CAN_MANAGE_CAMPAIGN, CAN_MANAGE_NON_CAMPAIGN}

	private static Marketing_SOW__c mSow;
	private static User ul1;
	private static User ul2;
	private static User ul3;
	private static User superuser;

	// TODO: test submit, approve, reject; test add/delete attachments
	@isTest static void testCampaignNonCampaignList() {

		initTestData();

        ApexPAges.currentPage().getParameters().put(SOW_ID_PARAMETER_STRING, mSow.Id);
        Oblix_SowMainDetailController controllerInstance = new Oblix_SowMainDetailController();
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

            Oblix_SOWMainDetailController controller = new Oblix_SOWMainDetailController();


            List<Oblix_SOWMainDetailController.CampaignNonCampaignItems> lstSowsMarketingLocal = new List<Oblix_SOWMainDetailController.CampaignNonCampaignItems>();
            for (Integer i = 0 ; i < 2000 ; i ++) {
                Marketing_SOW__c item = new Marketing_SOW__c();
                lstSowsMarketingLocal.add(new Oblix_SOWMainDetailController.CampaignNonCampaignItems('Marketing_SOW__c',item));
            }

            Oblix_SOWMainDetailController.limitWrapper[] wrapperlist = controller.getthousandBlocks(lstSowsMarketingLocal);

            Test.stopTest();

            System.assert(!wrapperlist.isEmpty(), 'There should be elements in the list');
        }
    }

*/
    @isTest static void actionsTest() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();
			MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME,Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
			Oblix_SOW_Projects__c project = Oblix_TestUtils.createSowProjects('Project', mSow.id);
			Oblix_Project_Assets__c asset = Oblix_TestUtils.createProjectAssets(project.Id);
			
			Oblix_SOWMainDetailController controllerNoParams = new Oblix_SOWMainDetailController();
			
            ApexPages.currentPage().getParameters().put('projectId',project.Id);
            ApexPages.currentPage().getParameters().put('sowId',mSow.Id);

            Oblix_SOWMainDetailController controller = new Oblix_SOWMainDetailController();
			List<SelectOption> options = controller.getFYSelectOptions();
			System.assert(controller.backAction() != null);
			System.assert(controller.cancelAction() != null);
			System.assert(controller.exitSwop() != null);
			controller.editAction();
			System.assert(controller.editActionPage() != null);
			
			controller.saveSOW();
		    controller.softSaveCampaign();
			System.assert(controller.msDetail() != null);
			System.assert(controller.viewProject() != null);
			System.assert(controller.createNonCamp() != null);
			System.assert(controller.addProject() != null);
			controller.cloneAction(); 
			
            Test.stopTest();

            controller.sow_id = mSow.id;
//            controller.RerenderSelectedSow();

            Attachment att = new Attachment(parentId = mSow.id, name = 'attachmentUnitTest', body = Blob.valueOf(FINAL_TEST));
            insert att;

            controller.refreshAttachments();
            controller.uploadeAttachment();
            controller.SaveAttachments();
   //         controller.applyFilters();
            controller.Cancel();
			System.assert(controller.deleteAction() != null);
        //    System.assert(controller.CreateSOWAction() != null, NOT_NULL_MESSSAGE);
            System.assert(controller.viewNonCampaign() != null, NOT_NULL_MESSSAGE);
            System.assert(controller.addNonCampaignProject() != null, NOT_NULL_MESSSAGE);
            System.assert(Oblix_SOWMainDetailController.reportFolderURL != null, NOT_NULL_MESSSAGE);
            controller.FileCount = '5';
            System.assertEquals(null, controller.changeCount());
            controller.getCategoryBrand();

<<<<<<< HEAD
        }
    }
    @isTest static void removeAttachments_Test() {
        System.runAs(Oblix_TestUtils.createTestUser()) {
            Attachment attach = Oblix_TestUtils.createAttachment(FINAL_TEST, FINAL_TEST,
                                Oblix_TestUtils.createTestMarketingSow(FINAL_TEST, null,
                                        Oblix_TestUtils.createBrand(FINAL_TEST, FINAL_TEST).Id).Id);
            System.assertEquals(1, [SELECT Id FROM Attachment Limit 100].size());
            Test.startTest();
            Oblix_SOWMainDetailController.removeAttachments(new List<String> {attach.Id});
            Test.stopTest();
            System.assertEquals(0, [SELECT Id FROM Attachment Limit 100].size());
        }
=======
    @isTest static void testDeleteAction() {

        initTestData();

        ApexPAges.currentPage().getParameters().put(SOW_ID_PARAMETER_STRING, mSow.Id);
        Oblix_SowMainDetailController controllerInstance = new Oblix_SowMainDetailController();

        controllerInstance.pageAttachment.Name='Unit Test Attachment';
        controllerInstance.pageAttachment.Body=Blob.valueOf('Unit Test Attachment Body');

        Test.startTest();

        controllerInstance.uploadAttachment();
        List<Attachment> uploadedAtt = [SELECT Id FROM Attachment limit 1];
        controllerInstance.deleteAttachmentId = uploadedAtt[0].Id;
        controllerInstance.deleteAtt();

        PageReference deleteAction = controllerInstance.deleteAction();
            
        Test.stopTest();    

        PageReference sow_details_page = Page.oblix_sowmain;
        System.assertEquals(sow_details_page.getUrl(), deleteAction.getUrl());

        List<Oblix_SOW_Projects__c> projects = [SELECT Id FROM Oblix_SOW_Projects__c WHERE Id = :mSow.Id];
        System.assertEquals(0, projects.size());

    }


    @isTest static void testApproveSOW_IS_Approver() {

        initTestData();

        ApexPAges.currentPage().getParameters().put(SOW_ID_PARAMETER_STRING, mSow.Id);
        Oblix_SowMainDetailController controllerInstance = new Oblix_SowMainDetailController();

        User currentUser = new User(Id = UserInfo.getUserId());
        update superuser;
        currentUser.ManagerId = superuser.Id;
        update currentUser;

        mSow.Unilever_SOW_Approver_Name__c = currentUser.Id;
        mSow.Agency_SOW_Approver_Name__c = superuser.Id;
        update mSow;

        Test.startTest();
        
        PageReference submitForApproval = controllerInstance.submitForApproval();

        PageReference approveSOW = controllerInstance.approveSOW();
            
        Test.stopTest();    

        PageReference sow_details_page = Page.oblix_sowmain;
        System.assertEquals(sow_details_page.getUrl(), submitForApproval.getUrl());
        System.assertEquals(sow_details_page.getUrl(), approveSOW.getUrl());

    }


    @isTest static void testRejectSOW_IS_Approver() {

        initTestData();

        insert Oblix_TestUtils.createOblixFXChangeCustomSetting();

        ApexPAges.currentPage().getParameters().put(SOW_ID_PARAMETER_STRING, mSow.Id);
        Oblix_SowMainDetailController controllerInstance = new Oblix_SowMainDetailController();

        User currentUser = new User(Id = UserInfo.getUserId());
        update superuser;
        currentUser.ManagerId = superuser.Id;
        update currentUser;

        mSow.Unilever_SOW_Approver_Name__c = currentUser.Id;
        mSow.Agency_SOW_Approver_Name__c = superuser.Id;
        update mSow;

        Test.startTest();

        Boolean fxEnabled = controllerInstance.submitForApprovalFX;
        
        PageReference submitForApproval = controllerInstance.submitForApproval();

        PageReference rejectSOW = controllerInstance.rejectSOW();
            
        Test.stopTest();    

        PageReference sow_details_page = Page.oblix_sowmain;
        System.assertEquals(sow_details_page.getUrl(), submitForApproval.getUrl());
        System.assertEquals(sow_details_page.getUrl(), rejectSOW.getUrl());

>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
    }
    @isTest static void uploadeAttachmentTest() {
        User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {
            Test.startTest();

<<<<<<< HEAD
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
=======
     @isTest static void testSyncCampaigns() {
        initTestData();

        ApexPAges.currentPage().getParameters().put(SOW_ID_PARAMETER_STRING, mSow.Id);
        Oblix_SowMainDetailController controllerInstance = new Oblix_SowMainDetailController();
        Test.startTest();
        
        PageReference initiateRO = controllerInstance.initiateRollOver();

        List<Oblix_SOW_Projects__c> lst_sowp = [SELECT Id, Sync_Status__c FROM Oblix_SOW_Projects__c limit 1];

        //lst_sowp[0].Sync_Status__c = Oblix_Utils.JOB_STATUS_SYNC_REQUIRED;
        controllerInstance.selected_sow.Initial_Approval_Complete__c = true;

        update lst_sowp;

        PageReference syncCamp = controllerInstance.syncCampaigns();

        controllerInstance.updateSyncStatusAndNameSuffix();
        
        Boolean shouldSync = controllerInstance.shouldSyncAllCampaigns;

        System.assertNotEquals(null, controllerInstance.selected_sow);
        System.assertEquals(mSow.Id, controllerInstance.selected_sow.Id);

        System.assertEquals(Oblix_Utils.NAME_SUFFIX_FINALISED, controllerInstance.selected_sow.Name_Suffix__c);

        controllerInstance.campaignIDSync = lst_sowp[0].Id;
        controllerInstance.syncCampaigns();
            
        Test.stopTest();    

        PageReference sow_details_page = Page.oblix_sowmain;

        //List<Marketing_SOW__c> sowRecord = [SELECT Id, Name_Suffix__c FROM Marketing_SOW__c LIMIT 1];

        

    }

    @isTest static void testIsFXApprovedForFY() {
        initTestData();

        Test.startTest();

        ApexPAges.currentPage().getParameters().put(SOW_ID_PARAMETER_STRING, mSow.Id);
        Oblix_SowMainDetailController controllerInstance = new Oblix_SowMainDetailController();

        Test.stopTest(); 

        System.assertEquals(false, controllerInstance.isFXApprovedForFY);
    }


    @isTest static void testMiscelaneous() {

        initTestData();

        Test.startTest();

        ApexPAges.currentPage().getParameters().put(SOW_ID_PARAMETER_STRING, mSow.Id);
        Oblix_SowMainDetailController controllerInstance = new Oblix_SowMainDetailController();

        

        Test.stopTest(); 

        System.assertEquals(false, controllerInstance.is_going_through_rollover);

        System.runAs(superuser){
            
            if(controllerInstance.isAdmin ){
                System.assert(controllerInstance.isAdmin);
            }

            if(controllerInstance.sow_approvers_defined ){
                System.assert(controllerInstance.sow_approvers_defined );
            }

        }

    }

    

/*
    @isTest static void testSubmitForApprovalCreator_IS_NOT_Approver() {
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);

            Oblix_SOWMainDetailController controller = new Oblix_SOWMainDetailController();

            controller.attachment = new Attachment(name = FINAL_TEST, body = Blob.valueOf(FINAL_TEST));

            controller.sow_Id = mSow.id;

            controller.uploadeAttachment();

            Test.stopTest();
            
            System.assert(controller != null);
            System.assert(controller.liso_attachments != null);

<<<<<<< HEAD
     //       System.assert(!controller.liso_attachments.isEmpty() , 'Attachment should be uploaded');
=======
    	up.put(Permission.CAN_EDIT, controllerInstance.can_edit);
    	up.put(Permission.CAN_DELETE, controllerInstance.can_delete_sow);
    	up.put(Permission.CAN_APPROVE, controllerInstance.can_approve_sow);
    	up.put(Permission.CAN_REJECT, controllerInstance.can_reject_sow);
    	up.put(Permission.CAN_SUBMIT, controllerInstance.can_submit_for_approval);
    	up.put(Permission.CAN_DELETE_ATTACHMENT, controllerInstance.can_delete_attachment);
    	up.put(Permission.CAN_ADD_ATTACHMENT, controllerInstance.can_add_attachment);
    	up.put(Permission.CAN_MANAGE_CAMPAIGN, controllerInstance.can_manage_campaign);
    	up.put(Permission.CAN_MANAGE_NON_CAMPAIGN, controllerInstance.can_manage_non_campaign);

    	return up;
    }

    // TODO: add user-brand UserPermission records that define approvers and test approval buttons
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
            //mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, brand.id);
            Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_test = Oblix_TestUtils.insertCampaignsWithRelatedRecords(3,5,5,mSow.Id,'Total turnover >€400m', 'Global campaign (all market clusters)', 'Up to 4 locations', 'New – Multi channel');
            Oblix_TestUtils.createMarketingBasics(mSow.Id);
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
        }
    }


}