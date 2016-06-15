@isTest
public class DMS_PostChatter_Schedule_Test {
    static User usuario;
    public static String CRON_EXP = '0 0 1 * * ?'; 
    
    static testMethod void test() {
        Test.setMock(HttpCalloutMock.class, new DMS_WebServiceMockGenerator());
        
        Test.startTest();
        DMS_PostChatter_Schedule schedulePost = new DMS_PostChatter_Schedule(UserInfo.getSessionId());
        system.debug('UserInfo.getSessionId()'+ UserInfo.getSessionId());
        Map<String, String> vMap = new Map<String, String>();
        vMap.put('00519000001B28n','DMS_ALTAMIRA'); 
        
        String jobId = system.schedule('First/Final Release date mail info'+System.now().millisecond(),CRON_EXP,schedulePost);
        
        //Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        System.assertEquals(CRON_EXP, ct.CronExpression,'Expressions must match');
        System.assertEquals(0, ct.TimesTriggered,'Cron should not be triggered');
        
        Test.stopTest(); 	
    }
    
    static testMethod void test2(){
        DMS_PostChatter_Schedule schedulePost = new DMS_PostChatter_Schedule(UserInfo.getSessionId());
        Test.startTest();
        createUser();
        CollaborationGroup groupId;
        system.runAs(usuario){
            CollaborationGroup myGroup = new CollaborationGroup(
                Name = 'TestGroupName',	//Group name must be unique
                CollaborationType = 'Private',
                CanHaveGuests = false,
                IsArchived = false,
                IsAutoArchiveDisabled = true
            );
            insert myGroup;
            groupId = [SELECT id from CollaborationGroup where id =:myGroup.id limit 1];
        }
        system.debug('groupId:'+ groupId);
        User user = [SELECT id from User where id =: UserInfo.getUserId()];
        CollaborationGroupMember gm = new CollaborationGroupMember(collaborationGroupId  = groupId.id,MemberId = user.id);
        
        
        insert gm;
        system.debug('gm:'+ gm);
        String jobId = system.schedule('First/Final Release date mail info'+System.now().millisecond(),CRON_EXP,schedulePost);
        Test.stopTest(); 
    }
    //@Future
    static testMethod void createUser(){
        
        usuario = DMS_SObjectInstance_Test.createUserRunTest2();
    }
}