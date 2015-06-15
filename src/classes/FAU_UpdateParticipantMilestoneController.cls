public with sharing class FAU_UpdateParticipantMilestoneController {

	public Boolean completeStatus {get;set;}
	public Boolean showAttachments{get;set;}
	public Boolean showRecordAttachments{get;set;}
	public Boolean submitRendered {get;set;}

	public String participantDescription {get;set;}
	public String participantBanner {get;set;}
	public String milestoneCompletionType {get;set;}
	
	public FAU_Milestone_Participant__c record {get;set;}
	public Attachment attachment {get;set;}
	public List<Attachment> attachments {get;set;}
	public List<Attachment> recordAttachments {get;set;}

	public FAU_UpdateParticipantMilestoneController(ApexPages.StandardController controller){
		record = (FAU_Milestone_Participant__c) controller.getRecord();
		record = [select FAU_Participant__c,FAU_Participant__r.FAU_program_banner_url__c,FAU_Milestone__r.name, FAU_Milestone__r.FAU_Description__c,FAU_Milestone__r.FAU_Milestone_Completition__c,FAU_Milestone__r.FAU_Information_to_Complete__c,FAU_Milestone__r.FAU_Information_Link__c,FAU_Information_for_Completion__c,FAU_Status__c from FAU_Milestone_Participant__c where id =: record.id];
		participantBanner = record.FAU_Participant__r.FAU_program_banner_url__c;
		milestoneCompletionType = record.FAU_Milestone__r.FAU_Milestone_Completition__c;
		submitRendered = milestoneCompletionType == 'Participant Update' || milestoneCompletionType == 'Information Needed' || milestoneCompletionType == 'File Needed';
		attachment = new Attachment(ParentId = record.id);
		completeStatus = false;
		attachments = retriveAttachmentList();
		recordAttachments = retriveAttachmentListForCurrentRecord();
		showAttachments = !attachments.isEmpty();
		showRecordAttachments = !recordAttachments.isEmpty();
		if (milestoneCompletionType == 'Information Needed'){
			participantDescription = record.FAU_Information_for_Completion__c;
		}
		if(milestoneCompletionType == 'Participant Update'){
			completeStatus = record.FAU_Status__c == 'Completed';
		}
	}
	
	public PageReference doSave(){
		
		List<ApexPages.Message> messages = validateCompletion();
		if(messages.isEmpty()){
        	return processSave(record, attachment, participantDescription);
		} else {
			for(ApexPages.Message message : messages){
				ApexPages.addMessage(message);
			}
			return null;
		}
	}
	
	@TestVisible
	private PageReference processSave(FAU_Milestone_Participant__c record, Attachment attachment, String participantDescription){
		if(!String.isEmpty(participantDescription)) record.FAU_Information_for_Completion__c = participantDescription;
        if(!String.isEmpty(attachment.name)) insert attachment;
        record.FAU_Status__c = 'Completed';
        update record;
        return doCancel();
	}
	
	@TestVisible
	private List<ApexPages.Message> validateCompletion(){
		List<ApexPages.Message> errorMessages = new List<ApexPages.Message>();
		if(milestoneCompletionType == 'Participant Update'){
			if(!completeStatus) errorMessages.add(new ApexPages.Message(Apexpages.Severity.ERROR,'Please fill required box'));
		} else if (milestoneCompletionType == 'Information Needed'){
			if(String.isEmpty(participantDescription)) errorMessages.add(new ApexPages.Message(Apexpages.Severity.ERROR,'Please fill required box'));
		} else if (milestoneCompletionType == 'File Needed'){
			if(String.isEmpty(attachment.name)) errorMessages.add(new ApexPages.Message(Apexpages.Severity.ERROR,'Please fill required box'));
		}
		return errorMessages;
	}
	
	public PageReference doCancel(){
		return new PageReference('/apex/fau_landingpage?Id='+record.FAU_Participant__c);
	}
	
	private List<Attachment> retriveAttachmentList(){
		List<Attachment> attachments = new List<Attachment>();
		for(Attachment attachment : [select id,name from Attachment where parentId =: record.FAU_Milestone__c]) attachments.add(attachment);
		return attachments;
	}
	
	private List<Attachment> retriveAttachmentListForCurrentRecord(){
		List<Attachment> recordAttachments = new List<Attachment>();
		for(Attachment attachment : [select id,name from Attachment where parentId =: record.id]) recordAttachments.add(attachment);
		return recordAttachments;
	}

}