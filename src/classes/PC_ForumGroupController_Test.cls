@isTest
private class PC_ForumGroupController_Test {

    @isTest static void loadData_noId()
    {
        Test.startTest();

        PC_ForumGroupController_CC ctrl = new PC_ForumGroupController_CC();
        ctrl.loadData();

        System.assertEquals(true, ctrl.getHasMessages(), 'There should be an error message');

        Test.stopTest();
    }

    @isTest static void loadData_withId()
    {
        Test.startTest();

        CollaborationGroup cg = PC_DataFactory.createChatterGroup('test1', 'test1');
        PC_Group__c pc        = PC_DataFactory.createPCGroup('test group', 'test group', cg.id, '1234', 1, 'Summary');

        PC_DataFactory.createWikiPage('test', 'test', pc.Name, 'test', null, true, true);
        PC_DataFactory.createFaqPage('test', 'test', pc.Name, 'test', null, true, true);

        ApexPages.currentPage().getParameters().put('id', pc.Id);

        PC_ForumGroupController_CC ctrl = new PC_ForumGroupController_CC();
        ctrl.loadData();

        System.assertEquals(false, ctrl.getHasMessages(), 'There should be no error message');

        System.assertNotEquals(null, ctrl.pcGroup, 'Group should be present');
        System.assertNotEquals(null, ctrl.groupObj, 'Chatter group should be present');

        Test.stopTest();
    }
}