/**********************************************************************
Name: ICB_Cockpit_CC_DAO
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
DAO class for controller ICB_Cockpit
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
1.0    	Antonio Raul 	25/08/2016  Class creation 
***********************************************************************/
public with sharing class ICB_Cockpit_CC_DAO 
{
    private static final String CONST_STAGE_CLOSED;
    private static final String CONST_STAGE_PENDING;
    private static final String CONST_STAGE_AVAILABLE;
    private static final String CONST_FAMILY_IMPULSE;
    
    Static
    {
        CONST_STAGE_CLOSED = 'Closed';
        CONST_STAGE_PENDING = 'Pending';
        CONST_STAGE_AVAILABLE = 'Available';
        CONST_FAMILY_IMPULSE = 'Impulse';
    }
    
    /*******************************************************************
    Purpose: Retrieve list of opportunities when operation is closed
    Parameters: NONE
    Returns: List<Opportunity>
    Throws [Exceptions]: NONE
    ********************************************************************/
    public static List<Opportunity> returnListOppClosed(Map<Id,Contact> mapContact)
    {
        System.debug('Entering <returnListOppClosed>');
        List<Opportunity> oppList = [SELECT 	id,
                                                Name,
                                                CreatedDate,
                                                StageName,
                                                ICB_Contact__c,
                                     			ICB_Contact__r.ICB_Type__c,
                                                OwnerId,
                                                Amount,
                                                ICB_OLD_QUANTITY_RETURNED__c,
                                                ICB_Total_Sold_Price__c,
                                     			ICB_Sales_Locale__c,
                                     			ICB_Sales_Locale_List__c
                                    FROM Opportunity 
                                    WHERE ICB_Contact__c =: mapContact.keySet() 
                                    AND (StageName = :CONST_STAGE_PENDING OR StageName = :CONST_STAGE_AVAILABLE OR StageName = :CONST_STAGE_CLOSED)
                                    ORDER BY CreatedDate DESC];
        System.debug('Exiting <returnListOppClosed>: ' + JSON.serializePretty(oppList));
        return oppList;
    }
    /*******************************************************************
    Purpose: Retrieve list of opportunities when operation is Open
    Parameters: NONE
    Returns: List<Opportunity>
    Throws [Exceptions]: NONE
    ********************************************************************/
    public static List<Opportunity> returnListOppOpen(Map<Id,Contact> mapContact)
    {
        System.debug('Entering <returnListOppOpen>');
        List<Opportunity> oppList = [SELECT 	id,
                                                Name,
                                                StageName,
                                                OwnerId,
                                                Amount,	
                                                ICB_Contact__c,
                                     			ICB_Contact__r.ICB_Type__c,
                                                ICB_OLD_QUANTITY_RETURNED__c,
                                                ICB_Total_Sold_Price__c,
                                     			ICB_Sales_Locale__c,
                                     			ICB_Sales_Locale_List__c
                                    FROM Opportunity 
                                    WHERE ICB_Contact__c =: mapContact.keySet()
                                    AND (StageName = :CONST_STAGE_PENDING OR StageName = :CONST_STAGE_AVAILABLE)];
        System.debug('Exiting <returnListOppOpen>: ' + JSON.serializePretty(oppList));
        return oppList;
    }
    /*******************************************************************
    Purpose: Retrieve list of opportunity line items when operation is closed
    Parameters: NONE
    Returns: List<OpportunityLineItem>
    Throws [Exceptions]: NONE
    ********************************************************************/
    public static List<OpportunityLineItem> returnListOppItem(Map<Id,Contact> mapContact)
    {
        System.debug('Entering <returnListOppItemClosed>');
        List<OpportunityLineItem> oppLineItemList =  [SELECT  Id,
                                                              Name,
                                                              Quantity,
                                                              ICB_STATUS_SALES__c,
                                                              Opportunity.OwnerId,
                                                              ICB_ITEMS_RETURNED__c, 
                                                              ICB_Total_Purchase_Price__c,
                                                              ICB_Purchase_Price__c 
                                                      FROM OpportunityLineItem 
                                                      WHERE Opportunity.ICB_Contact__c =: mapContact.keySet() 
                                                      AND (Opportunity.StageName = :CONST_STAGE_PENDING OR Opportunity.StageName = :CONST_STAGE_AVAILABLE 
                                                           OR Opportunity.StageName = :CONST_STAGE_CLOSED)]; 
        System.debug('Exiting <returnListOppItemClosed>: ' + JSON.serializePretty(oppLineItemList));
        return oppLineItemList;
    }
    /*******************************************************************
    Purpose: Retrieve list of opportunity line items
    Parameters: NONE
    Returns: List<OpportunityLineItem>
    Throws [Exceptions]: NONE
    ********************************************************************/
    public static List<OpportunityLineItem> getInventoriesOppLineItemList()
    {
        System.debug('Entering <getInventoriesOppLineItemList>');
        List<OpportunityLineItem> oppLineList = [SELECT  Quantity,
                                                         Product2Id,
                                                         Opportunity.StageName,
                                                         Opportunity.OwnerId,
                                                         ICB_IS_CLOSED__c,
                                                         Opportunity.ICB_Contact__c, 
                                                         ICB_STATUS_SALES__c,
                                                         ICB_ITEMS_RETURNED__c
                                                 FROM OpportunityLineItem 
                                                 WHERE (Opportunity.CreatedDate <=: System.Now() AND Opportunity.CreatedDate >: System.Now().addDays(-6)) 
                                                 AND (Opportunity.StageName =: CONST_STAGE_CLOSED OR Opportunity.StageName =: CONST_STAGE_PENDING 
                                                      OR Opportunity.StageName =: CONST_STAGE_AVAILABLE) 
                                                 AND ICB_IS_CLOSED__c = FALSE ];
        System.debug('Exiting <getInventoriesOppLineItemList>: ' + JSON.serializePretty(oppLineList));
        return oppLineList;
    }
    /*******************************************************************
    Purpose: Retrieve list of inventory line items
    Parameters: NONE
    Returns: List<OpportunityLineItem>
    Throws [Exceptions]: NONE
    ********************************************************************/
    public static List<ICB_Inventory_Line_Item__c> getInventoriesIventoryLineItem(String accountName)
    {
        System.debug('Entering <getInventoriesIventoryLineItem>');
        List<ICB_Inventory_Line_Item__c> inventoryList = [SELECT    id,
                                                                    Name,
                                                                    ICB_Product__r.Name,
                                                                    ICB_Inventory__r.Name,
                                                                    ICB_Product__r.Family,
                                                                    ICB_Product__c,
                                                                    ICB_Product__r.Product_Image__c, 
                                                                    ICB_Quantity_Unit__c 
                                                            FROM ICB_Inventory_Line_Item__c 
                                                            WHERE ICB_Inventory__r.Name =: accountName 
                                                            AND ICB_Product__r.Family =: CONST_FAMILY_IMPULSE AND ICB_Product__r.isActive = true];
        System.debug('Exiting <getInventoriesIventoryLineItem>: ' + JSON.serializePretty(inventoryList));
        return inventoryList;
    }
    /*******************************************************************
    Purpose: Retrieve list of opportunity line items
    Parameters: NONE
    Returns: List<OpportunityLineItem>
    Throws [Exceptions]: NONE
    ********************************************************************/
    public static List<OpportunityLineItem> updateOppItemListOppItem(Map<String,PriceBookEntry> mapPriceBook)
    {
         System.debug('Entering <updateOppItemListOppItem>');
        List<OpportunityLineItem> oppItemList = [SELECT 	Id,
                                                           OpportunityId,
                                                           TotalPrice, 
                                                           ICB_STATUS_SALES__c,
                                                           ICB_ITEMS_RETURNED__c,
                                                           PriceBookEntry.Name,
                                                           Quantity,
                                                           PriceBookEntryId 
                                                   FROM OpportunityLineItem 
                                                   WHERE PriceBookEntryId =: mapPriceBook.keySet() 
                                                   AND Opportunity.StageName <>: CONST_STAGE_CLOSED];
        System.debug('Exiting <updateOppItemListOppItem>: ' + JSON.serializePretty(oppItemList));
        return oppItemList;
    }
}