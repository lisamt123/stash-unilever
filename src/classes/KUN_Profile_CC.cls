/*******************************************************************************
    Name:KUN_Profile_CC ()
    Copyright © 2016 unilever
================================================================================
Purpose: To get the data from the database with respect to the KUN User Profile.
================================================================================
History
================================================================================
VERSION         AUTHOR             DATE            Description

1.0             Himanshu Kaushal    04/07/2016     INITIAL DEVELOPMENT :
*********************************************************************************/
public with sharing class KUN_Profile_CC {

    public KUN_Profile__c Profile {get;set;} 

    public KUN_Profile_CC () 
    {
        try
        {                 
           string strProfileId= ApexPages.currentPage().getParameters().get('sfdc.userId');        
           if(string.IsEmpty(strProfileId)) strProfileId= UserInfo.getUserId();       
            LIST<KUN_Profile__c> moProfiles =[ SELECT Capability__c,Cluster__c,E2E_Process__c,Employee_Type__c,
                                               English_speaking__c,Id,KUN_Role_Type__c,Local_Process_Area__c, MCO__c,Name,Organization_Role__c,Organization__c,OwnerId,Position__c,Site__c 
                                               FROM KUN_Profile__c WHERE Unilever_Profile__c  =: strProfileId LIMIT 1]; 
                                                                   
           if (moProfiles != null && moProfiles .Size() > 0 ){
              Profile =  moProfiles [0]; 
           }
           else
           {        
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'User’s KUN Profile dose not Exists, Please contact “KUN Community Administrator “for further details.');
               ApexPages.addMessage(myMsg); 
           }
        }
        catch(Exception e) { 
            // Generic exception handling code here.
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The following exception has occurred: ' + e.getMessage());
             ApexPages.addMessage(myMsg); 
        }  
        finally 
        {
            Profile  = new  KUN_Profile__c (); 
        }
    }  
}