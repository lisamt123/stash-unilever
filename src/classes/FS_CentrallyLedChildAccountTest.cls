/**********************************************************************
Purpose: Test class for FS_CentrallyLedChildAccount_Picklist.
History :
VERSION  AUTHOR         DATE          DETAIL Description
1.0     Accenture     19/July/2016     Created

***********************************************************************/
@isTest
private class FS_CentrallyLedChildAccountTest {
    //Set up Test Data for unit test    
    //@testSetup static void setupTestData()
    static testMethod void OpportunityTriggerUnitTest(){
       FS_UtilTestDataSetup testData=new FS_UtilTestDataSetup();
       User testUser=testData.createTestUser();        
        system.runAs(testUser){
            // Set up the Account records
            List<Account> accounts = new List<Account>();
            RecordType rt=[select id,name from RecordType where SObjectType='Account'and Name='Operator'];
            
            //accounts.add(new Account(Name = 'FS Test Acc1',recordtypeid=rt.Id));
            Account acc1 = new Account();
            acc1.name = 'FS Test Acc1';
            acc1.RecordTypeId = rt.Id;
            accounts.add(acc1);
            
            Account acc2 = new Account();
            acc2.name = 'FS Test Acc2';
            acc2.RecordTypeId = rt.Id;
            acc2.ParentId = acc1.id;
            accounts.add(acc2);
            
            Account acc3 = new Account();
            acc3.name = 'FS Test Acc3';
            acc3.RecordTypeId = rt.Id;
            acc3.ParentId = acc2.id;
            accounts.add(acc3);
            
            Insert accounts;
            List<String> stringList = new List<String>{acc1.id,acc2.id,acc3.id}; 
            
            //Set up Account Plan records
            FS_Account_Plan__c accplan = new FS_Account_Plan__c();               
            accplan.FS_Customer__c = acc1.id;
            accplan.CurrencyIsoCode = 'EUR';
            //insert accplan;
            //Set up Task records
            Task tsk = new Task();
            tsk.OwnerId = testUser.id;
            tsk.Subject = 'Call';
            tsk.CurrencyIsoCode = 'EUR';
            tsk.FS_Task_Type__c= 'Centrally Led';
            tsk.Status = 'In Progress';
            tsk.Priority = 'high';
            tsk.WhatId = accplan.id;
            insert tsk;
            
            
            ApexPages.StandardController sc = new ApexPages.StandardController(tsk);
            FS_CentrallyLedChildAccount_CX fscc = new FS_CentrallyLedChildAccount_CX(sc);
            List<SelectOption> tf = fscc.ChildAccountList;
            List<Task> tf1 = fscc.ChildAccountTaskList;
            //List<String> str1 = fscc.CentrallyLedList;
            fscc.CentrallyLedList = stringList;            
            fscc.CreateTask();
            fscc.CreateTask();            
            system.assertEquals((task)sc.getRecord(), tsk); 
            tf.clear();
            tf1.clear();
            //str1.clear();
            //fscc.clear();
            stringList.clear();
        }      
    }   
}