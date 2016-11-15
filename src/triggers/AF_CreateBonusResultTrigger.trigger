trigger AF_CreateBonusResultTrigger on AF_Bonus_Threshold__c (after insert) {
    
    //list variable for Bonus result to create new reords
    list<AF_Bonus_Results__c> bonusResultObjList = new list<AF_Bonus_Results__c>();
    
    //get Bonuus annual record type id
    String recTypeId = [select id from recordType where name='Bonus Annual' AND SobjectType='AF_Bonus_Results__c'].Id;
    
    for(AF_Bonus_Threshold__c bonusThObj : trigger.new){
        if(bonusThObj.AF_Pilot_Model__c==false){
        AF_Bonus_Results__c bonResObj = new AF_Bonus_Results__c();
        bonResObj.RecordTypeId=recTypeId;
        bonResObj.AF_Bonus_Thresholds__c=bonusThObj.Id;
        bonusResultObjList.add(bonResObj);
        }
    }
    
    if(!bonusResultObjList.isEmpty()){
        
        try{
            insert bonusResultObjList;
        }catch(DMLException ex){
            system.debug('++++'+ex);
        }
    }
}