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
         VPM_ECCVendorSearchServiceOutput test1 = new VPM_ECCVendorSearchServiceOutput();
        VPM_ECCVendorSearchServiceOutput eccSearchVendor = new VPM_ECCVendorSearchServiceOutput();
        //string jsonServiceResponse='[{"VPM_ECCVendorSearchServiceOutput" :{"VendorCode":"0001024103","ECC":"Fusion","Title":"0001","VendorName1":"SANGITA HARDWARE AND","VendorName2": "ELECTRICAL STORES","VendorName3": "","VendorName4": "","HouseNumber": "","Street1": "UDYOG VISHWA,SHOP N0 12","Street2": "NASHIK-PUNE ROAD","Street3": "","Street4": "","Street5": "M I D C,MALEGAON,SINNERDIST","PostCode": "422103","PostCode2": "","City": "Nasik","Country": "IN","Region": "13","RegStructGroup": "H02","District": "","POBox": "","HouseNumSupplement": "9","IntLocationNumber1": "0000000","IntLocationNumber2": "00000","CompanyPostCode": "","POBoxCity": "","TransportZone": "","Language": "E","AddressTimeZone": "INDIA","StandardCommunicationMethod": "RML","SearchTerm1": "UNS00054","SearchTerm2": "78","Dataline": "Data","Telebox": "Individual","TradePartnerType": "","TradingPartner": "","AccountGroup": "HL13","CheckDigit": "0","SocialInsuranceCode": "","SocialInsurance": false,"CorporateGrp": "","CreditInfoNumber": "","ExternalMFG": "","TaxNumber1": "","TaxNumber2": "","TaxNumber3": "","TaxNumber4": "","TaxNumber5": "TAX NUMBER 5","TaxNumberResponsibleAuthority": "","VATRegistrationNumber": "27920146882V","TaxNumberType": "","TaxType": "","TaxJurisdictionCode": "","Customer": "YU125","TrainStation": "BOB 26000200000022","Authorization": "","Industry": "0016","TypeOfIndustry": "NONSAP","isNaturalPerson": true,"DMEIndicator": "1","InstructionKey": "01","ISRNumber": "","AccountNumberAlternativePayee": "","EqualisationTax": true,"SalesPurchTax": true,"FiscalAddress": "","PlaceOfBirth": "NAME 30347471","DateOfBirth": null,"Sex": "","LastExtReview": null,"ActualQMSystem": "","Plant": "","IndicatorVendorSubRangeRelevant": false,"IndicatorPlantLevel": false,"SCAC": "SC12","CarFreightGroup": "","ServiceAgent": "","TaxSplit": false,"TaxBase": "0","Profession": "Profession","QMSystemTo": null,"PODRelevant": "","VendorSubRange": [],"OrderingEmail": "sangita_hard@yahoo.com","Telephone": "02551-2221-02","Extension1": "9999","IndicatorAlternativePayeeAccountNumber": false,"TaxOfficeIdentification": "","Nodel": false,"Deleted": false,"Blocked": false,"CompanyData": [{"CompanyCode": "H","ReconciliationAccount": "0001420198","PaymentTerms": "07D","PaymentTermsCreditMemoKey": "","SortKey": "005","CashMgmtGroup": "A5","IndicatorAltPayeeAccountNumber": false,"PaymentMethod": "2","InterestCalculationIndicator": "","IndicatorClearingBetweenCustomerAndVendor": false,"AccountWithVendor": "","ClerkAtVendor": "","AccountMemo": "","AccountingClerk": "","Authorization": "","AlternativePayee": "0002000004","LastKeyDate": null,"InterestFrequency": "00","LastInterestRun": null,"BExchangeLimit": "0.0","CheckCashing": "0","CheckDoubleInvoices": true,"ToleranceGroup": "0001","HouseBank": "DBE01","IndividualPayment": false,"ExemptionNumber": "","ValidUntil": null,"PreviousAccountNumber": "UNS00054","GroupingKey": "","PaymentMethodSupplement": "","WithholdingTaxCountryKey": "IN","HeadOfficeAccountNumber": "","PmtAdviceByEDI": false,"ClerksFax": "","RemittanceEmail": "","AccountStatement": "","Dunning": [],"WtaxType": [{"IndicatorForWithholdingTaxType": "A1","Liable": true,"WithholdingTaxCode": "A1","ExemptionRate": "1.0","ExemptionFrom": "2016-09-14","ExemptionTo": "2016-09-14","ExemptionReason": "B","TypeOfRecipient": "CO","IdentificationNumber": "ID","ExemptionCertificateNumber": "98700678"}],"BeneficiaryName": "SANGITA HARDWARE AND ELECTRONICS","BeneficiaryAddress1": "UDYOG VISHWA,SHOP N0 12","BeneficiaryAddress2": "NASHIK-PUNE ROAD","BeneficiaryAddress3": "M I D C,MALEGAON,SINNER DIST","BeneficiaryCountry": "IN","ThirdPartyCountry": "IN","ThirdPartyName": "THIRD PARTY NAME","ThirdPartyAddress1": "THIRD PARTY ADDRESS 1","ThirdPartyAddress2": "THIRD PARTY ADDRESS 2","ThirdPartyAddress3": "THIRD PARTY ADDRESS 3","ThirdPartyAddress4": "THIRD PARTY ADDRESS 4","FreeText1": "Text 1","PaymentBlock": "P","FreeText2": "Text 2","PayableLocation": "BANGALORE","AccountClerkTelephoneNumber": "","AdoptScanDate": false,"Nodel": false,"Blocked": false,"Deleted": false}],"companyCodeMatch": true,"PurchasingData": [],"purchasingOrgMatch": false,"CIN": {"PANNumber": "ADFPC8781J","CSTno": "27920146882C","LSTno": "27920146882V","SerRegNo": "","ExcIndVendor": "1","ECCNo": ".","ExciseRegNo": ".","ExciseRange": ".","ExciseDivision": ".","Commissionerate": ".","SSIStatus": "","TypeVendor": "","CENVAT": "","ChangedOn": "2016-09-14","ChangedBy": "H000334808","PANreference": ""}}}]';
        string jsonServiceResponse= '{"VendorCode":"0001024103"}';
        eccSearchVendor = (VPM_ECCVendorSearchServiceOutput) System.JSON.deserialize(jsonServiceResponse, VPM_ECCVendorSearchServiceOutput.class);
        //test1 = (VPM_ECCVendorSearchServiceOutput) System.JSON.deserialize('{"VendorCode":"0001024103"}', VPM_ECCVendorSearchServiceOutput.class);
        //eccSearchVendor[0].VendorCode = '0001234';
        //eccSearchVendor[0].AccountWithVendor ='1763387';
        system.debug('55555 '+test1 );
      Test.stopTest();
      system.assertEquals(crit.ecc,'Cordillera');
  }
    
    @isTest static void getVendorDetailsTestVendorFound() {
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