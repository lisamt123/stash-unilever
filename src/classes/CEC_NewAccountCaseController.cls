/**********************************************************************
 Name:  CEC_NewAccountCaseController()
 Copyright Â© 2013  Unilever
 ======================================================
======================================================
Purpose: This is the controller class for CEC_NewAccountCase Vf page                                                                                                    

                  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                Description
   1.0 - Shashank B      22/09/2014      INITIAL DEVELOPMENT                         CSR: 
 
***********************************************************************/

/**
Controller class for CEC_NewAccountCase Vf page
*/
public with sharing class CEC_NewAccountCaseController{
    
    /* Reference to Contact object */
   // public Contact newConsumer {get; set;}
    
    /* Reference to Market Picklist */
    //public List<SelectOption> MarketOptions{get; set;}
    
    /* Reference to Status Picklist */
    //public List<SelectOption> StatusOptions{get; set;}
    
    /* Reference to Origin Picklist */
    //public List<SelectOption> OriginOptions{get; set;}    
   
    /* Reference to Reason Picklist */
    //public List<SelectOption> ReasonOptions{get; set;}    
    
    /* Reference to Case object */
  //  public Case newCase {get; set;}
   
    /* Reference to id of the record to be previewed */
    //public String RecordPreviewID {get; set;}
 
    /* Reference to Account of the record to be previewed */
    //public Account previewAccount {get; set;}
    
    /* Closure reason */
    //public String closureReason{get; set;} 
    
    /* market */
    //public String market{get; set;}
    
    /*Case Id */
   // public String caseId {get; set;}

    /* Account*/
   // private Account accountObj;
    
    /* Reference to id of the record to be previewed */
    //private Account accs;

    /* Reference to id of the record to be previewed */
    /*private Case tempCaseObj;
    
    public Map<Id, ConsumerWrapper> duplicateConsumers {get; set;}
    public List<ConsumerWrapper> duplicateConsumerList {get; set;}
    private Case CaseObj;
    public String accId{get; set;}
    public Boolean buttonEnable{get;set;}*/
    /** 
    This is constructor which is used to create a consumer and a case
    */
    /*public CEC_NewAccountCaseController(ApexPages.StandardController stdController) {
    
        newConsumer = (Contact) stdController.getRecord();
        newCase = new Case();
        buttonEnable=true;*/
     
       /*This is to fetch the Picklist values for Market Field*/
       /* remove comment - >  Schema.DescribeFieldResult market = Case.Market__c.getDescribe();
         List<Schema.PicklistEntry> marketValues = market.getPicklistValues();
        
        MarketOptions = new List<SelectOption>();
        for (Schema.PicklistEntry a : marketValues)
        { 
           MarketOptions.add(new SelectOption(a.getLabel(), a.getValue())); 
        }*/
       
        /*This is to fetch the Picklist values for Case Status Field*/  
         /*Schema.DescribeFieldResult caseStatus = Case.Status.getDescribe();
         List<Schema.PicklistEntry> caseStatusValues = caseStatus.getPicklistValues();
        
         StatusOptions = new List<SelectOption>();
         for (Schema.PicklistEntry a : caseStatusValues)
        { 
           StatusOptions.add(new SelectOption(a.getLabel(), a.getValue())); 
        }
        */
         /*This is to fetch the Picklist values for Case Origin Field*/ 
         /*Schema.DescribeFieldResult caseOrigin = Case.Origin.getDescribe();
         List<Schema.PicklistEntry> caseOriginValues = caseOrigin.getPicklistValues();
        
         OriginOptions = new List<SelectOption>();
         for (Schema.PicklistEntry a : caseOriginValues)
        { 
           OriginOptions.add(new SelectOption(a.getLabel(), a.getValue())); 
        }      
        
        */
         /*This is to fetch the Picklist values for Case Reason Field*/
         /*Schema.DescribeFieldResult reason= Case.Reason.getDescribe();
         List<Schema.PicklistEntry> reasonValues = reason.getPicklistValues();
        
         ReasonOptions = new List<SelectOption>();
         for (Schema.PicklistEntry a : reasonValues)
        { 
           ReasonOptions.add(new SelectOption(a.getLabel(), a.getValue())); 
        }        
        
     }  
    */
   
    /**
    This method is used for searching the consumer if any duplicates present and creates Person Account and case if not present
    
    */
   /* public  pageReference searchConsumer() {
        
        duplicateConsumers = new Map<Id, ConsumerWrapper>();  
        duplicateConsumerList = new List<ConsumerWrapper>();          
        
        // Starting
        if((newConsumer.LastName!=null)&(newConsumer.Email!=null)||(newConsumer.LastName!=null)&(newConsumer.Email==null))
        {               
        
        accountObj = new Account();
        accountObj.RecordTypeId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
        accountObj.FirstName = newConsumer.FirstName;
        accountObj.LastName = newConsumer.LastName;
        accountObj.PersonEmail = newConsumer.Email;
        accountObj.PersonMobilePhone= newConsumer.Phone;
        accountObj.PersonMailingStreet = newConsumer.MailingStreet;
        accountObj.PersonMailingCity = newConsumer.MailingCity;
        accountObj.PersonMailingPostalCode = newConsumer.MailingPostalCode;
        accountObj.PersonMailingState = newConsumer.MailingState;
        accountObj.PersonMailingCountry = newConsumer.MailingCountry;
                  
        String accountString = JSON.serialize( accountObj);
        accountString = accountString.subString( 0, accountString.length() - 1 ) +
    ',"IsPersonAccount":true}';
        accountObj = (Account)JSON.deserialize( accountString, Account.class );
        System.debug( 'Person acct is ='+accountObj);
        Database.SaveResult res = Database.insert(accountObj, false);
        if (! res.isSuccess()) {
            ApexPages.addMessage( new ApexPages.MEssage( ApexPages.severity.Error, res.getErrors()[0].getMessage()) );
              System.debug('res is='+res);  
                         
        }
        if(res.isSuccess()){
        tempCaseObj= new case();
        tempCaseObj= newCase;
        if((newCase.Status==null)||(newCase.Status=='')){
        ApexPages.addMessage( new ApexPages.MEssage( ApexPages.severity.Error, 'Label.CEC_Status') );
        }
        else if((newCase.Origin==null)||(newCase.Origin=='')){
        ApexPages.addMessage( new ApexPages.MEssage( ApexPages.severity.Error, 'Label.CEC_Origin') );
        }
        tempCaseObj.Description = newCase.Description;
        tempCaseObj.Status= newCase.Status;
        tempCaseObj.Origin= 'Phone';        
        tempCaseObj.Reason= newCase.Reason;
        // tempCaseObj.Market__c= newCase.Market__c;
        
       
        if(accountObj!=null){
            tempCaseobj.Accountid=accountObj.id;
            tempCaseobj.ContactId=[select id from Contact where AccountId=:accountObj.id].Id;
        }
        
  
        insert tempCaseObj;
        
        
        //Ending
        System.debug('tempCaseObj = '+tempCaseObj);
                            
        PageReference pageRef = new ApexPages.StandardController(tempCaseObj).view(); 
        pageRef.setRedirect(true); 
        return pageRef ; 
       }
       
       
        System.debug('acc is='+accountObj);
        List<CRMfusionDBR101.DB_Api.Matches> matchSets = CRMfusionDBR101.DB_Api.findMatches(accountObj);
       
        
        if ( matchSets.isEmpty() ) {
       
       try{
            Database.update(accountObj, false);*/
            //To cover the Catch in Test class
            /* if(Test.isRunningTest()){
                 cec_Alert_Tracker_Item__c a1=new cec_Alert_Tracker_Item__c();
                 insert a1;
            } */   
          /*} catch ( Exception e )
             {
                 ApexPages.addMessages( e );
                 return null;
             }
             System.debug('*************SATHISH**************  NO MATCH FOUND');
          return null;
            
        } else {        
            Set<Id> accountIds = new Set<Id>();
            for ( CRMfusionDBR101.DB_Api.Matches matchSet : matchSets ) {
                for ( Id accId : matchSet.matchedIds ) {
                    accountIds.add(accId);
                }
            }        
            System.debug('*************SATHISH************** MATCH FOUND ACCOUNT = '+ accountIds);
            for (Account consumer : [Select Salutation, Name, FirstName, LastName, IsPersonAccount,PersonEmail, PersonMailingStreet, PersonMailingCity, 

PersonMailingPostalCode, PersonMailingState, PersonMailingCountry From Account Where Id In : accountIds]) {
                duplicateConsumers.put(consumer.Id, new ConsumerWrapper('Scenario z', consumer)); 
            }
        }        
        duplicateConsumerList = duplicateConsumers.values(); 
             
        return null;                
       }
       else if((newConsumer.LastName==null)&(newConsumer.Email==null)){
           tempCaseObj= new case();
            tempCaseObj= newCase;
            if((newCase.Status==null)||(newCase.Status=='')){
            ApexPages.addMessage( new ApexPages.MEssage( ApexPages.severity.Error, 'Label.CEC_Status') );
            }
            else if((newCase.Origin==null)||(newCase.Origin=='')){
            ApexPages.addMessage( new ApexPages.MEssage( ApexPages.severity.Error, 'Label.CEC_Origin') );
            }
            tempCaseObj.Description = newCase.Description;
            tempCaseObj.Status= newCase.Status;
            tempCaseObj.Origin= 'Phone';        
            tempCaseObj.Reason= newCase.Reason;*/
            // tempCaseObj.Market__c= newCase.Market__c;
          
          /*  if(accountObj!=null){
                tempCaseobj.Accountid=accountObj.id;
                tempCaseobj.ContactId=[select id from Contact where AccountId=:accountObj.id].Id;
            } */
            
      
            /*insert tempCaseObj;        */
        
            //Ending
            /*System.debug('tempCaseObj = '+tempCaseObj);
                                
            PageReference pageRef = new ApexPages.StandardController(tempCaseObj).view(); 
            pageRef.setRedirect(true); 
            return pageRef ;        
       }
      
       else if((newConsumer.LastName==null)&(newConsumer.Email!=null)){
         ApexPages.addMessage( new ApexPages.MEssage( ApexPages.severity.Error, 'You must enter Last Name to create a Consumer') );
       }
       
      return null; 
    }           
       */
    
    /**
    This method is used for creating case with already existing person Account
    */
 /*public PageReference proceed() {
        CaseObj= new case();
        CaseObj= newCase;
        CaseObj.Description = newCase.Description;
        CaseObj.Status= newCase.Status;
        CaseObj.Origin= 'Phone';        
        CaseObj.Reason= newCase.Reason;     
        // CaseObj.Market__c= newCase.Market__c;
        
        if(accId!=null){
            CaseObj.Accountid=accId;
            CaseObj.ContactId=[select id from Contact where AccountId=:accId].Id;
        }       
  
        insert CaseObj;
        System.debug('tempCaseObj = '+CaseObj);
        PageReference pg=new PageReference('/'+CaseObj.id);                    
        pg.setRedirect(true);
        return pg;          
         
    } */
   /* This method is used for the Population of Duplicate Records if exist*/
 /*public PageReference populateRecordPreviewID(){
        if (ApexPages.currentPage().getParameters().get('recordPreviewID') != null && ApexPages.currentPage().getParameters().get('recordPreviewID') != '' && 

ApexPages.currentPage().getParameters().get('recordPreviewID') != 'null'){
            this.RecordPreviewID = ApexPages.currentPage().getParameters().get('recordPreviewID');
            previewAccount = [Select Id, Name,PersonEmail,PersonMailingStreet, PersonMailingCity, PersonMailingPostalCode, PersonMailingState, PersonMailingCountry, 

Phone From Account Where Id = :ApexPages.currentPage().getParameters().get('recordPreviewID')];
        }
        return null;
    }*/
 /* This method is to accept the duplicate record found */
   /* public PageReference acceptAccount(){
        if (ApexPages.currentPage().getParameters().get('acceptAccountID') != null && ApexPages.currentPage().getParameters().get('acceptAccountID') != '' && 

ApexPages.currentPage().getParameters().get('acceptAccountID') != 'null'){
            String accountId = ApexPages.currentPage().getParameters().get('acceptAccountID');
            accId=accountId;
            buttonEnable=false;
            ConsumerWrapper c = duplicateConsumers.get(accountId);
            c.matchingFlag = '/img/samples/flag_green.gif';
            duplicateConsumers.put(accountId, c);
            duplicateConsumerList = duplicateConsumers.values();
            newConsumer.FirstName = c.consumer.FirstName;
            newConsumer.LastName = c.Consumer.LastName;
            newConsumer.Email= c.Consumer.PersonEmail;
            newConsumer.MailingStreet = c.consumer.PersonMailingStreet;
            newConsumer.MailingCity = c.consumer.PersonMailingCity;
            newConsumer.MailingPostalCode = c.consumer.PersonMailingPostalCode;
            newConsumer.MailingState = c.consumer.PersonMailingState;
            newConsumer.MailingCountry = c.consumer.PersonMailingCountry;
                     
        }
        return null;
    }
     
    public PageReference cancelPage()
    {
        PageReference pg=new PageReference('/apex/pages/CEC_NewAccountCase');                    
        pg.setRedirect(true);
        return pg; 
     }
   
       
       
    public class ConsumerWrapper {
        public String scenarioName {get; set;}
        public Account consumer {get; set;}
        public String matchingFlag {get; set;}
       public ConsumerWrapper(String sn, Account con) {
            scenarioName = sn;
            consumer = con;  
            matchingFlag = '/img/samples/flag_yellow.gif';      
        }
    }*/
 }