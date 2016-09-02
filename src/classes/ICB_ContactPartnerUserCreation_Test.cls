/**********************************************************************
Name: ICB_ContactPartnerUserCreation_Test
Copyright © 2016 Unilever
======================================================
Purpose: Class to test the class: ICB_ContactPartnerUserCreation.

History 
VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	Antonio Raul  		25/08/2016  Class Creation
***********************************************************************/
@IsTest
public class ICB_ContactPartnerUserCreation_Test 
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
    
    /*******************************************************************
    Purpose: Test the success scenario
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    public static testMethod void successScenario_Test()
    {
        createInstances();
        System.Test.startTest();
        ICB_ContactPartnerUserCreation contactUser = new ICB_ContactPartnerUserCreation();
        System.assertNotEquals(null,ICB_ContactPartnerUserCreation.getInstance());
        contactUser.createNewUser(new List<Contact>{contactOld});
        //contactUser.updateUser(new List<Contact>{contactOld}, new List<Contact>{contactNew});
        contactUser.userCreation();
        System.assertNotEquals(null, [Select Id From User where ContactId =: contactOld.Id]);
        System.Test.stopTest();
    }
    /*******************************************************************
    Purpose: Test the error scenario
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    public static testMethod void errorScenario_Test()
    {
        createInstances();
        System.Test.startTest();
        ICB_ContactPartnerUserCreation contactUser = new ICB_ContactPartnerUserCreation();
        contactUser.createNewUser(null);
       // contactUser.updateUser(null, null);
        List<User> listUser = [Select Id From User Where ContactId =:contactOld.Id];
        System.assertEquals(0, listUser.size());
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
        contactNew = ICB_SobjectInstance_SP2_Test.insertContact('Test New', ICB_RecordTypeMemory.getRecType(Label.ICB_SOBJECT_CONTACT, 'ICB_Operator'), acc.Id,'Operator', 'teste.new@unilever.com');
        //contactNew.Email = 'teste.new@unilever.com';
        contactNew.FirstName = 'Test New';
        Database.update(contactNew);
        contactOld = ICB_SobjectInstance_SP2_Test.insertContact('Test Old', ICB_RecordTypeMemory.getRecType(Label.ICB_SOBJECT_CONTACT, 'ICB_Operator'), acc.Id,'Operator', 'teste.old@unilever.com');
        //contactOld.Email = 'teste.old@unilever.com';
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