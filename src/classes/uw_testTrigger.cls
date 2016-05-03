@isTest
private class uw_testTrigger {
	static testMethod void triggerTest() {  
		
		ContentVersion cv = new ContentVersion();
		cv.Description='test';
		cv.Title='test';
		cv.PathOnClient='test';
		Blob b=Blob.valueOf('test');
		cv.VersionData=b;
		insert cv;	
		
		cv.Title='test2';
		update cv;
		
		System.assertEquals (null, cv.CMS_ID__c);
		
			
	}
}