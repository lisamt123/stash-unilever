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
    public static final String BODY = '{"action":"query","responseId":"44CkC_43gDvg5bH5ThAuU-","results":{"records":[{"Actual":0,"Distributor_AccountName":"CHALTAMIRA","Distributor_Country":"El Salvador","Distributor_ExternalCode":"DMS_ES_CHALTAMIRA","Indicator_Type":"DEVOLUCIONES ($)","Performance":0,"Periodo":"2016-04-01","Previous":0,"SalesChannel":"001","SalesRep":"venEA01","Target":0,"Target_Previous":0,"Variation":0,"dsCategory":"Actual"},{"Actual":0,"Distributor_AccountName":"CHALTAMIRA","Distributor_Country":"El Salvador","Distributor_ExternalCode":"DMS_ES_CHALTAMIRA","Indicator_Type":"DEVOLUCIONES (%)","Performance":0,"Periodo":"2016-04-01","Previous":0,"SalesChannel":"001","SalesRep":"venEA01","Target":0,"Target_Previous":0,"Variation":0,"dsCategory":"Actual"},{"Actual":14.23,"Distributor_AccountName":"CHALTAMIRA","Distributor_Country":"El Salvador","Distributor_ExternalCode":"DMS_ES_CHALTAMIRA","Indicator_Type":"DROPSIZE ($/PEDIDO)","Performance":56.92,"Periodo":"2016-04-01","Previous":14.86,"SalesChannel":"001","SalesRep":"venEA01","Target":25,"Target_Previous":16.67,"Variation":-32.222172,"dsCategory":"Actual"},{"Actual":2.19,"Distributor_AccountName":"CHALTAMIRA","Distributor_Country":"El Salvador","Distributor_ExternalCode":"DMS_ES_CHALTAMIRA","Indicator_Type":"FRECUENCIA (UN / tienda)","Performance":87.6,"Periodo":"2016-04-01","Previous":1.46,"SalesChannel":"001","SalesRep":"venEA01","Target":2.5,"Target_Previous":1.67,"Variation":0.17485,"dsCategory":"Actual"},{"Actual":716,"Distributor_AccountName":"CHALTAMIRA","Distributor_Country":"El Salvador","Distributor_ExternalCode":"DMS_ES_CHALTAMIRA","Indicator_Type":"PEDIDOS (UN)","Performance":111.007752,"Periodo":"2016-04-01","Previous":563,"SalesChannel":"001","SalesRep":"venEA01","Target":805,"Target_Previous":430,"Variation":-19.922481,"dsCategory":"Actual"},{"Actual":10186.05,"Distributor_AccountName":"CHALTAMIRA","Distributor_Country":"El Salvador","Distributor_ExternalCode":"DMS_ES_CHALTAMIRA","Indicator_Type":"SELLOUT ($)","Performance":67.907,"Periodo":"2016-04-01","Previous":8365.36,"SalesChannel":"001","SalesRep":"venEA01","Target":15000,"Target_Previous":10000,"Variation":-15.7466,"dsCategory":"Actual"},{"Actual":327,"Distributor_AccountName":"CHALTAMIRA","Distributor_Country":"El Salvador","Distributor_ExternalCode":"DMS_ES_CHALTAMIRA","Indicator_Type":"CLIENTES IMPACTADOS (UN)","Performance":99.090909,"Periodo":"2016-04-01","Previous":214,"SalesChannel":"001","SalesRep":"venEA01","Target":330,"Target_Previous":220,"Variation":1.818182,"dsCategory":"Actual"}]}}';
    
    // Create a fake response
    global HTTPResponse respond(HTTPRequest req) {                               
        HttpResponse res = new HttpResponse();
        res.setHeader(DMS_GlobalConstants.HEADER_CONTENT_TYPE, DMS_GlobalConstants.CONTENT_TYPE_JSON);         
        res.setStatusCode(200);               
        res.setBody(BODY);        
        return res;
    }    
}