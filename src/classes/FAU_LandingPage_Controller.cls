public with sharing class FAU_LandingPage_Controller {

	public List<FAU_Milestone_Participant__c> milestoneParticipants {get;set;}
	public List<FAU_Module_Participant__c> moduleParticipants {get;set;}
	public String pageState {get;set;}
    public Boolean isUL2020 {get;set;}
    public Boolean chatterGroupId{get;set;}
    public Boolean tablechatterGroupId{get;set;}
    public FAU_LandingPage_Controller() {

    }

    public FAU_LandingPage_Controller(ApexPages.StandardController controller) {
    	if(!Test.isRunningTest()) controller.addFields(new List<String>{'FAU_Invite_State__c'});
    	FAU_Participant__c record = (FAU_Participant__c)controller.getRecord();
    	pageState = record.FAU_Invite_State__c;
        FAU_Participant__c rec = [select id,FAU_Invite_State__c, FAU_Program_Wave__c, FAU_Program_Wave__r.name, PII_Chatter_Group_Link__c, PII_Table_Chatter_Group_Link__c,FAU_Participant__c.FAU_PII__r.FAU_PII_Chatter_Group_Id__c, FAU_PII__r.PII_Table__r.FAU_Participant_Chatter_Group_Id__c,
                                 (select id, name, FAU_Module_Start_Date__c,FAU_Module_End_Date__c,FAU_Module_Complete_Flag__c,FAU_Status__c,FAU_Module_Name__c from FAU_Module_Participants__r order by FAU_Module_Start_Date__c asc),
                                 (select id,FAU_Milestone_Name__c,FAU_Due_Date__c,FAU_Milestone__r.FAU_Milestone_Completition__c,FAU_Status__c  from Milestone_Participants__r order by FAU_Due_Date__c asc) from FAU_Participant__c where id=:record.id];
        if(String.isnotBlank(rec.FAU_PII__r.FAU_PII_Chatter_Group_Id__c)){
        chatterGroupId = true;
        } 
        if(String.isnotBlank(rec.FAU_PII__r.PII_Table__r.FAU_Participant_Chatter_Group_Id__c)){
        tablechatterGroupId = true;
        }                                
        milestoneParticipants  = rec.Milestone_Participants__r;
        moduleParticipants = rec.FAU_Module_Participants__r;
        isUL2020 = FAU_Utilities.isRectypeUL2020(rec);                       
    }
}