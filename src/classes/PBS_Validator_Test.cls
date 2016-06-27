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
private class PBS_Validator_Test {
    //String variables to avoid code containing duplicate String literals
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
    private static final string ABC ='abc';
    private static final string UTF8 = 'utf-8';
    private static final string C280 = '%c2%80';
    private static final string ZEROTONINE = '01234567890123456789012345678901234567890123456789';
    public static final string GOOGLE = 'www.google.com';
    //private static final string SALESFORCE = 'na7.salesforce.com';
    //private static final string CSALESFORCE = 'c.na7.salesforce.com';
    //private static final string ZEROTONINE_10 = '0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789';
    private static final string ONE_TXT = '1.txt';
    
    private class CreditCardTest {
        private String cardStr;
        private String errText;
        private Boolean allowNull;
        private Boolean expectedResult;

        public CreditCardTest(String cardStr, String errText, Boolean allowNull, Boolean expectedResult) {
            this.cardStr = cardStr;
            this.errText = errText;
            this.allowNull = allowNull;
            this.expectedResult = expectedResult;
        }
    }

    private static final CreditCardTest [] ccTests = new CreditCardTest[]{};

    static {
        ccTests.add(new CreditCardTest('4111111111111111', 'Valid basic test - 4111111111111111', false, true));
        ccTests.add(new CreditCardTest('4111-1111-1111-1111', 'Valid basic test dashes - 4111-1111-1111-1111', false, true));
        ccTests.add(new CreditCardTest('4111 1111 1111 1111', 'Valid basic test spaces - 4111 1111 1111 1111', false, true));

        ccTests.add(new CreditCardTest('111-1111-1111-1111', 'Invalid missing digit - 111-1111-1111-1111', false, false));
        ccTests.add(new CreditCardTest('4111-111-1111-1111', 'Invalid missing digit - 4111-111-1111-1111', false, false));
        ccTests.add(new CreditCardTest('4111-1111-111-1111', 'Invalid missing digit - 4111-1111-111-1111', false, false));
        ccTests.add(new CreditCardTest('4111-1111-1111-111', 'Invalid missing digit - 4111-1111-1111-111', false, false));

        ccTests.add(new CreditCardTest('4111-1111-1111-1112', 'Invalid incorrect digit - 4111-1111-1111-1112', false, false));
        ccTests.add(new CreditCardTest('4111-6789-0123-4567', 'Invalid incorrect digits - 4111-6789-0123-4567', false, false));

        ccTests.add(new CreditCardTest('41111-6789-0123-4567', 'Invalid incorrect length - 41111-6789-0123-4567', false, false));
        ccTests.add(new CreditCardTest('1111-16789-0123-4567', 'Invalid incorrect length - 1111-16789-0123-4567', false, false));
        ccTests.add(new CreditCardTest('1111-6789-10123-4567', 'Invalid incorrect length - 1111-6789-10123-4567', false, false));
        ccTests.add(new CreditCardTest('1111-6789-0123-14567', 'Invalid incorrect length - 1111-6789-0123-14567', false, false));
        ccTests.add(new CreditCardTest('1111-6789-0123-145', 'Invalid incorrect length - 1111-6789-0123-145', false, false));

        ccTests.add(new CreditCardTest('4111a1111a1111a1111', 'Invalid character - 4111a1111a1111a1111', false, false));
        ccTests.add(new CreditCardTest('a4111-1111-1111-1111', 'Invalid character - a4111-1111-1111-1111', false, false));

        ccTests.add(new CreditCardTest(null, 'Invalid null', false, false));
        ccTests.add(new CreditCardTest(null, 'Valid null', true, true));
        ccTests.add(new CreditCardTest('', 'Invalid empty', false, false));
        ccTests.add(new CreditCardTest('', 'Valid empty', true, true));

        //ccTests.add(new CreditCardTest('378282246310005', 'Valid - American Express - 378282246310005', false, true)); // card not supported
        //ccTests.add(new CreditCardTest('371449635398431', 'Valid - American Express - 371449635398431', false, true)); // card not supported
        //ccTests.add(new CreditCardTest('378734493671000', 'Valid - American Express Corporate - 378734493671000', false, true));
        ccTests.add(new CreditCardTest('5610591081018250', 'Valid - Australian BankCard - 5610591081018250', false, true));
        //ccTests.add(new CreditCardTest('30569309025904', 'Valid - Diners Club - 30569309025904', false, true)); // card not supported
        //ccTests.add(new CreditCardTest('38520000023237', 'Valid - Diners Club - 38520000023237', false, true)); // card not supported
        ccTests.add(new CreditCardTest('6011111111111117', 'Valid - Discover - 6011111111111117', false, true));
        ccTests.add(new CreditCardTest('6011000990139424', 'Valid - Discover - 6011000990139424', false, true));
        ccTests.add(new CreditCardTest('3530111333300000', 'Valid - JCB - 3530111333300000', false, true));
        ccTests.add(new CreditCardTest('3566002020360505', 'Valid - JCB - 3566002020360505', false, true));
        ccTests.add(new CreditCardTest('5555555555554444', 'Valid - MasterCard - 5555555555554444', false, true));
        ccTests.add(new CreditCardTest('5105105105105100', 'Valid - MasterCard - 5105105105105100', false, true));
        ccTests.add(new CreditCardTest('4111111111111111', 'Valid - Visa - 4111111111111111', false, true));
        ccTests.add(new CreditCardTest('4012888888881881', 'Valid - Visa - 4012888888881881', false, true));
        //ccTests.add(new CreditCardTest('4222222222222', 'Valid - Visa - 4222222222222', false, true)); // not supported (not 16 digits card)
    }

