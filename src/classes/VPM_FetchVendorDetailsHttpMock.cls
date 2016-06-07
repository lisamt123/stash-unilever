@isTest
global class VPM_FetchVendorDetailsHttpMock implements HttpCalloutMock {
    global HttpResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        String jsonServiceResponse = '{\"ECC\":\"Sirius\",\"VendorCode\":14428,\"BankCountry\":\"PL\",\"BankKey\":17501077,\"BankAccount\":1106821,\"ControlKey\":96,\"AccountHolder\":\"BAJK SERWIS SP. Z O.O.\",\"IBAN\":\"PL96175010770000000001106821\",\"CompanyCode\":\"PL10\",\"BankName\":\"RAIFF O. W SZCZECINIE UL.JEDNOSCI NARODOWEJ 3/4\",\"SwiftKey\":\"RCBWPLPW\"}';
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody(jsonServiceResponse);
        return res;
    }
}