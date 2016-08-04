/********************************************************************
    Created By   : Ajay Rawat
    Created Date : 20th July 2016
    Modified By  : 
    Last Modify  : 06th June 2016
    Description  : This class is used as a wrapper class for maintain result
    MetaData     : Properties, Wrapper Calss, Methods
  ********************************************************************/
public class VPM_MaintainVendorServiceHelper {
    public String ECC;  
    public String VendorCode;   
    public String TrainStation; 
    public String IntLocationNumber1;   
    public String IntLocationNumber2;   
    public String Authorization;    
    public String Industry; 
    public String CheckDigit;  
     public String RegionStreetGroup; 
    //public AddressObj Address;
    //public VATObj VAT = new VATObj();
    //public BankDetailsObj BankDetails ;
    //public String VendorSubRange;   
    public String DMEIndicator; 
    public String InstructionKeyDataExchange;   
    public String ISRNumber;    
    public String AccountGroup;
    public String Customer; 
    public String AlternativePayeeAccountNumber;    
    public String TaxNumber1;   
    public String TaxNumber2;   
    public boolean EqualisationTax;  
    public boolean SalesPurchTax;    
    public String FiscalAddress;    
    public String VATRegistrationNumber;    
    public String PlaceOfBirth; 
    public String DateOfBirth;  
    public String Sex;  
    public String LastExtReview;    
    public String ActualQMSystem;   
    public String Plant;    
    public boolean IndicatorVendorSubRange;  
    public boolean IndicatorPlantLevel;  
    public String SCAC; 
    public String CarFreightGroup;  
    public String ServiceAgent; 
    public String TaxNumber3;   
    public String TaxNumber4;   
    public boolean TaxSplit; 
    public String TaxBase;  
    public String Profession_c; 
    public boolean NODEL;    
    public String QMSystemTo;   
    public String PODRelevant;  
    public String TaxNumber5;   
    //public String CorporateGroup;   
    //public boolean AltPayeeAllowedFlag;  
    //public String ExternalManufacturer; 
    public CompanyDataObj CompanyData ;
    public PurchasingDataObj PurchasingData;
    public class AddressObj {
        public String ZIPPostcode;  //
        public String CompanyPostCode;  //
        public String POBox;    //
        public String POBoxCity;    //
        public String TransportZone;    //
        public String HouseNumber;  //
        public String Street1;  //
        public String Street2;  //
        public String Street3;  //
        public String Street4;  //
        public String Country;  //
        public String Language; //
        public String Region;   //
        public String SearchTerm1;  //
        public String SearchTerm2;  //
        public String TaxJurisdictionCode;  //
        public String AddressTimeZone;  //
        public String StandardCommunicationMethod;  //
        public String Telephone;    //118 247
        public String ExtensionPhone;   //411
        public String Fax;  //
        public String FaxExtension; //
        public String Email;    //
    }
    /*public class VATObj {
        public String VATCountry;   //
        public String VATRegistrationNumber;    //
    }
    public class BankDetailsObj {
        public String BankCountryKey;   //
        public String BankKey;  //
        public String BankAccountNumber;    //
        public String BankControlKey;   //
        public String PartnerBankType;  //
        public String CollectionAuthorisation;  //
        public String RefSpecBankDetails;   //
        public String AccountHolderName;    //
        public String IBAN; //
    }*/
    public class CompanyDataObj {
        public String CompanyCode;  //5487
        public String SortKey;  //012
        public String ReconciliationAccount;    //0014201009
        public String AuthorizationCC;  //ASM
        public String InterestCalculationIndicator; //01
        public String PaymentMethod;    //A
        public boolean IndicatorClearingBetwCustomerNVendor; //X
        public String PaymentBlock; //C
        public String PaymentTerm;  //P060
        public String AccntWithVendor;  //Account
        public String ClerkAtVendor;    //Clerk
        public String AccountMemo;  //Account Memo
        public String AccountingClerk;  //A8
        public String CashManagementGroup;  //V1020
        public String AlternativePayee; //0050000004
        public String LastKeyDate;  //2017-06-06
        public String InterestFrequency;    //01
        public String LastInterestRun;  //2017-06-06
        public String BExchangeLimit;   //0.00
        public String ChkCashing;   //0
        public boolean CheckDoubleInvoices;  //X
        public String ToleranceGroup;   //
        public String HouseBank;    //CHASE
        public boolean IndicatorPayItemsSeparately;  //X
        public String ExemptionNumber;  //EXNumber
        public String ValidUntil;   //2017-06-06
        public String PreviousAccountNumber;    //123456789
        public String GroupingKey;  //01
        public String PaymentMethodSupplement;  //B2
        public String WithholdingTaxCountryKey; //
        public String PmtAdviceByEDI;   //
        public String ClerksFax;    //01942 999999
        public String ClerksInternet;   //Clerks@clerk.com
        public String AccountStatement; //5
        public boolean NODELCC;  //X
        public String AccountClerkTelephoneNumber;  //01942 999999
        public boolean AdoptScanDate;    //X
        public boolean MinorityIndicator;    //
        public String HeadOfficeAccNo;  //
        public String MGroupingKey; //
        public String PaymentTermsCreditMemoKey;    //
        public String CertificationDate;    //2016-06-01
        public DunningObj Dunning;
        public WtaxTypeObj WtaxType;
    }
    public class DunningObj {
        public String DunnProcedure;    //0001
        public String DunningBlock; //D
        public String LastDunned;   //2016-06-01
        public String DunningLevel; //0
        public String DunRecipient; //0050019408
        public String LegalDunnProc;    //2016-06-06
        public String DunningClerk; //A8
    }
    public class WtaxTypeObj {
        public String IndicatorForWithholdingTaxType;   //MC
        public String Liable;   //
        public String WithholdingTaxCode;   //C1
        public String ExemptionRate;    //
        public String ExemptionFrom;    //
        public String ExemptionTo;  //
        public String ExemptionCertNumber;  //
    }
    public class PurchasingDataObj {
        public String PurchasingOrganisation;   //AM01
        public boolean ABCIndicator; //X
        public String OrderCurrency;    //GBP
        public String SalesPerson;  //Mike Conray
        public String Telephone;    //01924 999999
        public String MinimumOrderValue;    //0
        public String PaymentTerms; //P060
        public String Incoterms1;   //FCA
        public String Incoterms2;   //NAMED PLACE
        public boolean GRbasedIV;    //X
        public boolean OrderAcknowledgmentRequirement;   //X
        public String SchemaGroupVendor;    //01
        public boolean AutoGenerationPOAllowed;  //X
        public String ModeTransportForeignTrade;    //4
        public String OfficeOfEntry;    //CGB
        public String PricingDateControl;   //4
        public String PurchasingGroup;  //ALC
        public boolean AutoEvalGRSetmtDel;   //X
        public String PlannedDeliveryTime;  //1
        public boolean RackJobbingServiceAgreed; //X
        public boolean RelevantForPriceDet;  //X
        public boolean GrantDiscInKind;  //X
        public boolean DocIndexActive;   //X
        public String SortCriterion;    //A
        public String ConfirmationControl;  //0002
        public String OrderOptimRest;   //0001
        public boolean AutoEvalGRSetmtRet;   //X
        public String AccntWithVendorPO;    //Si
        public String PROATControlProof;    //SAPD
        public boolean SRVBasedVendorID; //X
        public FunctionObj Function ;
    }
    public class FunctionObj {
        public String PartnerFunction;  //BA
        public boolean DefaultPartner;   //X
        public String PurchasingOrgFunctionPartner; //0050000129
    }
    
}