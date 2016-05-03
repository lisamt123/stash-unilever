@isTest
public with sharing class CoreNTDeleteMPPDocsBatchTest {
	public static testMethod void myTestMethod() {
		Database.BatchableContext bc;
    	CoreNTDeleteMPPDocsBatch batchObj = new CoreNTDeleteMPPDocsBatch();
    	batchObj.start(bc);
    	
    	Test.startTest(); 
    	List<sObject> scope = new List<sObject>(); 
    	
    	batchObj.execute(bc,scope);
    	batchObj.finish(bc);
    	Test.stopTest();
	}
}