    static testMethod void testValidatorIsValidCreditCard() {

        for (CreditCardTest t : ccTests) {
            System.assertEquals(t.expectedResult, PBS_ESAPI_CC.validator().isValidCreditCard(t.cardStr, t.allowNull), t.errText);
        }
    }

    static testMethod void testValidatorGetValidCreditCard() {
        for (CreditCardTest t : ccTests) {
            try {
                String ret = PBS_ESAPI_CC.validator().getValidCreditCard(t.cardStr, t.allowNull);
                // if no exception - check if we are expecting a valid test
                System.assertEquals(true,t.expectedResult, t.errText);
                // also make sure return value is equal to input unless null if input was empty and that is allowed
                if (ret != null){
                    System.assert(ret.equals(t.cardStr), t.errText);}
                else{
                    System.assert(t.allowNull && t.cardStr == null, t.errText);}
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assertEquals(false,t.expectedResult, t.errText);
            }
        }
    }

    private class DateTest {
        private String dateStr;
        private String dateFormat;
        private String errText;
        private Boolean allowNull;
        private Boolean expectedResult;

        public DateTest(String dateStr, String dateFormat, String errText, Boolean allowNull, Boolean expectedResult) {
            this.dateStr = dateStr;
            this.dateFormat = dateFormat;
            this.errText = errText;
            this.allowNull = allowNull;
            this.expectedResult = expectedResult;
        }
    }

    private static final DateTest [] dateTests = new DateTest[]{};

    static {

        // test function structure

        dateTests.add(new DateTest('25/10/99', PBS_SFDCPatterns_CC.Date1, 'Valid basic test - 25/10/99 - Date1 - dd/mm/yy', false, true));
        dateTests.add(new DateTest('25/10/1999', PBS_SFDCPatterns_CC.Date1, 'Invalid basic test - 25/10/1999 - Date1 - dd/mm/yy', false, false));
        dateTests.add(new DateTest('251099', PBS_SFDCPatterns_CC.Date1, 'Invalid basic test - 251099 - Date1 - dd/mm/yy', false, false));

        dateTests.add(new DateTest(null, PBS_SFDCPatterns_CC.Date1, 'Invalid basic test - null - Date1 - dd/mm/yy', false, false));
        dateTests.add(new DateTest(null, PBS_SFDCPatterns_CC.Date1, 'Invalid basic test - null - Date1 - dd/mm/yy', true, true));
        dateTests.add(new DateTest('', PBS_SFDCPatterns_CC.Date1, 'Invalid basic test - empty - Date1 - dd/mm/yy', false, false));
        dateTests.add(new DateTest('', PBS_SFDCPatterns_CC.Date1, 'Invalid basic test - empty - Date1 - dd/mm/yy', true, true));

        dateTests.add(new DateTest('25/10/99', null, 'Invalid basic test - null format', false, false));

        dateTests.add(new DateTest('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', '^[A]*$', 'Invalid basic test - too long', false, false));

        // test regex formats

        // dd/mm/yy
        dateTests.add(new DateTest('25/10/99', PBS_SFDCPatterns_CC.Date1, 'Valid basic test - 25/10/99 - Date1 - dd/mm/yy', false, true));
        dateTests.add(new DateTest('25/25/99', PBS_SFDCPatterns_CC.Date1, 'Invalid month value - 25/25/99 - Date1 - dd/mm/yy', false, false));
        dateTests.add(new DateTest('25/aa/99', PBS_SFDCPatterns_CC.Date1, 'Invalid month value - 25/aa/99 - Date1 - dd/mm/yy', false, false));
        dateTests.add(new DateTest('25//99', PBS_SFDCPatterns_CC.Date1, 'Invalid empty month value - 25//99 - Date1 - dd/mm/yy', false, false));
        dateTests.add(new DateTest(' 25/10/99', PBS_SFDCPatterns_CC.Date1, 'Invalid value -  25/10/99 - Date1 - dd/mm/yy', false, false));
        dateTests.add(new DateTest('25/10/99 ', PBS_SFDCPatterns_CC.Date1, 'Invalid value - 25/10/99  - Date1 - dd/mm/yy', false, false));
        dateTests.add(new DateTest('25-10-99 ', PBS_SFDCPatterns_CC.Date1, 'Invalid value - 25-10-99 - Date1 - dd/mm/yy', false, false));
        dateTests.add(new DateTest('32/10/99 ', PBS_SFDCPatterns_CC.Date1, 'Invalid value - 32/10/99 - Date1 - dd/mm/yy', false, false));
        dateTests.add(new DateTest('31/00/99 ', PBS_SFDCPatterns_CC.Date1, 'Invalid value - 31/00/99 - Date1 - dd/mm/yy', false, false));
        dateTests.add(new DateTest('00/01/99 ', PBS_SFDCPatterns_CC.Date1, 'Invalid value - 00/01/99 - Date1 - dd/mm/yy', false, false));
        dateTests.add(new DateTest('29/01/9 ', PBS_SFDCPatterns_CC.Date1, 'Invalid value - 29/01/9 - Date1 - dd/mm/yy', false, false));

        // (d)d/-.(m)m/-.(yy)yy
        dateTests.add(new DateTest('25/10/99', PBS_SFDCPatterns_CC.Date4, 'Valid test - 25/10/99 - Date4 - (d)d/-.(m)m/-.(yy)yy', false, true));
        dateTests.add(new DateTest('5/10/1999', PBS_SFDCPatterns_CC.Date4, 'Valid test - 5/10/1999 - Date4 - (d)d/-.(m)m/-.(yy)yy', false, true));
        dateTests.add(new DateTest('15/2/08', PBS_SFDCPatterns_CC.Date4, 'Valid test - 15/2/08 - Date4 - (d)d/-.(m)m/-.(yy)yy', false, true));
        dateTests.add(new DateTest('15-2-08', PBS_SFDCPatterns_CC.Date4, 'Valid test - 15-2-08 - Date4 - (d)d/-.(m)m/-.(yy)yy', false, true));
        dateTests.add(new DateTest('15.2.08', PBS_SFDCPatterns_CC.Date4, 'Valid test - 15.2.08 - Date4 - (d)d/-.(m)m/-.(yy)yy', false, true));
        dateTests.add(new DateTest('15.02.08', PBS_SFDCPatterns_CC.Date4, 'Valid test - 15.02.08 - Date4 - (d)d/-.(m)m/-.(yy)yy', false, true));
        dateTests.add(new DateTest('15//08', PBS_SFDCPatterns_CC.Date4, 'Valid test - 15//08 - Date4 - (d)d/-.(m)m/-.(yy)yy', false, false));
        dateTests.add(new DateTest('15.a.08', PBS_SFDCPatterns_CC.Date4, 'Valid test - 15.a.08 - Date4 - (d)d/-.(m)m/-.(yy)yy', false, false));
        dateTests.add(new DateTest('2008/10/10', PBS_SFDCPatterns_CC.Date4, 'Valid test - 2008/10/10 - Date4 - (d)d/-.(m)m/-.(yy)yy', false, false));
        dateTests.add(new DateTest('', PBS_SFDCPatterns_CC.Date4, 'Valid test - empty - Date4 - (d)d/-.(m)m/-.(yy)yy', false, false));
    }

