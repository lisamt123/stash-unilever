trigger Af_AfterInsertBonusThresholdShare on AF_Bonus_Threshold__c (before insert,before update,after insert) {
    
    if(Trigger.isAfter){
    AF_BonusThresholdHelper.shareRecordToUser(trigger.new);
    }  
    if(Trigger.isBefore){
    for(AF_Bonus_Threshold__c b:trigger.new){
        if(b.AF_Minimum__c==0 && b.AF_Stretching__c==0 && b.AF_Outstanding__c==0 )
        {
        b.addError('Please ensure the values entered in the target threshold fields are ascending from minimum to outstanding');
        }
        else if((b.AF_Minimum__c >= b.AF_Stretching__c || b.AF_Minimum__c >= b.AF_Outstanding__c )){
        b.addError('Please ensure the values entered in the target threshold fields are ascending from minimum to outstanding');
        }
        else if((b.AF_Stretching__c  >= b.AF_Outstanding__c || b.AF_Stretching__c <=b.AF_Minimum__c )){
           b.addError('Please ensure the values entered in the target threshold fields are ascending from minimum to outstanding');
        }
         else if((b.AF_Outstanding__c  <= b.AF_Minimum__c || b.AF_Outstanding__c <=b.AF_Stretching__c )){
           b.addError('Please ensure the values entered in the target threshold fields are ascending from minimum to outstanding');
        }
        
    }
    }
}