/*
  Class Name: CFC_EventsController
  Author : Mindtree
  Date: 11 March 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: control all the events based on conference app. 
*/
public with sharing class CFC_EventsController{  
    @auraenabled
    public static CFC_EventsWrapper getEventsList(String filterTopic,String sortTopic) {
     Map<String,String> filterMap = new Map<String,String>();
        
        filterMap.put(CFC_Event__c.getInstance('showAll').Name,CFC_Event__c.getInstance('showAll').Text_Value__c);
        filterMap.put(CFC_Event__c.getInstance('showIT').Name,CFC_Event__c.getInstance('showIT').Text_Value__c);
        filterMap.put(CFC_Event__c.getInstance('showConsumer').Name,CFC_Event__c.getInstance('showConsumer').Text_Value__c);
        filterMap.put(CFC_Event__c.getInstance('showDigital').Name,CFC_Event__c.getInstance('showDigital').Text_Value__c);
        filterMap.put(CFC_Event__c.getInstance('showMobile').Name,CFC_Event__c.getInstance('showMobile').Text_Value__c);
        filterMap.put(CFC_Event__c.getInstance('showRND').Name,CFC_Event__c.getInstance('showRND').Text_Value__c);
        filterMap.put(CFC_Event__c.getInstance('showInnovation').Name,CFC_Event__c.getInstance('showInnovation').Text_Value__c);
        
        Map<Id,CFC_Events__c> eventListData=new Map<Id,CFC_Events__c>();
        String filterTopicName=filterMap.get(filterTopic);
        if(filterTopicName=='All') {
            if(sortTopic=='ASC'){
                return getEventsListWrapper([SELECT Banner__c,Description__c,From__c,Id,Name,Topics__c,To__c,Vendor__c,Website__c FROM CFC_Events__c WHERE Name!=Null ORDER BY From__c ASC]); }
                else {
                return getEventsListWrapper([SELECT Banner__c,Description__c,From__c,Id,Name,Topics__c,To__c,Vendor__c,Website__c FROM CFC_Events__c WHERE Name!=Null ORDER BY From__c DESC]); }
        } else {
            if(sortTopic=='ASC'){
                for(CFC_Events__c eventObj : [SELECT Banner__c,Description__c,From__c,Id,Name,Topics__c,To__c,Vendor__c,Website__c FROM CFC_Events__c WHERE Name!=Null ORDER BY From__c ASC]) {
                    if(eventObj.Topics__c!=null && eventObj.Topics__c!='') {
                        for(String strTopic : eventObj.Topics__c.split(';')){
                            if(strTopic == filterTopicName)
                            {
                                eventListData.put(eventObj.Id,eventObj); }
                        }
                    }
                }
            }
            else {
                for(CFC_Events__c eventObj : [SELECT Banner__c,Description__c,From__c,Id,Name,Topics__c,To__c,Vendor__c,Website__c FROM CFC_Events__c WHERE Name!=Null ORDER BY From__c DESC]) {
                    if(eventObj.Topics__c!=null && eventObj.Topics__c!='') {
                        for(String strTopic : eventObj.Topics__c.split(';')){
                            if(strTopic == filterTopicName)
                                eventListData.put(eventObj.Id,eventObj);
                        }
                    }
                }
            }
            return getEventsListWrapper(eventListData.values());
        }
    }

    public static CFC_EventsWrapper getEventsListWrapper(List<CFC_Events__c> EventsList) {
        CFC_EventsWrapper wrapper=new CFC_EventsWrapper();
        List<CFC_EventsWrapper.Core_Event> lstWrapper=new List<CFC_EventsWrapper.Core_Event>();
        //CFC_EventsWrapper.Events wrapperLisOfEvents=new CFC_EventsWrapper.Events();
        for(CFC_Events__c evt : EventsList){
            CFC_EventsWrapper.Core_Event wrp=new CFC_EventsWrapper.Core_Event();
            wrp.Banner=evt.Banner__c;
            wrp.Description=evt.Description__c;
            wrp.FromDate=evt.From__c;
            wrp.Id=evt.Id;
            wrp.Name=evt.Name;
            wrp.ToDate=evt.To__c;
            lstWrapper.add(wrp);
        }
        List<RecordType> lstRecType=[select Id from RecordType where Name = 'CFC_Create' and SobjectType = 'CFC_Events__c'];
        wrapper.DefaultRecordTypeId=lstRecType[0].Id;
        wrapper.Events=lstWrapper;
        return wrapper;
    }   
    
    @AuraEnabled
    public static string getCFCGAID(){      
        string strgaid = CFC_ReportingGA__c.getinstance('CFC_Id_Value').CFC_Id__c;
        return strgaid;      
    }    
    
     
}