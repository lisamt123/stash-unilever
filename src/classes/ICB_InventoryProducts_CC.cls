/**********************************************************************
Name: ICB_InventoryProducts_CC
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Controller class for lightning component 
ICB_ProductInvetoryBody.cmp
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
1.0    Thiago Oliveira 04/08/2016  Class creation  
***********************************************************************/
public with sharing class ICB_InventoryProducts_CC
{
    
    /*******************************************************************
    Purpose: Retrieve products to show in component productInventoryBody
    Parameters: None
    Returns: List<ICB_Inventory_Line_Item__c>
    Throws [Exceptions]: Exception
    ********************************************************************/
    @AuraEnabled
    public static List<ICB_Inventory_Line_Item__c> getProducts()
    {
        system.debug('Entering <getProducts>');
        
        ICB_Inventory__c  inventory = new ICB_Inventory__c();
        List<ICB_Inventory_Line_Item__c> inventoryLineItem = new List<ICB_Inventory_Line_Item__c>();
        List<Product2> product = new List<Product2>();
        contact contato = new contact();
        List<User> userList = new List<User>();
        try
        {
            
            String strUserId = UserInfo.getUserId();
            
            system.debug('strUserId:'+ strUserId);
            
            String strContactId = ContactDAO.getInstance().getContactId(strUserId);
            system.debug('strContactId:'+ strContactId);
            
            
            contato = ContactDAO.getInstance().getContact(strContactId);
            system.debug('contato:'+ contato);
            
            String strAccountName = AccountDAO.getInstance().getAccount(contato);
            system.debug('Entering <contato>:'+ contato);
            System.debug('Entering <contato.AccountId>: '+contato.AccountId);
            
            inventory = ICB_InventoryDAO.getInstance().getIventory(strAccountName);
            
            inventoryLineItem = ICB_InventoryLineItemDAO.getInstance().getIventoryLineList(inventory);
            
        }
        catch(Exception e)
        {
            system.debug('Exception: ' + e.getMessage());
        }
        system.debug('Exiting <inventoryLineItem>: '+ inventoryLineItem);
        return inventoryLineItem;
    }
    
    /*******************************************************************
    Purpose: Retrieve products to show in component productInventoryBody
    Parameters: @lineItems
    Returns: None
    Throws [Exceptions]: Exception
    ********************************************************************/ 
    @AuraEnabled
    public static void updateOperatorInventory(List<ICB_Inventory_Line_Item__c> lineItems)
    {
        System.debug('Entering <updateOperatorInventory>');
        try
        {
            system.debug('lineItems1:'+ lineItems);
            for(ICB_Inventory_Line_Item__c inventory: lineItems){
                inventory.ICB_Quantity_Boxes__c += inventory.ICB_Quantity_ToBe_Updated__c;
                inventory.ICB_Quantity_ToBe_Updated__c = 0;
                inventory.ICB_Quantity_Unit__c =  inventory.ICB_Quantity_Boxes__c * inventory.ICB_Product__r.ICB_Reference_Unit__c;
            }
            system.debug('lineItems2:'+ lineItems);
            database.update(lineItems);
            
        }
        catch(Exception e)
        {
            system.debug('Exception: ' + e.getMessage()+e.getCause()+e.getLineNumber());
        }
        system.debug('Exiting <updateOperatorInventory>');
    }
    
    
     public static List<PriceBookEntry> listPB = new List<PriceBookEntry>();

   //00519000000PPjb 
    @AuraEnabled
    public static List<PriceBookEntry> getProductPrice() {
        system.debug('Starting method: getProducts');
        String strAccountName 	= null;
        String strContactId 	= null;
        
        try {
            strContactId = ContactDAO.getInstance().getContactId(UserInfo.getUserId());
            
            Contact contato = ContactDAO.getInstance().getContact(strContactId);
            
            strAccountName = AccountDAO.getInstance().getAccount(contato);
            
            listPB = PriceBookEntryDAO.getInstance().getPricebook(strAccountName);            
            
        } catch (Exception e) {   
            system.debug('Method getProducts error: ' + e.getCause());
        }
        system.debug('Finishing method: getProducts');
        return listPB;
        
    }
    
    @AuraEnabled
    public static void updateValues(List<PriceBookEntry> listProduct) {
        System.debug('Entering <listProduct>: '+listProduct);
        if(listProduct.isEmpty()) {
            return;
        } else {
        	Database.update(listProduct);    
        }
    }

}