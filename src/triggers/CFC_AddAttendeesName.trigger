/*
  Class Name: CFC_AddAttendeesName
  Author : Mindtree
  Date: 11 March 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Add the Attendees for particular Event 
*/


 trigger CFC_AddAttendeesName on CFC_Attendee__c (before insert,after insert) {
/*
    if(trigger.isBefore){
         Set<ID> setEventId=new Set<ID>();
         Map<Id,Set<Id>> mapIdsForAttendees=new Map<Id,Set<Id>>();
         for(CFC_Attendee__c rec : trigger.new){
             setEventId.add(rec.Event__c);
         }
         List<CFC_Attendee__c> lstAttendies=[SELECT CFC_Attendee__c,Event__c,Name FROM CFC_Attendee__c where Event__c in:setEventId];
         for(CFC_Attendee__c attendee:lstAttendies){
            if(!mapIdsForAttendees.containsKey(attendee.Event__c))
               mapIdsForAttendees.put(attendee.Event__c,new Set<Id>());            
            mapIdsForAttendees.get(attendee.Event__c).add(attendee.CFC_Attendee__c);
         }
         for(CFC_Attendee__c rec : trigger.new){
             if(rec.CFC_Attendee__c==null){
                 if(mapIdsForAttendees.get(rec.Event__c)==null)
                 {
                     rec.CFC_Attendee__c=Userinfo.getUserId(); }
                 else if(!mapIdsForAttendees.get(rec.Event__c).contains(Id.valueof(Userinfo.getUserId())))
                 {
                     rec.CFC_Attendee__c=Userinfo.getUserId(); }
                 else
                    { rec.Event__c.addError('You are already attending'); }
             }
         }
    }
    else {
          Set<ID> setUserId=new Set<ID>();
         for(CFC_Attendee__c rec :Trigger.New){
             setUserId.add(rec.CFC_Attendee__c);
         }
         Map<ID,User> mapUserIds=new Map<ID,User>([Select Name from User where Id in : setUserId]);
         Set<ID> setEventId=new Set<ID>();
         for(CFC_Attendee__c rec : Trigger.New){
             setEventId.add(rec.Event__c);
         }
         Set<ID> setAttendeeId=new Set<ID>();
         for(CFC_Attendee__c rec : Trigger.New){
             setAttendeeId.add(rec.Id);
         }
         Map<Id,CFC_Events__c> mapIdsForEvents=new Map<Id,CFC_Events__c>([Select Id,TF_CFC_Attendee__c from CFC_Events__c where Id in : setEventId]);
         
         Map<Id,List<CFC_Attendee__c>> mapIdsForAttendees=new Map<Id,List<CFC_Attendee__c>>();
         for(CFC_Attendee__c attendee:Trigger.New){
            if(!mapIdsForAttendees.containsKey(attendee.Event__c))
            {
               mapIdsForAttendees.put(attendee.Event__c,new List<CFC_Attendee__c>());            
            mapIdsForAttendees.get(attendee.Event__c).add(attendee);
            }
         }
         List<CFC_Events__c> lstEventUpddates=new List<CFC_Events__c>();
         //system.debug('~~~~'+mapIdsForEvents);
         //system.debug('~~~~'+mapIdsForAttendees);
         for(Id evt:mapIdsForAttendees.keyset()){
             string strAttendee;
             if(mapIdsForEvents.get(evt).TF_CFC_Attendee__c!=null)
             {strAttendee=mapIdsForEvents.get(evt).TF_CFC_Attendee__c+'\n'; }
             else 
             {strAttendee='';}
             for(CFC_Attendee__c attendee:mapIdsForAttendees.get(evt)){
                 if(attendee.CFC_Attendee__c!=null) {strAttendee=strAttendee+mapUserIds.get(attendee.CFC_Attendee__c).Name+'\n';}
             }
            // system.debug('~~~~'+strAttendee);
             strAttendee=strAttendee.removeEnd(',');
             CFC_Events__c event=new CFC_Events__c();
             event.Id=evt;
             event.TF_CFC_Attendee__c=strAttendee;
             lstEventUpddates.add(event);
             //system.debug('~~~~'+lstEventUpddates);
         }
         if(!lstEventUpddates.isEmpty()) { update lstEventUpddates;}
    }
    */
}