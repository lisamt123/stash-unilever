/**
 * Unilever (Phase 1 - Sprint 4)
 * @author          Devesh Murdiya
 * @version         1.0
 * @date            06/12/2016
 * @description     Helper class for Fund Share Trigger to Enable or Disable Apex Sharing with User.
 */
global with sharing class UL_UserCustomerFundShareTriggerHandler{    
    /**
     * Unilever (Phase 1 - Sprint 4)
     * @author          Devesh Murdiya
     * @version         1.0
     * @date            06/12/2016
     * @description     Method for call UserCustomerFundShareTrigger to Enable sharing on Fund record.
     */
    @future (callout=true)
    public static void userCusenableApexSharing(list<id> lstUserCatId){
        /*Getting User customer Produt*/
        set<Id> setProd = new set<Id>();        
        List<UL_UserCustomerProduct__c> lstUserCusProd = [select id,Product__c,User__c,AccessType__c from UL_UserCustomerProduct__c where id=:lstUserCatId limit 49999];
        map<Id,List<UL_UserCustomerProduct__c>> mapUserCusProd = new map<Id,List<UL_UserCustomerProduct__c>>();
            
        if(!lstUserCusProd.isEmpty()){
            for(UL_UserCustomerProduct__c userCusObj : lstUserCusProd){
                setProd.add(userCusObj.Product__c);                
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
        /*Get Fund Records*/
        List<ACCL__Fund__c> lstFund = new List<ACCL__Fund__c>();
        lstFund = [select id,ACCL__Anchor_Product__c from ACCL__Fund__c where ACCL__Anchor_Product__c=:setProd limit 49999];                        
        Map<Id,List<id>> mapProdFund = new Map<Id,List<id>>();  
        map<id,id> mapShare = new map<id,id>();
        set<Id> fundsId = new set<Id>();    
        if(!lstFund.isEmpty()){
            for(ACCL__Fund__c fundObj : lstFund){
                fundsId.add(fundObj.id);
                if(fundObj.ACCL__Anchor_Product__c!=null){ 
                    if(!mapProdFund.containskey(fundObj.ACCL__Anchor_Product__c)){
                        mapProdFund.put(fundObj.ACCL__Anchor_Product__c,new List<id>{fundObj.id});
                    }
                    else{
                        List<Id> lstId = mapProdFund.get(fundObj.ACCL__Anchor_Product__c);
                        lstId.add(fundObj.Id);
                        mapProdFund.put(fundObj.ACCL__Anchor_Product__c,lstId);
                    }
                }
            }        
        }
        /*Create Share Record*/
        List<ACCL__Fund__share> lstFundShare = new List<ACCL__Fund__share>();
        List<ACCL__Fund__share> lstnewFundShare = new List<ACCL__Fund__share>();    
        if(!mapUserCusProd.isEmpty() && !mapProdFund.isEmpty()){
            lstFundShare = [select id,ParentId,UserOrGroupId from ACCL__Fund__share where ParentId=:fundsId limit 49999];
            if(!lstFundShare.isEmpty()){
                for(ACCL__Fund__share fundShare : lstFundShare){
                    mapShare.put(fundShare.ParentId,fundShare.UserOrGroupId);
                }
            }
            for(Id prodId : mapProdFund.keyset()){
                if(mapUserCusProd.containskey(prodId)){
                    for(Id fundId : mapProdFund.get(prodId)){
                        for(UL_UserCustomerProduct__c userCatObj : mapUserCusProd.get(prodId)){
                            if(!mapShare.containskey(fundId) || (mapShare.containskey(fundId) && mapShare.get(fundId)!=userCatObj.User__c)){    
                                ACCL__Fund__share fundShareObj = (ACCL__Fund__share)UL_Utility.getNewObject(Schema.SObjectType.ACCL__Fund__share);  //new ACCL__Fund__share();
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
    /**
     * Unilever (Phase 1 - Sprint 4)
     * @author          Devesh Murdiya
     * @version         1.0
     * @date            06/12/2016
     * @description     Method for call UserCustomerFundShareTrigger to Disable sharing on Fund record.
     */    
    public static void userCusDisableApexSharing(list<UL_UserCustomerProduct__c> lstUserCusProd){
        /*Getting User customer Produt*/
        set<Id> setProd = new set<Id>();               
        map<Id,List<UL_UserCustomerProduct__c>> mapUserCusProd = new map<Id,List<UL_UserCustomerProduct__c>>();
            
        if(!lstUserCusProd.isEmpty()){
            for(UL_UserCustomerProduct__c userCusObj : lstUserCusProd){
                setProd.add(userCusObj.Product__c);                
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
        /*Get Fund Records*/
        List<ACCL__Fund__c> lstFund = new List<ACCL__Fund__c>();
        lstFund = [select id,ACCL__Anchor_Product__c from ACCL__Fund__c where ACCL__Anchor_Product__c=:setProd limit 49999];        
        Map<id,List<Id>> mapFundProd = new Map<id,List<Id>>();                        
        set<Id> fundsId = new set<Id>();
        for(ACCL__Fund__c fundObj : lstFund){ 
            fundsId.add(fundObj.Id);            
            if(!mapFundProd.containskey(fundObj.ACCL__Anchor_Product__c)){
                mapFundProd.put(fundObj.ACCL__Anchor_Product__c,new List<id>{fundObj.id});
            }
            else{
                List<Id> lstId = mapFundProd.get(fundObj.ACCL__Anchor_Product__c);
                lstId.add(fundObj.Id);
                mapFundProd.put(fundObj.ACCL__Anchor_Product__c,lstId);
            }           
        }                      
        
        /*Delete Share Record*/
        List<ACCL__Fund__share> lstFundShare = new List<ACCL__Fund__share>();
        //set<id> setPromDelId = new set<id>();     
        lstFundShare = [select id,ParentId,UserOrGroupId from ACCL__Fund__share where ParentId=:fundsId limit 49999];
        List<ACCL__Fund__share> lstDelFundShare = new List<ACCL__Fund__share>();
        if(!mapUserCusProd.isEmpty() && !mapFundProd.isEmpty() && !lstFundShare.isEmpty()){
            for(Id prodId : mapFundProd.keyset()){
                for(Id fundId :mapFundProd.get(prodId)){
                    if(mapUserCusProd.containskey(prodId)){
                        for(UL_UserCustomerProduct__c userCatObj : mapUserCusProd.get(prodId)){                     
                            for(ACCL__Fund__share fundShare : lstFundShare){
                                if(fundShare.ParentId==fundId && fundShare.UserOrGroupId==userCatObj.user__c){
                                    lstDelFundShare.add(fundShare);
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        if(!lstDelFundShare.isEmpty()){
            try{
                delete lstDelFundShare;
            }
            catch(DMLException ex){
                UL_Utility.logError(ex, UserInfo.getUserId());
            }
        }
    }
}