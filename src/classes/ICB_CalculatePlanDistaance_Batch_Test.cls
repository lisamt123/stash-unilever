/**********************************************************************
Name: CalculatePlanDistaance_Batch_Test
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Class responsible for test: ICB_CalculatePlanDistaance_Batch.
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Antonio Raul 13/06/2016  Class creation  
***********************************************************************/
@IsTest
private class ICB_CalculatePlanDistaance_Batch_Test
{
	
    /*******************************************************************
    Purpose: Test Class Batchable ICB_CalculatePlanDistaance_Batch
    Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]  
    ********************************************************************/
    private static testMethod void calculatePlanDistaance_Batch_Test()
    {
        Id recordTypeId = ICB_RecordTypeMemory.getRecType(Label.ICB_SOBJECT_EVENT, Label.ICB_REC_TYPE_ICE_CREAM_VISIT);
        User user =  ICB_SobjectInstance_Test.insertUser('System Administrator', 'Test', 'User', 'tUser', 'testUser@email.com', 'testUser@email.com.unilever', 
                                                         'testUser', 'America/Los_Angeles', 'en_US', 'UTF-8', 'en_US');
        System.Test.startTest();
        
        ICB_SobjectInstance_Test.insertEvent('Call', System.now(), System.now(), user.Id, recordTypeId);
   		ICB_CalculatePlanDistaance_Batch batch = new ICB_CalculatePlanDistaance_Batch();
        Id batchId = Database.executeBatch(batch);
        System.assert(batchId != null);
        
        System.Test.stopTest();
        
    }
   
   
}