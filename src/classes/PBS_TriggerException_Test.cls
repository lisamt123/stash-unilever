@isTest
private class PBS_TriggerException_Test {
	@isTest static void testCodeMethods()
    {
        Test.startTest();

        // create object
        PBS_TriggerException e = new PBS_TriggerException('Code should be 0');
        // check if 0
        System.assertEquals(0, e.getCode(), 'Assert code is 0 failed');
        // set to 10
        System.assertEquals(10, e.setCode(10).getCode(), 'Expected code to be 10');
        // init with 5
        e = new PBS_TriggerException(5, 'Code should be 5');
        // assert is 5
        System.assertEquals(5, e.getCode(), 'Expected code to be 5');

        Test.stopTest();
    }
}