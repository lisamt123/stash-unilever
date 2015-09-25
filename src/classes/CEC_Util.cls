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
}