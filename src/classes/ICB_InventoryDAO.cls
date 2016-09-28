/**********************************************************************
Name: ICB_InventoryDAO
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
public with sharing class ICB_InventoryDAO {
    
    // Instance Class
    private static final ICB_InventoryDAO instance = new ICB_InventoryDAO();
    
    // Construtor 
    public ICB_InventoryDAO() {}
    
    // Get Instance method to return a static final instance of this object. 
    public static ICB_InventoryDAO getInstance(){
        return instance;
    }
    
    public ICB_Inventory__c getInventory(String AccountNameParam){
        
        return [SELECT id from ICB_Inventory__c where name =:AccountNameParam LIMIT 1];
    }      
}