@isTest(seeAllData=false)
public class VPM_VendorDetailsServicesHelper_Test {
    static testMethod void callVendorDetailsService_Test() {
        String venCode='', ecc='',compCode='';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock());
        VPM_VendorDetailsServicesHelper.callVendorDetailsService(venCode, ecc, compCode);
        Test.stopTest();        
    }
}