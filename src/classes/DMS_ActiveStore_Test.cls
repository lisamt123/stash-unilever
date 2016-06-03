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

VERSION 	AUTHOR		 		DATE  		Description
1.0		DIMITRI M. SANTANA	 02/06/2016		INITIAL DEVELOPMENT

***********************************************************************/
@isTest
public class DMS_ActiveStore_Test {
	private static User ownerUser = DMS_SObjectInstance_Test.createUserRunTest();
    private static Id userId = UserInfo.getUserId();
    
    private static Target__c createTarget(Id userIdParam){
        	Target__c target = new Target__c();
        
        	target.SalesRep__c = userIdParam;
            target.SalesChannel__c = DMS_GlobalConstants.ACCOUNT_SALES_CHANNEL;
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
    
    public static testMethod void testActiveStore(){
        system.runAs(ownerUser){
            Account accountDistributor = DMS_SObjectInstance_Test.createAccount(DMS_GlobalConstants.ACCOUNT_NAME,DMS_GlobalConstants.ACCOUNT_EXTERNAL_CODE, null, null, DMS_GlobalConstants.ACCOUNT_RECTYPE_DISTRIBUTOR, ownerUser.id,NULL, true);
            Account accountStore = DMS_SObjectInstance_Test.createAccount(DMS_GlobalConstants.ACCOUNT_NAME,DMS_GlobalConstants.ACCOUNT_EXTERNAL_CODE_STORE, accountDistributor.id, DMS_GlobalConstants.ACCOUNT_STATUS_APROV, DMS_GlobalConstants.ACCOUNT_RECTYPE_STORE, ownerUser.id, DMS_GlobalConstants.ACCOUNT_SALES_CHANNEL, true);        
        	
            //flow of sucess
        	Database.insert(createTarget(ownerUser.id));
            //flow of error
            Database.insert(createTarget(userId));           
            
        }                
    }
}