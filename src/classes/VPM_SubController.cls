/*********************************************************************************
Name:  VPM_SubController 
Copyright ? 2016  Unilever
==================================================================================
==================================================================================
Purpose:  Controller Extension for SendWebform , Payment Terms & Financially Sensitive

-------                                                             
===================================================================================
===================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                  Description
1.0 -   Samrin Shaikh       14/06/2016       INITIAL DEVELOPMENT      Controller Extension for SendWebform , Payment Terms & Financially Sensitiv

***********************************************************************************/


public class VPM_SubController {
    
    public  boolean ShowFeed {get;set;}

    public VPM_PurchasingRequests__c pr{get;set;}   
    public VPM_ECCVendorSearchServiceOutput vendorDetailsServiceOutput{get; set;}
    public ApexPages.StandardController newController;
    
    public Boolean isRequiredField{get;set;} 
    Public Boolean isBlockDeleted {get;set;}
    Public Boolean isUnBlockUnDeleted {get;set;}
    public Boolean isRequiredIncoterms2{get;set;}   
    
    public Id purid{get;set;}
    
    public String positions {get; set;}
    public String options {get;set;}    
    public string UnblockBlockUnDeleteDelete {get;set;} 
    public string DeletionBlockFlag  {get;set;}
    public string wsAccountHolderName{get; set;}
    public string wsBankCountryKey{get; set;}
    public string wsBankKey{get; set;}
    public string wsBankAccountNumber{get; set;}
    public string wsReferenceSpecificationsBankDetail{get; set;}
    public string wsBankControlKey{get; set;}
    public string wsIBAN{get; set;}
    public string wsCollectionAuthorization{get; set;}
    public string wsPartnerBankType{get; set;}
    public string wsBankName{get; set;}
    public string wsSwiftKey{get; set;}
    public User UserVar{get;set;}
    public string userlang{get;set;}   
    public string MaintainStatus{get;set;} 
    //for financialsensitive 
    public string wsReconciliationAccount{get;set;} 
    public string wsPaymentMethod{get;set;}
    public string wsGRbasedIV{get;set;} 
    public string wsPurchaseOrderText{get;set;}
    public string wsPaymentBlock{get;set;}
    public string wsAlternativePayee{get;set;}
    //for payment terms
    public string wsPaymentTerms{get;set;}
    //for vendor details
    public string wsAccountGroup{get;set;}
    public string wsCompanyCode{get;set;}
    public string wsVendorName1{get;set;}
    public string wsVendorName2{get;set;}
    public string wsName3{get;set;}
    public string wsName4{get;set;}
    public string wsHouseNumber{get;set;}
    public string wsHouseNumSupplement{get;set;}
    public string wsStreet1{get;set;}
    public string wsStreet2{get;set;}
    public string wsStreet3{get;set;}
    public string wsStreet4{get;set;}
    public string wsStreet5{get;set;}
    public string wsDistrict{get;set;}
    public string wsZIPPostcode{get;set;}
    public string wsCity{get;set;}
    public string wsRegion{get;set;}
    public string wsCountry{get;set;}
    public string wsTransportZone{get;set;}
    public string wsAddressTimeZone{get;set;}
    public string wsIntLocationNumber1{get;set;}
    public string wsIntLocationNumber2{get;set;}
    public string wsOrderingEmailAddress{get;set;}
    public string wsTaxNumber1{get;set;}
    public string wsTaxNumber2{get;set;}
    public string wsTaxNumber3{get;set;}
    public string wsTaxNumber4{get;set;}
    public string wsTaxNumber5{get;set;}
    public string wsTaxNumberType{get;set;}
    public string wsTaxType{get;set;}
    public string wsVATRegistrationNumber{get;set;}
    public string wsVATRegistrationNumber2{get;set;}
    public string wsVATRegistrationNumber3{get;set;}
    public string wsTaxJurisdictionCode{get;set;}
    public string wsCustomer{get;set;}
    public string wsPurchasingOrganisation{get;set;}
    public string wsPartnerFunctions{get;set;}
    public string wsAuthorization{get;set;} 
    public boolean InternationalVersion{get;set;}
    public  List<SelectOption> purchasingOrg{get;set;}
    public string vendorPurchasingOrg{get;set;} 
    
     public  List<SelectOption> Cashmgmntgroup{get;set;}
    public string vendorCashmgmntgroup{get;set;} 
    
    public  List<SelectOption> VenLanguage{get;set;}
    public string vendorLanguage{get;set;} 
    
    public  List<SelectOption> AccountStatement{get;set;}
    public string vendorAccountStatement{get;set;} 
    
    
    public  List<SelectOption> PaymentBlock{get;set;}
    public string vendorPaymentBlock{get;set;} 
    
  public  List<SelectOption> GroupingKey{get;set;}
    public string vendorGroupingKey{get;set;} 
    
 public  List<SelectOption> SchemaGroupVendor{get;set;}
    public string vendorSchemaGroupVendor{get;set;} 
    
    public  List<SelectOption> Incoterms1{get;set;}
    public string vendorIncoterms1{get;set;} 
    
    public  List<SelectOption> BankCountryKey{get;set;}
    public string vendorBankCountryKey{get;set;} 
    
    VPM_PurchasingRequests__c  vendorQuery1{get;set;}  
    VPM_PurchasingRequests__c  vendorQuery2{get;set;}  
    
