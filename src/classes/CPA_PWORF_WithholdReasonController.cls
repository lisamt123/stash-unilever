/********************************************************************
 Name:  CPA_PWORF_WithholdReasonController()
 Copyright © 2015  Unilever
 ======================================================
======================================================
Purpose:  Schedular class to schedule the Batch process for Pworf Ageing calculation                                                     
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR   DATE              DETAIL                 Description
   1.0   Name     03/04/2015        INITIAL DEVELOPMENT           
***********************************************************************/
public with sharing class CPA_PWORF_WithholdReasonController{
    Public id loiId;
    Public CPA_PWORF__c loiRec;
    Public string strReason{get;set;}  
    
    /*******************************************************************
    Purpose: Constructor to get LOI id from query string
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public CPA_PWORF_WithholdReasonController(ApexPages.StandardController controller) {
        
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
            loiId= ApexPages.currentPage().getParameters().get('id');
            getRecord(loiId);     
        }
      }
    /*******************************************************************
    Purpose: This method is used to get record id
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/  
    public void getRecord(ID loiId){
       loiRec = [select id,txta_Reason_for_Return__c,pkl_Status__c  from CPA_PWORF__c where id =:loiId];
       strReason = loiRec.txta_Reason_for_Return__c;
    }
    /*******************************************************************
    Purpose: This method is used to store cancel reason
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/  
    public PageReference  SaveCancelReason(){
        loiRec.txta_Reason_for_Return__c = strReason;
        loiRec.pkl_Status__c= CPA_ConstantsForContractingAppClasses.WITHHOLD;
        update loiRec;  
        PageReference ReturnPage = new PageReference('/' + loiRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;
    }
    /*******************************************************************
    Purpose: This method is used to redirect to LOi page
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public PageReference  CancelReason(){
        PageReference ReturnPage = new PageReference('/' + loiRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;  
    }
}