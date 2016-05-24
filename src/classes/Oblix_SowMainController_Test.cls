/*****************************************************************************************
* @author       Slavko Skular
* @date         2016-02-02
* @description  Tests for the SOWMainController
*
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Slavko Skular              2016-02-23          Created

******************************************************************************************/
@isTest
private class Oblix_SowMainController_Test {

    private static Marketing_SOW__c sowDove;
    private static Marketing_SOW__c sowKnorr;
    private static Marketing_SOW__c sowAmbrosia;
    private static Marketing_SOW__c sowCiff;
    private static Marketing_SOW__c sowInvalidBrandCatComb;

    private static MDO_CategoryBrands__c cbDovePC;
    private static MDO_CategoryBrands__c cbKnorrOF;
    private static MDO_CategoryBrands__c cbAmbrosiaOF;
    private static MDO_CategoryBrands__c cbCiffPC;

    private static final String BRAND_DOVE = 'Dove';
    private static final String BRAND_KNORR = 'Knorr';
    private static final String BRAND_AMBROSIA = 'Ambrosia';
    private static final String BRAND_CIFF = 'Ciff';
    private static final String SMALL_CAT_PC = 'Personal Care';
    private static final String SMALL_CAT_OF = 'Other Food';

    private static User ul1;
    private static User ul2;
    private static User ul3;
    private static User superuser;
    private static User ul1_2;

