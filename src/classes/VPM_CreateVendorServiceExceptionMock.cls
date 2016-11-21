public class VPM_CreateVendorServiceExceptionMock implements HttpCalloutMock {
    public class MockException extends Exception{
        
    }
 public HttpResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        String jsonServiceResponse;
        res.setStatus('OK'); 
        req.setMethod('PUT');
     	req.setBody(null);
        throw new MockException('No possible');
        return res;
    }
}