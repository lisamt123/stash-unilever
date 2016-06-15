@isTest
public class DMS_PostChatter_Schedule_Test {
    static User usuario;
    public static String CRON_EXP = '0 0 1 * * ?'; 
    
    static testMethod void test() {
        Test.setMock(HttpCalloutMock.class, new DMS_WebServiceMockGenerator());
        DMS_PostChatter_Schedule schedulePost;
        Test.startTest();
         User user = [SELECT id from User where id =: UserInfo.getUserId()];
        system.runAs(user){
         schedulePost = new DMS_PostChatter_Schedule(UserInfo.getSessionId());
        }
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
    /*
    static testMethod void test2(){
       DMS_PostChatter_Schedule schedulePost;
        Test.startTest();
        system.debug('CHEGOU AQUI');
        createUser();
        system.debug('PASSOU AQUI');
        SYSTEM.debug('MOSTRAR O USER: ' + usuario);
        CollaborationGroup groupId;
        system.runAs(usuario){
            
            system.debug('schedulePost:'+ schedulePost);
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
        system.runAs(user){
            schedulePost = new DMS_PostChatter_Schedule(userInfo.getSessionId());
            CollaborationGroupMember gm = new CollaborationGroupMember(collaborationGroupId  = groupId.id,MemberId = user.id);
            insert gm;
            system.debug('gm:'+ gm);
        }

        String jobId = system.schedule('First/Final Release date mail info'+System.now().millisecond(),CRON_EXP,schedulePost);
        Test.stopTest(); 
    }
    //@Future
    static testMethod void createUser(){
       SYSTEM.debug('ENTROU NO CREATEUSER');
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
      
        usuario = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName= system.now().day() + 'standarduser@testorg.com');
			database.insert(usuario);
        
        System.runAs(usuario) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            System.debug('Current Profile: ' + UserInfo.getSessionId()); 
        }
    }
*/
}