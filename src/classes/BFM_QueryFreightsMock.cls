/**
 * Mock class for supporting sample information on the Query Freights response. Also used for testing the Service Calls for 
 * Query Freights
 * 
 * @author Zanquini, Vinicius
 * @date 2016-08-16 
 * */
public class BFM_QueryFreightsMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest request){
        HttpResponse res= new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(getJSONResponse());
        res.setStatusCode(200);
        return res;
        
    }
    
    private String getJSONResponse(){
        String strResponse = '{"foo":"bar"}';
        return strResponse;
    }
}