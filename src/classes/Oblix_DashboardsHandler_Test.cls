@isTest
private class Oblix_DashboardsHandler_Test {
	
	//private static final String PROJECT_TXT = 'Project';
	private enum Permission {CAN_EDIT, CAN_DELETE, CAN_APPROVE, CAN_REJECT, CAN_SUBMIT, CAN_DELETE_ATTACHMENT, CAN_ADD_ATTACHMENT, CAN_MANAGE_CAMPAIGN, CAN_MANAGE_NON_CAMPAIGN}

	private static Marketing_SOW__c mSow;
    private static Oblix_SOW_Projects__c sowProject;
	/*private static User ul1;
	private static User ul2;
	private static User ul3;
	private static User superuser;

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
    }*/

	// TODO: add user-brand UserPermission records that define approvers and test approval buttons
    private static void initTestData(){

    	/*Map<String, User> testUsers = Oblix_TestUtils.createTestUsers();
    	ul1 = testUsers.get('UL1');
    	ul2 = testUsers.get('UL2');
    	ul3 = testUsers.get('UL3');
    	superuser = testUsers.get('superuser');*/

        insert Oblix_TestUtils.createOblixCustomSettings();

        User currentUser = new User(Id = UserInfo.getUserId());
        System.runAs(currentUser) {
            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);
            mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);
            Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_test = Oblix_TestUtils.insertCampaignsWithRelatedRecords(3,5,5,mSow.Id,'Total turnover >€400m', 'Global campaign (all market clusters)', 'Up to 4 locations', 'New – Multi channel');
            Oblix_TestUtils.createMarketingBasics(mSow.Id);
            sowProject = Oblix_TestUtils.createSowProjects('Test Project MP' , mSow.Id);
            //Oblix_TestUtils.createProjectAssets(sowProject.Id);
            Oblix_TestUtils.createProjectAssets(sowProject.Id,'Test Name', 'Audio Visual - Category', 'Origination Full');
            Oblix_TestUtils.createProjectAssets(sowProject.Id,'Test Name', 'Digital - Category', 'Digital Adaptation');

        }
    }

    @isTest 
    static void testDashboardsHandlerGenerateCampaignAssetTypesData() {

        String expectedJSON = '[["Audio Visual","2"],["Digital","2"],["Experiential","0"],["Static Imagery","0"],["Stimulus Materials","0"]]';
        initTestData();

        Oblix_DashboardsHandler controllerInstance = new Oblix_DashboardsHandler(Oblix_DashboardsHandler.Type.CAMPAIGN_ASSET_TYPES, sowProject.Id);

       
        Test.startTest();
        //List<List<Object>> lst_obj = controllerInstance.generateSOWScoresGraphData();

        Integer totAssets = controllerInstance.totalAssets;
        String graphData = controllerInstance.graphData;
        Integer assetTotal = controllerInstance.getAssetTotal();
        String valuesBeforeHyphen = controllerInstance.removeStringValuesAfterHyphen('/');


   
        Test.stopTest();    

        System.DEBUG('Graph Data : ' + graphData);
        System.assertEquals(expectedJSON,graphData);

    }

    @isTest 
    static void testDashboardsHandlerGenerateGraphDataFullFee() {

        String expectedJSON = '[[{"type":"string","label":""},{"type":"number","label":"# of Campaigns"},{"type":"number","label":"Campaign Fee"}],["S",{"v":"0","f":"0%"},{"v":"0","f":"0%"}],["S/M",{"v":"0","f":"0%"},{"v":"0","f":"0%"}],["M",{"v":"0","f":"0%"},{"v":"0","f":"0%"}],["M/L",{"v":"0","f":"0%"},{"v":"0","f":"0%"}],["L",{"v":"75","f":"75%"},{"v":"100","f":"100%"}]]';
        initTestData();

        Oblix_DashboardsHandler controllerInstance = new Oblix_DashboardsHandler(Oblix_DashboardsHandler.Type.SOW_SCORES_FULL_FEE, mSow.Id);

       
        Test.startTest();
        //List<List<Object>> lst_obj = controllerInstance.generateSOWScoresGraphData();

        Integer totAssets = controllerInstance.totalAssets;
        String graphData = controllerInstance.graphData;
        Integer assetTotal = controllerInstance.getAssetTotal();
        String valuesBeforeHyphen = controllerInstance.removeStringValuesAfterHyphen('/');


   
        Test.stopTest();    
        System.DEBUG('Graph Data : ' + graphData);
        System.assertEquals(expectedJSON,graphData);
    }

    @isTest 
    static void testDashboardsHandlerGenerateGraphDataFYFee() {

        String expectedJSON = '[[{"type":"string","label":""},{"type":"number","label":"# of Campaigns"},{"type":"number","label":"Campaign Fee"}],["S",{"v":"0","f":"0%"},{"v":"0","f":"0%"}],["S/M",{"v":"0","f":"0%"},{"v":"0","f":"0%"}],["M",{"v":"0","f":"0%"},{"v":"0","f":"0%"}],["M/L",{"v":"0","f":"0%"},{"v":"0","f":"0%"}],["L",{"v":"75","f":"75%"},{"v":"100","f":"100%"}]]';
        initTestData();

        Oblix_DashboardsHandler controllerInstance = new Oblix_DashboardsHandler(Oblix_DashboardsHandler.Type.SOW_SCORES_FY_FEE, mSow.Id);

       
        Test.startTest();
        //List<List<Object>> lst_obj = controllerInstance.generateSOWScoresGraphData();

        Integer totAssets = controllerInstance.totalAssets;
        String graphData = controllerInstance.graphData;
        Integer assetTotal = controllerInstance.getAssetTotal();
        String valuesBeforeHyphen = controllerInstance.removeStringValuesAfterHyphen('/');


   
        Test.stopTest();    
        System.DEBUG('Graph Data : ' + graphData);
        System.assertEquals(expectedJSON,graphData);
    }
	
}