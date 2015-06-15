/**
*
* Author:       Carmine Barbuto
* Date:         14/05/2014
* Description:  Test class for EventTriggerHandler.
*
* --------------
* COVERAGE:  86%
* --------------
*
**/
@isTest
private class cp_EventTriggerHandlerTest
{
    static testMethod void testHostPlanner()
    {
        // User
        User testUser = cp_TestData.getTestUser('System Administrator','Host');
        insert testUser;

        // Planner
        cp_Planner__c   cluster = cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,'Test',testUser.Id);
        insert cluster;
        cp_Planner__c   mco     = cp_TestData.getTestPlanner(cp_PlannerUtility.MCO,'Italy',testUser.Id);
        insert mco;

        // Planner Preferences
        cp_PlannerPreference__c defaults = new cp_PlannerPreference__c();
        defaults.Planner__c = cluster.Id;
        insert defaults;
        cp_PlannerPreference__c mydefaults = new cp_PlannerPreference__c();
        mydefaults.Planner__c = mco.Id;
        mydefaults.User__c    = testUser.Id;
        insert mydefaults;

        // Create an Event
        system.runAs(testUser) {
            cp_Event__c e = cp_TestData.getTestPlannerEvent();
            insert e;

            // Check Host Planner field has been set
            cp_Event__c temp = [SELECT HostPlanner__c FROM cp_Event__c WHERE Id =:e.Id];
            system.assertEquals(temp.HostPlanner__c,mco.Id);
        }
    }

    static testMethod void testParticipant()
    {
        // User
        User testUser = cp_TestData.getTestUser('System Administrator','Part');
        insert testUser;
        User testUser2 = cp_TestData.getTestUser('System Administrator','Part2');
        insert testUser2;

        // Planner
        cp_Planner__c   mco     = cp_TestData.getTestPlanner(cp_PlannerUtility.MCO,'Italy',testUser.Id);
        insert mco;
        cp_Planner__c   fun     = cp_TestData.getTestPlanner(cp_PlannerUtility.MCO,'Finance',testUser2.Id);
        insert fun;

        // Planner Preferences
        cp_PlannerPreference__c defaults = new cp_PlannerPreference__c();
        defaults.Planner__c = mco.Id;
        insert defaults;

        // Event
        cp_Event__c e = cp_TestData.getTestPlannerEvent();
        e.StartDate__c = Date.today();
        insert e;

        // Planner Locations
        cp_PlannerLocation__c plm = cp_TestData.getTestPlannerLocation(e.Id, mco.Id);
        insert plm;

        // Change status to trigger participant
        e.Activity_Status__c = cp_PlannerUtility.CONFIRMED;
        update e;

        // Remove location and add new one to change participant list
        cp_PlannerLocation__c plf = cp_TestData.getTestPlannerLocation(e.Id, fun.Id);
        delete plm;
        insert plf;
        update e;
 
        // Check Participant list
        List<cp_Participant__c> temp = [SELECT Participant_Name__c FROM cp_Participant__c WHERE Event__c =:e.Id];
        system.assertEquals(temp.get(0).Participant_Name__c,testUser2.Id);

    }

    static testMethod void testReapprovalProcess()
    {
        // User
        User testUser = cp_TestData.getTestUser('System Administrator','User');
        insert testUser;

        // Planner
        cp_Planner__c mco = cp_TestData.getTestPlanner(cp_PlannerUtility.MCO,'Italy',testUser.Id);
        insert mco;

        // Planner Preferences
        cp_PlannerPreference__c defaults = new cp_PlannerPreference__c();
        defaults.Planner__c = mco.Id;
        insert defaults;

        // Event
        cp_Event__c e = cp_TestData.getTestPlannerEvent();
        e.StartDate__c = Date.today();
        e.EndDate__c = Date.today().addDays(1);
        e.Are_Dates_Guarenteed__c = 'Yes';
        insert e;

        // Planner Locations
        cp_PlannerLocation__c plm = cp_TestData.getTestPlannerLocation(e.Id, mco.Id);
        insert plm;

        RecordType rt = [select Id from RecordType where DeveloperName = 'EventApproved' and SobjectType = 'cp_Event__c' limit 1];

        // Change status to event approved
        e.Activity_Status__c = cp_PlannerUtility.CONFIRMED;
        e.RecordTypeId = rt.Id;
        update e;

        e.EndDate__c = Date.today().addDays(5);
        update e;

        List<cp_Event__c> ev = [SELECT Id, Activity_Status__c FROM cp_Event__c WHERE Id =: e.Id];
        system.assertEquals(ev.get(0).Activity_Status__c,cp_EventTriggerHandler.EVENT_STATUS_DRAFT);
    }

    static testMethod void testNotifyOwnersAfterReapproval()
    {
        // User
        User testUser = cp_TestData.getTestUser('System Administrator','User');
        insert testUser;

        // Planner
        cp_Planner__c mco = cp_TestData.getTestPlanner(cp_PlannerUtility.MCO,'Italy',testUser.Id);
        insert mco;

        // Planner Preferences
        cp_PlannerPreference__c defaults = new cp_PlannerPreference__c();
        defaults.Planner__c = mco.Id;
        insert defaults;

        // Event
        cp_Event__c e = cp_TestData.getTestPlannerEvent();
        e.StartDate__c = Date.today();
        e.EndDate__c = Date.today().addDays(1);
        e.Are_Dates_Guarenteed__c = 'Yes';
        insert e;

        // Planner Locations
        cp_PlannerLocation__c plm = cp_TestData.getTestPlannerLocation(e.Id, mco.Id);
        insert plm;

        // Participants 
        cp_Participant__c participant = new cp_Participant__c();
        participant.Event__c = e.Id;
        participant.Participant_Name__c = testUser.Id;
        insert participant;


        RecordType rt = [select Id from RecordType where DeveloperName = 'EventApproved' and SobjectType = 'cp_Event__c' limit 1];

        // Change status to event approved
        e.Activity_Status__c = cp_PlannerUtility.CONFIRMED;
        e.RecordTypeId = rt.Id;
        update e;

        e.EndDate__c = Date.today().addDays(5);
        update e;

        e.Activity_Status__c = cp_PlannerUtility.CONFIRMED;
        e.RecordTypeId = rt.Id;
        e.ReApprovalRequired__c = false;
        update e;

    }
}