    static testMethod void testValidatorIsValidDate() {

        for (DateTest t : dateTests) {
            System.assertEquals(t.expectedResult, PBS_ESAPI_CC.validator().SFDC_isValidDate(t.dateStr, t.dateFormat, t.allowNull)  , t.errText);
        }
    }

    static testMethod void testValidatorGetValidDate() {
        for (DateTest t : dateTests) {
            try {
                String ret = PBS_ESAPI_CC.validator().SFDC_getValidDate(t.dateStr, t.dateFormat, t.allowNull);
                // if no exception - check if we are expecting a valid test
                System.assertEquals(true,t.expectedResult, t.errText);
                // also make sure return value is equal to input unless null if input was empty and that is allowed
                if (ret != null){
                    System.assert(ret.equals(t.dateStr), t.errText);}
                else{
                    System.assert(t.allowNull && t.dateStr == null, t.errText);}
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assertEquals(false,t.expectedResult, t.errText);
            }
        }
    }

    private class DoubleTest {
        private String inputStr;
        private Double minValue;
        private Double maxValue;
        private String errText;
        private Boolean allowNull;
        private Boolean expectedResult;

        public DoubleTest(String inputStr, Double minValue, Double maxValue, String errText, Boolean allowNull, Boolean expectedResult) {
            this.inputStr = inputStr;
            this.minValue = minValue;
            this.maxValue = maxValue;
            this.errText = errText;
            this.allowNull = allowNull;
            this.expectedResult = expectedResult;
        }
    }

    private static final DoubleTest [] doubleTests = new DoubleTest[]{};

    static {
        doubleTests.add(new DoubleTest('1.964', (Double)(-2.0), (Double)(2.0), VALID1, false, true));
        doubleTests.add(new DoubleTest('+1.964', (Double)(-2.0), (Double)(2.0), VALID2, false, true));
        doubleTests.add(new DoubleTest('-3.38475', (Double)(-5.0), (Double)(-2.0), VALID3, false, true));
        doubleTests.add(new DoubleTest('1', (Double)(0), (Double)(2), VALID4, false, true));
        doubleTests.add(new DoubleTest('0', (Double)(-2.0), (Double)(0), VALID5, false, true));
        doubleTests.add(new DoubleTest('0', (Double)(0), (Double)(0), VALID6, false, true));
        doubleTests.add(new DoubleTest(null, (Double)(1.0), (Double)(2.0), VALID7, true, true));
        doubleTests.add(new DoubleTest('1.0E+3', (Double)(500), (Double)(2000), VALID8, false, true));

        doubleTests.add(new DoubleTest('1.964', (Double)(2.0), (Double)(1.0), INVALID1, false, false));
        doubleTests.add(new DoubleTest(null, (Double)(1.0), (Double)(2.0), INVALID2, false, false));
        doubleTests.add(new DoubleTest('', (Double)(1.0), (Double)(2.0), INVALID3, false, false));
        doubleTests.add(new DoubleTest('1.0', (Double)(2.0), (Double)(3.0), INVALID4, false, false));
        doubleTests.add(new DoubleTest('5.0', (Double)(2.0), (Double)(3.0), INVALID5, false, false));
        doubleTests.add(new DoubleTest('2.5a', (Double)(2.0), (Double)(3.0), INVALID6, false, false));
        doubleTests.add(new DoubleTest('2e', (Double)(2.0), (Double)(3.0), INVALID7, false, false));
        doubleTests.add(new DoubleTest('1.e+50', (Double)(2.0), (Double)(3.0), INVALID8, false, false));
        doubleTests.add(new DoubleTest('7.237005577332262213973186563043e+75', (Double)(2.0), (Double)(3.0), INVALID9, false, false));
        doubleTests.add(new DoubleTest('10+10', (Double)(500), (Double)(2000), INVALID10, false, false));
    }

