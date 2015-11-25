/**********************************************************************
Name: WINatPOSUtil
Copyright © 2015 Unilever.
============================================================================
============================================================================
Purpose: Test class for WINatPOSUtil
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Pawel Niedziela         24/11/2015     INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class WINatPOSUtil_Test {

	/*******************************************************************
    Purpose: Method testing adding sharing
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testHandleAssetAgenciesShares(){
    	
    	List<Asset__c> assetsList = new List<Asset__c>();
    	
    	
    	Group test1 = new Group();
		test1.Name = 'Win@POS_Test1';
		insert test1;
		
		List<Group> winAtPosPublicGroups = [SELECT Name, Id FROM Group WHERE Name like 'Win@POS%' ORDER BY Name];

        Asset__c asset = new Asset__c();
        asset.Name = 'Uniq Test Asset';
        asset.Placement__c = 'Primary';
        asset.POS_Asset_Type__c = 'Masterbrand';
        asset.Market_Cluster__c = 'Global';
        asset.Channels__c = 'Cash & Carry;Convenience';
        asset.Status__c = 'Approved';
        asset.Country__c = 'UK';
        asset.Description__c = 'test';
        assetsList.add(asset);
        
        Test.startTest();
        	System.assert(winAtPosPublicGroups.size() > 0);
        	insert assetsList;
        	
        	System.assert([SELECT Id FROM Asset__Share].size() == 0);
        	
        	assetsList[0].Agency_Edit_Access_Text__c = winAtPosPublicGroups[0].Name;
        	
        	update assetsList;
        	
        	System.assert([SELECT Id FROM Asset__Share].size() == 1);
        	System.assert([SELECT Id, AccessLevel FROM Asset__Share].get(0).AccessLevel == 'Edit');
        
        Test.stopTest();
    }
    
    /*******************************************************************
    Purpose: Method testing adding sharing
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testHandleAssetAgenciesShares2(){
    	
    	List<Asset__c> assetsList = new List<Asset__c>();
    	
    	Group test1 = new Group();
		test1.Name = 'Win@POS_Test1';
		insert test1;
		
		Group test2 = new Group();
		test2.Name = 'Win@POS_Test2';
		insert test2;
		
    	List<Group> winAtPosPublicGroups = [SELECT Name, Id FROM Group WHERE Name like 'Win@POS%' ORDER BY Name];
    	
        Asset__c asset = new Asset__c();
        asset.Name = 'Uniq Test Asset';
        asset.Placement__c = 'Primary';
        asset.POS_Asset_Type__c = 'Masterbrand';
        asset.Market_Cluster__c = 'Global';
        asset.Channels__c = 'Cash & Carry;Convenience';
        asset.Status__c = 'Approved';
        asset.Country__c = 'UK';
        asset.Description__c = 'test';
        assetsList.add(asset);
        
        Test.startTest();
			System.assert(winAtPosPublicGroups.size() > 1);
			
			assetsList[0].Agency_Read_Access_Text__c = winAtPosPublicGroups[0].Name + ';' + winAtPosPublicGroups[1].Name;
			
        	insert assetsList;
        	
        	System.assert([SELECT Id FROM Asset__Share].size() == 2);
        	System.assert([SELECT Id, AccessLevel FROM Asset__Share].get(0).AccessLevel == 'Read');
        	System.assert([SELECT Id, AccessLevel FROM Asset__Share].get(1).AccessLevel == 'Read');
        
        Test.stopTest();
    }
}