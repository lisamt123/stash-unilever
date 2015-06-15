trigger AF_AfterInsertUpdateOOPSEstimate on AF_Agency_Estimate__c (after insert, after update) 
{
AF_RecursiveTriggerHelper.setAlreadyModified(); //set to stop the include
}