    static testMethod void testValidatorIsValidDouble() {
        for (DoubleTest t : doubleTests) {
            System.assertEquals(t.expectedResult, PBS_ESAPI_CC.validator().isValidDouble(t.inputStr, t.minValue, t.maxValue, t.allowNull), t.errText);
        }
    }

    static testMethod void testValidatorGetValidDouble() {
        for (DoubleTest t : doubleTests) {
            try {
                Double ret = PBS_ESAPI_CC.validator().getValidDouble(t.inputStr, t.minValue, t.maxValue, t.allowNull);
                // if no exception - check if we are expecting a valid test
                System.assertEquals(true,t.expectedResult, t.errText);
                // also make sure return value is equal to Double.valueOf(input) unless null if input was empty and that is allowed
                if (ret != null){
                    System.assert(ret == Double.valueOf(t.inputStr), t.errText);}
                else{
                    System.assert(t.allowNull && (t.inputStr == null || t.inputStr.length() == 0), t.errText);}
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assertEquals(false,t.expectedResult, t.errText);
            }
        }
    }

    private class IntTest {
        private String inputStr;
        private Integer minValue;
        private Integer maxValue;
        private String errText;
        private Boolean allowNull;
        private Boolean expectedResult;

        public IntTest(String inputStr, Integer minValue, Integer maxValue, String errText, Boolean allowNull, Boolean expectedResult) {
            this.inputStr = inputStr;
            this.minValue = minValue;
            this.maxValue = maxValue;
            this.errText = errText;
            this.allowNull = allowNull;
            this.expectedResult = expectedResult;
        }
    }

    private static final IntTest [] intTests = new IntTest[]{};

    static {
        intTests.add(new IntTest('1', -2, 2, VALID1, false, true));
        intTests.add(new IntTest('-3', -5, -2, VALID2, false, true));
        intTests.add(new IntTest('1', 0, 2, VALID3, false, true));
        intTests.add(new IntTest('0', -2, 0, VALID4, false, true));
        intTests.add(new IntTest('0', 0, 0, VALID5, false, true));
        intTests.add(new IntTest(null, 1, 2, VALID6, true, true));
        intTests.add(new IntTest('1000000', 500000, 2000000, VALID7, false, true));
        intTests.add(new IntTest('906842624', 906842623, 906842625, VALID8, false, true));
        intTests.add(new IntTest('+1', -2, 2, VALID9, false, true));

        intTests.add(new IntTest('1', 2, 1, INVALID1, false, false));
        intTests.add(new IntTest(null, 1, 2, INVALID2, false, false));
        intTests.add(new IntTest('', 1, 2, INVALID3, false, false));
        intTests.add(new IntTest('1', 2, 3, INVALID4, false, false));
        intTests.add(new IntTest('5', 2, 3, INVALID5, false, false));
        intTests.add(new IntTest('2a', 1, 3, INVALID6, false, false));
        intTests.add(new IntTest('2.0', 1, 3, INVALID7, false, false));
        intTests.add(new IntTest(' 10', 5, 20, INVALID10, false, false));
        intTests.add(new IntTest('10 ', 5, 20, INVALID11, false, false));
        intTests.add(new IntTest('5899906842624', 906842623, 906842625, INVALID13, false, false));
    }

    static testMethod void testValidatorIsValidInteger() {
        for (IntTest t : intTests) {
            System.assertEquals(t.expectedResult, PBS_ESAPI_CC.validator().isValidInteger(t.inputStr, t.minValue, t.maxValue, t.allowNull), t.errText);
        }
    }

    static testMethod void testValidatorGetValidInteger() {
        for (IntTest t : intTests) {
            try {
                Integer ret = PBS_ESAPI_CC.validator().getValidInteger(t.inputStr, t.minValue, t.maxValue, t.allowNull);
                // if no exception - check if we are expecting a valid test
                System.assertEquals(true,t.expectedResult, t.errText);
                // also make sure return value is equal to Integer.valueOf(input) unless null if input was empty and that is allowed
                if (ret != null){
                    System.assert(ret == Integer.valueOf(t.inputStr), t.errText);}
                else{
                    System.assert(t.allowNull && (t.inputStr == null || t.inputStr.length() == 0), t.errText);}
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assertEquals(false,t.expectedResult, t.errText);
            }
        }
    }

    private class NumberTest {
        private String inputStr;
        private Long minValue;
        private Long maxValue;
        private String errText;
        private Boolean allowNull;
        private Boolean expectedResult;

        public NumberTest(String inputStr, Long minValue, Long maxValue, String errText, Boolean allowNull, Boolean expectedResult) {
            this.inputStr = inputStr;
            this.minValue = minValue;
            this.maxValue = maxValue;
            this.errText = errText;
            this.allowNull = allowNull;
            this.expectedResult = expectedResult;
        }
    }

