/**********************************************************************
Name: Product2DAO
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
DAO class for retrieve queries in objet Product2
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Ronaldo Garcia  12/08/2016  Class creation  
***********************************************************************/
public with sharing class ICB_Product2DAO {
    
    // Instance Class
    private static final ICB_Product2DAO instance = new ICB_Product2DAO();
        
    // Construtor 
    public ICB_Product2DAO() {}
        
    // Get Instance method to return a static final instance of this object. 
    public static ICB_Product2DAO getInstance()
    {
    	return instance;
	}
    
    // Retrieve active products. 
    public List<Product2> getActiveProducts()
    {
        System.debug('Entering <getActiveProducts>');
        return [Select 	Name, 
               		   	Description
               	From 	Product2
                Where 	isActive =: true];
    }
    public Product2 getProduct(String idProductParam)
    {
        return [SELECT Name, 
                    Product_Image__c, 
                    ICB_Price__c, 
                    IsActive,
                    Family
                    FROM Product2 
                    WHERE Id =: idProductParam];
    }
}