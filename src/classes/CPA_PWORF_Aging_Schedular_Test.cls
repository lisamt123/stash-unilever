/**********************************************************************
Name: CPA_PWORF_Aging_Schedular_Test()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This is the util class of rest of the test classes.
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR       DATE            DETAIL Description
1.0         Name      19/04/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest
private class CPA_PWORF_Aging_Schedular_Test {
    /*******************************************************************
    Purpose: This method is used to cover Schedular
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
 ********************************************************************/
	public static testMethod void testschedule() {
		Test.StartTest();
		CPA_ScheduleBatchProrfAgeUpdate sh1 = new CPA_ScheduleBatchProrfAgeUpdate();
		String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1); 
		Test.stopTest(); 
	}
}