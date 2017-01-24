/**********************************************************************
Name: TEL_ProductInfo_CC_DAO
Copyright © 2016 Unilever

Purpose:
Handles all the operations regarding access to Salesforce database coming
from TEL_Product_CC.apxc

History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Diego Maranhão  22/11/2016  Class creation  
***********************************************************************/
public with sharing class TEL_ProductInfo_CC_DAO {
    
    //Returns Opportunity object based on given Id
    public static Opportunity getOpportunity(String oppId) {
        return [SELECT Id, 
                AccountId, 
                CloseDate,
                Pricebook2Id,
                StageName
                FROM Opportunity 
                WHERE Id =: oppId LIMIT 1];
    } 
    
    //Returns a List<TEL_Campaign_Accounts__c> based on given Account Id
    public static List<TEL_Campaign_Accounts__c> getAccountCampaigns(String accountId) {
        return [SELECT TEL_Campaign__c,
                TEL_Campaign__r.IsActive
                FROM TEL_Campaign_Accounts__c
                WHERE TEL_Account__c =: accountId LIMIT 10000];
    }
    
    //Returns a List<TEL_Campaign_Products__c> based on list of ids of TEL_Campaign_Accounts__c
    public static List<TEL_Campaign_Products__c> getActiveCampaignsProducts(List<String> activeCampaignsIdsListParam) {
        return [SELECT Id,
                TEL_Campaign__r.Name,
                TEL_Product_Name__c, 
                TEL_Product_Name__r.Name
                FROM TEL_Campaign_Products__c
                WHERE TEL_Campaign__c =: activeCampaignsIdsListParam LIMIT 10000];
    }
    
    //Returns most recent Transmitted Opportunity based on Account Id
    public static List<Opportunity> getMostRecentOpportunity(String accountId) {
        return [SELECT Id,
                CloseDate
                FROM Opportunity
                WHERE AccountId =: accountId
                AND StageName =: Label.TEL_OppStageTransmitted 
                ORDER BY CloseDate DESC LIMIT 1];
    }
    
    //Returns a List<OpportunityLineItem> based on given Opportunity Id
    public static List<OpportunityLineItem> getOppLineitems(String oppIdParam) {
        return [SELECT Id,
                Product2Id,
                Product2.Name,
                Quantity,
                UnitPrice,
                TEL_Associated_Campaigns__c
                FROM OpportunityLineItem
                WHERE OpportunityId =: oppIdParam LIMIT 10000];
    }
    
    //Returns a List<PricebookEntry> based on given list of products ids
    public static List<PricebookEntry> getPrices(List<String> productsIds) {
        return [SELECT Id,
                UnitPrice,
                Product2Id
                FROM PricebookEntry
                WHERE Product2Id =: productsIds LIMIT 10000];
    }
    
    //Returns a List<PricebookEntry> based on given Opportunity Id and list of products ids
    public static List<PricebookEntry> getPricebookEntry(String oppId, List<String> productsIdsList) {
        String pricebookId = [SELECT Pricebook2Id 
                              FROM Opportunity 
                              WHERE Id =: oppId].Pricebook2Id;
        
        
        return [SELECT Id,
                Product2Id
                FROM PricebookEntry 
                WHERE Pricebook2Id =: pricebookId
                AND Product2Id =: productsIdsList];
    }
    
    //Inserts given List<OpportunitylineItem>
    public static void createOppLineItems(List<OpportunitylineItem> oppLineItemList) {
        System.debug('ENTERING createOppLineItems');
        
        Database.insert(oppLineItemList);
        
        System.debug('EXITING createOppLineItems');
    }
    
    //Updates StageName of given Opportunity object
    public static void updateOppStage(Opportunity oppObjParam) {
        System.debug('ENTERING updateOppStage');
        
        Database.update(oppObjParam);
        
        System.debug('EXITING updateOppStage');
    }

}