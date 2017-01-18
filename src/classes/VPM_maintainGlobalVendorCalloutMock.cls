@isTest
public class VPM_maintainGlobalVendorCalloutMock implements HttpCalloutMock {
    private Integer returnedStatusCode;
    public VPM_maintainGlobalVendorCalloutMock(Integer returnedStatusCode) {
        this.returnedStatusCode = returnedStatusCode;
    }
    public HttpResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        String jsonServiceResponse;
        res.setStatus('OK'); 
        req.setMethod('PUT');
        if(returnedStatusCode == 200){
        //jsonServiceResponse='{"VendorCode":"0001024103","ECC":"Fusion","Title":"0001","VendorName1":"SANGITA HARDWARE AND","VendorName2": "ELECTRICAL STORES","VendorName3": null,"VendorName4": "test","HouseNumber": null,"Street1": "UDYOG VISHWA,SHOP N0 12","Street2": "NASHIK-PUNE ROAD","Street3": null,"Street4": null,"Street5": "M I D C,MALEGAON,SINNERDIST","PostCode": "422103","PostCode2": null,"City": "Nasik","Country": "IN","Region": "13","RegStructGroup": "H02","District": null,"POBox": null,"HouseNumSupplement": "9","IntLocationNumber1": "0000000","IntLocationNumber2": "00000","CompanyPostCode": null,"POBoxCity": null,"TransportZone": null,"Language": "E","AddressTimeZone": "INDIA","StandardCommunicationMethod": "RML","SearchTerm1": "UNS00054","SearchTerm2": "78","Dataline": "Data","Telebox": "Individual","TradePartnerType": null,"TradingPartner": null,"AccountGroup": "HL13","CheckDigit": "0","SocialInsuranceCode": null,"SocialInsurance": false,"CorporateGrp": null,"CreditInfoNumber": null,"ExternalMFG": null,"TaxNumber1": null,"TaxNumber2": null,"TaxNumber3": null,"TaxNumber4": null,"TaxNumber5": "TAX NUMBER 5","TaxNumberResponsibleAuthority": null,"VATRegistrationNumber": "27920146882V","TaxNumberType": null,"TaxType": null,"TaxJurisdictionCode": null,"Customer": "YU125","TrainStation": "BOB 26000200000022","Authorization": null,"Industry": "0016","TypeOfIndustry": "NONSAP","isNaturalPerson": true,"DMEIndicator": "1","InstructionKey": "01","ISRNumber": null,"AccountNumberAlternativePayee": null,"EqualisationTax": true,"SalesPurchTax": true,"FiscalAddress": null,"PlaceOfBirth": "NAME 30347471","DateOfBirth": null,"Sex": null,"LastExtReview": null,"ActualQMSystem": null,"Plant": null,"IndicatorVendorSubRangeRelevant": false,"IndicatorPlantLevel": false,"SCAC": "SC12","CarFreightGroup": null,"ServiceAgent": null,"TaxSplit": false,"TaxBase": "0","Profession": "Profession","QMSystemTo": null,"PODRelevant": null,"VendorSubRange": [],"OrderingEmail": "sangita_hard@yahoo.com","Telephone": "02551-2221-02","Extension1": "9999","IndicatorAlternativePayeeAccountNumber": false,"TaxOfficeIdentification": null,"Nodel": false,"Deleted": false,"Blocked": false,"CompanyData": [{"CompanyCode": "H","ReconciliationAccount": "0001420198","PaymentTerms": "07D","PaymentTermsCreditMemoKey": null,"SortKey": "005","CashMgmtGroup": "A5","IndicatorAltPayeeAccountNumber": false,"PaymentMethod": "2","InterestCalculationIndicator": null,"IndicatorClearingBetweenCustomerAndVendor": false,"AccountWithVendor": null,"ClerkAtVendor": null,"AccountMemo": null,"AccountingClerk": null,"Authorization": null,"AlternativePayee": "0002000004","LastKeyDate": null,"InterestFrequency": "00","LastInterestRun": null,"BExchangeLimit": "0.0","CheckCashing": "0","CheckDoubleInvoices": true,"ToleranceGroup": "0001","HouseBank": "DBE01","IndividualPayment": false,"ExemptionNumber": null,"ValidUntil": null,"PreviousAccountNumber": "UNS00054","GroupingKey": null,"PaymentMethodSupplement": null,"WithholdingTaxCountryKey": "IN","HeadOfficeAccountNumber": null,"PmtAdviceByEDI": false,"ClerksFax": null,"RemittanceEmail": null,"AccountStatement": null,"Dunning": [],"WtaxType": [{"IndicatorForWithholdingTaxType": "A1","Liable": true,"WithholdingTaxCode": "A1","ExemptionRate": "1.0","ExemptionFrom": "2016-09-14","ExemptionTo": "2016-09-14","ExemptionReason": "B","TypeOfRecipient": "CO","IdentificationNumber": "ID","ExemptionCertificateNumber": "98700678"}],"BeneficiaryName": "SANGITA HARDWARE AND ELECTRONICS","BeneficiaryAddress1": "UDYOG VISHWA,SHOP N0 12","BeneficiaryAddress2": "NASHIK-PUNE ROAD","BeneficiaryAddress3": "M I D C,MALEGAON,SINNER DIST","BeneficiaryCountry": "IN","ThirdPartyCountry": "IN","ThirdPartyName": "THIRD PARTY NAME","ThirdPartyAddress1": "THIRD PARTY ADDRESS 1","ThirdPartyAddress2": "THIRD PARTY ADDRESS 2","ThirdPartyAddress3": "THIRD PARTY ADDRESS 3","ThirdPartyAddress4": "THIRD PARTY ADDRESS 4","FreeText1": "Text 1","PaymentBlock": "P","FreeText2": "Text 2","PayableLocation": "BANGALORE","AccountClerkTelephoneNumber": null,"AdoptScanDate": false,"Nodel": false,"Blocked": false,"Deleted": false}],"companyCodeMatch": true,"PurchasingData": [],"purchasingOrgMatch": false,"CIN": {"PANNumber": "ADFPC8781J","CSTno": "27920146882C","LSTno": "27920146882V","SerRegNo": null,"ExcIndVendor": "1","ECCNo": ".","ExciseRegNo": ".","ExciseRange": ".","ExciseDivision": ".","Commissionerate": ".","SSIStatus": null,"TypeVendor": null,"CENVAT": null,"ChangedOn": "2016-09-14","ChangedBy": "H000334808","PANreference": ""}}';
             jsonServiceResponse='{\"SAP_Messages\":[{\"status\":\"Failure\",\"bpmID\":\"12345678\"}]}';
            res.setStatusCode(returnedStatusCode );
        res.setBody(jsonServiceResponse);
        } else if(returnedStatusCode == 300 || returnedStatusCode == 500 || returnedStatusCode == 504
        || returnedStatusCode == 400 || returnedStatusCode == 503) {
       
       // jsonServiceResponse='{\"SAP_Messages\":[{\"status\":\"Failure\",\"bpmID\":\"12345678\"}]}';
         jsonServiceResponse='{\"status\":\"Failure\",\"bpmID\":\"12345678\"}';
            res.setStatusCode(returnedStatusCode );
        res.setBody(jsonServiceResponse);
        } 
        else if(returnedStatusCode == 505) {
       
       // jsonServiceResponse='{\"SAP_Messages\":[{\"status\":\"Fail"ure\",\"bpmID\":\"12345678\"}]}';
         jsonServiceResponse='{\"status\":\"Fail"ure\",\"bpmID\":\"12345678\"}';
            res.setStatusCode(returnedStatusCode );
        res.setBody(jsonServiceResponse);
        }
        else {
            jsonServiceResponse='{\"SAP_Messages\":[{\"status\":\"Failure\",\"bpmID\":\"12345678\"}]}';
        res.setStatusCode(returnedStatusCode );
        res.setBody(jsonServiceResponse);
        }
        return res;
    }
}