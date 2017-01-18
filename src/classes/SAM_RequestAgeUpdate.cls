/**********************************************************************
Name: SAM_RequestAgeUpdate()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: Batch Class to process Request Ageing.
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR               DATE            DETAIL Description
1.0         Mindtree          19/07/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
global with sharing class SAM_RequestAgeUpdate implements Database.Batchable<sObject>
{
    /*******************************************************************
    Purpose: This method is start method of the Batchable interface
    Parameters: Database.BatchableContext
    Returns: Database.QueryLocator
    Throws [Exceptions]: 
    ********************************************************************/
    global String query;
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('>>>>>> SAM_RequestAgeUpdate  : Started...');
        query = 'select id,txt_Request_Type__c,createdById, pkl_Status__c,Ticket_Age__c,rus_Pending_with_Project__c,rus_Pending_with_SAM_records__c,date_Query_End_Date__c,date_Query_Start_Date__c,RecordType.DeveloperName  from SAM_Request__c';
        return Database.getQueryLocator(query);
    }

    /*******************************************************************
    Purpose: This method is execute method of the Batchable interface
    Parameters: Database.BatchableContext, List<SAM_Request__c>
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    global void execute(Database.BatchableContext BC, List<SAM_Request__c> requestList)
    {   // Calling the static method   
        if(requestList.size()>0){
            system.debug('requestList>>'+requestList);
            SAM_RequestAgeing.RequestAgeUpdateScheduler(requestList);  
        }
    }

    /*******************************************************************
    Purpose: This method is finish method of the Batchable interface
    Parameters: Database.BatchableContext
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    global void finish(Database.BatchableContext BC)
    {
        System.debug('>>>>>> SAM_RequestAgeUpdate  : Ends');
    }
}