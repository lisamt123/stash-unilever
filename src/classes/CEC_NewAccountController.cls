/**********************************************************************
Name:  CEC_NewAccountController()
Copyright ? 2015  Unilever
======================================================
======================================================
Purpose: This is the controller class for CEC_NewAccountContact Vf page                                                                                                    


======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                          Description
1.0 - Kasi&Pavan      Jan 22-2015      INITIAL DEVELOPMENT                  CSR: 
2.0 - Sathish V       Feb 03-2015      CONSUMER COMPONENT ENHANCEMENT       UI enhancements for Customer Console   
3.0 - Mahesh K        July 21-2016     CONSUMER COMPONENT ENHANCEMENT       UI enhancements for Customer Console 
***********************************************************************/

/**
Controller class for CEC_NewAccountContact Vf page
*/


global with sharing class CEC_NewAccountController{
    
    public PageReference back() {
        showDuplicates = false;
        return null;   
    }
    
    public Account newConsumer {get; set;}  // Reference to Account object     
    public String selectedAccountId {get; set;}  
    public String resultsOutputLabel {get;set;} 
    public String resultsOutputTitle {get;set;} 
    public List<ConsumerWrapper> duplicateConsumerList {get; set;}    
    public Boolean searchPerformed {get;set;}
    public Boolean showDuplicates {get;set;}
    public Boolean isContactPopulated {get;set;}
    public Boolean isTransactionSuccess {get;set;}
    //public List<SelectOption> unileverOptInOptions { get;set; } 
    
    transient public Map<Id, ConsumerWrapper> duplicateConsumers {get; set;}
    public String caseId {get; set;}
    
    public class ConsumerWrapper {
        
        public Account consumer {get; set;}
        
        public ConsumerWrapper(Account con) {
            consumer = con;  
        }
        // Boolean flag to check whether the consumer record is sorted/filtered to display in the results page.
        public Boolean resultOrderFlag = false;
    }
    
    public CEC_NewAccountController() {
        
        caseId = ApexPages.currentPage().getParameters().get('id');
        RecordType recType = [select id from recordType where Name = 'Person Account' and sobjectType='account' limit 1];
        newConsumer = new Account(RecordTypeId=recType.Id);
        
        Case currentCase = [SELECT AccountId,ContactId,Search_Salutation__c,Search_First_Name__c,Search_Last_Name__c,Search_Email__c,Search_Mailing_Street__c,
                            Search_Mailing_City__c,Search_Mailing_State_Province__c,Search_Mailing_Country__c,Search_Mailing_Zip_Postal_Code__c,
                            Search_Home_Phone__c, Search_Other_Phone__c,Search_Phone__c,Search_Mobile__c , Search_Birthdate__c from Case WHERE Id = :caseId];
        
        if(currentCase.AccountId != null || currentCase.ContactId != null) {
            isContactPopulated = true;
            resultsOutputLabel = Label.CEC_ConsumerInfoDisplay;
        } else {
            isContactPopulated = false;
            newConsumer.Salutation = currentCase.Search_Salutation__c;
            newConsumer.FirstName = currentCase.Search_First_Name__c;
            newConsumer.LastName = currentCase.Search_Last_Name__c;
            newConsumer.PersonEmail = currentCase.Search_Email__c;
            newConsumer.PersonMailingStreet = currentCase.Search_Mailing_Street__c;
            newConsumer.PersonMailingCity = currentCase.Search_Mailing_City__c;
            newConsumer.PersonMailingState = currentCase.Search_Mailing_State_Province__c;
            newConsumer.PersonMailingPostalCode = currentCase.Search_Mailing_Zip_Postal_Code__c;
            newConsumer.PersonMailingCountry = currentCase.Search_Mailing_Country__c;
            newConsumer.PersonHomePhone = currentCase.Search_Home_Phone__c;
            newConsumer.PersonMobilePhone = currentCase.Search_Mobile__c;
            newConsumer.PersonOtherPhone = currentCase.Search_Other_Phone__c;
            newConsumer.Phone = currentCase.Search_Phone__c;
            newConsumer.PersonBirthdate = currentCase.Search_Birthdate__c; 
            resultsOutputLabel = Label.CEC_ConsumerNotFoundInfo;
        }        
        
        searchPerformed = false;
        showDuplicates = false;
        isTransactionSuccess = true;
        resultsOutputTitle = Label.CEC_ConsumerResultsTitleDisplay;
        
    }
    
    /** This method is used to getch the Salutation field values **/    
    public List<SelectOption> getSalutation() {
        
        List<SelectOption> salutationOptions = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Account.Salutation.getDescribe();
        List<Schema.PicklistEntry> salutationValues = fieldResult.getPicklistValues();      
        
        salutationOptions.add(new SelectOption('', ''));
        for( Schema.PicklistEntry sValue : salutationValues) {
            salutationOptions.add(new SelectOption(sValue.getLabel(), sValue.getLabel()));
        }       
        return salutationOptions;
    }
    
    
    /**
This method is used for searching the Consumer Records and Displaying of Duplicate Records if any exists.
*/
    public pageReference searchConsumer() {
        
        try{                
            duplicateConsumers = new Map<Id, ConsumerWrapper>();  
            duplicateConsumerList = new List<ConsumerWrapper>();
            Boolean  hasResultToDisplayFlag = false; 
            System.debug('**** Search consumer parameters : ' + newConsumer);
            if(String.isNotBlank(newConsumer.LastName) || String.isNotBlank(newConsumer.PersonMailingPostalCode) || 
               String.isNotBlank(newConsumer.PersonMailingStreet) || String.isNotBlank(newConsumer.PersonEmail) || 
               String.isNotBlank(newConsumer.Phone) || String.isNotBlank(newConsumer.Local_Identifier__c)) {  
                   newConsumer.RecordTypeId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
                   
                   // If there is a phone value then remove all the special characters and set the value to the custom field. This will be used in the DupeBlocker search for the phone which has special characters.
                   if (String.isNotBlank(newConsumer.Phone)) {
                       newConsumer.Phone_No_Special_Char__c = CEC_Util.removeSpecialChar(newConsumer.Phone);
                       newConsumer.Home_Phone_No_Special_Char__c = CEC_Util.removeSpecialChar(newConsumer.Phone);
                       newConsumer.Mobile_Phone_No_Special_Char__c = CEC_Util.removeSpecialChar(newConsumer.Phone);
                       newConsumer.Other_Phone_No_Special_Char__c = CEC_Util.removeSpecialChar(newConsumer.Phone);
                       System.debug('****other phone****'+ newConsumer.Other_Phone_No_Special_Char__c);
                   }
                   
                   
                   User loggedinuser = [select UserRole.name from User where id = :UserInfo.getUserId()];
                   string  UserRole =  loggedinuser.UserRole.name;
                   system.debug('User role :=' +UserRole);
                   system.debug('Local_Identifier__c :=' +newConsumer.Local_Identifier__c);
                   
                   if (String.isNotBlank(newConsumer.Local_Identifier__c)) {
                       newConsumer.Local_Identifier_No_Special_Char__c = newConsumer.Local_Identifier__c;
                       
                       cec_Org_Settings__c SpecialRoles = cec_Org_Settings__c.getOrgDefaults();
                       if (SpecialRoles.Local_Identifier_Special_roles__c != null){
                           if (SpecialRoles.Local_Identifier_Special_roles__c.contains(UserRole)) {  
                               newConsumer.Local_Identifier_No_Special_Char__c = CEC_Util.removeSpecialChar(newConsumer.Local_Identifier__c);
                           }                       
                       }
                   }
                   
                   system.debug('Local_Identifier_No_Special_Char__c :=' +newConsumer.Local_Identifier_No_Special_Char__c);
                   
                   String accountString = JSON.serialize(newConsumer);                
                   accountString = accountString.subString(0, accountString.length() - 1 ) + ',"IsPersonAccount":true}';
                   newConsumer = (Account)JSON.deserialize( accountString, Account.class );
                   System.debug('***newConsumer***'+ newConsumer);
                   List<CRMfusionDBR101.DB_Api.Matches> matchSets = CRMfusionDBR101.DB_Api.findMatches(newConsumer);
                   System.debug('***matchSets***'+ matchSets);
                   if(!matchSets.isEmpty()){
                       System.debug('The Matchset from DupeBlocker :: ' + matchSets);
                       showDuplicates = true;
                       Set<Id> accountIds = new Set<Id>();
                       for (CRMfusionDBR101.DB_Api.Matches matchSet : matchSets ) {
                           for (Id accId : matchSet.matchedIds){
                               accountIds.add(accId);
                           }
                       }        
                       for (Account consumer : [Select Salutation, Name, Phone,PersonHomePhone,Home_Phone_No_Special_Char__c,
                                                PersonMobilePhone,Mobile_Phone_No_Special_Char__c,PersonOtherPhone,Other_Phone_No_Special_Char__c, FirstName, LastName, IsPersonAccount,
                                                PersonEmail, PersonMailingStreet, PersonMailingCity, PersonMailingPostalCode, PersonMailingState, PersonMailingCountry, Latest_Case_Number__c, 
                                                Latest_Case_Reason_Code__c,Latest_Case_Product_Code__c,Phone_No_Special_Char__c,Consumer_Note__c,VIP__c,Local_Identifier__c, Local_Identifier_No_Special_Char__c 
                                                From Account Where Id In : accountIds]) {
                           duplicateConsumers.put(consumer.Id, new ConsumerWrapper(consumer)); 
                       }
                       List<ConsumerWrapper> unOrderedConsumerList = duplicateConsumers.values(); 
                       // Set the Search results page title
                       
                       duplicateConsumerList = filterAndReorderSearchResults(unOrderedConsumerList);
                       
                       if (duplicateConsumerList.size() > 0) {
                           hasResultToDisplayFlag = true;
                       }                      
                   } 
                   searchPerformed = true;    
                   isTransactionSuccess = true;
               } else {
                   isTransactionSuccess = false;
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, Label.CEC_SearchValidationError));    
               }
            // Display the title if based on the consumer search results
            if (hasResultToDisplayFlag) {
                resultsOutputTitle = Label.CEC_ConsumerResultsTitleDisplay;
            } else {
                // Set the Search results page title as no results
                resultsOutputTitle = Label.CEC_ConsumerResultsNoMatchTitle;
            } 
            
        }catch(Exception e){
            isTransactionSuccess = false;
            System.debug('Exception in SearchConsumer method ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, e.getMessage()));
        }
        
        return null; 
    }           
    
    /**
This method is used for Auto populate selected Account on Case obj.
*/        
    public PageReference chooseAccount() {
        
        try{
            
            if(isContactPopulated) {
                isTransactionSuccess = false;
                ApexPages.addMessage( new ApexPages.Message( ApexPages.severity.Error, Label.CEC_Consumer_Record_Update));
                
            } else if(caseId != null) {
                
                Case currentCase = [SELECT Id from Case WHERE Id = :caseId];
                System.debug('Setting currentCase.Id');
                currentCase.Id = caseId;
                System.debug('Setting currentCase.AccountId');
                currentCase.AccountId = selectedAccountId;
                System.debug('Setting currentCase.ContactId');
                currentCase.ContactId = [select id from Contact where AccountId = :selectedAccountId].Id;
                update currentCase;
                showDuplicates = false;
                isContactPopulated = true;
                isTransactionSuccess = true;
            }
            
        } catch(Exception e) {
            isTransactionSuccess = false;
            System.debug('Exception in chooseAccount method ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, e.getMessage()));
        } 
        
        return null;
    }
    
    /**
This method is used for creating Person Account and auto populate it on Case obj. 
*/
    public PageReference saveAccount() {
        
        Case currentCase = null;        
        try{            
            if(isContactPopulated) {
                isTransactionSuccess = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, Label.CEC_Consumer_Record_Update));
                
            } else {
                
                newConsumer.RecordTypeId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
                
                String accountString = JSON.serialize(newConsumer);
                accountString = accountString.subString( 0, accountString.length() - 1 ) + ',"IsPersonAccount":true}';
                newConsumer = (Account)JSON.deserialize( accountString, Account.class );
                
                Database.SaveResult res = Database.insert(newConsumer, false);
                if (!res.isSuccess()) {
                    isTransactionSuccess = false;
                    System.debug('EXCEPTION IN THE DUPEBLOCKER :: ' + res.getErrors()[0].getMessage());
                    ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.Error, res.getErrors()[0].getMessage()));
                } else if(caseId != null) {
                    currentCase = [SELECT Id from Case WHERE Id = :caseId];
                    currentCase.AccountId = newConsumer.Id;
                    currentCase.ContactId = [select id from Contact where AccountId = :newConsumer.Id].Id;
                    update currentCase;
                    isContactPopulated = true;
                }
                isTransactionSuccess = true;
            }            
        }catch(Exception e) {
            isTransactionSuccess = false;
            System.debug('Exception in saveAccount method ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, Label.CEC_Consumer_Duplicate_Error) );
        }        
        return null;      
    }
    
    /**
This method is used for disassociating Account and Contact from Case Obj. 
*/
    @RemoteAction
    global static Boolean rollbackSave(String caseId) {
        
        try{
            if(caseId != null) {
                Case currentCase = [SELECT Id from Case WHERE Id = :caseId];
                currentCase.AccountId = null;
                currentCase.ContactId = null;
                update currentCase;                
                return true;
            }
        } catch(Exception e){           
            System.debug('Exception in rollbackSave method ' + e.getMessage());
            return false;
        }
        return false;
    }
    
    /*
The Consumer search results returned by DupeBlocker should be Ordered based on the following criterias
1. Local Identifier
2. Email Match
3. Phone Match
4. PostCode Match
5. Street + LastName Match
6. Street + City Match
The rest of the Consumer records are ignored.
*/
    public List<ConsumerWrapper> filterAndReorderSearchResults(List<ConsumerWrapper> duplicateConsumerList) { 
        
        List<ConsumerWrapper> finalOrderedConsumerList = new List<ConsumerWrapper>();
        Set<Id> accountIdSet = new Set<Id>();
        
        System.debug('The Consumer List to be filtered/Ordered :: ' + duplicateConsumerList);
        
        // Order 1 : Check the Local Identifier match
        CEC_NewAccountControllerExtension.checkLocalidentifierMatch(duplicateConsumerList, finalOrderedConsumerList, accountIdSet,newConsumer);
        
        // Order 2 : Check the email match
        CEC_NewAccountControllerExtension.checkEmailMatch(duplicateConsumerList, finalOrderedConsumerList, accountIdSet,newConsumer);
        
        // Order 3 : Check the phone match
        CEC_NewAccountControllerExtension.checkPhoneMatch(duplicateConsumerList, finalOrderedConsumerList, accountIdSet,newConsumer);
        
        // Order 4 : Check the PostCode match
        CEC_NewAccountControllerExtension.checkPostCodeMatch(duplicateConsumerList, finalOrderedConsumerList, accountIdSet,newConsumer);
        
        // Order 5 : Check the Street & LastName match
        CEC_NewAccountControllerExtension.checkStreetAndLastName(duplicateConsumerList, finalOrderedConsumerList, accountIdSet,newConsumer);
        
        //Order 6 : Display Street fuzzy match
        if(String.isNotBlank(newConsumer.PersonMailingStreet) && String.isNotBlank(newConsumer.PersonMailingCity)) {
            
            for(ConsumerWrapper account : duplicateConsumerList) {
                if(!accountIdSet.contains(account.consumer.Id))
                    finalOrderedConsumerList.add(account);
            }
        }
        
        
        return finalOrderedConsumerList;
    }
    
    
    //Check the Local Identifier match
    private void checkLocalidentifierMatch(List<ConsumerWrapper> duplicateConsumerList, List<ConsumerWrapper> finalOrderedConsumerList, Set<Id> accountIdSet){      
        if(String.isNotBlank(newConsumer.Local_Identifier_No_Special_Char__c)) {
            // fetch local Identifier
            String searchLocalIdentifier = newConsumer.Local_Identifier_No_Special_Char__c;
            for(ConsumerWrapper account : duplicateConsumerList) {
                if (!account.resultOrderFlag && String.isNotBlank(account.consumer.Local_Identifier_No_Special_Char__c) && account.consumer.Local_Identifier_No_Special_Char__c == searchLocalIdentifier) {
                    account.resultOrderFlag = true;
                    finalOrderedConsumerList.add(account);
                    accountIdSet.add(account.consumer.Id);
                }
            }
        }       
    }
    
    //Check the email match
    private void checkEmailMatch(List<ConsumerWrapper> duplicateConsumerList, List<ConsumerWrapper> finalOrderedConsumerList, Set<Id> accountIdSet){
        if(String.isNotBlank(newConsumer.PersonEmail)) {
            // fetch person email
            String searchEmailStr = newConsumer.PersonEmail;
            for(ConsumerWrapper account : duplicateConsumerList) {
                if (!account.resultOrderFlag && String.isNotBlank(account.consumer.PersonEmail) && account.consumer.PersonEmail == searchEmailStr) {
                    account.resultOrderFlag = true;
                    finalOrderedConsumerList.add(account);
                    accountIdSet.add(account.consumer.Id);
                }
            }
        }       
    }
    
    //Check the phone match
    private void checkPhoneMatch(List<ConsumerWrapper> duplicateConsumerList, List<ConsumerWrapper> finalOrderedConsumerList, Set<Id> accountIdSet){
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
        
            for(ConsumerWrapper account : duplicateConsumerList) {
                
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
    private void checkPostCodeMatch(List<ConsumerWrapper> duplicateConsumerList, List<ConsumerWrapper> finalOrderedConsumerList, Set<Id> accountIdSet){
        if(String.isNotBlank(newConsumer.PersonMailingPostalCode)) {
            String searchPostalCodeStr = newConsumer.PersonMailingPostalCode;
            for(ConsumerWrapper account : duplicateConsumerList) {
                if (!account.resultOrderFlag && String.isNotBlank(account.consumer.PersonMailingPostalCode) && account.consumer.PersonMailingPostalCode == searchPostalCodeStr) {
                    account.resultOrderFlag = true;
                    finalOrderedConsumerList.add(account);
                    accountIdSet.add(account.consumer.Id);
                }
            }
        }
    }
    
    //Check the Street & LastName match
    private void checkStreetAndLastName(List<ConsumerWrapper> duplicateConsumerList, List<ConsumerWrapper> finalOrderedConsumerList, Set<Id> accountIdSet){
        if(String.isNotBlank(newConsumer.PersonMailingStreet) && String.isNotBlank(newConsumer.LastName)) {
            String searchStreetStr = newConsumer.PersonMailingStreet;
            String searchLastNameStr = newConsumer.LastName;
            for(ConsumerWrapper account : duplicateConsumerList) {
                if (!account.resultOrderFlag && String.isNotBlank(account.consumer.PersonMailingStreet) && String.isNotBlank(account.consumer.LastName) && account.consumer.PersonMailingStreet == searchStreetStr && account.consumer.LastName == searchLastNameStr) {
                    account.resultOrderFlag = true;
                    finalOrderedConsumerList.add(account);
                    accountIdSet.add(account.consumer.Id);
                }
            }
        }       
    }
    
}