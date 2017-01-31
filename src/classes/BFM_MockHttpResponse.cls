@isTest

global class BFM_MockHttpResponse implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        //System.assertEquals('https://salesforce.com/', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setStatusCode(200);
        return res;
    }
}