    public VPM_SubController(ApexPages.StandardController controller) {
        wsReconciliationAccount = VPM_WSOutputVariableClass.ReconciliationAccount ;
        pr= (VPM_PurchasingRequests__c)Controller.getRecord(); 
        purid = pr.id;  
        positions='Yes';
        ShowFeed =false;
        isRequiredField = true;       
        this.newController = controller;
        
        vendorQuery2= [select Id,VPM_VendorName1Int__c,VPM_InternationalVersion__c,VPM_VendorName2Int__c,VPM_VendorName3Int__c,VPM_VendorName4Int__c,VPM_Street1Int__c,VPM_Street2Int__c,VPM_Street3Int__c,VPM_Street4Int__c,VPM_HouseNumberInt__c,VPM_SearchTerm1Int__c,VPM_PostCodeInt__c,VPM_CityInt__c,VPM_CountryInt__c  from VPM_PurchasingRequests__c where id = : purid];

        
        if(vendorQuery2.VPM_VendorName1Int__c!=null || vendorQuery2.VPM_VendorName2Int__c!=null || vendorQuery2.VPM_VendorName3Int__c!=null || 
           vendorQuery2.VPM_VendorName4Int__c!=null || vendorQuery2.VPM_Street1Int__c!=null || vendorQuery2.VPM_Street2Int__c!=null || vendorQuery2.VPM_Street3Int__c!=null || 
           vendorQuery2.VPM_Street4Int__c!=null || vendorQuery2.VPM_HouseNumberInt__c!=null || vendorQuery2.VPM_SearchTerm1Int__c!=null || vendorQuery2.VPM_PostCodeInt__c!=null || 
           vendorQuery2.VPM_CityInt__c!=null || vendorQuery2.VPM_CountryInt__c!=null){
               if(vendorQuery2.VPM_InternationalVersion__c == null){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error, 'Please select International Version'));
               }
           
               
           }
        
        
        
        vendorQuery1 = [select Id,VPM_ECCSystem__c ,VPM_VendordoesntExistFlag__c,VPM_VendorContactDetail__c,VPM_ReconciliationAccount__c,VPM_BankCountryKey__c, VPM_Comments__c, VPM_VendorName1__c, VPM_VendorPhone__c,
                          recordTypeId,VPM_CompanyCode__r.VPM_CompanyCode__c,VPM_CompanyCode__r.ECC__c,VPM_VendorCodeLookup__r.mdm_Code__c,VPM_VendorType__c,
                          VPM_Regions__c,createdbyid,VPM_PurchasingOrganisation__c,VPM_CashManagementGroup__c,VPM_Language__c,VPM_AccountStatement__c,VPM_PaymentBlock__c,VPM_GroupingKey__c,VPM_SchemaGroupVendor__c,VPM_Incoterms1__c, VPM_ECC__c from VPM_PurchasingRequests__c where id = : purid];

        UserVar = [SELECT Id, name, Email, userRoleId, userRole.name, phone from User where id= :vendorQuery1.createdbyid];
        system.debug('@@pr=' +UserVar);
        userlang = [select LanguageLocaleKey from User where Id=:UserInfo.getUserId()].LanguageLocaleKey;
        system.debug('@@userlang=' +userlang); 
        
        
        vendorPurchasingOrg = vendorQuery1.VPM_PurchasingOrganisation__c== null ? 'None':vendorQuery1.VPM_PurchasingOrganisation__c;
        vendorCashmgmntgroup =vendorQuery1.VPM_CashManagementGroup__c== null ? 'None':vendorQuery1.VPM_CashManagementGroup__c;
        system.debug('@@ vendorQuery1.VPM_Language__c' + vendorQuery1.VPM_Language__c);
        vendorLanguage=vendorQuery1.VPM_Language__c== null ? 'None':vendorQuery1.VPM_Language__c;
        vendorAccountStatement=vendorQuery1.VPM_AccountStatement__c== null ? 'None':vendorQuery1.VPM_AccountStatement__c;
        vendorPaymentBlock=vendorQuery1.VPM_PaymentBlock__c== null ? 'None':vendorQuery1.VPM_PaymentBlock__c;
        vendorGroupingKey=vendorQuery1.VPM_GroupingKey__c== null ? 'None':vendorQuery1.VPM_GroupingKey__c;
        vendorIncoterms1=vendorQuery1.VPM_Incoterms1__c== null ? 'None':vendorQuery1.VPM_Incoterms1__c;
        vendorSchemaGroupVendor=vendorQuery1.VPM_SchemaGroupVendor__c== null ? 'None':vendorQuery1.VPM_SchemaGroupVendor__c;
        vendorBankCountryKey=vendorQuery1.VPM_BankCountryKey__c== null ? 'None':vendorQuery1.VPM_BankCountryKey__c;
        
        if(vendorQuery1.VPM_CompanyCode__r.ecc__c <> '' || vendorQuery1.VPM_CompanyCode__r.ecc__c <> null)
           pr.VPM_ECC__c = vendorQuery1.VPM_CompanyCode__r.ecc__c;
           
           purchasingOrg = getPurchasingOrgItems();
           Cashmgmntgroup =getCashmgmntgroupItems();
            VenLanguage=getVenLanguageItems();
            AccountStatement=getAccountStatement();
            PaymentBlock=getPaymentBlock();
           GroupingKey=getGroupingKey();
            Incoterms1=getIncoterms1();
            SchemaGroupVendor=getSchemaGroupVendor();
            BankCountryKey=getBankCountryKey();
        
        IF( this.positions == 'Yes')
        {
            isRequiredField = true;         
        }else {
            isRequiredField = false;
        }
        
        //incoterms1 check is blank or not
        
        system.debug('@@ vendorIncoterms1'+ vendorIncoterms1);
        if(vendorIncoterms1<>'None'){
            isRequiredIncoterms2=true;
        }
        else
        {
            isRequiredIncoterms2 =false;
        
        }
        // Block Un Block Delete UnDlete Logic Start 
        UnblockBlockUnDeleteDelete = ApexPages.currentPage().getParameters().get('maintainScreen');
        System.debug('@@@@@@ UnblockBlockUnDeleteDelete Status -----------'+UnblockBlockUnDeleteDelete);
        //  UnblockBlockUnDeleteDelete='Maintain1';
        if(UnblockBlockUnDeleteDelete<> '' || UnblockBlockUnDeleteDelete <> null)
        {
            if(UnblockBlockUnDeleteDelete==System.Label.VPM_BlockDeleteFlag)
            {            
                isBlockDeleted=true;
                isUnBlockUnDeleted=false;       
            }
            else
            {
                isBlockDeleted=false;
                isUnBlockUnDeleted=true;
            }
        }
        try {
            if(VPM_RecordTypeHelper.getLaunchScreenVariable(null,vendorQuery1.recordTypeId) == 'Maintain') {
                vendorDetailsServiceOutput = FetchVendorDeatilSAPService(vendorQuery1.VPM_VendorCodeLookup__r.mdm_Code__c, vendorQuery1.VPM_CompanyCode__r.ECC__c, vendorQuery1.VPM_CompanyCode__r.VPM_CompanyCode__c);
                webServiceData();
         }      
        // system.debug('###vendorDetailsServiceOutput '+vendorDetailsServiceOutput);
        }
        catch(exception ex){
            system.debug('@@EXception' +ex.getStackTraceString());
        }
    }


     public boolean getInternational()
     { 
        if(vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Cordillera' || vendorQuery1.VPM_CompanyCode__r.ECC__c == 'Fusion')
        {
        InternationalVersion = true;
        }
        
        else
        {
        InternationalVersion = false;
        }    
    
    return InternationalVersion ;
     }

    public void webServiceData(){
        
        //pr.VPM_ABCIndicator__c = vendorDetailsServiceOutput.ABCIndicator;
        pr.VPM_AccntWithVendor__c = vendorDetailsServiceOutput.AccntWithVendor;
        pr.VPM_AccountClerkTelephoneNumber__c = vendorDetailsServiceOutput.AccountClerkTelephoneNumber;
        pr.VPM_AccountGroup__c = vendorDetailsServiceOutput.AccountGroup;
        //pr.VPM_AccountHolderName__c = vendorDetailsServiceOutput.AccountHolderName;
        pr.VPM_AccountingClerk__c = vendorDetailsServiceOutput.AccountingClerk;
        pr.VPM_AccountingNote__c = vendorDetailsServiceOutput.AccountingNote;
        pr.VPM_AccountingText__c = vendorDetailsServiceOutput.AccountingText;
        pr.VPM_AccountMemo__c = vendorDetailsServiceOutput.AccountMemo;
        //pr.VPM_AccountStatement__c = vendorDetailsServiceOutput.AccountStatement;
        pr.VPM_ActualQMSystem__c = vendorDetailsServiceOutput.ActualQMSystem;
        pr.VPM_AddressForm__c = vendorDetailsServiceOutput.AddressForm;
        pr.VPM_AddressTimeZone__c = vendorDetailsServiceOutput.AddressTimeZone;
        //pr.VPM_AdoptScanDate__c = vendorDetailsServiceOutput.AdoptScanDate;
        //pr.VPM_AlternativePayee__c = vendorDetailsServiceOutput.AlternativePayee;
        //pr.VPM_AlternativePayeeAccountNumber__c = vendorDetailsServiceOutput.AlternativePayeeAccountNumber;
        //pr.VPM_AltPayeeAccountNum__c = vendorDetailsServiceOutput.AltPayeeAccountNum;
        pr.VPM_ArabiaOldNumber__c = vendorDetailsServiceOutput.ArabiaOldNumber;
        pr.VPM_ArabicVersion__c = vendorDetailsServiceOutput.ArabicVersion;
        pr.VPM_Authorization__c = vendorDetailsServiceOutput.Authorization;
        //pr.VPM_AutoEvalGRSetmtDel__c = vendorDetailsServiceOutput.AutoEvalGRSetmtDel;
        //pr.VPM_AutoEvalGRSetmtRet__c = vendorDetailsServiceOutput.AutoEvalGRSetmtRet;
        //pr.VPM_AutoGenerationPOAllowed__c = vendorDetailsServiceOutput.AutoGenerationPOAllowed;
        //pr.VPM_BankAccountNumber__c = vendorDetailsServiceOutput.BankAccountNumber;
        //pr.VPM_BankControlKey__c = vendorDetailsServiceOutput.BankControlKey;
        //pr.VPM_BankCountryKey__c = vendorDetailsServiceOutput.BankCountryKey;
        //pr.VPM_BankKey__c = vendorDetailsServiceOutput.BankKey;
        //pr.VPM_BankName__c = vendorDetailsServiceOutput.BankName;
        //pr.VPM_BankNumber__c = vendorDetailsServiceOutput.BankNumber;
        pr.VPM_BeneficiaryAddress1__c = vendorDetailsServiceOutput.BeneficiaryAddress1;
        pr.VPM_BeneficiaryAddress2__c = vendorDetailsServiceOutput.BeneficiaryAddress2;
        pr.VPM_BeneficiaryAddress3__c = vendorDetailsServiceOutput.BeneficiaryAddress3;
        pr.VPM_BeneficiaryCountry__c = vendorDetailsServiceOutput.BeneficiaryCountry;
        pr.VPM_BeneficiaryName__c = vendorDetailsServiceOutput.BeneficiaryName;
        //pr.VPM_BExchangeLimit__c = vendorDetailsServiceOutput.BExchangeLimit;
        //pr.VPM_Blocked__c = vendorDetailsServiceOutput.Blocked;
        pr.VPM_BlockFunction__c = vendorDetailsServiceOutput.BlockFunction;
        pr.VPM_CarFreightGroup__c = vendorDetailsServiceOutput.CarFreightGroup;
        //pr.VPM_CashManagementGroup__c = vendorDetailsServiceOutput.CashManagementGroup;
        //pr.VPM_catorPantLevel__c = vendorDetailsServiceOutput.catorPantLevel;
        //pr.VPM_catorVendorSubRange__c = vendorDetailsServiceOutput.catorVendorSubRange;
        //pr.VPM_CentralDeletionFlag__c = vendorDetailsServiceOutput.CentralDeletionFlag;
        //pr.VPM_CentralPostingBlock__c = vendorDetailsServiceOutput.CentralPostingBlock;
        //pr.VPM_CentralPurchasingBlock__c = vendorDetailsServiceOutput.CentralPurchasingBlock;
        pr.VPM_CENVAT__c = vendorDetailsServiceOutput.CENVAT;
        pr.VPM_CertificateWithholdingTaxExemption__c = vendorDetailsServiceOutput.CertificateWithholdingTaxExemption;
        //pr.VPM_CertificationDate__c = vendorDetailsServiceOutput.CertificationDate;
        pr.VPM_ChangedBy__c = vendorDetailsServiceOutput.ChangedBy;
        pr.VPM_Changedon__c = vendorDetailsServiceOutput.Changedon;
        //pr.VPM_CheckDigit__c = vendorDetailsServiceOutput.CheckDigit; // data value too large
        //pr.VPM_CheckDoubleInvoices__c = vendorDetailsServiceOutput.CheckDoubleInvoices;
        pr.VPM_ChkCashing__c = vendorDetailsServiceOutput.ChkCashing;
        pr.VPM_City__c = vendorDetailsServiceOutput.City;
        pr.VPM_ClerkAtVendor__c = vendorDetailsServiceOutput.ClerkAtVendor;
        pr.VPM_ClerksFax__c = vendorDetailsServiceOutput.ClerksFax;
        pr.VPM_ClerksInternet__c = vendorDetailsServiceOutput.ClerksInternet;
        //pr.VPM_CollectionAuthorization__c = vendorDetailsServiceOutput.CollectionAuthorization;
        pr.VPM_Commissionerate__c = vendorDetailsServiceOutput.Commissionerate;
        //pr.VPM_CompanyCode__c = vendorDetailsServiceOutput.CompanyCode;
        pr.VPM_CompanyPostCode__c = vendorDetailsServiceOutput.CompanyPostCode;
        pr.VPM_ConfirmationControl__c = vendorDetailsServiceOutput.ConfirmationControl;
        pr.VPM_ContactPerson__c = vendorDetailsServiceOutput.ContactPerson;
        pr.VPM_ContactPersonSurname__c = vendorDetailsServiceOutput.ContactPersonSurname;
        pr.VPM_CorporateGrp__c = vendorDetailsServiceOutput.CorporateGrp;
        pr.VPM_CorrespondentBank__c = vendorDetailsServiceOutput.CorrespondentBank;
        pr.VPM_Country__c = vendorDetailsServiceOutput.Country;
        pr.VPM_CreditInfoNumber__c = vendorDetailsServiceOutput.CreditInfoNumber;
        pr.VPM_CSTno__c = vendorDetailsServiceOutput.CSTno;
        pr.VPM_Customer__c = vendorDetailsServiceOutput.Customer;
        pr.VPM_DataLine__c = vendorDetailsServiceOutput.DataLine;
        //pr.VPM_DateOfBirth__c = vendorDetailsServiceOutput.DateOfBirth;
        //pr.VPM_DefaultPartner__c = vendorDetailsServiceOutput.DefaultPartner;
        //pr.VPM_Deleted__c = vendorDetailsServiceOutput.Deleted;
        pr.VPM_Department__c = vendorDetailsServiceOutput.Department;
        pr.VPM_DepartmentDescription__c = vendorDetailsServiceOutput.DepartmentDescription;
        pr.VPM_DepartmentNumber__c = vendorDetailsServiceOutput.DepartmentNumber;
        pr.VPM_Description__c = vendorDetailsServiceOutput.Description;
        pr.VPM_District__c = vendorDetailsServiceOutput.District;
       // pr.VPM_DMEIndicator__c = vendorDetailsServiceOutput.DMEIndicator;
        //pr.VPM_DocIndexActive__c = vendorDetailsServiceOutput.DocIndexActive;
        pr.VPM_DunningBlock__c = vendorDetailsServiceOutput.DunningBlock;
        pr.VPM_DunningClerk__c = vendorDetailsServiceOutput.DunningClerk;
        pr.VPM_DunningLevel__c = vendorDetailsServiceOutput.DunningLevel;
        pr.VPM_DunnProcedure__c = vendorDetailsServiceOutput.DunnProcedure;
        pr.VPM_DunnRecipient__c = vendorDetailsServiceOutput.DunnRecipient;
        pr.VPM_ECC__c = vendorDetailsServiceOutput.ECC;
        pr.VPM_ECCNo__c = vendorDetailsServiceOutput.ECCNo;
        //pr.VPM_Email__c = vendorDetailsServiceOutput.Email;
        //pr.VPM_Email2__c = vendorDetailsServiceOutput.Email2;
        //pr.VPM_Email3__c = vendorDetailsServiceOutput.Email3;
        //pr.VPM_EqualisationTax__c = vendorDetailsServiceOutput.EqualisationTax;
        pr.VPM_ExcIndVendor__c = vendorDetailsServiceOutput.ExcIndVendor;
        pr.VPM_ExciseDivision__c = vendorDetailsServiceOutput.ExciseDivision;
        //pr.VPM_ExciseRange__c = vendorDetailsServiceOutput.ExciseRange;
        //pr.VPM_ExciseRegNo__c = vendorDetailsServiceOutput.ExciseRegNo;
        //pr.VPM_ExemptionFrom__c = vendorDetailsServiceOutput.ExemptionFrom;
        pr.VPM_ExemptionNumber__c = vendorDetailsServiceOutput.ExemptionNumber;
        //pr.VPM_ExemptionRate__c = vendorDetailsServiceOutput.ExemptionRate;
        //pr.VPM_ExemptionTo__c = vendorDetailsServiceOutput.ExemptionTo;
        pr.VPM_Extension2__c = vendorDetailsServiceOutput.Extension2;
        pr.VPM_Extension3__c = vendorDetailsServiceOutput.Extension3;
        pr.VPM_ExtensionPhone__c = vendorDetailsServiceOutput.ExtensionPhone;
        pr.VPM_ExternalMFG__c = vendorDetailsServiceOutput.ExternalMFG;
        pr.VPM_Fax__c = vendorDetailsServiceOutput.Fax;
        pr.VPM_FaxExtension__c = vendorDetailsServiceOutput.FaxExtension;
        pr.VPM_FaxNumber2__c = vendorDetailsServiceOutput.FaxNumber2;
        pr.VPM_FaxNumber3__c = vendorDetailsServiceOutput.FaxNumber3;
        pr.VPM_FiscalAddress__c = vendorDetailsServiceOutput.FiscalAddress;
        pr.VPM_FreeText1__c = vendorDetailsServiceOutput.FreeText1;
        pr.VPM_FreeText2__c = vendorDetailsServiceOutput.FreeText2;
        pr.VPM_Function__c = vendorDetailsServiceOutput.Function;
        pr.VPM_FunctionDescription__c = vendorDetailsServiceOutput.FunctionDescription;
        //pr.VPM_GrantDiscInKind__c = vendorDetailsServiceOutput.GrantDiscInKind;
        //pr.VPM_GRbasedIV__c = vendorDetailsServiceOutput.GRbasedIV;
        //pr.VPM_GroupingKey__c = vendorDetailsServiceOutput.GroupingKey;
        pr.VPM_HeadOfficeAccountNumber__c = vendorDetailsServiceOutput.HeadOfficeAccountNumber;
        pr.VPM_HouseBank__c = vendorDetailsServiceOutput.HouseBank;
        pr.VPM_HouseNumber__c = vendorDetailsServiceOutput.HouseNumber;
        pr.VPM_HouseNumSupplement__c = vendorDetailsServiceOutput.HouseNumSupplement;
        //pr.VPM_IBAN__c = vendorDetailsServiceOutput.IBAN;
        //pr.VPM_icate__c = vendorDetailsServiceOutput.icate;
        //pr.VPM_Incoterms1__c = vendorDetailsServiceOutput.Incoterms1;
        pr.VPM_Incoterms2__c = vendorDetailsServiceOutput.Incoterms2;
        //pr.VPM_IndicatorAlternativePayeeAllowed__c = vendorDetailsServiceOutput.IndicatorAlternativePayeeAllowed;
        //pr.VPM_IndicatorClearingBetwCustomerNVendor__c = vendorDetailsServiceOutput.IndicatorClearingBetwCustomerNVendor;
        //pr.VPM_IndicatorCollectionAuthorization__c = vendorDetailsServiceOutput.IndicatorCollectionAuthorization;
        pr.VPM_IndicatorForWithholdingTaxType__c = vendorDetailsServiceOutput.IndicatorForWithholdingTaxType;
        //pr.VPM_IndicatorPayItemsSeparately__c = vendorDetailsServiceOutput.IndicatorPayItemsSeparately;
        //pr.VPM_IndicatorPlantLevelRelevant__c = vendorDetailsServiceOutput.IndicatorPlantLevelRelevant;
        pr.VPM_IndicatorSubjectToWithholdingTax__c = vendorDetailsServiceOutput.IndicatorSubjectToWithholdingTax;
        //pr.VPM_IndicatorVendorSubRangeRelevant__c = vendorDetailsServiceOutput.IndicatorVendorSubRangeRelevant;
        //pr.VPM_IndividualPayment__c = vendorDetailsServiceOutput.IndividualPayment;
        pr.VPM_IndividualSpec__c = vendorDetailsServiceOutput.IndividualSpec;
        pr.VPM_IndonesiaOldVendorNumber__c = vendorDetailsServiceOutput.IndonesiaOldVendorNumber;
        pr.VPM_Industry__c = vendorDetailsServiceOutput.Industry;
        pr.VPM_IndustryType__c = vendorDetailsServiceOutput.IndustryType;
        pr.VPM_InstructionKeyDataExchange__c = vendorDetailsServiceOutput.InstructionKeyDataExchange;
        pr.VPM_InterestCalculationIndicator__c = vendorDetailsServiceOutput.InterestCalculationIndicator;
        pr.VPM_InterestFrequency__c = vendorDetailsServiceOutput.InterestFrequency;
        pr.VPM_InternationalVersion__c = vendorDetailsServiceOutput.InternationalVersion;
        pr.VPM_IntLocationNumber1__c = vendorDetailsServiceOutput.IntLocationNumber1;
        pr.VPM_IntLocationNumber2__c = vendorDetailsServiceOutput.IntLocationNumber2;
        pr.VPM_IsraelOldNumber__c = vendorDetailsServiceOutput.IsraelOldNumber;
        pr.VPM_ISRNumber__c = vendorDetailsServiceOutput.ISRNumber;
        //pr.VPM_Language__c = vendorDetailsServiceOutput.Language;
        //pr.VPM_Local2Version__c= vendorDetailsServiceOutput.String Local2Version;
        //pr.VPM_LastKeyDate__c = vendorDetailsServiceOutput.String LastKeyDate;
        pr.VPM_LanguageKeyCOCode__c = vendorDetailsServiceOutput.LanguageKeyCOCode;
        //pr.VPM_LastDunned__c = vendorDetailsServiceOutput.LastDunned;
        //pr.VPM_LastExtReview__c = vendorDetailsServiceOutput.LastExtReview;
        //pr.VPM_LastInterestRun__c = vendorDetailsServiceOutput.LastInterestRun;
        //pr.VPM_LegalDunnProc__c = vendorDetailsServiceOutput.LegalDunnProc;
        //pr.VPM_Liable__c = vendorDetailsServiceOutput.Liable;
        pr.VPM_LLDCode__c = vendorDetailsServiceOutput.LLDCode;
        pr.VPM_LSTno__c = vendorDetailsServiceOutput.LSTno;
        //pr.VPM_MinimumOrderValue__c = vendorDetailsServiceOutput.MinimumOrderValue;
        pr.VPM_MinorityIndicators__c = vendorDetailsServiceOutput.MinorityIndicators;
        pr.VPM_MobilePhone__c = vendorDetailsServiceOutput.MobilePhone;
        pr.VPM_MobilePhone2__c = vendorDetailsServiceOutput.MobilePhone2;
        pr.VPM_MobilePhone3__c = vendorDetailsServiceOutput.MobilePhone3;
        pr.VPM_ModeTransportForeignTrade__c = vendorDetailsServiceOutput.ModeTransportForeignTrade;
        pr.VPM_Name3__c = vendorDetailsServiceOutput.Name3;
        pr.VPM_Name4__c = vendorDetailsServiceOutput.Name4;
        //pr.VPM_NODEL__c = vendorDetailsServiceOutput.NODEL;
        //pr.VPM_NPIVendor__c = vendorDetailsServiceOutput.NPIVendor;
        pr.VPM_OfficeOfEntry__c = vendorDetailsServiceOutput.OfficeOfEntry;
        //pr.VPM_OrderAcknowledgmentRequirement__c = vendorDetailsServiceOutput.OrderAcknowledgmentRequirement;
        pr.VPM_OrderCurrency__c = vendorDetailsServiceOutput.OrderCurrency;
        //pr.VPM_OrderingEmailAddress__c = vendorDetailsServiceOutput.OrderingEmailAddress;
        pr.VPM_OrderOptimRest__c = vendorDetailsServiceOutput.OrderOptimRest;
        pr.VPM_OtherCommunication__c = vendorDetailsServiceOutput.OtherCommunication;
        pr.VPM_OurAccNumWithVendor__c = vendorDetailsServiceOutput.OurAccNumWithVendor;
        pr.VPM_PANNumber__c = vendorDetailsServiceOutput.PANNumber;
        pr.VPM_PANreference__c = vendorDetailsServiceOutput.PANreference;
        //pr.VPM_PartnerBankType__c = vendorDetailsServiceOutput.PartnerBankType;
        pr.VPM_PartnerFunction__c = vendorDetailsServiceOutput.PartnerFunction;
        pr.VPM_PartnerFunctionName__c = vendorDetailsServiceOutput.PartnerFunctionName;
        pr.VPM_PartnerFunctions__c = vendorDetailsServiceOutput.PartnerFunctions;
        pr.VPM_PartnerName__c = vendorDetailsServiceOutput.PartnerName;
        pr.VPM_PartnerNumber__c = vendorDetailsServiceOutput.PartnerNumber;
        pr.VPM_PayableLocation__c = vendorDetailsServiceOutput.PayableLocation;
        //pr.VPM_PaymentBlock__c = vendorDetailsServiceOutput.PaymentBlock;
        pr.VPM_PaymentMethod__c = vendorDetailsServiceOutput.PaymentMethod;
        pr.VPM_PaymentMethodSupplement__c = vendorDetailsServiceOutput.PaymentMethodSupplement;
        pr.VPM_PaymentTerms__c = vendorDetailsServiceOutput.PaymentTerms;
        pr.VPM_PaymentTermsKeyCreditMemos__c = vendorDetailsServiceOutput.PaymentTermsKeyCreditMemos;
        pr.VPM_PermittedPayee__c = vendorDetailsServiceOutput.PermittedPayee;
        pr.VPM_PlaceOfBirth__c = vendorDetailsServiceOutput.PlaceOfBirth;
        //pr.VPM_PlannedDeliveryTime__c = vendorDetailsServiceOutput.PlannedDeliveryTime;
        pr.VPM_Plant__c = vendorDetailsServiceOutput.Plant;
        //pr.VPM_PmtAdviceByEDI__c = vendorDetailsServiceOutput.PmtAdviceByEDI;
        pr.VPM_POBox__c = vendorDetailsServiceOutput.POBox;
        pr.VPM_POBoxCity__c = vendorDetailsServiceOutput.POBoxCity;
        pr.VPM_PODRelevant__c = vendorDetailsServiceOutput.PODRelevant;
        pr.VPM_PostalCode2__c = vendorDetailsServiceOutput.PostalCode2;
        pr.VPM_PreviousAccountNumber__c = vendorDetailsServiceOutput.PreviousAccountNumber;
        pr.VPM_PROATControlProof__c = vendorDetailsServiceOutput.PricingDateControl;
        pr.VPM_ABCIndicator__c = vendorDetailsServiceOutput.PROATControlProof;
        pr.VPM_Profession_c__c = vendorDetailsServiceOutput.Profession;
        pr.VPM_ABCIndicator__c = vendorDetailsServiceOutput.Profession_c;
        pr.VPM_ABCIndicator__c = vendorDetailsServiceOutput.PurchaseOrderText;
        pr.VPM_ABCIndicator__c = vendorDetailsServiceOutput.PurchasingGroup;
        pr.VPM_PurchasingGroup__c = vendorDetailsServiceOutput.PurchasingOrganisation;
        //pr.VPM_QMSystemTo__c = vendorDetailsServiceOutput.QMSystemTo;
        //pr.VPM_RackJobbingServiceAgreed__c = vendorDetailsServiceOutput.RackJobbingServiceAgreed;
        pr.VPM_OtherCommunication__c = vendorDetailsServiceOutput.OtherCommunication;
        pr.VPM_ReasonForExemption__c = vendorDetailsServiceOutput.ReasonForExemption;
        pr.VPM_RecipientType__c = vendorDetailsServiceOutput.RecipientType;
        pr.VPM_ReconciliationAccount__c = vendorDetailsServiceOutput.ReconciliationAccount;
        //pr.VPM_ReferenceSpecificationsBankDetail__c = vendorDetailsServiceOutput.RefSpecBankDetails;
        pr.VPM_Region__c = vendorDetailsServiceOutput.Region;
        pr.VPM_RegStGrp__c = vendorDetailsServiceOutput.RegStGrp;
        //pr.VPM_RelevantForPriceDet__c = vendorDetailsServiceOutput.RelevantForPriceDet;
        //pr.VPM_ReturnsVendor__c = vendorDetailsServiceOutput.ReturnsVendor;
        pr.VPM_RoundingProfile__c = vendorDetailsServiceOutput.RoundingProfile;
        pr.VPM_RussianVersion__c = vendorDetailsServiceOutput.RussianVersion;
        pr.VPM_SalesPerson__c = vendorDetailsServiceOutput.SalesPerson;
        //pr.VPM_SalesPurchTax__c = vendorDetailsServiceOutput.SalesPurchTax;
        pr.VPM_SAPECCComments__c = vendorDetailsServiceOutput.SAPComments;
        pr.VPM_SCAC__c = vendorDetailsServiceOutput.SCAC;
        //pr.VPM_SchemaGroupVendor__c = vendorDetailsServiceOutput.SchemaGroupVendor;
        //pr.VPM_SearchTerm1__c = vendorDetailsServiceOutput.SearchTerm1;
        pr.VPM_SearchTerm2__c = vendorDetailsServiceOutput.SearchTerm2;
        pr.VPM_SerRegNo__c = vendorDetailsServiceOutput.SerRegNo;
        pr.VPM_ServiceAgent__c = vendorDetailsServiceOutput.ServiceAgent;
        pr.VPM_Sex__c = vendorDetailsServiceOutput.Sex;
        pr.VPM_ShippingConditions__c = vendorDetailsServiceOutput.ShippingConditions;
        //pr.VPM_SMSIndicator__c = vendorDetailsServiceOutput.SMSIndicator;
        pr.VPM_SocialInsurance__c = vendorDetailsServiceOutput.SocialInsurance;
        pr.VPM_SocialInsuranceCodeSoc__c = vendorDetailsServiceOutput.SocialInsuranceCode;
        pr.VPM_SortCriterion__c = vendorDetailsServiceOutput.SortCriterion;
        pr.VPM_SortKey__c = vendorDetailsServiceOutput.SortKey;
        //pr.VPM_SRVBasedVendorID__c = vendorDetailsServiceOutput.SRVBasedVendorID;
        pr.VPM_SSIStatus__c = vendorDetailsServiceOutput.SSIStatus;
        pr.VPM_StandardCommMethod__c = vendorDetailsServiceOutput.StandardCommMethod;
        pr.VPM_Street1__c = vendorDetailsServiceOutput.Street1;
        pr.VPM_Street2__c = vendorDetailsServiceOutput.Street2;
        pr.VPM_Street3__c = vendorDetailsServiceOutput.Street3;
        pr.VPM_Street4__c = vendorDetailsServiceOutput.Street4;
        pr.VPM_Street5__c = vendorDetailsServiceOutput.Street5;
        pr.VPM_SubsequentSettlement__c = vendorDetailsServiceOutput.SubsequentSettlement;
        pr.VPM_SubsequentSettlementIndex__c = vendorDetailsServiceOutput.SubsequentSettlementIndex;
        //pr.VPM_SwiftKey__c = vendorDetailsServiceOutput.SwiftKey;
        pr.VPM_TaxBase__c = vendorDetailsServiceOutput.TaxBase;
        pr.VPM_TaxJurisdictionCode__c = vendorDetailsServiceOutput.TaxJurisdictionCode;
        pr.VPM_TaxNumber1__c = vendorDetailsServiceOutput.TaxNumber1;
        pr.VPM_TaxNumber2__c = vendorDetailsServiceOutput.TaxNumber2;
        pr.VPM_TaxNumber3__c = vendorDetailsServiceOutput.TaxNumber3;
        pr.VPM_TaxNumber4__c = vendorDetailsServiceOutput.TaxNumber4;
        pr.VPM_TaxNumber5__c = vendorDetailsServiceOutput.TaxNumber5;
        pr.VPM_TaxNumberType__c = vendorDetailsServiceOutput.TaxNumberType;
        pr.VPM_TaxOfficeIdentification__c = vendorDetailsServiceOutput.TaxOfficeIdentification;
        pr.VPM_TAXOfficeIdentLangKey__c = vendorDetailsServiceOutput.TAXOfficeIdentLangKey;
        //pr.VPM_TaxSplit__c = vendorDetailsServiceOutput.TaxSplit;
        pr.VPM_TaxType__c = vendorDetailsServiceOutput.TaxType;
        pr.VPM_TeleBox__c = vendorDetailsServiceOutput.TeleBox;
        pr.VPM_Telephone__c = vendorDetailsServiceOutput.Telephone;
        pr.VPM_Telephone2__c = vendorDetailsServiceOutput.Telephone2;
        pr.VPM_Telephone3__c = vendorDetailsServiceOutput.Telephone3;
        pr.VPM_TextToInput__c = vendorDetailsServiceOutput.TextToInput;
        pr.VPM_ThaiOldVendorNumber__c = vendorDetailsServiceOutput.ThaiOldVendorNumber;
        pr.VPM_ThirdPartyAddress1__c = vendorDetailsServiceOutput.ThirdPartyAddress1;
        pr.VPM_ThirdPartyAddress3__c = vendorDetailsServiceOutput.ThirdPartyAddress3;
        pr.VPM_ThirdPartyAddress4__c = vendorDetailsServiceOutput.ThirdPartyAddress4;
        pr.VPM_ThirdPartyName__c = vendorDetailsServiceOutput.ThirdPartyName;
        pr.VPM_Title__c = vendorDetailsServiceOutput.Title;
        pr.VPM_ToleranceGroup__c = vendorDetailsServiceOutput.ToleranceGroup;
        pr.VPM_TradePartnerType__c = vendorDetailsServiceOutput.TradePartnerType;
        pr.VPM_TrainStation__c = vendorDetailsServiceOutput.TrainStation;
        pr.VPM_TransportZone__c = vendorDetailsServiceOutput.TransportZone;
        pr.VPM_TurkeyOldNumber__c = vendorDetailsServiceOutput.TurkeyOldNumber;
        if(pr.VPM_VendorType__c == null || pr.VPM_VendorType__c =='')
        pr.VPM_VendorType__c = vendorDetailsServiceOutput.TypeVendor;
        
        pr.VPM_UkrainianVersion__c = vendorDetailsServiceOutput.UkrainianVersion;
        pr.VPM_UnitOfMeasureGrp__c = vendorDetailsServiceOutput.UnitOfMeasureGrp;
        //pr.VPM_ValidUntil__c = vendorDetailsServiceOutput.ValidUntil;
        pr.VPM_VATRegistrationNumber__c = vendorDetailsServiceOutput.VATRegistrationNumber;
        pr.VPM_VATRegistrationNumber2__c = vendorDetailsServiceOutput.VATRegistrationNumber2;
        pr.VPM_VATRegistrationNumber3__c = vendorDetailsServiceOutput.VATRegistrationNumber3;
        pr.VPM_VendorCode__c = vendorDetailsServiceOutput.VendorCode;
        pr.VPM_VendorName1__c = vendorDetailsServiceOutput.VendorName1;
        pr.VPM_VendorName2__c = vendorDetailsServiceOutput.VendorName2;
        pr.VPM_Name3__c = vendorDetailsServiceOutput.VendorName3;
        pr.VPM_Name4__c = vendorDetailsServiceOutput.VendorName4;
        //pr.VPM_VendorSubRange__c = vendorDetailsServiceOutput.VendorSubRange;
        pr.VPM_WithholdingTaxCode__c = vendorDetailsServiceOutput.WithholdingTaxCode;
        pr.VPM_WithholdingTaxCountryKey__c = vendorDetailsServiceOutput.WithholdingTaxCountryKey;
        pr.VPM_WithholdingTaxIdentificationNumber__c = vendorDetailsServiceOutput.WithholdingTaxIdentificationNumber;
        pr.VPM_ZIPPostcode__c = vendorDetailsServiceOutput.ZIPPostCode;
        
        system.debug('@@Pr' + json.serializePretty(pr));
    }

    /******************************************************************** 

    Created By   : Ajay Rawat
    Created Date : 16th June 2016
    Last Modify  : 
    Description  : Get details of selected vendor from SAP.
    Return Type  : VPM_FetchVendorsDetails.OutputVariables
    ********************************************************************/
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

    public pagereference saveSendWebform() {
        pageReference newPage = null;
        system.debug('@@@@@@@@ Exist Flag Alsana ' +pr.VPM_VendorContactDetail__c);
        this.pr= (VPM_PurchasingRequests__c)newController.getRecord();
        if(newController.save() <> null) {
            pr.RecordTypeId = VPM_RecordTypeHelper.getRecordTypeNameById(VPM_RecordTypeHelper.VendorReqCreateRecordType);
            pr.VPM_VendordoesntExistFlag__c =positions;
            update pr;
            system.debug('@@@@@@@@ After Record update Exist Flag Alsana ' +pr.VPM_VendorContactDetail__c);
        }   
        newPage =  BacktoMenu();  
        return newPage;
    }

// Method to Set the Values for Deletion/Block Flag 
    public string SetDeletionBlockFlag()
    {

        if(UnblockBlockUnDeleteDelete<> '' || UnblockBlockUnDeleteDelete <> null)
        {
        //if(positions<>''||positions<>null)
            if(options != null){
                DeletionBlockFlag=options;
            }
        }
    return DeletionBlockFlag;
    }
    
    public pagereference setIncotermsTrue(){
    
        system.debug('@@ vendorIncoterms1'+ vendorIncoterms1);
        
        if(vendorIncoterms1<>'None'){
            isRequiredIncoterms2=true;
        }
        else
        {
            isRequiredIncoterms2 =false;
        
        }
        return null;
    }


public List<SelectOption> getPurchasingOrgItems(){
       List<VPM_RegionSpecificFields__c> getPicklistValues = VPM_RegionSpecificFields__c.getAll().values();
         List<SelectOption> options = new List<SelectOption>();
          options.add(new SelectOption('','None'));
       for(VPM_RegionSpecificFields__c region:getPicklistValues){
        if(region.Region__c == pr.VPM_ECC__c && region.Picklist_Name__c =='Purchasing Organisation'){
        
           options.add(new SelectOption(region.Picklist_Values__c,region.Picklist_Values__c));
            //purchasingOrg.add(region.Picklist_Values__c);
        }
        system.debug('@@region.Picklist_Values__c'+region.Picklist_Values__c);
        system.debug('@@region.Region__c'+region.Region__c);
        }

            return options;
        }
        
        
public List<SelectOption> getCashmgmntgroupItems(){
       List<VPM_RegionSpecificFields__c> getPicklistValues = VPM_RegionSpecificFields__c.getAll().values();
         List<SelectOption> options = new List<SelectOption>();
          options.add(new SelectOption('','None'));
       for(VPM_RegionSpecificFields__c region:getPicklistValues){
        if(region.Region__c == pr.VPM_ECC__c && region.Picklist_Name__c =='Cash mgmnt group'){
        
           options.add(new SelectOption(region.Picklist_Values__c,region.Picklist_Values__c));
            //purchasingOrg.add(region.Picklist_Values__c);
        }
        system.debug('@@region.Picklist_Values__c'+region.Picklist_Values__c);
        system.debug('@@region.Region__c'+region.Region__c);
        }

            return options;
        }   
        
        public List<SelectOption>  getVenLanguageItems(){
       List<VPM_RegionSpecificFields__c> getPicklistValues = VPM_RegionSpecificFields__c.getAll().values();
         List<SelectOption> options = new List<SelectOption>();
          options.add(new SelectOption('','None'));
       for(VPM_RegionSpecificFields__c region:getPicklistValues){
        if(region.Region__c == pr.VPM_ECC__c && region.Picklist_Name__c =='Language'){
        
           options.add(new SelectOption(region.Picklist_Values__c,region.Picklist_Values__c));
            //purchasingOrg.add(region.Picklist_Values__c);
        }
        system.debug('@@region.Picklist_Values__c'+region.Picklist_Values__c);
        system.debug('@@region.Region__c'+region.Region__c);
        }

            return options;
        }        
     
      public List<SelectOption>  getAccountStatement(){
       List<VPM_RegionSpecificFields__c> getPicklistValues = VPM_RegionSpecificFields__c.getAll().values();
         List<SelectOption> options = new List<SelectOption>();
          options.add(new SelectOption('','None'));
       for(VPM_RegionSpecificFields__c region:getPicklistValues){
        if(region.Region__c == pr.VPM_ECC__c && region.Picklist_Name__c =='Account Statement'){
        
           options.add(new SelectOption(region.Picklist_Values__c,region.Picklist_Values__c));
            //purchasingOrg.add(region.Picklist_Values__c);
        }
        system.debug('@@region.Picklist_Values__c'+region.Picklist_Values__c);
        system.debug('@@region.Region__c'+region.Region__c);
        }

            return options;
        }  
        
        
        
        public List<SelectOption> getPaymentBlock(){
       List<VPM_RegionSpecificFields__c> getPicklistValues = VPM_RegionSpecificFields__c.getAll().values();
         List<SelectOption> options = new List<SelectOption>();
          options.add(new SelectOption('','None'));
       for(VPM_RegionSpecificFields__c region:getPicklistValues){
        if(region.Region__c == pr.VPM_ECC__c && region.Picklist_Name__c =='Payment Block'){
        
           options.add(new SelectOption(region.Picklist_Values__c,region.Picklist_Values__c));
            //purchasingOrg.add(region.Picklist_Values__c);
        }
        system.debug('@@region.Picklist_Values__c'+region.Picklist_Values__c);
        system.debug('@@region.Region__c'+region.Region__c);
        }

            return options;
        }         
        
        
         public List<SelectOption>  getGroupingKey(){
       List<VPM_RegionSpecificFields__c> getPicklistValues = VPM_RegionSpecificFields__c.getAll().values();
         List<SelectOption> options = new List<SelectOption>();
          options.add(new SelectOption('','None'));
       for(VPM_RegionSpecificFields__c region:getPicklistValues){
        if(region.Region__c == pr.VPM_ECC__c && region.Picklist_Name__c =='Grouping Key'){
        
           options.add(new SelectOption(region.Picklist_Values__c,region.Picklist_Values__c));
            //purchasingOrg.add(region.Picklist_Values__c);
        }
        system.debug('@@region.Picklist_Values__c'+region.Picklist_Values__c);
        system.debug('@@region.Region__c'+region.Region__c);
        }

            return options;
        }             

public List<SelectOption> getSchemaGroupVendor(){
       List<VPM_RegionSpecificFields__c> getPicklistValues = VPM_RegionSpecificFields__c.getAll().values();
         List<SelectOption> options = new List<SelectOption>();
          options.add(new SelectOption('','None'));
       for(VPM_RegionSpecificFields__c region:getPicklistValues){
        if(region.Region__c == pr.VPM_ECC__c && region.Picklist_Name__c =='Schema Group Vendor'){
        
           options.add(new SelectOption(region.Picklist_Values__c,region.Picklist_Values__c));
            //purchasingOrg.add(region.Picklist_Values__c);
        }
        system.debug('@@region.Picklist_Values__c'+region.Picklist_Values__c);
        system.debug('@@region.Region__c'+region.Region__c);
        }

            return options;
        }        
     
      public List<SelectOption>  getIncoterms1(){
       List<VPM_RegionSpecificFields__c> getPicklistValues = VPM_RegionSpecificFields__c.getAll().values();
         List<SelectOption> options = new List<SelectOption>();
          options.add(new SelectOption('','None'));
       for(VPM_RegionSpecificFields__c region:getPicklistValues){
        if(region.Region__c == pr.VPM_ECC__c && region.Picklist_Name__c =='Incoterms 1'){
        
           options.add(new SelectOption(region.Picklist_Values__c,region.Picklist_Values__c));
            //purchasingOrg.add(region.Picklist_Values__c);
        }
        system.debug('@@region.Picklist_Values__c'+region.Picklist_Values__c);
        system.debug('@@region.Region__c'+region.Region__c);
        }

            return options;
        }        
     
     
      public List<SelectOption>  getBankCountryKey(){
       List<VPM_RegionSpecificFields__c> getPicklistValues = VPM_RegionSpecificFields__c.getAll().values();
         List<SelectOption> options = new List<SelectOption>();
          options.add(new SelectOption('','None'));
       for(VPM_RegionSpecificFields__c region:getPicklistValues){
        if(region.Region__c == pr.VPM_ECC__c && region.Picklist_Name__c =='Bank Country Key'){
        
           options.add(new SelectOption(region.Picklist_Values__c,region.Picklist_Values__c));
            //purchasingOrg.add(region.Picklist_Values__c);
        }
        system.debug('@@region.Picklist_Values__c'+region.Picklist_Values__c);
        system.debug('@@region.Region__c'+region.Region__c);
        }

            return options;
        }        
     

    public pageReference SaveMethod() 
    { 
       /*system.debug('@@ pr.VPM_ECCSystem__c' + pr.VPM_ECCSystem__c);
       if(!pr.VPM_ECCSystem__c || pr.VPM_ECCSystem__c ==null){
        system.debug('@@ pr.VPM_ECCSystem__c' + pr.VPM_ECCSystem__c);
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error, 'ECC System Value is Required'));
           return null;
       }*/
       
        
        vendorQuery1.VPM_PurchasingOrganisation__c = vendorPurchasingOrg;
        vendorQuery1.VPM_CashManagementGroup__c= vendorCashmgmntgroup;
        system.debug('@@ vendorQuery1.VPM_Language__c' + vendorQuery1.VPM_Language__c);
        vendorQuery1.VPM_Language__c = vendorLanguage;
        vendorQuery1.VPM_AccountStatement__c = vendorAccountStatement;
        vendorQuery1.VPM_PaymentBlock__c = vendorPaymentBlock;
        vendorQuery1.VPM_GroupingKey__c = vendorGroupingKey;
        vendorQuery1.VPM_Incoterms1__c =vendorIncoterms1;
        vendorQuery1.VPM_SchemaGroupVendor__c =vendorSchemaGroupVendor;
        vendorQuery1.VPM_BankCountryKey__c =vendorBankCountryKey;
        update vendorQuery1;
        system.debug('@@ vendorQuery1' + vendorQuery1);
        pageReference newPage = null;
        if(newController.save() != null) {   
            newPage =  BacktoMenu();  
        }
        return newPage;
    }

 public pageReference SaveMethodRegionSpecific() 
    { 
       system.debug('@@ pr.VPM_CheckDoubleInvoices__c' + pr.VPM_CheckDoubleInvoices__c);
       if(!pr.VPM_CheckDoubleInvoices__c || pr.VPM_CheckDoubleInvoices__c ==null){
        system.debug('@@ pr.VPM_CheckDoubleInvoices__c' + pr.VPM_CheckDoubleInvoices__c);
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error, 'Check Double Invoices value is Required'));
           return null;
       }
       
        vendorQuery1.VPM_PurchasingOrganisation__c = vendorPurchasingOrg;
        vendorQuery1.VPM_CashManagementGroup__c= vendorCashmgmntgroup;
        vendorQuery1.VPM_Language__c = vendorLanguage;
        vendorQuery1.VPM_AccountStatement__c = vendorAccountStatement;
        vendorQuery1.VPM_PaymentBlock__c = vendorPaymentBlock;
        vendorQuery1.VPM_GroupingKey__c = vendorGroupingKey;
        vendorQuery1.VPM_Incoterms1__c =vendorIncoterms1;
        vendorQuery1.VPM_SchemaGroupVendor__c =vendorSchemaGroupVendor;
        vendorQuery1.VPM_BankCountryKey__c =vendorBankCountryKey;
        update vendorQuery1;
        pageReference newPage = null;
        if(newController.save() != null) {   
            newPage =  BacktoMenu();  
        }
        return newPage;
    }
    
    
     public pageReference SaveMethodGeneralVendor() 
    { 
       
       
        vendorQuery1.VPM_PurchasingOrganisation__c = vendorPurchasingOrg;
        update vendorQuery1;
        pageReference newPage = null;
        if(newController.save() != null) {   
            newPage =  BacktoMenu();  
        }
        return newPage;
    }
    

    Public Pagereference SaveAndExit()
    {
        try{  
        vendorQuery1.VPM_PurchasingOrganisation__c = vendorPurchasingOrg;
        vendorQuery1.VPM_CashManagementGroup__c= vendorCashmgmntgroup;
        system.debug('@@ vendorQuery1.VPM_Language__c' + vendorQuery1.VPM_Language__c);
        vendorQuery1.VPM_Language__c = vendorLanguage;
        vendorQuery1.VPM_AccountStatement__c = vendorAccountStatement;
        vendorQuery1.VPM_PaymentBlock__c = vendorPaymentBlock;
        vendorQuery1.VPM_GroupingKey__c = vendorGroupingKey;
        vendorQuery1.VPM_Incoterms1__c =vendorIncoterms1;
        vendorQuery1.VPM_SchemaGroupVendor__c =vendorSchemaGroupVendor;
        vendorQuery1.VPM_BankCountryKey__c =vendorBankCountryKey;
        update vendorQuery1;
        
        pageReference newPage = null;
        if(UnblockBlockUnDeleteDelete<> '' || UnblockBlockUnDeleteDelete <> null)
        {
            pr.VPM_DeletionBlockFlag__c= SetDeletionBlockFlag();
            update pr; 
            newPage=BackDetailPage(); 
        }

        else if(newController.save() != null) {
            newPage=BackDetailPage(); 
        }
        return newPage; 
        }
        catch(exception ex){}
        return null;
    }
    
    public PageReference BackDetailPage()
    {
        Pagereference pg =  new Pagereference('/'+purid); 
        pg.setRedirect(true);
        return pg; 
    }
    public PageReference BacktoMenu()
    {   
       string queryString = '&back=true&RecordType=Create'; 
        Pagereference pg =  new Pagereference('/apex/VPM_AdvancedForm?id=' +purid +queryString); 
        pg.setRedirect(true);
        return pg;
    }
    public PageReference save() { 
    try{
    pageReference newPage = null;
    if(UnblockBlockUnDeleteDelete<> '' || UnblockBlockUnDeleteDelete <> null)
        pr.VPM_DeletionBlockFlag__c= SetDeletionBlockFlag();
    else
        pr.VPM_VendordoesntExistFlag__c=positions; 
        update pr;    
        newPage =  BacktoMenu();  
    return newPage;
    }
    catch(exception ex){}
        return null;
    }

    public pageReference newMethod() {
        pr.VPM_VendordoesntExistFlag__c=positions;
        IF( pr.VPM_VendordoesntExistFlag__c== 'Yes')
        {
            isRequiredField = true;
        }else {
            isRequiredField = false;
        }
        return null;    
    }

    public pagereference backToFlow()
    {
        string queryString = '&back=true&RecordType=Create';    
        Pagereference pg =  new Pagereference('/apex/VPM_AdvancedForm?id=' +purid +queryString); 
        pg.setRedirect(true);
        return pg;
    }
}