/**********************************************************************
Name: DMS_Account_Test
Copyright © 2016 Salesforce
====================================================== 
====================================================== 
Purpose: 
Class used to test the trigger DMS_Account
====================================================== 
======================================================
History 

VERSION		AUTHOR			 DATE 	 	 Description
1.0		DIMITRI M. SANTANA	15/06/2016	INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class DMS_Account_Test {
    private Static final String SALES_CHANNEL = '001';
    private static testMethod void testTrigger()
    {
        Account account = DMS_SObjectInstance_Test.createAccount('ALTAMIRA','DMS_DISTRIBUTOR', null, null, '01219000000CiAT', UserInfo.getUserId(),null, true);
        account.Name = 'Teste';
        
        database.update(account);
         System.assertNotEquals(null, account);

    }
    
    private static testMethod void testTriggerUpdateTarget()
    {
        Account accountDistributor = DMS_SObjectInstance_Test.createAccount('Distributor','DistributorCode', null, null, DMS_RecordTypeMemory.getRecType('Account', 'Distributor'), UserInfo.getUserId(),NULL, true);
        Account accountStore = DMS_SObjectInstance_Test.createAccount('Store1','Store1Code', accountDistributor.id, 'DESAC', DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer'), UserInfo.getUserId(), SALES_CHANNEL, true);
        
        Contact contact1 = DMS_SObjectInstance_Test.createContact(accountDistributor.Id,'Test', null,true);
        User createdUser = DMS_SObjectInstance_Test.createUserPartner(contact1.Id,'AccountTrigger@test.com',true);                                 
        
        DMS_SObjectInstance_Test.createAccountTeam(createdUser.id,accountStore.Id,true);
        
        Target__c target = DMS_SObjectInstance_Test.createTarget(contact1.id,SALES_CHANNEL,true);                    
        target = [SELECT ImpactedStores__c From Target__c WHERE id =: target.id];
        System.assert(target.ImpactedStores__c == 0);
        
        accountStore.StoreStatus__c = 'APROV';
        Database.update(accountStore);
        target = [SELECT ImpactedStores__c From Target__c WHERE id =: target.id];        
        System.assert(target.ImpactedStores__c == 1);        
    }               
}