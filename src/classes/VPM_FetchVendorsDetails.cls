global class VPM_FetchVendorsDetails {
    
    global class InputVariables {
        @InvocableVariable(label='Vendor Code')
        public String vendorCodeInput;
        @InvocableVariable(label='ECC')
        public String ecc;
        @InvocableVariable(label='Company Code')
        public String compnayCode;
    }
    
    global class OutputVariables {
        @InvocableVariable
        public String ECC;
        @InvocableVariable
        public String VendorCode;
        @InvocableVariable
        public String BankCountry;
        @InvocableVariable
        public String BankKey;
        @InvocableVariable
        public String BankAccount;
        @InvocableVariable
        public String ControlKey;
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
        @InvocableVariable(label='Vendor Blocked Result')
        public Boolean Blocked;
        @InvocableVariable(label='Vendor Deleted Result')
        public Boolean Deleted;
        @InvocableVariable(label='Vendor Found')
        public boolean vendorFoundResult;
    }
    
    @InvocableMethod
    global static List<OutputVariables> getVendorDetails(List<InputVariables> inputCriteria) {
        
        List<String> vendors = new List<String>();
        List<OutputVariables> vendorListResult = new List<OutputVariables>();
        String compnayCode, vendorCode, eccInput;
        List<Account> vendorList = new List<Account>();
        List<VPM_VendorDetailsType> vendorDetails;
        VPM_VendorDetailsType vendorDetail;
        
        System.debug('-----inputCriteria-----'+inputCriteria);
        
        if(inputCriteria != null && inputCriteria.size() > 0) {
            System.debug('-----inputCriteria.size()-----'+inputCriteria.size());
            System.debug('-----vendor code and Input-----'+inputCriteria.get(0).vendorCodeInput + '  ' + 
                inputCriteria.get(0).ecc + '  ' + inputCriteria.get(0).compnayCode);
            vendorCode = inputCriteria.get(0).vendorCodeInput;
            eccInput = inputCriteria.get(0).ecc;
            compnayCode = inputCriteria.get(0).compnayCode;
        }
        
        vendorDetail = VPM_VendorDetailsServicesHelper.callVendorDetailsService(vendorCode,eccInput,compnayCode);
        
        System.debug('-----vendor details are -----'+vendorDetail);
        
        if(vendorDetail != null) {
            OutputVariables outVar = new OutputVariables();
            
            outVar.ECC=vendorDetail.ECC;
            outVar.VendorCode=vendorDetail.VendorCode;
            outVar.BankCountry=vendorDetail.BankCountryKey;
            outVar.BankKey=vendorDetail.BankKey;
            outVar.BankAccount=vendorDetail.BankAccountNumber;
            outVar.ControlKey=vendorDetail.BankControlKey;
            outVar.AccountHolder=vendorDetail.AccountHolderName;
            outVar.IBAN=vendorDetail.IBAN;
            outVar.BankName=vendorDetail.BankName;
            outVar.SwiftKey=vendorDetail.SwiftKey;
            outVar.Blocked=vendorDetail.Blocked;
            outVar.Deleted=vendorDetail.Deleted;
            outVar.CompanyCode=vendorDetail.CompanyCode;
            outVar.vendorFoundResult=true;
            
            vendorListResult.add(outVar);
        } else {
            OutputVariables outVar = new OutputVariables();
            
            /*outVar.ECC=vendorDetail.ECC;
            outVar.VendorCode=vendorDetail.VendorCode;
            outVar.BankCountry=vendorDetail.BankCountry;
            outVar.BankKey=vendorDetail.BankKey;
            outVar.BankAccount=vendorDetail.BankAccount;
            outVar.ControlKey=vendorDetail.ControlKey;
            outVar.AccountHolder=vendorDetail.AccountHolder;
            outVar.IBAN=vendorDetail.IBAN;
            outVar.CompanyCode=vendorDetail.CompanyCode;
            outVar.BankName=vendorDetail.BankName;
            outVar.SwiftKey=vendorDetail.SwiftKey;*/
            outVar.Blocked=false;
            outVar.Deleted=false;
            outVar.vendorFoundResult=false;
            
            vendorListResult.add(outVar);
        }
        return vendorListResult;
    }
}