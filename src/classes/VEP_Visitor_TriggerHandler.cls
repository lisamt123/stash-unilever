/**********************************************************************
Name: VEP_Visitor_TriggerHandler
Purpose:
This TriggerHandler is used to popuklate the travel, lodging, pickup desk emails
on VEP records dynamically from custom settings
VERSION   AUTHOR   DATE    
1.0       Leena    Mar-2016   
***********************************************************************/

public with sharing class VEP_Visitor_TriggerHandler implements ITrigger{
    
    // Constructor
    public VEP_Visitor_TriggerHandler() {       
        ExceptionLoggingHelper.initializeExceptionLog(); 
    }
    /***********************************************************************************************************************************
    * bulkBefore
    *
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore(){
        
        if(trigger.isInsert || trigger.isUpdate){
            Map<string,VEP_FactoryVisit__c> mapEmailIds = new Map<string,VEP_FactoryVisit__c>();
            Map<string,VEP_TravelDesk__c> mapTravelEmailIds = new Map<string,VEP_TravelDesk__c>();
            Id robRecordTypeId = Schema.SObjectType.VEP_Visitor__c.getRecordTypeInfosByName().get('Request on Behalf').getRecordTypeId(); 
            mapEmailIds = VEP_FactoryVisit__c.getAll();
            mapTravelEmailIds = VEP_TravelDesk__c.getAll();         
            Map<id, Vep_Visitor__c> oldMap = (Map<Id,Vep_Visitor__c >) Trigger.oldMap;
            for(Vep_Visitor__c  v: (List<Vep_Visitor__c >)Trigger.New){
                if((trigger.isUpdate && oldMap.get(v.id).status__c!='Approved' && v.status__c=='Approved') || (trigger.isInsert && v.recordtypeId==robRecordTypeId)){
                                 
                        if(v.travel__c && mapTravelEmailIds.containsKey(v.base_location__c) && mapTravelEmailIds.get(v.base_location__c)!=null){
                            v.Travel_Desk_Email__c = mapTravelEmailIds.get(v.base_location__c).Travel_Desk_Email__c;
                        }
                    
                    
                        if(v.lodging__c && mapEmailIds.containsKey(v.Factory_to_visit__c) && mapEmailIds.get(v.Factory_to_visit__c)!=null){
                            v.Lodging_Desk_Email__c = mapEmailIds.get(v.Factory_to_visit__c).Lodging_Desk_Email__c ;
                        }
                    
                    
                        if(v.pickup__c && mapEmailIds.containsKey(v.Factory_to_visit__c) && mapEmailIds.get(v.Factory_to_visit__c)!=null){
                            v.pickup_Desk_Email__c = mapEmailIds.get(v.Factory_to_visit__c).pickup_Desk_Email__c ;
                        }
                    
                }
                
            }
        }
    }
     /***********************************************************************************************************************************
    * bulkAfter
    *
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter(){
        if(trigger.isInsert){
            Id robRecordTypeId1 = Schema.SObjectType.VEP_Visitor__c.getRecordTypeInfosByName().get('Request on Behalf').getRecordTypeId(); 
            List<VEP_Visitor_Pass__c> listVpass = new List<VEP_Visitor_Pass__c>();
            try{
            for(Vep_Visitor__c  v: (List<Vep_Visitor__c >)Trigger.New){
                if(v.recordtypeId==robRecordTypeId1){
                    VEP_Visitor_Pass__c vPass = new VEP_Visitor_Pass__c();
                    vPass.Visitor__c = v.id;
                    listVpass.add(vPass);
                    
                }
            }
            if(!listVpass.isEmpty()){
                insert listVpass;
            }
            }
            catch(Exception e){
                for(Vep_Visitor__c  v: (List<Vep_Visitor__c >)Trigger.New){
                    v.addError(e.getmessage());
                }
            }
        }
        
        if(trigger.isInsert || trigger.isupdate){
        Id robRecordTypeId2 = Schema.SObjectType.VEP_Visitor__c.getRecordTypeInfosByName().get('Request').getRecordTypeId(); 
            List<Vep_Visitor__Share> listvshare = new List<Vep_Visitor__Share>();
            for(Vep_Visitor__c  v: (List<Vep_Visitor__c >)Trigger.New){
                Map<id, Vep_Visitor__c> oldMap1 = (Map<Id,Vep_Visitor__c >) Trigger.oldMap;
                if((trigger.isInsert && v.person_to_meet__c!=null && v.recordtypeid==robRecordTypeId2) || (trigger.isUpdate && v.person_to_meet__c!=null && v.person_to_meet__c != oldMap1.get(v.id).Person_to_meet__c && v.recordtypeid==robRecordTypeId2)){
                    
                    Vep_Visitor__Share vshare = new Vep_Visitor__Share();
                    vshare.UserOrGroupId = v.Person_to_meet__c;
                    vshare.AccessLevel = 'Edit';
                    vshare.ParentId = v.id;
                    vshare.RowCause =Schema.Vep_Visitor__Share.RowCause.Manual;
                    listvshare.add(vshare);
                }
            }
            try{
            if(!listvshare.isEmpty()){
                insert listvshare;
            }
            }
            catch(Exception e){
                for(Vep_Visitor__c  v: (List<Vep_Visitor__c >)Trigger.New){
                    v.addError(label.VEP_ApproverAccess_Err);
                }
            }
        }
        
    }
    public void beforeInsert(SObject so){
        //This method has been included as the class implements the ITrigger interface
        
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){   
        //This method has been included as the class implements the ITrigger interface
    }
    public void beforeDelete(SObject so){      
        //This method has been included as the class implements the ITrigger interface
    }
    
    public void afterInsert(SObject so){
        //This method has been included as the class implements the ITrigger interface
        
    }
    
    public void afterUpdate(SObject oldSo, SObject so){    
        //This method has been included as the class implements the ITrigger interface
          
     
    }
    
    public void afterDelete(SObject so){
        //This method has been included as the class implements the ITrigger interface
    } 
    public void andFinally(){
        //Added by Devendra - call method to insert all exception logs got while excecution of trigger
        ExceptionLoggingHelper.insertLogRecordList();
    }   
    
    
}