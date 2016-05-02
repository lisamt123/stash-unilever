public with sharing class FAU_LandingPage_Controller {

	public List<FAU_Milestone_Participant__c> milestoneParticipants {get;set;}
	public List<FAU_Module_Participant__c> moduleParticipants {get;set;}
	public String pageState {get;set;}

    public FAU_LandingPage_Controller() {

    }

    public FAU_LandingPage_Controller(ApexPages.StandardController controller) {
    	if(!Test.isRunningTest()) controller.addFields(new List<String>{'FAU_Invite_State__c'});
    	FAU_Participant__c record = (FAU_Participant__c)controller.getRecord();
    	pageState = record.FAU_Invite_State__c;
		FAU_Participant__c rec = [select id,FAU_Invite_State__c,
								 (select id, name , FAU_Module_Start_Date__c,FAU_Module_End_Date__c,FAU_Module_Complete_Flag__c,FAU_Status__c,FAU_Module_Name__c from FAU_Module_Participants__r order by FAU_Module_Start_Date__c asc),
								 (select id,FAU_Milestone_Name__c,FAU_Due_Date__c,FAU_Milestone__r.FAU_Milestone_Completition__c,FAU_Status__c  from Milestone_Participants__r order by FAU_Due_Date__c asc) from FAU_Participant__c where id=:record.id];
								 
		milestoneParticipants  = rec.Milestone_Participants__r;
		moduleParticipants = rec.FAU_Module_Participants__r;
								 
    }
}