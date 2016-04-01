/**********************************************************************
Name: CPA_LOI_ReturnReasonController()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This class is used to capture CR return reason
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       01/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_LOI_ReturnReasonController{
    Public id loiId;
     Public CPA_LOI__c loiRec;
     Public string strReason{get;set;}  
    /*******************************************************************
    Purpose: Constructor to get record of a given record id.
    Parameters: ApexPages.StandardController
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/ 
    public CPA_LOI_ReturnReasonController(ApexPages.StandardController controller) {
        
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
              loiId= ApexPages.currentPage().getParameters().get('id');
            getRecord(loiId);     
        }
      }
    /*******************************************************************
    Purpose: This method actually gets record of a given record id.
    Parameters: loiId
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/  
    public void getRecord(ID loiId){
       loiRec = [select id,txta_Reason_for_Return__c,pkl_Status__c  from CPA_LOI__c where id =:loiId];
       strReason = loiRec.txta_Reason_for_Return__c;
      }
    /*******************************************************************
    Purpose: This method is used to save cancel reason.
    Parameters: loiId
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/  
    public PageReference  SaveCancelReason(){
        loiRec.txta_Reason_for_Return__c = strReason;
        loiRec.pkl_Status__c= CPA_ConstantsForContractingAppClasses.RETURNED;
        update loiRec;  
        PageReference ReturnPage = new PageReference('/' + loiRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;
    }
    /*******************************************************************
    Purpose: This method is used to redirect to the page.
    Parameters: loiId
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public PageReference  CancelReason(){
        PageReference ReturnPage = new PageReference('/' + loiRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;  
    }
}