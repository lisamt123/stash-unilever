/**********************************************************************
 Name:  CEC_Util()
 Copyright  2015  Unilever
======================================================================
======================================================================
Purpose:  Utility Class                                                
1. Utility class which has all the common functions to be used across the app                                  
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
   1.0 - Sathish       05/08/2015      INITIAL DEVELOPMENT     Util class for Email
****************************************************************************/


public class CEC_Util {

    //Method to send email
    public static void sendNotificationEmail(string msgString, string emailSubject){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<CEC_NotificationEmailId__C> listNotifEmail = CEC_NotificationEmailId__C.getall().values();
        if(listNotifEmail.size()>0){
            if(listNotifEmail[0].EmailId__C !=''){                
                String[] toAddresses = new String[]{listNotifEmail[0].EmailId__C};
                mail.setToAddresses(toAddresses);
                mail.setSubject(emailSubject);
                mail.setHTMLBody(msgString);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
            }
        }
    } 

    //Method to remove special characters in the String.
    public static String removeSpecialChar(String inputStr) {
        String finalStr;
        if(String.isNotBlank(inputStr)) {
            finalStr = inputStr.replace(' ', '');
            finalStr = finalStr.replace('.', '');
            finalStr = finalStr.replace('-', '');
            finalStr = finalStr.replace('+', '');
        }
        return finalStr;
    }   
    
