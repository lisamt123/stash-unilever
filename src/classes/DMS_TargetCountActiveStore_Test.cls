/**********************************************************************
Name: DMS_ActiveStore_Test
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
    
    
    public static Target__c fireTargetTrigger(id contactId,id userId,id storeId,String saleschannel){
        if(userId !=null){
            DMS_SObjectInstance_Test.createAccountTeam(userId,storeId,true);
        }
        Target__c target;
        //flow of sucess
        target = DMS_SObjectInstance_Test.createTarget(contactId,saleschannel,true);                        
        return target;
    }
    
    public static testMethod void testActiveStore(){
        system.runAs(ownerUser){   
            String channel = '001';
            String channel2 = '002';
            Target__c target;
            Account accountDistributor = DMS_SObjectInstance_Test.createAccount('Distributor','DistributorCode', null, null, DMS_RecordTypeMemory.getRecType('Account', 'Distributor'), ownerUser.id,NULL, true);
            Account accountStore = DMS_SObjectInstance_Test.createAccount('Store1','Store1Code', accountDistributor.id, 'APROV', DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer'), ownerUser.id, channel, true);
            Account accountStoreSameChannel = DMS_SObjectInstance_Test.createAccount('Store2','Store2Code', accountDistributor.id, 'APROV', DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer'), ownerUser.id, channel, true);        
            Account accountStoreDiferentChannel = DMS_SObjectInstance_Test.createAccount('Store3','Store3Code', accountDistributor.id, 'APROV', DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer'), ownerUser.id, channel2, true);
            Contact contact1 = DMS_SObjectInstance_Test.createContact(accountDistributor.Id,'Test', null,true);
            Contact contact2 = DMS_SObjectInstance_Test.createContact(accountDistributor.Id,'contactError', null, true);
            User createdUser = DMS_SObjectInstance_Test.createUserPartner(contact1.Id,'testTriggerTarget@test.com',true);                        
            
            target = fireTargetTrigger(contact1.id,createdUser.id,accountStore.id,channel);
            target = [SELECT ImpactedStores__c From Target__c WHERE id =: target.id];
            System.assert(target.ImpactedStores__c == 1);
            
            target = fireTargetTrigger(contact1.id,createdUser.id,accountStoreSameChannel.id,channel);
            target = [SELECT ImpactedStores__c From Target__c WHERE id =: target.id];
            System.assert(target.ImpactedStores__c == 2);
            
            target = fireTargetTrigger(contact1.id,createdUser.id,accountStoreDiferentChannel.id,channel2);            
            target = [SELECT ImpactedStores__c From Target__c WHERE id =: target.id];
            System.assert(target.ImpactedStores__c == 1);
            
            //flow of error            
            target = fireTargetTrigger(contact2.id,null,null,channel);
            target = [SELECT ImpactedStores__c From Target__c WHERE id =: target.id];
            System.assert(target.ImpactedStores__c == 0);                                              
        }                
    }
}