public  class cp_EventTriggerHandler {
    /* Activity Statuses */
    public static final String EVENT_STATUS_OFFLINE         = 'Offline';
    public static final String EVENT_STATUS_DRAFT           = 'Draft';
    public static final String EVENT_STATUS_SUBMITTED       = 'Submitted';

    public static final list<String> NON_LOCAL_EVENTS       = new list<String>{};
    private boolean m_isExecuting                           = false;
    private integer BatchSize                               = 0;
    
    public cp_EventTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    // ********************* HEADINGS ********************* //
    
    // BEFORE INSERT
    public void OnBeforeInsert(cp_Event__c[] newEvents, Map<ID, cp_Event__c> EventMap){
        cp_PlannerUtility.setHostPlanner(newEvents);
    }
    
    // BEFORE UPDATE
    public void OnBeforeUpdate(cp_Event__c[] oldEvents, cp_Event__c[] updatedEvents, Map<ID, cp_Event__c> newEventMap, Map<ID, cp_Event__c> oldEventMap){
        updateCommentHistory(updatedEvents, newEventMap);
        cp_PlannerUtility.setPlannerTextField(newEventMap,false);
    }
    
    // AFTER UPDATE
    public void OnAfterUpdate(cp_Event__c[] oldEvents, cp_Event__c[] updatedEvents, Map<ID, cp_Event__c> newEventMap, Map<ID, cp_Event__c> oldEventMap){
        notifyUsers(oldEvents, newEventMap);
        createReapproval(newEventMap, oldEventMap);
        if (!cp_PlannerUtility.emailSent)
            notifyOwnersAfterReapproval(newEventMap, oldEventMap);
    }
    
    // ********************* BUSINESS LOGIC ********************* //

    private void updateCommentHistory(cp_Event__c[] newEvents, map<ID, cp_Event__c> eventMap) {
        List<processInstanceHistory> processHistory = new List<processInstanceHistory>();
        String remarks;
        Set<Id> actorIds = new Set<Id>();
        Map<Id, cp_Event__c> processRecordsMap = new Map<Id, cp_Event__c>([SELECT (SELECT StepStatus, Comments, ActorId, SystemModstamp FROM ProcessSteps  order by SystemModstamp desc) FROM cp_Event__c
                                                                        WHERE Id IN:eventMap.keySet()]);
        for(cp_Event__c eachEvent : newEvents) {
            for(processInstanceHistory eachStep : processRecordsMap.get(eachEvent.Id).ProcessSteps) {
                actorIds.add(eachStep.ActorId);
            }
        }
        
        Map<Id, User> userMap = new Map<Id, User>([SELECT Name FROM User WHERE id IN: actorIds]);
        
        for(cp_Event__c eachEvent : newEvents) {
            String status;
            for(processInstanceHistory eachStep : processRecordsMap.get(eachEvent.Id).ProcessSteps) {
                status = eachStep.StepStatus;
                if(status == 'Removed') {
                    status = 'Recalled';
                }
                if(remarks != null && eachStep.Comments != null && (status == 'Rejected' || status == 'Recalled' || status == 'Reassigned')) {
                        remarks += '<br />----------------<br />';
                    remarks += userMap.get(eachStep.ActorId).Name + '(Actual Approver): ' + eachStep.Comments + '<br/>';
                    remarks += 'Status: <b>' + status + '</b><br/>';
                    remarks += 'Date/Time: ' + eachStep.SystemModstamp;
                }else if(remarks == null && eachStep.Comments != null && (status == 'Rejected' || status == 'Recalled' || status == 'Reassigned')) {
                        remarks = userMap.get(eachStep.ActorId).Name + '(Actual Approver): ' + eachStep.Comments + '<br/>';
                        remarks += 'Status: <b>' + status + '</b><br/>';
                        remarks += 'Date/Time: ' + eachStep.SystemModstamp;
                }
            }
            eachEvent.Approval_History_Thread__c = remarks;
            remarks = null;
        }
    }
    
