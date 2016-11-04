/**
@Author - vinod.thupakula@accenture.com
@name - UL_UpdatePromotionTypeController
@CreateDate - 03-10-2016
@Description - this class is helper for promotiontypeupdate process builder.
@Version - 1.0
@reference - N/A
*/
public with sharing class UL_UpdatePromotionTypeController{
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
public static void updatePromotionType(list<ACSFUL001__Promotion__c> promotionRecords){
  try{
      String promotionType = UL_Utility.promotionPickOne;
      Boolean isChecked = false;
      list<ACSFUL001__promotion__c>  allPromotionRecords = new list<ACSFUL001__promotion__c>();
      for(ACSFUL001__Promotion_Template__c currentPromotionTemp:[select id,
                                                                        UL_Calculate_Promotion_Type__c 
                                                                           from ACSFUL001__Promotion_Template__c 
                                                                           where 
                                                                        id=:promotionRecords[0].ACSFUL001__Promotion_Template__c
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
                                         id =:promotionRecords[0].ACSFUL001__Anchor_Account__c 
                                            limit 1]){
            if((accReocrds.UL_Direct_Indirect_Flag__c != null 
                    && accReocrds.UL_Direct_Indirect_Flag__c.equals(UL_Utility.indirect))
                    || accReocrds.UL_NCF_Flag__c){
               promotionType = UL_Utility.promotionPickTwo;
            }       
         }
         for(ACSFUL001__promotion__c currentPromotion : [select id,
                                                                UL_Promotion_Type__c 
                                                                   from ACSFUL001__promotion__c
                                                                   where 
                                                                id=:promotionRecords[0].id 
                                                                   limit 1]){
            currentPromotion.UL_Promotion_Type__c = promotionType ;
            allPromotionRecords.add(currentPromotion);
         }        
        Database.update(allPromotionRecords,false);
    }
  }
  catch(Exception ex){
      
  }
         
}
}