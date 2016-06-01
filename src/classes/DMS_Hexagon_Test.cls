/**********************************************************************
Name: DMS_Hexagon_Test
Copyright © 2016 Salesforce
====================================================== 
====================================================== 
Purpose: 
Class used to test the controller DMS_Hexagon_CC
====================================================== 
======================================================
History 

VERSION		AUTHOR			 DATE 	 	 Description
1.0		DIMITRI M. SANTANA	30/05/2016	INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class DMS_Hexagon_Test 
{
    
    public static Account accountDistributor = DMS_SObjectInstance_Test.createAccount(DMS_GlobalConstants.ACCOUNT_NAME,DMS_GlobalConstants.ACCOUNT_EXTERNAL_CODE, null, null, DMS_GlobalConstants.ACCOUNT_RECTYPE_DISTRIBUTOR, UserInfo.getUserId(),NULL, true);
    public static Account accountStore = DMS_SObjectInstance_Test.createAccount(DMS_GlobalConstants.ACCOUNT_NAME,DMS_GlobalConstants.ACCOUNT_EXTERNAL_CODE, accountDistributor.id, DMS_GlobalConstants.ACCOUNT_STATUS_APROV, DMS_GlobalConstants.ACCOUNT_RECTYPE_STORE, UserInfo.getUserId(), DMS_GlobalConstants.ACCOUNT_SALES_CHANNEL, true);  
    
    private static testMethod void testHexagon()
    {        
        DMS_Hexagon_CC hexagon = new DMS_Hexagon_CC();         
        hexagon.selectedDistributor = DMS_GlobalConstants.ACCOUNT_NAME;        
        hexagon.selectedDate = '2016-05-01';
        hexagon.selectedSalesChannel = DMS_GlobalConstants.ACCOUNT_SALES_CHANNEL;
                        
        Test.setMock(HttpCalloutMock.class, new DMS_WaveHexagonRestMock_Test());
        
        Test.startTest();
        hexagon.submitRequest();                
        Test.stopTest();
    }
}