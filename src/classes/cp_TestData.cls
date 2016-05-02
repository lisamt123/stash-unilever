/**
*
* Author:		Carmine Barbuto
* Date:			31/01/2013
* Description:	Test class used to create all test data.
*
**/
@isTest
public class cp_TestData {


    // PLANNER EVENT
    public static cp_Event__c getTestPlannerEvent() {
        cp_Event__c e  			= getTestPlannerEvent('Global');
        
        return e;
    }
    public static cp_Event__c getTestPlannerEvent(String LocalOrGlobal) {
        cp_Event__c e           = new cp_Event__c();
        e.Name                  = 'Test';
        e.Local_or_Global__c    = LocalOrGlobal;
        
        return e;
    }

    // PLANNER
    public static cp_Planner__c getTestPlanner() {
        return getTestPlanner(cp_PlannerUtility.CLUSTER,'Europe', UserInfo.getUserId());
    }

    public static cp_Planner__c getTestPlanner(String subtype, String name, String ownerId) {
        cp_Planner__c p = new cp_Planner__c();
        p.Name          = name;
        p.SubType__c    = subtype;
        p.Owner__c      = ownerId;

        return p;
    }

    // PLANNER LOCATION
    public static cp_PlannerLocation__c getTestPlannerLocation(String eventId, String plannerId) {
        cp_PlannerLocation__c pl    = new cp_PlannerLocation__c();
        pl.Event__c                 = eventId;
        pl.Planner__c               = plannerId;

        return pl;
    }

    // PLANNER PREFERENCE
    public static cp_PlannerPreference__c getTestPlannerPreference(Id plannerId, Id userId)
    {
        cp_PlannerPreference__c pp  = new cp_PlannerPreference__c();
        pp.Planner__c               = plannerId;
        pp.User__c                  = userId;

        return pp;
    }

    // ULE
    public static cp_ULE_Contact__c getTestULE()
    {
        cp_ULE_Contact__c ule   = new cp_ULE_Contact__c();
        ule.Active_ULE__c       = true;
        ule.FirstName__c        = 'Leadership';
        ule.Name                = 'Exec';

        return ule;
    }
    
    // USER
    public static User getTestUser(String profileName,String name) {
        Profile pf = [select id from profile where name=:profileName limit 1];
        User user  = new User(alias = name, email= name +'standarduser@ulc.com',
                                emailencodingkey='UTF-8', lastname= name + 'lastName', 
                                languagelocalekey='en_US',localesidkey='en_US', 
                                profileid = pf.Id,timezonesidkey='America/Los_Angeles', 
                                username= name + DateTime.now().millisecond() + 'standarduser@ulc.com');
        return user;
    }

    // Create planners, events and locations
    public static void createTestData()
    {
        // Create planner data
        insert cp_TestData.getTestPlanner('Foods', 'Category', UserInfo.getUserId());
        insert cp_TestData.getTestPlanner('Campaigns', 'Expertise', UserInfo.getUserId());
        insert cp_TestData.getTestPlanner('Legal', 'Function', UserInfo.getUserId());
        insert cp_TestData.getTestPlanner('Canada', 'Country', UserInfo.getUserId());
        insert cp_TestData.getTestPlanner('Brazil', 'MCO', UserInfo.getUserId());
        insert cp_TestData.getTestPlanner('Europe', 'Cluster', UserInfo.getUserId());

        List<cp_Planner__c> allPlanners = [Select Id From cp_Planner__c];

        // Create an active ULE
        cp_ULE_Contact__c ule = cp_TestData.getTestULE();
        insert ule;

        // Create default preference for user
        insert cp_TestData.getTestPlannerPreference([Select Id From cp_Planner__c Order by Name Limit 1][0].Id, UserInfo.getUserId());

        // Create a number of events
        List<cp_Event__c> testEvents = new List<cp_Event__c>();
        for (Integer i = 0; i < 100; i++)
        {
            cp_Event__c testGlobalEvent             = cp_TestData.getTestPlannerEvent();
            testGlobalEvent.StartDate__c            = system.today().addDays(i);
            testGlobalEvent.EndDate__c              = system.today().addDays(i);
            testGlobalEvent.Are_Dates_Guarenteed__c = Math.Mod(i, 2) == 0 ? 'Yes' : 'No';
            testGlobalEvent.Activity_Status__c      = Math.Mod(i, 2) == 0 ? 'Tentative' : 'Confirmed';
            testGlobalEvent.Activity_Type__c        = Math.Mod(i, 2) == 0 ? 'Tier 1 - Big Moment' : 'Tier 2 - External';
            testEvents.add(testGlobalEvent);

            cp_Event__c testLocalEvent              = cp_TestData.getTestPlannerEvent('Local');
            testLocalEvent.StartDate__c             = system.today().addDays(i);
            testLocalEvent.EndDate__c               = system.today().addDays(i);
            testLocalEvent.Are_Dates_Guarenteed__c  = Math.Mod(i, 2) == 0 ? 'Yes' : 'No';
            testLocalEvent.Activity_Status__c       = Math.Mod(i, 2) == 0 ? 'Tentative' : 'Confirmed';
            testLocalEvent.Activity_Type__c        = Math.Mod(i, 2) == 0 ? 'Tier 1 - Big Moment' : 'Tier 2 - External';
            testEvents.add(testLocalEvent);
        }
        insert testEvents;

        system.assertEquals(
            200,
            [Select count() From cp_Event__c],
            'Not all events are created'
        );

        // Create child events, activations, opt outs
        List<cp_PlannerLocation__c> plannerLocations = new List<cp_PlannerLocation__c>();
        List<cp_ULE__c>             uleReps          = new List<cp_ULE__c>();
        List<cp_Event__c>           childEvents      = new List<cp_Event__c>();
        for (cp_Event__c event :testEvents)
        {
            for (Integer i = 0; i < 6; i++)
            {
                cp_PlannerLocation__c testLoc   = cp_TestData.getTestPlannerLocation(event.Id, allPlanners[i].Id);
                testLoc.Activate__c             = Math.Mod(i, 2) == 0 ? true : false;
                testLoc.OptOut__c               = Math.Mod(i, 2) == 0 ? false : true;
                plannerLocations.add(testLoc);

                if (Math.Mod(i, 2) == 0 && event.Local_or_Global__c == 'Global')
                {
                    cp_Event__c testLocalEvent              = cp_TestData.getTestPlannerEvent('Local');
                    testLocalEvent.StartDate__c             = system.today().addDays(i);
                    testLocalEvent.EndDate__c               = system.today().addDays(i);
                    testLocalEvent.Are_Dates_Guarenteed__c  = 'Yes';
                    testLocalEvent.Parent_Event__c          = event.Id;
                    testLocalEvent.Activity_Status__c       = 'Confirmed';
                    childEvents.add(testLocalEvent);
                }
            }

            cp_ULE__c uleRep                        = new cp_ULE__c();
            uleRep.Event__c                         = event.Id;
            uleRep.UnileverLeadershipExecutive__c   = ule.Id;
            uleReps.add(uleRep);

        }

        insert plannerLocations;
        insert childEvents;
        insert uleReps;
    }
}