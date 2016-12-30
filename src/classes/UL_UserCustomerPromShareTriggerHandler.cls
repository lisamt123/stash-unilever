/**
 * Unilever (Phase 1 - Sprint 4)
 * @author          Devesh Murdiya
 * @version         1.0
 * @date            06/12/2016
 * @description     Helper class for Promotion Share Trigger to Enable or Disable Apex Sharing with User.
 */
global with sharing class UL_UserCustomerPromShareTriggerHandler{    
    /**
     * Unilever (Phase 1 - Sprint 4)
     * @author          Devesh Murdiya
     * @version         1.0
     * @date            06/12/2016
     * @description     Method for call UserCustomerPromotionShareTrigger to Enable sharing on Promotion record.
     */
    @future (callout=true)
    public static void userCusenableApexSharing(list<id> lstUserCatId){
        /*Getting User customer Produt*/
        set<Id> setProd = new set<Id>();        
        List<UL_UserCustomerProduct__c> lstUserCusProd = [select id,Product__c,User__c,AccessType__c from UL_UserCustomerProduct__c where id=:lstUserCatId limit 49999];
        map<Id,List<UL_UserCustomerProduct__c>> mapUserCusProd = new map<Id,List<UL_UserCustomerProduct__c>>();
        set<Id> setAcc = new set<Id>();
        map<id,id>  mapPromAcc = new map<id,id>();
        Map<id,set<id>> mapAccManger = new Map<id,set<id>>();    
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
        /*Get Promotion Category and Promotion Records*/
        List<UL_PromotionCategory__c> lstPromCat = new List<UL_PromotionCategory__c>();
        lstPromCat = [select id,Promotion__c,Product__c,Account__c from UL_PromotionCategory__c where Product__c=:setProd limit 49999];                        
        Map<id,Id> mapProd = new Map<id,Id>();
        map<id,id> mapShare = new map<id,id>();        
        if(!lstPromCat.isEmpty()){          
            for(UL_PromotionCategory__c promCatObj : lstPromCat){
                setAcc.add(id.valueof(promCatObj.Account__c));
                mapPromAcc.put(promCatObj.Promotion__c,id.valueof(promCatObj.Account__c));  
                mapProd.put(promCatObj.Promotion__c,promCatObj.Product__c);
            }        
        }
        
        /*Get the Account team information*/
        if(!setAcc.isEmpty()){
            UL_CustomerManager uc = new UL_CustomerManager();
            mapAccManger = uc.customerManagerList(setAcc);
        }
        
        /*Create Share Record*/
        List<ACCL__Promotion__share> lstPromShare = new List<ACCL__Promotion__share>();
        List<ACCL__Promotion__share> lstnewPromShare = new List<ACCL__Promotion__share>();
        List<ACCL__Account_Manager__c> lstAccManager = new List<ACCL__Account_Manager__c>();  
        if(!mapUserCusProd.isEmpty() && !mapProd.isEmpty()){
            lstPromShare = [select id,ParentId,UserOrGroupId from ACCL__Promotion__share where ParentId=:mapProd.keyset() limit 49999];
            if(!lstPromShare.isEmpty()){
                for(ACCL__Promotion__share promshare : lstPromShare){
                    mapShare.put(promshare.ParentId,promshare.UserOrGroupId);
                }
            }
            for(Id promId : mapProd.keyset()){
                if(mapUserCusProd.containskey(mapProd.get(promId))){
                    for(UL_UserCustomerProduct__c userCatObj : mapUserCusProd.get(mapProd.get(promId))){
                        if(!mapShare.containskey(promId) || (mapShare.containskey(promId) && mapShare.get(promId)!=userCatObj.User__c)){
                            ACCL__Promotion__share promShareObj = (ACCL__Promotion__share)UL_Utility.getNewObject(Schema.SObjectType.ACCL__Promotion__share);  //new ACCL__Promotion__share();
                            promShareObj.ParentId = promId;
                            promShareObj.UserOrGroupId = userCatObj.User__c;
                            if(userCatObj.AccessType__c==system.label.Write){
                                promShareObj.AccessLevel = system.label.Promotion_Access_Edit;
                            }
                            else if(userCatObj.AccessType__c==system.label.Promotion_Access_Read){
                                promShareObj.AccessLevel = system.label.Promotion_Access_Read;
                            }
                            promShareObj.RowCause = system.label.Manual;
                            if(userCatObj.AccessType__c!=system.label.None){    
                                lstnewPromShare.add(promShareObj);
                                if(!mapAccManger.isEmpty() && mapPromAcc.containskey(promId) && mapAccManger.containskey(mapPromAcc.get(promId)) && !mapAccManger.get(mapPromAcc.get(promId)).contains(userCatObj.User__c)){
                                    //create Account team
                                    ACCL__Account_Manager__c accMan = (ACCL__Account_Manager__c)UL_Utility.getNewObject(Schema.SObjectType.ACCL__Account_Manager__c);  //new ACCL__Account_Manager__c();
                                    accMan.ACCL__Active__c = true;
                                    accMan.ACCL__Account__c = mapPromAcc.get(promId);
                                    accMan.ACCL__User__c = userCatObj.User__c;
                                    accMan.ACCL__Valid_From__c = system.today();
                                    accMan.ACCL__Valid_Thru__c = Date.newInstance(2099, 12, 31);
                                    accMan.UL_Create_Type__c = system.label.Manual;
                                    lstAccManager.add(accMan);
                                }
                                else if(mapAccManger.isEmpty() || !mapAccManger.containskey(mapPromAcc.get(promId))){
                                    //create Account team
                                    ACCL__Account_Manager__c accMan = (ACCL__Account_Manager__c)UL_Utility.getNewObject(Schema.SObjectType.ACCL__Account_Manager__c);  //new ACCL__Account_Manager__c();
                                    accMan.ACCL__Active__c = true;
                                    accMan.ACCL__Account__c = mapPromAcc.get(promId);
                                    accMan.ACCL__User__c = userCatObj.User__c;
                                    accMan.ACCL__Valid_From__c = system.today();
                                    accMan.ACCL__Valid_Thru__c = Date.newInstance(2099, 12, 31);
                                    accMan.UL_Create_Type__c = system.label.Manual;
                                    lstAccManager.add(accMan);
                                }
                            }
                        }
                    }
                }
            }
        }
        if(!lstnewPromShare.isEmpty()){
            try{
                insert lstnewPromShare;
                insert lstAccManager;
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
     * @description     Method for call UserCustomerPromotionShareTrigger to Disable sharing on Promotion record.
     */    
    public static void userCusDisableApexSharing(list<UL_UserCustomerProduct__c> lstUserCusProd){
        /*Getting User customer Produt*/
        set<Id> setProd = new set<Id>();               
        map<Id,List<UL_UserCustomerProduct__c>> mapUserCusProd = new map<Id,List<UL_UserCustomerProduct__c>>();
        set<Id> setAcc = new set<Id>();
        map<id,id>  mapPromAcc = new map<id,id>();    
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
        /*Get Promotion Category and Promotion Records*/
        List<UL_PromotionCategory__c> lstPromCat = new List<UL_PromotionCategory__c>();
        lstPromCat = [select id,Promotion__c,Product__c,Account__c from UL_PromotionCategory__c where Product__c=:setProd limit 49999];        
        Map<id,Id> mapPromcatProd = new Map<id,Id>();        
        Map<id,set<Id>> mapAccUser = new Map<id,set<Id>>();         
        
        for(UL_PromotionCategory__c promCatObj : lstPromCat){
            setAcc.add(id.valueof(promCatObj.Account__c));
            mapPromAcc.put(promCatObj.Promotion__c,id.valueof(promCatObj.Account__c));  
            mapPromcatProd.put(promCatObj.Promotion__c,promCatObj.Product__c);
        }                      
        
        /*Delete Share Record*/
        List<ACCL__Promotion__share> lstPromShare = new List<ACCL__Promotion__share>();
        //set<id> setPromDelId = new set<id>();     
        lstPromShare = [select id,ParentId,UserOrGroupId from ACCL__Promotion__share where ParentId=:mapPromcatProd.keyset() limit 49999];
        List<ACCL__Promotion__share> lstDelPromShare = new List<ACCL__Promotion__share>();
        List<ACCL__Account_Manager__c> lstdelAccManger = new List<ACCL__Account_Manager__c>();
        if(!mapUserCusProd.isEmpty() && !mapPromcatProd.isEmpty() && !lstPromShare.isEmpty()){
            for(Id promId : mapPromcatProd.keyset()){
                if(mapUserCusProd.containskey(mapPromcatProd.get(promId))){
                    for(UL_UserCustomerProduct__c userCatObj : mapUserCusProd.get(mapPromcatProd.get(promId))){                     
                        for(ACCL__Promotion__share promshare : lstPromShare){
                            if(promshare.ParentId==promId && promshare.UserOrGroupId==userCatObj.user__c){
                                lstDelPromShare.add(promshare);
                                if(mapPromAcc.get(promId)!=null){
                                    if(mapAccUser.containskey(mapPromAcc.get(promId))){
                                        set<id> setUser = mapAccUser.get(mapPromAcc.get(promId));
                                        setUser.add(userCatObj.user__c);
                                        mapAccUser.put(mapPromAcc.get(promId),setUser);
                                    }
                                    else{
                                        mapAccUser.put(mapPromAcc.get(promId),new set<id>{userCatObj.user__c});
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
        }
                
        if(!lstDelPromShare.isEmpty()){
            try{
                delete lstDelPromShare;
            }
            catch(DMLException ex){
                UL_Utility.logError(ex, UserInfo.getUserId());
            }
        }
        /*Delete Account Team*/
        if(!mapAccUser.isEmpty()){
            UL_CustomerManager uc = new UL_CustomerManager();
            lstdelAccManger = uc.deletecustomerManagerList(mapAccUser); 
        }
        if(!lstdelAccManger.isEmpty()){
            try{
                delete lstdelAccManger;
            }
            catch(DMLException ex){
                UL_Utility.logError(ex, UserInfo.getUserId());
            }
        }
    }
}