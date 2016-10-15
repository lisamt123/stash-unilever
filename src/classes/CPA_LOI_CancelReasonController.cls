/**********************************************************************
Name: CPA_LOI_CancelReasonController()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This class is used to capture LOI cancel reason
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       12/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_LOI_CancelReasonController {

    Public Id loiId;
    Public CPA_LOI__c loiRec{set;get;}
    Public String strReason{set;get;}
    
    /*******************************************************************
    Purpose: This controller gets LOI record data
    Parameters: ApexPages.StandardController
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public CPA_LOI_CancelReasonController(ApexPages.StandardController controller){
        if(ApexPages.currentPage().getParameters().get('Id')!=null){
            loiId=ApexPages.currentPage().getParameters().get('Id');
            getRecord(loiId);
        }
    }
    
    /*******************************************************************
    Purpose: This method gets record details
    Parameters: loiId
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/  
    public void getRecord(Id loiId){
        loiRec=[select id,txta_Reason_for_Cancellation__c,pkl_Status__c from CPA_LOI__c where id=:loiId];
        strReason=loiRec.txta_Reason_for_Cancellation__c;
    }
    
    /*******************************************************************
    Purpose: This method stores the cancel reason
    Parameters: 
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/ 
    public PageReference SaveCancelReason(){
        loiRec.txta_Reason_for_Cancellation__c = strReason;
        
        loiRec.pkl_Status__c= CPA_ConstantsForContractingAppClasses.CANCELLED;
        update loiRec;
        
        PageReference ReturnPage = new PageReference('/' + loiRec.id); 
        ReturnPage.setRedirect(true);
        return ReturnPage;
    }
    
    /*******************************************************************
    Purpose: This method used to redirect to the page
    Parameters: 
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/ 
    public PageReference CancelReason(){
        PageReference ReturnPage = new PageReference ('/'+loiRec.Id);
        return ReturnPage ;
    }
}