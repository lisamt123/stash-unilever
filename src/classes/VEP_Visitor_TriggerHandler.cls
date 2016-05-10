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
            Id robRecordTypeId = Schema.SObjectType.VEP_Visitor__c.getRecordTypeInfosByName().get('Request on Behalf').getRecordTypeId(); 
            mapEmailIds = VEP_FactoryVisit__c.getAll();         
            Map<id, Vep_Visitor__c> oldMap = (Map<Id,Vep_Visitor__c >) Trigger.oldMap;
            for(Vep_Visitor__c  v: (List<Vep_Visitor__c >)Trigger.New){
                if((trigger.isUpdate && oldMap.get(v.id).status__c!='Approved' && v.status__c=='Approved') || (trigger.isInsert && v.recordtypeId==robRecordTypeId)){
                                 
                        if(v.travel__c && mapEmailIds.get(v.Factory_to_visit__c)!=null){
                            v.Travel_Desk_Email__c = mapEmailIds.get(v.Factory_to_visit__c).Travel_Desk_Email__c;
                        }
                    
                    
                        if(v.lodging__c && mapEmailIds.get(v.Factory_to_visit__c)!=null){
                            v.Lodging_Desk_Email__c = mapEmailIds.get(v.Factory_to_visit__c).Lodging_Desk_Email__c ;
                        }
                    
                    
                        if(v.pickup__c && mapEmailIds.get(v.Factory_to_visit__c)!=null){
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
        Id robRecordTypeId2 = Schema.SObjectType.VEP_Visitor__c.getRecordTypeInfosByName().get('Request on Behalf').getRecordTypeId(); 
        set<string> setemails = new set<string>();
        List<Vep_Visitor__c> listvisitors = new List<Vep_Visitor__c>();
        
        for(Vep_Visitor__c  v: (List<Vep_Visitor__c >)Trigger.New){
            if(robRecordTypeId2 == v.recordtypeid && v.status__c == 'Approved'){
                if(v.travel_desk_email__c!=null && v.travel__c){
                    setemails.add(v.travel_desk_email__c);
                }
                if(v.lodging_desk_email__c!=null && v.lodging__c){
                    setemails.add(v.lodging_desk_email__c);
                } 
                listvisitors.add(v);    
            }
        }
        if(!setemails.isEmpty()){
            recordVisibility(setemails,listvisitors);
        }
    }
    
    public void afterUpdate(SObject oldSo, SObject so){    
        //This method has been included as the class implements the ITrigger interface
        Map<id, Vep_Visitor__c> oldMap2 = (Map<Id,Vep_Visitor__c >) Trigger.oldMap;
        set<string> setemails = new set<string>();
        Id RequestRecordTypeId2 = Schema.SObjectType.VEP_Visitor__c.getRecordTypeInfosByName().get('Request Readonly').getRecordTypeId(); 
        List<Vep_Visitor__c> listvisitors1 = new List<Vep_Visitor__c>();
        for(Vep_Visitor__c  v: (List<Vep_Visitor__c >)Trigger.New){
            if(v.status__c == 'Approved' && oldMap2.get(v.id).status__c != v.status__c && RequestRecordTypeId2 == v.recordtypeid){
                if(v.travel_desk_email__c!=null && v.travel__c){
                    setemails.add(v.travel_desk_email__c);
                }
                if(v.lodging_desk_email__c!=null && v.lodging__c){
                    setemails.add(v.lodging_desk_email__c);
                } 
                listvisitors1.add(v); 
            }
        }
        if(!setemails.isEmpty()){
            recordVisibility(setemails,listvisitors1);
        }       
     
    }
    
    public void afterDelete(SObject so){
        //This method has been included as the class implements the ITrigger interface
    } 
    public void andFinally(){
        //Added by Devendra - call method to insert all exception logs got while excecution of trigger
        ExceptionLoggingHelper.insertLogRecordList();
    }   
    public void recordVisibility(set<string> setemails,List<Vep_Visitor__c> listvisitors){
        
        List<User> listusers = new List<User>();
          listusers = [select id,name,email from user where email in: setemails];
        
        Map<string,user> mapuser = new Map<string, user>();
        if(!listusers.isEmpty()){
            for(user u :listusers){
                mapuser.put(u.email,u);
            }
           // recordVisibilityExt(mapuser,listVisitors);   
         List<Vep_Visitor__Share> listvshare1 = new List<Vep_Visitor__Share>();
        for(Vep_Visitor__c  v: listVisitors){
                if(v.travel_desk_email__c!=null && v.travel__c && v.person_to_meet__c != mapUser.get(v.travel_desk_email__c).id){
                    Vep_Visitor__Share vshare1 = new Vep_Visitor__Share();
                    vshare1.UserOrGroupId = mapUser.get(v.travel_desk_email__c).id;
                    vshare1.AccessLevel = 'Edit';
                    vshare1.ParentId = v.id;
                    vshare1.RowCause =Schema.Vep_Visitor__Share.RowCause.Manual;
                    listvshare1.add(vshare1);                    
                }
                if(v.lodging_desk_email__c!=null && v.lodging__c && v.person_to_meet__c != mapUser.get(v.lodging_desk_email__c).id){
                    Vep_Visitor__Share vshare2 = new Vep_Visitor__Share();
                    vshare2.UserOrGroupId = mapUser.get(v.lodging_desk_email__c).id;
                    vshare2.AccessLevel = 'Edit';
                    vshare2.ParentId = v.id;
                    vshare2.RowCause =Schema.Vep_Visitor__Share.RowCause.Manual;
                    listvshare1.add(vshare2);
                }
            }
            if(!listvshare1.isEmpty()){
                insert listvshare1;
            }                          
        }
        
    }
    
}