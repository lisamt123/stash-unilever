@isTest
public with sharing class UL_ProductTestFactory {
    public static ACCL__Product__c defaultProduct;
    public final static String NAME = 'TestClass_ProductTesting';

    public static ACCL__Product__c buildProduct(Integer nameSuffix,ACCL__Product_Template__c template) {
        ACCL__Product__c product = new ACCL__Product__c();
        product.Name = NAME+nameSuffix;
        //product.Active__c = true;
        product.ACCL__Description_1_Language_1__c = 'description'+nameSuffix;
        product.ACCL__Product_Code__c = 'ProductCode'+nameSuffix;
        product.ACCL__Product_Template__c = template.Id;
        product.ACCL__Field_Valid_From__c=System.today();
        product.ACCL__Field_Valid_Thru__c = System.today().addMonths(5);
        product.ACCL__Delivery_Valid_From__c=System.today();
        product.ACCL__Delivery_Valid_Thru__c = System.today().addMonths(5);
        product.ACCL__KAM_Valid_From__c=System.today();
        product.ACCL__KAM_Valid_Thru__c = System.today().addMonths(5);
        product.ACCL__New_Item_Valid_From__c=System.today();
        product.ACCL__New_Item_Valid_Thru__c = System.today().addMonths(5);
        product.ACCL__Fund_Valid_From__c=System.today();
        product.ACCL__Fund_Valid_Thru__c = System.today().addMonths(5);
        product.ACCL__Category__c = null;
        return product;
    }
    public static ACCL__Product__c buildDefaultProduct() {
        return buildProduct(-1,UL_ProductTemplateTestFactory.getDefaultProductTemplate());
    }

    public static ACCL__Product__c insertProduct(integer i,ACCL__Product_Template__c template){
        ACCL__Product__c product = buildProduct(i, template);
        insert product;
        return product;
    }
    
    public static ACCL__Product__c getDefaultProduct() {
        if( defaultProduct == null ){
            defaultProduct = insertProduct(-1,UL_ProductTemplateTestFactory.getDefaultProductTemplate());
        }
        return defaultProduct;
    }
    public static ACCL__Product__c getDefaultProductForProductRecordType() {
        if( defaultProduct == null ){
            defaultProduct = insertProduct(-1,UL_ProductTemplateTestFactory.getDefaultProductTemplateForProduct());
        }
        return defaultProduct;
    }
    public static List<ACCL__Product__c> buildProducts( List<ACCL__Product_Template__c> lstProductTemplate) {
        List<ACCL__Product__c> products = new List<ACCL__Product__c>();
        
        for(integer i=0; i < lstProductTemplate.size(); i++){
            products.add(buildProduct(i,lstProductTemplate[i]));
        }
        return products;
    }
    public static List<ACCL__Product__c> insertProducts( Integer noOfRecords) {
        List<ACCL__Product__c> products = new List<ACCL__Product__c>();
        for(integer i=0;i<noOfRecords;i++){
            products.add(buildProduct(i,UL_ProductTemplateTestFactory.getDefaultProductTemplateForProduct()));
        }
        insert products;
        return products;
    }
    
    public static List<ACCL__Product__c> insertProducts( List<ACCL__Product__c> products){
        insert products;
        return products;
    }
    public static list<ACCL__Product__c> updateProduct(List<ACCL__Product__c> products, string Category)
    {
        for(ACCL__Product__c p :products)
        {
            p.ACCL__Category__c = Category;
        }
        update products;
        return products;
    }
}