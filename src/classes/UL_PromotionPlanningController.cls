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
global with sharing class UL_PromotionPlanningController{
    ACCL__Promotion__c promObj;
/*******************************************************************
    Purpose: Constructor
    Version: 1.0
    Parameters: N/A
    Returns: N/A
    Throws N/A
    ********************************************************************/
    global UL_PromotionPlanningController(ApexPages.StandardController ctr) {
       promObj = new ACCL__Promotion__c();
    }
     /*******************************************************************
    Purpose: Get promotion grid 
    Version: 1.0
    Parameters: N/A
    Returns: N\A
    Throws N/A
    ********************************************************************/
    @RemoteAction
    global Static String getDataLOExtPromotionGrid(String txid, String promotionContent) {
    promotionContent = UL_PromotionContentReplace.replaceFieldContent(promotionContent);
    String promoGrid = ACCL.PromotionPlanningController.getDataLOExtPromotionGrid(txid,promotionContent);
    return promoGrid;
    }
    /*******************************************************************
    Purpose: Get promotion grid 
    Version: 1.0
    Parameters: N/A
    Returns: N\A
    Throws N/A
    ********************************************************************/
    @RemoteAction
    global static Map<String,Object> getMetaLOExtPromotionGrid(String txid, String promotionContent) {
         promotionContent = UL_PromotionContentReplace.replaceFieldContent(promotionContent);
    	 return ACCL.PromotionPlanningController.getMetaLOExtPromotionGrid(txid,promotionContent);
    }
}