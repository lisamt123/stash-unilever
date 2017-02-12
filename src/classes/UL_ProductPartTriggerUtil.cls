/**
@Author - Chandra Reddy
@Name - UL_ProductPartTriggerUtil 
@CreateDate - 19-10-2016
@Description - Utility class to handle UL_UpdateCUCount trigger events.
@Version - 1.0
@reference - UL_UpdateCUCount Trigger
*/ 
public with sharing class UL_ProductPartTriggerUtil{
    public static final String UNIT_TYPE = 'ConsumerUnit';

    /**
    @Author - Chandra Reddy
    @method name - UpdateCUQuantity
    @CreateDate - 19-10-2016
    @Description - This method updates CU Quantity field on ProductPart object.
    @Param - List of ProductPart
    @Version - 1.0
    @reference - NR
    */
    public static void updateCUQuantity(list<ACCL__Product_Part__c> productParts){
        Set<Id> ids = new Set<Id>();
        Map<Id, ACCL__Product_Part__c> prodPartMap = new Map<Id, ACCL__Product_Part__c>();
        try{             
            for(ACCL__Product_Part__c prodPart:productParts){
                ids.add(prodPart.ACCL__Child_Product__c);
                prodPartMap.put(prodPart.ACCL__Child_Product__c, prodPart);
            }
            
            ACCL__Product_Part__c prodPartObj = null;
            for(List<ACCL__Unit_of_Measure__c> unitList : [SELECT Id,
                                                    UL_UnitsPerCase__c,
                                                    ACCL__Product__c 
                                                    FROM ACCL__Unit_of_Measure__c 
                                                    WHERE 
                                                    ACCL__Unit_Type__c = :UNIT_TYPE AND
                                                    ACCL__Product__c =:ids 
                                                    LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())]){
                for(ACCL__Unit_of_Measure__c unit:unitList){
                        
                        prodPartObj = prodPartMap.get(unit.ACCL__Product__c);
                        if(prodPartObj != null){
                            prodPartObj.UL_CU_Quantity__c = integer.valueOf(unit.UL_UnitsPerCase__c) 
                                                            * integer.valueOf(prodPartObj.ACCL__Quantity__C);
                        }            
                }
              }       
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }
}