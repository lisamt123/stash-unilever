trigger UL_UpdateDatefileds on ACCL__Promotion__c (before update) {
  if(trigger.isBefore){
      if(trigger.isUpdate){
          UL_PromotionInstoreDates.inStoredatesUpdated(trigger.new,trigger.oldMap,trigger.newMap);
      }
  }
    
}