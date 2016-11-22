/**
 * OWASP Enterprise Security API (PBS_ESAPI_CC)
 *
 * This file is part of the Open Web Application Security Project (OWASP)
 * Enterprise Security API (PBS_ESAPI_CC) project. For details, please see
 * <a href="http://www.owasp.org/index.php/PBS_ESAPI_CC">http://www.owasp.org/index.php/PBS_ESAPI_CC</a>.
 *
 * Copyright (c) 2010 - Salesforce.com
 *
 * The Apex PBS_ESAPI_CC implementation is published by Salesforce.com under the New BSD license. You should read and accept the
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
private class PBS_Encoder_Test {

    public static final string VALID_1 = 'Valid #1';
    public static final string VALID_2 = 'Valid #2';
    public static final string VALID_3 = 'Valid #3';
    public static final string VALID_4 = 'Valid #4';
    public static final string VALID_5 = 'Valid #5';
    public static final string VALID_6 = 'Valid #6';
    public static final string VALID_7 = 'Valid #7';
    public static final string ABC_NDEF = 'abc\ndef' ;
    public static final string ABCDEF = 'abc\'def';
    public static final string ABC_DEF = 'abc"def';
    public static final string ABC_RDEF = 'abc\rdef';
    public static final string VALID_8 = 'Valid #8';
    public static final string VALID_9 = 'Valid #9';
    public static final string  ABC =  'abc' ;
    public static final string ABC_TESTDEF = 'abc<b>test</b>def';
    public static final string ABC_LTDEF = 'abc&lt;def';
    public static final string ABC_SFDGDEF = 'abc<fghgfh&lt;<sfdg>&amp;def';
    public static final string UTF8= 'UTF-8';
    public static final string UTF16= 'UTF-16';
    
    
    
    private class EncodeTest {
        public String inputStr;
        public String expectedOutput;
        public String errText;
        public Boolean expectedResult;
        public String encoding;

        public EncodeTest(String inputStr, String expectedOutput, String errText, Boolean expectedResult) {
            this.inputStr = inputStr;
            this.expectedOutput = expectedOutput;
            this.errText = errText;
            this.expectedResult = expectedResult;
        }

        public EncodeTest(String inputStr, String encoding, String expectedOutput, String errText, Boolean expectedResult) {
            this.inputStr = inputStr;
            this.encoding = encoding;
            this.expectedOutput = expectedOutput;
            this.errText = errText;
            this.expectedResult = expectedResult;
        }
    }

    private static final EncodeTest [] htmlEncodeTests = new EncodeTest[]{};
    private static final EncodeTest [] jsEncodeTests = new EncodeTest[]{};
    private static final EncodeTest [] jsInHtmlEncodeTests = new EncodeTest[]{};
    private static final EncodeTest [] urlEncodeTests = new EncodeTest[]{};
    private static final EncodeTest [] urlEncodeWithEncodingTests = new EncodeTest[]{};

    static {
        htmlEncodeTests.add(new EncodeTest(ABC, ABC, VALID_1, true));
        htmlEncodeTests.add(new EncodeTest(ABC_TESTDEF, 'abc&lt;b&gt;test&lt;/b&gt;def', VALID_2, true));
        htmlEncodeTests.add(new EncodeTest(ABC_LTDEF, 'abc&amp;lt;def', VALID_3, true));
        htmlEncodeTests.add(new EncodeTest(ABC_SFDGDEF, 'abc&lt;fghgfh&amp;lt;&lt;sfdg&gt;&amp;amp;def', VALID_4, true));
        htmlEncodeTests.add(new EncodeTest(ABCDEF, 'abc&#39;def', VALID_5, true));
        htmlEncodeTests.add(new EncodeTest(ABC_DEF, 'abc&quot;def', VALID_6, true));

        jsEncodeTests.add(new EncodeTest(ABC, ABC, VALID_1, true));
        jsEncodeTests.add(new EncodeTest(ABC_TESTDEF, 'abc\\u003Cb\\u003Etest\\u003C\\/b\\u003Edef', VALID_2, true));
        jsEncodeTests.add(new EncodeTest(ABC_LTDEF, 'abc&lt;def', VALID_3, true));
        jsEncodeTests.add(new EncodeTest(ABC_SFDGDEF, 'abc\\u003Cfghgfh&lt;\\u003Csfdg\\u003E&amp;def', VALID_4, true));
        jsEncodeTests.add(new EncodeTest('abc\\def', 'abc\\\\def', VALID_5, true));
        jsEncodeTests.add(new EncodeTest(ABCDEF, 'abc\\\'def', VALID_6, true));
        jsEncodeTests.add(new EncodeTest(ABC_RDEF, 'abc\\rdef', VALID_7, true));
        jsEncodeTests.add(new EncodeTest(ABC_NDEF, 'abc\\ndef', VALID_8, true));
        jsEncodeTests.add(new EncodeTest(ABC_DEF, 'abc\\"def', VALID_9, true));
        jsEncodeTests.add(new EncodeTest('abc!--def', 'abc\\!--def', 'Valid #10', true));
        jsEncodeTests.add(new EncodeTest('abc<!--def', 'abc\\u003C\\!--def', 'Valid #11', true));
        jsEncodeTests.add(new EncodeTest('abc/def', 'abc\\/def', 'Valid #12', true));

        jsInHtmlEncodeTests.add(new EncodeTest(ABC, ABC, VALID_1, true));
        jsInHtmlEncodeTests.add(new EncodeTest(ABC_TESTDEF, 'abc&lt;b&gt;test&lt;/b&gt;def', VALID_2, true));
        jsInHtmlEncodeTests.add(new EncodeTest(ABC_LTDEF, 'abc\\\\&amp;lt;def', VALID_3, true));
        jsInHtmlEncodeTests.add(new EncodeTest(ABC_SFDGDEF, 'abc&lt;fghgfh\\\\&amp;lt;&lt;sfdg&gt;\\\\&amp;amp;def', VALID_4, true));
        jsInHtmlEncodeTests.add(new EncodeTest(ABCDEF, 'abc\\&#39;def', VALID_5, true));
        jsInHtmlEncodeTests.add(new EncodeTest(ABC_DEF, 'abc\\&quot;def', VALID_6, true));
        jsInHtmlEncodeTests.add(new EncodeTest('abc&def', 'abc\\\\&amp;def', VALID_7, true));
        jsInHtmlEncodeTests.add(new EncodeTest('abc\\def', 'abc\\\\def', VALID_8, true));
        jsInHtmlEncodeTests.add(new EncodeTest(ABC_RDEF, 'abc\\rdef', VALID_9, true));
        jsInHtmlEncodeTests.add(new EncodeTest(ABC_NDEF, 'abc\\ndef', 'Valid #10', true));
        jsInHtmlEncodeTests.add(new EncodeTest('abc<def', ABC_LTDEF, 'Valid #11', true));
        jsInHtmlEncodeTests.add(new EncodeTest('abc>def', 'abc&gt;def', 'Valid #12', true));

        urlEncodeTests.add(new EncodeTest(ABC, ABC, VALID_1, true));
        urlEncodeTests.add(new EncodeTest(ABC_TESTDEF, 'abc%3Cb%3Etest%3C%2Fb%3Edef', VALID_2, true));
        urlEncodeTests.add(new EncodeTest(ABC_LTDEF, 'abc%26lt%3Bdef', VALID_3, true));
        urlEncodeTests.add(new EncodeTest(ABC_SFDGDEF, 'abc%3Cfghgfh%26lt%3B%3Csfdg%3E%26amp%3Bdef', VALID_4, true));
        urlEncodeTests.add(new EncodeTest(ABCDEF, 'abc%27def', VALID_5, true));
        urlEncodeTests.add(new EncodeTest(ABC_DEF, 'abc%22def', VALID_6, true));
        urlEncodeTests.add(new EncodeTest(ABC_RDEF, 'abc%0Ddef', VALID_7, true));
        urlEncodeTests.add(new EncodeTest(ABC_NDEF, 'abc%0Adef', VALID_8, true));
        urlEncodeTests.add(new EncodeTest(ABC + EncodingUtil.urlDecode('%D7%A9', UTF8) + 'def', 'abc%D7%A9def', VALID_9, true));

        urlEncodeWithEncodingTests.add(new EncodeTest(ABC, UTF8, ABC, VALID_1, true));
        urlEncodeWithEncodingTests.add(new EncodeTest(ABC_TESTDEF, UTF8, 'abc%3Cb%3Etest%3C%2Fb%3Edef', VALID_2, true));
        urlEncodeWithEncodingTests.add(new EncodeTest(ABC_LTDEF, UTF8, 'abc%26lt%3Bdef', VALID_3, true));
        urlEncodeWithEncodingTests.add(new EncodeTest(ABC_SFDGDEF, UTF8, 'abc%3Cfghgfh%26lt%3B%3Csfdg%3E%26amp%3Bdef', VALID_4, true));
        urlEncodeWithEncodingTests.add(new EncodeTest(ABCDEF, UTF8, 'abc%27def', VALID_5, true));
        urlEncodeWithEncodingTests.add(new EncodeTest(ABC_DEF, UTF8, 'abc%22def', VALID_6, true));
        urlEncodeWithEncodingTests.add(new EncodeTest(ABC_RDEF, UTF8, 'abc%0Ddef', VALID_7, true));
        urlEncodeWithEncodingTests.add(new EncodeTest(ABC_NDEF, UTF8, 'abc%0Adef', VALID_8, true));
        urlEncodeWithEncodingTests.add(new EncodeTest(ABC + EncodingUtil.urlDecode('%D7%A9', UTF8) + 'def', UTF8, 'abc%D7%A9def', VALID_9, true));

        urlEncodeWithEncodingTests.add(new EncodeTest(ABC, UTF16, ABC, VALID_1, true));
        urlEncodeWithEncodingTests.add(new EncodeTest(ABC_TESTDEF, UTF16, 'abc%FE%FF%00%3Cb%FE%FF%00%3Etest%FE%FF%00%3C%00%2Fb%FE%FF%00%3Edef', VALID_2, true));
        urlEncodeWithEncodingTests.add(new EncodeTest(ABC_LTDEF, UTF16, 'abc%FE%FF%00%26lt%FE%FF%00%3Bdef', VALID_3, true));
        urlEncodeWithEncodingTests.add(new EncodeTest(ABC_SFDGDEF, UTF16, 'abc%FE%FF%00%3Cfghgfh%FE%FF%00%26lt%FE%FF%00%3B%00%3Csfdg%FE%FF%00%3E%00%26amp%FE%FF%00%3Bdef', VALID_4, true));
        urlEncodeWithEncodingTests.add(new EncodeTest(ABCDEF, UTF16, 'abc%FE%FF%00%27def', VALID_5, true));
        urlEncodeWithEncodingTests.add(new EncodeTest(ABC_DEF, UTF16, 'abc%FE%FF%00%22def', VALID_6, true));
        urlEncodeWithEncodingTests.add(new EncodeTest(ABC_RDEF, UTF16, 'abc%FE%FF%00%0Ddef', VALID_7, true));
        urlEncodeWithEncodingTests.add(new EncodeTest(ABC_NDEF, UTF16, 'abc%FE%FF%00%0Adef', VALID_8, true));
        urlEncodeWithEncodingTests.add(new EncodeTest(ABC + EncodingUtil.urlDecode('%D7%A9', UTF8) + 'def', UTF16, 'abc%FE%FF%05%E9def', VALID_9, true));
    }

    static testMethod void testEncoderHtmlEncode() {
        for (EncodeTest t : htmlEncodeTests) {
            try {
                String ret = PBS_ESAPI_CC.encoder().SFDC_HTMLENCODE(t.inputStr);
                // if no exception - check if we are expecting a valid test
                /*System.assert(t.expectedResult == true, t.errText);*/
                System.assertEquals(true,t.expectedResult, t.errText);
                // also make sure return value is equal to input
                System.assert(ret.equals(t.expectedOutput), t.errText);
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
/*                System.assert(t.expectedResult == false, t.errText); */
                System.assertEquals(false, t.expectedResult, t.errText);
            }
        }
    }

    static testMethod void testEncoderJsEncode() {
        for (EncodeTest t : jsEncodeTests) {
            try {
                String ret = PBS_ESAPI_CC.encoder().SFDC_JSENCODE(t.inputStr);
                // if no exception - check if we are expecting a valid test
                /*System.assert(t.expectedResult == true, t.errText);*/
                System.assertEquals(true,t.expectedResult, t.errText);
                // also make sure return value is equal to input
                System.assert(ret.equals(t.expectedOutput), t.errText);
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
               /* System.assert(t.expectedResult == false, t.errText);*/
                System.assertEquals(false, t.expectedResult, t.errText);
            }
        }
    }

    static testMethod void testEncoderJsInHtmlEncode() {
        for (EncodeTest t : jsInHtmlEncodeTests) {
            try {
                String ret = PBS_ESAPI_CC.encoder().SFDC_JSINHTMLENCODE(t.inputStr);
                // if no exception - check if we are expecting a valid test
                //System.assert(t.expectedResult == true, t.errText);
                System.assertEquals(true,t.expectedResult, t.errText);
                // also make sure return value is equal to input
                System.debug('expected: ' + t.expectedOutput);
                System.debug('observed: ' + ret);
                System.assert(ret.equals(t.expectedOutput), t.errText);
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                //System.assert(t.expectedResult == false, t.errText);
                System.assertEquals(false, t.expectedResult, t.errText);
            }
        }
    }

    static testMethod void testEncoderUrlEncode() {
        for (EncodeTest t : urlEncodeTests) {
            try {
                String ret = PBS_ESAPI_CC.encoder().SFDC_URLENCODE(t.inputStr);
                // if no exception - check if we are expecting a valid test
                //System.assert(t.expectedResult == true, t.errText);
                System.assertEquals(true,t.expectedResult, t.errText);
                // also make sure return value is equal to input
                System.assert(ret.equals(t.expectedOutput), t.errText);
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                //System.assert(t.expectedResult == false, t.errText);
                System.assertEquals(false, t.expectedResult, t.errText);
            }
        }
    }

    static testMethod void testEncoderUrlEncodeWithEncoding() {
        for (EncodeTest t : urlEncodeWithEncodingTests) {
            try {
                String ret = PBS_ESAPI_CC.encoder().SFDC_URLENCODE(t.inputStr, t.encoding);
                // if no exception - check if we are expecting a valid test
                //System.assert(t.expectedResult == true, t.errText);
                System.assertEquals(true,t.expectedResult, t.errText);
                // also make sure return value is equal to input
                System.assert(ret.equals(t.expectedOutput), t.errText);
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                //System.assert(t.expectedResult == false, t.errText);
                System.assertEquals(false, t.expectedResult, t.errText);
            }
        }
    }
}