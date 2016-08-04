global class  VPM_ApprovalProcessCall {
    
    public class ApprovalFlagWrapper{
        
        public Boolean isFinancialSensitiveDetailsChanged{get;set;}
        public Boolean isPaymentTermsDetailsChanged{get;set;}
        
        public ApprovalFlagWrapper(Boolean isFinancialSensitiveDetailsChanged, 
                                   Boolean isPaymentTermsDetailsChanged)
        {
            
            this.isFinancialSensitiveDetailsChanged=isFinancialSensitiveDetailsChanged;
            this.isPaymentTermsDetailsChanged= isPaymentTermsDetailsChanged;
            
        }
    }
    
     public VPM_ECCVendorSearchServiceOutput op;
    public VPM_PurchasingRequests__c purchReqVar {get;set;}
    public List<ApprovalFlagWrapper> display_list {get; set;} 
        
    public string vendorCode {get;set;}
    
     public VPM_ECCVendorSearchServiceOutput FetchVendorDeatilSAPService(string mdmCode, string ECC, string VPMCompanyCode)
    {   
        VPM_FetchVendorsDetails.InputVariables ip = new VPM_FetchVendorsDetails.InputVariables();
        List<VPM_FetchVendorsDetails.InputVariables> ipList = new List<VPM_FetchVendorsDetails.InputVariables>();
        List<VPM_ECCVendorSearchServiceOutput> opList = new List<VPM_ECCVendorSearchServiceOutput>();
        ip.vendorCodeInput = mdmCode;
        ip.ecc = ECC;
        ip.compnayCode = VPMCompanyCode;
        ipList.add(ip);
        opList = VPM_FetchVendorsDetails.getVendorDetails(ipList);
        return opList[0];
    }
    
    Public List<ApprovalFlagWrapper> SetApprovalFlag(VPM_PurchasingRequests__c purchReqVar)
    {
        
        display_list = new List<ApprovalFlagWrapper>();
        Boolean isPaymentTermsDetailsChanged;
        Boolean isFinancialSensitiveDetailsChanged;
        Boolean isBankDetailsChanged;
        Boolean isBlockDeletedChanged;
        Boolean isUnBlockUnDeletedChanged;
        //Payment Terms 
        if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Cordillera'){        
            vendorCode =purchReqVar.VPM_VendorCodeLookup__r.mdm_vCodeCordillera__c;
        }else if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Fusion'){
            
            vendorCode =purchReqVar.VPM_VendorCodeLookup__r.mdm_vCodeFusion__c;
            
        }else if(purchReqVar.VPM_CompanyCode__r.ecc__c =='Sirius'){
            
            vendorCode =purchReqVar.VPM_VendorCodeLookup__r.mdm_vCodeSirius__c;
            
        }else if(purchReqVar.VPM_CompanyCode__r.ecc__c =='U2K2'){
            
            vendorCode =purchReqVar.VPM_VendorCodeLookup__r.mdm_vCodeU2K2__c;
            
        }
        
        // Call to Web service Data 
                op = FetchVendorDeatilSAPService(vendorCode,purchReqVar.VPM_CompanyCode__r.ecc__c,purchReqVar.VPM_Company_Code_Value__c);
   
        if(purchReqVar.VPM_PaymentTerms__c !=null  ||(purchReqVar.VPM_PaymentTerms__c == op.CompanyCodeFields[0].PaymentTerms))
          isPaymentTermsDetailsChanged=true;
        else
            isPaymentTermsDetailsChanged=false;
        
        //isFinancialSensitiveDetailsChanged
        
        if((purchReqVar.VPM_ReconciliationAccount__c!= null &&
            (purchReqVar.VPM_ReconciliationAccount__c == op.CompanyCodeFields[0].ReconciliationAccount))
           ||
           (purchReqVar.VPM_PaymentMethod__c !=null && (purchReqVar.VPM_PaymentMethod__c == op.CompanyCodeFields[0].PaymentMethod))
           ||
           (purchReqVar.VPM_CashManagementGroup__c!= null && (purchReqVar.VPM_CashManagementGroup__c == op.CompanyCodeFields[0].CashManagementGroup))
           ||
           (purchReqVar.VPM_SortKey__c!=null && (purchReqVar.VPM_SortKey__c == op.CompanyCodeFields[0].SortKey))
           ||
           (purchReqVar.VPM_PaymentBlock__c !=null &&(purchReqVar.VPM_PaymentBlock__c == op.PaymentBlock))
            ||
            (purchReqVar.VPM_CheckDoubleInvoices__c ==true &&(purchReqVar.VPM_CheckDoubleInvoices__c==op.CompanyCodeFields[0].CheckDoubleInvoices))     
          )
        {
            isFinancialSensitiveDetailsChanged=true;
        }
        else
        {
            isFinancialSensitiveDetailsChanged=false;
        }

        display_list.add(new ApprovalFlagWrapper(isFinancialSensitiveDetailsChanged, 
                                                 isPaymentTermsDetailsChanged));
        return display_list; 
        
        
        
    }
        
        
    
   /* public VPM_PurchasingRequests__c  webServiceData(VPM_ECCVendorSearchServiceOutput op){ 
        VPM_PurchasingRequests__c Vendordtl= new VPM_PurchasingRequests__c();
        
        
      
        if(op.CompanyCodeFields <> null && op.CompanyCodeFields.size() > 0) {
            
            // Financial Sensitive Details
            Vendordtl.VPM_ReconciliationAccount__c == op.CompanyCodeFields[0].ReconciliationAccount;
            Vendordtl.VPM_PaymentMethod__c = op.CompanyCodeFields[0].PaymentMethod;
            Vendordtl.VPM_CashManagementGroup__c = op.CompanyCodeFields[0].CashManagementGroup;
            Vendordtl.VPM_SortKey__c = op.CompanyCodeFields[0].SortKey;
            Vendordtl.VPM_CheckDoubleInvoices__c = op.CompanyCodeFields[0].CheckDoubleInvoices <>null?op.CompanyCodeFields[0].CheckDoubleInvoices:false;
            Vendordtl.VPM_PaymentBlock__c = op.PaymentBlock;
            //Payment Terms 
             Vendordtl.VPM_PaymentTerms__c = op.CompanyCodeFields[0].PaymentTerms;
            // Bank Details 
        }
        
         

        
        
        
        return Vendordtl;
    } */ 
        
        
        

}