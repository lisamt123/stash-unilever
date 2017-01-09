/**
* Name:        -   FAU_GroupCreationPIIClass_Test
* @description -   This is the test class for FAU_GroupCreationPIIClass Class.
* @Author      -   Tejasvi Gujjula     
*/

@isTest
public with sharing class FAU_GroupCreationPIIClass_Test {
    
    static testMethod void myUnitTest() {
        
       //with Participant to chattergroups
        FAU_PII_Table__c testpiitable=new FAU_PII_Table__c(Name='Teja Test PIITable1',CurrencyIsoCode='EUR');
        insert testpiitable;
        
         RecordType Ul2020recordprg = [SELECT Id,Name FROM RecordType WHERE sObjectType = 'FAU_Program__c' AND Name = 'UL2020' LIMIT 1];
        FAU_Program__c testprogram=new   FAU_Program__c(RecordTypeId=Ul2020recordprg.Id,Name='Tejaprg',FAU_Program_Type__c='UL2020',FAU_Status__c='Active',FAU_Primary_Location__c='London',FAU_Program_Fee__c=2000,CurrencyIsoCode='EUR',FAU_Start_Date__c=Date.today()+6,FAU_Invitation_ResponseDeadline__c=Date.today()+2,FAU_Biography_Deadline__c=Date.today());
        insert testprogram;
        
        FAU_PII__c testpii=new  FAU_PII__c(Name='testpii1teja',PII_Table__c=testpiitable.id,FAU_Program__c=testprogram.Id,CurrencyIsoCode='EUR');
        insert testpii;
        
        
        User testuser= new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'Unilever - Salesforce MultiApp Standard'].Id,LastName = 'last',Email = 'test1@abc.com',Username = 'test1@abc.com' + System.currentTimeMillis(),CompanyName = 'TEST',Title = 'title',Alias = 'alias',TimeZoneSidKey = 'America/Los_Angeles',EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US');
        insert testuser;
        
        
        User chattertestuser= new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'Chatter Only User'].Id,LastName = 'last',Email = 'test2@abc.com',Username = 'test2@abc.com' + System.currentTimeMillis(),CompanyName = 'TEST2',Title = 'title2',Alias = 'alias2',TimeZoneSidKey = 'America/Los_Angeles',EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US');
        insert chattertestuser;
        
        
        RecordType Ul2020record = [SELECT Id,Name FROM RecordType WHERE sObjectType = 'FAU_Participant__c' AND Name = 'UL2020 Participant' LIMIT 1];
        FAU_Participant__c testparticipant= new FAU_Participant__c( FAU_PII__c=testpii.Id,FAU_Program_Wave__c=testprogram.Id,FAU_Invite_State__c='Not yet Invited',FAU_User__c=testuser.Id,RecordtypeId=Ul2020record .Id,CurrencyIsoCode='EUR');
        insert testparticipant;
        testparticipant.FAU_Invite_State__c='Accepted';
        update testparticipant;
        
        FAU_Sponsor__c testsponsor=new FAU_Sponsor__c(Sponsor__c=chattertestuser.Id, PII__c=testpii.Id,CurrencyIsoCode='EUR',FAU_Program__c=testprogram.Id);
        insert testsponsor;
        
        FAU_Participant__c testparticipantlist=[SELECT Id FROM FAU_Participant__c  WHERE Id = :testparticipant.Id ALL ROWS]; 
        delete testparticipantlist;
        
        FAU_Sponsor__c testsponsorlist=[SELECT Id FROM FAU_Sponsor__c WHERE Id = :testsponsor.Id ALL ROWS];
        delete testsponsorlist;
        
    }
}