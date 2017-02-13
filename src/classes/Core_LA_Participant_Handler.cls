/*
Class Name: Core_LA_Participant_Handler
Author : Mindtree
Date: 12 Feb 2017
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: 1) Used to Notify Admin
*                          2) Used to give access to specific users - Apex sharing
*                          3) Used for Entity Subscription
*/

public class Core_LA_Participant_Handler {

 public void handleAfterInsert(List < CORE_LA_Participant__c > particapantList) {
  for (CORE_LA_Participant__c participant: particapantList) {


  }

 }

 public void handleAfterUpdate(List < CORE_LA_Participant__c > participantNew, List < CORE_LA_Participant__c > participantOld) {
  List < CORE_LA_Participant__c > adminId = new List < CORE_LA_Participant__c >();
  List < FeedItem > lstFeedItem = new List < FeedItem > ();
  

 
  for (CORE_LA_Participant__c participant: participantNew) {
  
    String strBody = 'Dear xxx, \n yyy has Registered for the below event: \n Event Name : zzz \n Thanks';
    CORE_LA_Participant__c newParti = participantNew[0];
    CORE_LA_Participant__c oldParti = participantOld[0];
    
   List < CORE_LA_Participant__c > partiList = new List < CORE_LA_Participant__c > ([SELECT Id, Role__c, Status__c, Participant_Name__r.Name, Event__r.Name FROM CORE_LA_Participant__c WHERE Event__c = : participant.Event__c]);
   
  
   for (CORE_LA_Participant__c parti: partiList) {
   
    if (parti.Role__c == 'Admin') {
     adminId.add(parti);
    }
    if(newParti.Status__c == 'Registered' && newParti.Status__c != oldParti.Status__c)
    {
        if(newParti.Participant_Name__c == parti.Participant_Name__c)
        {
            strBody = strBody.replace('yyy',parti.Participant_Name__r.Name);
        }
        }
    
   }
    if(newParti.Status__c == 'Registered' && newParti.Status__c != oldParti.Status__c)
    {
        for(CORE_LA_Participant__c admId : adminId)
        {
                strBody = strBody.replace('xxx',admId.Participant_Name__r.Name);
                strBody = strBody.replace('zzz', admId.Event__r.Name);
                lstFeedItem.add(new FeedItem(Type = 'TextPost', Body = strBody, ParentId = admId.Participant_Name__c, Title = admId.Event__r.Name ));
                strBody = strBody.replace(admId.Participant_Name__r.Name, 'xxx');
            }
   }
   
  }
  
  if (!lstFeedItem.isEmpty()) {
   Database.insert(lstFeedItem);
  }


 }

 public void handleAfterDelete(List < CORE_LA_Participant__c > particapantList) {

 }

}