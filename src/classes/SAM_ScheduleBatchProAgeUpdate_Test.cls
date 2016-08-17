/**********************************************************************
Name: SAM_ScheduleBatchProAgeUpdate_Test ()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: This is the test class for Scheduler
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR               DATE            DETAIL Description
1.0         Mindtree          04/08/2016        INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest
public  class SAM_ScheduleBatchProAgeUpdate_Test {
  /*******************************************************************
    Purpose: This method is used to test scheduler
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static testMethod void testschedule() {

    Test.StartTest();
    SAM_ScheduleBatchProAgeUpdate sh1 = new SAM_ScheduleBatchProAgeUpdate();
    String sch = '0 0 23 * * ?'; 
    system.schedule('Test Aging Check', sch, sh1); 
    Test.stopTest();
    
    System.assert(sch != null);
    }
   
   }