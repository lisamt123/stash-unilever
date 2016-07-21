/**
 * Test_AF_CloseAndRefresh: This Test class for AF_CloseAndRefresh apex class
 * @author 
 *
 */
 
 @isTest(SeeAlldata=false)
public class Test_AF_CloseAndRefresh
{ 

    Static testMethod void closeandRefresh()
    {
    Test.startTest();
     
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     
     //Insert User 
     User u= new User(Alias = 'testcr', Email='standardusercr@unilever.com', 
      EmailEncodingKey='UTF-8', LastName='Test Usercr', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Agency',isActive=true, 
      UserName='testusercr@test123321.com',AF_Brand__c='Test Brandcr',AF_Category__c='Test Beveragescr');
     insert u;        
     
     System.runAs(u)
     { 
        ApexPages.currentPage().getParameters().put('IsError','false');      
        AF_CloseAndRefresh cloRef=new AF_CloseAndRefresh();
        ApexPages.currentPage().getParameters().put('IsError','true');     
        ApexPages.currentPage().getParameters().put('ErrorMessage','error');        
        AF_CloseAndRefresh cloRef1=new AF_CloseAndRefresh();
     }
    Test.stopTest();
    }

}