    private static final NumberTest [] numberTests = new NumberTest[]{};

    static {
        numberTests.add(new NumberTest('1', -2, 2, VALID1, false, true));
        numberTests.add(new NumberTest('-3', -5, -2, VALID2, false, true));
        numberTests.add(new NumberTest('1', 0, 2, VALID3, false, true));
        numberTests.add(new NumberTest('0', -2, 0, VALID4, false, true));
        numberTests.add(new NumberTest('0', 0, 0, VALID5, false, true));
        numberTests.add(new NumberTest(null, 1, 2, VALID6, true, true));
        numberTests.add(new NumberTest('1000000', 500000, 2000000, VALID7, false, true));
        numberTests.add(new NumberTest('1125899906842624', 1125899906842623L, 1125899906842625L, VALID8, false, true));

        numberTests.add(new NumberTest('1', 2, 1, INVALID1, false, false));
        numberTests.add(new NumberTest(null, 1, 2, INVALID2, false, false));
        numberTests.add(new NumberTest('', 1, 2, INVALID3, false, false));
        numberTests.add(new NumberTest('1', 2, 3, INVALID4, false, false));
        numberTests.add(new NumberTest('5', 2, 3, INVALID5, false, false));
        numberTests.add(new NumberTest('2a', 1, 3, INVALID6, false, false));
        //numberTests.add(new NumberTest('2.0', 1, 3, INVALID7, false, false)); // number is internally a double - so this is valid.
        numberTests.add(new NumberTest(' 10', 5, 20, INVALID8, false, false));
        numberTests.add(new NumberTest('10 ', 5, 20, INVALID9, false, false));
    }

    static testMethod void testValidatorIsValidNumber() {
        for (NumberTest t : numberTests) {
            System.assertEquals(t.expectedResult, PBS_ESAPI_CC.validator().isValidNumber(t.inputStr, t.minValue, t.maxValue, t.allowNull), t.errText);
        }
    }

    static testMethod void testValidatorGetValidNumber() {
        for (NumberTest t : numberTests) {
            try {
                Double ret = PBS_ESAPI_CC.validator().getValidNumber(t.inputStr, t.minValue, t.maxValue, t.allowNull);
                // if no exception - check if we are expecting a valid test
                System.assertEquals(true,t.expectedResult, t.errText);
                // also make sure return value is equal to Double.valueOf(input) unless null if input was empty and that is allowed
                if (ret != null){
                    System.assert(ret == Double.valueOf(t.inputStr), t.errText);}
                else{
                    System.assert(t.allowNull && (t.inputStr == null || t.inputStr.length() == 0), t.errText);}
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assertEquals(false,t.expectedResult, t.errText);
            }
        }
    }

    private class ListItemTest {
        private String inputStr;
        private Set<String> validItems;
        private String errText;
        private Boolean expectedResult;

        public ListItemTest(String inputStr, Set<String> validItems, String errText, Boolean expectedResult) {
            this.inputStr = inputStr;
            this.validItems = validItems;
            this.errText = errText;
            this.expectedResult = expectedResult;
        }
    }

    private static final ListItemTest [] listItemTests = new ListItemTest[]{};
    private static final Set<String> listItems1 = new Set<String>{'US', 'CANADA', 'MEXICO', 'ksjdfhg^$ \t%^DSFGs'};
    private static final Set<String> listItems2 = new Set<String>{'US'};
    private static final Set<String> listItems3 = new Set<String>{};
    private static final Set<String> listItems4 = new Set<String>{'', null};

    static {
        listItemTests.add(new ListItemTest('US', listItems1, VALID1, true));
        listItemTests.add(new ListItemTest('US', listItems2, VALID2, true));
        listItemTests.add(new ListItemTest('CANADA', listItems1, VALID3, true));
        listItemTests.add(new ListItemTest('MEXICO', listItems1, VALID4, true));
        listItemTests.add(new ListItemTest('ksjdfhg^$ \t%^DSFGs', listItems1, VALID5, true));
        listItemTests.add(new ListItemTest('', listItems4, VALID6, true));
        listItemTests.add(new ListItemTest(null, listItems4, VALID7, true));

        listItemTests.add(new ListItemTest('', listItems1, INVALID1, false));
        listItemTests.add(new ListItemTest(null, listItems1, INVALID2, false));
        listItemTests.add(new ListItemTest('', listItems2, INVALID3, false));
        listItemTests.add(new ListItemTest(null, listItems2, INVALID4, false));
        listItemTests.add(new ListItemTest('', listItems3, INVALID5, false));
        listItemTests.add(new ListItemTest(null, listItems3, INVALID6, false));
        listItemTests.add(new ListItemTest('', null, INVALID7, false));
        listItemTests.add(new ListItemTest(null, null, INVALID8, false));
        listItemTests.add(new ListItemTest('EU', listItems1, INVALID9, false));
        listItemTests.add(new ListItemTest('us', listItems1, INVALID10, false));
        listItemTests.add(new ListItemTest('ksjdfhg^$  %^DSFGs', listItems1, INVALID11, false));
        listItemTests.add(new ListItemTest('USA', listItems1, 'Invalid #12', false));
        listItemTests.add(new ListItemTest('AUS', listItems1, INVALID13, false));
        listItemTests.add(new ListItemTest(' US', listItems1, 'Invalid #14', false));
        listItemTests.add(new ListItemTest('US ', listItems1, 'Invalid #15', false));
    }

