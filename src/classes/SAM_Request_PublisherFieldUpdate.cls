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
2.0         Alok Kumar          20/08/2016     Fetching publisher from Quotation line items
***********************************************************************/
public with sharing class SAM_Request_PublisherFieldUpdate{

    /*******************************************************************
    Purpose: This method gets the unique list of Publishers from Quotation line items and updates the Publisher field of the Request
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
           
           List<SAM_Request__c> requests = [SELECT Name,txt_CrossCharge_Publisher__c,txt_Request_Type__c,(Select pkl_Publisher__c,pkl_Charging_Type__c FROM Quote_Line_Items__r ) FROM SAM_Request__c where Id in :recIds];           
            for(SAM_Request__c request : requests)
            {
              Set<string> publishers = new Set<String>();
              for(SAM_Quote_Line_Item__c requestLineItem : request.Quote_Line_Items__r)
              {
               if(requestLineItem.pkl_Charging_Type__c == Label.SAM_Cross_Charge_Applicable)
                publishers.add(requestLineItem.pkl_Publisher__c);
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