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
public with sharing class Win_UploadEndpoint_Test {

    private static String TEST_DEVICE = 'testdevice';
    private static String TQ_ONE = 'TquilaONE';
    private static String ACCOUNT = 'Account';

	/*
     * Test a simple insertion
     */
	static testMethod void simpleInsertTest() {
        Win_Local_Assignment__c testRecord = new Win_Local_Assignment__c(Device_Id__c = 'SimpleTestAccoun', 
        	Local_Id__c = 'oneoneone', Salesforce_Id__c = 'accentureone');
        insert testRecord;
        
        List<Win_UploadRequestItem> requestItems = new List<Win_UploadRequestItem>{
            new Win_UploadRequestItem(
                'Win_Local_Assignment__c', 'Local_Id',
                '{"Id" : "Local_Id", "Name" : "Test Account Name 2", "LastModifiedById" : "Fake_Id"}'
            ),
            
            new Win_UploadRequestItem(
                'Win_Local_Assignment__c', testRecord.Id,
                '{"Id" : "' + testRecord.Id + '", "IsDeleted" : true}'
            )
        };      

        
        Win_UploadResponse response = Win_UploadEndpoint.uploadRequest(TQ_ONE, requestItems, TEST_DEVICE);
        System.assertEquals(0, response.getStatus());
        System.assert(response.body.get(0).success);
        System.assert(response.body.get(0).responseId != null);
        System.assertNotEquals(response.body.get(0).requestId, response.body.get(0).responseId);
        System.assert(response.body.get(1).success);
        response.getError();
        response.getStatus();
        
        List<Win_Local_Assignment__c> resultRecords = [SELECT Id FROM Win_Local_Assignment__c WHERE Id = : testRecord.Id];
        System.assertEquals(0, resultRecords.size());

        Win_UploadService service = new Win_UploadService();
        testRecord = new Win_Local_Assignment__c(Device_Id__c = 'SimpleTestAcco', Local_Id__c = 'oneone', Salesforce_Id__c = 'accenture');
        service.insertForceSharing(testRecord);
        service.updateForceSharing(testRecord);
    }

    /*
     * Test multiple insertions
     */
    static testMethod void testMultipleRequestWithReassignment() {
        List<Win_UploadRequestItem> requestItems = new List<Win_UploadRequestItem>{
            new Win_UploadRequestItem(
                'Contact', 'Local_Id_2',
                '{"Id" : "Local_Id_2", "Name" : "Nik", "LastName": "Tassini", "AccountId" : "Local_Id"}'
            ),
            new Win_UploadRequestItem(
                ACCOUNT, 'Local_Id',
                '{"Id" : "Local_Id", "Name" : "Test Account Name 35", "LastModifiedById" : "Fake_Id"}'
            ),
            new Win_UploadRequestItem(
                ACCOUNT, '0012000001C'+ '' + 'zRAbAAN',
                '{"Id" : "00120000'+ '' + '01CzRAbAAN", "Name" : "Test Account Name 2", "LastModifiedById" : "Fake_Id", "IsDeleted" : true}'
            ),
            new Win_UploadRequestItem(
                'Contact', 'Local_Id_3',
                '{"Id" : "Local_Id_3", "Name" : "Ale", "LastName": "Valentini",  "AccountId" : "Local_Id_XXX"}'
            )
        };
        
        Win_UploadResponse response = Win_UploadEndpoint.uploadRequest(TQ_ONE, requestItems, TEST_DEVICE);
        System.assertEquals(0, response.getStatus());
        System.assert(response.body.get(0).success);        
        System.assert(response.body.get(1).success);
        System.assert(!response.body.get(2).success);
        System.assert(!response.body.get(3).success);
    }

    /*
     * test update with a local Id
     */
    static testMethod void testSecondRequest() {
        List<Win_UploadRequestItem> requestItems = new List<Win_UploadRequestItem>{
            new Win_UploadRequestItem(
                ACCOUNT, 'Local_Id',
                '{"Id" : "Local_Id", "Name" : "Test Account Name 35", "LastModifiedById" : "Fake_Id"}'
            )
        };
        
        Win_UploadResponse response = Win_UploadEndpoint.uploadRequest(TQ_ONE, requestItems, TEST_DEVICE);
        System.assertEquals(0, response.getStatus());
        System.assert(response.body.get(0).success);
        
        response = Win_UploadEndpoint.uploadRequest(TQ_ONE, requestItems, 'testdevice');
    }

    /*
     * Test DML batch inserts
     */
    static testMethod void testDmlBatchesInsert() {
    	Win_UploadEndpoint.EXECUTE_DML_BY_RECORD_LIMIT = 2;
    	
        List<Win_UploadRequestItem> requestItems = new List<Win_UploadRequestItem>{
            new Win_UploadRequestItem(
                ACCOUNT, 'Local_Id',
                '{"Id" : "Local_Id", "Name" : "Test Account Name 35", "LastModifiedById" : "Fake_Id"}'
            )
        };
        
        requestItems.addAll(Win_TestUtils.createTQUploadRequestItemList(2));

        Win_UploadResponse response = Win_UploadEndpoint.uploadRequest(TQ_ONE, requestItems, TEST_DEVICE);
        System.assertEquals(0, response.getStatus());
        System.assert(response.body.get(0).success);        
        System.assert(response.body.get(1).success);
        System.assert(response.body.get(2).success);
    }

    /*
     * Test DML batch deletions
     */
    static testMethod void testDmlBatchesDelete() {
    	Win_UploadEndpoint.EXECUTE_DML_BY_RECORD_LIMIT = 2;
    	//create Accounts 
    	List<Win_Local_Assignment__c> aL = Win_TestUtils.createRecords(4);
    	insert aL;
    	
    	List<Win_UploadRequestItem> requestItems = Win_TestUtils.createTQUploadRequestItemList(aL, 'Win_Local_Assignment__c', '"IsDeleted" : true');

        Win_UploadResponse response = Win_UploadEndpoint.uploadRequest(TQ_ONE, requestItems, TEST_DEVICE);
        System.assertEquals(0, response.getStatus());
        System.assert(response.body.get(0).success);        
        System.assert(response.body.get(1).success);
        System.assert(response.body.get(3).success);
        
    }
    
    /*
     * Test DML batch updates
     */
    static testMethod void testDmlBatchesUpdate() {
    	Win_UploadEndpoint.EXECUTE_DML_BY_RECORD_LIMIT = 2;
    	//create Accounts 
    	List<Win_Local_Assignment__c> aL = Win_TestUtils.createRecords(4);
    	insert aL;
    	
    	List<Win_UploadRequestItem> requestItems = Win_TestUtils.createTQUploadRequestItemList(aL, 'Win_Local_Assignment__c', '"LastModifiedById" : "Fake_Id"');

        Win_UploadResponse response = Win_UploadEndpoint.uploadRequest(TQ_ONE, requestItems, TEST_DEVICE);
        System.assertEquals(0, response.getStatus());
        System.assert(response.body.get(0).success);        
        System.assert(response.body.get(1).success);
        System.assert(response.body.get(3).success);
        
    }
    
    /*
     * Test Chatter feeds
     */
    //@IsTest(SeeAllData=true)
    /*
    static void testFeedItem() {
    	Win_UploadRequestItem reqItem = new Win_UploadRequestItem();
    	Win_Utils winUtils = new Win_Utils();
    	Win_Local_Assignment__c a = Win_TestUtils.createRecord(1);
        insert a;
        
        List<Win_UploadRequestItem> requestItems = new List<Win_UploadRequestItem>{
            new Win_UploadRequestItem(
                'FeedItem', 'Local_Id',
                '{"Id" : "Local_Id", "Type" : "TextPost", "Body" : "Test", "ParentId" : "' + a.Id + '"}'
            ),
            new Win_UploadRequestItem(
                'FeedItem', 'Local_Id_1',
                '{"Id" : "Local_Id_1", "Type" : "ContentPost", "Body" : "Test", "ParentId" : "' + a.Id + '", "ContentFileName" : "file.txt", "ContentData" : "' + 
                	EncodingUtil.base64Encode(Blob.valueOf('data data dataaa')) +'"}'
            )
        };

        Win_UploadResponse response = Win_UploadEndpoint.uploadRequest('TquilaONE', requestItems, 'testdevice');
        System.assertEquals(0, response.getStatus());
        //System.assert(response.body.get(0).success);
        
        response = Win_UploadEndpoint.uploadRequest('TquilaONE', requestItems, 'testdevice');
    }
    */

}