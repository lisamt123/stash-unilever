@isTest(seealldata=true)
public class CORE_TEST_Batch_Deactivate_External_User{

public static testMethod void myTestMethodForBatch() {
   profile p=[select id from profile where name=:'Chatter External User']; 
   User obj_user  = new User (username='Core_Chatter_user_admin_test1@admintest.com',IsActive=true,City='Bangalore',Function__c='Information Technology', Alias='user1',
                                 timezonesidkey='America/Los_Angeles',ProfileId=p.id,Email='Core_Chatter_user_admin_test1@admintest.com',FederationIdentifier='feed1',
                                 FirstName='user1', LastName='user2',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
   insert obj_user; 
   System.assert(obj_user != null);
   
   List<User> scope  = [SELECT username,IsActive,City,Function__c,Alias,timezonesidkey,ProfileId,Email,
                        FederationIdentifier,FirstName,LastName,emailencodingkey,languagelocalekey,localesidkey
                        FROM User where Username='Core_Chatter_user_admin_test1@admintest.com'];
   
   Database.BatchableContext bc;
   CORE_Batch_Deactivate_External_User batchObj = new CORE_Batch_Deactivate_External_User ();
   batchObj.start(bc);                                               
   Test.startTest(); 
       List<User> lstUser= scope;
       batchObj.execute(bc,scope);
       batchObj.finish(bc);
   Test.stopTest();
}

public static testMethod void myTestMethodForScheduler() {        
         test.starttest();
         CORE_Batch_Deactivate_Ext_User_Scheduler myClass = new CORE_Batch_Deactivate_Ext_User_Scheduler();
         System.assert(myClass != null);
         test.stopTest();
    }
}