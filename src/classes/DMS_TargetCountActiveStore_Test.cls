/**********************************************************************
Name: DMS_ActiveStore_Test
Copyright © 2016 Salesforce
====================================================== 
====================================================== 
Purpose: 
Class for test the trigger DMS_ActiveStore
====================================================== 
======================================================
History 

VERSION     AUTHOR              DATE        Description
1.0     DIMITRI M. SANTANA   02/06/2016     INITIAL DEVELOPMENT

***********************************************************************/
@isTest
public class DMS_TargetCountActiveStore_Test {
    private static User ownerUser = DMS_SObjectInstance_Test.createUserRunTest();
       
    
    private static Target__c createTarget(Id userIdParam,String saleschannel){
        Target__c target = new Target__c();
        //ownerUser.ContactId = contactTest.Id;
        target.SalesRep__c = userIdParam;
        target.SalesChannel__c = saleschannel;
        target.Frequency__c = 0;
        target.TargetDate__c = Date.today();
        target.Target_Key__c='';
        target.CurrencyIsoCode = 'EUR';
        target.Dropsize__c = 0;
        target.Sellout__c = 0;
        target.Orders__c = 0;
        target.Status__c = 'ACT';
        
        return target;
    }
    
    
    private static void createAccountTeam(id userIdParam, id accountIdParam){
        AccountTeamMember aTeam = new AccountTeamMember();
        aTeam.AccountId = accountIdParam;
        aTeam.UserId = userIdParam;
        Database.insert(aTeam);       
    }
    public static Target__c fireTargetTrigger(id contactId,id userId,id storeId,String saleschannel){
        if(userId !=null){
        	createAccountTeam(userId,storeId);
        }
        Target__c target;
            //flow of sucess
            target = createTarget(contactId,saleschannel);            
            Database.insert(target); 
        return target;
    }
    
    public static testMethod void testActiveStore(){
        system.runAs(ownerUser){             
            Target__c target;
            Account accountDistributor = DMS_SObjectInstance_Test.createAccount('Distributor','DistributorCode', null, null, DMS_RecordTypeMemory.getRecType('Account', 'Distributor'), ownerUser.id,NULL, true);
            Account accountStore = DMS_SObjectInstance_Test.createAccount('Store1','Store1Code', accountDistributor.id, 'APROV', DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer'), ownerUser.id, '001', true);
            Account accountStoreSameChannel = DMS_SObjectInstance_Test.createAccount('Store2','Store2Code', accountDistributor.id, 'APROV', DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer'), ownerUser.id, '001', true);        
            Account accountStoreDiferentChannel = DMS_SObjectInstance_Test.createAccount('Store3','Store3Code', accountDistributor.id, 'APROV', DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer'), ownerUser.id, '002', true);
            Contact contact1 = DMS_SObjectInstance_Test.createContact(accountDistributor.Id,'Test', null);
            Contact contact2 = DMS_SObjectInstance_Test.createContact(accountDistributor.Id,'contactError', null);
            User createdUser = DMS_SObjectInstance_Test.createUserParthner(contact1.Id);
                
            //User createdUser = [SELECT id FROM User where contactId =: contact1.id];
                                    
            target = fireTargetTrigger(contact1.id,createdUser.id,accountStore.id,'001');
            target = [SELECT ImpactedStores__c From Target__c WHERE id =: target.id];
            System.assert(target.ImpactedStores__c == 1);
                                     
            target = fireTargetTrigger(contact1.id,createdUser.id,accountStoreSameChannel.id,'001');
             target = [SELECT ImpactedStores__c From Target__c WHERE id =: target.id];
            System.assert(target.ImpactedStores__c == 2);
            
            target = fireTargetTrigger(contact1.id,createdUser.id,accountStoreDiferentChannel.id,'002');            
            target = [SELECT ImpactedStores__c From Target__c WHERE id =: target.id];
            System.assert(target.ImpactedStores__c == 1);
            
            //flow of error            
            target = fireTargetTrigger(contact2.id,null,null,'001');
            target = [SELECT ImpactedStores__c From Target__c WHERE id =: target.id];
            System.assert(target.ImpactedStores__c == 0);                                              
        }                
    }
}