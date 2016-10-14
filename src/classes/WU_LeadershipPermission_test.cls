/*************************************************************
*@Author :          Cognizant
*@Date :            December 2015
*@Description :     To test WU_SetWarehousePOCHandler, WU_TestFactory_Helper class, WU_SerWarehousePOC Trogger
*************************************************************/

@isTest
public class WU_LeadershipPermission_test{

static testMethod void  WU_LeadershipPermission(){
      Test.startTest();
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     //Insert User 
   User u= new User(Alias = 'testarc', Email='standarduserarc@unilever.com', 
      ProfileId = p.Id, WU_Permission_set_Check__c=true,LastName='Test Userarc',
      TimeZoneSidKey='Europe/London',LocaleSidKey='en_US',EmailEncodingKey='UTF-8',
      isActive=true,LanguageLocaleKey='en_US',
      UserName='testuserarc@test123321.com');
      insert u;        
      system.assert(u!=null,true);
     System.runAs(u)
     { 
        ApexPages.StandardController sc = new ApexPages.StandardController(u);
        WU_LeadershipPermission Leader= new WU_LeadershipPermission(sc);
        Leader.redirectPage();
        test.stopTest();
     }
   }
   static testMethod void  WU_LeadershipPermission2(){
      Test.startTest();
     Profile p=[Select Id from Profile where Name='System Administrator'];       
     //Insert User 
   User u= new User(Alias = 'testarc', Email='standarduserarc@unilever.com', 
      ProfileId = p.Id, WU_Permission_set_Check__c=false,LastName='Test Userarc',
      TimeZoneSidKey='Europe/London',LocaleSidKey='en_US',EmailEncodingKey='UTF-8',
      isActive=true,LanguageLocaleKey='en_US',
      UserName='testuserarc@test123321.com');
      insert u;        
      system.assert(u!=null,true);
     System.runAs(u)
     { 
        ApexPages.StandardController sc = new ApexPages.StandardController(u);
        WU_LeadershipPermission Leader= new WU_LeadershipPermission(sc);
        Leader.redirectPage();
        test.stopTest();
     }
   }
}