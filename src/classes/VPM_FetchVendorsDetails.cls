global class VPM_FetchVendorsDetails {
    global class InputVariables {
        public String vendorCodeInput;
        public String ecc;
        public String compnayCode;
    }
    global class serviceErrorResponse {
        public string statusCode;
        public string message;
    }
    global static List<VPM_ECCVendorSearchServiceOutput> getVendorDetails(List<InputVariables> inputCriteria) {
        String compnayCode, vendorCode, eccInput;
        List<VPM_ECCVendorSearchServiceOutput> vendorDetailsOutput = new List<VPM_ECCVendorSearchServiceOutput>();
        VPM_ECCVendorSearchServiceOutput vendorDetail;
        HttpResponse resp;
        System.debug('-----inputCriteria-----'+inputCriteria);
        if(inputCriteria != null && inputCriteria.size() > 0) {
            System.debug('-----inputCriteria.size()-----'+inputCriteria.size());
            System.debug('-----vendor code and Input-----'+inputCriteria.get(0).vendorCodeInput + '  ' + 
                         inputCriteria.get(0).ecc + '  ' + inputCriteria.get(0).compnayCode);
            vendorCode = inputCriteria.get(0).vendorCodeInput;
            eccInput = inputCriteria.get(0).ecc;
            compnayCode = inputCriteria.get(0).compnayCode;
        }
        resp = VPM_VendorDetailsServicesHelper.callVendorDetailsService2(vendorCode,eccInput,compnayCode);        
        System.debug('-----http response from service is -----'+resp);
        if(resp != null && resp.getStatusCode() == 200 && String.isNotBlank(resp.getBody())) {
            System.debug('---resp.getBody()--'+resp.getBody());
            vendorDetail = (VPM_ECCVendorSearchServiceOutput) System.JSON.deserialize(resp.getBody(), VPM_ECCVendorSearchServiceOutput.class);
            vendorDetail = addMaintainExtendFlags(vendorDetail);
            vendorDetail.message = 'Vendor found.';
            vendorDetail.statusCode = '200';
            System.debug('----vendorDetail---'+vendorDetail);
            vendorDetailsOutput.add(vendorDetail);
        } else if(resp != null && resp.getStatusCode() == 404) {
            serviceErrorResponse serviceResponse = (serviceErrorResponse) System.JSON.deserialize(resp.getBody(), serviceErrorResponse.class);
            System.debug('-----404-----' + serviceResponse.statusCode + '  ' + serviceResponse.message);
            vendorDetail = new VPM_ECCVendorSearchServiceOutput();
            vendorDetail.message = serviceResponse.message;
            vendorDetail.statusCode = serviceResponse.statusCode;
            vendorDetail.Blocked=false;
            vendorDetail.Deleted=false;
            vendorDetail.vendorFoundResult=false;
            vendorDetail.companyCodeMatching = false;
            System.debug('----vendorDetail---'+vendorDetail);
            vendorDetailsOutput.add(vendorDetail);
        } else {
            serviceErrorResponse serviceResponse = (serviceErrorResponse) System.JSON.deserialize(resp.getBody(), serviceErrorResponse.class);
            System.debug('-----Neither 200 nor 404 status code-----');
            vendorDetail = new VPM_ECCVendorSearchServiceOutput();
            if(serviceResponse != null) {
                vendorDetail.message = serviceResponse.message;
            	vendorDetail.statusCode = serviceResponse.statusCode;
            }
            vendorDetail.Blocked=false;
            vendorDetail.Deleted=false;
            vendorDetail.vendorFoundResult=false;
            vendorDetail.companyCodeMatching = false;
            vendorDetailsOutput.add(vendorDetail);
        }
        //system.debug('@@vendorDetailsOutput' + json.serializePretty(vendorDetailsOutput));
        return vendorDetailsOutput;
    }
    public static VPM_ECCVendorSearchServiceOutput addMaintainExtendFlags(VPM_ECCVendorSearchServiceOutput vendorDetailsInput) {
        //add company Code match and vendor found result flags to json response depending on message
        if(vendorDetailsInput != null) {
            /*if(String.isNotBlank(vendorDetailsInput.message) && (vendorDetailsInput.message).equalsIgnoreCase('Vendor does not exist in this company code.') && vendorDetailsInput.companyCodeMatch != null) {
                vendorDetailsInput.companyCodeMatching = false;
                vendorDetailsInput.vendorFoundResult=true;
            } else if(String.isNotBlank(vendorDetailsInput.message) && (vendorDetailsInput.message).equalsIgnoreCase('Vendor code not found in region.')) {
                vendorDetailsInput.vendorFoundResult=false;
                vendorDetailsInput.companyCodeMatching = false;
            } else {*/
                //vendorDetailsInput.companyCodeMatching = true;
                vendorDetailsInput.vendorFoundResult=true;
            	vendorDetailsInput.companyCodeMatching = Boolean.valueOf(vendorDetailsInput.companyCodeMatch);
            //}
        }
        return vendorDetailsInput;
    }
}