global class VPM_VendorDetailsServicesHelper {
    global static VPM_VendorDetailsType callVendorDetailsService(String venCode, String eccVal, String compCode) {
        System.debug('----------input parameters passed are----------' + venCode + '  ' + eccVal + '  ' + compCode);
        //String url = 'https://vendor-bpm.eu.cloudhub.io/vendor-api/vendor/ecc?client_id=3485ee8279af458abc58065291e188d4&client_secret=ca16126215ea409498F4296ADB25EAB5';
        String url = 'https://vendor-bpm-uat.eu.cloudhub.io/vendor-api/vendor/ecc?client_id=3485ee8279af458abc58065291e188d4&client_secret=ca16126215ea409498F4296ADB25EAB5';
        Map<String, Object> results;
        List<boolean> flagResults;
        VPM_VendorDetailsType vendorDetails;
        
        url = url + '&vendorCode='+venCode+'&ECC='+eccVal + '&companyCode=' + compCode;
        
        // Instantiate a new http object
        Http h = new Http();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        System.debug('------HTTP response status and status code are ------'+res.getStatus() + '  ' + res.getStatusCode());
        System.debug('----------'+ res.getBody());
        
        // If the request is successful, parse the JSON response.
        if (res.getStatusCode() == 200 && String.isNotBlank(res.getBody())) {
            // Deserialize the JSON string into collections of primitive data types.
            vendorDetails = VPM_VendorDetailsType.parse(res.getBody());
            System.debug('----vendorDetails----'+vendorDetails);
        }
        return vendorDetails;
    }
}