/**********************************************************************
Name: OV_ChatterServiceImpl_Test
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: TEst for OV_ChatterServiceImpl
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Dan Harfleet            24/06/2015      INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class OV_ChatterServiceImpl_Test {
    public static final String ADMIN_NAME                 = 'utest';
    public static final String CATEGORY1_LABEL            = 'Category 1';
    public static final String GEOGRAPHY1_LABEL           = 'Geography 1';
    public static final String FUNCTION1_LABEL            = 'Function 1';
    public static final String COMPARATOR1_LABEL          = 'Comparator 1';
    public static final String BRAND1_LABEL               = 'Brand 1';
    public static final String RAPORT1_LABEL              = 'Report 1';
    public static final String KPINAME1_LABEL             = 'KPIName1';
    public static final String KPIELEMENT1_LABEL          = 'KPIElement1';
    public static final String DEVICE_DESKTOP             = 'Desktop';
    public static final String WEEK_LABEL                 = 'Week';
    
	private static void assertRecordIsFollowedByUser(Id recordId, Id userId) {
		List<EntitySubscription> follows = [SELECT ParentId, SubscriberId FROM EntitySubscription where ParentId = :recordId AND SubscriberId = :userId];
		System.assertEquals(follows.size(), 1);
	}

	private static void assertRecordIsNotfollowedByUser(Id recordId, Id userId) {
		List<EntitySubscription> follows = [SELECT ParentId, SubscriberId FROM EntitySubscription where ParentId = :recordId AND SubscriberId = :userId];
		System.assertEquals(follows.size(), 0);
	}

	@isTest static void testFollow() {
		Integer random = Math.floor(Math.random() * 10000).intValue();
		String email = 'ovutest' + random + '@example.com';
		User record = OV_TestingHelper.createAdminUser(ADMIN_NAME, email, ADMIN_NAME + random);
		Id currentUserId = UserInfo.getUserId();

		Test.startTest();
		OV_ChatterServiceImpl.follow(currentUserId, record.Id, true);
		EntitySubscription result = OV_ChatterServiceImpl.follow(currentUserId, record.Id, true);
		System.assertEquals(result, null);
		Test.stopTest();

		assertRecordIsFollowedByUser(record.Id, currentUserId);
	}

	@isTest static void testUnfollow() {
		Integer random = Math.floor(Math.random() * 10000).intValue();
		String email = 'ovutest' + random + '@example.com';
		User record = OV_TestingHelper.createAdminUser(ADMIN_NAME, email, ADMIN_NAME + random);
		Id currentUserId = UserInfo.getUserId();
		
		Test.startTest();
		OV_ChatterServiceImpl.unfollow(currentUserId, record.Id);
		Test.stopTest();

		assertRecordIsNotfollowedByUser(record.Id, currentUserId);
	}

	@isTest static void testFollowUnFollowReport() {
		Id currentUserId = UserInfo.getUserId();

		OV_Category__c category1 = OV_TestingHelper.initCategory(CATEGORY1_LABEL, true);

        OV_Geography__c geography1 = OV_TestingHelper.initGeography(GEOGRAPHY1_LABEL, true);

        OV_Function__c function1 = OV_TestingHelper.initFunction(FUNCTION1_LABEL, true);

        OV_Report__c report1 = OV_TestingHelper.initReport(RAPORT1_LABEL, category1, function1, geography1, DEVICE_DESKTOP, true);

		
		OV_ChatterService service = new OV_ChatterServiceImpl();

		Test.startTest();

		service.followReport(report1.Id);

		assertRecordIsFollowedByUser(report1.Id, currentUserId);

		service.unfollowReport(report1.Id);

		assertRecordIsNotfollowedByUser(report1.Id, currentUserId);

		service.followReport(report1);

		Test.stopTest(); 

		assertRecordIsFollowedByUser(report1.Id, currentUserId);
		
	}
	
	@isTest static void testFollowKPIElement() {
		Id currentUserId = UserInfo.getUserId();

		OV_Brand__c brand1 = OV_TestingHelper.initBrand(BRAND1_LABEL, true);
        OV_Comparator__c comparator1 = OV_TestingHelper.initBrandComparator(COMPARATOR1_LABEL, true);

		OV_Category__c category1 = OV_TestingHelper.initCategory(CATEGORY1_LABEL, true);

        OV_Geography__c geography1 = OV_TestingHelper.initGeography(GEOGRAPHY1_LABEL, true);

        OV_Function__c function1 = OV_TestingHelper.initFunction(FUNCTION1_LABEL, true);

        OV_Report__c report1 = OV_TestingHelper.initReport(RAPORT1_LABEL, category1, function1, geography1, DEVICE_DESKTOP, true);

        OV_KPI_Name__c kpiName1 = OV_TestingHelper.initKPIName(KPINAME1_LABEL, true);

        OV_KPI_Element__c kpiElement1 = OV_TestingHelper.initKPIElement(KPIELEMENT1_LABEL, brand1, comparator1, category1, 'UP', function1, geography1, kpiName1, 1.1, report1, 2.1, WEEK_LABEL, true);
	
		OV_ChatterService service = new OV_ChatterServiceImpl();

		Test.startTest();

		service.followKPIElement(kpiElement1.Id, true);

		Test.stopTest();
		
		assertRecordIsFollowedByUser(kpiElement1.Id, currentUserId);
	}
	
	@isTest static void testFollowKPIElementObject() {
		Id currentUserId = UserInfo.getUserId();

		OV_Brand__c brand1 = OV_TestingHelper.initBrand(BRAND1_LABEL, true);

        OV_Comparator__c comparator1 = OV_TestingHelper.initBrandComparator(COMPARATOR1_LABEL, true);

		OV_Category__c category1 = OV_TestingHelper.initCategory(CATEGORY1_LABEL, true);

        OV_Geography__c geography1 = OV_TestingHelper.initGeography(GEOGRAPHY1_LABEL, true);

        OV_Function__c function1 = OV_TestingHelper.initFunction(FUNCTION1_LABEL, true);

        OV_Report__c report1 = OV_TestingHelper.initReport(RAPORT1_LABEL, category1, function1, geography1, DEVICE_DESKTOP, true);

        OV_KPI_Name__c kpiName1 = OV_TestingHelper.initKPIName(KPINAME1_LABEL, true);

        OV_KPI_Element__c kpiElement1 = OV_TestingHelper.initKPIElement(KPIELEMENT1_LABEL, brand1, comparator1, category1, 'UP', function1, geography1, kpiName1, 1.1, report1, 2.1, WEEK_LABEL, true);
	
		OV_ChatterService service = new OV_ChatterServiceImpl();

		Test.startTest();

		service.followKPIElement(kpiElement1, true);

		Test.stopTest();
		
		assertRecordIsFollowedByUser(kpiElement1.Id, currentUserId);
	}
	
	@isTest static void testFollowKPIElementInterest() {
		Id currentUserId = UserInfo.getUserId();

		OV_Brand__c brand1 = OV_TestingHelper.initBrand(BRAND1_LABEL, true);
        OV_Category__c category1 = OV_TestingHelper.initCategory(CATEGORY1_LABEL, true);
        OV_Comparator__c comparator1 = OV_TestingHelper.initBrandComparator(COMPARATOR1_LABEL, true);
        OV_Function__c function1 = OV_TestingHelper.initFunction(FUNCTION1_LABEL, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography(GEOGRAPHY1_LABEL, true);

        OV_KPI_Name__c kpiName1 = OV_TestingHelper.initKPIName(KPINAME1_LABEL, true);        
        OV_Report__c report1 = OV_TestingHelper.initReport(RAPORT1_LABEL, category1, function1, geography1, DEVICE_DESKTOP, true);

        OV_KPI_Element__c kpiElement1 = OV_TestingHelper.initKPIElement(KPIELEMENT1_LABEL, brand1, comparator1, category1, 'UP', function1, geography1, kpiName1, 1.1, report1, 2.1, WEEK_LABEL, true);

        List<OV_Wrapper.KPINameWrapper> kpiNamesList = OV_KPIService.getKPINames();
        System.assertEquals(kpiName1.Name, kpiNamesList[0].kpiNameName);

        List<OV_Wrapper.ReportWrapper> reports = OV_KPIService.getReports(kpiName1.Id);
       
        List<OV_Wrapper.KPIElementWrapper> kpiElementsList = OV_KPIService.getKPIElements(kpiName1.Id, report1.Id);

        User u = OV_TestingHelper.createAdminUser('test', 'test@test.com', 'test2');
        OV_Profile__c profile = OV_TestingHelper.initProfile('Profile1', u, true);

        System.runAs(u){
            OV_KPIService.addKPIElementToMyKPIs(kpiElementsList[0].kpiElementId, true);
        }

        List<OV_KPI_Element_Interest__c> objIntrests = [SELECT Id, KPI_Element__c, User__c, Wants_Notifications__c FROM OV_KPI_Element_Interest__c WHERE KPI_Element__c =:kpiElementsList[0].kpiElementId];

        System.assertEquals(profile.Id, objIntrests[0].User__c);
        
        OV_ChatterService service = new OV_ChatterServiceImpl();

        Test.startTest(); 

		service.followKPIElementInterest(objIntrests[0].Id, true);

		Test.stopTest();

		assertRecordIsFollowedByUser(objIntrests[0].Id, currentUserId);
	}
    
    @isTest static void testFollowKPIElementInterestObject() {
		Id currentUserId = UserInfo.getUserId();

		OV_Brand__c brand1 = OV_TestingHelper.initBrand(BRAND1_LABEL, true);
        OV_Category__c category1 = OV_TestingHelper.initCategory(CATEGORY1_LABEL, true);
        OV_Comparator__c comparator1 = OV_TestingHelper.initBrandComparator(COMPARATOR1_LABEL, true);
        OV_Function__c function1 = OV_TestingHelper.initFunction(FUNCTION1_LABEL, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography(GEOGRAPHY1_LABEL, true);

        OV_KPI_Name__c kpiName1 = OV_TestingHelper.initKPIName(KPINAME1_LABEL, true);        
        OV_Report__c report1 = OV_TestingHelper.initReport(RAPORT1_LABEL, category1, function1, geography1, DEVICE_DESKTOP, true);

        OV_KPI_Element__c kpiElement1 = OV_TestingHelper.initKPIElement(KPIELEMENT1_LABEL, brand1, comparator1, category1, 'UP', function1, geography1, kpiName1, 1.1, report1, 2.1, WEEK_LABEL, true);

        List<OV_Wrapper.KPINameWrapper> kpiNamesList = OV_KPIService.getKPINames();
        System.assertEquals(kpiName1.Name, kpiNamesList[0].kpiNameName);

        List<OV_Wrapper.ReportWrapper> reports = OV_KPIService.getReports(kpiName1.Id);
       
        List<OV_Wrapper.KPIElementWrapper> kpiElementsList = OV_KPIService.getKPIElements(kpiName1.Id, report1.Id);

        User u = OV_TestingHelper.createAdminUser('test', 'test@test.com', 'test2');
        OV_Profile__c profile = OV_TestingHelper.initProfile('Profile1', u, true);

        System.runAs(u){
            OV_KPIService.addKPIElementToMyKPIs(kpiElementsList[0].kpiElementId, true);
        }

        List<OV_KPI_Element_Interest__c> objIntrests = [SELECT Id, KPI_Element__c, User__c, Wants_Notifications__c FROM OV_KPI_Element_Interest__c WHERE KPI_Element__c =:kpiElementsList[0].kpiElementId];

        System.assertEquals(profile.Id, objIntrests[0].User__c);
        
        OV_ChatterService service = new OV_ChatterServiceImpl(currentUserId);

        Test.startTest(); 

		service.followKPIElementInterest(objIntrests[0], true);

		Test.stopTest();

		assertRecordIsFollowedByUser(objIntrests[0].Id, currentUserId);        
	}	
}