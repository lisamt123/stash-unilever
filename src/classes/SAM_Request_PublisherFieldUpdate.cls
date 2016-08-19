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
           
            List<SAM_Request__c> requests = [SELECT Name,txt_CrossCharge_Publisher__c,txt_Request_Type__c,(Select txt_Publisher__c FROM Request_Line_Items__r ) FROM SAM_Request__c where Id in :recIds];           
            for(SAM_Request__c request : requests)
            {
              Set<string> publishers = new Set<String>();
              for(SAM_Request_Line_Item__c requestLineItem : request.Request_Line_Items__r)
              {
                  publishers.add(requestLineItem.txt_Publisher__c);
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