@isTest
public class FA_Test_SendPWTMail
{
    private static User runningUser(String aliasId, String profileName)
    {
        Id profId = [SELECT Id FROM Profile WHERE Name=: profileName].Id;
        User userData = new User(FirstName='Test', LastName='User', Alias=aliasId, IsActive=True, Email='rejeesh.raghavan@accenture.com',
                                 ProfileId=profId, Username=aliasId+'@test.com', EmailEncodingKey='UTF-8', CommunityNickname='Test12345',
                                 LanguageLocaleKey='en_US', LocaleSidKey='en_US', TimeZoneSidKey='GMT');
        insert userData;
        return userData;
    }
    
    static testMethod void testFA_SendPWTMail()
    {
        User runUser = runningUser('mUsr1','System Administrator');
        Test.startTest();
        System.runAs(runUser)
        {
            FA_Test_SendPWTMail a = new FA_Test_SendPWTMail();
            String taskName = 'Test Task';
            String dueDate = datetime.now().format('MMMM d,  yyyy');
            String courseName = 'Test Course';
            FA_Config_Settings__c liPWTReminder =  FA_Config_Settings__c.getValues('FA_PWTReminderTemplateId'); 
            //String templateId = liPWTReminder.FA_Value__c;
           // System.debug('templateId---'+templateId);
            Id usrId = UserInfo.getUserId();
            //a.sendSingleMail(Id usrID, String usrName, String taskName, String dueDate, String courseName, String templateId);
            //a.sendSingleMail(usrId, 'mUsr1', taskName, dueDate, courseName, templateId);
          FA_SendPWTMail.sendSingleMail(runUser.Id,'mUsr1', taskName, dueDate, courseName);
          FA_SendPWTMail.sendSingleMail(runUser.Id,'mUsr1','' ,'' ,'' );
        }
        Test.stopTest();


   }
}