/**********************************************************************
Name: SAM_Request_PublisherFieldUpdate
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: Update the Publisher Field of Request
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR               DATE            DETAIL Description
1.0         Alok Kumar          27/07/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class SAM_Request_PublisherFieldUpdate{

    /*******************************************************************
    Purpose: This method gets the unique list of publishers from Product Details and updates the Publisher field of the Request
    InvokedBy : Process Builder : SAM Status Update and Quotation Record Type Update > Is Next Action(Requester)-Quote Approved clause
    Parameters: List<string>
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
   @InvocableMethod
    public static void UpdatePublisherField(List<string> recIds)
    {
        try
        {
            List<SAM_Request__c> requests = [Select Id,txt_CrossCharge_Publisher__c From SAM_Request__c where Id in :recIds];           
            for(SAM_Request__c request : requests)
            {
              List<SAM_Request_Line_Item__c> requestLineItems = [SELECT Name FROM SAM_Request_Line_Item__c WHERE md_Request_ID__c = :request.Id];
              Set<string> publishers = new Set<String>();
              for(SAM_Request_Line_Item__c requestLineItem : requestLineItems)
              {
                  publishers.add(requestLineItem.Name);
              }
              request.txt_CrossCharge_Publisher__c  = String.Join(new List<String>(publishers),',');
              //System.debug(publishers); 
            }
            update requests;
        }
        catch(Exception e)
        {
            System.debug('Request Publisher could NOT be set because of error : ' + e.getMessage());
        }
    }    
 }