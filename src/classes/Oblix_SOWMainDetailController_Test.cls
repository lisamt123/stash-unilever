/*****************************************************************************************
* @author       Slavko Skular
* @date         2016-03-22
* @description  Tests for the SOWMainDetailController
*
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Slavko Skular              2016-03-22          Created.

******************************************************************************************/

@isTest
private class Oblix_SOWMainDetailController_Test {

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

        Test.startTest();

        Integer numberOfSOWItems = controllerInstance.li_campaign_and_non_campaign_items.size();

        Map<Permission, Boolean> ul1Permissions;
        Map<Permission, Boolean> ul2Permissions;
        Map<Permission, Boolean> ul3Permissions;
        Map<Permission, Boolean> superuserPermissions;

        Boolean showSubmitUL1;
        Boolean showSubmitUL2;
        Boolean showSubmitUL3;
        Boolean showSubmitSuperuser;

        //Boolean sow_approvers_defined;

        System.runAs(ul1){
        	ul1Permissions = getUserPermissions(controllerInstance);
        	showSubmitUL1 = controllerInstance.show_submit;
            system.assertNotEquals(NULL, ul1Permissions, 'Expecting this to be populated with permissions!');
        }
        System.runAs(ul2){
        	ul2Permissions = getUserPermissions(controllerInstance);
        	showSubmitUL2 = controllerInstance.show_submit;
            system.assertNotEquals(NULL, ul2Permissions, 'Expecting this to be populated with permissions!');
        }
        System.runAs(ul3){
        	ul3Permissions = getUserPermissions(controllerInstance);
        	showSubmitUL3 = controllerInstance.show_submit;
            system.assertNotEquals(NULL, ul3Permissions, 'Expecting this to be populated with permissions!');
        }
        System.runAs(superuser){
        	superuserPermissions = getUserPermissions(controllerInstance);
        	showSubmitSuperuser = controllerInstance.show_submit;

            system.assertNotEquals(NULL, superuserPermissions, 'Expecting this to be populated with permissions!');
        }
            
        Test.stopTest();

        System.assertEquals(4, numberOfSOWItems);

        System.assertEquals(true, showSubmitUL1);
        System.assertEquals(true, showSubmitUL2);
        System.assertEquals(true, showSubmitUL3);
        System.assertEquals(true, showSubmitSuperuser);


    }


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

    }

     @isTest static void testSyncCampaigns() {
        initTestData();

        ApexPAges.currentPage().getParameters().put(SOW_ID_PARAMETER_STRING, mSow.Id);
        Oblix_SowMainDetailController controllerInstance = new Oblix_SowMainDetailController();
<<<<<<< HEAD

=======
>>>>>>> develop
        Test.startTest();
        
        PageReference initiateRO = controllerInstance.initiateRollOver();

        List<Oblix_SOW_Projects__c> lst_sowp = [SELECT Id, Sync_Status__c FROM Oblix_SOW_Projects__c limit 1];

        //lst_sowp[0].Sync_Status__c = Oblix_Utils.JOB_STATUS_SYNC_REQUIRED;
        controllerInstance.selected_sow.Initial_Approval_Complete__c = true;

        update lst_sowp;

        PageReference syncCamp = controllerInstance.syncCampaigns();

        controllerInstance.updateSyncStatusAndNameSuffix();
        
<<<<<<< HEAD

        Boolean shouldSync = controllerInstance.shouldSyncAllCampaigns;
=======
        Boolean shouldSync = controllerInstance.shouldSyncAllCampaigns;

        System.assertNotEquals(null, controllerInstance.selected_sow);
        System.assertEquals(mSow.Id, controllerInstance.selected_sow.Id);

        System.assertEquals(Oblix_Utils.NAME_SUFFIX_FINALISED, controllerInstance.selected_sow.Name_Suffix__c);

        controllerInstance.campaignIDSync = lst_sowp[0].Id;
        controllerInstance.syncCampaigns();
>>>>>>> develop
            
        Test.stopTest();    

        PageReference sow_details_page = Page.oblix_sowmain;

        //List<Marketing_SOW__c> sowRecord = [SELECT Id, Name_Suffix__c FROM Marketing_SOW__c LIMIT 1];

<<<<<<< HEAD
        System.assertNotEquals(null, controllerInstance.selected_sow);
        System.assertEquals(mSow.Id, controllerInstance.selected_sow.Id);

        System.assertEquals(Oblix_Utils.NAME_SUFFIX_FINALISED, controllerInstance.selected_sow.Name_Suffix__c);

    }

=======
        

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

    

>>>>>>> develop
/*
    @isTest static void testSubmitForApprovalCreator_IS_NOT_Approver() {

        initTestData();



        ApexPAges.currentPage().getParameters().put('sowId', mSow.Id);
        Oblix_SowMainDetailController controllerInstance = new Oblix_SowMainDetailController();

        Test.startTest();

        System.runAs(superuser){
            PageReference submitForApproval = controllerInstance.submitForApproval();
            PageReference sow_details_page = Page.oblix_sowmain;
            System.assertEquals(sow_details_page.getUrl(), submitForApproval.getUrl());
        }
            
        Test.stopTest();    

    }
*/

    private static Map<Permission, Boolean> getUserPermissions(Oblix_SowMainDetailController controllerInstance){
    	Map<Permission, Boolean> up = new Map<Permission, Boolean>();

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
        }
    }


}