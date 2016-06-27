/**
 * OWASP Enterprise Security API (ESAPI)
 *
 * This file is part of the Open Web Application Security Project (OWASP)
 * Enterprise Security API (ESAPI) project. For details, please see
 * <a href="http://www.owasp.org/index.php/ESAPI">http://www.owasp.org/index.php/ESAPI</a>.
 *
 * Copyright (c) 2010 - Salesforce.com
 *
 * The Apex ESAPI implementation is published by Salesforce.com under the New BSD license. You should read and accept the
 * LICENSE before you use, modify, and/or redistribute this software.
 *
 * @author Yoel Gluck (securecloud .at. salesforce.com) <a href="http://www.salesforce.com">Salesforce.com</a>
 * @created 2010
 */

/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
Public class PBS_ValidatorHelperTest{
    private static final string ABC ='abc';
    private static final string UTF8 = 'utf-8';
    private static final string C280 = '%c2%80';
    //private static final string ZEROTONINE = '01234567890123456789012345678901234567890123456789';
    public static final string GOOGLE = 'www.google.com';
    private static final string SALESFORCE = 'na7.salesforce.com';
    private static final string CSALESFORCE = 'c.na7.salesforce.com';
    private static final string ZEROTONINE_10 = '0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789';
    //private static final string ONE_TXT = '1.txt';
        private static final string VALID1 = 'valid #1';
    private static final string VALID2 = 'valid #2';
    private static final string VALID3 = 'valid #3';
    private static final string VALID4 = 'valid #4';
    private static final string VALID5 = 'valid #5';
    private static final string VALID6 = 'valid #6';
    private static final string VALID7 = 'valid #7';
    private static final string VALID8 = 'valid #8';
    private static final string VALID9 = 'valid #9';
    private static final string VALID10 = 'valid #10';
    private static final string VALID11 = 'valid #11';
    private static final string INVALID1 ='invalid #1';
    private static final string INVALID2 ='invalid #2';
    private static final string INVALID3 ='invalid #3';
    private static final string INVALID4 ='invalid #4';
    private static final string INVALID5 ='invalid #5';
    private static final string INVALID6 ='invalid #6';
    private static final string INVALID7 ='invalid #7';
    private static final string INVALID8 ='invalid #8';
    private static final string INVALID9 ='invalid #9';
    private static final string INVALID10 ='invalid #10';
    private static final string INVALID11 ='invalid #11';
    private static final string INVALID13 ='invalid #13';
    
    
     private class HttpRequestParamsTest {
        private String inputStr;
        private Set<String> requiredParams;
        private Set<String> optionalParams;
        private String errText;
        private Boolean expectedResult;

        public HttpRequestParamsTest(String inputStr, Set<String> requiredParams, Set<String> optionalParams, String errText, Boolean expectedResult) {
            this.inputStr = inputStr;
            this.requiredParams = requiredParams;
            this.optionalParams = optionalParams;
            this.errText = errText;
            this.expectedResult = expectedResult;
        }
    }

    private static final HttpRequestParamsTest [] httpRequestParamsTests = new HttpRequestParamsTest[]{};

    private static final Set<String> requiredParams1 = new Set<String>{'USER', 'PASS', 'PARAM1'};
    private static final Set<String> requiredParams2 = new Set<String>{'USER'};
    private static final Set<String> requiredParams3 = new Set<String>{};

    private static final Set<String> optionalParams1 = new Set<String>{'OPTUSER', 'OPTPASS', 'OPTPARAM1'};
    private static final Set<String> optionalParams2 = new Set<String>{'OPTUSER'};
    private static final Set<String> optionalParams3 = new Set<String>{};

    static {
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?USER=def&PASS=jfg&PARAM1=ud847', requiredParams1, optionalParams1, VALID1, true));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?USER=def&PASS=jfg&PARAM1=ud847&OPTUSER=jhd6532', requiredParams1, optionalParams1, VALID2, true));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?USER=def&PASS=jfg&PARAM1=ud847&OPTUSER=jhd6532&OPTPASS=hdf&OPTPARAM1=g7345sfg', requiredParams1, optionalParams1, VALID3, true));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?USER=def&OPTUSER=123', requiredParams2, optionalParams1, VALID4, true));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html', requiredParams3, optionalParams3, VALID5, true));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html', requiredParams3, optionalParams1, VALID6, true));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?', requiredParams3, optionalParams3, VALID7, true));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?', requiredParams3, optionalParams1, VALID8, true));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?OPTUSER=ksjfdhg', requiredParams3, optionalParams2, VALID9, true));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?OPTUSER=ksjfdhg', requiredParams3, optionalParams1, VALID10, true));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?OPTPARAM1=ksjfdhg', requiredParams3, optionalParams1, VALID11, true));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?PASS=fdgg&USER=def&PARAM1=ud847', requiredParams1, optionalParams1, 'Valid #12', true));

        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?abc=def', requiredParams1, optionalParams1, INVALID1, false));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?USER=abc', requiredParams1, optionalParams1, INVALID2, false));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?USER=abc&PASS=gg', requiredParams1, optionalParams1, INVALID3, false));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?PASS=gg&PARAM1=dfg', requiredParams1, optionalParams1, INVALID4, false));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?USER=abc&PARAM1=dfg', requiredParams1, optionalParams1, INVALID5, false));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?user=abc&PASS=gg&PARAM1=dfg', requiredParams1, optionalParams1, INVALID6, false));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?USER=abc&PASS=gg&PARAM1=dfg&extra=sdfgfg', requiredParams1, optionalParams1, INVALID7, false));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?extra=sdfgfg&USER=abc&PASS=gg&PARAM1=dfg', requiredParams1, optionalParams1, INVALID8, false));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?extra=sdfgfg&USER=abc&PASS=gg&PARAM1=dfg', null, optionalParams1, INVALID9, false));
        httpRequestParamsTests.add(new HttpRequestParamsTest('test.html?extra=sdfgfg&USER=abc&PASS=gg&PARAM1=dfg', requiredParams1, null, INVALID10, false));
        httpRequestParamsTests.add(new HttpRequestParamsTest(null, requiredParams1, optionalParams1, INVALID11, false));
    }

    static testMethod void testValidatorIsValidHttpRequestParams() {
        for (HttpRequestParamsTest t : httpRequestParamsTests) {
                PageReference pr = null;
                if (t.inputStr != null){
                    pr = new PageReference(t.inputStr);}
            System.assertEquals(t.expectedResult, PBS_ESAPI_CC.validator().isValidHTTPRequestParameterSet(pr, t.requiredParams, t.optionalParams), t.errText);
        }
    }

    static testMethod void testValidatorGetValidHttpRequestParams() {
        for (HttpRequestParamsTest t : httpRequestParamsTests) {
            try {
                PageReference pr = null;
                if (t.inputStr != null){
                    pr = new PageReference(t.inputStr);}
                PBS_ESAPI_CC.validator().assertValidHTTPRequestParameterSet(pr, t.requiredParams, t.optionalParams);
                // if no exception - check if we are expecting a valid test
                System.assertEquals(true,t.expectedResult, t.errText);
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assertEquals(false,t.expectedResult, t.errText);
            }
        }
    }

    private class RedirectDefaultDomainTest {
        private String inputStr;
        private String errText;
        private Boolean expectedResult;

        public RedirectDefaultDomainTest(String inputStr, String errText, Boolean expectedResult) {
            this.inputStr = inputStr;
            this.errText = errText;
            this.expectedResult = expectedResult;
        }
    }

    private static final RedirectDefaultDomainTest [] redirectDefaultDomainTests = new RedirectDefaultDomainTest[]{};

    static {
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('/test.html', VALID1, true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('/test.html?', VALID2, true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('/test.html?USER=def', VALID3, true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('https://na7.salesforce.com/test.html?USER=def&OPTUSER=123', VALID4, true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('http://na7.salesforce.com/test.html', VALID5, true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('https://na7.salesforce.com', VALID6, true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('http://na7.salesforce.com', VALID7, true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('https://na7.salesforce.com/', VALID8, true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('http://na7.salesforce.com/', VALID9, true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('https://na7.salesforce.com/www.google.com', VALID10, true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('http://na7.salesforce.com/www.google.com', VALID11, true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('https://kjfhfg.salesforce.com/www.google.com', 'Valid #12', true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('http://le4t98whw.salesforce.com/www.google.com', 'Valid #13', true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('/javascript%3Atest', 'Valid #14', true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('/http%3A//na1.salesforce.com', 'Valid #15', true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('/http%3a//www.google.com', 'Valid #16', true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('https://c.na7.salesforce.com/', 'Valid #18', true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('https://sdfgdfgfsdg.c.na7.salesforce.com/', 'Valid #19', true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('/%D7%A9', 'Valid #20', true));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('https://c.na7.salesforce.com/apex/testPage?id=8435987435987435&value=1&param=2', 'Valid #21', true));

        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('test.html?abc=def', INVALID1, false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('test.html', INVALID2, false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('www.salesforce.com', INVALID3, false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest(GOOGLE, INVALID4, false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest(SALESFORCE, INVALID5, false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('javascript:eval', INVALID6, false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest(null, INVALID7, false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('', INVALID8, false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('http://na7.salesforce.com/'
            + ZEROTONINE_10
            + ZEROTONINE_10
            + ZEROTONINE_10
            + ZEROTONINE_10
            + ZEROTONINE_10, INVALID9, false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('https://c.na7.salesforce.com.c/', INVALID10, false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('https://c.na7.salesforce.comc/', INVALID11, false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('https://c.na7.salesforcec.com/', 'Invalid #12', false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('https://c.na7.salesforcecom/', INVALID13, false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('https:///', 'Invalid #14', false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('https://.salesforce.com/', 'Invalid #15', false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('https://salesforce.com/', 'Invalid #16', false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('https://0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789.salesforce.com/', 'Invalid #17', false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('/javascript:test', 'Invalid #18', false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('/javascript%GGtest', 'Invalid #19', false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('/' + EncodingUtil.urlDecode('%D7%A9', UTF8), 'Invalid #20', false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('/' + EncodingUtil.urlDecode(C280, UTF8), 'Invalid #21', false));
        redirectDefaultDomainTests.add(new RedirectDefaultDomainTest('https://na1.salesforce.com/' + EncodingUtil.urlDecode(C280, UTF8), 'Invalid #22', false));
    }

    static testMethod void testValidatorIsValidRedirectDefaultDomain() {
        PageReference pr = new PageReference('https://c.na7.salesforce.com');
        pr.getHeaders().put('Host', CSALESFORCE);
        Test.setCurrentPage(pr);

        for (RedirectDefaultDomainTest t : redirectDefaultDomainTests) {
            System.assertEquals(t.expectedResult, PBS_ESAPI_CC.validator().SFDC_isValidRedirectLocation(t.inputStr), t.errText);
        }
    }

    static testMethod void testValidatorGetValidRedirectDefaultDomain() {
        PageReference pr = new PageReference('https://c.na7.salesforce.com');
        pr.getHeaders().put('Host', CSALESFORCE);
        Test.setCurrentPage(pr);

        for (RedirectDefaultDomainTest t : redirectDefaultDomainTests) {
            try {
                String ret = PBS_ESAPI_CC.validator().SFDC_getValidRedirectLocation(t.inputStr);
                // if no exception - check if we are expecting a valid test
                System.assertEquals(true,t.expectedResult, t.errText);
                // also make sure return value is equal to input
                System.assert(ret.equals(t.inputStr), t.errText);
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assertEquals(false,t.expectedResult, t.errText);
            }
        }
    }
    
    
    private class RedirectTest {
        private String inputStr;
        private String currentDomain;
        private String errText;
        private Boolean expectedResult;

        public RedirectTest(String inputStr, String currentDomain, String errText, Boolean expectedResult) {
            this.inputStr = inputStr;
            this.currentDomain = currentDomain;
            this.errText = errText;
            this.expectedResult = expectedResult;
        }
    }

    private static final RedirectTest [] redirectTests = new RedirectTest[]{};

    static {
        redirectTests.add(new RedirectTest('/test.html', SALESFORCE, VALID1, true));
        redirectTests.add(new RedirectTest('/test.html?', SALESFORCE, VALID2, true));
        redirectTests.add(new RedirectTest('/test.html?USER=def', SALESFORCE, VALID3, true));
        redirectTests.add(new RedirectTest('https://na7.salesforce.com/test.html?USER=def&OPTUSER=123', SALESFORCE, VALID4, true));
        redirectTests.add(new RedirectTest('http://na7.salesforce.com/test.html', SALESFORCE, VALID5, true));
        redirectTests.add(new RedirectTest('https://na7.salesforce.com', SALESFORCE, VALID6, true));
        redirectTests.add(new RedirectTest('http://na7.salesforce.com', SALESFORCE, VALID7, true));
        redirectTests.add(new RedirectTest('https://na7.salesforce.com/', SALESFORCE, VALID8, true));
        redirectTests.add(new RedirectTest('http://na7.salesforce.com/', SALESFORCE, VALID9, true));
        redirectTests.add(new RedirectTest('https://na7.salesforce.com/www.google.com', SALESFORCE, VALID10, true));
        redirectTests.add(new RedirectTest('http://na7.salesforce.com/www.google.com', SALESFORCE, VALID11, true));
        redirectTests.add(new RedirectTest('/javascript%3Atest', SALESFORCE, 'Valid #12', true));
        redirectTests.add(new RedirectTest('/http%3A//na1.salesforce.com', SALESFORCE, 'Valid #13', true));
        redirectTests.add(new RedirectTest('/http%3a//www.google.com', SALESFORCE, 'Valid #14', true));
        redirectTests.add(new RedirectTest('https://c.na7.salesforce.com/', CSALESFORCE, 'Valid #16', true));
        redirectTests.add(new RedirectTest('https://sdfgdfgfsdg.c.na7.salesforce.com/', 'sdfgdfgfsdg.c.na7.salesforce.com', 'Valid #17', true));
        redirectTests.add(new RedirectTest('/%D7%A9', SALESFORCE, 'Valid #18', true));
        redirectTests.add(new RedirectTest('https://c.na7.salesforce.com/apex/testPage?id=8435987435987435&value=1&param=2', CSALESFORCE, 'Valid #19', true));
        redirectTests.add(new RedirectTest('https://www.google.com/', GOOGLE, 'Valid #20', true));
        redirectTests.add(new RedirectTest('https://1.2.google.com/', '1.2.google.com', 'Valid #21', true));
        redirectTests.add(new RedirectTest('https://na1.salesforce.com/', GOOGLE, 'Valid #22', true));

        redirectTests.add(new RedirectTest('test.html?abc=def', SALESFORCE, INVALID1, false));
        redirectTests.add(new RedirectTest('test.html', SALESFORCE, INVALID2, false));
        redirectTests.add(new RedirectTest('www.salesforce.com', 'www.salesforce.com', INVALID3, false));
        redirectTests.add(new RedirectTest(GOOGLE, 'www.google.com', INVALID4, false));
        redirectTests.add(new RedirectTest(SALESFORCE, 'na7.salesforce.com', INVALID5, false));
        redirectTests.add(new RedirectTest('javascript:eval', SALESFORCE, INVALID6, false));
        redirectTests.add(new RedirectTest(null, SALESFORCE, INVALID7, false));
        redirectTests.add(new RedirectTest('', SALESFORCE, INVALID8, false));
        redirectTests.add(new RedirectTest('http://na7.salesforce.com/'
            + ZEROTONINE_10
            + ZEROTONINE_10
            + ZEROTONINE_10
            + ZEROTONINE_10
            + ZEROTONINE_10, SALESFORCE, INVALID9, false));
        redirectTests.add(new RedirectTest('https://c.na7.salesforce.com.c/', CSALESFORCE, INVALID10, false));
        redirectTests.add(new RedirectTest('https://c.na7.salesforce.comc/', CSALESFORCE, INVALID11, false));
        redirectTests.add(new RedirectTest('https://c.na7.salesforcec.com/', CSALESFORCE, 'Invalid #12', false));
        redirectTests.add(new RedirectTest('https://c.na7.salesforcecom/', CSALESFORCE, INVALID13, false));
        redirectTests.add(new RedirectTest('https:///', SALESFORCE, 'Invalid #14', false));
        redirectTests.add(new RedirectTest('https://.salesforce.com/', 'salesforce.com', 'Invalid #15', false));
        redirectTests.add(new RedirectTest('https://0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789.salesforce.com/', 'salesforce.com', 'Invalid #16', false));
        redirectTests.add(new RedirectTest('/javascript:test', CSALESFORCE, 'Invalid #17', false));
        redirectTests.add(new RedirectTest('/javascript%GGtest', CSALESFORCE, 'Invalid #18', false));
        redirectTests.add(new RedirectTest('/' + EncodingUtil.urlDecode('%D7%A9', UTF8), CSALESFORCE, 'Invalid #19', false));
        redirectTests.add(new RedirectTest('/' + EncodingUtil.urlDecode(C280, UTF8), CSALESFORCE, 'Invalid #20', false));
        redirectTests.add(new RedirectTest('https://na1.salesforce.com/' + EncodingUtil.urlDecode(C280, UTF8), 'na1.salesforce.com', 'Invalid #21', false));
        redirectTests.add(new RedirectTest('https://c.na7.salesforcecom/', null, 'Invalid #22', false));
        redirectTests.add(new RedirectTest('https://www.google.com/', 'login.google.com', 'Invalid #23', false));
        redirectTests.add(new RedirectTest('https://1.2.google.com/', '', 'Invalid #24', false));
        redirectTests.add(new RedirectTest('https:///', '', 'Invalid #25', false));
        redirectTests.add(new RedirectTest('https://abc/', ABC, 'Invalid #26', false));
    }

    static testMethod void testValidatorIsValidRedirect() {
        for (RedirectTest t : redirectTests) {
            System.assertEquals(t.expectedResult, PBS_ESAPI_CC.validator().SFDC_isValidRedirectLocation(t.inputStr, t.currentDomain), t.errText);
        }
    }

    static testMethod void testValidatorGetValidRedirect() {
        for (RedirectTest t : redirectTests) {
            try {
                String ret = PBS_ESAPI_CC.validator().SFDC_getValidRedirectLocation(t.inputStr, t.currentDomain);
                // if no exception - check if we are expecting a valid test
                System.assertEquals(true,t.expectedResult, t.errText);
                // also make sure return value is equal to input
                System.assert(ret.equals(t.inputStr), t.errText);
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assertEquals(false,t.expectedResult, t.errText);
            }
        }
    }
}