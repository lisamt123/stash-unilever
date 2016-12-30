@isTest
public with sharing class UL_ProductTemplateTestFactory {
    public static ACCL__Product_Template__c defaultProductTemplate;
    public static ACCL__Product_Template__c buildProductTemplate(Integer nameSuffix) {
        ACCL__Product_Template__c productTemplate = new ACCL__Product_Template__c();
            productTemplate.Name = 'test'+nameSuffix; 
            productTemplate.ACCL__Description_Language_1__c = 'lan'+nameSuffix;
            productTemplate.ACCL__Active__c = true;
            productTemplate.ACCL__Price_Required__c= true;
            return productTemplate;
    }
    public static ACCL__Product_Template__c buildProductTemplateForProductRecordType(Integer nameSuffix) {
        Map<String, Id> mapProductTemplateRecordTypesByDeveloperName=UL_RecordTypeUtil.getRecordTypeIdsByDeveloperNameWithAllAvailableTypes(ACCL__Product_Template__c.sObjectType);
        ACCL__Product_Template__c productTemplate = new ACCL__Product_Template__c();
        productTemplate.Name = 'test'+nameSuffix; 
        productTemplate.ACCL__Description_Language_1__c = 'lan'+nameSuffix;
        productTemplate.ACCL__Active__c = true;
        productTemplate.ACCL__Price_Required__c= true;
        productTemplate.recordtypeid=mapProductTemplateRecordTypesByDeveloperName.get('Product');
        return productTemplate;
    }
    public static ACCL__Product_Template__c buildDefaultProductTemplate() {
        return buildProductTemplate(-1);
    }
    
    public static ACCL__Product_Template__c insertProductTemplate(Integer nameSuffix){
        ACCL__Product_Template__c productTemplate = buildProductTemplate(nameSuffix);
        insert productTemplate;
        return productTemplate;
    }
    
    public static ACCL__Product_Template__c getDefaultProductTemplate() {
        if( defaultProductTemplate == null ){
            defaultProductTemplate = insertProductTemplate( -1 );
        }
        return defaultProductTemplate;
    }
    public static ACCL__Product_Template__c insertProductTemplateForProduct(Integer nameSuffix){
        ACCL__Product_Template__c productTemplate = buildProductTemplateForProductRecordType(nameSuffix);
        insert productTemplate;
        return productTemplate;
    }
    
    public static ACCL__Product_Template__c getDefaultProductTemplateForProduct() {
        if( defaultProductTemplate == null ){
            defaultProductTemplate = insertProductTemplateForProduct( -1 );
        }
        return defaultProductTemplate;
    }
    public static List<ACCL__Product_Template__c> buildProductTemplates( Integer numberOfProductTemplates ) {
        List<ACCL__Product_Template__c> productTemplates = new List<ACCL__Product_Template__c>();
            for(Integer i=0 ; i < numberOfProductTemplates ; i++){
            productTemplates.add(buildProductTemplate(i));
        }
        return productTemplates;
    }
    
    public static List<ACCL__Product_Template__c> insertProductTemplates( List<ACCL__Product_Template__c> productTemplates){
        insert productTemplates;
        return productTemplates;
    }
    
    public static List<ACCL__Product_Template__c> insertProductTemplates( Integer numberOfProductTemplates){
        List<ACCL__Product_Template__c> tempaltes = buildProductTemplates(numberOfProductTemplates);
        insert tempaltes;
        return tempaltes;
    }

}