    private static Oblix_User_Permission__c up1Dove;
    //private static Oblix_User_Permission__c up1Knorr;
    private static Oblix_User_Permission__c up1_2Knorr;
    
    
    @isTest static void testGetAllSOWRecords() {
        
        initTestData();

        Oblix_SowMainController controller = new Oblix_SowMainController();

        Test.startTest();

        List<List<Oblix_SowMainController.SOWWrapper>> records = controller.liliso_sow;
        
        Test.stopTest();

        System.assertEquals(4, records[0].size());

    }
    

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-23
    * @description  test redirects of the page
    ********************************************************************************/   
    @isTest static void testRedirects() {
        
        initTestData();

        Oblix_SowMainController controller = new Oblix_SowMainController();
        controller.selectedSowId = sowDove.Id;

        Test.startTest();

        PageReference prefSowDetail = controller.redirectToSOWDetailPage();
        PageReference prefNewSow = controller.createSOWAction();

        Test.stopTest();

        System.assertEquals(Page.Oblix_SOWMainDetail.getUrl() + '?sowId=' + sowDove.Id, prefSowDetail.getUrl());
        System.assertEquals(prefSowDetail.getParameters().get('sowId'), sowDove.Id);

        System.assertEquals(Page.Oblix_SOWCreate.getUrl(), prefNewSow.getUrl());

    }

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-23
    * @description  test brand-category access permissions
    ********************************************************************************/   
    @isTest static void testPermissions() {

        initTestData();

        Test.startTest();

        // ul1 should see Dove, Knorr and Ambrosia
        // ul2 should see Dove and Knorr
        // ul3 should see Dove and Ciff
        // superuser should see all regardless of user permission records (View-All on Marketing_SOW__c object)

        List<Marketing_SOW__c> ul1SOWList;
        List<Marketing_SOW__c> ul2SOWList;
        List<Marketing_SOW__c> ul3SOWList;
        List<Marketing_SOW__c> superuserSOWList;
        List<Marketing_SOW__c> administratorSOWList;

        // s.m added limit as per sonar issue 
        System.runAs(ul1){
            ul1SOWList = [SELECT Id, Name, OblixBrand__c, SmallProductCategory__c FROM Marketing_SOW__c LIMIT 1000];
        }
        System.runAs(ul2){
            ul2SOWList = [SELECT Id, Name, OblixBrand__c, SmallProductCategory__c FROM Marketing_SOW__c LIMIT 1000];
        }
        System.runAs(ul3){
            ul3SOWList = [SELECT Id, Name, OblixBrand__c, SmallProductCategory__c FROM Marketing_SOW__c LIMIT 1000];
        }
        System.runAs(superuser){
            superuserSOWList = [SELECT Id, Name, OblixBrand__c, SmallProductCategory__c FROM Marketing_SOW__c LIMIT 1000];
        }

        administratorSOWList = [SELECT Id, Name, OblixBrand__c, SmallProductCategory__c FROM Marketing_SOW__c LIMIT 1000];

        Test.stopTest();

        Map<String, String> ul1Brands = new Map<String, String>{
            cbDovePC.brand_id__c => cbDovePC.product_Category_Id__c,
            cbKnorrOF.brand_id__c => cbKnorrOF.product_Category_Id__c,
            cbAmbrosiaOF.brand_id__c => cbAmbrosiaOF.product_Category_Id__c
        };
        Map<String, String> ul2Brands = new Map<String, String>{
            cbDovePC.brand_id__c => cbDovePC.product_Category_Id__c,
            cbKnorrOF.brand_id__c => cbKnorrOF.product_Category_Id__c
        };
        Map<String, String> ul3Brands = new Map<String, String>{
            cbDovePC.brand_id__c => cbDovePC.product_Category_Id__c,
            cbCiffPC.brand_id__c => cbCiffPC.product_Category_Id__c
        };
        Map<String, String> superuserBrands = new Map<String, String>{
            cbDovePC.brand_id__c => cbDovePC.product_Category_Id__c,
            cbKnorrOF.brand_id__c => cbKnorrOF.product_Category_Id__c,
            cbAmbrosiaOF.brand_id__c => cbAmbrosiaOF.product_Category_Id__c,
            cbCiffPC.brand_id__c => cbCiffPC.product_Category_Id__c
        };
        

        System.assertEquals(4, administratorSOWList.size());

        System.assertEquals(3, ul1SOWList.size());
        for(Marketing_SOW__c sow : ul1SOWList){
            System.assert(ul1Brands.keyset().contains(sow.OblixBrand__c) && ul1Brands.get(sow.OblixBrand__c) == sow.SmallProductCategory__c);
        }
        
        System.assertEquals(2, ul2SOWList.size());
        for(Marketing_SOW__c sow : ul2SOWList){
            System.assert(ul2Brands.keyset().contains(sow.OblixBrand__c) && ul2Brands.get(sow.OblixBrand__c) == sow.SmallProductCategory__c);
        }

        System.assertEquals(2, ul3SOWList.size());
        for(Marketing_SOW__c sow : ul3SOWList){
            System.assert(ul3Brands.keyset().contains(sow.OblixBrand__c) && ul3Brands.get(sow.OblixBrand__c) == sow.SmallProductCategory__c);
        }

        System.assertEquals(4, superuserSOWList.size());
        for(Marketing_SOW__c sow : superuserSOWList){
            System.assert(superuserBrands.keyset().contains(sow.OblixBrand__c) && superuserBrands.get(sow.OblixBrand__c) == sow.SmallProductCategory__c);
        }


    }

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-23
    * @description  test approval reassignment
    ********************************************************************************/
    @isTest static void testApprovalReassignment(){

        initTestData();

        Test.setCurrentPageReference(new PageReference('Page.Oblix_SOWMainDetail'));
        System.currentPageReference().getParameters().put('sowId', sowKnorr.Id);
        Oblix_SowMainDetailController controller = new Oblix_SowMainDetailController();

        controller.submitForApproval();

        Test.startTest();

        up1_2Knorr.CategoryBrand_id__c = cbDovePC.Id;
        update up1_2Knorr;

        up1Dove.CategoryBrand_id__c = cbKnorrOF.Id;
        update up1Dove;

        Test.stopTest();

        List<ProcessInstanceWorkItem> pendingApprovals = [Select Id, ActorId, ProcessInstance.TargetObjectId From ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId = :sowKnorr.Id];

        System.assertEquals(1, pendingApprovals.size());
        System.assertEquals(ul1.Id, pendingApprovals[0].ActorId);

    }


    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-23
    * @description  initialize test data
    ********************************************************************************/
    private static void initTestData(){

        // insert brands MDO data
        MDO_Brand__c bDove = Oblix_TestUtils.createBrand(BRAND_DOVE);
        MDO_Brand__c bKnorr = Oblix_TestUtils.createBrand(BRAND_KNORR);
        MDO_Brand__c bAmbrosia = Oblix_TestUtils.createBrand(BRAND_AMBROSIA);
        MDO_Brand__c bCiff = Oblix_TestUtils.createBrand(BRAND_CIFF);
        insert new List<MDO_Brand__c>{bDove, bKnorr, bAmbrosia, bCiff};

        insert Oblix_TestUtils.createOblixCustomSettings();

        // insert categories MDO data
        MDO_Category__c scPC = Oblix_TestUtils.createProductCategory(SMALL_CAT_PC);
        MDO_Category__c scOF = Oblix_TestUtils.createProductCategory(SMALL_CAT_OF);
        MDO_Category__c bc = Oblix_TestUtils.createProductCategory('Big category');
        insert new List<MDO_Category__c>{scPC, scOF, bc};

        // insert category brand MDO data
        cbDovePC = Oblix_TestUtils.createCategoryBrand(scPC.Id, bDove.Id);
        cbKnorrOF = Oblix_TestUtils.createCategoryBrand(scOF.Id, bKnorr.Id);
        cbAmbrosiaOF = Oblix_TestUtils.createCategoryBrand(scOF.Id, bAmbrosia.Id);
        cbCiffPC = Oblix_TestUtils.createCategoryBrand(scPC.Id, bCiff.Id);
        insert new List<MDO_CategoryBrands__c>{cbDovePC, cbKnorrOF, cbAmbrosiaOF, cbCiffPC};

        // insert users
        User thisUser = new User(Id = UserInfo.getUserId());
        System.runAs(thisUser){
            ul1 = Oblix_TestUtils.createMarketingUser('UL1');
            ul2 = Oblix_TestUtils.createMarketingUser('UL2');
            ul3 = Oblix_TestUtils.createMarketingUser('UL3');
            superuser = Oblix_TestUtils.createMarketingUser('superu');
            ul1_2 = Oblix_TestUtils.createMarketingUser('UL1_1');
            insert new List<User>{ul1, ul2, ul3, superuser, ul1_2};

            // assign permission sets (step 1. get permission set ids, verify they exist)
            Map<String, Id> oblixPermissionSets = Oblix_TestUtils.getOblixPermissionSets();

            System.assertNotEquals(null, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL1));
            System.assertNotEquals(null, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL2));
            System.assertNotEquals(null, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL3));
            System.assertNotEquals(null, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_SUPERUSER));

            PermissionSetAssignment ul1PSA = Oblix_TestUtils.createPermissionSetAssignment(ul1.Id, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL1));
            PermissionSetAssignment ul2PSA = Oblix_TestUtils.createPermissionSetAssignment(ul2.Id, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL2));
            PermissionSetAssignment ul3PSA = Oblix_TestUtils.createPermissionSetAssignment(ul3.Id, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL3));
            PermissionSetAssignment superuserPSA = Oblix_TestUtils.createPermissionSetAssignment(superuser.Id, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_SUPERUSER));
            PermissionSetAssignment ul1_2PSA = Oblix_TestUtils.createPermissionSetAssignment(ul1_2.Id, oblixPermissionSets.get(Oblix_Utils.PERMISSIONSETNAME_UL1));
            insert new List<PermissionSetAssignment>{ul1PSA, ul2PSA, ul3PSA, superuserPSA, ul1_2PSA};
        }

        // insert oblix user permission (user permissions to brand-category)
        // UL1 Dove approver, Knorr edit, Ambrosia read only, Ciff no access
        // UL2 Dove Edit, Knorr read only, Ambrosia no access, Ciff no access
        // UL3 Dove Read only, Knorr no access, Ambrosia no access, Ciff edit (should have read regardless)
        // superuser Dove approver, Knorr edit, Ambrosia read only, Diff no access
        // UL1_2 Knorr approver
        up1Dove = Oblix_TestUtils.createUserPermission(ul1.Id, cbDovePC.Id, Oblix_Utils.USER_PERMISSION_APPROVER, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);
        Oblix_User_Permission__c up1Knorr = Oblix_TestUtils.createUserPermission(ul1.Id, cbKnorrOF.Id, Oblix_Utils.USER_PERMISSION_ACCESS_EDIT, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);
        Oblix_User_Permission__c up1Ambrosia = Oblix_TestUtils.createUserPermission(ul1.Id, cbAmbrosiaOF.Id, Oblix_Utils.USER_PERMISSION_READ_ONLY, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);

        Oblix_User_Permission__c up2Dove = Oblix_TestUtils.createUserPermission(ul2.Id, cbDovePC.Id, Oblix_Utils.USER_PERMISSION_ACCESS_EDIT, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);
        Oblix_User_Permission__c up2Knorr = Oblix_TestUtils.createUserPermission(ul2.Id, cbKnorrOF.Id, Oblix_Utils.USER_PERMISSION_READ_ONLY, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);

        Oblix_User_Permission__c up3Dove = Oblix_TestUtils.createUserPermission(ul3.Id, cbDovePC.Id, Oblix_Utils.USER_PERMISSION_READ_ONLY, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);
        Oblix_User_Permission__c up3Ciff = Oblix_TestUtils.createUserPermission(ul3.Id, cbCiffPC.Id, Oblix_Utils.USER_PERMISSION_ACCESS_EDIT, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);

        Oblix_User_Permission__c superuserDove = Oblix_TestUtils.createUserPermission(superuser.Id, cbDovePC.Id, Oblix_Utils.USER_PERMISSION_APPROVER, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);
        Oblix_User_Permission__c superuserKnorr = Oblix_TestUtils.createUserPermission(superuser.Id, cbKnorrOF.Id, Oblix_Utils.USER_PERMISSION_ACCESS_EDIT, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);
        Oblix_User_Permission__c superuserAmbrosia = Oblix_TestUtils.createUserPermission(superuser.Id, cbAmbrosiaOF.Id, Oblix_Utils.USER_PERMISSION_READ_ONLY, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);

        up1_2Knorr = Oblix_TestUtils.createUserPermission(ul1_2.Id, cbKnorrOF.Id, Oblix_Utils.USER_PERMISSION_APPROVER, Oblix_Utils.RT_USER_PERMISSION_UNILEVER_USER);

        insert new List<Oblix_User_Permission__c>{up1Dove, up1Knorr, up1Ambrosia, up2Dove, up2Knorr, up3Dove, up3Ciff, superuserDove, superuserKnorr, superuserAmbrosia, up1_2Knorr};

        Account agency = Oblix_TestUtils.createAccount();
        sowDove = Oblix_TestUtils.createTestMarketingSow('Dove SOW', Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, cbDovePC.brand_id__c, cbDovePC.product_Category_Id__c, bc.Id, agency.Id);
        sowKnorr = Oblix_TestUtils.createTestMarketingSow('Knorr SOW', Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, cbKnorrOF.brand_id__c, cbKnorrOF.product_Category_Id__c, bc.Id, agency.Id);
        sowAmbrosia = Oblix_TestUtils.createTestMarketingSow('Ambrosia SOW', Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, cbAmbrosiaOF.brand_id__c, cbAmbrosiaOF.product_Category_Id__c, bc.Id, agency.Id);
        sowCiff = Oblix_TestUtils.createTestMarketingSow('Ciff SOW', Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, cbCiffPC.brand_id__c, cbCiffPC.product_Category_Id__c, bc.Id, agency.Id);
        sowInvalidBrandCatComb = Oblix_TestUtils.createTestMarketingSow('SOW invalid', Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, bCiff.Id, scOF.Id, bc.Id, agency.Id);
        insert new List<Marketing_SOW__c>{sowDove, sowKnorr, sowAmbrosia, sowCiff};
        update new List<Marketing_SOW__c>{sowDove, sowKnorr, sowAmbrosia, sowCiff};
        system.assertNotEquals(NULL, sowInvalidBrandCatComb, 'Expecting sowInvalidBrandCatComb to be populated');

    }
    
}