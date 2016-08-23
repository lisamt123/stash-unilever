/**********************************************************************
Name: PriceBookEntryDAO
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
DAO class for retrieve queries in objet PriceBookEntry
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Thiago Oliveira 12/08/2016  Class creation  
***********************************************************************/
public with sharing class PriceBookEntryDAO {
    
    // Instance Class
    private static final PriceBookEntryDAO instance = new PriceBookEntryDAO();
    
    // Construtor 
    public PriceBookEntryDAO() {}
    
    // Get Instance method to return a static final instance of this object. 
    public static PriceBookEntryDAO getInstance(){
        return instance;
    }
    
    public List<PriceBookEntry> getPricebook(String AccountNameParam){
        
        return [SELECT UnitPrice, 
                ICB_Purchase_Price__c,
                PriceBook2.Name,
                Product2.Name, 
                Product2.Product_Image__c,
                ICB_Manufacture_Price__c
                FROM PriceBookEntry 
                WHERE Product2.IsActive = TRUE AND PriceBook2.Name =: AccountNameParam];
    }
    
    public List<Pricebook2> getActivePricebook(Boolean value){
        if(value) {
        return [SELECT ID from Pricebook2 where IsStandard = TRUE and IsActive = TRUE];
        } else {
            return [SELECT ID from Pricebook2 where IsStandard = FALSE and IsActive = TRUE];
        }
    }
}