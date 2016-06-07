global class VPM_VendorDetailsServicesHelper {
    global static HttpResponse callVendorDetailsService2(String venCode, String eccVal, String compCode) {
        System.debug('----------input parameters passed are----------' + venCode + '  ' + eccVal + '  ' + compCode);
        Map<String, String> reqQueryParams = new Map<String,String>();
        reqQueryParams.put('VendorCode', venCode);
        reqQueryParams.put('ECC', eccVal);
        reqQueryParams.put('CompanyCode', compCode);
        VPM_VendorDetailsType vendorDetails;
        VPM_HttpUtil utilClass = new VPM_HttpUtil();
        HttpResponse res = utilClass.sendGetRequest('GET','VPM_ECCVendorSearch',reqQueryParams);
        System.debug('------HTTP response status and status code and Response body are ------'+res.getStatus() + '  ' + res.getStatusCode() + res.getBody());
        return res;
    }
    global static VPM_VendorDetailsType callVendorDetailsService(String venCode, String eccVal, String compCode) {
        System.debug('----------input parameters passed are----------' + venCode + '  ' + eccVal + '  ' + compCode);
        Map<String, String> reqQueryParams = new Map<String,String>();
        reqQueryParams.put('VendorCode', venCode);
        reqQueryParams.put('ECC', eccVal);
        reqQueryParams.put('CompanyCode', compCode);
        VPM_VendorDetailsType vendorDetails;
        VPM_HttpUtil utilClass = new VPM_HttpUtil();
        HttpResponse res = utilClass.sendGetRequest('GET','VPM_ECCVendorSearch',reqQueryParams);
        System.debug('------HTTP response status and status code and Response body are ------'+res.getStatus() + '  ' + res.getStatusCode() + res.getBody());
        if (res.getStatusCode() == 200 && String.isNotBlank(res.getBody())) {
            vendorDetails = VPM_VendorDetailsType.parse(res.getBody());
            System.debug('----vendorDetails----'+vendorDetails);
        }
        return vendorDetails;
    }
}