/**********************************************************************
Name: DMS_WaveHexagonRestMock_Test
Copyright © 2016 Salesforce
====================================================== 
====================================================== 
Purpose: 
Class used to mock for call the wave
====================================================== 
======================================================
History 

VERSION		AUTHOR			 DATE 	 	 Description
1.0		DIMITRI M. SANTANA	30/05/2016	INITIAL DEVELOPMENT
***********************************************************************/
@isTest
global class DMS_WaveHexagonRestMock_Test implements HttpCalloutMock{
    public static final String BODY = '{"action":"query","responseId":"44S_yDq9cxKcpMH5ThAuU-","results":{"records":[{"cdDistributor":"DMS_ES_CHALTAMIRA","dsSalesRep":"R1","cdSalesChannel":"001","cdSalesRep":"venEA02","devolutionAc":0,"devolutionPrev":0,"dropsizeAc":26.772261,"dropsizePrev":17.818238,"dsCountry":"El Salvador","dsDistributor":"CHALTAMIRA","dtPeriod":"2016-06-01","frequencyAc":2.065,"frequencyPrev":1.986885,"impactedStoreAc":200,"impactedStorePrev":203.333333,"ordersAc":413,"ordersPrev":404,"perforDevolutionAc":100,"perforDevolutionPrev":100,"perforDropsizeAc":107.089043,"perforDropsizePrev":106.909425,"perforFrequencyAc":82.6,"perforFrequencyPrev":119.213115,"perforImpactedStoreAc":60.606061,"perforImpactedStorePrev":92.424242,"perforOrdersAc":71.206897,"perforOrdersPrev":104.482759,"perforSelloutAc":73.712958,"perforSelloutPrev":71.98568,"selloutAc":11056.9437,"selloutPrev":7198.567967,"targetDevolutionAc":0,"targetDevolutionPrev":0,"targetDropsizeAc":25,"targetDropsizePrev":16.666667,"targetFrequencyAc":2.5,"targetFrequencyPrev":1.666667,"targetImpactedStoreAc":330,"targetImpactedStorePrev":220,"targetOrderAc":580,"targetOrderPrev":386.666667,"targetSelloutAc":15000,"targetSelloutPrev":10000,"variacDevolution":0,"variacDropsize":0.179618,"variacFrequency":-36.613115,"variacImpactedStore":-31.818182,"variacOrders":-33.275862,"variacSellout":1.727278},{"cdDistributor":"DMS_ES_CHALTAMIRA","dsSalesRep":"R2","cdSalesChannel":"001","cdSalesRep":"venEA03","devolutionAc":0,"devolutionPrev":0,"dropsizeAc":28.300283,"dropsizePrev":27.183098,"dsCountry":"El Salvador","dsDistributor":"CHALTAMIRA","dtPeriod":"2016-06-01","frequencyAc":2.751515,"frequencyPrev":2.389744,"impactedStoreAc":165,"impactedStorePrev":130,"ordersAc":454,"ordersPrev":310.666667,"perforDevolutionAc":100,"perforDevolutionPrev":100,"perforDropsizeAc":113.201131,"perforDropsizePrev":163.09859,"perforFrequencyAc":110.060606,"perforFrequencyPrev":143.384615,"perforImpactedStoreAc":50,"perforImpactedStorePrev":59.090909,"perforOrdersAc":82.545455,"perforOrdersPrev":84.727273,"perforSelloutAc":85.655523,"perforSelloutPrev":84.448826,"selloutAc":12848.3284,"selloutPrev":8444.882567,"targetDevolutionAc":0,"targetDevolutionPrev":0,"targetDropsizeAc":25,"targetDropsizePrev":16.666667,"targetFrequencyAc":2.5,"targetFrequencyPrev":1.666667,"targetImpactedStoreAc":330,"targetImpactedStorePrev":220,"targetOrderAc":550,"targetOrderPrev":366.666667,"targetSelloutAc":15000,"targetSelloutPrev":10000,"variacDevolution":0,"variacDropsize":-49.897459,"variacFrequency":-33.324009,"variacImpactedStore":-9.090909,"variacOrders":-2.181818,"variacSellout":1.206697},{"cdDistributor":"DMS_ES_CHALTAMIRA","dsSalesRep":"R3","cdSalesChannel":"001","cdSalesRep":"venEA01","devolutionAc":0,"devolutionPrev":0,"dropsizeAc":15.887304,"dropsizePrev":14.668384,"dsCountry":"El Salvador","dsDistributor":"CHALTAMIRA","dtPeriod":"2016-06-01","frequencyAc":2.402439,"frequencyPrev":2.481481,"impactedStoreAc":328,"impactedStorePrev":216,"ordersAc":788,"ordersPrev":536,"perforDevolutionAc":100,"perforDevolutionPrev":100,"perforDropsizeAc":63.549216,"perforDropsizePrev":88.010303,"perforFrequencyAc":96.097561,"perforFrequencyPrev":148.888889,"perforImpactedStoreAc":99.393939,"perforImpactedStorePrev":98.181818,"perforOrdersAc":97.888199,"perforOrdersPrev":99.875776,"perforSelloutAc":83.461304,"perforSelloutPrev":78.622537,"selloutAc":12519.1956,"selloutPrev":7862.2537,"targetDevolutionAc":0,"targetDevolutionPrev":0,"targetDropsizeAc":25,"targetDropsizePrev":16.666667,"targetFrequencyAc":2.5,"targetFrequencyPrev":1.666667,"targetImpactedStoreAc":330,"targetImpactedStorePrev":220,"targetOrderAc":805,"targetOrderPrev":536.666667,"targetSelloutAc":15000,"targetSelloutPrev":10000,"variacDevolution":0,"variacDropsize":-24.461086,"variacFrequency":-52.791328,"variacImpactedStore":1.212121,"variacOrders":-1.987578,"variacSellout":4.838767}]}}';
    
    // Create a fake response
    global HTTPResponse respond(HTTPRequest req) {                               
        HttpResponse res = new HttpResponse();
        res.setHeader(DMS_GlobalConstants.HEADER_CONTENT_TYPE, DMS_GlobalConstants.CONTENT_TYPE_JSON);         
        res.setStatusCode(200);               
        res.setBody(BODY);         
        return res;
    }    
}