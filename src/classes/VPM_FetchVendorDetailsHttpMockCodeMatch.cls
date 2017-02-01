@isTest
global class VPM_FetchVendorDetailsHttpMockCodeMatch implements HttpCalloutMock {
    private Integer returnedStatusCode;
    public VPM_FetchVendorDetailsHttpMockCodeMatch(Integer returnedStatusCode) {
        this.returnedStatusCode = returnedStatusCode;
    }
    global HttpResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        String jsonServiceResponse;
        res.setStatus('OK');
        if(returnedStatusCode == 200){
        jsonServiceResponse='{"BankName":"xyz","ClerksFax":"xyz","EqualisationTax":"xyz","Customer":"xyz","SalesPerson":"xyz","SchemaGroupVendor":"xyz","Extension2":"xyz","Extension3":"xyz","ContactPerson":"xyz","ArabicVersion":"xyz","SRVBasedVendorID":"xyz","CashManagementGroup":"xyz","DateOfBirth":"xyz","BExchangeLimit":"xyz","CreditInfoNumber":"xyz","ReturnsVendor":"xyz","IBAN":"xyz","OrderCurrency":"xyz","AccountHolderName":"xyz","TransportZone":"xyz","TaxJurisdictionCode":"xyz","QMSystemTo":"xyz","ToleranceGroup":"xyz","ContactPersonSurname":"xyz","Telephone3":"xyz","Telephone2":"xyz","Country":"xyz","IndividualPayment":"xyz","OurAccNumWithVendor":"xyz","ExtensionPhone":"xyz","Blocked":false,"AutoGenerationPOAllowed":"xyz","HouseNumber":"xyz","BankKey":"xyz","VATRegistrationNumber3":"xyz","InternationalVersion":"xyz","Sex":"xyz","StandardCommMethod":"xyz","SortKey":"xyz","PricingDateControl":"xyz","VATRegistrationNumber2":"xyz","CheckDigit":"xyz","PlaceOfBirth":"xyz","Authorization":"xyz","SCAC":"xyz","VendorCode":"9987534","HouseBank":"xyz","Deleted":false,"TradePartnerType":"xyz","DunnProcedure":"xyz","ZIPPostCode":"xyz","Street2":"xyz","Street1":"xyz","ECC":"Fusion","PurchasingOrganisation":"xyz","PartnerBankType":"xyz","SwiftKey":"xyz","TaxNumber3":"xyz","VATRegistrationNumber":"xyz","TaxNumber2":"xyz","TaxNumber1":"xyz","OrderingEmailAddress":"timmy@aquagel.com","RefSpecBankDetails":"xyz","ClerkAtVendor":"xyz","Street4":"xyz","Street3":"xyz","PreviousAccountNumber":"xyz","VendorName4":"xyz","VendorName3":"xyz","Street5":"xyz","VendorName2":"xyz","VendorName1":"xyz","OfficeOfEntry":"xyz","ModeTransportForeignTrade":"xyz","PermittedPayee":"xyz","POBoxCity":"xyz","BankCountryKey":"xyz","MobilePhone":"xyz","TaxNumber5":"xyz","TaxNumber4":"xyz","IndicatorSubjectToWithholdingTax":"xyz","Name3":"xyz","ReconciliationAccount":"xyz","Industry":"xyz","Name4":"xyz","GRbasedIV":"xyz","AccountingClerk":"xyz","AccountClerkTelephoneNumber":"xyz","RussianVersion":"xyz","PlannedDeliveryTime":"xyz","TeleBox":"xyz","ConfirmationControl":"xyz","CarFreightGroup":"xyz","ABCIndicator":"xyz","DataLine":"xyz","Local2Version":"xyz","ActualQMSystem":"xyz","City":"xyz","ExternalMFG":"xyz","MinorityIndicators":"xyz","BankControlKey":"xyz","TaxType":"xyz","Profession":"xyz","ShippingConditions":"xyz","CompanyPostCode":"xyz","MinimumOrderValue":"xyz","ClerksInternet":"xyz","Region":"Cordillera","PaymentMethod":"xyz","AccountStatement":"xyz","District":"xyz","BankAccountNumber":"xyz","POBox":"xyz","TrainStation":"xyz","AccntWithVendor":"xyz","Telephone":"98765432100","companyCodeStatus":[{"blocked":false,"deleted":false,"companyCode":""}],"UkrainianVersion":"xyz","PaymentTerms":"xyz","Incoterms2":"xyz","Incoterms1":"xyz","AdoptScanDate":"xyz","icate":"xyz","AlternativePayee":"xyz","Language":"xyz","PaymentBlock":"xyz","GroupingKey":"xyz","AccountMemo":"xyz","PartnerFunctions":"xyz","CheckDoubleInvoices":"xyz","IntLocationNumber2":"xyz","ServiceAgent":"xyz","IntLocationNumber1":"xyz","SalesPurchTax":"xyz","Title":"xyz","MobilePhone2":"xyz","MobilePhone3":"xyz","CorporateGrp":"xyz","AccountGroup":"xyz","CollectionAuthorization":"xyz","SAPComments":"xyz","HouseNumSupplement":"xyz","Fax":"xyz","SearchTerm2":"xyz","TaxNumberType":"xyz","LastExtReview":"xyz","CompanyCode":"","SearchTerm1":"xyz"}';
        res.setStatusCode(returnedStatusCode );
        res.setBody(jsonServiceResponse);
        } else if(returnedStatusCode == 300 || returnedStatusCode == 500 || returnedStatusCode == 504
        || returnedStatusCode == 400 || returnedStatusCode == 503) {
        jsonServiceResponse='{\"status\":\"Failure\",\"bpmID\":\"12345678\"}';
        res.setStatusCode(returnedStatusCode );
        res.setBody(jsonServiceResponse);
        } else {
        jsonServiceResponse='{\"status\":\"Failure\",\"bpmID\":\"12345678\"}';
        res.setStatusCode(returnedStatusCode );
        res.setBody(jsonServiceResponse);
        }
        return res;
    }
}