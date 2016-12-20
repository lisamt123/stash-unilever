/**
 * Mock class for simulation of the Mulesoft interface. It exposes its methods as REST webservices and they should be
 * called with HttpRequests calls from Salesforce.
 * */

@RestResource(urlMapping='/MulesoftMock/v1/*')
global class BFM_MulesoftMock {
    
    public Class QueryFreightRequest{
        public QueryFreight QueryFreight;
    }
    
    public Class QueryFreight{
        public List<String> shipmentNumber;
        public String queryType;
    }
    
    
    @HttpPost
    global static void queryFreight(){
        HttpRequest req = new HttpRequest();
        RestRequest restReq= RestContext.request;
        QueryFreightRequest qfr = (QueryFreightRequest)JSON.deserialize(restReq.requestBody.toString(), QueryFreightRequest.class);
        // 1. Do some processing with the request
        // 
        // 2. Query response from Static Resourse
        StaticResource sr = [select Body from StaticResource where Name = 'BFM_JSON_Example_Query_Freights' LIMIT 1];
        String jsonBody = sr.Body.toString();
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody =  Blob.valueOf(jsonBody);
    }
    
    
}