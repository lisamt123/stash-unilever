/*********************************************************************************************************
Name:  VPM_VendorDetailsServicesHelper 
Copyright ? 2016  Unilever
==========================================================================================================
==========================================================================================================
Purpose:  This class has been used to make 'GET' web service callout.

==========================================================================================================
==========================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                                                Description
1.0 -    Ajay       09-09-2016    getVendorDetails method    Added the Code to do 'GET' web service callout operation.
                  
**********************************************************************************************************/
global class VPM_VendorDetailsServicesHelper {
    global static HttpResponse callVendorDetailsService2(String venCode, String eccVal, String compCode, String purchasingOrg) {
        System.debug('----------input parameters passed are----------' + venCode + '  ' + eccVal + '  ' + compCode + '  ' + purchasingOrg);
        Map<String, String> reqQueryParams = new Map<String,String>();
        reqQueryParams.put('VendorCode', venCode);
        reqQueryParams.put('ECC', eccVal);
        reqQueryParams.put('CompanyCode', compCode);
        if(String.isNotBlank(purchasingOrg)){
        reqQueryParams.put('PurchasingOrg', purchasingOrg);
        }
        VPM_HttpUtil utilClass = new VPM_HttpUtil();
        HttpResponse res = utilClass.sendGetRequest('GET','VPM_ECCVendorSearch',reqQueryParams);
        System.debug('------HTTP response status and status code and Response body are ------'+res.getStatus() + '  ' + res.getStatusCode() + res.getBody());
        return res;
    }
}