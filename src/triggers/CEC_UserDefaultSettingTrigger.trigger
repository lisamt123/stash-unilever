trigger CEC_UserDefaultSettingTrigger on User_Default_Setting__c (before insert,before update) {
    
    for(User_Default_Setting__c obj:trigger.new){
         obj.UserId__c = obj.UserName__c;
         obj.ownerId = obj.UserName__c;
    }
    
}