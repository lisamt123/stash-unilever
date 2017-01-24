/*
Class Name: CORE_CA_Delete_FullyScheduler_Test 
Author : Mindtree
Date: 27 sep 2016
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test class to cover 
1.CORE_CA_Delete_Fullyapproved_Scheduler

*/
@isTest
public with sharing class CORE_CA_Delete_FullyScheduler_Test {
    public static testMethod void myTestMethod() {
        CORE_Chatter_Approval__c setting = new CORE_Chatter_Approval__c();
        setting.Name = 'FullyApproved_deletePost_ChatterGroup';
        setting.ReminderAlertDays__c= 30;
        setting.Text_Value__c= '0F9180000000feD';
        insert setting;
        System.assert(setting!= null);
        
        CORE_Chatter_Approval__c setting1 = new CORE_Chatter_Approval__c();
        setting1.Name = 'FullyApproved_delete_Msg';
        setting1.Text_Value__c = 'The following PR/Expense has been deleted on XXX as they are fully approved:';
        insert setting1;
        System.assert(setting1!= null);
        
        CORE_Chatter_Approval__c setting2 = new CORE_Chatter_Approval__c();
        setting2.Name = 'AribaBatch';
        setting2.Text_Value__c = 'Yes';
        insert setting2;
        System.assert(setting2!= null); 
        
        CORE_Chatter_Approval__c setting3 = new CORE_Chatter_Approval__c();
        setting3.Name = 'GTESBatch';
        setting3.Text_Value__c = 'Yes';
        insert setting3;
        System.assert(setting3!= null);
        
        Test.StartTest();
        SchedulableContext sc;
        CORE_CA_Delete_Fullyapproved_Scheduler shedulerObj=new CORE_CA_Delete_Fullyapproved_Scheduler();
        shedulerObj.execute(sc);
        Test.StopTest();
    }
}