    static testMethod void testValidatorIsValidListItem() {
        for (ListItemTest t : listItemTests) {
            System.assertEquals(t.expectedResult, PBS_ESAPI_CC.validator().isValidListItem(t.inputStr, t.validItems), t.errText);
        }
    }

    static testMethod void testValidatorGetValidListItem() {
        for (ListItemTest t : listItemTests) {
            try {
                String ret = PBS_ESAPI_CC.validator().getValidListItem(t.inputStr, t.validItems);
                // if no exception - check if we are expecting a valid test
                System.assertEquals(true,t.expectedResult, t.errText);
                // also make sure return value is equal to input unless null if input was also null
                if (ret != null){
                    System.assert(ret.equals(t.inputStr), t.errText);}
                else{
                    System.assert(ret == t.inputStr, t.errText);}
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assertEquals(false,t.expectedResult, t.errText);
            }
        }
    }

    private class FileContentTest {
        private String inputStr;
        private Integer maxBytes;
        private String errText;
        private Boolean allowNull;
        private Boolean expectedResult;

        public FileContentTest(String inputStr, Integer maxBytes, String errText, Boolean allowNull, Boolean expectedResult) {
            this.inputStr = inputStr;
            this.maxBytes = maxBytes;
            this.errText = errText;
            this.allowNull = allowNull;
            this.expectedResult = expectedResult;
        }
    }

    private static final FileContentTest [] fileContentTests = new FileContentTest[]{};

    static {
        fileContentTests.add(new FileContentTest('1', 1, VALID1, false, true));
        fileContentTests.add(new FileContentTest(ABC, 3, VALID2, false, true));
        fileContentTests.add(new FileContentTest(ABC, 300, VALID3, false, true));
        fileContentTests.add(new FileContentTest(null, 1, VALID4, true, true));
        fileContentTests.add(new FileContentTest('', 1, VALID5, true, true));

        fileContentTests.add(new FileContentTest(ABC, 2, INVALID1, false, false));
        fileContentTests.add(new FileContentTest(null, 1, INVALID2, false, false));
        fileContentTests.add(new FileContentTest('', 1, INVALID3, false, false));
    }

    static testMethod void testValidatorIsValidfileContent() {
        for (FileContentTest t : fileContentTests) {
            System.assertEquals(t.expectedResult, PBS_ESAPI_CC.validator().isValidFileContent(t.inputStr, t.maxBytes, t.allowNull), t.errText);
        }
    }

    static testMethod void testValidatorGetValidFileContent() {
        for (FileContentTest t : fileContentTests) {
            try {
                String ret = PBS_ESAPI_CC.validator().getValidFileContent(t.inputStr, t.maxBytes, t.allowNull);
                // if no exception - check if we are expecting a valid test
                System.assertEquals(true,t.expectedResult, t.errText);
                // also make sure return value is equal to input unless null if input was empty and that is allowed
                if (ret != null){
                    System.assert(ret.equals(t.inputStr), t.errText);}
                else{
                    System.assert(t.allowNull && (t.inputStr == null || t.inputStr.length() == 0), t.errText);}
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assertEquals(false,t.expectedResult, t.errText);
            }
        }
    }

    private class PrintableTest {
        private String inputStr;
        private Integer maxBytes;
        private String errText;
        private Boolean allowNull;
        private Boolean expectedResult;

        public PrintableTest(String inputStr, Integer maxBytes, String errText, Boolean allowNull, Boolean expectedResult) {
            this.inputStr = inputStr;
            this.maxBytes = maxBytes;
            this.errText = errText;
            this.allowNull = allowNull;
            this.expectedResult = expectedResult;
        }
    }

    private static final PrintableTest [] printableTests = new PrintableTest[]{};

    static {
        printableTests.add(new PrintableTest('1', 1, VALID1, false, true));
        printableTests.add(new PrintableTest(ABC, 3, VALID2, false, true));
        printableTests.add(new PrintableTest(ABC, 300, VALID3, false, true));
        printableTests.add(new PrintableTest(null, 1, VALID4, true, true));
        printableTests.add(new PrintableTest('', 1, VALID5, true, true));
        printableTests.add(new PrintableTest('ab487sjhdg$%^#$%^&L>PO:c ~', 100, VALID6, false, true));
        printableTests.add(new PrintableTest(EncodingUtil.urlDecode('%20', UTF8), 10, VALID7, false, true));
        printableTests.add(new PrintableTest(EncodingUtil.urlDecode('%7E', UTF8), 10, VALID8, false, true));

        printableTests.add(new PrintableTest(ABC, 2, INVALID1, false, false));
        printableTests.add(new PrintableTest(null, 1, INVALID2, false, false));
        printableTests.add(new PrintableTest('', 1, INVALID3, false, false));
        printableTests.add(new PrintableTest('\r', 1, INVALID4, false, false));
        printableTests.add(new PrintableTest(EncodingUtil.urlDecode('%1F', UTF8), 10, INVALID5, false, false));
        printableTests.add(new PrintableTest(EncodingUtil.urlDecode('%7F', UTF8), 10, VALID8, false, false));
        printableTests.add(new PrintableTest(EncodingUtil.urlDecode(C280, UTF8), 10, VALID9, false, false)); // ascii 0x80
        printableTests.add(new PrintableTest(EncodingUtil.urlDecode('%C3%BF', UTF8), 10, VALID10, false, false)); // ascii 0xFF
        printableTests.add(new PrintableTest(EncodingUtil.urlDecode('%D7%A9', UTF8), 10, VALID11, false, false)); // unicode U+05E9
    }

