/**********************************************************************
Name: ICB_InventoryLineItemDAO
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
DAO class for retrieve queries in objet Contact
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Thiago Oliveira 12/08/2016  Class creation  
***********************************************************************/
public with sharing class ICB_InventoryLineItemDAO {
    
    // Instance Class
    private static final ICB_InventoryLineItemDAO instance = new ICB_InventoryLineItemDAO();
    
    // Construtor 
    public ICB_InventoryLineItemDAO() {}
    
    // Get Instance method to return a static final instance of this object. 
    public static ICB_InventoryLineItemDAO getInstance(){
        return instance;
    }
    
    public List<ICB_Inventory_Line_Item__c> getIventoryLineList(ICB_Inventory__c inventoryParam){
        
        return[SELECT id, Name, 
                          ICB_Product__r.Name,
                          ICB_Product__r.ICB_Reference_Unit__c,
                          ICB_Product__r.Product_Image__c,
                          ICB_Quantity_Unit__c, 
                          ICB_Quantity_Boxes__c, 
                          ICB_Sales_Price__c,
                          ICB_Quantity_ToBe_Updated__c
                          FROM ICB_Inventory_Line_Item__c 
                          WHERE ICB_Inventory__c =: inventoryParam.id 
               			  AND ICB_Product__r.Family =: Label.ICB_FAMILY_IMPULSE 
               			  AND ICB_Active__c =: true];
    }
     
    public List<ICB_Inventory_Line_Item__c> getProductInfo(Id productId) {
        return [SELECT Id, ICB_Product__c,
                ICB_Quantity_Boxes__c,
                ICB_Quantity_Unit__c,
                ICB_Active__c
                FROM ICB_Inventory_Line_Item__c
                WHERE ICB_Product__c =: productId];
    }
        
    public AggregateResult[] getInventoryReference() {
        return [SELECT ICB_Inventory__c FROM ICB_Inventory_Line_Item__c WHERE ICB_Active__c = TRUE GROUP BY ICB_Inventory__c]; 
    }    
}