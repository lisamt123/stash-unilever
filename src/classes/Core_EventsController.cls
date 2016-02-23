public with sharing class Core_EventsController{
    
    @auraenabled
    public static List<Core_Events__c> getEventsList(String filterTopic,String sortTopic) {
        Map<String,String> filterMAp = new Map<String,String>();
        filterMAp.put('showAll','All');
        filterMAp.put('showIT','IT');
        filterMAp.put('showConsumer','Consumer');
        filterMAp.put('showDigital','Digital');
        filterMAp.put('showMobile','Mobile');
        filterMAp.put('showRND','R & D');
        filterMAp.put('showInnovation','Innovation');
        Map<Id,Core_Events__c> eventListData=new Map<Id,Core_Events__c>();
        String filterTopicName=filterMAp.get(filterTopic);
        if(filterTopicName=='All') {
            if(sortTopic=='ASC')
                return [SELECT Banner__c,Description__c,From__c,Id,Name,Topics__c,To__c,Vendor__c,Website__c FROM Core_Events__c ORDER BY From__c ASC];
                else return [SELECT Banner__c,Description__c,From__c,Id,Name,Topics__c,To__c,Vendor__c,Website__c FROM Core_Events__c ORDER BY From__c DESC];
        } else {
            if(sortTopic=='ASC'){
                for(Core_Events__c eventObj : [SELECT Banner__c,Description__c,From__c,Id,Name,Topics__c,To__c,Vendor__c,Website__c FROM Core_Events__c ORDER BY From__c ASC]) {
                    for(String strTopic : eventObj.Topics__c.split(';')){
                        if(strTopic == filterTopicName)
                            eventListData.put(eventObj.Id,eventObj);
                    }
                }
            }
            else {
                for(Core_Events__c eventObj : [SELECT Banner__c,Description__c,From__c,Id,Name,Topics__c,To__c,Vendor__c,Website__c FROM Core_Events__c ORDER BY From__c DESC]) {
                    for(String strTopic : eventObj.Topics__c.split(';')){
                        if(strTopic == filterTopicName)
                            eventListData.put(eventObj.Id,eventObj);
                    }
                }
            }
            return eventListData.values();
        }
    }
    public Class eventDataList {
    
    }
    
}