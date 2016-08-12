/**********************************************************************
Name:  CEC_NewAccountControllerExtension()
Copyright ? 2016  Unilever
======================================================
======================================================
Purpose: This is the controller class to reduce too many methods sonar issue.                                                                                               


======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                          Description
1.0 - Mahesh K      Aug 8-2016      INITIAL DEVELOPMENT                  Sonar Issue
***********************************************************************/

/**
Controller class as extension for CEC_NewAccountController.
*/

global with sharing class CEC_NewAccountControllerExtension {
    
     //Check the Local Identifier match
    public static void checkLocalidentifierMatch(List<CEC_NewAccountController.ConsumerWrapper> duplicateConsumerList, List<CEC_NewAccountController.ConsumerWrapper> finalOrderedConsumerList, Set<Id> accountIdSet,Account newConsumer){      
        if(String.isNotBlank(newConsumer.Local_Identifier_No_Special_Char__c)) {
            // fetch local Identifier
            String searchLocalIdentifier = newConsumer.Local_Identifier_No_Special_Char__c;
            for(CEC_NewAccountController.ConsumerWrapper account : duplicateConsumerList) {
                if (!account.resultOrderFlag && String.isNotBlank(account.consumer.Local_Identifier_No_Special_Char__c) && account.consumer.Local_Identifier_No_Special_Char__c == searchLocalIdentifier) {
                    account.resultOrderFlag = true;
                    finalOrderedConsumerList.add(account);
                    accountIdSet.add(account.consumer.Id);
                }
            }
        }       
    }
    
    //Check the email match
    public static void checkEmailMatch(List<CEC_NewAccountController.ConsumerWrapper> duplicateConsumerList, List<CEC_NewAccountController.ConsumerWrapper> finalOrderedConsumerList, Set<Id> accountIdSet,Account newConsumer){
        if(String.isNotBlank(newConsumer.PersonEmail)) {
            // fetch person email
            String searchEmailStr = newConsumer.PersonEmail;
            for(CEC_NewAccountController.ConsumerWrapper account : duplicateConsumerList) {
                if (!account.resultOrderFlag && String.isNotBlank(account.consumer.PersonEmail) && account.consumer.PersonEmail == searchEmailStr) {
                    account.resultOrderFlag = true;
                    finalOrderedConsumerList.add(account);
                    accountIdSet.add(account.consumer.Id);
                }
            }
        }       
    }
    
    //Check the phone match
    public static void checkPhoneMatch(List<CEC_NewAccountController.ConsumerWrapper> duplicateConsumerList, List<CEC_NewAccountController.ConsumerWrapper> finalOrderedConsumerList, Set<Id> accountIdSet,Account newConsumer){
        String searchPhoneStr = '',searchHomePhoneStr = '' ,searchMobilePhoneStr = '' ,searchOtherPhoneStr = '';
        
        if(String.isNotBlank(newConsumer.Phone_No_Special_Char__c) && newConsumer.Phone_No_Special_Char__c.length() >= 6) {
            // Get last 6 characters of the phone.
            searchPhoneStr = newConsumer.Phone_No_Special_Char__c.right(6);
        }
        
        if(String.isNotBlank(newConsumer.Home_Phone_No_Special_Char__c) && newConsumer.Home_Phone_No_Special_Char__c.length() >= 6) {
            // Get last 6 characters of the phone.
            searchHomePhoneStr = newConsumer.Home_Phone_No_Special_Char__c.right(6);
        }
        
         if(String.isNotBlank(newConsumer.Mobile_Phone_No_Special_Char__c) && newConsumer.Mobile_Phone_No_Special_Char__c.length() >= 6) {
            // Get last 6 characters of the phone.
            searchMobilePhoneStr = newConsumer.Mobile_Phone_No_Special_Char__c.right(6);
        }
       
        if(String.isNotBlank(newConsumer.Other_Phone_No_Special_Char__c) && newConsumer.Other_Phone_No_Special_Char__c.length() >= 6) {
            // Get last 6 characters of the phone.
            searchOtherPhoneStr = newConsumer.Other_Phone_No_Special_Char__c.right(6);
            System.debug('***searchOtherPhoneStr***'+ searchOtherPhoneStr);
        }
        
            for(CEC_NewAccountController.ConsumerWrapper account : duplicateConsumerList) {
                
                if (!account.resultOrderFlag && String.isNotBlank(account.consumer.Phone_No_Special_Char__c) && account.consumer.Phone_No_Special_Char__c.contains(searchPhoneStr)) {
                    account.resultOrderFlag = true;
                    finalOrderedConsumerList.add(account);
                    accountIdSet.add(account.consumer.Id);
                }
                else if (!account.resultOrderFlag && String.isNotBlank(account.consumer.Home_Phone_No_Special_Char__c) && account.consumer.Home_Phone_No_Special_Char__c.contains(searchHomePhoneStr)){
                    account.resultOrderFlag = true;
                    finalOrderedConsumerList.add(account);
                    accountIdSet.add(account.consumer.Id);
                }else if (!account.resultOrderFlag && String.isNotBlank(account.consumer.Mobile_Phone_No_Special_Char__c) && account.consumer.Mobile_Phone_No_Special_Char__c.contains(searchMobilePhoneStr)){
                    account.resultOrderFlag = true;
                    finalOrderedConsumerList.add(account);
                    accountIdSet.add(account.consumer.Id);
                }else if (!account.resultOrderFlag && String.isNotBlank(account.consumer.Other_Phone_No_Special_Char__c) && account.consumer.Other_Phone_No_Special_Char__c.contains(searchOtherPhoneStr)){
                    account.resultOrderFlag = true;
                    finalOrderedConsumerList.add(account);
                    accountIdSet.add(account.consumer.Id);
                    System.debug('*****accountIdSet******'+accountIdSet);
                }
                
            }
       
    }
    
    
    //Check the PostCode match
    public static void checkPostCodeMatch(List<CEC_NewAccountController.ConsumerWrapper> duplicateConsumerList, List<CEC_NewAccountController.ConsumerWrapper> finalOrderedConsumerList, Set<Id> accountIdSet,Account newConsumer){
        if(String.isNotBlank(newConsumer.PersonMailingPostalCode)) {
            String searchPostalCodeStr = newConsumer.PersonMailingPostalCode;
            for(CEC_NewAccountController.ConsumerWrapper account : duplicateConsumerList) {
                if (!account.resultOrderFlag && String.isNotBlank(account.consumer.PersonMailingPostalCode) && account.consumer.PersonMailingPostalCode == searchPostalCodeStr) {
                    account.resultOrderFlag = true;
                    finalOrderedConsumerList.add(account);
                    accountIdSet.add(account.consumer.Id);
                }
            }
        }
    }
	
      //Check the Street & LastName match
    public static void checkStreetAndLastName(List<CEC_NewAccountController.ConsumerWrapper> duplicateConsumerList, List<CEC_NewAccountController.ConsumerWrapper> finalOrderedConsumerList, Set<Id> accountIdSet, Account newConsumer){
        if(String.isNotBlank(newConsumer.PersonMailingStreet) && String.isNotBlank(newConsumer.LastName)) {
            String searchStreetStr = newConsumer.PersonMailingStreet;
            String searchLastNameStr = newConsumer.LastName;
            for(CEC_NewAccountController.ConsumerWrapper account : duplicateConsumerList) {
                if (!account.resultOrderFlag && String.isNotBlank(account.consumer.PersonMailingStreet) && String.isNotBlank(account.consumer.LastName) && account.consumer.PersonMailingStreet == searchStreetStr && account.consumer.LastName == searchLastNameStr) {
                    account.resultOrderFlag = true;
                    finalOrderedConsumerList.add(account);
                    accountIdSet.add(account.consumer.Id);
                }
            }
        }       
    }
    
}