/***************************************************************
Name: UL_ProductTriggerTest
======================================================
Purpose:
Test class for trigger UL_ProductTrigger on product object 
======================================================
History
-------
VERSION     AUTHOR         DATE             DETAIL                 Description
1.0         Ketan Mehta    24/11/2016       Initial Development    Test product before insert event
***************************************************************/
@isTest(SeeAllData=false)
private class UL_ProductTriggerTest{
    
    @testsetup
    private static void testData(){
        //Prepare product template
        ACCL__Product_Template__c productTemplate = new ACCL__Product_Template__c();
        productTemplate.Name = 'Test Product Template';
        productTemplate.ACCL__Active__c = true;
        productTemplate.ACCL__Sales_Org__c = 'UK SO';
        productTemplate.ACCL__Description_Language_1__c = 'English';
        insert productTemplate;
        
        //Insert UL_ProductLevelMapping__c Custom setting record
        UL_ProductLevelMapping__c prodLevelMapping = new UL_ProductLevelMapping__c(
            Name = 'ProdMap 1',
            External_System_Value__c = '8',
            Sales_Org__c = 'UKI',
            TMP_System_Value__c ='Product'
        );
        Insert prodLevelMapping;
        
        //
    }
    
    @isTest
    private static void insertProduectNegativeTest(){
        
        
        List<UL_ProductLevelMapping__c> settings = UL_ProductLevelMapping__c.getall().values();
        if(!settings.isEmpty()){
            UL_ProductLevelMapping__c mapping = settings.get(0);
            
            //Get product template
            ACCL__Product_Template__c productTemplate = [SELECT id FROM ACCL__Product_Template__c WHERE Name = 'Test Product Template' AND ACCL__Sales_Org__c = 'UK SO'];
            
            
            //Prepare a product to insert
            ACCL__Product__c product = new ACCL__Product__c();
            product.Name = 'Test Product';
            product.ACCL__Product_Template__c = productTemplate.id;
            product.ACCL__Product_Level__c = mapping.External_System_Value__c;
            product.ACCL__Product_Code__c = '99999';
            insert product;
            
            ACCL__Product__c insertedProduct = [SELECT Id, ACCL__Product_Level__c FROM ACCL__Product__c WHERE Id=:product.Id];
            //Assert product level
            system.assertEquals(insertedProduct.ACCL__Product_Level__c, mapping.TMP_System_Value__c);
        }
    }
    
    @isTest
    private static void insertProduectPositiveTest(){
        //Insert Sales Org Mapping Record
        UL_Sales_Org_Mapping__c salesOrgMapping = new UL_Sales_Org_Mapping__c(
        	Name = 'UK SO',
            UL_Sales_Org__c = 'UKI'
        );
        Insert salesOrgMapping;
        List<UL_ProductLevelMapping__c> settings = UL_ProductLevelMapping__c.getall().values();
        if(!settings.isEmpty()){
            UL_ProductLevelMapping__c mapping = settings.get(0);
            
            //Get product template
            ACCL__Product_Template__c productTemplate = [SELECT id FROM ACCL__Product_Template__c WHERE Name = 'Test Product Template' AND ACCL__Sales_Org__c = 'UK SO'];
            
            
            //Prepare a product to insert
            ACCL__Product__c product = new ACCL__Product__c();
            product.Name = 'Test Product';
            product.ACCL__Product_Template__c = productTemplate.id;
            product.ACCL__Product_Level__c = mapping.External_System_Value__c;
            product.ACCL__Product_Code__c = '99999';
            insert product;
            
            ACCL__Product__c insertedProduct = [SELECT Id, ACCL__Product_Level__c FROM ACCL__Product__c WHERE Id=:product.Id];
            //Assert product level
            system.assertEquals(insertedProduct.ACCL__Product_Level__c, mapping.TMP_System_Value__c);
        }
    }
}