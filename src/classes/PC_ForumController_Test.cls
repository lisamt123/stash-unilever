@isTest
private class PC_ForumController_Test
{
    private static final string STR_TEST = 'test1';
    private static final string NO_PLAN_GROUP = 'There should be no plancraft group';
    private static final string INVALID_PLAN_GROUP = 'Plancraft group is invalid';
    private static final string PUBLISH_FLAG  = 'Only groups with Published flag set to true should be visible';
    
    @isTest static void getGroupList()
    {
        Test.startTest();

        PC_ForumController_CC fc = new PC_ForumController_CC();
        System.assertEquals(0, fc.getGroupList().size(), 'There should be no groups at all');

        CollaborationGroup cg = PC_DataFactory.createChatterGroup(STR_TEST, STR_TEST);
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
        System.assertEquals(null, fc.getPlancraftGroup(), NO_PLAN_GROUP);

        CollaborationGroup cg = PC_DataFactory.createChatterGroup(STR_TEST, STR_TEST);
        PC_Group__c pc = PC_DataFactory.createPCGroup('test group', 'test group', cg.id, '1234', 0, 'Summary');

        System.assertEquals(pc.Id, fc.getPlancraftGroup().id, INVALID_PLAN_GROUP);

        pc.Published__c = false;
        update pc;

        System.assertEquals(null, fc.getPlancraftGroup(), PUBLISH_FLAG);

        Test.stopTest();
    }
    
    @isTest static void getPBSForumGroupId()
    {
        Test.startTest();

        PC_ForumController_CC fc = new PC_ForumController_CC();
        System.assertEquals(null, fc.getPBSForumGroupId(), NO_PLAN_GROUP);

        CollaborationGroup cg = PC_DataFactory.createChatterGroup(STR_TEST, STR_TEST);
        PC_Group__c pc = PC_DataFactory.createPCGroup('test group', 'test group', cg.id, '1234', 5, 'Summary');

        System.assertEquals(pc.Id, fc.getPBSForumGroupId().id, INVALID_PLAN_GROUP);

        pc.Published__c = false;
        update pc;

        System.assertEquals(null, fc.getPBSForumGroupId(), PUBLISH_FLAG);

        Test.stopTest();
    }
    
     @isTest static void getDPForumGroupId()
    {
        Test.startTest();

        PC_ForumController_CC fc = new PC_ForumController_CC();
        System.assertEquals(null, fc.getDPForumGroupId(), NO_PLAN_GROUP);

        CollaborationGroup cg = PC_DataFactory.createChatterGroup(STR_TEST, STR_TEST);
        PC_Group__c pc = PC_DataFactory.createPCGroup('test group', 'test group', cg.id, '1234', 1, 'Summary');

        System.assertEquals(pc.Id, fc.getDPForumGroupId().id, INVALID_PLAN_GROUP);

        pc.Published__c = false;
        update pc;

        System.assertEquals(null, fc.getDPForumGroupId(), PUBLISH_FLAG);

        Test.stopTest();
    }
    
     @isTest static void getSPForumGroupId()
    {
        Test.startTest();

        PC_ForumController_CC fc = new PC_ForumController_CC();
        System.assertEquals(null, fc.getSPForumGroupId(), NO_PLAN_GROUP);

        CollaborationGroup cg = PC_DataFactory.createChatterGroup(STR_TEST, STR_TEST);
        PC_Group__c pc = PC_DataFactory.createPCGroup('test group', 'test group', cg.id, '1234', 2, 'Summary');

        System.assertEquals(pc.Id, fc.getSPForumGroupId().id, INVALID_PLAN_GROUP);

        pc.Published__c = false;
        update pc;

        System.assertEquals(null, fc.getSPForumGroupId(), PUBLISH_FLAG);

        Test.stopTest();
    }
    
     @isTest static void getDisPForumGroupId()
    {
        Test.startTest();

        PC_ForumController_CC fc = new PC_ForumController_CC();
        System.assertEquals(null, fc.getDisPForumGroupId(), NO_PLAN_GROUP);

        CollaborationGroup cg = PC_DataFactory.createChatterGroup(STR_TEST, STR_TEST);
        PC_Group__c pc = PC_DataFactory.createPCGroup('test group', 'test group', cg.id, '1234', 3, 'Summary');

        System.assertEquals(pc.Id, fc.getDisPForumGroupId().id, INVALID_PLAN_GROUP);

        pc.Published__c = false;
        update pc;

        System.assertEquals(null, fc.getDisPForumGroupId(), PUBLISH_FLAG);

        Test.stopTest();
    }
    
    @isTest static void getMPForumGroupId()
    {
        Test.startTest();

        PC_ForumController_CC fc = new PC_ForumController_CC();
        System.assertEquals(null, fc.getMPForumGroupId(), NO_PLAN_GROUP);

        CollaborationGroup cg = PC_DataFactory.createChatterGroup(STR_TEST, STR_TEST);
        PC_Group__c pc = PC_DataFactory.createPCGroup('test group', 'test group', cg.id, '1234', 4, 'Summary');

        System.assertEquals(pc.Id, fc.getMPForumGroupId().id, INVALID_PLAN_GROUP);

        pc.Published__c = false;
        update pc;

        System.assertEquals(null, fc.getMPForumGroupId(), PUBLISH_FLAG);

        Test.stopTest();
    }
    
    @isTest static void getIPForumGroupId()
    {
        Test.startTest();

        PC_ForumController_CC fc = new PC_ForumController_CC();
        System.assertEquals(null, fc.getIPForumGroupId(), NO_PLAN_GROUP);

        CollaborationGroup cg = PC_DataFactory.createChatterGroup(STR_TEST, STR_TEST);
        PC_Group__c pc = PC_DataFactory.createPCGroup('test group', 'test group', cg.id, '1234', 6, 'Summary');

        System.assertEquals(pc.Id, fc.getIPForumGroupId().id, INVALID_PLAN_GROUP);

        pc.Published__c = false;
        update pc;

        System.assertEquals(null, fc.getIPForumGroupId(), PUBLISH_FLAG);

        Test.stopTest();
    }
    

}