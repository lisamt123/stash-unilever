trigger UL_PromotionTrigger on ACCL__Promotion__c (before update, before delete, after insert, after update) {
  if(trigger.isBefore){
      if(trigger.isUpdate){
          UL_PromotionInstoreDates.inStoredatesUpdated(trigger.new,trigger.oldMap,trigger.newMap);
      }
  }
  if(trigger.isBefore){
     if(trigger.isDelete){
         UL_PromotionInstoreDates.deletePromotion(trigger.old);
     }
  }
}