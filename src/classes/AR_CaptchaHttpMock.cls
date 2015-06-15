@isTest
global class AR_CaptchaHttpMock implements HttpCalloutMock {
    private boolean forceError;
    
    public AR_CaptchaHttpMock(boolean forceError) {
        this.forceError = forceError;
    }
    
    global HttpResponse respond(HttpRequest req) {
        system.debug('Creating mock response...');
        HttpResponse res = new HttpResponse();
        String body = this.forceError ? 'false' : 'true';
        res.setBody(body);
        system.debug('Response: ' + res);
        return res;
    }

}