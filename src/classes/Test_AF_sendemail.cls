/**
* Test_AF_sendemail  : This Test class for  AF_sendemail  apex class
* @author 
*
*/

@isTest(SeeAlldata=false)
public class Test_AF_sendemail 
{ 

    Static testMethod void sndMail()
    {
        Test.startTest();
        
        Profile p=[Select Id from Profile where Name='Agency Fee Platform User'];       
        
        //Insert User 
        User u= new User(Alias = 'testsm', Email='standardusersm@unilever.com', 
        EmailEncodingKey='UTF-8', LastName='Test Usersm', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
        UserName='testusersm@test123321.com',AF_Brand__c='Test Brandsm',AF_Category__c='Test Beveragessm');
        insert u;     
           
        PermissionSet per = [SELECT Id,Name FROM PermissionSet where Name=:'AF_CMCO_Super_User'];
         
        PermissionSetAssignment pa = new PermissionSetAssignment();
        pa.PermissionSetId = per.id;
        pa.AssigneeId = u.id;
        insert pa;
        
        System.runAs(u)
        { 
            AF_TriggerDate__c  customList = new AF_TriggerDate__c ();
            customList.Date__c = system.today();
            insert customList;
            AF_schedule_sendemail.start();
            AF_sendemail obj = new AF_sendemail();
            Datetime dt = Datetime.now().addMinutes(1);
            String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
            String jobId = System.schedule('Sample_Heading', CRON_EXP, obj); 
        }
        Test.stopTest();
    }
}