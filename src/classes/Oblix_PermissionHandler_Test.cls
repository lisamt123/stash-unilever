@isTest
private class Oblix_PermissionHandler_Test {


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
    }

    @isTest static void testSuperUserApproval() {

        initTestUsers();

        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_Utils.SOW_STATUS_AWAITING_UNILEVER_APPROVAL, brand.id);
        MDO_Category__c category = Oblix_TestUtils.createSmallProductCategory();
        system.assert(category!=null,'category inserted');
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
        System.runAs(superuser) {

            System.assertEquals(true, Oblix_PermissionHandler.isNextApprover(mSow.Id));
            System.assertEquals(true, Oblix_PermissionHandler.canSubmitForApproval(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, NULL,NULL));
            System.assertEquals(false, Oblix_PermissionHandler.canRejectSOW(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, mSow.Id));
            System.assertEquals(false, Oblix_PermissionHandler.canApproveSOW(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, mSow.Id));

        }

        Test.stopTest();


    }
    
    @isTest static void testSuperUser() {
        initTestUsers();

        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_Utils.SOW_STATUS_AWAITING_UNILEVER_APPROVAL, brand.id);
        MDO_Category__c category = Oblix_TestUtils.createSmallProductCategory();

        Test.startTest();
        System.runAs(superuser) {

            System.assertEquals(true, Oblix_PermissionHandler.hasEditAccess(mSow));
            System.assertEquals(true, Oblix_PermissionHandler.canCreateSOW());
            System.assertEquals(true, Oblix_PermissionHandler.canSeeFinancialField(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, mSow.Id));
            System.assertEquals(true, Oblix_PermissionHandler.canSeeFinancialField(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, null));
            System.assertEquals(true, Oblix_PermissionHandler.canDeleteSOW(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, mSow.Id));
            System.assertEquals(true, Oblix_PermissionHandler.canSetCompletionStage(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER));
            System.assertEquals(true, Oblix_PermissionHandler.canSetProjectedStage(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER));
            //System.assertEquals(true, Oblix_PermissionHandler.canSeeGeographicScale());
            //System.assertEquals(true, Oblix_PermissionHandler.canSeeAgencyHubFields());
            System.assertEquals(true, Oblix_PermissionHandler.canCancelCampaign(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER));
            System.assertEquals(true, Oblix_PermissionHandler.canManageNonCampaign(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, mSow.Id));
            System.assertEquals(true, Oblix_PermissionHandler.canManageCampaign(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, mSow.Id, 'New'));
            System.assertEquals(true, Oblix_PermissionHandler.canManageAssetBasket(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, mSow.Id, 'New', null));
            System.assertEquals(false, Oblix_PermissionHandler.isNextApprover(mSow.Id));
            System.assertEquals(true, Oblix_PermissionHandler.canSubmitForApproval(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, NULL,NULL));
            System.assertEquals(false, Oblix_PermissionHandler.canRejectSOW(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, mSow.Id));
            System.assertEquals(false, Oblix_PermissionHandler.canApproveSOW(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, mSow.Id));
            System.assertEquals(true, Oblix_PermissionHandler.canAddNewAttachment(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER));
            System.assertEquals(true, Oblix_PermissionHandler.canDeleteAttachment(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER));
            System.assertEquals(true, Oblix_PermissionHandler.canCancelSOW(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER));
            System.assertEquals(false, Oblix_PermissionHandler.hasUL1permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasUL2permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasUL3permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasAG1permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasAG2permissionSet());
            System.assertEquals(true, Oblix_PermissionHandler.hasSuperUserpermissionSet());

            System.assertEquals(true, Oblix_PermissionHandler.isOnlyBrandCatEditor(brand.Id, category.Id, superuser.id));
            System.assertEquals(true, Oblix_PermissionHandler.canAdjustFee(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER,brand.Id, category.Id, superuser.id));


        }
        Test.stopTest();
    }

    @isTest static void testUL1() {
        initTestUsers();

        Test.startTest();
        System.runAs(ul1) {

            System.assertEquals(true, Oblix_PermissionHandler.hasUL1permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasUL2permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasUL3permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasAG1permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasAG2permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasSuperUserpermissionSet());

        }
        Test.stopTest();
    }

    @isTest static void testUL2() {
        initTestUsers();

        Test.startTest();
        System.runAs(ul2) {

            System.assertEquals(false, Oblix_PermissionHandler.hasUL1permissionSet());
            System.assertEquals(true, Oblix_PermissionHandler.hasUL2permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasUL3permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasAG1permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasAG2permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasSuperUserpermissionSet());

        }
        Test.stopTest();
    }

    @isTest static void testUL3() {
        initTestUsers();

        MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_Utils.SOW_STATUS_AWAITING_UNILEVER_APPROVAL, brand.id);
        MDO_Category__c category = Oblix_TestUtils.createSmallProductCategory();
        system.assertequals(mSow!=null,category!=null,'category inserted');
        Test.startTest();
        System.runAs(ul3) {

            System.assertEquals(false, Oblix_PermissionHandler.hasUL1permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasUL2permissionSet());
            System.assertEquals(true, Oblix_PermissionHandler.hasUL3permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasAG1permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasAG2permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasSuperUserpermissionSet());

            System.assertEquals(false, Oblix_PermissionHandler.canAdjustFee(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER,brand.Id, category.Id, ul3.id));
            System.assertEquals(false, Oblix_PermissionHandler.hasEditAccess(mSow));

        }
        Test.stopTest();
    }
    
    // Added by suresh
    
    @isTest static void testAG1() {
      User thisUser = new User(Id = UserInfo.getUserId());
       User ag1 =new user();
          MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_Utils.SOW_STATUS_AWAITING_UNILEVER_APPROVAL, brand.id);
        MDO_Category__c category = Oblix_TestUtils.createSmallProductCategory();
        system.assertequals(mSow!=null,category!=null,'category inserted');
      
      System.runAs(thisUser){
         Profile profile = [SELECT Id FROM Profile WHERE Name='Marketing User'];
         ag1 = new User(Alias = 'ag1'+'ut', Email = 'ag1'+'unittest@unilever.com', 
            EmailEncodingKey = 'UTF-8', LastName = 'LastName', LanguageLocaleKey = 'en_us', 
            LocaleSidKey = 'en_us', ProfileId = profile.Id, FirstName = 'ag1', 
            TimeZoneSidKey = 'Europe/London',AF_Agency_Fees_User_Type__c = 'Category Finance',isActive = true, 
            UserName = 'ag1'+'@unilever.com.unittest');

         insert ag1;

         PermissionSet ps1 = [SELECT Id, Name FROM PermissionSet WHERE Name='Oblix_SWOP_AG_1_Agency'];

         PermissionSetAssignment ag1PSA = Oblix_TestUtils.createPermissionSetAssignment(ag1.Id, ps1.id);

         insert ag1PSA;
      }
      Test.startTest();
        System.runAs(ag1) {

            System.assertEquals(false, Oblix_PermissionHandler.hasUL1permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasUL2permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasUL3permissionSet());
            System.assertEquals(true, Oblix_PermissionHandler.hasAG1permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasAG2permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasAG3permissionSet()); 
            System.assertEquals(false, Oblix_PermissionHandler.hasSuperUserpermissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.canDeleteSOW(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, mSow.Id));
            System.assertEquals(true, Oblix_PermissionHandler.canSeeFinancialField(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, mSow.Id));
            System.assertEquals(false, Oblix_PermissionHandler.canSetCompletionStage(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER));
            System.assertEquals(false, Oblix_PermissionHandler.canSetProjectedStage(Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER));
            System.assertEquals(false, Oblix_PermissionHandler.canEditKeySOWFields());
           
           
        }
        Test.stopTest(); 
      
    }
    
    /*  @isTest static void testAG2() {
      User thisUser = new User(Id = UserInfo.getUserId());
       User ag2 =new user();
      System.runAs(thisUser){
         Profile profile = [SELECT Id FROM Profile WHERE Name='Marketing User'];
         ag2 = new User(Alias = 'ag2'+'ut', Email = 'ag2'+'unittest@unilever.com', 
            EmailEncodingKey = 'UTF-8', LastName = 'LastName', LanguageLocaleKey = 'en_us', 
            LocaleSidKey = 'en_us', ProfileId = profile.Id, FirstName = 'ag2', 
            TimeZoneSidKey = 'Europe/London',AF_Agency_Fees_User_Type__c ='Category Finance',isActive = true, 
            UserName = 'ag2'+'@unilever.com.unittest');

         insert ag2;

         PermissionSet ps2 = [SELECT Id, Name FROM PermissionSet WHERE Name='Oblix_SWOP_AG_2_Agency'];

         PermissionSetAssignment ag2PSA = Oblix_TestUtils.createPermissionSetAssignment(ag2.Id, ps2.id);

         insert ag2PSA;
      }
      Test.startTest();
        System.runAs(ag2) {

            System.assertEquals(false, Oblix_PermissionHandler.hasUL1permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasUL2permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasUL3permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasAG1permissionSet());
            System.assertEquals(true, Oblix_PermissionHandler.hasAG2permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasAG3permissionSet()); 
            System.assertEquals(false, Oblix_PermissionHandler.hasSuperUserpermissionSet());
        }
        Test.stopTest(); 
      
    } */

      @isTest static void testAG3() {
      User thisUser = new User(Id = UserInfo.getUserId());
       User ag3 =new user();
          MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
        Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_Utils.SOW_STATUS_AWAITING_UNILEVER_APPROVAL, brand.id);
        MDO_Category__c category = Oblix_TestUtils.createSmallProductCategory();
        system.assertequals(mSow!=null,category!=null,'category inserted');
      
      System.runAs(thisUser){
         Profile profile = [SELECT Id FROM Profile WHERE Name='Marketing User'];
         ag3 = new User(Alias = 'ag3'+'ut', Email = 'ag3'+'unittest@unilever.com', 
            EmailEncodingKey = 'UTF-8', LastName = 'LastName', LanguageLocaleKey = 'en_us', 
            LocaleSidKey = 'en_us', ProfileId = profile.Id, FirstName = 'ag3', 
            TimeZoneSidKey = 'Europe/London',AF_Agency_Fees_User_Type__c ='Category Finance',isActive = true, 
            UserName = 'ag3'+'@unilever.com.unittest');

         insert ag3;

         PermissionSet ps3 = [SELECT Id, Name FROM PermissionSet WHERE Name='Oblix_SWOP_AG_3_Agency'];
         PermissionSet ps32 = [SELECT Id, Name FROM PermissionSet WHERE Name='Oblix_SWOP_Super_User_V1'];
         PermissionSetAssignment ag3PSA = Oblix_TestUtils.createPermissionSetAssignment(ag3.Id, ps3.id);
         PermissionSetAssignment ag32PSA = Oblix_TestUtils.createPermissionSetAssignment(ag3.Id, ps32.id);

         insert ag3PSA;
         insert ag32PSA;
      
      }
      Test.startTest();
        System.runAs(ag3) {

            System.assertEquals(false, Oblix_PermissionHandler.hasUL1permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasUL2permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasUL3permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasAG1permissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.hasAG2permissionSet());
            System.assertEquals(true, Oblix_PermissionHandler.hasAG3permissionSet()); 
            System.assertEquals(true, Oblix_PermissionHandler.hasSuperUserpermissionSet());
            System.assertEquals(false, Oblix_PermissionHandler.canSeeDashboards());
            System.assertEquals(true, Oblix_PermissionHandler.hasEditAccess(mSow));
            System.assertEquals(true, Oblix_PermissionHandler.canEditKeySOWFields());
           
        }
        Test.stopTest(); 
      
    }

    
    

    
}