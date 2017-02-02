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
    
    @isTest(SeeAllData=False)
    static void TQException_Test(){
        Win_Exception exp = new Win_Exception(2);
        system.assert(exp.getErrorCode() == 2);
        exp.setErrorCode(3);
        system.assert(exp.getErrorCode() == 3);
    }	
}