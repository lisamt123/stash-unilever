/**********************************************************************
Name: TEL_AssociateProductsController_Test
Copyright © 2016 Unilever
======================================================
Purpose: Class to test the class: TEL_AssociateProductsController_Test.

History 
VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	Ronaldo Garcia  	27/12/2016  Class Creation
***********************************************************************/
@isTest
public class TEL_AssociateProductsController_Test {

    @testSetup
    public static void createData() {
        Product2 prdObj 		= new Product2(
        	Name 				= 'Test', 
            Family				= 'Test',
            ProductCode			= '001',
            Description  		= 'Test',
            isActive 			= true
        );
        System.Database.insert(prdObj);
        
        Product2 prdObj1 		= new Product2(
            Name 				= 'Test 1', 
            Family				= 'Test',
            ProductCode			= '001',
            Description  		= 'Test Desc 1',
            isActive 			= true
        );
        System.Database.insert(prdObj1);
        
        Account accObj 			= new Account();
        accObj.Name				= 'Test Class';
        accObj.TEL_OTM__c		= 'A';
        accObj.Segment__c		= 'Test';
        accObj.SubSegment__c	= 'Test';
        accObj.RecordTypeId 	= [SELECT Id FROM RecordType WHERE DeveloperName = 'Standard' LIMIT 1].Id;
        System.Database.insert(accObj);
        
        Campaign cmpObj			= new Campaign(
            Name 				= 'Test', 
            isActive 			= true);
        System.Database.insert(cmpObj);
        
        TEL_Campaign_Products__c cmpProducts	= new TEL_Campaign_Products__c(
        	TEL_Campaign__c 	= cmpObj.Id,
            TEL_Product_Name__c	= prdObj.Id
        );
        System.Database.insert(cmpProducts);
    }
    
    static testMethod void testRetrieveProducts(){
        Id campaignId = [Select Id From Campaign Where Name =: 'Test'].Id;
        List<TEL_TelesalesWrapper.DisplayProducts> 	lstProducts = TEL_AssociateProductsController.retrieveProducts('Test', campaignId);
        
        System.assert(!lstProducts.isEmpty());
    }
    
    static testMethod void testCreatePrdCampaign(){
        Product2 prd 			= [Select Name, ProductCode, Family From Product2 Where Name =: 'Test'];
        Id campaignId 			= [Select Id From Campaign Where Name =: 'Test'].Id;
        List<TEL_TelesalesWrapper.DisplayProducts> 	lstSelectedProduct 	= new List<TEL_TelesalesWrapper.DisplayProducts>();
        TEL_TelesalesWrapper.DisplayProducts 		product			 	= new TEL_TelesalesWrapper.DisplayProducts();
        product.isSelected		= true;
        product.productId	 	= prd.Id;
        product.productName 	= prd.Name;
        product.productFamily 	= prd.Family;
        product.productCode		= prd.ProductCode;
        lstSelectedProduct.add(product);
        String productJSON 		= JSON.serialize(lstSelectedProduct);
     	TEL_AssociateProductsController.createPrdCampaign(productJSON, campaignId);
        
        List<TEL_Campaign_Products__c> assertList = [SELECT Id FROM TEL_Campaign_Products__c LIMIT 10];
        System.assert(!assertList.isEmpty());
    }
}