/**
*
* Author:       Radoslava Radkova
* Date:         03/06/2014
* Description:  Test class for cp_EventEditController.
*
* --------------
* COVERAGE:  94%
* --------------
*
**/
@isTest
private class cp_EventEditControllerTest
{
	static testMethod void testActivate()
	{
		// Setup data
        User testUser 		= cp_TestData.getTestUser('System Administrator','EvntEdit');
        insert testUser;
        
        // Planners 
        cp_Planner__c	pl	= cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,'Europe',testUser.Id);
        insert pl;
        
        // Planner Defaults
        cp_PlannerPreference__c defaults = new cp_PlannerPreference__c();
        defaults.Planner__c = pl.Id;
        insert defaults;

        cp_PlannerPreference__c userDefault = new cp_PlannerPreference__c();
        userDefault.Planner__c = pl.Id;
        userDefault.User__c = testUser.Id;
        insert userDefault;
        
        // Event
        cp_Event__c e 			= cp_TestData.getTestPlannerEvent();
        insert e;
        // Child event
        cp_Event__c ce          = cp_TestData.getTestPlannerEvent();
        ce.Parent_Event__c      = e.Id;
        insert ce;

        // Related lists >> Planner locations
        cp_PlannerLocation__c loc   = cp_TestData.getTestPlannerLocation(e.Id, pl.Id);
        insert loc;
        
        Test.startTest();
        
        System.runAs(testUser)
        {
           
            Test.setCurrentPage(Page.cp_EventEdit);
            Apexpages.currentPage().getParameters().put('Id',e.Id);
            Apexpages.currentPage().getParameters().put('activate','1');

            ApexPages.StandardController sc = new ApexPages.standardController(e);
            
            cp_EventEditController controller = new cp_EventEditController(sc);
            controller.save();
            
            // Check activation
            List<cp_PlannerLocation__c> temp = [SELECT Planner__c FROM cp_PlannerLocation__c WHERE Event__r.Parent_Event__c =:e.Id];
            system.assertEquals(temp.get(0).Planner__c,pl.Id);

        }
            
        Test.stopTest();
        
    }

    static testMethod void testClone()
	{
		// Setup data
        User testUser 		= cp_TestData.getTestUser('System Administrator','EvntEdit');
        insert testUser;
        
        // Planners 
        cp_Planner__c	pl	= cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,'Europe',testUser.Id);
        insert pl;
        
        // Planner Defaults
        cp_PlannerPreference__c defaults = new cp_PlannerPreference__c();
        defaults.Planner__c = pl.Id;
        insert defaults;

        cp_PlannerPreference__c userDefault = new cp_PlannerPreference__c();
        userDefault.Planner__c = pl.Id;
        userDefault.User__c = testUser.Id;
        insert userDefault;
        
        // Event
        cp_Event__c e 			= cp_TestData.getTestPlannerEvent();
        insert e;
        // Child event
        cp_Event__c ce          = cp_TestData.getTestPlannerEvent();
        ce.Parent_Event__c      = e.Id;
        insert ce;

        // Related lists >> Planner locations
        cp_PlannerLocation__c loc   = cp_TestData.getTestPlannerLocation(e.Id, pl.Id);
        insert loc;
        
        Test.startTest();
        
        System.runAs(testUser)
        {
           
            Test.setCurrentPage(Page.cp_EventEdit);
            Apexpages.currentPage().getParameters().put('Id',e.Id);
            Apexpages.currentPage().getParameters().put('clone','1');

            ApexPages.StandardController sc = new ApexPages.standardController(e);
            
            cp_EventEditController controller = new cp_EventEditController(sc);
            controller.save();

        }
            
        Test.stopTest();
        
    }

    static testMethod void testNew()
	{
		// Setup data
        User testUser 		= cp_TestData.getTestUser('System Administrator','EvntEdit');
        insert testUser;
        
        // Planners 
        cp_Planner__c	pl	= cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,'Europe',testUser.Id);
        insert pl;
        
        // Planner Defaults
        cp_PlannerPreference__c defaults = new cp_PlannerPreference__c();
        defaults.Planner__c = pl.Id;
        insert defaults;

        cp_PlannerPreference__c userDefault = new cp_PlannerPreference__c();
        userDefault.Planner__c = pl.Id;
        userDefault.User__c = testUser.Id;
        insert userDefault;

        cp_Event__c e = cp_TestData.getTestPlannerEvent();
        
        Test.startTest();
        
        System.runAs(testUser)
        {
           
            Test.setCurrentPage(Page.cp_EventEdit);
            Apexpages.currentPage().getParameters().put('Id', null);

            ApexPages.StandardController sc = new ApexPages.standardController(e);
            
            cp_EventEditController controller = new cp_EventEditController(sc);
            controller.save();

        }
            
        Test.stopTest();
        
    }

    static testMethod void testEdit()
	{
		// Setup data
        User testUser 		= cp_TestData.getTestUser('System Administrator','EvntEdit');
        insert testUser;
        
        // Planners 
        cp_Planner__c	pl	= cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,'Europe',testUser.Id);
        insert pl;
        
        // Planner Defaults
        cp_PlannerPreference__c defaults = new cp_PlannerPreference__c();
        defaults.Planner__c = pl.Id;
        insert defaults;

        cp_PlannerPreference__c userDefault = new cp_PlannerPreference__c();
        userDefault.Planner__c = pl.Id;
        userDefault.User__c = testUser.Id;
        insert userDefault;
        
        // Event
        cp_Event__c e 			= cp_TestData.getTestPlannerEvent();
        insert e;
        // Child event
        cp_Event__c ce          = cp_TestData.getTestPlannerEvent();
        ce.Parent_Event__c      = e.Id;
        insert ce;

        // Related lists >> Planner locations
        cp_PlannerLocation__c loc   = cp_TestData.getTestPlannerLocation(e.Id, pl.Id);
        insert loc;
        
        Test.startTest();
        
        System.runAs(testUser)
        {
           
            Test.setCurrentPage(Page.cp_EventEdit);
            Apexpages.currentPage().getParameters().put('Id',e.Id);

            ApexPages.StandardController sc = new ApexPages.standardController(e);
            
            cp_EventEditController controller = new cp_EventEditController(sc);
            controller.save();

        }
            
        Test.stopTest();
        
    }

}