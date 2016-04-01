/**********************************************************************
Name: CPA_PwoCnfTnf_CancelReasonController()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This class is used to capture PWO/CNF/TNF cancel reason
-------
======================================================
======================================================
History : AC.08.12.01, AC.10.07.03
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       01/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_PwoCnfTnf_CancelReasonController{
    Public id pwoId;
    Public CPA_project_work_order__c pwoRec;
    Public string strReason{get;set;}
    Public List<CPA_CR__c> crRec;
    
    public String recordType;
    
    /*******************************************************************
    Purpose: This constructor gets PWO id and record type
    Parameters: ApexPages.StandardController
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/ 
    public CPA_PwoCnfTnf_CancelReasonController(ApexPages.StandardController controller) {
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
             pwoId= ApexPages.currentPage().getParameters().get('id');
             recordType = ApexPages.currentPage().getParameters().get(CPA_ConstantsForContractingAppClasses.RECORDTYPE);
            getRecord(pwoId);
        }
    }
    /*******************************************************************
    Purpose: This method gets record details
    Parameters: pwoId
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/   
    public void getRecord(ID pwoId){
       pwoRec = [select id,txta_Reason_for_Cancellation__c,ltxta_CNF_Reason_for_Cancellation__c,txta_TNF_Reason_for_Cancellation__c, pkl_Status__c,CNF_Status__c,TNF_Status__c, chk_isCNFcancelled__c,chk_isTNFcancelled__c from CPA_project_work_order__c where id =:pwoId];
       crRec = [select id,ltxta_Reason_for_Cancellation__c,pkl_Status__c,CPA_Project_Work_Order__c  from CPA_CR__c where CPA_Project_Work_Order__c =:pwoId];
       
         if(recordType == CPA_ConstantsForContractingAppClasses.PWO){
            strReason = pwoRec.txta_Reason_for_Cancellation__c;
        }else if(recordType == CPA_ConstantsForContractingAppClasses.CNF){
           strReason = pwoRec.ltxta_CNF_Reason_for_Cancellation__c;
        }else if(recordType == CPA_ConstantsForContractingAppClasses.TNF){
          strReason = pwoRec.txta_TNF_Reason_for_Cancellation__c;
        }
      
      }
      
      
    /*******************************************************************
    Purpose: This method stores the cancel reason
    Parameters: 
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/   
    public PageReference  SaveCancelReason(){
        
        if(recordType == CPA_ConstantsForContractingAppClasses.PWO){
            pwoRec.txta_Reason_for_Cancellation__c = strReason;
            pwoRec.pkl_Status__c = CPA_ConstantsForContractingAppClasses.CANCELLED;
        }else if(recordType == CPA_ConstantsForContractingAppClasses.CNF){
            pwoRec.CNF_Status__c = null;
            pwoRec.chk_isCNFcancelled__c = true;
            pwoRec.ltxta_CNF_Reason_for_Cancellation__c = strReason;
        }else if(recordType == CPA_ConstantsForContractingAppClasses.TNF){
            pwoRec.TNF_Status__c = null;
             pwoRec.chk_isTNFcancelled__c = true;
            pwoRec.txta_TNF_Reason_for_Cancellation__c = strReason;
        }
        
        update pwoRec;
        if(recordType == CPA_ConstantsForContractingAppClasses.PWO && crRec != null && crRec.size() > 0){
            crCancel(crRec);
        }                
        PageReference ReturnPage = new PageReference('/' + pwoRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;  
    }
    
    /*******************************************************************
    Purpose: This method used to redirect to the page
    Parameters: 
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/ 
    public PageReference  CancelReason(){
        PageReference ReturnPage = new PageReference('/' + pwoRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;
    
    }
    
    /*******************************************************************
    Purpose: This method used to cancel the record
    Parameters: 
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/
    void crCancel(List<CPA_CR__c> crRecList){
        if(crRecList.size()>0){
            for(CPA_CR__c cr:crRecList){
                cr.ltxta_Reason_for_Cancellation__c = strReason;
                cr.pkl_Status__c= CPA_ConstantsForContractingAppClasses.CANCELLED;
                //update cr;
            }
            update crRecList;
        }
    }
}