    static String[] to_19 = new string[]{ 'zero', 'One',  'Two', 'Three', 'Four',  'Five',  'Six', 'Seven','Eight', 'Nine', 'Ten',  'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen' }; 
    static String[] tens = new string[]{ 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'}; 
    static string[] denom = new string[]{ '','Thousand',   'Million',     'Billion',    'trillion',    'quadrillion',  'quintillion', 's!xtillion',   'septillion',  'octillion',   'nonillion',  'decillion',  'undecillion',   'duodecillion', 'tredecillion',  'quattuordecillion',  's!xdecillion', 'septendecillion', 'octodecillion', 'novemdecillion', 'vigintillion' }; 

    
    // convert a value < 100 to English.   
    public static string convertTwoDigitToWord(integer val) { 
        System.debug('In convertTwoDigitToWord val is  ' + val ); 
        if (val < 20) 
            return to_19[val]; 
        if (val == 100) 
            return 'One Hundred'; 
        
        for (integer v = 0; v < tens.size(); v++) { 
            String dcap = tens[v]; 
            System.debug('dcap is  ' + dcap ); 
            integer dval = 20 + 10 * v; 
            System.debug('dval is  ' + dval ); 
            
            if (dval + 10 > val) { 
                System.debug('in loop 1' ); 
                if (Math.Mod(val,10) != 0) {
                    System.debug('in loop 2' ); 
                    system.debug('to_19[Math.Mod(val,10)] ' + to_19[Math.Mod(val,10)] );
                    return dcap + ' ' + to_19[Math.Mod(val,10)]; 
                }
                return dcap; 
            }     
        } 
        return null; 
    } 
    // convert a value < 1000 to english, special cased because it is the level that kicks   
    // off the < 100 special case. The rest are more general. This also allows you to  
    // get strings in the form of "forty-five hundred" if called directly.  
    public static String convertThreeDigitToWord(integer val) { 
        System.debug('In convertThreeDigitToWord val is  ' + val ); 
        string word = ''; 
        integer rem = val / 100; 
        integer mod = Math.mod(val,100); 
        System.debug('mod is  ' + mod ); 
        System.debug('rem is  ' + rem );
        
        if (rem > 0) { 
            word = to_19[rem] + ' Hundred'; 
            if (mod > 0) { 
                word += ' and '; 
            } 
        } 
        System.debug('mod is  ' + mod ); 
        if (mod > 0) { 
            word += convertTwoDigitToWord(mod); 
        } 
        return word; 
    }   
    // This method will get following 3 inputs and it will return Currency in words
    // 1) Number to be converted in words
    // 2) Textual version of currency, e.g. DOLLARS
    // 3) Textual version of decimal currency, e.g. CENTS
    public static String convertAllDigitsToWord(decimal val, string currencyText, string currencyDecimalText ) { 
        if (val < 100) { 
            System.debug('In englishNumber val is < 100 ' + val ); 
            
            if ((val -val.intValue()) > 0){
                if (val.intValue() > 0){
                    return convertTwoDigitToWord(val.intValue())+ ' ' + currencyText + ' and' + ' ' + convertTwoDigitToWord(((val -val.intValue())*100).intValue()) + ' ' + currencyDecimalText; 
                    
                }
                else{
                    return  convertTwoDigitToWord(((val -val.intValue())*100).intValue()) + ' ' + currencyDecimalText; 
                    
                }               
            }
            else {
                return convertTwoDigitToWord(val.intValue())+ ' ' + currencyText ; 
            }
                
        } 
        if (val < 1000) { 
            System.debug('In englishNumber val is < 1000 ' + val ); 
            
            if ((val -val.intValue()) > 0){
                return convertThreeDigitToWord(val.intValue())+ ' ' + currencyText + ' and' + ' ' + convertTwoDigitToWord(((val -val.intValue())*100).intValue()) + ' ' + currencyDecimalText; 
            }
            else {
                return convertThreeDigitToWord(val.intValue())+ ' ' + currencyText ; 
            }
        } 
        for (integer v = 0; v < denom.size(); v++) { 
            integer didx = v - 1; 
            integer dval = (integer)Math.pow(1000, v); 
            
            System.debug('didx ' + didx ); 
            System.debug('dval ' + dval ); 
            
            
            if (dval > val) { 
                integer mod = (integer)Math.pow(1000, didx); 
                System.debug('value of mod ' + mod ); 
                integer l = (integer) val / mod; 
                System.debug('value of l ' + l ); 
                integer r = (integer) val - (l * mod); 
                System.debug('value of r ' + r ); 
                String ret = convertThreeDigitToWord(l) + ' ' + denom[didx]; 
                System.debug('value of ret ' + ret ); 
                
                
                if (r > 0) { 
                    System.debug('in loop value of r ' + r ); 
                    ret += ', ' + convertAllDigitsToWord(r,currencyText,currencyDecimalText); 
                    
                } 
                System.debug('in loop value of ret ' + ret ); 
                if ((val -val.intValue()) > 0){
                    return ret + ' ' + 'and' + ' ' + convertTwoDigitToWord(((val -val.intValue())*100).intValue()) + ' ' + currencyDecimalText; 
                    return ret + ' ' + 'and' + ' ' + convertTwoDigitToWord(((val -val.intValue())*100).intValue()) + ' ' + currencyDecimalText; 
                }
                else {
                    return ret ; 
                }       
            } 
        } 
        return null; 
    } 

     //Method to Construct final Prod Category String.
    public static String constructFinalProdCategoryValue(String initialProductCategory, 
                                                String prodCategory1, String prodCategory2){
        String finalProdCategoryConcatValue = initialProductCategory;
        // Concatenate prodCategory1 if it is not null.
        finalProdCategoryConcatValue = (String.isNotBlank(prodCategory1))?
                                         (finalProdCategoryConcatValue + prodCategory1): finalProdCategoryConcatValue;
                                                             
        // Concatenate prodCategory2 if it is not null.
        finalProdCategoryConcatValue = (String.isNotBlank(prodCategory2))?
                                         (finalProdCategoryConcatValue + prodCategory2): finalProdCategoryConcatValue;

        return finalProdCategoryConcatValue;
    }

     //Method to Construct Reason Code String.
    public static String constructFinalReasonCodeValue(String initialReasonCode, 
                                                String reason1, String reason2, 
                                                String reason3, String reason4){
        String finalReasonCodeConcatValue = initialReasonCode;
        // Concatenate reason1 if it is not null.
        finalReasonCodeConcatValue = (String.isNotBlank(reason1))?
                                         (finalReasonCodeConcatValue + reason1):finalReasonCodeConcatValue;
                                                             
        // Concatenate reason2 if it is not null.
        finalReasonCodeConcatValue = (String.isNotBlank(reason2))?
                                         (finalReasonCodeConcatValue + reason2):finalReasonCodeConcatValue;

        // Concatenate reason3 if it is not null.
        finalReasonCodeConcatValue = (String.isNotBlank(reason3))?
                                         (finalReasonCodeConcatValue + reason3):finalReasonCodeConcatValue;

        // Concatenate reason4 if it is not null.
        finalReasonCodeConcatValue = (String.isNotBlank(reason4))?
                                         (finalReasonCodeConcatValue + reason4):finalReasonCodeConcatValue;                                         
        return finalReasonCodeConcatValue;
    }
        
}