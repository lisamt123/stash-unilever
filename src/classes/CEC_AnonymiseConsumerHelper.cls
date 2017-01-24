/**********************************************************************
Name:  CEC_AnonymiseConsumerHelper
Copyright@: 2015  Unilever
=======================================================================
=======================================================================
Purpose: An helper class to anonymise consumer data when retention date
is reached 
========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0        Masood Ansari     Dec-2015      INITIAL DEVELOPMENT   
2.0        Mahesh Konar     Nov-2016      Additonal fields and related records to anonymise
***********************************************************************/
public with sharing class CEC_AnonymiseConsumerHelper{
    
    /***************************************************************** 
        Purpose: Ability to anonymise structured consumer data when retention date is reached.
        Parameters: accountList list of consumer data.
    ********************************************************************/ 
    public void updateAccountInformation(List<Account> accountList){
        
        List<Account> accountToUpdateList = new List<Account>();
        for(Account accountObj : accountList){
            accountObj.Salutation = null;
            accountObj.FirstName = null;
            accountObj.LastName = String.valueOf(accountObj.ID);
            accountObj.PersonEmail = null;
            accountObj.Phone = null;
            accountObj.PersonOtherPhone = null;
            accountObj.PersonMobilePhone = null;
            accountObj.PersonHomePhone = null;
            accountObj.BillingStreet = null;
            accountObj.PersonMailingStreet = null;
            accountObj.ShippingStreet = null;
            accountObj.Date_Anonymized__c = System.now();
            accountObj.Anonymise_check__c = false;
            accountObj.Debit_Card_Number__c = null;
            accountObj.Local_Identifier__c = null ;
            accountObj.Document_Number__c = null ;
            accountToUpdateList.add(accountObj);
            System.debug('*****Account '+accountToUpdateList);
        }
        update accountToUpdateList;
        //updateAccountRelatedInformation(accountList);
    }
    
    /***************************************************************** 
        Purpose: Ability to anonymise all related consumer data when retention date is reached.
        Parameters: accounts list of consumer data.
    ******************************************************************* 
    public void updateAccountRelatedInformation(List<Account> accounts){
        set<Id> relatedSobjIds = new set<Id>();
        set<Id> sobjIds = new set<Id>();
        List<sObject> sobjectsUpdate = new  List<sObject>();
        List<sObject> sobjects = new  List<sObject>();
        
        for(Account acct:   accounts){
            relatedSobjIds.add(acct.Id);
        }
        
        for(case cse : [SELECT Id,Description,Search_Birthdate__c,Search_Email__c,Search_First_Name__c,
                           Search_Home_Phone__c,Search_Last_Name__c,Search_Mailing_City__c,
                           Search_Mailing_Country__c,Search_Mailing_State_Province__c,
                           Search_Mailing_Street__c,Search_Mailing_Zip_Postal_Code__c,
                           Search_Mobile__c,Search_Other_Phone__c,Search_Phone__c,
                           Search_Salutation__c,SMS_Mobile_Number__c,Social_Media_External_Id__c
                           FROM Case
                           WHERE AccountId IN : relatedSobjIds])
        {
            sobjIds.add(cse.Id);
            cse.Description = null;
            cse.Search_Birthdate__c = null;
            cse.Search_Email__c = null;
            cse.Search_Home_Phone__c = null;
            cse.Search_Last_Name__c = null;
            cse.Search_Mailing_City__c = null;
            cse.Search_Mailing_Country__c = null;
            cse.Search_Mailing_State_Province__c = null;
            cse.Search_Mailing_Zip_Postal_Code__c = null;
            cse.Search_Mobile__c = null;
            cse.Search_Other_Phone__c = null;
            cse.Search_Phone__c = null;
            cse.Search_Salutation__c = null;
            cse.SMS_Mobile_Number__c = null;
            cse.Social_Media_External_Id__c = null;
            sobjectsUpdate.add(cse);
        }
        
        for(cec_Fulfilment__c fulfillment : [SELECT Account_Card_Number__c,Date_of_Birth__c,Fullname__c,
                                            Local_Identifier__c,Message__c,Payable_To__c,
                                            PersonEmail__c,Product_Notes__c 
                                            FROM cec_Fulfilment__c
                                            WHERE Case__c IN : sobjIds]){
                                                
            fulfillment.Account_Card_Number__c = null;
            fulfillment.Date_of_Birth__c = null;
            fulfillment.Fullname__c = null;
            fulfillment.Local_Identifier__c = null;
            fulfillment.Message__c = null;
            fulfillment.Payable_To__c = null;  
            fulfillment.PersonEmail__c = null; 
            fulfillment.Product_Notes__c = null;                                     
            sobjectsUpdate.add(fulfillment);
            relatedSobjIds.add(fulfillment.Id);                                    
            
        }
        
        update sobjectsUpdate;
        sobjects.addAll(querysObjects('TH1__Draft__c','Related_Lookup_Case__c',sobjIds));
		sobjects.addAll(querysObjects('CaseHistory','CaseId',sobjIds));
		sobjects.addAll(querysObjects('CaseComment','ParentId',sobjIds));
		sobjects.addAll(querysObjects('EmailMessage','ParentId',sobjIds));
		sobjects.addAll(querysObjects('Task','WhatId',sobjIds));
		sobjects.addAll(querysObjects('Event','WhatId',sobjIds));
		sobjects.addAll(querysObjects('ActivityHistory','WhatId',sobjIds));
		sobjects.addAll(querysObjects('LiveChatTranscript','CaseID',sobjIds));
		sobjects.addAll(querysObjects('note','ParentId',sobjIds));
		sobjects.addAll(querysObjects('Attachment','ParentId',sobjIds));
        sobjects.addAll(querysObjects('smagicinteract__Incoming_SMS__c','smagicinteract__Case__c',sobjIds));
        sobjects.addAll(querysObjects('sf4twitter__Twitter_Conversation__c','sf4twitter__Case__c',sobjIds));
        sobjects.addAll(querysObjects('TH1__Draft__c','Related_Lookup_cec_Fulfilment__c',relatedSobjIds));
        sobjects.addAll(querysObjects('cec_Fulfilment__history','ParentId',relatedSobjIds));
        sobjects.addAll(querysObjects('note','ParentId',relatedSobjIds));
        sobjects.addAll(querysObjects('Attachment','ParentId',relatedSobjIds));
        relatedSobjIds.clear();
         for(sObject reterive : querysObjects('CEC_Retrieval_Request__c','Case__c',sobjIds)){
            relatedSobjIds.add(reterive.Id);
        }
        sobjects.addAll(querysObjects('TH1__Draft__c','Related_Lookup_CEC_Retrieval__c',relatedSobjIds));
        sobjects.addAll(querysObjects('CEC_Retrieval_Request__history','Related_Lookup_CEC_Retrieval__c',relatedSobjIds));
        sobjects.addAll(querysObjects('Task','WhatId',relatedSobjIds));
        sobjects.addAll(querysObjects('Event','WhatId',relatedSobjIds));
        
        delete sobjects;
    }*/
    
    /***************************************************************** 
        Purpose: to query sobject using dynamic query.
        Parameters: sobjectName sObject Name.
        Parameters: whereCond to filter the query.
        Parameters: caseIds case Id of all consumer data.
    *******************************************************************
    public List<sObject> querysObjects(String sobjectName,String whereCond, set<Id> caseIds){
        
        return Database.query('SELECT Id FROM ' + sobjectName +' WHERE ' + whereCond + ' IN: caseIds');
    }*/
        
}