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
 1.0    Ronaldo Garcia  09/12/2016  Class creation  
***********************************************************************/
public with sharing class Product2DAO {
	
    // Instance Class
    private static final Product2DAO instance = new Product2DAO();
        
    // Construtor 
    public Product2DAO() {}
    
    // Get Instance method to return a static final instance of this object. 
    public static Product2DAO getInstance()
    {
    	return instance;
	}
    
    // Retrieve products based on family and if is active product. 
    public List<Product2> getActiveProductsByFamily(String family, Boolean isActive)
    {
        System.debug('Entering <getActiveProductsByFamily>');
        return [Select 		Name, 
                			Family, 
                			ProductCode,
               		   		Description
               	From 		Product2
                Where 		Family =: family 
                AND 		isActive =: isActive 
                Order By 	Name];
    }
    
}