@isTest
private class PC_ForumController_Test
{

	@isTest static void getGroupList()
    {
        Test.startTest();

        PC_ForumController fc = new PC_ForumController();
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

        PC_ForumController fc = new PC_ForumController();
        System.assertEquals(null, fc.getPlancraftGroup(), 'There should be no plancraft group');

        CollaborationGroup cg = PC_DataFactory.createChatterGroup('test1', 'test1');
        PC_Group__c pc = PC_DataFactory.createPCGroup('test group', 'test group', cg.id, '1234', 0, 'Summary');

        System.assertEquals(pc.Id, fc.getPlancraftGroup().id, 'Plancraft group is invalid');

        pc.Published__c = false;
        update pc;

        System.assertEquals(null, fc.getPlancraftGroup(), 'Only groups with Published flag set to true should be visible');

        Test.stopTest();
    }

}