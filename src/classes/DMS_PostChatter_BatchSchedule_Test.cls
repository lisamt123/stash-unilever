@isTest
public class DMS_PostChatter_BatchSchedule_Test {
     
    public static String CRON_EXP = '0 0 1 * * ?'; 
    
    static testMethod void test() {
		Test.setMock(HttpCalloutMock.class, new DMS_WebServiceMockGenerator());
        
        Test.startTest();
      	DMS_PostChatter_BatchSchedule schedulePost = new DMS_PostChatter_BatchSchedule();
		Map<String, String> vMap = new Map<String, String>();
        vMap.put('00519000001B28n','DMS_ALTAMIRA');
        
		String jobId = system.schedule('First/Final Release date mail info'+System.now().millisecond(),CRON_EXP,schedulePost);

		//Get the information from the CronTrigger API object
      	CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

      	System.assertEquals(CRON_EXP, ct.CronExpression,'Expressions must match');
      	System.assertEquals(0, ct.TimesTriggered,'Cron should not be triggered');
        
        //valid values
        schedulePost.insertMentionedUser(DMS_GlobalConstants.ACCOUNT_SALES_CHANNEL);
		schedulePost.formatString(DMS_GlobalConstants.ACCOUNT_SALES_CHANNEL);
       
        //blank values
        schedulePost.insertMentionedUser('');
		schedulePost.formatString('');
        
        //blank values
        schedulePost.insertMentionedUser('null');
		schedulePost.formatString('null');
        
        //NULL
        schedulePost.insertMentionedUser(null);
		schedulePost.formatString(null);
        
        schedulePost.getMapUserGroupId(vMap);
        
        
	    Test.stopTest(); 	
    }
}