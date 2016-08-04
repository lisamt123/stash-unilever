@isTest
public class VPM_FetchVendorsDetails_Test {
  @isTest static void getVendorDetailsTest() {
      List<VPM_FetchVendorsDetails.InputVariables> inputCriteria = new List<VPM_FetchVendorsDetails.InputVariables>();
        VPM_FetchVendorsDetails.InputVariables crit = new VPM_FetchVendorsDetails.InputVariables();
        crit.vendorCodeInput='9987534';
        crit.ecc = 'Cordillera';
        crit.compnayCode = 'ULAG';
        inputCriteria.add(crit);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200));
        VPM_FetchVendorsDetails.getVendorDetails(inputCriteria);
      Test.stopTest();
  }
    static testMethod void getVendorDetailsTestNull() {
        list<VPM_FetchVendorsDetails.InputVariables> InputVariablesListObj = new list<VPM_FetchVendorsDetails.InputVariables>();
        VPM_FetchVendorsDetails.InputVariables InputVariablesObj =new VPM_FetchVendorsDetails.InputVariables();
        InputVariablesObj.vendorCodeInput ='Vendor Code';
        InputVariablesObj.ecc='ECC';
        InputVariablesObj.compnayCode='compCode';
        InputVariablesListObj.add(InputVariablesObj);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(300));
        VPM_FetchVendorsDetails.getVendorDetails(InputVariablesListObj);
        Test.stopTest();
    }
}