/**
@Author - vinod.thupakula@accenture.com
@name - UL_UpdatePromotionTypeController
@CreateDate - 03-10-2016
@Description - this class is helper for promotiontypeupdate process builder.
@Version - 1.0
@reference - N/A
*/
public with sharing class UL_UpdatePromotionTypeController{
    
    private final static String INDIRECT = 'Indirect';
    /**
    @Author - vinod.thupakula@accenture.com
    @method name - updatePromotionType
    @CreateDate - 03-10-2016
    @Description - this method will update the promotion type values.
    @Param - 
    @Version - 1.0
    @reference - NR
    */
@InvocableMethod(Label = 'UpdatePromotionTypeController')
public static void updatePromotionType(list<ACCL__Promotion__c> promotionRecords){
  try{
      String promotionType = UL_Utility.PROMOTION_TYPE_ONE;
      Boolean isChecked = false;
      list<ACCL__promotion__c>  allPromotionRecords = new list<ACCL__promotion__c>();
      for(ACCL__Promotion_Template__c currentPromotionTemp:[select id,
                                                                        UL_Calculate_Promotion_Type__c 
                                                                           from ACCL__Promotion_Template__c 
                                                                           where 
                                                                        id=:promotionRecords[0].ACCL__Promotion_Template__c
                                                                           LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())]){
        isChecked  = currentPromotionTemp.UL_Calculate_Promotion_Type__c;
      } 
      if(isChecked){
         for(Account accReocrds: [select id,
                                         name,
                                         UL_Direct_Indirect_Flag__c,
                                         UL_NCF_Flag__c 
                                            from Account 
                                            where 
                                         id =:promotionRecords[0].ACCL__Anchor_Account__c 
                                            LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())]){
            if((accReocrds.UL_Direct_Indirect_Flag__c != null 
                    && INDIRECT.equals(accReocrds.UL_Direct_Indirect_Flag__c))
                    || accReocrds.UL_NCF_Flag__c){
               promotionType = UL_Utility.PROMOTION_TYPE_TWO;
               }       
         }
         for(ACCL__promotion__c currentPromotion : [select id,
                                                                UL_Promotion_Type__c 
                                                                   from ACCL__promotion__c
                                                                   where 
                                                                id=:promotionRecords[0].id 
                                                                   LIMIT 1]){
            currentPromotion.UL_Promotion_Type__c = promotionType ;
            allPromotionRecords.add(currentPromotion);
         }        
        Database.update(allPromotionRecords,false);
    }
  }
  catch(Exception ex){
       UL_Utility.logError(ex, UserInfo.getUserId());

  }
}
}