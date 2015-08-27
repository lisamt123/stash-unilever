/**
 * Test_AF_Sendemail_categoryfinance : This Test class for  AF_Sendemail_categoryfinance apex class
 * @author 
 *
 */
 
 @isTest(SeeAlldata=false)
public class Test_AF_Sendemail_categoryfinance
{ 

    Static testMethod void sendMailCatFinance()
    {
    Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testsm', Email='standardusersm@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Usersm', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testusersm@test123321.com',AF_Brand__c='Test Brandsm',AF_Category__c='Test Beveragessm');
     insert u;        
     
     System.runAs(u)
     { 
       AF_Sendemail_categoryfinance sendMailCatFin=new AF_Sendemail_categoryfinance();
       //sendMailCatFin.send();
       sendMailCatFin.closePopup();
     }
    Test.stopTest();
    }
}