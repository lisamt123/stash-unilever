public class AR_CaptchaHelper {

    /* Configuration */

    private String baseUrl; 

    private String privateKey {set; get;}
    
    public String publicKey {set; get;}

    /* Implementation */
    
    // Create properties for the non-VF component input fields generated
    // by the reCAPTCHA JavaScript.
    public String challenge { 
        get {
            return ApexPages.currentPage().getParameters().get('recaptcha_challenge_field');
        }
    }
    public String response  { 
        get {
            return ApexPages.currentPage().getParameters().get('recaptcha_response_field');
        }
    }
    
    // Whether the submission has passed reCAPTCHA validation or not
    public Boolean verified { get; private set; }
    
    public AR_CaptchaHelper() {
        this.verified = false;
        loadSettings();
    }
    
    private void loadSettings() {
        AR_CaptchaSettings__c settings = AR_CaptchaSettings__c.getInstance();
        if(settings != null) {
            this.baseUrl = settings.base_url__c;
            this.publicKey = settings.public_key__c;
            this.privateKey = settings.private_key__c;
        } else {
            System.debug(logginglevel.error, 'No settings found.');
        }
    }
    
    public PageReference doVerify() {
        verify();
        return null;
    }
    
    public boolean verify() {
        System.debug(logginglevel.info, '### Verifying CAPTCHA...');
        this.verified = false;
        
        try {
            // On first page load, form is empty, so no request to make yet
            if ( challenge == null || response == null ) { 
                System.debug('reCAPTCHA verification attempt with empty form');
                return false;
            }
                        
            HttpResponse r = makeRequest(baseUrl,
                'privatekey=' + privateKey + 
                '&remoteip='  + remoteHost + 
                '&challenge=' + challenge +
                '&response='  + response
            );
            
            if ( r!= null ) {
                this.verified = (r.getBody().startsWithIgnoreCase('true'));
                System.debug(logginglevel.info, 'CAPTCHA VALID? ' + verified);
            }
        } catch(Exception e) {
            System.debug(logginglevel.error, 'Error verifying captcha: ' + e.getmessage());
        }
        
        return this.verified;
    }

    public PageReference reset() {
        return null; 
    }   

    /* Private helper methods */
    
    private static HttpResponse makeRequest(string url, string body)  {
        System.debug(logginglevel.info, '### Making request... url: ' + url + ' \nbody: ' + body);
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
        try {
            Http http = new Http();
            response = http.send(req);
            System.debug(logginglevel.info, 'reCAPTCHA response: ' + response);
            System.debug(logginglevel.info, 'reCAPTCHA body: ' + response.getBody());
        } catch(System.Exception e) {
            System.debug(logginglevel.error, 'ERROR: ' + e);
        }
        return response;
    }   
        
    private String remoteHost { 
        get { 
            String ret = '127.0.0.1';
            // also could use x-original-remote-host 
            Map<String, String> hdrs = ApexPages.currentPage().getHeaders();
            if (hdrs.get('x-original-remote-addr')!= null)
                ret =  hdrs.get('x-original-remote-addr');
            else if (hdrs.get('X-Salesforce-SIP')!= null)
                ret =  hdrs.get('X-Salesforce-SIP');
            return ret;
        }
    }
}