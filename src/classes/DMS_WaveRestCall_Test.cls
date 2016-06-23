/**********************************************************************
Name: DMS_WaveRestCall_Test
Copyright © 2016 Salesforce
====================================================== 
====================================================== 
Purpose: 
Class used to test the class DMS_WaveRestCall
====================================================== 
======================================================
History 

VERSION		AUTHOR			 DATE 	 	 Description
1.0		DIMITRI M. SANTANA	30/05/2016	INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class DMS_WaveRestCall_Test {

     static testMethod void test() {
        Test.setMock(HttpCalloutMock.class, new DMS_WebServiceMockGenerator_Test());
        Test.startTest();
         
        new DMS_WaveRestCall();
        DMS_WaveRestCall.getRecords('','','');
        System.assert(DMS_WaveRestCall.listRecords.size() > 0);
        Test.stopTest();
         
     }    
}