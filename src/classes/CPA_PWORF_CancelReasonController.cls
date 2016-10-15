/**********************************************************************
Name: CPA_PWORF_CancelReasonController()
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
public with sharing Class CPA_PWORF_CancelReasonController{
     Public id pworfId;
     Public CPA_PWORF__c pworfRec;
     Public List<CPA_project_work_order__c> pwoRec;
     Public List<CPA_LOI__c> loiRec;
     Public List<CPA_CR__c> crRec;
     Public List<Id> pwoIdList;
     Public string strReason{get;set;}
    
    /*******************************************************************
    Purpose: This constructor captures ID from the user
    Parameters: ApexPages.StandardController
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public CPA_PWORF_CancelReasonController(ApexPages.StandardController controller) {
        
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
              pworfId= ApexPages.currentPage().getParameters().get('id');
              getRecord(pworfId);
        }
      }
    /*******************************************************************
    Purpose: To get the PWORF record details by providing its ID
    Parameters: crId
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/  
    public void getRecord(ID pworfId){
        pworfRec = [select id,ltxt_Reason_for_Cancellation__c,pkl_Status__c,isCancelled__c  from CPA_PWORF__c where id =:pworfId];
        pwoRec = [select id,txta_Reason_for_Cancellation__c,pkl_Status__c,PWORF_ID__c  from CPA_project_work_order__c  where PWORF_ID__c =:pworfId];      
        loiRec =[select id,txta_Reason_for_Cancellation__c,pkl_Status__c,lkp_PWORF__c  from CPA_LOI__c where lkp_PWORF__c =:pworfId];
        Id profileId=userinfo.getProfileId();
      
        strReason = pworfRec.ltxt_Reason_for_Cancellation__c;
      }
    /*******************************************************************
    Purpose: This method saves the cancel reason
    Parameters:
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/  
    public PageReference  SaveCancelReason(){
        List<id> pwoIdList = new List<id>();
        if(pwoRec.size()>0){
            for(CPA_project_work_order__c pwo:pwoRec){
                pwoIdList.add(pwo.id);
            }
        }
        if(pwoIdList.size() > 0){
            crRec = [select id,ltxta_Reason_for_Cancellation__c,pkl_Status__c,CPA_Project_Work_Order__c  from CPA_CR__c where CPA_Project_Work_Order__c =:pwoIdList];
        }
        
        if(pwoRec!=null && pwoRec.size() > 0)
            pwoCancel(pwoRec);
        if(loiRec != null && loiRec.size() > 0)
            loiCancel(loiRec);  
        if(crRec != null && crRec.size() > 0)
            crCancel(crRec);
        if(pworfRec != null)
            pworfCancel(pworfRec);
        PageReference ReturnPage = new PageReference('/' + pworfRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;          
    }
        
    /*******************************************************************
    Purpose: This method redirects to PWORF page
    Parameters:
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/
    public PageReference  CancelReason(){
        PageReference ReturnPage = new PageReference('/' + pworfRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;
    
    }
    /*******************************************************************
    Purpose: This method is used to store status as cancel
    Parameters:
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/
    void pworfCancel(CPA_PWORF__c pworfRecord){
        pworfRecord.ltxt_Reason_for_Cancellation__c = strReason;
        pworfRecord.pkl_Status__c= CPA_ConstantsForContractingAppClasses.CANCELLED;
        pworfRecord.isCancelled__c= true;
        update pworfRecord;
    }
    /*******************************************************************
    Purpose: This method is used to store status as cancel for PWO
    Parameters:
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/
    void pwoCancel(List<CPA_project_work_order__c> pwoRecList){
        List<CPA_project_work_order__c> pwoList = new List<CPA_project_work_order__c>();
        if(pwoRecList.size()>0){
            for(CPA_project_work_order__c pwo:pwoRecList){
                pwo.txta_Reason_for_Cancellation__c = strReason;
                pwo.pkl_Status__c= CPA_ConstantsForContractingAppClasses.CANCELLED;
                pwoList.add(pwo);
            }
            update pwoList;
        }
    }
    /*******************************************************************
    Purpose: This method is used to store status as cancel for LOI
    Parameters:
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/
    void loiCancel(List<CPA_LOI__c> loiRecList){
        List<CPA_LOI__c> loiList = new List<CPA_LOI__c>();
        if(loiRecList.size()>0){
            for(CPA_LOI__c loi:loiRecList){
                loi.txta_Reason_for_Cancellation__c = strReason;
                loi.pkl_Status__c= CPA_ConstantsForContractingAppClasses.CANCELLED;
                loiList.add(loi);
            }
            update loiList;
        }
    }
    /*******************************************************************
    Purpose: This method is used to store status as cancel for CR
    Parameters:
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/
    void crCancel(List<CPA_CR__c> crRecList){
        List<CPA_CR__c> crList = new List<CPA_CR__c>();
        if(crRecList.size()>0){
            for(CPA_CR__c cr:crRecList){
                cr.ltxta_Reason_for_Cancellation__c = strReason;
                cr.pkl_Status__c= CPA_ConstantsForContractingAppClasses.CANCELLED;
                crList.add(cr);
            }
            update crList;
        }
    }
}