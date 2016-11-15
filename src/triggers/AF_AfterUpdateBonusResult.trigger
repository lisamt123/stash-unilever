trigger AF_AfterUpdateBonusResult on AF_Bonus_Results__c (after update,after insert) {
   system.debug('** AF_StopRecursiveOcc.hasAlreadyCreated() : ' + AF_StopRecursiveOcc.hasAlreadyCreated());
    if (!AF_StopRecursiveOcc.hasAlreadyCreated() && !(system.isBatch() || system.isFuture())) {
        system.debug('** Trigger being called : ' + AF_StopRecursiveOcc.hasAlreadyCreated());
      List<AF_Bonus_Results__c> BonusResultsCollection;  
     Set<Id> BonusResultIds = new Set<Id>();
  
     if(Trigger.isUpdate) {       
          AF_AfterUpdateBonusResHandler.AF_AfterUpdHandler(Trigger.new);
          
      }
    AF_StopRecursiveOcc.setAlreadyCreated();
       
    }
}