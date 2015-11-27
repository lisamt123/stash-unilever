/**********************************************************************
Name: WINatPOS_AssetService_Test
Copyright © 2015 Unilever.
============================================================================
============================================================================
Purpose: Test class for WINatPOS_AssetService_Test
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Pawel Niedziela        23/11/2015     INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class WINatPOS_AssetService_Test {

    static testMethod void testDeleteAsset1() {
    	
    	Profile p = [select Id, Name from Profile where Name  = 'Unilever Way - Marketing - System Administrator Lite' limit 1];
    	Profile profileSystemAdmin = [select Id, Name from Profile where Name  = 'System Administrator' limit 1];
        //create test data
        User testUser = new User(
				profileId = p.id, 
				username = 'testXXX@test.com', 
				email = 'testXXX@test.com', 
				emailencodingkey = 'UTF-8', 
				localesidkey = 'en_GB', 
				languagelocalekey = 'en_US', 
				timezonesidkey = 'Europe/London', 
				alias='nuser', 
				lastname='lastname'
			);
		insert testUser;
		
		User testUserSystemAdmin = new User(
				profileId = profileSystemAdmin.id, 
				username = 'testXXXYYY@test.com', 
				email = 'testXXXYYY@test.com', 
				emailencodingkey = 'UTF-8', 
				localesidkey = 'en_GB', 
				languagelocalekey = 'en_US', 
				timezonesidkey = 'Europe/London', 
				alias='nuser', 
				lastname='lastname'
			);
		insert testUserSystemAdmin;
		
        Asset__c asset = new Asset__c();
        asset.Name = 'test';
        asset.Status__c = 'Approved';
        asset.POS_Asset_Type__c = 'Masterbrand';
        asset.Description__c = 'test';
        insert asset;
        
        String result = '';
        
        Test.startTest();
	        System.runAs(testUser){
	        	result = WINatPOS_AssetService.deleteAsset(asset.Id);
	        }
	       	
	       	System.assert(result != '');
	       	
	       	System.runAs(testUserSystemAdmin){
	       		result = WINatPOS_AssetService.deleteAsset(asset.Id);
	       	}
	       	
	       	System.assert(result == '');
	       	System.assert([SELECT Id FROM Asset__c WHERE Id = :asset.Id].size()==0);
	       	
        Test.stopTest();
    }
    
    static testMethod void testDeleteAsset2() {
    	
    	Profile p = [select Id, Name from Profile where Name  = 'Unilever Way - Marketing - System Administrator Lite' limit 1];
    	Profile profileSystemAdmin = [select Id, Name from Profile where Name  = 'System Administrator' limit 1];
        //create test data
        User testUser = new User(
				profileId = p.id, 
				username = 'testXXX@test.com', 
				email = 'testXXX@test.com', 
				emailencodingkey = 'UTF-8', 
				localesidkey = 'en_GB', 
				languagelocalekey = 'en_US', 
				timezonesidkey = 'Europe/London', 
				alias='nuser', 
				lastname='lastname'
			);
		insert testUser;
		
		User testUser2 = new User(
				profileId = p.id, 
				username = 'testXXXYYY@test.com', 
				email = 'testXXXYYY@test.com', 
				emailencodingkey = 'UTF-8', 
				localesidkey = 'en_GB', 
				languagelocalekey = 'en_US', 
				timezonesidkey = 'Europe/London', 
				alias='nuser', 
				lastname='lastname'
			);
		insert testUser2;
		
        Asset__c asset = new Asset__c();
        asset.Name = 'test';
        asset.Additional_Owner_1__c = testUser2.Id;
        asset.Status__c = 'Approved';
        asset.POS_Asset_Type__c = 'Masterbrand';
        asset.Description__c = 'test';
        insert asset;
        
        String result = '';
        
        Test.startTest();
	        System.runAs(testUser){
	        	result = WINatPOS_AssetService.deleteAsset(asset.Id);
	        }
	       	
	       	System.assert(result != '');
	       	
	       	System.runAs(testUser2){
	       		result = WINatPOS_AssetService.deleteAsset(asset.Id);
	       	}
	       	
	       	System.assert(result == '');
	       	System.assert([SELECT Id FROM Asset__c WHERE Id = :asset.Id].size()==0);
	       	
        Test.stopTest();
    }
}