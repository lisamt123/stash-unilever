/**********************************************************************
Name: DMS_WaveHexagonRestCall_Test
Copyright © 2016 Salesforce
====================================================== 
====================================================== 
Purpose: 
Class used to test the class DMS_WaveHexagon
====================================================== 
======================================================
History 

VERSION		AUTHOR			 DATE 	 	 Description
1.0		DIMITRI M. SANTANA	30/05/2016	INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class DMS_WaveHexagonRestCall_Test 
{
    
    public static testMethod void testRestCall()
    {
        Test.setMock(HttpCalloutMock.class, new DMS_WaveHexagonRestMock_Test());
        List<DMS_WaveHexagon.Records> recordsList;
        
        DMS_WaveHexagon call = new DMS_WaveHexagon();
        recordsList = call.getRecords('', '', '', '','');
        
        System.assert(recordsList.size() > 0);        
        
        System.assert(recordsList.get(0).dsSalesRep !=null);
        System.assert(recordsList.get(0).cdDistributor !=null);
        System.assert(recordsList.get(0).cdSalesChannel !=null);
        System.assert(recordsList.get(0).cdSalesRep !=null);
        System.assert(recordsList.get(0).dsCountry !=null);
        System.assert(recordsList.get(0).dsDistributor !=null);
        System.assert(recordsList.get(0).dtPeriod !=null);
        System.assert(recordsList.get(0).devolutionAc !=null);
        System.assert(recordsList.get(0).devolutionPrev !=null);
        System.assert(recordsList.get(0).dropsizeAc !=null);
        System.assert(recordsList.get(0).dropsizePrev !=null);       
        System.assert(recordsList.get(0).frequencyAc !=null);
        System.assert(recordsList.get(0).frequencyPrev !=null);
        System.assert(recordsList.get(0).impactedStoreAc !=null);
        System.assert(recordsList.get(0).impactedStorePrev !=null);
        System.assert(recordsList.get(0).ordersAc !=null);
        System.assert(recordsList.get(0).ordersPrev !=null);
        System.assert(recordsList.get(0).perforDevolutionAc !=null);
        System.assert(recordsList.get(0).perforDevolutionPrev !=null);
        System.assert(recordsList.get(0).perforDropsizeAc !=null);
        System.assert(recordsList.get(0).perforDropsizePrev !=null);
        System.assert(recordsList.get(0).perforFrequencyAc !=null);
        System.assert(recordsList.get(0).perforFrequencyPrev !=null);
        System.assert(recordsList.get(0).perforImpactedStoreAc !=null);
        System.assert(recordsList.get(0).perforImpactedStorePrev !=null);
        System.assert(recordsList.get(0).perforOrdersAc !=null);
        System.assert(recordsList.get(0).perforOrdersPrev !=null);
        System.assert(recordsList.get(0).perforSelloutAc !=null);
        System.assert(recordsList.get(0).perforSelloutPrev !=null);
        System.assert(recordsList.get(0).selloutAc !=null);
        System.assert(recordsList.get(0).selloutPrev !=null);
        System.assert(recordsList.get(0).targetDevolutionAc !=null);
        System.assert(recordsList.get(0).targetDevolutionPrev !=null);
        System.assert(recordsList.get(0).targetDropsizeAc !=null);
        System.assert(recordsList.get(0).targetDropsizePrev !=null);
        System.assert(recordsList.get(0).targetFrequencyAc !=null);
        System.assert(recordsList.get(0).targetFrequencyPrev !=null);
        System.assert(recordsList.get(0).targetImpactedStoreAc !=null);
        System.assert(recordsList.get(0).targetImpactedStorePrev !=null);
        System.assert(recordsList.get(0).targetOrderAc !=null);
        System.assert(recordsList.get(0).targetOrderPrev !=null);
        System.assert(recordsList.get(0).targetSelloutAc !=null);
        System.assert(recordsList.get(0).targetSelloutPrev !=null);
        System.assert(recordsList.get(0).variacDevolution !=null);
        System.assert(recordsList.get(0).variacDropsize !=null);
        System.assert(recordsList.get(0).variacFrequency !=null);
        System.assert(recordsList.get(0).variacImpactedStore !=null);
        System.assert(recordsList.get(0).variacOrders !=null);
        System.assert(recordsList.get(0).variacSellout !=null);        
    }    
}