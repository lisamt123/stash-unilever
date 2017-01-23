/**************************************************************************************************************
* @Trigger          : UL_AccountTrigger
* @Description      : Trigger on Account
* @CreatedBy/Date   : Accenture IDC, 1/10/2016
* @Updates By/Date  : 
**************************************************************************************************************/ 
trigger UL_AccountTrigger on Account(before insert,before update,after insert) {
    
     if(trigger.isBefore){
            if(trigger.isInsert){
                UL_AccountTriggerHandler.beforeInsert(trigger.new);
            }
            if(trigger.isUpdate){
                UL_AccountTriggerHandler.beforeUpdate(trigger.oldMap,trigger.newMap);
            }
        }
    if(trigger.isAfter){
        if(trigger.isInsert){
           UL_AccountTriggerHandler.afterInsert(trigger.oldMap,trigger.newMap); 
        }
    }
    
    //call handler method for Planning Level functionality only if Planning Level = TRUE
    Boolean  callPlanLevMethod = FALSE ;
    try{
        for(Account newAcc : Trigger.new){
            if(newAcc.UL_Planning_Level__c && newAcc.UL_Planning_Level__c <> Trigger.oldMap.get(newAcc.Id).UL_Planning_Level__c){
                callPlanLevMethod = TRUE ;    
            }
            
        }
        
        if(callPlanLevMethod){
            UL_AccountTriggerHandler.planningLevelValidations(trigger.old, trigger.oldMap, trigger.new, trigger.newMap);
        }
    }
    catch(Exception e)
    {
        System.debug('An Exception occurred in Level trigger :' +e.getMessage());
    }
}