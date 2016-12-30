trigger UL_Tactic_trigger on ACCL__Tactic__c (after update, before insert, after delete) {
list<ACCL__Tactic__c> tacticlist = new list<ACCL__Tactic__c>();
if(trigger.isafter && trigger.isupdate){

UL_FundAmountUpdateHandler.FundAmountUpdate(trigger.new);
}

/*if(trigger.isinsert && trigger.isbefore){
 for(ACCL__Tactic__c TacticDetails : trigger.new){
  
  //Validation error for the tactics overapping which having tactic templates enabled in TacticOverlap
   tacticlist.add(TacticDetails);
  
  system.debug('tactic value is-'+TacticDetails.ACCL__Tactic_Template__c+'check box is-'+TacticDetails.ACCL__Tactic_Template__r.UL_TacticOverlap__c);
 }
 if(tacticlist!=null && tacticlist.size()>0){
 UL_Tactic_triggerHandler.ul_TacticsOverlap(tacticlist);
 }
}*/
}