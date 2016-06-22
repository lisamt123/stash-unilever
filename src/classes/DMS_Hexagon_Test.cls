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
    private static final String SALES_CHANNEL = '001';
    private static Account accountDistributor = DMS_SObjectInstance_Test.createAccount('account Test','DMS_test_test', null, null, DMS_RecordTypeMemory.getRecType('Account', 'Distributor'), UserInfo.getUserId(),NULL, true);
    private static Account accountStore = DMS_SObjectInstance_Test.createAccount('account Test','DMS_test_test', accountDistributor.id, 'APROV', DMS_RecordTypeMemory.getRecType('Account', 'InDirect_Customer'), UserInfo.getUserId(), SALES_CHANNEL,true);     
    private static Contact contact1 = DMS_SObjectInstance_Test.createContact(accountDistributor.Id,'Test', null,true);
    private static Target__c target =  DMS_SObjectInstance_Test.createTarget(contact1.id,SALES_CHANNEL,true);
    private static Target__c target2 =  DMS_SObjectInstance_Test.createTarget(contact1.id,SALES_CHANNEL,true);
    private static testMethod void testHexagon()
    {        
        DMS_Hexagon_CC hexagon = new DMS_Hexagon_CC();         
        hexagon.selectedDistributor = 'DMS_test_test';        
        hexagon.selectedDate = '2016-06-01';
        hexagon.selectedSalesChannel = '001';
        hexagon.selectedDistributorCountry = 'testCountry';
        hexagon.selectedSeller = 'Todos';
        hexagon.getOptionDistributor();
        hexagon.getOptionSeller();
        hexagon.getOptionDate();
        
        Test.setMock(HttpCalloutMock.class, new DMS_WaveHexagonRestMock_Test());
        
        Test.startTest();
        System.assert(hexagon.hexagonMap == null);        
        hexagon.submitRequest(); 
        System.assert(hexagon.hexagonMap.size() > 0);
        Test.stopTest();
    }
}