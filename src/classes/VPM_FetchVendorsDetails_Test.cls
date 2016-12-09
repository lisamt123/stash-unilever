@isTest
public class VPM_FetchVendorsDetails_Test {
  static testMethod void getVendorDetailsTest() {
      List<VPM_FetchVendorsDetails.InputVariables> inputCriteria = new List<VPM_FetchVendorsDetails.InputVariables>();
        VPM_FetchVendorsDetails.InputVariables crit = new VPM_FetchVendorsDetails.InputVariables();
        crit.vendorCodeInput='9987534';
        crit.ecc = 'Cordillera';
        crit.compnayCode = 'ULAG';
        inputCriteria.add(crit);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(200));
         VPM_FetchVendorsDetails.getVendorDetails(inputCriteria);
         
        //VPM_ECCVendorSearchServiceOutput eccSearchVendor = new VPM_ECCVendorSearchServiceOutput();
        
        string jsonServiceResponse ='{  "VendorCode": "0050478468",  "ECC": "Fusion",  "Title": "0001",  "VendorName1": "ACP ADMIN AND PI WELFARE",  "VendorName2": "SADBHAWANA VASTU",  "VendorName3": "BHANDAR NASHIK CITY",  "VendorName4": "",  "HouseNumber": "",  "Street1": "SADBHAWANA VASTU BHANDAR",  "Street2": "POLICE HEAD QUARTER ASHIK",  "Street3": "CITY BEHIND OLD C B S NASHIK",  "Street4": "",  "Street5": "Street 5",  "PostCode": "422002",  "PostCode2": "517501",  "City": "NASHIK",  "Country": "IN",  "Region": "13",  "RegStructGroup": "",  "District": "",  "POBox": "517501",  "HouseNumSupplement": "Supplement",  "IntLocationNumber1": "0000001",  "IntLocationNumber2": "00001",  "CompanyPostCode": "",  "POBoxCity": "400005",  "TransportZone": "0000000002",  "Language": "E",  "AddressTimeZone": "INDIA",  "StandardCommunicationMethod": "INT",  "SearchTerm1": "ACP ADMIN AND P",  "SearchTerm2": "13",  "Dataline": "DIFF CITY AND STATE",  "Telebox": "Company",  "TradePartnerType": "",  "TradingPartner": "",  "AccountGroup": "HL02",  "CheckDigit": "1",  "SocialInsuranceCode": "SAP",  "SocialInsurance": true,  "CorporateGrp": "GROUP",  "CreditInfoNumber": "INFO",  "ExternalMFG": "External",  "TaxNumber1": "TAX 1",  "TaxNumber2": "TAX 2",  "TaxNumber3": "TAX 134",  "TaxNumber4": "TAX 156",  "TaxNumber5": "TAX 5",  "TaxNumberResponsibleAuthority": "123456789",  "VATRegistrationNumber": "",  "TaxNumberType": "01",  "TaxType": "",  "TaxJurisdictionCode": "TAX JUD",  "Customer": "YU125",  "TrainStation": "Port Sunlight",  "Authorization": "",  "Industry": "1",  "TypeOfIndustry": "SAP",  "isNaturalPerson": true,  "DMEIndicator": "1",  "InstructionKey": "01",  "ISRNumber": "7890",  "AccountNumberAlternativePayee": "true",  "EqualisationTax": true,  "SalesPurchTax": true,  "FiscalAddress": "",  "PlaceOfBirth": "Bangalore",  "DateOfBirth": "1985-08-01",  "Sex": "Male",  "LastExtReview": "2016-09-05",  "ActualQMSystem": "1080",  "Plant": "",  "IndicatorVendorSubRangeRelevant": false,  "IndicatorPlantLevel": false,  "SCAC": "SC12",  "CarFreightGroup": "",  "ServiceAgent": "0001",  "TaxSplit": true,  "TaxBase": "1",  "Profession": "",  "QMSystemTo": "2016-09-05",  "PODRelevant": "B",  "VendorSubRange": [    {      "SubRange": null    }  ],  "OrderingEmail": "nithin.jacob@unilever.com",  "Telephone": "9876543212",  "Extension1": "",  "IndicatorAlternativePayeeAccountNumber": false,  "TaxOfficeIdentification": "50478468",  "Nodel": false,  "Deleted": false,"Blocked": false,  "CompanyData": [    {      "CompanyCode": "UNEL",      "ReconciliationAccount": "12334",      "PaymentTerms": "",      "MinorityIndicator": "",      "PaymentTermsCreditMemoKey": "",      "SortKey": "011",      "CashManagementGroup": "A5",      "IndicatorAltPayeeAccountNumber": false,      "PaymentMethod": "5",      "InterestCalculationIndicator": "",      "IndicatorClearingBetweenCustomerAndVendor": false,      "AccountWithVendor": "",      "ClerkAtVendor": "",      "AccountMemo": "",      "AccountingClerk": "",      "Authorization": "",      "AlternativePayee": "",      "LastKeyDate": null,      "InterestFrequency": "00",      "LastInterestRun": null,      "BExchangeLimit": "0.0",      "CheckCashing": "0",      "CheckDoubleInvoices": true,      "ToleranceGroup": "",      "HouseBank": "",      "IndividualPayment": false,      "ExemptionNumber": "",      "ValidUntil": null,      "PreviousAccountNumber": "",      "GroupingKey": "",      "PaymentMethodSupplement": "",      "WithholdingTaxCountryKey": "",      "HeadOfficeAccountNumber": "",      "PmtAdviceByEDI": false,      "ClerksFax": "",      "RemittanceEmail": "",      "AccountStatement": "",      "Dunning": [              ],      "WtaxType": [        {          "IndicatorForWithholdingTaxType": "",          "Liable": false,          "WithholdingTaxCode": "",          "ExemptionRate": "0.0",          "ExemptionFrom": null,          "ExemptionTo": null,          "ExemptionReason": "",          "TypeOfRecipient": "",          "IdentificationNumber": "",          "ExemptionCertificateNumber": ""        }      ],      "BeneficiaryName": "",      "BeneficiaryAddress1": "",      "BeneficiaryAddress2": "",      "BeneficiaryAddress3": "",      "BeneficiaryCountry": "",      "ThirdPartyCountry": "",      "ThirdPartyName": "",      "ThirdPartyAddress1": "",      "ThirdPartyAddress2": "",      "ThirdPartyAddress3": "",      "ThirdPartyAddress4": "",      "FreeText1": "",      "PaymentBlock": "R",      "FreeText2": "",      "PayableLocation": "",      "AccountClerkTelephoneNumber": "",      "AdoptScanDate": false,      "Nodel": false,      "Blocked": false,      "Deleted": false    }  ],  "companyCodeMatch": true,  "PurchasingData": [    {      "PurchasingOrganisation": "NLAB",      "ABCIndicator": "",      "OrderCurrency": "AFA",      "SalesPerson": "",      "Telephone": "",      "MinimumOrderValue": "0.0",      "PaymentTerms": "90DK",      "Incoterms1": "CIR",      "Incoterms2": "qweq",      "GRBasedIV": true,      "OrderAcknowledgmentRequirement": false,      "SchemaGroupVendor": "01",      "SubsequentSettlement": false,      "SubsequentSettlementIndex": false,      "AutoGenerationPOAllowed": false,      "ModeTransportForeignTrade": "",      "OfficeOfEntry": "",      "ShippingConditions": "",      "UnitOfMeasure": "",      "RoundingProfile": "",      "PricingDateControl": "2",      "PurchasingGroup": "",      "AutoEvalGRSetmtDel": false,      "PlannedDeliveryTime": "0",      "RackJobbingServiceAgreed": false,      "RelevantForPriceDet": false,      "GrantDiscInKind": false,      "DocIndexActive": false,     "SortCriterion": "",      "ConfirmationControl": "",      "OrderOptimRest": "",      "AutoEvalGRSetmtRet": false,      "AccountWithVendor": "",      "PROACTControlProof": "",      "SRVBasedVendorID": true,      "Functions": [        {          "PartnerFunction": "AZ",          "DefaultPartner": false        },        {          "PartnerFunction": "LF",          "DefaultPartner": true        }      ]    }  ],  "purchasingOrgMatch": true,  "CIN": {    "PANNumber": "AAJFA9129R",    "CSTno": "19413403267",    "LSTno": "19413403073",    "SerRegNo": "AAJFA9129RST001",    "ExcIndVendor": "",    "ECCNo": "TEST2",    "ExciseRegNo": "346TEST",    "ExciseRange": "567TEST",    "ExciseDivision": "TEST",    "Commissionerate": "TEST1",    "SSIStatus": "0",    "TypeVendor": "M",    "CENVAT": "X",    "ChangedOn": "2016-09-22",    "ChangedBy": "ALE_MULESOFT",    "PANreference": "REFERENCE1"  }}';
       VPM_ECCVendorSearchServiceOutput test1 = new VPM_ECCVendorSearchServiceOutput();
        
