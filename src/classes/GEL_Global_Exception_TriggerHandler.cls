/**********************************************************************
Name: GEL_Global_Exception_TriggerHandler
Purpose:
This TriggerHandler is used to populate the ETC BO Owner and the owner of the record 
according to the process on GEL records dynamically from custom settings
VERSION   AUTHOR   DATE    
1.0       Chandana June-2016   
***********************************************************************/
public with sharing class GEL_Global_Exception_TriggerHandler implements ITrigger{
    
    // Constructor
    public GEL_Global_Exception_TriggerHandler() {       
        ExceptionLoggingHelper.initializeExceptionLog(); 
    }
    /***********************************************************************************************************************************
    * bulkBefore
    *
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore(){
        Map<string,Global_Exception_Users__c> mapUsers = new Map<string,Global_Exception_Users__c>();
        set<string> setUserEmails = new set<string>();
        List<user> listUsers = new list<User>();
        Map<string,id> mapuserid = new map<String,id>();
        List<Global_Exception_Users__c> listuseremails = Global_Exception_Users__c.getall().values();
        mapUsers = Global_Exception_Users__c.getall();
        if(trigger.isInsert){
            for(Global_Exception_Users__c geu : listuseremails){            
                    setUserEmails.add(geu.Email__c);                
            }        
            listUsers = [select id,Username from user where Username in:setUserEmails];
            if(!listUsers.isEmpty()){
                for(user u: listUsers){
                    mapuserid.put(u.Username,u.id);
                }
            }
            for(GEL_Global_Exception_Log__c GE : (List<GEL_Global_Exception_Log__c>) Trigger.New){
                if(mapUsers.containsKey(GE.Process__c) && mapUsers.get(GE.Process__c).Email__c!=null && mapuserid.get(mapUsers.get(GE.Process__c).Email__c)!=null){
                    ge.ETC_BO_Owner__c = mapuserid.get(mapUsers.get(GE.Process__c).Email__c);
                    ge.ownerid = mapuserid.get(mapUsers.get(GE.Process__c).Email__c);
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
        //This method has been included as the class implements the ITrigger interface
        
    }
    public void beforeInsert(SObject so){
        //This method has been included as the class implements the ITrigger interface
        
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){   
        //This method has been included as the class implements the ITrigger interface
        set<string> setUserEmails = new set<string>();
<<<<<<< HEAD
        List<user> listUsers = new list<User>();
        Map<string,id> mapuserid = new map<String,id>();
=======
>>>>>>> develop
        List<Global_Exception_Users__c> listuseremails = Global_Exception_Users__c.getall().values(); 
       if(trigger.isUpdate){
            for(Global_Exception_Users__c geu : listuseremails){            
                    setUserEmails.add(geu.Email__c);                
            }        
<<<<<<< HEAD
            listUsers = [select id,Username from user where Username in:setUserEmails];
            if(!listUsers.isEmpty()){
                for(user u: listUsers){
                    mapuserid.put(u.Username,u.id);
                }
            }
=======

>>>>>>> develop
            for(GEL_Global_Exception_Log__c GE : (List<GEL_Global_Exception_Log__c>) Trigger.new){
                Map<id, GEL_Global_Exception_Log__c> oldMap1 = (Map<Id,GEL_Global_Exception_Log__c >) Trigger.oldMap;
                if(GE.ETC_BO_Owner__c != null && GE.ETC_BO_Owner__c != oldMap1.get(GE.id).ETC_BO_Owner__c ){
                    ge.ownerid = GE.ETC_BO_Owner__c;
                }
            }
        }
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