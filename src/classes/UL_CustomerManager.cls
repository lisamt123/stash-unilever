/**
 * Unilever (Phase 1 - Sprint 4)
 * @author          Devesh Murdiya
 * @version         1.0
 * @date            20/12/2016
 * @description     Helper class to get Account team information.
 */
public with sharing class UL_CustomerManager{
    /**
     * Unilever (Phase 1 - Sprint 4)
     * @author          Devesh Murdiya
     * @version         1.0
     * @date            20/12/2016
     * @description     Method for getting Account team information.
     */
    public Map<id,set<id>> customerManagerList(set<Id> accId){
        Map<id,set<id>> mapAccManger = new Map<id,set<id>>();
            try{
                for(ACCL__Account_Manager__c accManObj : [SELECT id,ACCL__Account__c,ACCL__User__c FROM ACCL__Account_Manager__c WHERE ACCL__Account__c=:accId LIMIT 49999]){
                    if(accManObj.ACCL__User__c!= UL_Utility.NULL_ID){
                        if(mapAccManger.containskey(accManObj.ACCL__Account__c)){
                            set<id> setUser = mapAccManger.get(accManObj.ACCL__Account__c);
                            setUser.add(accManObj.ACCL__User__c);
                            mapAccManger.put(accManObj.ACCL__Account__c,setUser);
                        }
                        else{
                            mapAccManger.put(accManObj.ACCL__Account__c,new set<id>{accManObj.ACCL__User__c});
                        }
                    }
                 }   
             }catch(Exception ex){
                 UL_Utility.logError(ex, UserInfo.getUserId());
             }   

        return mapAccManger;
    }
    /**
     * Unilever (Phase 1 - Sprint 4)
     * @author          Devesh Murdiya
     * @version         1.0
     * @date            20/12/2016
     * @description     Method for deleting Account team information.
     */  
    public List<ACCL__Account_Manager__c> deletecustomerManagerList(Map<id,set<Id>> mapaccteam){
        List<ACCL__Account_Manager__c> lstdelAccManger = new List<ACCL__Account_Manager__c>();
        try{
            for(ACCL__Account_Manager__c accManObj : [select id,ACCL__Account__c,ACCL__User__c from ACCL__Account_Manager__c where ACCL__Account__c=:mapaccteam.keyset() and UL_Create_Type__c =: system.label.Manual limit 49999]){
                if(accManObj.ACCL__User__c!=null){
                    if(mapaccteam.containskey(accManObj.ACCL__Account__c) && mapaccteam.get(accManObj.ACCL__Account__c).contains(accManObj.ACCL__User__c)){
                        lstdelAccManger.add(accManObj);
                    }                   
              }
            }
        }catch(Exception ex){
                 UL_Utility.logError(ex, UserInfo.getUserId());
        }
        return lstdelAccManger;
    }   
}