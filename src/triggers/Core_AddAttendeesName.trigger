trigger Core_AddAttendeesName on Attendee__c (before insert,after insert) {
    if(trigger.isBefore){
         Set<ID> setEventId=new Set<ID>();
         Map<Id,Set<Id>> mapIdsForAttendees=new Map<Id,Set<Id>>();
         for(Attendee__c rec : trigger.new){
             setEventId.add(rec.Event__c);
         }
         List<Attendee__c> lstAttendies=[SELECT Attendee__c,Event__c,Name FROM Attendee__c where Event__c in:setEventId];
         for(Attendee__c attendee:lstAttendies){
            if(!mapIdsForAttendees.containsKey(attendee.Event__c))
               mapIdsForAttendees.put(attendee.Event__c,new Set<Id>());            
            mapIdsForAttendees.get(attendee.Event__c).add(attendee.Attendee__c);
         }
         for(Attendee__c rec : trigger.new){
             if(rec.Attendee__c==null){
                 if(mapIdsForAttendees.get(rec.Event__c)==null)
                     rec.Attendee__c=Userinfo.getUserId();
                 else if(!mapIdsForAttendees.get(rec.Event__c).contains(Id.valueof(Userinfo.getUserId())))
                     rec.Attendee__c=Userinfo.getUserId();
                 else
                     rec.Event__c.addError('You are already attending');
             }
         }
    }
    else {
          Set<ID> setUserId=new Set<ID>();
         for(Attendee__c rec :Trigger.New){
             setUserId.add(rec.Attendee__c);
         }
         Map<ID,User> mapUserIds=new Map<ID,User>([Select Name from User where Id in : setUserId]);
         Set<ID> setEventId=new Set<ID>();
         for(Attendee__c rec : Trigger.New){
             setEventId.add(rec.Event__c);
         }
         Set<ID> setAttendeeId=new Set<ID>();
         for(Attendee__c rec : Trigger.New){
             setAttendeeId.add(rec.Id);
         }
         Map<Id,Core_Events__c> mapIdsForEvents=new Map<Id,Core_Events__c>([Select Id,TF_Attendee__c from Core_Events__c where Id in : setEventId]);
         
         Map<Id,List<Attendee__c>> mapIdsForAttendees=new Map<Id,List<Attendee__c>>();
         for(Attendee__c attendee:Trigger.New){
            if(!mapIdsForAttendees.containsKey(attendee.Event__c))
               mapIdsForAttendees.put(attendee.Event__c,new List<Attendee__c>());            
            mapIdsForAttendees.get(attendee.Event__c).add(attendee);
         }
         List<Core_Events__c> lstEventUpddates=new List<Core_Events__c>();
         system.debug('~~~~'+mapIdsForEvents);
         system.debug('~~~~'+mapIdsForAttendees);
         for(Id evt:mapIdsForAttendees.keyset()){
             string strAttendee;
             if(mapIdsForEvents.get(evt).TF_Attendee__c!=null) strAttendee=mapIdsForEvents.get(evt).TF_Attendee__c+'\n'; 
             else strAttendee='';
             for(Attendee__c attendee:mapIdsForAttendees.get(evt)){
                 if(attendee.Attendee__c!=null) strAttendee=strAttendee+mapUserIds.get(attendee.Attendee__c).Name+'\n';
             }
             system.debug('~~~~'+strAttendee);
             strAttendee=strAttendee.removeEnd(',');
             Core_Events__c event=new Core_Events__c();
             event.Id=evt;
             event.TF_Attendee__c=strAttendee;
             lstEventUpddates.add(event);
             system.debug('~~~~'+lstEventUpddates);
         }
         if(!lstEventUpddates.isEmpty()) update lstEventUpddates;
    }
}