    // PARTICIPANT LOGIC
    private void notifyUsers(cp_Event__c[] oldEvents, map<ID, cp_Event__c> eventMap) {
        try {
            // 1. Get all eventIds for which participants should be created for market and for central
            Set <Id> setUpdatedEventIds = new Set <Id> ();
                        
            for(cp_Event__c oldEvent: oldEvents) {
                cp_Event__c updatedEvent = eventMap.get(oldEvent.Id);
                if  (
                    // Do not spam users on past events
                    updatedEvent.StartDate__c >= Date.today() && 
                    (     
                    // a. event status changed to confirmed or tentative
                    (updatedEvent.Activity_Status__c != oldEvent.Activity_Status__c &&
                    (cp_PlannerUtility.CONFIRMED.equals(updatedEvent.Activity_Status__c) ||
                    cp_PlannerUtility.TENTATIVE.equals(updatedEvent.Activity_Status__c)))
                    ||
                    // b. market assignment changed for active/tentative event
                    ((cp_PlannerUtility.CONFIRMED.equals(updatedEvent.Activity_Status__c) ||
                    cp_PlannerUtility.TENTATIVE.equals(updatedEvent.Activity_Status__c) 
                    ) &&
                    (updatedEvent.Track_Cluster__c != oldEvent.Track_Cluster__c ||
                    updatedEvent.Track_Country__c != oldEvent.Track_Country__c ||
                    updatedEvent.Track_MCO__c != oldEvent.Track_MCO__c ||
                    updatedEvent.Track_Categories__c != oldEvent.Track_Categories__c ||
                    updatedEvent.Track_Expertise__c != oldEvent.Track_Expertise__c ||
                    updatedEvent.Track_Functions__c != oldEvent.Track_Functions__c))
                    ||      
                    // c. Activity_Type__c changed for active/tentative event
                    ((cp_PlannerUtility.CONFIRMED.equals(updatedEvent.Activity_Status__c) ||
                    cp_PlannerUtility.TENTATIVE.equals(updatedEvent.Activity_Status__c) 
                    ) &&
                    (updatedEvent.Activity_Type__c != oldEvent.Activity_Type__c))
                    ) 
                    ) 
                {
                    setUpdatedEventIds.add(updatedEvent.id);
                }
            }

            // 2. Get existing participants for defined events
            Map<Id, Map<Id, cp_Participant__c>> mapExistingEventParticipants = new Map<Id, Map<Id, cp_Participant__c>> ();
            for (cp_Participant__c participant : [select Event__c, Id, Participant_Name__c from cp_Participant__c where Event__c in :setUpdatedEventIds]){
                if (!mapExistingEventParticipants.containsKey(participant.Event__c)){
                    Map<Id, cp_Participant__c> mapParticipants = new Map<Id, cp_Participant__c>();
                    mapParticipants.put(participant.Participant_Name__c, participant);
                    mapExistingEventParticipants.put(participant.Event__c, mapParticipants);
                }
                else {
                    mapExistingEventParticipants.get(participant.Event__c).put(participant.Participant_Name__c, participant);
                }
            }
                        
            // 3. Get all new participants for markets
            Map<Id, Map<Id, cp_Participant__c>> mapEventParticipant = new Map<Id, Map<Id, cp_Participant__c>> ();
            if (setUpdatedEventIds.size() > 0){
                mapEventParticipant = getEventParticipants(setUpdatedEventIds);
            }

            // 5. Upsert participants (prepare DML lists)
            List<cp_Participant__c> liNewParticipants = new List<cp_Participant__c>();
            List<cp_Participant__c> liDelParticipants = new List<cp_Participant__c>();
            // remove exiting users from existing user map or if not found add it to new participate list
            for (Id eventId : mapEventParticipant.keySet()){
                for (id userId : mapEventParticipant.get(eventId).keySet()){
                    if (mapExistingEventParticipants.containsKey(eventId) && mapExistingEventParticipants.get(eventId).containsKey(userId)){
                        mapExistingEventParticipants.get(eventId).remove(userId);
                    }
                    else {
                        liNewParticipants.add(mapEventParticipant.get(eventId).get(userId));
                    }
                }
            }
                        
            // create a list of participants for deletion (the remaing participants in existing map are not more valid)
            for (Id eventId : mapExistingEventParticipants.keySet()){
                for (id userId : mapExistingEventParticipants.get(eventId).keySet()){
                    liDelParticipants.add(mapExistingEventParticipants.get(eventId).get(userId));
                }       
            }
            
            // delete not more valid, existing participant
            if (liDelParticipants.size() > 0){
                delete liDelParticipants;
            }
            // insert new participants
            if (liNewParticipants.size() > 0){
                insert liNewParticipants;
            }

        } catch (Exception ex){
            System.debug('!!!!!!Exception occured in EventTriggerHandler: ' + ex.getMessage());
            System.debug('!!!!!!Exception occured in EventTriggerHandler: ' + ex.getStackTraceString());
            eventMap.values().get(0).addError(Label.cp_EventTriggerHandler_General_Exception);
        }       
    }        
    private Map<Id, Map<Id, cp_Participant__c>> getEventParticipants(Set<ID> setUpdatedEventIds) {
        Map<Id, Map<Id, cp_Participant__c>> retVal = new Map<Id, Map<Id, cp_Participant__c>>();

        // Get Planner Locations and create participant map
        for (cp_PlannerLocation__c curr : [SELECT Planner__r.Owner__c, Event__c 
                                            FROM cp_PlannerLocation__c
                                            WHERE Event__c IN :setUpdatedEventIds]) {
            addNewParticipant(retVal, curr.Event__c, curr.Planner__r.Owner__c);
        }

        return retVal;
    }
    private void addNewParticipant(Map<Id, Map<Id, cp_Participant__c>> mapParticipants, Id eventId,Id userId){
        if (!mapParticipants.containsKey(eventId)){
            mapParticipants.put(eventId, new Map<Id, cp_Participant__c>());
        }
        mapParticipants.get(eventId).put(userId, buildParticipant(eventId, userId));
    }
    
