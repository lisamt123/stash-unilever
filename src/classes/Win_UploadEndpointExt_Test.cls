/*************************************************************** 
    Name: Win_UploadEndpoint_Test
    Copyright © 2016 Accenture
    ======================================================
    Purpose:
    -------
    Testing class for the UploadEndpoint API
    ======================================================
    History
    -------
    VERSION     AUTHOR          DATE        DETAIL          Description
    1.0         Nicola Tassini  31/01/2017  Initial Dev     First version
***************************************************************/
@isTest
private class Win_UploadEndpointExt_Test {

	private static String ACCOUNT = 'Account';
	
   	/*
     * Test tracked objects
     */
    @isTest(SeeAllData=False)
    static void TQUploadService_Test(){
        Win_TestUtils.createTrackedObjConfigCustomSetting();
        Win_UploadService tqUploadSer = new Win_UploadService();
        tqUploadSer.getUniqueArray(new list<String>{'1','2','3'});
    }
    
    /*
     * tracked objects with upload requests
     */
    @isTest(SeeAllData=False)
    static void TQUploadRequest_Test(){
        Win_TestUtils.createTrackedObjConfigCustomSetting();
        Win_UploadRequest req = new Win_UploadRequest();
        System.assert(req != null);
    }

    /*
     * Test getting fieldsets from the tracking objects
     */
    static testMethod void testGettFieldSetFields() {
		Win_TrackingUtils.FieldSetSelectionCriteria params = new Win_TrackingUtils.FieldSetSelectionCriteria();
		params.objectAPIName = ACCOUNT;
		params.fieldSetName = 'FieldSet';
		List<String> res = Win_TrackingUtils.getFieldSetFields(Win_TrackingUtils.getGlobalDescribe(), params);
		System.assertEquals(0, res.size());
	}

    /*
     * Test multiple insertions
     */
    static testMethod void testObjectFieldListMap() {
        Win_Utils utils = new Win_Utils();
        System.assert(utils != null);
        Win_UploadRequestItem item = new Win_UploadRequestItem();
        System.assert(item != null);
        Win_WebServiceResponse resp = new Win_UploadResponse();
        resp.getError();

        Win_Tracked_Object_Config__c t1TrackedObjConfig2 = new Win_Tracked_Object_Config__c();
        t1TrackedObjConfig2.Active__c = true;
        t1TrackedObjConfig2.ClientApp_ID__c = 'TestingONE';
        t1TrackedObjConfig2.Name = 'Case';
        t1TrackedObjConfig2.Object_Api_Name__c = 'Case';
        insert t1TrackedObjConfig2;

        Win_UploadService service = new Win_UploadService('TestingONE');
        //Win_TestUtils.createTrackedObjConfigCustomSetting();
        Map<String, List<String>> result = service.getObjectFieldListMap();
        System.assert(result != null);
    }

    /*
     * Test multiple insertions
     */
    static testMethod void testFeed() {
        FeedItem item = new FeedItem();
        Map<String, Object> additionalDataMap = new Map<String, Object>();
        additionalDataMap.put('ChatterPostContentFileName', 'nameeee');
        additionalDataMap.put('ChatterPostContentDataBlob', Blob.valueof('Jimmyyy'));
        Win_UploadEndpoint.post(item, additionalDataMap);
        System.assert(additionalDataMap != null);
    }

    /*
     * Test multiple insertions
     */
    static testMethod void testObjectPreparation() {
        Win_UploadService service = new Win_UploadService();
        Map<String, Object> additionalData = new Map<String, Object>();
        Map<String, Object> dataMap = new Map<String, Object>();
        service.prepareAdditionalData(additionalData, dataMap, 'testing', 'Jimmyyy');
    }


}