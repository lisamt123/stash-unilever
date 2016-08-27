/**********************************************************************
Name: PriceBookEntryDAO
Copyright © 2016 Unilever

Purpose:
DAO class for retrieve queries in objet PriceBookEntry


History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Thiago Oliveira 12/08/2016  Class creation  
***********************************************************************/
public with sharing class ICB_PriceBookEntryDAO {
    
    // Instance Class
    private static final ICB_PriceBookEntryDAO instance = new ICB_PriceBookEntryDAO();
    
    // Construtor 
    public ICB_PriceBookEntryDAO() {}
    
    // Get Instance method to return a static final instance of this object. 
    public static ICB_PriceBookEntryDAO getInstance(){
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
                WHERE PriceBook2.Name =: AccountNameParam
                AND IsActive = true];
    }
    
    public List<Pricebook2> getActivePricebook(Boolean value){
        List<Pricebook2> pb2 = new List<Pricebook2>();
        pb2 = [SELECT ID from Pricebook2 where IsStandard =: value and IsActive = TRUE];
        system.debug('pb2:'+ pb2);
        return pb2;
        
    }
    
    public List<PriceBookEntry> getPriceBookvalidate(List<priceBook2> priceparam){
        List<PriceBookEntry> pbEntry = new List<PriceBookEntry>();
        List<id> pbId = new List<id>();
        for(priceBook2 pBook2: priceparam){
          pbId.add(pBook2.id);
        }
        pbEntry = [SELECT id, Pricebook2Id, Product2Id from PriceBookEntry where Pricebook2Id =: pbId];
        
        return pbEntry;
    }
    
    public List<PriceBookEntry> getPricebookEntry(Boolean value){
        List<PriceBookEntry> bp1 = new List<PriceBookEntry>();
        
        bp1 = [SELECT Name,
                        Id, 
                        Product2Id, 
                        PriceBook2Id
                        FROM PriceBookEntry
                        WHERE PriceBook2Id =:getActivePricebook(value)];
        system.debug('bp1:'+ bp1);
        return bp1;
    }
        
}