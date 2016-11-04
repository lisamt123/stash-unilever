/**
@Author - Chandra Reddy
@Name - UL_ProductPartTriggerUtil 
@CreateDate - 19-10-2016
@Description - Utility class to handle UL_UpdateCUCount trigger events.
@Version - 1.0
@reference - UL_UpdateCUCount Trigger
*/ 
public with sharing class UL_ProductPartTriggerUtil{

    /**
    @Author - Chandra Reddy
    @method name - UpdateCUQuantity
    @CreateDate - 19-10-2016
    @Description - This method updates CU Quantity field on ProductPart object.
    @Param - List of ProductPart
    @Version - 1.0
    @reference - NR
    */
    public static void UpdateCUQuantity(list<ACSFUL001__Product_Part__c> productParts){
        Set<Id> ids = new Set<Id>();
        Map<Id, ACSFUL001__Product_Part__c> prodPartMap = new Map<Id, ACSFUL001__Product_Part__c>();
        for(ACSFUL001__Product_Part__c prodPart:productParts){
            ids.add(prodPart.ACSFUL001__Child_Product__c);
            prodPartMap.put(prodPart.ACSFUL001__Child_Product__c, prodPart);
        }
        
        ACSFUL001__Product_Part__c prodPartObj;
        
        for(ACSFUL001__Unit_of_Measure__c unit:[select ID,UL_UnitsPerCase__c,ACSFUL001__Product__c from ACSFUL001__Unit_of_Measure__c where ACSFUL001__Unit_Type__c ='ConsumerUnit' and ACSFUL001__Product__c =:ids]){
            prodPartObj = prodPartMap.get(unit.ACSFUL001__Product__c);
            if(prodPartObj != null){
                prodPartObj.UL_CU_Quantity__c = integer.valueOf(unit.UL_UnitsPerCase__c) * integer.valueOf(prodPartObj.ACSFUL001__Quantity__C);
            }
        }
    }
}