@isTest
private class BET_ChatterController_Test {
    
    @isTest static void emptyGidParameter() {
        System.Test.setCurrentPageReference(Page.BET_Chatter);

        BET_ChatterController controller = new BET_ChatterController();

        system.assertEquals(false, controller.showChatter);
        system.assertEquals(null, controller.BETGroupId);
        system.assertEquals('', controller.message);
    }
    
    @isTest static void invalidGidParameter() {
        System.Test.setCurrentPageReference(Page.BET_Chatter);
        System.currentPageReference().getParameters().put('gid', '001000000000001');

        BET_ChatterController controller = new BET_ChatterController();

        system.assertEquals(false, controller.showChatter);
        system.assertEquals(null, controller.BETGroupId);
        system.assertEquals('You don\'t have access to this group.', controller.message);
    }

    @isTest static void archivedChatterGroup() {
        BET_TestingHelper.BET_TestingData betWrapper = BET_TestingHelper.initBET('UT_BET', true);
        betWrapper.archiveGroup();

        System.Test.setCurrentPageReference(Page.BET_Chatter);
        System.currentPageReference().getParameters().put('gid', betWrapper.BET.Studio_Chatter_Group__c);

        BET_ChatterController controller = new BET_ChatterController();

        system.assertEquals(true, controller.showChatter);
        system.assertEquals(betWrapper.BET.Studio_Chatter_Group__c, controller.BETGroupId);
        system.assertEquals('This chatter group has been archived. Please contact your group owner/manager for reactivation.', controller.message);
    }

    @isTest static void activeChatterGroup() {
        BET_TestingHelper.BET_TestingData betWrapper = BET_TestingHelper.initBET('UT_BET', true);

        System.Test.setCurrentPageReference(Page.BET_Chatter);
        System.currentPageReference().getParameters().put('gid', betWrapper.BET.Studio_Chatter_Group__c);

        BET_ChatterController controller = new BET_ChatterController();

        system.assertEquals(true, controller.showChatter);
        system.assertEquals(betWrapper.BET.Studio_Chatter_Group__c, controller.BETGroupId);
        system.assertEquals('', controller.message);
    }

    @isTest static void changeFeedContext() {
        BET_TestingHelper.BET_TestingData betWrapper = BET_TestingHelper.initBET('UT_BET', true);

        System.Test.setCurrentPageReference(Page.BET_Chatter);
        System.currentPageReference().getParameters().put('gid', betWrapper.BET.Studio_Chatter_Group__c);

        BET_ChatterController controller = new BET_ChatterController();

        system.assertEquals(betWrapper.BET.Studio_Chatter_Group__c, controller.BETGroupId);

        controller.entityId ='a01000000000000';
        controller.UpdateChatterFeed();
        system.assertEquals('a01000000000000', controller.BETGroupId);
    }
}