/**
 * @author Pooja Kanani
 * @date 25/01/2016
 * @description - This Class is used to perform operation on event of Termination Requested  Trigger
 */
public class CPA_Termination_Requested_TriggerUtil{
    
    public static void updatePwoOnTR(List<CPA_Termination_Requested__c> newTR){
        
        set<Id> setPWO = new set<ID>();
        map<Id,CPA_PWO__c> mapPWO = new map<ID,CPA_PWO__c>();
        
        for(CPA_Termination_Requested__c objnewTR : newTR){
                setPWO.add(objnewTR.PWO__c);
            }
        for(CPA_PWO__c objPwo : [select id, pkl_Status__c from CPA_PWO__c where ID  IN: setPWO]){
                mapPWO.put(objPwo.Id,objPwo);
            }
            
        for(CPA_Termination_Requested__c objnewTR : newTR){
            CPA_PWO__c objPWOTemp = mapPWO.get(objnewTR.PWO__c);
            if(objPWOTemp !=null){
                objPWOTemp.pkl_Status__c ='Request For Termination';
                update objPWOTemp;
            }
        }
    }    

}