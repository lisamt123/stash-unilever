/**********************************************************************
Name: TEL_OppGenController_Test
Copyright © 2016 Unilever
======================================================
Purpose: Class to test the class: TEL_OppGenController_Test.

History 
VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	Ronaldo Garcia  	26/12/2016  Class Creation
***********************************************************************/
@isTest
public class TEL_OppGenController_Test {
    
    @testSetup
    public static void createData() {
        TEL_Segment__c  		segmentObj 		= new TEL_Segment__c (Name = 'Test', Value__c = 'Test');
        Insert segmentObj;
        
        TEL_Sub_Segment__c   	subSegmentObj 	= new TEL_Sub_Segment__c (Name = 'Test', Value__c = 'Test');
        Insert subSegmentObj;
        
        TEL_Product_Family__c  	familyObj		= new TEL_Product_Family__c (Name = 'Test', Value__c = 'Test');
        Insert familyObj;
        
        TEL_Frequency__c  		frequencyObj	= new TEL_Frequency__c (Name = 'Test', Value__c = 'Test');
        Insert frequencyObj;
        
        TEL_OTM__c  			OTMObj			= new TEL_OTM__c (Name = 'Test', Value__c = 'Test');
        Insert OTMObj;
        
        Pricebook2 p 							= new Pricebook2(Name = 'Telesales UK');
        insert p;
        
        Account accObj 			= new Account();
        accObj.Name				= 'Test Class';
        accObj.TEL_OTM__c		= 'A';
        accObj.Segment__c		= 'Test';
        accObj.SubSegment__c	= 'Test';
        accObj.RecordTypeId 	= [SELECT Id FROM RecordType WHERE DeveloperName = 'Standard' LIMIT 1].Id;
        System.Database.insert(accObj);
        
        Campaign camObj			= new Campaign(Name = 'Test', isActive = true);
        System.Database.insert(camObj);
        
        TEL_Campaign_Accounts__c campAccObj = new TEL_Campaign_Accounts__c();
        campAccObj.TEL_Account__c = accObj.Id;
        campAccObj.TEL_Campaign__c = camObj.Id;
        System.Database.insert(campAccObj);
        
    }
    
    // Test the retrieved segment. 
    static testMethod void testSegment(){
        List<String> lstSegment = new List<String>();
        lstSegment = TEL_OppGenController.searchSegment();
        system.assert(!lstSegment.isEmpty());
    }
    
    // Test the retrieved subSegment. 
    static testMethod void testSubSegment(){
        List<String> lstSubSegment = new List<String>();
        lstSubSegment = TEL_OppGenController.searchSubSegment();
        system.assert(!lstSubSegment.isEmpty());
    }
    
    // Test the retrieved returnFamily. 
    static testMethod void testFamily(){
        List<String> lstFamily = new List<String>();
        lstFamily = TEL_OppGenController.returnFamily();
        system.assert(!lstFamily.isEmpty());
    }
    
    // Test the retrieved OTM. 
    static testMethod void testOTM(){
        List<String> lstOTM = new List<String>();
        lstOTM = TEL_OppGenController.searchOTM();
        system.assert(!lstOTM.isEmpty());
    }
    
    // Test the retrieved Frequency. 
    static testMethod void testFrequency(){
        List<String> lstFrequency = new List<String>();
        lstFrequency = TEL_OppGenController.frequencyOppGeneration();
        system.assert(!lstFrequency.isEmpty());
    }
    
    // Test the retrieved search accounts. 
    static testMethod void testSearchAccount(){
        List<TEL_TelesalesWrapper.DisplayAccounts> lstAccounts1 = new List<TEL_TelesalesWrapper.DisplayAccounts>();
        List<TEL_TelesalesWrapper.DisplayAccounts> lstAccounts2 = new List<TEL_TelesalesWrapper.DisplayAccounts>();
        List<TEL_TelesalesWrapper.DisplayAccounts> lstAccounts3 = new List<TEL_TelesalesWrapper.DisplayAccounts>();
        List<TEL_TelesalesWrapper.DisplayAccounts> lstAccounts4 = new List<TEL_TelesalesWrapper.DisplayAccounts>();
        List<TEL_TelesalesWrapper.DisplayAccounts> lstAccounts5 = new List<TEL_TelesalesWrapper.DisplayAccounts>();
        List<TEL_TelesalesWrapper.DisplayAccounts> lstAccounts6 = new List<TEL_TelesalesWrapper.DisplayAccounts>();
        List<TEL_TelesalesWrapper.DisplayAccounts> lstAccounts7 = new List<TEL_TelesalesWrapper.DisplayAccounts>();
        List<TEL_TelesalesWrapper.DisplayAccounts> lstWrapperD  = new List<TEL_TelesalesWrapper.DisplayAccounts>();
        lstAccounts1 = TEL_OppGenController.searchAccounts('A', 'None', 'None');
        lstAccounts2 = TEL_OppGenController.searchAccounts('None', 'Test', 'None');
        lstAccounts3 = TEL_OppGenController.searchAccounts('None', 'None', 'Test');
        lstAccounts4 = TEL_OppGenController.searchAccounts('A', 'Test', 'None');
        lstAccounts5 = TEL_OppGenController.searchAccounts('A', 'Test', 'Test');
        lstAccounts6 = TEL_OppGenController.searchAccounts('None', 'Test', 'Test');
        lstAccounts7 = TEL_OppGenController.searchAccounts('A', 'None', 'Test');
        system.assert(!lstAccounts1.isEmpty());
        system.assert(!lstAccounts2.isEmpty());
        system.assert(!lstAccounts3.isEmpty());
        system.assert(!lstAccounts4.isEmpty());
        system.assert(!lstAccounts5.isEmpty());
        system.assert(!lstAccounts6.isEmpty());
        system.assert(!lstAccounts7.isEmpty());
    }
    
    static testMethod void createOpp() {
        List<TEL_TelesalesWrapper.DisplayAccounts> accList = new List<TEL_TelesalesWrapper.DisplayAccounts>();
        TEL_TelesalesWrapper.DisplayAccounts acc = new TEL_TelesalesWrapper.DisplayAccounts();
        acc.isSelected = true;
        acc.accountId = [SELECT Id FROM Account LIMIT 1].Id;
        accList.add(acc);
        
        String accountsJSON = JSON.serialize(accList);
        
        System.Test.startTest();
        TEL_OppGenController.createOpp(accountsJSON, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'One Week', 'Standarad Sales', [SELECT Id FROM Campaign LIMIT 1].Id);
        System.Test.stopTest();
    }
    
    static testMethod void createAccCampaign() {
        List<TEL_TelesalesWrapper.DisplayAccounts> accList = new List<TEL_TelesalesWrapper.DisplayAccounts>();
        TEL_TelesalesWrapper.DisplayAccounts acc = new TEL_TelesalesWrapper.DisplayAccounts();
        acc.isSelected = true;
        acc.accountId = [SELECT Id FROM Account LIMIT 1].Id;
        accList.add(acc);
        
        String accountsJSON = JSON.serialize(accList);
        
        System.Test.startTest();
        TEL_OppGenController.createAccCampaign(accountsJSON, [SELECT Id FROM Campaign LIMIT 1].Id);
        System.Test.stopTest();
    }
    
}