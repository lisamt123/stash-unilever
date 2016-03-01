/**********************************************************************
Name: CPA_CR_CancelReasonController()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This class is used to capture CR cancel reason.
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       01/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/

public with sharing class CPA_CR_CancelReasonController{
    public Id crId;
    public CPA_CR__c crRec{set;get;}
    public String strReason{set;get;}
    
    /*******************************************************************
    Purpose: This constructor captures ID from the user
    Parameters: ApexPages.StandardController
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public CPA_CR_CancelReasonController(ApexPages.StandardController controller){
        if(ApexPages.currentPage().getParameters().get('Id') != null){
            crId = ApexPages.currentPage().getParameters().get('Id');
            getRecord(crId);
        }
    }
    /*******************************************************************
    Purpose: To get the CR record details by providing its ID
    Parameters: crId
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public void getRecord(Id crId){
        crRec=[select id,ltxta_Reason_for_Cancellation__c,pkl_Status__c from CPA_CR__c where id=:crId];
        strReason=crRec.ltxta_Reason_for_Cancellation__c;
    } 
    
    /*******************************************************************
    Purpose: This method saves the cancel reason
    Parameters:
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/
    public PageReference SaveCancelReason(){
        crRec.ltxta_Reason_for_Cancellation__c = strReason;
        crRec.pkl_Status__c= 'Cancelled';
        update crRec;
        PageReference ReturnPage = new PageReference('/' + crRec.id); 
        ReturnPage.setRedirect(true);
        return ReturnPage;
    }
    
    /*******************************************************************
    Purpose: This method redirects to CR page
    Parameters:
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/
    public PageReference CancelReason(){
        PageReference ReturnPage = new PageReference ('/'+crRec.Id);
        return ReturnPage ;
    }   
}