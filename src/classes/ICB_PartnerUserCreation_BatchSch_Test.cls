/**********************************************************************
Name: ICB_PartnerUserCreation_BatchSch_Test
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Class responsible for test: ICB_PartnerUserCreation_BatchSchedule.
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Antonio Raul 25/08/2016  Class creation  
***********************************************************************/
@IsTest
public class ICB_PartnerUserCreation_BatchSch_Test 
{
    private static Account acc;
    private static Contact contactNew;
    private static Contact contactOld;
    
    Static
    {
        acc = new Account();
        contactNew = new Contact();
        contactOld = new Contact();
    }
    
    /********************************************************************
    Purpose: Test the Schedulable class ICB_PartnerUserCreation_BatchSchedule
    Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]  
    ********************************************************************/
    static testMethod void ICB_PartnerUserCreation_BatchSch_Test()
    {
        String cronExp = '0 0 0 15 12 ? 2050';
        createInstances();
        System.Test.startTest();
        
        String jobId = System.schedule('ICB_PartnerUserCreation_BatchSchedule', cronExp, new ICB_PartnerUserCreation_BatchSchedule());
        
        CronTrigger cronTrigger = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id =: jobId];
        
        System.assertEquals(jobId, cronTrigger.Id);
        System.assertEquals(cronExp, cronTrigger.CronExpression);
        System.assertEquals(0, cronTrigger.TimesTriggered);
        System.assertEquals('2050-12-15 00:00:00', String.valueOf(CronTrigger.NextFireTime));
        
        System.Test.stopTest();
    } 
    /*******************************************************************
    Purpose: Method to instance all objects used for tests
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    private static void createInstances()
    {
        acc = ICB_SobjectInstance_SP2_Test.insertAccount('Catanduva Distribuidora', ICB_RecordTypeMemory.getRecType('Account', 'Standard'));
        contactNew = ICB_SobjectInstance_SP2_Test.insertContact('Test New', ICB_RecordTypeMemory.getRecType(Label.ICB_SOBJECT_CONTACT, 'ICB_Operator'), acc.Id,'Operator');
        contactNew.Email = 'teste.new@unilever.com';
        contactNew.FirstName = 'Test New';
        Database.update(contactNew);
        contactOld = ICB_SobjectInstance_SP2_Test.insertContact('Test Old', ICB_RecordTypeMemory.getRecType(Label.ICB_SOBJECT_CONTACT, 'ICB_Operator'), acc.Id,'Operator');
        contactOld.Email = 'teste.old@unilever.com';
        contactOld.FirstName = 'Test Old';
        Database.update(contactOld);
        ICB_SobjectInstance_SP2_Test.insertContactTypes('Permission_Salesman','ICB Mobile Channel Salesman');
        ICB_SobjectInstance_SP2_Test.insertContactTypes('Permission_Operator','ICB Mobile Channel Operator PCL');
        ICB_SobjectInstance_SP2_Test.insertContactTypes('Type_Salesman','Ice Cream Salesman');
        ICB_SobjectInstance_SP2_Test.insertContactTypes('Type_Operator','Operator');
        ICB_SobjectInstance_SP2_Test.insertContactTypes('User_Email','@operadorkibon.com');
        ICB_SobjectInstance_SP2_Test.insertContactTypes('Profile_Community','Partner Community Login Basic');
        ICB_SobjectInstance_SP2_Test.insertContactTypes('RecordType','Ice Cream');
        
    }
}