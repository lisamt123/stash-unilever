/*************************************************************** 
    Name: Win_MetadataEndpoint_Test
    Copyright © 2016 Accenture
    ======================================================
    Purpose:
    -------
    Testing class for the MetadataEndpoint API
    ======================================================
    History
    -------
    VERSION     AUTHOR          DATE        DETAIL          Description
    1.0         Nicola Tassini  31/01/2017  Initial Dev     First version
***************************************************************/
@isTest
public with sharing class Win_MetadataEndpoint_Test {

    /**
    *   Test tracking utils
    */
    @isTest(SeeAllData=False)
    static void TQTrackingUtils_Test(){
        Test.startTest();
        list<Win_Tracked_Object_Config__c> trackedObjConfigList = Win_TestUtils.createTrackedObjConfigCustomSettings();
        insert trackedObjConfigList;
        Win_TrackingUtils.getObjects('TquilaONE');
        
        Win_TrackingUtils.FieldSetSelectionCriteria param = new Win_TrackingUtils.FieldSetSelectionCriteria();
        param.objectAPIName = 'Account';
        param.fieldSetName = 'testFieldSetName';
        param.enforceIsAccessible = false;
        param.enforceIsCreateable = false;
        param.enforceIsRequired = false;
        param.enforceIsUpdateable = false;
        Win_TrackingUtils.splitList('Id,Name,OwnerId,CreatedDate,LastModifiedDate');
        Test.stopTest();
    }
    
    /**
    *   Test metadata response
    */
    @isTest(SeeAllData=False)
    static void TQMetadataResponse_Test(){
        
        Win_MetadataResponse.Win_MetadataResponseFieldSet restFS = new Win_MetadataResponse.Win_MetadataResponseFieldSet('Name',new List<String>{'Id','OwnerId','LastModifiedDate','CreatedDate'});
        restFS.getFieldList();
        restFS.getName();
        
        Win_MetadataResponse.Win_MetadataResponseItem resItem = new Win_MetadataResponse.Win_MetadataResponseItem();
        resItem.getObjectApiName();
        resItem.getLayoutNeeded();
        resItem.getDisplayable();
        resItem.getFieldSetList();
        resItem.setFieldSetList(new List<Win_MetadataResponse.Win_MetadataResponseFieldSet>{restFS});
        resItem.getObjectCustomIndexList();
        resItem.setDetailFieldSet(restFS.getFieldList());
        resItem.getDetailFieldSet();
        resItem.setListHeaderFieldSet(restFS.getFieldList());
        resItem.getListHeaderFieldSet();
    }
    
    /**
    *   Test exception
    */
    @isTest(SeeAllData=False)
    static void TQException_Test(){
        Win_Exception exp = new Win_Exception(2);
        system.assert(exp.getErrorCode() == 2);
        exp.setErrorCode(3);
        system.assert(exp.getErrorCode() == 3);
    }

    /**
    *   Test tracking utils
    */
    @isTest(SeeAllData=False)
    static void objectAPINamesTest() {
        String clientAppId = 'TestingONE';
        String objectAPIName = 'Case';

        Win_Tracked_Object_Config__c t1TrackedObjConfig2 = new Win_Tracked_Object_Config__c();
        t1TrackedObjConfig2.Active__c = true;
        t1TrackedObjConfig2.ClientApp_ID__c = clientAppId;
        t1TrackedObjConfig2.Name = objectAPIName;
        t1TrackedObjConfig2.Object_Api_Name__c = objectAPIName;
        insert t1TrackedObjConfig2;

        Win_MetadataService service = new Win_MetadataService();
        service = new Win_MetadataService(clientAppId);

        List<String> objs = service.trackedObjectsAPINames(clientAppId);
        System.assert(objs != null);

        System.assert(service.trackedObjectAccessible(objectAPIName) != null);
        System.assert(service.trackedObjectLayouts(objectAPIName) != null);
        System.assert(service.trackedObjectDisplayable(objectAPIName) != null);
        System.assert(service.trackedObjectOnlyMetadataNeeded(objectAPIName) != null);
        System.assert(service.trackedObjectCustomIndexList(objectAPIName) != null);
        System.assert(service.trackedObjectFieldSetList(objectAPIName) != null);
        System.assert(service.trackedObjectFieldSets(objectAPIName) != null);
        System.assert(service.getFieldDescriptionMap(objectAPIName) != null);
        System.assert(service.trackedObjectHeaderFieldSet(objectAPIName) != null);
        System.assert(service.trackedObjectDefaultValues(objectAPIName) != null);
        System.assert(service.getSystemFieldSet(objectAPIName) != null);
        System.assert(service.getNameField(objectAPIName) != null);
        System.assert(service.getAllFieldSet(objectAPIName) != null);

        List<String> fieldSetTest = new List<String>();
        System.assert(service.getFullRecordFieldSet(objectAPIName, fieldSetTest) != null);
        System.assert(service.getCreateableFieldSet(objectAPIName, fieldSetTest) != null);
        System.assert(service.getUpdateableFieldSet(objectAPIName, fieldSetTest) != null);
    }

    /**
    *   Test tracking utils
    */
    @isTest(SeeAllData=False)
    static void TestRunningUser() {
        User running = Win_TrackingUtils.getCurrentUser();
        System.assert(running != null);
        System.assertEquals(UserInfo.getUserId(), running.Id);
    }

    /**
    *   Metadata testing
    */
    @isTest(SeeAllData=False)
    static void TestMetadataResponse() {
        Win_MetadataResponse response = new Win_MetadataResponse();
        System.assert(Win_MetadataResponse.SERVER_ERROR_CUSTOMSETTING < 0);
        System.assert(Win_MetadataResponse.SERVER_ERROR_OBJECTNOTFOUND < 0);
        
        Win_MetadataResponse.Win_MetadataResponseItem item = new Win_MetadataResponse.Win_MetadataResponseItem();
        item.setObjectApiName('Case');
        item.setOnlyMetadataNeeded(false);
        System.assert(!item.getOnlyMetadataNeeded());

        item.setLayoutNeeded(false);
        System.assert(!item.getLayoutNeeded());

        item.setDisplayable(false);
        System.assert(!item.getDisplayable());

        item.setOnlyMetadataNeeded(true);
        System.assert(item.getOnlyMetadataNeeded());

        item.setObjectCustomIndexList(new List<String>());
        System.assert(item.getObjectCustomIndexList() != null);

        item.defaultValuesMap = new Case();
        item.editFieldSet = new List<String>();
        item.createFieldSet = new List<String>();
        item.rawRecordFieldSet = new List<String>();

        List<Win_MetadataResponse.Win_MetadataResponseItem> items = new List<Win_MetadataResponse.Win_MetadataResponseItem>();
        items.add(item);
        response.setBody(items);
        System.assert(response.getBody() != null);
    }

}