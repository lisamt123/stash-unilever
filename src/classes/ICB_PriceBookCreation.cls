/**********************************************************************
Name: ICB_PriceBookCreation
Copyright © 2016 Unilever

Purpose:
Class to create the PriceBook of the Items and the Inventory.

History
VERSION AUTHOR    		DATE 		DETAIL 			Description
1.0    Carlos Henrique 16/08/2016  Class creation  
***********************************************************************/
public with sharing class ICB_PriceBookCreation {
    
    private static Product2 prod = null;
    
    public ICB_PriceBookCreation() {
    }
     /*******************************************************************
    Purpose: Create and Edit priceBook and inventory when product is created and Edited.
    Parameters: None
    Returns: [Void]
    Throws [Exceptions]: Exception
	********************************************************************/
    @InvocableMethod
    public static void changeProductStructure(List<Id> product) 
    {
        try { 
            system.debug('Entering <changeProductStructure>');
            List<ICB_Inventory_Line_Item__c> iltList 	= new List<ICB_Inventory_Line_Item__c>();
            List<ICB_Inventory_Line_Item__c> vInventory = new List<ICB_Inventory_Line_Item__c>();
            
            //get the info of the Product 
            prod = ICB_Product2DAO.getInstance().getProduct(product.get(0));
            
            
            if (prod.IsActive) 
            {

                vInventory = ICB_InventoryLineItemDAO.getInstance().getProductInfo(product.get(0));
				system.debug('vInventory'+ vInventory);
                if(!vInventory.isEmpty()) {
                    updateInventory(true, vInventory, iltList);                       
                }
                
                //Create the StandardPriceBook(true) and the PriceBookEntry(False). 
                priceBookCreation(true);         
                priceBookCreation(false);        
                
                List<ICB_Inventory_Line_Item__c> UpdateInventory = new List<ICB_Inventory_Line_Item__c>(); 
                //Iterate over the Inventorys and insert the product on each of them.
                for(AggregateResult aggregateInventory : ICB_InventoryLineItemDAO.getInstance().getInventoryReference()) 
                {

                    UpdateInventory.add(createInventoryLI((Id) aggregateInventory.get('ICB_Inventory__c'), prod.Id));
                }
                system.debug('iltList:'+ UpdateInventory);
                Database.insert(UpdateInventory);
                
            } 
            else 
            {
                if(prod.Id != null)
                {
                    updateInventory(false, ICB_InventoryLineItemDAO.getInstance().getProductInfo(prod.Id), iltList);
                }
            }
            
        } catch (Exception e) {
            
            system.debug(LABEL.ICB_ERROR_MESSAGE + e.getMessage());
            system.debug('Exiting <changeProductStructure>: ');
        }
    }
    
    /*******************************************************************
    Purpose: Create Inventory Line Item
    Parameters: Inventory Id , Product Id.
    Returns: [CB_Inventory_Line_Item__c]
    Throws [Exceptions]: Exception
	********************************************************************/
    private static ICB_Inventory_Line_Item__c createInventoryLI(Id inventoryId, Id productId) {
        system.debug('Entering <createInventoryLI>');
        ICB_Inventory_Line_Item__c IvlineItem = new ICB_Inventory_Line_Item__c(ICB_Inventory__c = inventoryId,
                                                                               ICB_Product__c = productId,
                                                                               ICB_Active__c = TRUE,
                                                                               ICB_Quantity_Boxes__c = 0.00,
                                                                               ICB_Quantity_ToBe_Updated__c = 0.00,
                                                                               ICB_Quantity_Unit__c = 0.00,
                                                                               ICB_Unit_COnvertion__c = 0.00);
        system.debug('Exiting <createInventoryLI>');
        return IvlineItem;
        
    }
    
	/*******************************************************************
    Purpose: Create PriceBookEntry
    Parameters: Boolean
    Returns: [VOID]
    Throws [Exceptions]: Exception
	********************************************************************/    
    private static void priceBookCreation(Boolean value) 
    {
        try
        {
            system.debug('Entering <PriceBookcreation>' + value);
            Map<Id, Set<String>> mapProductPB 			= new Map<Id, Set<String>>();
            List<PricebookEntry> pbeList 				= new List<PricebookEntry>();
            List<PriceBookEntry> listPriceBook 			= ICB_PriceBookEntryDAO.getInstance().getPricebookEntry(value);
            system.debug('listPriceBook:'+ listPriceBook);
            for(PriceBookEntry vPBEntry : listPriceBook)
            {
                if(mapProductPB.containsKey(vPBEntry.PriceBook2Id)) 
                {
                    Set<String> valueId = mapProductPB.get(vPBEntry.PriceBook2Id);
                    valueId.add(vPBEntry.Name);
                    mapProductPB.put(vPBEntry.PriceBook2Id, valueId);
                    
                } else {
                    mapProductPB.put(vPBEntry.PriceBook2Id, new Set<String> { vPBEntry.Name });
                    
                }
                
            }
            
            for(PriceBook2 vPB2 : ICB_PriceBookEntryDAO.getInstance().getActivePricebook(value)) 
            {
                system.debug('vPB2:'+ vPB2);
                Set<String> lista = mapProductPB.get(vPB2.Id);
                system.debug('lista:'+ lista);
                if(!lista.contains(prod.Name)) {
                    pbeList.add(create(vPB2.Id, prod));
                }
            }  
            Database.Insert(pbeList);	
             system.debug('Exiting <priceBookCreation>: ');
        }
        catch (Exception e) 
        {
            system.debug(LABEL.ICB_ERROR_MESSAGE + e.getMessage());
        }
        
        
    }
    /*******************************************************************
    Purpose: Update Inventory Line Item
    Parameters: Boolean, List<ICB_Inventory_Line_Item__c>.
    Returns: [VOID]
    Throws [Exceptions]: Exception
	********************************************************************/ 
    private static void updateInventory(Boolean value, List<ICB_Inventory_Line_Item__c> listInventory, List<ICB_Inventory_Line_Item__c> listUpdate) 
    {
        try
        {
            system.debug('Entering <UpdateInventory>' + value);
            system.debug('Entering <UpdateInventory>' + listInventory);
            system.debug('Entering <UpdateInventory>' + listUpdate);
            for(ICB_Inventory_Line_Item__c iventoryLineItem : listInventory) 
            {
                iventoryLineItem.ICB_Active__c = value;
                listUpdate.add(iventoryLineItem);
            }
            Database.update(listUpdate); 
            system.debug('Exiting <updateInventory>');
        }
        catch(exception e)
        {
            
            system.debug(LABEL.ICB_ERROR_MESSAGE + e.getMessage());
        }
            
    }
    
    /*******************************************************************
    Purpose: create price Book Entry
    Parameters: Id, Sobject.
    Returns: [VOID]
    Throws [Exceptions]: Exception
	********************************************************************/
    private static PricebookEntry create(Id vId, sObject prodValue) 
    {
        try
        {
           system.debug('Entering <create>');
           return new PricebookEntry ( Pricebook2Id 	= vId, 
                                   Product2Id 			= (Id) prodValue.Id, 
                                   IsActive 			= TRUE,
                                   UnitPrice 			= 1.99,
                                   UseStandardPrice 	= FALSE,
                                   ICB_Manufacture_Price__c = 0.00,
                                   ICB_Purchase_Price__c    = 0.00); 
        }catch(exception e)
        {
            system.debug('Exiting <create>: ');
            system.debug(LABEL.ICB_ERROR_MESSAGE + e.getMessage());
            return null;            
        }
        
    }
}