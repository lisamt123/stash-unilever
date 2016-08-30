/**********************************************************************
Purpose: Test class for FS_CentrallyLedChildAccount_Picklist.
History :
VERSION  AUTHOR         DATE          DETAIL Description
1.0     Accenture     19/July/2016     Created

***********************************************************************/
@isTest
private class FS_CentrallyLedChildAccount_Pic_Test {
    //Set up Test Data for unit test    
    //@testSetup static void setupTestData()
    static testMethod void OpportunityTriggerUnitTest(){
        String profile='Unilever - Salesforce MultiApp Standard';
        String permissionset='FS_Sales_Rep';        
        Profile p = [SELECT Id FROM Profile WHERE Name=:profile];
        Userrole role=[SELECT Id FROM UserRole WHERE Name = 'FS 10100 Sales Rep'];
        User SalesRepUser1 = new User(Alias = 'newUser', Email='newuser1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId=role.id,
        TimeZoneSidKey='America/Los_Angeles', UserName='newuseropphelper1@testorg.com');
        insert SalesRepUser1;
        User SalesRepUser = new User(Alias = 'newUser', Email='newuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId=role.id,ManagerId = SalesRepUser1.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='newuseropphelper@testorg.com');
        insert SalesRepUser;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =:permissionset];
        PermissionSetAssignment psetassignment = new PermissionSetAssignment();
        psetassignment.AssigneeId = SalesRepUser.Id;
        psetassignment.PermissionSetId = ps.Id;
        insert psetassignment;
        
        system.runAs(SalesRepUser){
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
            
            Id rectypeId = Schema.SObjectType.FS_Account_Plan__c.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
            
            //Set up Account Plan records
            FS_Account_Plan__c accplan = new FS_Account_Plan__c();
                //accplan.add(new FS_Account_Plan__c(FS_Customer__c = acc1.id,CurrencyIsoCode = 'EUR'));
            accplan.FS_Customer__c = acc1.id;
            accplan.CurrencyIsoCode = 'EUR';
            //insert accplan;
            //Set up Task records
            Task tsk = new Task();
            tsk.OwnerId = SalesRepUser.id;
            tsk.Subject = 'Call';
            tsk.CurrencyIsoCode = 'EUR';
            tsk.FS_Task_Type__c= 'Centrally Led';
            tsk.Status = 'In Progress';
            tsk.Priority = 'high';
            tsk.WhatId = accplan.id;
            insert tsk;
            
            
            ApexPages.StandardController sc = new ApexPages.StandardController(tsk);
            FS_CentrallyLedChildAccount_Picklist_CX fscc = new FS_CentrallyLedChildAccount_Picklist_CX(sc);
            List<SelectOption> tf = fscc.ChildAccountList;
            List<Task> tf1 = fscc.ChildAccountTaskList;
            List<String> str1 = fscc.CentrallyLedList;
            fscc.CentrallyLedList = stringList;
            //FS_CentrallyLedChildAccount_Picklist fscc1 = new FS_CentrallyLedChildAccount_Picklist();
            //List<SelectOption> tf = new List<SelectOption>();//FS_CentrallyLedChildAccount_Picklist.getChildAccountList();
            //FS_CentrallyLedChildAccount_Picklist.ChildAccountList=tf;
            pagereference page1 = fscc.CreateTask();
            pagereference page2 = fscc.CreateTask();
        }   
        
    }
    
    
}