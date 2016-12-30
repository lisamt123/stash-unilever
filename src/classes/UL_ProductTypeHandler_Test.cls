@isTest
private class UL_ProductTypeHandler_Test {
    
    @isTest
    private static void test1()
    {        
        //Create Product Template record
        ACCL__Product_Template__c testProdTemp = new ACCL__Product_Template__c();
        testProdTemp.Name ='Product Template for test';
        testProdTemp.ACCL__Active__c =True;
        testProdTemp.ACCL__Sales_Org__c = 'AR01';
        testProdTemp.ACCL__Description_Language_1__c ='English';
        testProdTemp.UL_Product_Type_Update__c = true;
        insert testProdTemp;
        
        //Create Product Record    
        ACCL__Product__c testProd = new ACCL__Product__c();
        testProd.Name ='PatrentProduct';
        testProd.ACCL__Product_Template__c =testProdTemp.id;
        testProd.ACCL__Product_Code__c = '1234';
        testProd.ACCL__Product_Level__c = 'Producto';
        testProd.ACCL__Description_1_Language_1__c ='English1';
        testProd.ACCL__Product_Type__c = 'Standard Product';
        
        insert testProd;
        
        //Create Product2 Record    
        ACCL__Product__c testProd1 = new ACCL__Product__c();
        testProd1.Name ='ChildProduct';
        testProd1.ACCL__Product_Template__c = testProdTemp.id;
        testProd1.ACCL__Product_Code__c = '12345';
        testProd1.ACCL__Product_Level__c = 'Producto';
        testProd1.ACCL__Description_1_Language_1__c ='English2';
        testProd.ACCL__Product_Type__c = 'Standard Product';
        
        insert testProd1;
        
        //Create product part
        ACCL__Product_Part__c productPart = new ACCL__Product_Part__c ();
        productPart.ACCL__Parent_Product__c = testProd.id;
        productPart.ACCL__Child_Product__c = testProd1.Id;
        
        insert productPart;
        ACCL__Product__c  ParentProduct = [Select id, ACCL__Product_Type__c from ACCL__Product__c where id=:testProd.id];
        System.assertEquals(ParentProduct.ACCL__Product_Type__c,'BoM');    
    }
}