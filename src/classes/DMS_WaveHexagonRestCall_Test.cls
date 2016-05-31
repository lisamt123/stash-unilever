/**********************************************************************
Name: DMS_WaveHexagonRestCall_Test
Copyright © 2016 Salesforce
====================================================== 
====================================================== 
Purpose: 
Class used to test the 
====================================================== 
======================================================
History 

VERSION		AUTHOR			 DATE 	 	 Description
1.0		DIMITRI M. SANTANA	30/05/2016	INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class DMS_WaveHexagonRestCall_Test {
    
    public static testMethod void testRestCall(){
        Test.setMock(HttpCalloutMock.class, new DMS_WaveHexagonRestMock_Test());
        
        DMS_WaveHexagonRestCall call = new DMS_WaveHexagonRestCall();
        call.getRecords('', '', '', '');
    }    
}