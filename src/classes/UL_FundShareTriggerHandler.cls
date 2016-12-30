/**
 * Unilever (Phase 1 - Sprint 4)
 * @author          Devesh Murdiya
 * @version         1.0
 * @date            06/12/2016
 * @description     Helper class for Fund Share Trigger to Enable or Disable Apex Sharing with User.
 */
global with sharing class UL_FundShareTriggerHandler{
    /**
     * Unilever (Phase 1 - Sprint 4)
     * @author          Devesh Murdiya
     * @version         1.0
     * @date            06/12/2016
     * @description     Method for call Fund Share Trigger to Enable on Fund record.
     */
    @future (callout=true)
    public static void enableApexSharing(list<id> lstFundId){
        /*Getting the Product and account for Fund*/        
        Map<Id,List<id>> mapProdFund = new Map<Id,List<id>>();  
        set<Id> setProd = new set<Id>();                
        for(ACCL__Fund__c fundObj : [select id,ACCL__Anchor_Product__c from ACCL__Fund__c where  id=:lstFundId limit 49999]){            
            setProd.add(fundObj.ACCL__Anchor_Product__c);                                        
            if(!mapProdFund.containskey(fundObj.ACCL__Anchor_Product__c)){
                mapProdFund.put(fundObj.ACCL__Anchor_Product__c,new List<id>{fundObj.id});
            }
            else{
                List<Id> lstId = mapProdFund.get(fundObj.ACCL__Anchor_Product__c);
                lstId.add(fundObj.Id);
                mapProdFund.put(fundObj.ACCL__Anchor_Product__c,lstId);
            }   
        }        
        /*Comparing Fund data with User customer Produt*/
        List<UL_UserCustomerProduct__c> lstUserCusProd = new List<UL_UserCustomerProduct__c>();
        map<Id,List<UL_UserCustomerProduct__c>> mapUserCusProd = new map<Id,List<UL_UserCustomerProduct__c>>();
        if(!setProd.isEmpty()){ 
            lstUserCusProd = [select id,Product__c,User__c,AccessType__c from UL_UserCustomerProduct__c where Product__c=:setProd limit 49999];
        }   
        if(!lstUserCusProd.isEmpty()){
            for(UL_UserCustomerProduct__c userCusObj : lstUserCusProd){
                if(!mapUserCusProd.containskey(userCusObj.Product__c)){
                    mapUserCusProd.put(userCusObj.Product__c,new list<UL_UserCustomerProduct__c>{userCusObj});
                }
                else{
                    List<UL_UserCustomerProduct__c> lstUserCus = mapUserCusProd.get(userCusObj.Product__c);
                    lstUserCus.add(userCusObj);
                    mapUserCusProd.put(userCusObj.Product__c,lstUserCus);
                }
            }
        }
        /*Create Share Record*/        
        List<ACCL__Fund__share> lstnewFundShare = new List<ACCL__Fund__share>();      
        for(Id prodId : mapProdFund.keyset()){
            if(mapUserCusProd.containskey(prodId)){
                for(Id fundId : mapProdFund.get(prodId)){
                    for(UL_UserCustomerProduct__c userCatObj : mapUserCusProd.get(prodId)){                     
                        ACCL__Fund__share fundShareObj = (ACCL__Fund__share) UL_Utility.getNewObject(Schema.SObjectType.ACCL__Fund__share); //new ACCL__Fund__share();
                        fundShareObj.ParentId = fundId;
                        fundShareObj.UserOrGroupId = userCatObj.User__c;
                        if(userCatObj.AccessType__c==system.label.Write){
                        	fundShareObj.AccessLevel = system.label.Promotion_Access_Edit;
                        }
                        else {
                        	if(userCatObj.AccessType__c==system.label.Promotion_Access_Read){
                        		fundShareObj.AccessLevel = system.label.Promotion_Access_Read;
                            }
                        }
                        fundShareObj.RowCause = system.label.Manual;
                        if(userCatObj.AccessType__c!=system.label.None){    
                            lstnewFundShare.add(fundShareObj);
                        }                           
                    }
                }
            }
        }        
        if(!lstnewFundShare.isEmpty()){
            try{
                insert lstnewFundShare;
            }
            catch(DMLException ex){
            	UL_Utility.logError(ex, UserInfo.getUserId());
            }
        }
    }
}