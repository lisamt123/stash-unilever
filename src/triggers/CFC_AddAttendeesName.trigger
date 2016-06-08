/*
  Class Name: CFC_AddAttendeesName
  Author : Mindtree
  Date: 11 March 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Add the Attendees for particular Event 
*/
 trigger CFC_AddAttendeesName on CFC_Attendee__c (before insert,after insert) {
  TriggerFactory.createHandler(CFC_Attendee__c.sObjectType);    
}