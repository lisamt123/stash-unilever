public with sharing class CORE_LA_EventController{
    @AuraEnabled
    public static String createCustomEvent(String eventName) {
        try {
            CORE_LA_Event__c newEventObj = new CORE_LA_Event__c();
            newEventObj.Name = eventName;
            newEventObj.Status__c = 'Saved';
            insert newEventObj;
            
            CORE_LA_Participant__c  adminDetail= new CORE_LA_Participant__c ();
            //adminDetail.Event__c='aDjV00000004CuvKAE';
            adminDetail.Event__c=newEventObj.Id;
            adminDetail.Role__c= 'Admin';
            adminDetail.Participant_Name__c = UserInfo.getUserId();
                          
            insert adminDetail;
            
            return newEventObj.Id;
            //return 'aDjV00000004D2aKAE';
            
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            return null;
        } 
    } 
    
    @AuraEnabled
    public static List<CORE_LA_Event__c> getEventById(String eId) {
        List <CORE_LA_Event__c> newEventList = [SELECT Agenda__c,Banner__c,CreatedById,CreatedDate,Details__c,Faclities__c,From_Date__c,Id,Location__c,Name,No_of_Attendees__c,OwnerId,Prerequisite__c,Recurring_Details__c,Recurring_Time__c,Recurring__c,Short_Description__c,Status__c,To_Date__c,Banner_Content_Version__c FROM CORE_LA_Event__c WHERE Id =: eId];
        system.debug('event list'+ newEventList);
        if(newEventList.size() > 0){
            return newEventList;
        }
        return null;
    }
    
    @AuraEnabled
    public static boolean saveEventDetailPage(String eId, String eventName, String eventShortDescription, String bannerImageVersionId) {
        try {
            CORE_LA_Event__c newEventList = [SELECT CreatedById,CreatedDate,Details__c,Faclities__c,From_Date__c,Id,Location__c,Name,No_of_Attendees__c,OwnerId,Prerequisite__c,Recurring_Details__c,Recurring_Time__c,Recurring__c,Status__c,To_Date__c FROM CORE_LA_Event__c WHERE Id =: eId];
            //if(newEventList.size() > 0){
                newEventList.Name = eventName;
                newEventList.Details__c = eventShortDescription;
                if(bannerImageVersionId != 'null'){
                    newEventList.Banner_Content_Version__c = bannerImageVersionId;
                }
                upsert newEventList;
            //}
            
            
            //return newEventObj.Id;
            return true;
            
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            return false;
        } 
    }
    
    @AuraEnabled
    public static boolean saveVenueDetailPage(String eId, String locationDetails, List<String> facility, String floorPlanImageVersionId) {
        try {
            CORE_LA_Event__c newEventList = [SELECT CreatedById,CreatedDate,Details__c,Faclities__c,From_Date__c,Id,Location__c,Name,No_of_Attendees__c,OwnerId,Prerequisite__c,Recurring_Details__c,Recurring_Time__c,Recurring__c,Status__c,To_Date__c,Floor_Plan__c FROM CORE_LA_Event__c WHERE Id =: eId];
            //if(newEventList.size() > 0){
                String facilitiesString='';
                if(!facility.isEmpty()) {  
                    for(String facilityItem : facility){
                        if(facilitiesString == ''){
                            facilitiesString = facilityItem;
                        }else{
                            facilitiesString = facilitiesString + ';' + facilityItem;
                        }
                    }
                }
                newEventList.Location__c= locationDetails;
                if(facilitiesString != '' || facilitiesString != 'null'){
                    newEventList.Faclities__c = facilitiesString;
                }
                if(floorPlanImageVersionId != 'null'){
                    newEventList.Floor_Plan__c = floorPlanImageVersionId;
                }
                upsert newEventList;
            //}
            
            
            //return newEventObj.Id;
            return true;
            
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            return false;
        } 
    }
    
    @AuraEnabled
    public static boolean saveEventReadingDetails(String eId, String readingDescription, List<String> listUploadedContentVersion) {
        //try {
            CORE_LA_Event__c newEventList = [SELECT CreatedById,CreatedDate,Details__c,Faclities__c,From_Date__c,Id,Location__c,Name,No_of_Attendees__c,OwnerId,Prerequisite__c,Recurring_Details__c,Recurring_Time__c,Recurring__c,Status__c,To_Date__c FROM CORE_LA_Event__c WHERE Id =: eId];
            newEventList.Prerequisite__c= readingDescription;
            upsert newEventList;
        /*} catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            return false;
        }*/

        if(listUploadedContentVersion.size() > 0){
            List<FeedItem> listFeedItem = new List<FeedItem>();
            for(String fItem : listUploadedContentVersion){
                FeedItem singleFeedItem = new FeedItem();
                singleFeedItem.body = 'Event-Reading Material';
                singleFeedItem.Type = 'TextPost' ;
                if(fItem !=null && fItem != ''){
                    singleFeedItem.RelatedRecordId = fItem;
                    singleFeedItem.Type = 'ContentPost' ;
                }
                singleFeedItem.Title = 'Event Reading Material';           
                singleFeedItem.ParentId = newEventList.Id;
                listFeedItem.add(singleFeedItem);
            }   
            insert listFeedItem;
        }
        
        //return newEventObj.Id;
        return true; 
    }
    
    @AuraEnabled
    public static List<sObject> getFeedItemByEventId(String eId) {
        List<String> idListToFind = new List<String>();
        system.debug('--->'+ eId);
        List<FeedItem> listObjFeedItem = [SELECT Id, ParentId, RelatedRecordId FROM FeedItem Where ParentId=:eId];
        
        system.debug('List feed Item--->'+ listObjFeedItem);
        for(FeedItem objFeedItem: listObjFeedItem){
            idListToFind.add(objFeedItem.RelatedRecordId);
        }
        
        system.debug('Id List--->'+ idListToFind);
        List<ContentVersion> lstContentVersion = [SELECT Id, Title FROM ContentVersion WHERE Id=:idListToFind];
        system.debug(' Content version Id List--->'+ lstContentVersion );
        if(lstContentVersion.size() > 0){
           return lstContentVersion;
        }
        
        return null;
    }
    
    @AuraEnabled
    public static List<sObject> getDeleteFeedItemByVersionId(String eId) {
    
        ContentVersion c = [Select Id, ContentDocumentId from ContentVersion where id =: eId LIMIT 1]; 
        ContentDocument cd = new ContentDocument();
        cd.Id = c.ContentDocumentId;
        delete cd;
                
        List<String> idListToFind = new List<String>();
        List<FeedItem> listObjFeedItem = [SELECT Id, ParentId, RelatedRecordId FROM FeedItem Where ParentId=:eId];
        
        for(FeedItem objFeedItem: listObjFeedItem){
            idListToFind.add(objFeedItem.RelatedRecordId);
        }

        List<ContentVersion> lstContentVersion = [SELECT Id, Title FROM ContentVersion WHERE Id=:idListToFind];

        if(lstContentVersion.size() > 0){
           return lstContentVersion;
        }
        
        return null;
    }
    @AuraEnabled
    public static boolean getDeleteAgendaByVersionId(String vId, String eId){
        
        try{
            ContentVersion c = [Select Id, ContentDocumentId from ContentVersion where id =: vId LIMIT 1]; 
            ContentDocument cd = new ContentDocument();
            cd.Id = c.ContentDocumentId;
            delete cd;
            
            CORE_LA_Event__c eventObj= new CORE_LA_Event__c();
            eventObj=[SELECT Id,Name,From_Date__c,To_Date__c,Agenda__c FROM CORE_LA_Event__c WHERE Id =: eId];
            eventObj.Agenda__c='';
            upsert eventObj;
        
            return true;
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            return false;
        } 
        
    }
     @AuraEnabled
    public static List<ContentVersion> saveAgendaDetails(List<CORE_LA_Agenda__c> agendaList, String eventId, String agendaDocumentId){
        system.debug('Agenda List>>>>>>>>>> '+agendaList);
        system.debug('Agenda List size>>>>>>>>>> '+agendaList.size());
        CORE_LA_EventWrapperClass.Event eventDetails = new CORE_LA_EventWrapperClass.Event();
        List<CORE_LA_Agenda__c> saveAgendaList = new List<CORE_LA_Agenda__c> ();
        
        CORE_LA_Event__c eventObj= new CORE_LA_Event__c();
        List<ContentVersion> documentDetails = new List<ContentVersion>();        
        if(agendaDocumentId != '' && agendaDocumentId != 'null'){
            eventObj=[SELECT Id, Name, Agenda__c FROM CORE_LA_Event__c WHERE ID = :eventId];
            eventObj.Agenda__c = agendaDocumentId;
            upsert eventObj;
            

            documentDetails = [Select Id,FileType,Title,FileExtension From ContentVersion Where Id =: agendaDocumentId];
            
        }
        
        
        if(agendaList.size()!= 0){
            system.debug('inside if>>>>>>>>>>>>>');
            insert agendaList;
        }
        
        if(documentDetails.size()>0){
            return documentDetails;
        }
        return null;
    }
    @AuraEnabled
    public static CORE_LA_EventWrapperClass.Event saveEventDateTimeDetails(String fromEventDate,String toEventDate,Id eventId ){
        CORE_LA_EventWrapperClass.Event eventDetails= new CORE_LA_EventWrapperClass.Event();
        CORE_LA_Event__c eventObj= new CORE_LA_Event__c();
        eventObj=[SELECT Id,Name,From_Date__c,To_Date__c FROM CORE_LA_Event__c WHERE ID = :eventId];
        eventObj.From_Date__c= DateTime.newInstance(long.valueOf(fromEventDate));
        eventObj.To_Date__c= DateTime.newInstance(long.valueOf(toEventDate));
        update eventObj;
        
         return eventDetails;
    }
    @AuraEnabled
    public static List<CORE_LA_Participant__c> getAttendeeList(String eventId){
        List<CORE_LA_Participant__c> attendeeList= [SELECT Id,Name,Participant_Name__c,Participant_Name__r.Name,Status__c,Event__c FROM CORE_LA_Participant__c WHERE Event__c =:eventId AND Role__c = 'Attendee'];
        if(attendeeList.size()!=0){
            return attendeeList;
        }
        else{
            return null;
        }
    }
    @AuraEnabled
    public static void updateAttendeeList(String eventId, LIST<String> removeAttendees){
        If(removeAttendees.size()!=0){
            for(String attendee:removeAttendees){  
                CORE_LA_Participant__c removeAttendee=[Select Id from CORE_LA_Participant__c where Id=:attendee];
                delete removeAttendee;
            }
        }      
    }
    
    @AuraEnabled
    public static List<ContentVersion> getAgendaDocumentDetails(String eventId){
        CORE_LA_Event__c eventObj= new CORE_LA_Event__c();
        eventObj=[SELECT Id,Name,From_Date__c,To_Date__c,Agenda__c FROM CORE_LA_Event__c WHERE Id =: eventId];
        
        if(eventObj.Agenda__c != 'null' && eventObj.Agenda__c != ''){
            List<ContentVersion> documentDetails = new List<ContentVersion>();        
            documentDetails = [Select Id,FileType,Title From ContentVersion Where Id =: eventObj.Agenda__c];   
            return documentDetails;
        }
        return null;
    }
    @AuraEnabled 
    public static CORE_LA_EventWrapperClass.Event getEventDateTime(String eventId){
       CORE_LA_Event__c eventObj= new CORE_LA_Event__c();
        eventObj=[SELECT Id,Name,From_Date__c,To_Date__c FROM CORE_LA_Event__c WHERE ID = :eventId];
       CORE_LA_EventWrapperClass.Event eventDetails= new CORE_LA_EventWrapperClass.Event();
        eventDetails.fromDate=eventObj.From_Date__c;
        eventDetails.toDate=eventObj.To_Date__c;
        return eventDetails;
    }
    @AuraEnabled 
    public static CORE_LA_EventWrapperClass.Event getAgendaDetails(String eventId){
        List<CORE_LA_Agenda__c> agendaList=[SELECT Event__c,From_Time__c,Id,Name,Summary__c,To_Time__c FROM CORE_LA_Agenda__c WHERE Event__c = :eventId];
    	CORE_LA_EventWrapperClass.Event agendaDetails=new CORE_LA_EventWrapperClass.Event();
        CORE_LA_Event__c eventDetails= [SELECT From_Date__c,Id,Name,To_Date__c FROM CORE_LA_Event__c WHERE Id =:eventId ];
        if(agendaList.size()!=0 ){
            agendaDetails.agendaList=agendaList;
            
        }
        if(eventDetails.From_Date__c!= null && eventDetails.To_Date__c!= null){
           agendaDetails.fromDate=eventDetails.From_Date__c;
        agendaDetails.toDate=eventDetails.To_Date__c;  
        }
       
        system.debug('getAgendaDetails>>>>> '+agendaDetails);
       return agendaDetails;
    }
    //Admin Add Attendee ,Admin
   @AuraEnabled
     public static CORE_LA_EventWrapperClass.TrainerWrapper getParticipantListWrapper(String eventId, List<User> participantList,String Role, String Status){
         CORE_LA_EventWrapperClass.TrainerWrapper eventDetails= new CORE_LA_EventWrapperClass.TrainerWrapper();
         system.debug('List'+participantList);
         
         If(participantList.size()!=0){
           for(User u:participantList){  
               CORE_LA_Participant__c ParticipantObj= new CORE_LA_Participant__c();
               ParticipantObj.Role__c=Role;
               ParticipantObj.Event__c= eventId;
               ParticipantObj.Status__c=Status;
               ParticipantObj.Participant_Name__c=u.Id;
               insert ParticipantObj; 
           }
         }      
         return eventDetails;
     }
    @AuraEnabled
    public static CORE_LA_EventWrapperClass.Event getAdminList(String eventId){//adminList
        CORE_LA_EventWrapperClass.Event adminDetails= new CORE_LA_EventWrapperClass.Event();
        List<CORE_LA_Participant__c> EventAdminList=[SELECT Event__c,Name,Participant_Name__c,Participant_Name__r.Name,Role__c,Status__c FROM CORE_LA_Participant__c WHERE Event__c =:eventId AND Role__c = 'Admin'];
        if(EventAdminList.size()!=0){
            adminDetails.adminList=EventAdminList;
            return adminDetails;
        }
        return null;
    }
    
}