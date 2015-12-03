trigger IPM_Project_Document_Section_Content_Trigger on IPM_Project_Document_Section_Content__c (after delete, after insert, after update, before delete, before insert, before update) {
	TriggerFactory.createHandler(IPM_Project_Document_Section_Content__c.sObjectType);
}