    static testMethod void testValidatorIsValidPrintable() {
        for (PrintableTest t : printableTests) {
            System.assertEquals(t.expectedResult, PBS_ESAPI_CC.validator().isValidPrintable(t.inputStr, t.maxBytes, t.allowNull), t.errText);
        }
    }

    static testMethod void testValidatorGetValidPrintable() {
        for (PrintableTest t : printableTests) {
            try {
                String ret = PBS_ESAPI_CC.validator().getValidPrintable(t.inputStr, t.maxBytes, t.allowNull);
                // if no exception - check if we are expecting a valid test
                System.assertEquals(true,t.expectedResult, t.errText);
                // also make sure return value is equal to input unless null if input was empty and that is allowed
                if (ret != null){
                    System.assert(ret.equals(t.inputStr), t.errText);}
                else{
                    System.assert(t.allowNull && (t.inputStr == null || t.inputStr.length() == 0), t.errText);}
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assertEquals(false,t.expectedResult, t.errText);
            }
        }
    }

    private class FileNameDefaultExtensionsTest {
        private String inputStr;
        private String errText;
        private Boolean allowNull;
        private Boolean expectedResult;

        public FileNameDefaultExtensionsTest(String inputStr, String errText, Boolean allowNull, Boolean expectedResult) {
            this.inputStr = inputStr;
            this.errText = errText;
            this.allowNull = allowNull;
            this.expectedResult = expectedResult;
        }
    }

    private static final FileNameDefaultExtensionsTest [] fileNameDefaultExtensionsTests = new FileNameDefaultExtensionsTest[]{};

    static {

        fileNameDefaultExtensionsTests.add(new FileNameDefaultExtensionsTest(ONE_TXT, VALID1, false, true));
        fileNameDefaultExtensionsTests.add(new FileNameDefaultExtensionsTest(null, VALID2, true, true));
        fileNameDefaultExtensionsTests.add(new FileNameDefaultExtensionsTest('', VALID3, true, true));
        fileNameDefaultExtensionsTests.add(new FileNameDefaultExtensionsTest('()+. \'&,-=_0123456789abcdefhhijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.zip', VALID4, false, true));
        fileNameDefaultExtensionsTests.add(new FileNameDefaultExtensionsTest(ONE_TXT, VALID5, false, true));

        fileNameDefaultExtensionsTests.add(new FileNameDefaultExtensionsTest(null, INVALID1, false, false));
        fileNameDefaultExtensionsTests.add(new FileNameDefaultExtensionsTest('', INVALID2, false, false));
        fileNameDefaultExtensionsTests.add(new FileNameDefaultExtensionsTest('\r', INVALID3, false, false));
        fileNameDefaultExtensionsTests.add(new FileNameDefaultExtensionsTest(EncodingUtil.urlDecode('%1F', UTF8), INVALID4, false, false));
        fileNameDefaultExtensionsTests.add(new FileNameDefaultExtensionsTest(EncodingUtil.urlDecode('%7F', UTF8), INVALID5, false, false));
        fileNameDefaultExtensionsTests.add(new FileNameDefaultExtensionsTest(EncodingUtil.urlDecode(C280, UTF8), INVALID6, false, false)); // ascii 0x80
        fileNameDefaultExtensionsTests.add(new FileNameDefaultExtensionsTest(EncodingUtil.urlDecode('%C3%BF', UTF8), INVALID7, false, false)); // ascii 0xFF
        fileNameDefaultExtensionsTests.add(new FileNameDefaultExtensionsTest(EncodingUtil.urlDecode('%D7%A9', UTF8), INVALID8, false, false)); // unicode U+05E9
        fileNameDefaultExtensionsTests.add(new FileNameDefaultExtensionsTest('ab487sjhdg$%^#$%^&L>PO:c ~', INVALID9, false, false));
        fileNameDefaultExtensionsTests.add(new FileNameDefaultExtensionsTest(ZEROTONINE
            + ZEROTONINE
            + ZEROTONINE
            + ZEROTONINE
            + ZEROTONINE
            + '01234567890123456789012345678901234567890123456789.txt', 'Invalid #10 (too long)', false, false));
        fileNameDefaultExtensionsTests.add(new FileNameDefaultExtensionsTest('1.exe', VALID10, false, false));

    }

    static testMethod void testValidatorIsValidFileNameDefaultExtensions() {
        for (FileNameDefaultExtensionsTest t : fileNameDefaultExtensionsTests) {
            System.assertEquals(t.expectedResult, PBS_ESAPI_CC.validator().SFDC_isValidFileName(t.inputStr, t.allowNull), t.errText);
        }
    }

