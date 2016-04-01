/**
 * This is a test class that tests Group handler implementation
 *
 * @author Krzysztof Wasniowski <k.wasniowski@polsource.com>
 */
@isTest
private class PC_GroupHandler_Test
{
	@isTest static void testInsertThrowsErrorOnDuplicateOrder()
    {
	   	Test.startTest();

        PC_Group__c pc1;

        System.assertEquals(0, getGroupCount(), 'There should be no groups');

        pc1 = PC_DataFactory.createPCGroup('test', 'test', null, null, 0, null);
        System.assertEquals(1, getGroupCount(), 'There should be 1 group');

        // cannot add another with 0 order
        try {
            PC_DataFactory.createPCGroup('test 2', 'test 2', null, null, 0, null);
            System.assert(false, 'Expected exception');
        } catch (System.DMLException e) {
            System.assertEquals(1, e.getNumDml(), 'Expected 1 error');
            System.assertEquals('Order__c', e.getDmlFieldNames(0).get(0), 'Expected error on Order__c object');
        }

        System.assertEquals(1, getGroupCount(), 'There should be 1 group');

        pc1.published__c = false;
        update pc1;

        // try same insert again
        PC_DataFactory.createPCGroup('test 2', 'test 2', null, null, 0, null);

        System.assertEquals(2, getGroupCount(), 'There should be 2 groups');

        Test.stopTest();
	}

	@isTest static void testUpdateThrowsErrorOnDuplicateOrder()
    {
		Test.startTest();

        System.assertEquals(0, getGroupCount(), 'There should be no groups');

        PC_Group__c pc1 = PC_DataFactory.createPCGroup('test', 'test', null, null, 0, null);
        PC_Group__c pc2 = PC_DataFactory.createPCGroup('test 2', 'test 2', null, null, 1, null);

        System.assertEquals(2, getGroupCount(), 'There should be 2 groups');

        // try assigning same number to pc1 as pc2 has
        try {
            pc1.Order__c = pc2.Order__c;
            update pc1;
            System.assert(false, 'Expected exception');
        } catch (System.DMLException e) {
            System.assertEquals(1, e.getNumDml(), 'Expected 1 error');
            System.assertEquals('Order__c', e.getDmlFieldNames(0).get(0), 'Expected error on Order__c object');
        }

        // change order to duplicate but inactivate the group
        pc1.Order__c = pc2.Order__c;
        pc1.published__c = false;
        update pc1;

        // activation should fail
        try {
            pc1.published__c = true;
            update pc1;
            System.assert(false, 'Expected exception');
        } catch (System.DMLException e) {
            System.assertEquals(1, e.getNumDml(), 'Expected 1 error');
            System.assertEquals('Order__c', e.getDmlFieldNames(0).get(0), 'Expected error on Order__c object');
        }

        delete pc2;

        pc1.published__c = true;
        update pc1;

        System.assertEquals(true, pc1.published__c, 'Group should be published');

        Test.stopTest();
	}
    /**
     * Returns number of groups defined in PC_Group__c object
     *
     * @return Integer
     */
    private static Integer getGroupCount()
    {
        return Database.countQuery('SELECT COUNT() FROM PC_Group__c');
    }
}