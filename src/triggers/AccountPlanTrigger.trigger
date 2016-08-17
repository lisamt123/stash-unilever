/* * Handler class AccountPlanTrigger for Account Plan approval process
*  @name AccountPlanTrigger
*  @param
*  @return 
*  @throws 
*/ 
trigger AccountPlanTrigger on FS_Account_Plan__c (after insert, after update, before insert, before update) {
    FS_AccountPlanHandler handler=new FS_AccountPlanHandler();
    //Update approved and status on defined objective after account plan record is modified
    if(trigger.isAfter && trigger.isUpdate){
       //Call handler method for update objective as per approval outcomes
       handler.accountPlanApproval(Trigger.new,Trigger.OldMap); 
    }
}