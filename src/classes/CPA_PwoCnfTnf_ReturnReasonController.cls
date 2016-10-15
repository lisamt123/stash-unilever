/**********************************************************************
Name: CPA_PwoCnfTnf_ReturnReasonController()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This class is used to capture PWO/CNF/TNF return reason
-------
======================================================
======================================================
History: AC.08.05.03, AC.09.05.03, AC.11.05.03
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       01/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/

public with sharing Class CPA_PwoCnfTnf_ReturnReasonController{
    Public id pwoId;
    Public CPA_project_work_order__c pwoRec;
    Public string strReason{get;set;}
    Public List<CPA_CR__c> crRec;
    
    public String recordType;
    
    /*******************************************************************
    Purpose: Constructor to get record of a given record id.
    Parameters: ApexPages.StandardController
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/ 
    public CPA_PwoCnfTnf_ReturnReasonController(ApexPages.StandardController controller) {
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
             pwoId= ApexPages.currentPage().getParameters().get('id');
             recordType = ApexPages.currentPage().getParameters().get('recordType');
            getRecord(pwoId);
         
        }
      }
    
    /*******************************************************************
    Purpose: This method actually gets record of a given record id.
    Parameters: loiId
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/  
    public void getRecord(ID pwoId){
       pwoRec = [select id,txta_Reason_for_Return__c,txta_TNF_Reason_for_Return__c,txta_CNF_Reason_for_Return__c, pkl_Status__c,CNF_Status__c,TNF_Status__c from CPA_project_work_order__c where id =:pwoId];
      // crRec = [select id,ltxta_Reason_for_Cancellation__c,pkl_Status__c,PWO_ID__c  from CPA_CR__c where PWO_ID__c =:pwoId];
       
         if(recordType == CPA_ConstantsForContractingAppClasses.PWO){
            strReason = pwoRec.txta_Reason_for_Return__c;
        }else if(recordType == CPA_ConstantsForContractingAppClasses.CNF){
           strReason = pwoRec.txta_CNF_Reason_for_Return__c;
        }else if(recordType == CPA_ConstantsForContractingAppClasses.TNF){
          strReason = pwoRec.txta_TNF_Reason_for_Return__c;
        }
      
      }
    /*******************************************************************
    Purpose: This method is used to save cancel reason.
    Parameters: loiId
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/  
    public PageReference  SaveCancelReason(){
        
        if(recordType == CPA_ConstantsForContractingAppClasses.PWO){
            pwoRec.txta_Reason_for_Return__c = strReason;
            pwoRec.pkl_Status__c = CPA_ConstantsForContractingAppClasses.RETURNED;
        }else if(recordType == CPA_ConstantsForContractingAppClasses.CNF){
            pwoRec.CNF_Status__c = CPA_ConstantsForContractingAppClasses.RETURNED;
            pwoRec.txta_CNF_Reason_for_Return__c = strReason;
        }else if(recordType == CPA_ConstantsForContractingAppClasses.TNF){
            pwoRec.TNF_Status__c = CPA_ConstantsForContractingAppClasses.RETURNED;
            pwoRec.txta_TNF_Reason_for_Return__c = strReason;
        }        
        update pwoRec;
                       
        PageReference ReturnPage = new PageReference('/' + pwoRec.id); 
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
        PageReference ReturnPage = new PageReference('/' + pwoRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;
    
    }
   
}