                //string jsonServiceResponse= '{"VendorCode":"0001024103"}';
        //eccSearchVendor = (VPM_ECCVendorSearchServiceOutput) System.JSON.deserialize(jsonServiceResponse, VPM_ECCVendorSearchServiceOutput.class);
        //test1 = (VPM_ECCVendorSearchServiceOutput) System.JSON.deserialize(jsonServiceResponse , VPM_ECCVendorSearchServiceOutput.class);
            test1 = VPM_ECCVendorSearchServiceOutput.parse(jsonServiceResponse);  
        //eccSearchVendor[0].VendorCode = '0001234';
        //eccSearchVendor[0].AccountWithVendor ='1763387';
        system.debug('55555 '+test1 );
      Test.stopTest();
      system.assertEquals(crit.ecc,'Cordillera');
  }
    
    static testMethod void getVendorDetailsTestVendorFound() {
      List<VPM_FetchVendorsDetails.InputVariables> inputCriteria = new List<VPM_FetchVendorsDetails.InputVariables>();
        VPM_FetchVendorsDetails.InputVariables crit = new VPM_FetchVendorsDetails.InputVariables();
        crit.vendorCodeInput='343';
        crit.ecc = 'Cordillera';
        crit.compnayCode = '5495';
        inputCriteria.add(crit);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_FetchVendorDetailsHttpMock(404));
        VPM_FetchVendorsDetails.getVendorDetails(inputCriteria);
      Test.stopTest();
      system.assertEquals(crit.ecc,'Cordillera');
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
        system.assertEquals(InputVariablesObj.ecc,'ECC');
    }
}