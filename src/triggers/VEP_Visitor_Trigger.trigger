trigger VEP_Visitor_Trigger on Vep_Visitor__c (before insert,before update,after insert, after update) {
    set<string> setFactories = new set<string>();
    List<VEP_Factory__c> listFactory = new List<VEP_Factory__c>();
    Map<string,VEP_Factory__c> mapFactoryuser = new Map<string,VEP_Factory__c>();
    if(trigger.isBefore && trigger.IsInsert){
        for(Vep_Visitor__c  v: trigger.new){
            setFactories.add(v.Factory_to_Visit__c);
        }
        if(setFactories!=null && setFactories.size()>0){
            listFactory= [select id,name,Factory_manager__c,Factory_Manager__r.name from VEP_Factory__c where name in:setFactories];
        }
        if(listFactory!=null && listFactory.size()>0){
            for(VEP_Factory__c fact: listFactory){
                mapFactoryuser.put(fact.name,fact);
            }
        }
        if(mapFactoryuser!=null && mapFactoryuser.size()>0){
            for(Vep_Visitor__c  v: trigger.new){
                if(trigger.IsInsert){
                if(mapFactoryuser.get(v.Factory_to_Visit__c)!=null){
                    v.factory_manager__c = mapFactoryuser.get(v.Factory_to_Visit__c).Factory_manager__c;
                    v.factory_manager_name__c = mapFactoryuser.get(v.Factory_to_Visit__c).Factory_Manager__r.name;
                }
                }
               
            }
        }
        
    }
    
   Map<string,VEP_FactoryVisit__c> mapEmailIds = new Map<string,VEP_FactoryVisit__c>();
   Id robRecordTypeId = Schema.SObjectType.VEP_Visitor__c.getRecordTypeInfosByName().get('Request on Behalf').getRecordTypeId(); 
    if(trigger.isBefore ){
        mapEmailIds = VEP_FactoryVisit__c.getAll();
         
        for(Vep_Visitor__c  v: trigger.new){
            if((trigger.isupdate && trigger.oldMap.get(v.id).status__c!='Approved' && v.status__c=='Approved') || (trigger.isInsert && v.recordtypeId==robRecordTypeId)){
              
                if(v.travel__c==true){
                    if(mapEmailIds.get(v.Factory_to_visit__c)!=null)
                        v.Travel_Desk_Email__c = mapEmailIds.get(v.Factory_to_visit__c).Travel_Desk_Email__c;
                }
                if(v.lodging__c==true){
                    if(mapEmailIds.get(v.Factory_to_visit__c)!=null)
                        v.Lodging_Desk_Email__c = mapEmailIds.get(v.Factory_to_visit__c).Lodging_Desk_Email__c ;
                }
                if(v.pickup__c==true){
                    if(mapEmailIds.get(v.Factory_to_visit__c)!=null)
                        v.pickup_Desk_Email__c = mapEmailIds.get(v.Factory_to_visit__c).pickup_Desk_Email__c ;
                }
            }
            
        }
    }
    if(trigger.isAfter && trigger.isInsert){
        try{
        for(Vep_Visitor__c  v: trigger.new){
            if(v.recordtypeId==robRecordTypeId){
                VEP_Visitor_Pass__c vPass = new VEP_Visitor_Pass__c();
                vPass.Visitor__c = v.id;
                insert vPass;
            }
        }
        }
        catch(Exception e){
        }
    }
}