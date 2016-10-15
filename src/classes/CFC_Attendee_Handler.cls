/*
  Class Name: CFC_Attendee_Handler
  Author : Mindtree
  Date: 16 March 2016
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Validate if the attendee being added already exists in the Attendee object, if yes show a validation error, if no then complete the create transaction.
                           On successful completion of create transaction for attendee record, then update the attendee name in the TF_Attendee__c field on master object (Event).                       
*/
public with sharing class CFC_Attendee_Handler implements ITrigger{
    List<CFC_Events__c> lstEventUpddates=new List<CFC_Events__c>();
    List<CFC_Attendee__c> lstAttendies = new List<CFC_Attendee__c>();
    Map<Id,Set<Id>> mapIdsForAttendeesbefore=new Map<Id,Set<Id>>();
    Map<ID,User> mapUserIds ;
    Map<Id,CFC_Events__c> mapIdsForEvents;
    Map<Id,List<CFC_Attendee__c>> mapIdsForAttendees=new Map<Id,List<CFC_Attendee__c>>();
        
     
    public void bulkBefore(){
        Set<ID> setEventId=new Set<ID>();
        
        for(CFC_Attendee__c rec : (List<CFC_Attendee__c>)trigger.new){
             setEventId.add(rec.Event__c);
        }
        
        lstAttendies=[SELECT Attendee__c,Event__c,Name FROM CFC_Attendee__c where Event__c in:setEventId];
        for(CFC_Attendee__c attendee: (List<CFC_Attendee__c>)lstAttendies){
            if(!mapIdsForAttendeesbefore.containsKey(attendee.Event__c))
               mapIdsForAttendeesbefore.put(attendee.Event__c,new Set<Id>());            
            mapIdsForAttendeesbefore.get(attendee.Event__c).add(attendee.Attendee__c);
        }     
    }
    
    public void beforeInsert(SObject so){
       CFC_Attendee__c  rec = (CFC_Attendee__c)so;
            if(rec.Attendee__c==null){
                if(mapIdsForAttendeesbefore.get(rec.Event__c)==null){
                     rec.Attendee__c=Userinfo.getUserId(); }
                else if(!mapIdsForAttendeesbefore.get(rec.Event__c).contains(Id.valueof(Userinfo.getUserId()))){
                     rec.Attendee__c=Userinfo.getUserId(); }
                else{ 
                rec.Event__c.addError(CFC_Event__c.getInstance('YourAlreadyAttendeeError').Text_Value__c); }
            }
    }
    
    public void bulkAfter(){
        // Attendee user Id 
        Set<ID> setUserId=new Set<ID>();
        for(CFC_Attendee__c rec : (List<CFC_Attendee__c>)Trigger.New){
             setUserId.add(rec.Attendee__c);
        }
        mapUserIds=new Map<ID,User>([Select Name from User where Id in : setUserId]);
        
        // event Id
        Set<ID> setEventId=new Set<ID>();
        for(CFC_Attendee__c rec : (List<CFC_Attendee__c>)Trigger.New){
            setEventId.add(rec.Event__c);
        }
        
        // Attendee Id
        Set<ID> setAttendeeId=new Set<ID>();
        for(CFC_Attendee__c rec : (List<CFC_Attendee__c>)Trigger.New){
            setAttendeeId.add(rec.Id);
        }
        
        
        //Event Map
        mapIdsForEvents=new Map<Id,CFC_Events__c>([Select Id,TF_Attendee__c from CFC_Events__c where Id in : setEventId]);
        
        // event and Attendee Map       
        
        for(CFC_Attendee__c attendee: (List<CFC_Attendee__c>)Trigger.New){
            if(!mapIdsForAttendees.containsKey(attendee.Event__c))
            {
               mapIdsForAttendees.put(attendee.Event__c,new List<CFC_Attendee__c>());            
               mapIdsForAttendees.get(attendee.Event__c).add(attendee);
            }
         }
    
    }
     
    
    public void afterInsert(SObject so){
        CFC_Attendee__c  rec = (CFC_Attendee__c)so;
        
        
        //for(Id evt: mapIdsForAttendees.get(rec.Event__c)){
             string strAttendee;
             if(mapIdsForEvents.get(rec.Event__c).TF_Attendee__c!=null){
                strAttendee= mapIdsForEvents.get(rec.Event__c).TF_Attendee__c+'\n'; 
             }
             else {
                strAttendee='';
             }
             
            if(rec.Attendee__c!=null) {
               strAttendee=strAttendee+mapUserIds.get(rec.Attendee__c).Name;
            } 

            strAttendee=strAttendee.removeEnd(',');
             
             CFC_Events__c event=new CFC_Events__c();
             event.Id= rec.Event__c;
             event.TF_Attendee__c=strAttendee;
             lstEventUpddates.add(event);            
        // }   
    } 
    
    public void beforeUpdate(SObject oldSo,SObject so){System.debug('Inside beforeUpdate');}
    public void beforeDelete(SObject so){System.debug('Inside beforeDelete');}
    public void afterUpdate(SObject oldSo,SObject so){System.debug('Inside afterUpdate');}
    public void afterDelete(SObject so){System.debug('Inside afterDelete');}
    public void andFinally(){
        if(!lstEventUpddates.isEmpty()) { update lstEventUpddates;}
    }
}