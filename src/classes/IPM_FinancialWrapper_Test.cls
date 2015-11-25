/**
* @author       Cognizant
* @date         15/04/2015
* @description  This test class is to test the functionality of IPM_FinancialWrapper class 
*/
@isTest
public class IPM_FinancialWrapper_Test {
    
    /*******************************************************************************************************
    * @description testMethod to test the IPM_FinancialWrapper class
    */ 
    static testMethod void testIPM_FinancialWrapper()
    {
    	Test.startTest();
    	
        IPM_FinancialWrapper ipmfinwrp=new IPM_FinancialWrapper(); 
        system.assert(ipmfinwrp.y0ValueMarketShare ==0, 'y0ValueMarketShare is initialized as 0');
        system.assert(ipmfinwrp.y0Volume ==0, 'y0Volume is initialized as 0');
        system.assert(ipmfinwrp.y0VolumeTons ==0, 'y0VolumeTons is initialized as 0');
        system.assert(ipmfinwrp.y0Turnover ==0, 'y0Turnover is initialized as 0');
        system.assert(ipmfinwrp.y0GrossProfit ==0, 'y0GrossProfit is initialized as 0');
        system.assert(ipmfinwrp.y0Advertising ==0, 'y0Advertising is initialized as 0');
        system.assert(ipmfinwrp.y0Profit ==0, 'y0Profit is initialized as 0');
        system.assert(ipmfinwrp.y0GM ==0, 'y0GM is initialized as 0');
        system.assert(ipmfinwrp.y0AP ==0, 'y0AP is initialized as 0');
        system.assert(ipmfinwrp.y0PBO ==0, 'y0PBO is initialized as 0');
        
        Test.stopTest();
    }
}