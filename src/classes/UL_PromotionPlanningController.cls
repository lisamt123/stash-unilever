/***************************************************************
Name: UL_PromotionPlanningExtension 
Copyright © 2016 Accenture
======================================================
Purpose:
Utility extention class for Promotion SmartUI
======================================================
History
-------
VERSION     AUTHOR        DATE           DETAIL                 Description
1.0         Chandrababu         24/01/2017     INITIAL DEV            
***************************************************************/
global class UL_PromotionPlanningController{
    global UL_PromotionPlanningController(ApexPages.StandardController ctr) {
    }
    @RemoteAction
    global Static String getDataLOExtPromotionGrid(String txid, String promotionContent) {
    promotionContent = UL_PromotionContentReplace.replaceFieldContent(promotionContent);
    return ACCL.PromotionPlanningController.getDataLOExtPromotionGrid(txid,promotionContent);
    }
    
    
    @RemoteAction
    global static Map<String,Object> getMetaLOExtPromotionGrid(String txid, String promotionContent) {
         promotionContent = UL_PromotionContentReplace.replaceFieldContent(promotionContent);
    	 return ACCL.PromotionPlanningController.getMetaLOExtPromotionGrid(txid,promotionContent);
    }
}