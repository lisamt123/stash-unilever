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
    public List<ConsumerWrapper> duplicateConsumerList {get; set;}    
    public Boolean searchPerformed {get;set;}
    public Boolean showDuplicates {get;set;}
    public Boolean isContactPopulated {get;set;}
    public Boolean isTransactionSuccess {get;set;}
        
    transient public Map<Id, ConsumerWrapper> duplicateConsumers {get; set;}
    public String caseId {get; set;}

    public class ConsumerWrapper {

        public Account consumer {get; set;}

        public ConsumerWrapper(Account con) {
             consumer = con;  
        }
    }
       
    public CEC_NewAccountController() {
 
        caseId = ApexPages.currentPage().getParameters().get('id');

        Case currentCase = [SELECT AccountId, ContactId from Case WHERE Id = :caseId];
        
        if(currentCase.AccountId != null || currentCase.ContactId != null) {
            isContactPopulated = true;
            resultsOutputLabel = Label.CEC_ConsumerInfoDisplay;
        } else {
            isContactPopulated = false;
            resultsOutputLabel = Label.CEC_ConsumerNotFoundInfo;
        }        
        
        searchPerformed = false;
        showDuplicates = false;
        isTransactionSuccess = true;
        
        RecordType recType = [select id from recordType where Name = 'Person Account' and sobjectType='account' limit 1];
        
        newConsumer = new Account(RecordTypeId=recType.Id);
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
            if(newConsumer.LastName != null && newConsumer.LastName != '' ) {     
                newConsumer.RecordTypeId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
                String accountString = JSON.serialize(newConsumer);                
                accountString = accountString.subString( 0, accountString.length() - 1 ) + ',"IsPersonAccount":true}';
                newConsumer = (Account)JSON.deserialize( accountString, Account.class );
                List<CRMfusionDBR101.DB_Api.Matches> matchSets = CRMfusionDBR101.DB_Api.findMatches(newConsumer);
                if(!matchSets.isEmpty()){
                    showDuplicates = true;
                    Set<Id> accountIds = new Set<Id>();
                    for (CRMfusionDBR101.DB_Api.Matches matchSet : matchSets ) {
                        for (Id accId : matchSet.matchedIds){
                            accountIds.add(accId);
                        }
                    }        
                    for (Account consumer : [Select Salutation, Name, Phone, FirstName, LastName, IsPersonAccount,PersonEmail, PersonMailingStreet, PersonMailingCity, PersonMailingPostalCode, PersonMailingState, PersonMailingCountry,Latest_Case_Reason_Code__c,Latest_Case_Product_Code__c From Account Where Id In : accountIds]) {
                        duplicateConsumers.put(consumer.Id, new ConsumerWrapper(consumer)); 
                    }
                    duplicateConsumerList = duplicateConsumers.values(); 
                }
                searchPerformed = true;    
                isTransactionSuccess = true;
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
            
            } else if(newConsumer.LastName != null && newConsumer.LastName != '') {
                               
                newConsumer.RecordTypeId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
                      
                String accountString = JSON.serialize(newConsumer);
                accountString = accountString.subString( 0, accountString.length() - 1 ) + ',"IsPersonAccount":true}';
                newConsumer = (Account)JSON.deserialize( accountString, Account.class );
                
                Database.SaveResult res = Database.insert(newConsumer, false);
                if (!res.isSuccess()) {
                    System.debug(res.getErrors()[0].getMessage());
                    // Commenting the custom error message because the dupeblocker already added the error message in case of insert failure
                    //ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.Error, Label.CEC_Consumer_Duplicate_Error));
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
    
 }