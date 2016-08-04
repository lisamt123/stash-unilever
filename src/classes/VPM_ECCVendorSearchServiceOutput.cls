global class VPM_ECCVendorSearchServiceOutput {
    public List<CompanyCodeFields> CompanyCodeFields;
    public List<PurchasingOrgFields> PurchasingOrgFields;
    public String message;
    public string statusCode;
    public String companyCodeMatch;
    public boolean companyCodeMatching;
    public boolean vendorFoundResult;
    //change
    public boolean ABCIndicator;
    public String AccntWithVendor;
    public String AccountClerkTelephoneNumber;
    public String AccountGroup;
    public String AccountingClerk;
    public String AccountingNote;
    public String AccountingText;
    public String AccountMemo;
    public String AccountStatement;
    public String ActualQMSystem;
    public String AddressForm;
    public String AddressTimeZone;
    //change
    public boolean AdoptScanDate;
    public String AlternativePayee;
    public String AlternativePayeeAccountNumber;
    public String AltPayeeAccountNum;
    public String ArabiaOldNumber;
    public String ArabicVersion;
    public String Authorization;
    //change
    public boolean AutoEvalGRSetmtDel;
    //change
    public boolean AutoEvalGRSetmtRet;
    //change
    public boolean AutoGenerationPOAllowed;
    /*Fields commented since bank details fields need not be retrieved in get vendor details call. Line number 31 to 41.
    public String BankCountryKey;
    public String BankKey;
    public String BankAccountNumber;
    public String AccountHolderName;
    public String RefSpecBankDetails;
    public String BankControlKey;
    public String IBAN;
    public String CollectionAuthorization;
    public String PartnerBankType;
    public String BankName;
    public String SwiftKey; */
    public String BankNumber;
    public String BeneficiaryAddress1;
    public String BeneficiaryAddress2;
    public String BeneficiaryAddress3;
    public String BeneficiaryCountry;
    public String BeneficiaryName;
    public String BExchangeLimit;
    public Boolean Blocked;
    public String BlockFunction;
    public String CarFreightGroup;
    public String CashManagementGroup;
    public String IndicatorPantLevel;
    public String IndicatorVendorSubRange;
    public String CentralDeletionFlag;
    public String CentralPostingBlock;
    public String CentralPurchasingBlock;
    public String CENVAT;
    public String CertificateWithholdingTaxExemption;
    public String CertificationDate;
    public String ChangedBy;
    public String Changedon;
    public String CheckDigit;
    //change
    public boolean CheckDoubleInvoices;
    public String ChkCashing;
    public String City;
    public String ClerkAtVendor;
    public String ClerksFax;
    public String ClerksInternet;
    public String Commissionerate;
    public String CompanyCode;
    public String CompanyPostCode;
    public String ConfirmationControl;
    public String ContactPerson;
    public String ContactPersonSurname;
    public String CorporateGrp;
    public String CorrespondentBank;
    public String Country;
    public String CreditInfoNumber;
    public String CSTno;
    public String Customer;
    public String DataLine;
    public String DateOfBirth;
    //change
    public boolean DefaultPartner;
    public Boolean Deleted;
    public String Department;
    public String DepartmentDescription;
    public String DepartmentNumber;
    public String Description;
    public String District;
    //change
    public boolean DMEIndicator;
    //change
    public boolean DocIndexActive;
    public String DunningBlock;
    public String DunningClerk;
    public String DunningLevel;
    public String DunnProcedure;
    public String DunnRecipient;
    public String ECC;
    public String ECCNo;
    public String Email;
    public String Email2;
    public String Email3;
    //change
    public boolean EqualisationTax;
    public String ExcIndVendor;
    public String ExciseDivision;
    public String ExciseRange;
    public String ExciseRegNo;
    public String ExemptionFrom;
    public String ExemptionNumber;
    public String ExemptionRate;
    public String ExemptionTo;
    public String Extension2;
    public String Extension3;
    public String ExtensionPhone;
    public String ExternalMFG;
    public String Fax;
    public String FaxExtension;
    public String FaxNumber2;
    public String FaxNumber3;
    public String FiscalAddress;
    public String FreeText1;
    public String FreeText2;
    public String Function;
    public String FunctionDescription;
    //change
    public boolean GrantDiscInKind;
    //change
    public boolean GRBasedIV;
    public String GroupingKey;
    public String HeadOfficeAccountNumber;
    public String HouseBank;
    public String HouseNumber;
    public String HouseNumSupplement;
    public String icate;
    public String Incoterms1;
    public String Incoterms2;
    public String IndicatorAlternativePayeeAllowed;
    //change
    public boolean IndicatorClearingBetweenCustomerAndVendor;
    public String IndicatorCollectionAuthorization;
    public String IndicatorForWithholdingTaxType;
    //change
    public boolean IndicatorPayItemsSeparatley;
    //change
    public boolean IndicatorPlantLevel;
    public String IndicatorSubjectToWithholdingTax;
    //change
    //public String IndicatorVendorSubRange;
    public String IndividualPayment;
    public String IndividualSpec;
    public String IndonesiaOldVendorNumber;
    public String Industry;
    public String IndustryType;
    public String InstructionKeyDataExchange;
    public String InterestCalculationIndicator;
    public String InterestFrequency;
    public String InternationalVersion;
    public String IntLocationNumber1;
    public String IntLocationNumber2;
    public String IsraelOldNumber;
    public String ISRNumber;
    public String Language;
    public String LanguageKeyCOCode;
    public String LastDunned;
    public String LastExtReview;
    public String LastInterestRun;
    public String LastKeyDate;
    public String LegalDunnProc;
    public String Liable;
    public String LLDCode;
    public String Local2Version;
    public String LSTno;
    public String MinimumOrderValue;
    public String MinorityIndicators;
    public String MobilePhone;
    public String MobilePhone2;
    public String MobilePhone3;
    public String ModeTransportForeignTrade;
    public String Name3;
    public String Name4;
    public String NODEL;
    public String NPIVendor;
    public String OfficeOfEntry;
    //change
    public boolean OrderAcknowledgementRequirement;
    public String OrderCurrency;
    public String OrderingEmailAddress;
    public String OrderOptimRest;
    public String OtherCommunication;
    public String OurAccNumWithVendor;
    public String PANNumber;
    public String PANreference;
    public String PartnerFunction;
    public String PartnerFunctionName;
    public String PartnerFunctions;
    public String PartnerName;
    public String PartnerNumber;
    public String PayableLocation;
    public String PaymentBlock;
    public String PaymentMethod;
    public String PaymentMethodSupplement;
    public String PaymentTerms;
    public String PaymentTermsKeyCreditMemos;
    public String PermittedPayee;
    public String PlaceOfBirth;
    public String PlannedDeliveryTime;
    public String Plant;
    public String PmtAdviceByEDI;
    public String POBox;
    public String POBoxCity;
    public String PODRelevant;
    public String PostalCode2;
    public String PreviousAccountNumber;
    public String PricingDateControl;
    public String PROATControlProof;
    public String Profession;
    public String Profession_c;
    public String PurchaseOrderText;
    public String PurchasingGroup;
    public String PurchasingOrganisation;
    public String QMSystemTo;
    //change
    public boolean RackJobbingServiceAgreed;
    public String rCommunication;
    public String ReasonForExemption;
    public String RecipientType;
    public String ReconciliationAccount;
    public String Region;
    public String RegStGrp;
    //change
    public boolean RelevantForPriceDet;
    public String ReturnsVendor;
    public String RoundingProfile;
    public String RussianVersion;
    public String SalesPerson;
    //change
    public boolean SalesPurchTax;
    public String SAPComments;
    public String SCAC;
    public String SchemaGroupVendor;
    public String SearchTerm1;
    public String SearchTerm2;
    public String SerRegNo;
    public String ServiceAgent;
    public String Sex;
    public String ShippingConditions;
    public String SMSIndicator;
    public String SocialInsurance;
    public String SocialInsuranceCode;
    public String SortCriterion;
    public String SortKey;
    //change
    public boolean SRVBasedVendorID;
    public String SSIStatus;
    public String StandardCommMethod;
    public String Street1;
    public String Street2;
    public String Street3;
    public String Street4;
    public String Street5;
    public String SubsequentSettlement;
    public String SubsequentSettlementIndex;
    public String TaxBase;
    public String TaxJurisdictionCode;
    public String TaxNumber1;
    public String TaxNumber2;
    public String TaxNumber3;
    public String TaxNumber4;
    public String TaxNumber5;
    public String TaxNumberType;
    public String TaxOfficeIdentification;
    public String TAXOfficeIdentLangKey;
    //change
    public boolean TaxSplit;
    public String TaxType;
    public String TeleBox;
    public String Telephone;
    public String Telephone2;
    public String Telephone3;
    public String TextToInput;
    public String ThaiOldVendorNumber;
    public String ThirdPartyAddress1;
    public String ThirdPartyAddress2;
    public String ThirdPartyAddress3;
    public String ThirdPartyAddress4;
    public String ThirdPartyName;
    public String Title;
    public String ToleranceGroup;
    public String TradePartnerType;
    public String TrainStation;
    public String TransportZone;
    public String TurkeyOldNumber;
    public String TypeVendor;
    public String UkrainianVersion;
    public String UnitOfMeasureGrp;
    public String ValidUntil;
    public String VATRegistrationNumber;
    public String VATRegistrationNumber2;
    public String VATRegistrationNumber3;
    public String VendorCode;
    public String VendorName1;
    public String VendorName2;
    public String VendorName3;
    public String VendorName4;
    public List<String> VendorSubRange;
    public String WithholdingTaxCode;
    public String WithholdingTaxCountryKey;
    public String WithholdingTaxIdentificationNumber;
    public String ZIPPostCode;
    public class PurchasingOrgFields {
        public String PurchasingOrganisation;
        //change
        public boolean ABCIndicator;
        public String OrderCurrency;
        public String SalesPerson;
        public String Telephone;
        public String MinimumOrderValue;
        public String PaymentTerms;
        public String Incoterms1;
        public String Incoterms2;
        //change
        public boolean GRBasedIV;
        //change
        public boolean OrderAcknowledgementRequirement;
        public String SchemaGroupVendor;
        //change
        public boolean AutoGenerationPOAllowed;
        public String ModeTransportForeignTrade;
        public String OfficeOfEntry;
        public String PricingDateControl;
        public String PurchasingGroup;
        //change
        public boolean AutoEvalGRSetmtDel;
        public String PlannedDeliveryTime;
        //change
        public boolean RackJobbingServiceAgreed;
        //change
        public boolean RelevantForPriceDet;
        //change
        public boolean GrantDiscInKind;
        //change
        public boolean DocIndexActive;
        public String SortCriterion;
        public String ConfirmationControl;
        public String OrderOptimRest;
        //change
        public boolean AutoEvalGRSetmtRet;
        public String AccntWithVendor;
        public String PROATControlProof;
        //change
        public boolean SRVBasedVendorID;
        public List<Functions> Functions;
    }
    public class Dunning {
        public String DunnProcedure;
        public String DunningBlock;
        public String LastDunned;
        public String DunningLevel;
        public String DunnRecipient;
        public String LegalDunnProc;
        public String DunningClerk;
    }
    public class CompanyCodeFields {
        public String ReconciliationAccount;
        public String PaymentTerms;
        public String SortKey;
        public String CashManagementGroup;
        public String PaymentMethod;
        public String InterestCalculationIndicator;
        //change
        public boolean IndicatorClearingBetweenCustomerAndVendor;
        public String AccntWithVendor;
        public String ClerkAtVendor;
        public String AccountMemo;
        public String AccountingClerk;
        public String AlternativePayee;
        public String InterestFrequency;
        public String LastInterestRun;
        public String BExchangeLimit;
        public String ChkCashing;
        //change
        public boolean CheckDoubleInvoices;
        public String ToleranceGroup;
        public String HouseBank;
        //change
        public boolean IndicatorPayItemsSeparatley;
        public String ExemptionNumber;
        public String ValidUntil;
        public String PreviousAccountNumber;
        public String GroupingKey;
        public String PaymentMethodSupplement;
        public String WithholdingTaxCountryKey;
        public String PmtAdviceByEDI;
        public String ClerksFax;
        public String ClerksInternet;
        public String AccountStatement;
        public List<Dunning> Dunning;
        public List<WtaxType> WtaxType;
        public String AccountClerkTelephoneNumber;
        //change
        public boolean AdoptScanDate;
        public Boolean Blocked;
        public Boolean Deleted;
        public String CompanyCode;
    }
    public class Functions {
        public String PartnerFunction;
        public String DefaultPartner;
    }
    public class WtaxType {
        public String IndicatorForWithholdingTaxType;
        public String Liable;
        public String WithholdingTaxCode;
        public String ExemptionRate;
        public String ExemptionFrom;
        public String ExemptionTo;
    }
}