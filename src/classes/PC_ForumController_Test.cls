@isTest
private class PC_ForumController_Test
{

    @isTest static void getGroupList()
    {
        Test.startTest();

        PC_ForumController_CC fc = new PC_ForumController_CC();
        System.assertEquals(0, fc.getGroupList().size(), 'There should be no groups at all');

        CollaborationGroup cg = PC_DataFactory.createChatterGroup('test1', 'test1');
        PC_Group__c pc = PC_DataFactory.createPCGroup('test group', 'test group', cg.id, '1234', 1, 'Summary');

        System.assertEquals(1, fc.getGroupList().size(), 'There should be exactly one group');

        for (Integer i = 0; i < 6; i++) {
            pc = PC_DataFactory.createPCGroup('test group' + i, 'test group', cg.id, '1234', i + 2 , 'Summary');
        }
        System.assertEquals(2, fc.getGroupList().size(), 'There should be exactly two group');

        pc.Published__c = false;
        update pc;

        System.assertEquals(1, fc.getGroupList().size(), 'Only groups with Published flag set to true should be visible therefore only one page should be available');

        Test.stopTest();
    }

    @isTest static void getPlancraftGroup()
    {
        Test.startTest();

        PC_ForumController_CC fc = new PC_ForumController_CC();
        System.assertEquals(null, fc.getPlancraftGroup(), 'There should be no plancraft group');

        CollaborationGroup cg = PC_DataFactory.createChatterGroup('test1', 'test1');
        PC_Group__c pc = PC_DataFactory.createPCGroup('test group', 'test group', cg.id, '1234', 0, 'Summary');

        System.assertEquals(pc.Id, fc.getPlancraftGroup().id, 'Plancraft group is invalid');

        pc.Published__c = false;
        update pc;

        System.assertEquals(null, fc.getPlancraftGroup(), 'Only groups with Published flag set to true should be visible');

        Test.stopTest();
    }
    
    @isTest static void getPBSForumGroupId()
    {
        Test.startTest();

        PC_ForumController_CC fc = new PC_ForumController_CC();
        System.assertEquals(null, fc.getPBSForumGroupId(), 'There should be no plancraft group');

        CollaborationGroup cg = PC_DataFactory.createChatterGroup('test1', 'test1');
        PC_Group__c pc = PC_DataFactory.createPCGroup('test group', 'test group', cg.id, '1234', 5, 'Summary');

        System.assertEquals(pc.Id, fc.getPBSForumGroupId().id, 'Plancraft group is invalid');

        pc.Published__c = false;
        update pc;

        System.assertEquals(null, fc.getPBSForumGroupId(), 'Only groups with Published flag set to true should be visible');

        Test.stopTest();
    }
    
     @isTest static void getDPForumGroupId()
    {
        Test.startTest();

        PC_ForumController_CC fc = new PC_ForumController_CC();
        System.assertEquals(null, fc.getDPForumGroupId(), 'There should be no plancraft group');

        CollaborationGroup cg = PC_DataFactory.createChatterGroup('test1', 'test1');
        PC_Group__c pc = PC_DataFactory.createPCGroup('test group', 'test group', cg.id, '1234', 1, 'Summary');

        System.assertEquals(pc.Id, fc.getDPForumGroupId().id, 'Plancraft group is invalid');

        pc.Published__c = false;
        update pc;

        System.assertEquals(null, fc.getDPForumGroupId(), 'Only groups with Published flag set to true should be visible');

        Test.stopTest();
    }
    
     @isTest static void getSPForumGroupId()
    {
        Test.startTest();

        PC_ForumController_CC fc = new PC_ForumController_CC();
        System.assertEquals(null, fc.getSPForumGroupId(), 'There should be no plancraft group');

        CollaborationGroup cg = PC_DataFactory.createChatterGroup('test1', 'test1');
        PC_Group__c pc = PC_DataFactory.createPCGroup('test group', 'test group', cg.id, '1234', 2, 'Summary');

        System.assertEquals(pc.Id, fc.getSPForumGroupId().id, 'Plancraft group is invalid');

        pc.Published__c = false;
        update pc;

        System.assertEquals(null, fc.getSPForumGroupId(), 'Only groups with Published flag set to true should be visible');

        Test.stopTest();
    }
    
     @isTest static void getDisPForumGroupId()
    {
        Test.startTest();

        PC_ForumController_CC fc = new PC_ForumController_CC();
        System.assertEquals(null, fc.getDisPForumGroupId(), 'There should be no plancraft group');

        CollaborationGroup cg = PC_DataFactory.createChatterGroup('test1', 'test1');
        PC_Group__c pc = PC_DataFactory.createPCGroup('test group', 'test group', cg.id, '1234', 3, 'Summary');

        System.assertEquals(pc.Id, fc.getDisPForumGroupId().id, 'Plancraft group is invalid');

        pc.Published__c = false;
        update pc;

        System.assertEquals(null, fc.getDisPForumGroupId(), 'Only groups with Published flag set to true should be visible');

        Test.stopTest();
    }
    
    @isTest static void getMPForumGroupId()
    {
        Test.startTest();

        PC_ForumController_CC fc = new PC_ForumController_CC();
        System.assertEquals(null, fc.getMPForumGroupId(), 'There should be no plancraft group');

        CollaborationGroup cg = PC_DataFactory.createChatterGroup('test1', 'test1');
        PC_Group__c pc = PC_DataFactory.createPCGroup('test group', 'test group', cg.id, '1234', 4, 'Summary');

        System.assertEquals(pc.Id, fc.getMPForumGroupId().id, 'Plancraft group is invalid');

        pc.Published__c = false;
        update pc;

        System.assertEquals(null, fc.getMPForumGroupId(), 'Only groups with Published flag set to true should be visible');

        Test.stopTest();
    }
    
    @isTest static void getIPForumGroupId()
    {
        Test.startTest();

        PC_ForumController_CC fc = new PC_ForumController_CC();
        System.assertEquals(null, fc.getIPForumGroupId(), 'There should be no plancraft group');

        CollaborationGroup cg = PC_DataFactory.createChatterGroup('test1', 'test1');
        PC_Group__c pc = PC_DataFactory.createPCGroup('test group', 'test group', cg.id, '1234', 6, 'Summary');

        System.assertEquals(pc.Id, fc.getIPForumGroupId().id, 'Plancraft group is invalid');

        pc.Published__c = false;
        update pc;

        System.assertEquals(null, fc.getIPForumGroupId(), 'Only groups with Published flag set to true should be visible');

        Test.stopTest();
    }
    

}