/*
    Controller for the cp_EventEdit page
    This controller is used to handle edit of Planner Events
    It also has some validation based on the user's planner selection
*/
public with sharing class cp_EventEditController {

    public Id           plannerEventId      {get;set;}
    public cp_Event__c  plannerEvent        {get;set;}
    public cp_Event__c  parentPlannerEvent  {get;set;}
    public Boolean      eventActivated      {get;set;}
    public Boolean      canEdit             {get;set;}
    
    public cp_EventEditController(ApexPages.StandardController controller) 
    {
        plannerEventId = ApexPages.currentPage().getParameters().get('id');
        canEdit = true;

        Id plId = cp_PlannerUtility.getDefaultPlanner(UserInfo.getUserId());                                 
        List<cp_PlannerLocation__c> childEvents = [SELECT Id 
                                                   FROM cp_PlannerLocation__c
                                                   WHERE Event__r.Parent_Event__c =:plannerEventId
                                                   AND Planner__c =:plId];

        if (childEvents.size() > 0 && ApexPages.currentPage().getParameters().get('activate') != null)
        {
            eventActivated = true;
        } 
        else 
        {
            eventActivated = false;
            
            if (ApexPages.currentPage().getParameters().get('clone') != null)
            {
                cloneEvent();
            } 

            else if (ApexPages.currentPage().getParameters().get('activate') != null)
            {
                activateEvent();
            }

            else if (plannerEventId == null)
            {
                plannerEvent = new cp_Event__c();
            }
            else
            {
                plannerEvent = eventWithAllFields(plannerEventId);
                canEdit = cp_PlannerUtility.canEditEvent(plannerEvent.HostPlanner__c, UserInfo.getUserId());
            }
        }
    }

    private void cloneEvent()
    {
        parentPlannerEvent = eventWithAllFields(plannerEventId);
        plannerEvent = parentPlannerEvent.clone(
            false, // preserve id
            true, // deep clone
            false, // preserve read-only timestamps
            false // preserve auto-numbers
        );
        clearFields(false);
    }

    private void activateEvent()
    {
        cloneEvent();
        clearFields(true);
    }

    private void clearFields(Boolean activatedEvent)
    {
        
        if (activatedEvent)
        {
            plannerEvent.RecordTypeId       = eventRecordTypes.get('EventDraft');
            plannerEvent.Parent_Event__c    = parentPlannerEvent.Id;
            plannerEvent.Activate_Event__c  = true;
            plannerEvent.Local_or_Global__c = 'Local';
            plannerEvent.Activity_Status__c = 'Offline';

            for (Schema.FieldSetMember fld: SObjectType.cp_Event__c.FieldSets.BlankOnActivate.getFields()) 
            {
                plannerEvent.put(fld.FieldPath,null); 
            }

        }
        else 
        {
            plannerEvent.Activity_Status__c = 'Offline';
            plannerEvent.RecordTypeId = eventRecordTypes.get('EventDraft');

            for (Schema.FieldSetMember fld: SObjectType.cp_Event__c.FieldSets.BlankOnClone.getFields()) 
            {
                plannerEvent.put(fld.FieldPath,null); 
            }
        }

    }

    public PageReference save()
    {
        try
        {
            upsert plannerEvent;

            if (ApexPages.currentPage().getParameters().get('activate') != null)
            {

                Id defaultPlannerId = cp_PlannerUtility.getDefaultPlanner(UserInfo.getUserId());

                insert new cp_PlannerLocation__c(
                    Event__c    = plannerEvent.Id,
                    Planner__c  = defaultPlannerId,
                    Activate__c = true
                );

                List<cp_PlannerLocation__c> parentEventPlannerLocation = [SELECT    Id, Activate__c, OptOut__c 
                                                                          FROM      cp_PlannerLocation__c
                                                                          WHERE     Event__c    = :parentPlannerEvent.Id
                                                                          AND       Planner__c  = :defaultPlannerId];

                for (cp_PlannerLocation__c parentLocation :parentEventPlannerLocation)
                {
                    parentLocation.Activate__c      = true;
                    parentLocation.OptOut__c        = false;
                    parentLocation.OptOutReason__c  = null;
                }
                update parentEventPlannerLocation;
                update new cp_Event__c(Id = plannerEvent.Id); // This update will populate the rollup text field for planners
            }

            return new PageReference('/' + plannerEvent.Id);
        }
        catch (Exception ex)
        {
            ApexPages.addMessages(ex);
            return null;
        }
    }

    private cp_Event__c eventWithAllFields(Id eventId)
    {
        string soqlQuery = 'Select ';
        for (Schema.SObjectField field :schema.SObjectType.cp_Event__c.fields.getMap().values())
        {
            soqlQuery += field.getDescribe().getName() + ',';
        }
        soqlQuery = soqlQuery.subString(0, soqlQuery.length() - 1);
        soqlQuery += ' From cp_Event__c Where Id = :eventId';
        return database.query(soqlQuery);
    }

    private static Map<String, Id> eventRecordTypes 
    {
        get
        {
            if (eventRecordTypes == null)
            {
                eventRecordTypes = new Map<String,Id>();
                for (RecordType rt :[SELECT Id, DeveloperName 
                                     FROM RecordType 
                                     WHERE SObjectType = 'cp_Event__c'])
                {
                    eventRecordTypes.put(rt.DeveloperName, rt.Id);
                }
            }
            return eventRecordTypes;
        }
        set;
    } 
}