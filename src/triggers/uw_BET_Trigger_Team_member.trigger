/* -----------------------------------------------------------------------------------------------------------------------
   Name:        uw_BET_Trigger_Team_member.trigger 
   Description: 1) Main Trigger for uw_BET_Team_Member__c object
                
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   December 2013     1.0        Teenu Pius           Initial Release for BET 2.0
   August   2015     1.1  m.bluj@polsource.com       IPM related changes implementation
  ------------------------------------------------------------------------------------------------------------------------ */

trigger uw_BET_Trigger_Team_member on uw_BET_Team_Member__c (after delete, after insert, after undelete,
after update, before delete, before insert, before update ) {

  if(((Trigger.isInsert && Trigger.isafter) || 
      (Trigger.isdelete && Trigger.isafter) || 
      (Trigger.isupdate && Trigger.isafter)|| 
      (Trigger.isundelete && Trigger.isafter)) && uw_bet_update_totalnumberof_betmembers.firstRun_updatetotalnum){
    //Making sure trigger is called only once
      uw_bet_update_totalnumberof_betmembers.firstRun_updatetotalnum = false;
      //This makes sure  trigger on uw_bet__C is called
      uw_bet_update_totalnumberof_betmembers.runAccount_trigger = true;
      //Calling the static method to recalculate
      uw_bet_update_totalnumberof_betmembers.updatetotalnumber(Trigger.new,Trigger.old); 
  }
  BET_TriggerFactory.createHandler(uw_BET_Team_Member__c.sObjectType);
}