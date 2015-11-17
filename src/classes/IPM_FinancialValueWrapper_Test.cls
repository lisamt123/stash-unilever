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
   static testMethod void dotest()
     {
         IPM_FinancialValueWrapper  ifvw=new IPM_FinancialValueWrapper (2,2.0,2.0);
         system.assertEquals(ifvw.index,2);
        
         new IPM_FinancialValueWrapper (2, 2.0, 0.0, 2); 
         system.assertEquals(ifvw.difference,2.0);
     }
}