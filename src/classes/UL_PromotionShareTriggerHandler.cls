/**
 * Unilever (Phase 1 - Sprint 4)
 * @author          Devesh Murdiya
 * @version         1.0
 * @date            06/12/2016
 * @description     Helper class for Promotion Share Trigger to Enable or Disable Apex Sharing with User.
 */
global with sharing class UL_PromotionShareTriggerHandler{
    /**
     * Unilever (Phase 1 - Sprint 4)
     * @author          Devesh Murdiya
     * @version         1.0
     * @date            06/12/2016
     * @description     Method for call Promotion Share Trigger to Enable on Promotion record.
     */    
    public static void enableApexSharing(list<id> lstpromCatId){
        List<UL_PromotionCategory__c> newlstPromCat = [select id,Promotion__c,Product__c,Account__c from UL_PromotionCategory__c where  id=:lstpromCatId limit 49999];
        /*Getting the Product and account for promotion*/
        Map<Id,Id> mapProd = new Map<Id,Id>();
        set<id> setpromid = new set<id>();
        set<Id> setProd = new set<Id>();
        set<Id> setAcc = new set<Id>();
        map<id,id>  mapPromAcc = new map<id,id>();
        Map<id,set<id>> mapAccManger = new Map<id,set<id>>();        
        for(UL_PromotionCategory__c promCatObj : newlstPromCat){
            setpromid.add(promCatObj.Promotion__c);
            setProd.add(promCatObj.Product__c);
            setAcc.add(id.valueof(promCatObj.Account__c));
            mapPromAcc.put(promCatObj.Promotion__c,id.valueof(promCatObj.Account__c));
            if(promCatObj.Promotion__c!=null){
                if(!mapProd.containskey(promCatObj.Promotion__c)){
                    mapProd.put(promCatObj.Promotion__c,promCatObj.Product__c);
                }
            }
        }        
        /*Comparing promotion data with User customer Produt*/
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
        
        /*Get the Account team information*/
        if(!setAcc.isEmpty()){
            UL_CustomerManager customerManager = new UL_CustomerManager();
            mapAccManger = customerManager.customerManagerList(setAcc);
        }
        
        /*Create Share Record*/
        List<ACCL__Promotion__share> lstPromShare = new List<ACCL__Promotion__share>();
        List<ACCL__Promotion__share> lstnewPromShare = new List<ACCL__Promotion__share>();
        List<ACCL__Account_Manager__c> lstAccManager = new List<ACCL__Account_Manager__c>();
        map<id,id> mapShare = new map<id,id>();     
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
                            ACCL__Promotion__share promShareObj = (ACCL__Promotion__share) UL_Utility.getNewObject(Schema.SObjectType.ACCL__Promotion__share);  //new ACCL__Promotion__share();
                            promShareObj.ParentId = promId;
                            promShareObj.UserOrGroupId = userCatObj.User__c;
                            if(userCatObj.AccessType__c==system.label.Write){
                                promShareObj.AccessLevel = system.label.Promotion_Access_Edit;
                            }
                            else {
                                if(userCatObj.AccessType__c==system.label.Promotion_Access_Read){
                                    promShareObj.AccessLevel = system.label.Promotion_Access_Read;
                                }
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
                                else {
                                    if(mapAccManger.isEmpty() || !mapAccManger.containskey(mapPromAcc.get(promId))){
                                        //create Account team
                                        ACCL__Account_Manager__c accMan = (ACCL__Account_Manager__c)UL_Utility.getNewObject(Schema.SObjectType.ACCL__Account_Manager__c); //new ACCL__Account_Manager__c();
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
}