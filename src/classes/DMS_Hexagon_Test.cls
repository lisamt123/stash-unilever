/**********************************************************************
Name: DMS_Hexagon_Test

Purpose: 
Class used to test the controller DMS_Hexagon_CC

History 

VERSION		AUTHOR			 DATE 	 	 Description
1.0		DIMITRI M. SANTANA	30/05/2016	INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class DMS_Hexagon_Test 
{
    
    public static Account accountDistributor = DMS_SObjectInstance_Test.createAccount('account Test','DMS_test_test', null, null, DMS_RecordTypeMemory.getRecType('Account', 'Distributor'), UserInfo.getUserId(),NULL, true);
    public static Account accountStore = DMS_SObjectInstance_Test.createAccount('account Test','DMS_test_test', accountDistributor.id, 'APROV', DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer'), UserInfo.getUserId(), '001', true);  
    
    private static testMethod void testHexagon()
    {        
        DMS_Hexagon_CC hexagon = new DMS_Hexagon_CC();         
        hexagon.selectedDistributor = 'account Test';        
        hexagon.selectedDate = '2016-06-01';
        hexagon.selectedSalesChannel = '001';
        hexagon.selectedDistributorCountry = 'El Salvador';
        hexagon.selectedSeller = '';
        hexagon.getOptionDistributor();
        hexagon.getOptionSeller();
        hexagon.getOptionDate();
        
        Test.setMock(HttpCalloutMock.class, new DMS_WaveHexagonRestMock_Test());
        
        Test.startTest();
        hexagon.submitRequest();                
        Test.stopTest();
    }
}