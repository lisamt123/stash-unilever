global class VPM_FetchVendorsDetails {
    
    global class InputVariables {
        @InvocableVariable(label='Vendor Code')
        public String vendorCodeInput;        
        @InvocableVariable(label='ECC')
        public String ecc;        
    }
    
    global class OutputVariables {
        @InvocableVariable
        public String ECC;
        @InvocableVariable
        public Integer VendorCode;
        @InvocableVariable
        public String BankCountry;
        @InvocableVariable
        public Integer BankKey;
        @InvocableVariable
        public Integer BankAccount;
        @InvocableVariable
        public Integer ControlKey;
        @InvocableVariable
        public String AccountHolder;
        @InvocableVariable
        public String IBAN;
        @InvocableVariable
        public String CompanyCode;
        @InvocableVariable
        public String BankName;
        @InvocableVariable
        public String SwiftKey;
        @InvocableVariable
        public Boolean Blocked;
        @InvocableVariable
    	public Boolean Deleted;
    }
    
    @InvocableMethod
    global static List<OutputVariables> getVendorDetails(List<InputVariables> inputCriteria) {
        
        List<String> vendors = new List<String>();
        List<OutputVariables> vendorListResult = new List<OutputVariables>();
        String vendorName, vendorCode, eccInput;
        List<Account> vendorList = new List<Account>();
        List<VPM_VendorDetailsType> vendorDetails;
        VPM_VendorDetailsType vendorDetail;
        
        System.debug('-----inputCriteria-----'+inputCriteria);
        
        if(inputCriteria != null) {
            System.debug('-----inputCriteria.size()-----'+inputCriteria.size());
            System.debug('-----vendor code and Input-----'+inputCriteria.get(0).vendorCodeInput + '  ' + 
                inputCriteria.get(0).ecc);
            vendorCode = inputCriteria.get(0).vendorCodeInput;
            eccInput = inputCriteria.get(0).ecc;
        }
        
        vendorDetail = VPM_VendorDetailsServicesHelper.callVendorDetailsService(vendorCode,eccInput);
        
        System.debug('-----vendor details are -----'+vendorDetail);
        if(vendorDetail != null) {
            OutputVariables outVar = new OutputVariables();
            
            outVar.ECC=vendorDetail.ECC;
            outVar.VendorCode=vendorDetail.VendorCode;
            outVar.BankCountry=vendorDetail.BankCountry;
            outVar.BankKey=vendorDetail.BankKey;
            outVar.BankAccount=vendorDetail.BankAccount;
            outVar.ControlKey=vendorDetail.ControlKey;
            outVar.AccountHolder=vendorDetail.AccountHolder;
            outVar.IBAN=vendorDetail.IBAN;
            outVar.CompanyCode=vendorDetail.CompanyCode;
            outVar.BankName=vendorDetail.BankName;
            outVar.SwiftKey=vendorDetail.SwiftKey;
            outVar.Blocked=vendorDetail.Blocked;
            outVar.Deleted=vendorDetail.Deleted;
            
            vendorListResult.add(outVar);
        }
        return vendorListResult;
    }
}