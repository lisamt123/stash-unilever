trigger UL_PromotionTrigger on ACCL__Promotion__c (before update, before delete, before insert,after insert, after update) {

    public final String STATUS_END_DATE = 'End Date' ;
    
  if(trigger.isBefore){
      if(trigger.isUpdate){
          UL_PromotionInstoreDates.inStoredatesUpdated(trigger.new,trigger.oldMap,trigger.newMap);
          UL_PromotionSetIIBBTaxHandler.updateIIBBTax(trigger.new,trigger.oldMap);
      }
  }
  if(trigger.isBefore){
     if(trigger.isDelete){
         UL_PromotionInstoreDates.deletePromotion(trigger.old);
     }
  }
  if(trigger.isBefore){
     if(trigger.isInsert){
        UL_PromotionSetIIBBTaxHandler.updateIIBBTax(trigger.new,null);
     }
  }
    if(trigger.isAfter){
        if(trigger.isUpdate){
            
        Set<Id> approvedPromoIds = new Set<Id>() ;
        Set<Id> endDatedPromoIds = new Set<Id>() ;
        Set<Id> planningPromoIds = new Set<Id>() ;
        
        final String OB_ACTION_CREATE = 'CREATE_CONDITION' ;
        final String OB_ACTION_DELETE = 'DELETE_CONDITION' ;        
        
            for(ACCL__Promotion__c promo : trigger.new){
            if(promo.ACCL__Sales_Org__c.equalsIgnoreCase(UL_Utility.SalesOrg.AR01.Name())){
                if(!trigger.oldMap.get(promo.Id).UL_Current_Status__c.equalsIgnoreCase(promo.UL_Current_Status__c)){
                    if(promo.UL_Current_Status__c.equalsIgnoreCase(UL_Utility.STATUS_APPROVED) && (promo.ACCL__Sales_Org__c.equalsIgnoreCase(UL_Utility.SalesOrg.AR01.Name()) 
                        || promo.ACCL__Sales_Org__c.equalsIgnoreCase(UL_Utility.SalesOrg.CL01.Name())
                        || promo.ACCL__Sales_Org__c.equalsIgnoreCase(UL_Utility.SalesOrg.CL03.Name()))){
                        approvedPromoIds.add(promo.Id) ;
                    }
                    if(promo.UL_Current_Status__c.equalsIgnoreCase(STATUS_END_DATE) && (promo.ACCL__Sales_Org__c.equalsIgnoreCase(UL_Utility.SalesOrg.AR01.Name()) 
                        || promo.ACCL__Sales_Org__c.equalsIgnoreCase(UL_Utility.SalesOrg.CL01.Name())
                        || promo.ACCL__Sales_Org__c.equalsIgnoreCase(UL_Utility.SalesOrg.CL03.Name()))){
                        endDatedPromoIds.add(promo.Id) ;
                    }
                    if(promo.UL_Current_Status__c.equalsIgnoreCase(UL_Utility.STATUS_PLANNING) && (promo.ACCL__Sales_Org__c.equalsIgnoreCase(UL_Utility.SalesOrg.AR01.Name()) 
                        || promo.ACCL__Sales_Org__c.equalsIgnoreCase(UL_Utility.SalesOrg.CL01.Name())
                        || promo.ACCL__Sales_Org__c.equalsIgnoreCase(UL_Utility.SalesOrg.CL03.Name()))){
                        planningPromoIds.add(promo.Id) ;
                    }
                }
            }}
            
            if(approvedPromoIds.size() > 0){
                UL_PromotionUtility.promotionOutbound(approvedPromoIds, OB_ACTION_CREATE) ;
            }
            if(endDatedPromoIds.size() > 0){
                UL_PromotionUtility.promotionOutbound(endDatedPromoIds, OB_ACTION_CREATE) ;
            }
            if(planningPromoIds.size() > 0){
                UL_PromotionUtility.promotionOutbound(planningPromoIds, OB_ACTION_DELETE) ;
            }
        }
    }
  
}