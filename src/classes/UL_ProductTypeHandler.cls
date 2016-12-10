/**
@Author - alok.b.pandey@accenture.com
@Name - UL_ProductTypeHandler 
@CreateDate - 16-11-2016
@Description - This class is to update ProductType field on Product record.
@Version - 1.0
@reference - UL_Product_Part_Trigger Trigger
*/ 
Public with sharing Class UL_ProductTypeHandler{
    
    /**
@Author - alok.b.pandey@accenture.com
@method name - productType
@CreateDate - 16-11-2016
@Description - This method is to update ProductType field on Product record.
@Param - List of ProductPart
@Version - 1.0
@reference - NR
*/
    
    Public static void updateProductType(List<ACSFUL001__Product_Part__c> productPartList){
        try{
            Set<Id> productIdSet = new Set<Id>();
            for(ACSFUL001__Product_Part__c productPart: productPartList){
                productIdSet.add(productPart.ACSFUL001__Parent_Product__c);               
            }
        
        
        List<ACSFUL001__Product__c> updateProductList = new List<ACSFUL001__Product__c>();
            for(ACSFUL001__Product__c product: [SELECT id,ACSFUL001__Product_Type__c FROM ACSFUL001__Product__c where Id IN: productIdSet and  ACSFUL001__Product__c.ACSFUL001__Product_Template__r.UL_Product_Type_Update__c = true]){
                product.ACSFUL001__Product_Type__c = UL_Utility.BOM_PRODUCT;
                updateProductList.add(product);
            }
        if(!updateProductList.isEmpty())    
        update updateProductList;
    }catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'UL_ProductTypeHandler', 'productType', 'An Error occured while updating Product Part value', Ex, NULL, NULL, NULL, NULL, UL_Utility.APPLICATION_NAME);
    }
   }
}