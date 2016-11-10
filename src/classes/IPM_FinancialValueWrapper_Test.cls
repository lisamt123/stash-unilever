/*******************************************************
 * @Description: Test class for IPM_FinancialValueWrapper 
 * @Author:Cognizant
 * @Date:05/08/2015
 * *****************************************************/

@isTest
public class IPM_FinancialValueWrapper_Test {
   
   /*************************************
   * @Description: Test Method invocation
   ***************************************/ 
   static testMethod void testFinancialValueWrapper()
     {
         
        //Insert User 
        user plUser = IPM_TestFactory_Helper.createUser(false);
        insert plUser; 
        List<User>userList=[SELECT lastName FROM user WHERE id=:plUser.id LIMIT 1];
        System.AssertEquals(userList[0].lastName, plUser.lastName,'user lastName is:'+userList[0].lastName);//positive test
        
        test.startTest();
        system.runAs(plUser){
	     IPM_Financial__c fin = new IPM_Financial__c();
	     String finExtIdKey= 'Y1';
	     String currenttab = 'myView';
             IPM_FinancialValueWrapper  ifvw=new IPM_FinancialValueWrapper (2,2.0,2.0,2,finExtIdKey,fin,currenttab);
             system.assertEquals(ifvw.index,2, 'Index Mismatch');//positive test
            
             new IPM_FinancialValueWrapper (2, 2.0, 0.0, 2,null,null,null); 
             system.assertEquals(ifvw.difference,2.0, 'Difference Mismatch');//positive test
        }
        test.stopTest();
     }
}