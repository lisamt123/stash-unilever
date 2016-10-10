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
 * A credit card validator class. This class only validates Visa and MasterCard 16 digits cards.
 * It will check their length, characters used, and perform the Luhn algorithm check on the number.
 */
public with sharing class PBS_SFDCCreditCardValidationRule_CC extends PBS_SFDCBaseValidationRule_CC {
  
  // The maximum credit card length is 16 digits + 3 separators (like dash or space)
  private Integer maxCardLength = 19;
  
  private static final Pattern CREDIT_CARD_PATTERN = null;

  static {
    CREDIT_CARD_PATTERN = Pattern.compile(PBS_SFDCPatterns_CC.CreditCard);
  }
  
  private PBS_SFDCStringValidationRule_CC ccrule = null; 
  
  /**
   * Creates a CreditCardValidator using the default RegEx pattern from SFDCPatterns.CreditCard
   * @param typeName a description of the type of card being validated
   */
  public PBS_SFDCCreditCardValidationRule_CC( String typeName) {
    super(typeName);
    ccrule = readDefaultCreditCardRule();
  }
  
  private PBS_SFDCStringValidationRule_CC readDefaultCreditCardRule() {
    PBS_SFDCStringValidationRule_CC ccr = new PBS_SFDCStringValidationRule_CC( 'ccrule', CREDIT_CARD_PATTERN.pattern() );
    ccr.setMaximumLength(getMaxCardLength());
    ccr.setAllowNull( false );
    return ccr;
  }

    /**
     * This function will perform the following tests, and throw an exception if any of them fail.
     *   - is null or zero bytes and allow null was set to false
     *   - maximum length
     *   - input matches the credit card pattern we use
     * If all tests passed it will just finish without any exceptions 
     */
  public void assertValid(String input ) {

      if ( PBS_SFDCStringUtils_CC.isEmpty(input) ) {
      if (isAllowNull()){
        return;}
      throw new PBS_SFDCValidator_CC.SFDCValidationException('Input credit card required');
      }
      
      try {
        ccrule.assertValid(input);
      } catch (Exception e) {
        // Card did not match the regex pattern or other basic string rule checks
        throw new PBS_SFDCValidator_CC.SFDCValidationException('Invalid credit card input',e);
      }

    if( ! validCreditCardFormat(input)) {
      throw new PBS_SFDCValidator_CC.SFDCValidationException('Invalid credit card input');
       
    }
    
    // all tests passed
  }

  /**
   * Performs additional validation on the card nummber.
   * This implementation performs Luhn algorithm checking
   * @param ccNum number to be validated
   * @return true if the ccNum passes the Luhn Algorithm
   */
  private boolean validCreditCardFormat(String ccNum) {
    
      String digitsOnly = '';
      
    PBS_SFDCCharacter_CC c = new PBS_SFDCCharacter_CC('a'); // start with a temp value that we don't care about - we will overwrite it for each character in the string
    for (Integer i = 0; i < ccNum.length(); i++) {
      c.updateVal(ccNum.substring(i, i + 1));
      if (PBS_SFDCEncoderConstants_CC.DIGITS.contains(c.toInt())) {
        digitsOnly += c.toStr();
      }
    }

    Integer sum = 0;
    Integer digit = 0;
    Integer addend = 0;
    Boolean timesTwo = false;
  
    for (Integer i = digitsOnly.length() - 1; i >= 0; i--) {
      // guaranteed to be an integer because the previous loop only adds digits to the digitsOnly string
      digit = Integer.valueOf(digitsOnly.substring(i, i + 1));
      if (timesTwo) {
        addend = digit * 2;
        if (addend > 9) {
          addend -= 9;
        }
      } else {
        addend = digit;
      }
      sum += addend;
      timesTwo = !timesTwo;
    }

    return Math.mod(sum, 10) == 0; 
  }
  
  /**
   * @param maxCardLength the maxCardLength to set
   */
  public void setMaxCardLength(Integer maxCardLength) {
    this.maxCardLength = maxCardLength;
  }

  /**
   * @return the maxCardLength
   */
  public Integer getMaxCardLength() {
    return maxCardLength;
  }
  
}