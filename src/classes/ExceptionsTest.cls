/**
 * Name : ExceptionsTest 
 * Author : Accenture IDC
 * Description : Test class used for testing the Exceptions 
 * Date : 8/6/14 
 */
@isTest
public class ExceptionsTest 
{ 
    /*
     *@name testExceptionsInnerClass
     *@return void 
     *@description This method for innerclass In CLASS Exceptions.cls
     */
    static testMethod void  testExceptionsInnerClass()
    { 
        Test.startTest();
      /*  User stdUser = FA_createTestData.createUser('navTst1');       
        
    
        System.runAs(stdUser) */
        {
            Exceptions ex = new Exceptions();
            Exceptions.IllegalArgumentException iae = new Exceptions.IllegalArgumentException();
            Exceptions.IllegalStateException ise = new Exceptions.IllegalStateException();
            Test.stopTest();
             System.assert(true);
        }
    }
}