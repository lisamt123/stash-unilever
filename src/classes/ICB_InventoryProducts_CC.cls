/**********************************************************************
Name: ICB_InventoryProducts_CC
Copyright © 2016 Unilever

Purpose:
Controller class for lightning component 
ICB_ProductInvetoryBody.cmp

History
VERSION AUTHOR    		DATE 		DETAIL 			Description
1.0    Thiago Oliveira 04/08/2016  Class creation  
***********************************************************************/
public with sharing class ICB_InventoryProducts_CC
{
    public static List<PriceBookEntry> listPB;
    private static final String CONST_TYPE_LIST;
    Static
    {
        listPB = new List<PriceBookEntry>();
        CONST_TYPE_LIST = 'List<ICB_Inventory_Line_Item__c>';
    }
    
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
        contact contato = new contact();
        
        try
        {
            String strUserId = UserInfo.getUserId();
            String strContactId = ICB_ContactDAO.getInstance().getContactId(strUserId);
            contato = ICB_ContactDAO.getInstance().getContact(strContactId);
            String strAccountName = ICB_AccountDAO.getInstance().getAccount(contato);
            inventory = ICB_InventoryDAO.getInstance().getInventory(strAccountName);
            inventoryLineItem = ICB_InventoryLineItemDAO.getInstance().getIventoryLineList(inventory);
            
        }
        catch (Exception e)
        {
            system.debug(Label.ICB_ERROR_MESSAGE +  e.getCause());
           
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
    public static List<ICB_Inventory_Line_Item__c> updateOperatorInventory(String listJson)
    {
        System.debug('Entering <222>: ' + listJson);
        System.debug('Entering <updateOperatorInventory>: ' + JSON.serializePretty(listJson));
        List<ICB_Inventory_Line_Item__c> lineItems = deserializeJSON(listJson);
        system.debug('Lista de Inventory:'+ lineItems);
        try
        {
            Database.update(lineItems);
            system.debug('Exiting <updateOperatorInventory>');
            return lineItems;
        }
        catch(Exception e)
        {
            system.debug(Label.ICB_ERROR_MESSAGE  +  e.getCause());
            system.debug('Exiting <updateOperatorInventory>');
            return null;
        }
    }
    
    /*******************************************************************
    Purpose: Retrieve PriceBookEntry 
    Parameters: None
    Returns: None
    Throws [Exceptions]: Exception
    ********************************************************************/ 
    @AuraEnabled
    public static List<PriceBookEntry> getProductPrice() 
    {
        System.debug('Entering <getProductPrice>');
        String strAccountName 	= null;
        String strContactId 	= null;
        
        try {
            strContactId = ICB_ContactDAO.getInstance().getContactId(UserInfo.getUserId());
            
            Contact contato = ICB_ContactDAO.getInstance().getContact(strContactId);
            
            strAccountName = ICB_AccountDAO.getInstance().getAccount(contato); 
            listPB = ICB_PriceBookEntryDAO.getInstance().getPricebook(strAccountName);
            system.debug('listPB:'+ listPB);
          } 
        catch (Exception e) 
        {   
            system.debug(Label.ICB_ERROR_MESSAGE +  e.getCause());
        }
        System.debug('Exiting <getProductPrice>');
        return listPB;
        
    }
    
    /*******************************************************************
    Purpose: Update PriceBookEntry based in list
    Parameters: @listProduct
    Returns: None
    Throws [Exceptions]: Exception
    ********************************************************************/
    @AuraEnabled
    public static List<PriceBookEntry> updateValues(List<PriceBookEntry> listProduct) 
    {
        System.debug('Entering <updateValues>: '+ JSON.serializePretty(listProduct));
        try 
        {
            Database.update(listProduct);
            System.debug('Exiting <updateValues>');
            return listProduct;
        } 
        catch (Exception e) 
        {
            system.debug(Label.ICB_ERROR_MESSAGE +  e.getCause());
            System.debug('Exiting <updateValues>');
            return null;
        }
    }
    
     private static List<ICB_Inventory_Line_Item__c> deserializeJSON(String jsonList)
    {
        System.debug('Entering <deserializeJSON>: '+ jsonList);
        Type idArrType=Type.forName(CONST_TYPE_LIST);
        List<ICB_Inventory_Line_Item__c> listInventories = (List<ICB_Inventory_Line_Item__c>) JSON.deserialize(jsonList, idArrType);
        System.debug('Exiting <deserializeJSON>: ' + JSON.serializePretty(listInventories));
        return listInventories;
    } 
    
}