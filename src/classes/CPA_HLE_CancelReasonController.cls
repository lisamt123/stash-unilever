/**********************************************************************
Name: CPA_HLE_CancelReasonController()
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
public with sharing class CPA_HLE_CancelReasonController{
 Public id hleId;
     Public CPA_HLE_Request__c hleRecord;
     Public string strReason{get;set;}  
    /*******************************************************************
    Purpose: This constructor captures ID from the user
    Parameters: ApexPages.StandardController
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public CPA_HLE_CancelReasonController(ApexPages.StandardController controller) {
        
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
              hleId= ApexPages.currentPage().getParameters().get('id');
            getRecord(hleId);     
        }
      }
    /*******************************************************************
    Purpose: To get the HLE record details by providing its ID
    Parameters: crId
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public void getRecord(ID hleId){
       hleRecord = [select id,  txta_Reason_for_Cancellation__c,pkl_Status__c  from CPA_HLE_Request__c where id =:hleId];
       strReason = hleRecord.txta_Reason_for_Cancellation__c;
      }
    
    /*******************************************************************
    Purpose: This method saves the cancel reason
    Parameters:
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/
    public PageReference  SaveCancelReason(){
        hleRecord.txta_Reason_for_Cancellation__c = strReason;
        hleRecord.pkl_Status__c= CPA_ConstantsForContractingAppClasses.CANCELLED;
        Approval.unLockResult lrList = Approval.unlock(hleRecord.id, true);           
        update hleRecord;  
        PageReference ReturnPage = new PageReference('/' + hleRecord.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;
    }
    /*******************************************************************
    Purpose: This method redirects to HLE page
    Parameters:
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/
    public PageReference  CancelReason(){
        PageReference ReturnPage = new PageReference('/' + hleRecord.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;  
    }
}