/**********************************************************************
Name: VEP_Visitor_TriggerHandler
Purpose:
This TriggerHandler is used to popuklate the travel, lodging, pickup desk emails
on VEP records dynamically from custom settings
VERSION   AUTHOR   DATE    
1.0       Leena    Mar-2016   
***********************************************************************/

public class VEP_Visitor_TriggerHandler{
    //Populate Factory Manager details
    public static void vep_UpdateFactory(List<Vep_Visitor__c> listVisitors){
        set<string> setFactories = new set<string>();
        List<VEP_Factory__c> listFactory = new List<VEP_Factory__c>();
        Map<string,VEP_Factory__c> mapFactoryuser = new Map<string,VEP_Factory__c>();
        for(Vep_Visitor__c  v: listVisitors){
            setFactories.add(v.Factory_to_Visit__c);
        }
        if(!setFactories.isEmpty()){
            listFactory= [select id,name,Factory_manager__c,Factory_Manager__r.name from VEP_Factory__c where name in:setFactories];
        }
        if(!listFactory.isEmpty()){
            for(VEP_Factory__c fact: listFactory){
                mapFactoryuser.put(fact.name,fact);
            }
        }
        if(!mapFactoryuser.isEmpty()){
            for(Vep_Visitor__c  v: listVisitors){
                
                if(mapFactoryuser.get(v.Factory_to_Visit__c)!=null){
                    v.factory_manager__c = mapFactoryuser.get(v.Factory_to_Visit__c).Factory_manager__c;
                    v.factory_manager_name__c = mapFactoryuser.get(v.Factory_to_Visit__c).Factory_Manager__r.name;
                }
                
               
            }
        }
    }
     //populate travel, lodging, pickup desk emials from custom settings
    public static void vep_populateDeskEmails(List<Vep_Visitor__c> listnew, Map<id, Vep_Visitor__c> oldMap,boolean isinsert, boolean isupdate){
        Map<string,VEP_FactoryVisit__c> mapEmailIds = new Map<string,VEP_FactoryVisit__c>();
        Id robRecordTypeId = Schema.SObjectType.VEP_Visitor__c.getRecordTypeInfosByName().get('Request on Behalf').getRecordTypeId(); 
        mapEmailIds = VEP_FactoryVisit__c.getAll();         
        for(Vep_Visitor__c  v: listnew){
            if((isupdate && oldMap.get(v.id).status__c!='Approved' && v.status__c=='Approved') || (isInsert && v.recordtypeId==robRecordTypeId)){
                             
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
    //visitor pass is generated automatically for request on behalf
    public static void vep_generatePassOnBehalf(List<Vep_Visitor__c> listnew){
        Id robRecordTypeId1 = Schema.SObjectType.VEP_Visitor__c.getRecordTypeInfosByName().get('Request on Behalf').getRecordTypeId(); 
        List<VEP_Visitor_Pass__c> listVpass = new List<VEP_Visitor_Pass__c>();
        try{
        for(Vep_Visitor__c  v: listnew){
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
            for(Vep_Visitor__c  v: listnew){
                v.addError(e.getmessage());
            }
        }
    }
    
}