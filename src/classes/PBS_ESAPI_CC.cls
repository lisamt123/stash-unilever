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
* ESAPI locator class is provided to make it easy to gain access to the current ESAPI classes in use.<br>
* For example you can use the validator() function to access the validator methods. (i.e. <CODE>ESAPI.validator().isValidCreditCard(creditcard, false)</CODE>)
*/
global with sharing class PBS_ESAPI_CC {

    private static PBS_SFDCValidator_CC SFDC_validator = null;
    private static PBS_SFDCEncoder_CC SFDC_encoder = null;
    private static PBS_SFDCAccessController_CC SFDC_accessController = null;

    /**
    * prevent instantiation of this class
    */
   private PBS_ESAPI_CC() {} 

    /**
    * @return the current ESAPI SFDCValidator being used to validate data in this application.
    */
   global static PBS_SFDCValidator_CC validator() {
        if (SFDC_validator == null) {
            SFDC_validator =  new PBS_SFDCValidator_CC();
        }
        return SFDC_validator;
    }

    /**
    * @return the current SFDCEncoder object. This gives the basic encoding functionality as those availabel in VisualForce (HTMLENCODE, JSENCODE, JSINHTMLENCODE and URLENCODE)
    */
    global static PBS_SFDCEncoder_CC encoder() {
        if (SFDC_encoder == null) {
            SFDC_encoder =  new pbs_SFDCEncoder_CC();
        }
        return SFDC_encoder;
    }

    /**
    * @return the current ESAPI SFDCAccessController object being used to maintain the access control rules for this application.
    */
   global static PBS_SFDCAccessController_CC accessController() {
        if (SFDC_accessController == null) {
            SFDC_accessController = new PBS_SFDCAccessController_CC ();
        }
        return SFDC_accessController;
    }
}