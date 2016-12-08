/**********************************************************************
Purpose: Test class for FS_CHDUtility.
History :
VERSION           AUTHOR              DATE                         DETAIL Description
1.0              Accenture        2/December/2016                       Created
***********************************************************************/
@isTest
private class FS_CHDUtilityTest {
   private static testMethod void CHDTest (){
       FS_UtilTestDataSetup testData=new FS_UtilTestDataSetup();
       User testUser=testData.createTestUser();        
       system.runAs(testUser){
           FS_CHD_GFCCode__c cust= new FS_CHD_GFCCode__c(Name='3380',Segment__c='Club, Cash & Carry');
           insert cust;
               FS_CHD_GFCCode__c cust1= new FS_CHD_GFCCode__c();
               List<Account> acclist = new  List<Account>() ;
               List<Account> accounts = new List<Account>();
               Account acclistTemp1 = new Account();
               List<string> strList = new List<String>();
               RecordType rt=[select id,name from RecordType where SObjectType='Account'and Name='Operator'];
               Test.startTest(); 
                  acclist= new List<Account>();
                  Account acc1 = new Account();
                  acc1.name = 'FS Test Acc1';
                  acc1.RecordTypeId = rt.Id;
                  acc1.SubSegment__c='3380. Stores';
                  acclist.add(acc1);
                  insert acclist;
               Test.stopTest();
                     
          }
          }
          private static testMethod void CHDTesttwo (){
          FS_UtilTestDataSetup testData=new FS_UtilTestDataSetup();
          User testUser=testData.createTestUser();        
       system.runAs(testUser){
           FS_CHD_GFCCode__c cust= new FS_CHD_GFCCode__c(Name='3380',Segment__c='Club, Cash & Carry');
           insert cust;
           RecordType rt=[select id,name from RecordType where SObjectType='Account'and Name='Operator'];
          List<Account> newacclist = new  List<Account>() ;
           Account acc2 = new Account();
                  acc2 .name = 'FS Test Acc1';
                  acc2 .RecordTypeId = rt.Id;
                  acc2 .SubSegment__c='3380. Stores';
                  newacclist.add(acc2 );
                  insert newacclist;
          FS_CHDUtility.getsegment(newacclist );
          }
          }
          }