    private cp_Participant__c buildParticipant(final Id eventId, final Id userId) {
        cp_Participant__c pt = new cp_Participant__c(Event__c = eventId, Participant_Name__c = userId);
        return pt;
    }

    // GLOBAL RE-APPROVAL PROCESS
    private void createReapproval(Map<ID, cp_Event__c> newEventMap, Map<ID, cp_Event__c> oldEventMap)
    {
        Set<Id> eventIds = new Set<Id>();
        List<Id> participantsIds = new List<Id>();

        for (Id eventId : newEventMap.keySet()) 
        {
            if (    oldEventMap.get(eventId).ReApprovalRequired__c 
                !=  newEventMap.get(eventId).ReApprovalRequired__c 
                &&  newEventMap.get(eventId).ReApprovalRequired__c == true) 
            {
                eventIds.add(eventId);
            }
        }

        try {
            for (Id eventId : eventIds) {
                Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                approvalRequest.setComments('Submitting request for Global re-approval.');
                approvalRequest.setObjectId(eventId);
                Approval.ProcessResult approvalResult = Approval.process(approvalRequest);
            }
        } catch (Exception ex) {
            for (cp_Event__c curr : newEventMap.values()) {
               curr.addError(' ' + Label.cp_DefaultSubmitWarning + ' ' + Label.cp_NoPlannerSelected);
            }
        }
    }
    
    // EMAIL ALERT TO PLANNER OWNERS    
    private void notifyOwnersAfterReapproval(Map<ID, cp_Event__c> newEventMap, Map<ID, cp_Event__c> oldEventMap)
    {

        Set<Id> eventIds = new Set<Id>();
        List<Id> participantsIds = new List<Id>();

        for (Id eventId : newEventMap.keySet()) 
        {
            if (    oldEventMap.get(eventId).ReApprovalRequired__c 
                !=  newEventMap.get(eventId).ReApprovalRequired__c 
                &&  newEventMap.get(eventId).ReApprovalRequired__c == false
                &&  (newEventMap.get(eventId).Activity_Status__c == cp_PlannerUtility.CONFIRMED
                ||   newEventMap.get(eventId).Activity_Status__c == cp_PlannerUtility.TENTATIVE)) 
            {
                eventIds.add(eventId);
            }
        }

        List<cp_Participant__c> participants = new List<cp_Participant__c>([SELECT ReApprovalEmailNeeded__c
                                                                            FROM cp_Participant__c
                                                                            WHERE Event__c IN : eventIds]); 

        for(cp_Participant__c p : participants)
        {
            p.ReApprovalEmailNeeded__c = true;
        }

        if (!participants.isEmpty()) 
        {
            update participants;
            cp_PlannerUtility.emailSent = true;
        }

    }

}