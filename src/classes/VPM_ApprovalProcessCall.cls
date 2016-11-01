global class  VPM_ApprovalProcessCall {
    
    public VPM_ECCVendorSearchServiceOutput op;
    public VPM_PurchasingRequests__c purchReqVar {get;set;}      
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
    
    Public string SetApprovalFlag(VPM_PurchasingRequests__c purchReqVar)
    {
        
       string ReturnResult;
        /* String isPaymentTermsDetailsChanged;
        String isFinancialSensitiveDetailsChanged;
       
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
   
       /* if(purchReqVar.VPM_PaymentTerms__c !=null  ||(purchReqVar.VPM_PaymentTerms__c == op.CompanyCodeFields[0].PaymentTerms))
          isPaymentTermsDetailsChanged='Yes';
        else
            isPaymentTermsDetailsChanged='No'; */
        
        //isFinancialSensitiveDetailsChanged
        
      /*  if((purchReqVar.VPM_ReconciliationAccount__c!= null &&
            (purchReqVar.VPM_ReconciliationAccount__c == op.CompanyCodeFields[0].ReconciliationAccount))
           ||
           (purchReqVar.VPM_PaymentMethod__c !=null && (purchReqVar.VPM_PaymentMethod__c == op.CompanyCodeFields[0].PaymentMethod))
           ||
           (purchReqVar.VPM_CashManagementGroup__c!= null && (purchReqVar.VPM_CashManagementGroup__c == op.CompanyCodeFields[0].CashMgmtGroup))
           ||
           (purchReqVar.VPM_SortKey__c!=null && (purchReqVar.VPM_SortKey__c == op.CompanyCodeFields[0].SortKey))
           ||
           (purchReqVar.VPM_PaymentBlock__c !=null &&(purchReqVar.VPM_PaymentBlock__c == op.PaymentBlock))
            ||
            (purchReqVar.VPM_CheckDoubleInvoices__c ==true &&(purchReqVar.VPM_CheckDoubleInvoices__c==op.CompanyCodeFields[0].CheckDoubleInvoices))     
          )
        {
            isFinancialSensitiveDetailsChanged='Yes';
        }
        else
        {
            isFinancialSensitiveDetailsChanged='No';
        }
        ReturnResult =isPaymentTermsDetailsChanged +'^'+isFinancialSensitiveDetailsChanged; */ 
        
        Return ReturnResult; 
    }
}