    static testMethod void testValidatorGetValidFileNameDefaultExtensions() {
        for (FileNameDefaultExtensionsTest t : fileNameDefaultExtensionsTests) {
            try {
                String ret = PBS_ESAPI_CC.validator().SFDC_getValidFileName(t.inputStr, t.allowNull);
                // if no exception - check if we are expecting a valid test
                System.assertEquals(true,t.expectedResult, t.errText);
                // also make sure return value is equal to input unless null if input was empty and that is allowed
                if (ret != null){
                    System.assert(ret.equals(t.inputStr), t.errText);}
                else{
                    System.assert(t.allowNull && (t.inputStr == null || t.inputStr.length() == 0), t.errText);}
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assertEquals(false,t.expectedResult, t.errText);
            }
        }
    }

    private class FileNameTest {
        private String inputStr;
        private List<String> fileExtensions;
        private String errText;
        private Boolean allowNull;
        private Boolean expectedResult;

        public FileNameTest(String inputStr, List<String> fileExtensions, String errText, Boolean allowNull, Boolean expectedResult) {
            this.inputStr = inputStr;
            this.fileExtensions = fileExtensions;
            this.errText = errText;
            this.allowNull = allowNull;
            this.expectedResult = expectedResult;
        }
    }

    private static final FileNameTest [] fileNameTests = new FileNameTest[]{};
    private static final List<String> fileExtensions1 = new List<String>{'.txt', '.jpg', '.zip'};
    private static final List<String> fileExtensions2 = new List<String>{'.txt'};
    private static final List<String> fileExtensions3 = new List<String>{};
    private static final List<String> fileExtensions4 = new List<String>{'', null};

    static {
        fileNameTests.add(new FileNameTest(ONE_TXT, fileExtensions1, VALID1, false, true));
        fileNameTests.add(new FileNameTest(ONE_TXT, fileExtensions1, VALID2, false, true));
        fileNameTests.add(new FileNameTest(ONE_TXT, fileExtensions2, VALID3, false, true));
        fileNameTests.add(new FileNameTest(ONE_TXT, fileExtensions2, VALID4, false, true));
        fileNameTests.add(new FileNameTest('1.JPG', fileExtensions1, VALID5, false, true));
        fileNameTests.add(new FileNameTest('1.ZIP', fileExtensions1, VALID6, false, true));
        fileNameTests.add(new FileNameTest('', fileExtensions4, VALID7, true, true));
        fileNameTests.add(new FileNameTest(null, fileExtensions4, VALID8, true, true));
        fileNameTests.add(new FileNameTest('', fileExtensions1, VALID9, true, true));
        fileNameTests.add(new FileNameTest(null, fileExtensions1, VALID10, true, true));
        fileNameTests.add(new FileNameTest('', fileExtensions3, VALID11, true, true));
        fileNameTests.add(new FileNameTest(null, fileExtensions3, 'Valid #12', true, true));
        fileNameTests.add(new FileNameTest('1.exe.txt', fileExtensions1, 'Valid #13', false, true));

        fileNameTests.add(new FileNameTest('1.JPG', fileExtensions2, INVALID1, false, false));
        fileNameTests.add(new FileNameTest('1.ZIP', fileExtensions2, INVALID2, false, false));
        fileNameTests.add(new FileNameTest('1.JPG', fileExtensions3, INVALID3, false, false));
        fileNameTests.add(new FileNameTest('1.ZIP', fileExtensions3, INVALID4, false, false));
        fileNameTests.add(new FileNameTest('1.JPG', fileExtensions4, INVALID5, false, false));
        fileNameTests.add(new FileNameTest('1.ZIP', fileExtensions4, INVALID6, false, false));
        fileNameTests.add(new FileNameTest('', fileExtensions1, INVALID7, false, false));
        fileNameTests.add(new FileNameTest(null, fileExtensions1, INVALID8, false, false));
        fileNameTests.add(new FileNameTest('', fileExtensions3, INVALID9, false, false));
        fileNameTests.add(new FileNameTest(null, fileExtensions3, INVALID10, false, false));
        fileNameTests.add(new FileNameTest('', fileExtensions4, INVALID11, false, false));
        fileNameTests.add(new FileNameTest(null, fileExtensions4, 'Invalid #12', false, false));
        fileNameTests.add(new FileNameTest('1.exe', fileExtensions1, INVALID13, false, false));
        fileNameTests.add(new FileNameTest('1.exetxt', fileExtensions1, 'Invalid #14', false, false));
        fileNameTests.add(new FileNameTest('1.txt.exe', fileExtensions1, 'Invalid #15', false, false));
    }

    static testMethod void testValidatorIsValidFileName() {
        for (FileNameTest t : fileNameTests) {
            System.assertEquals(t.expectedResult, PBS_ESAPI_CC.validator().SFDC_isValidFileName(t.inputStr, t.fileExtensions, t.allowNull), t.errText);
        }
    }

    static testMethod void testValidatorGetValidFileName() {
        for (FileNameTest t : fileNameTests) {
            try {
                String ret = PBS_ESAPI_CC.validator().SFDC_getValidFileName(t.inputStr, t.fileExtensions, t.allowNull);
                // if no exception - check if we are expecting a valid test
                System.assertEquals(true,t.expectedResult, t.errText);
                // also make sure return value is equal to input unless null if input was empty and that is allowed
                if (ret != null){
                    System.assert(ret.equals(t.inputStr), t.errText);}
                else{
                    System.assert(t.allowNull && (t.inputStr == null || t.inputStr.length() == 0), t.errText);}
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assertEquals(false,t.expectedResult, t.errText);
            }
        }
    }
/*
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
    
    */
}