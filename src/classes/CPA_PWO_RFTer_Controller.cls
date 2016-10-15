/**********************************************************************
Name: CPA_PWO_RFTer_Controller()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This class is used to capture mandatory fields
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       01/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_PWO_RFTer_Controller{
 
    public ID CPA_PWOID;
     Public CPA_project_work_order__c CPAPwoObject;
     Public string strReason{get;set;}  

    /*******************************************************************
    Purpose: Below constructor will be call from VF page
    Parameters: ApexPages.StandardController
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public CPA_PWO_RFTer_Controller(ApexPages.StandardController controller) {
        
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
            CPA_PWOID= ApexPages.currentPage().getParameters().get('id');
            getRecord(CPA_PWOID);     
        }
      }
    /*******************************************************************
    Purpose: To get the PWO record details by providing its ID
    Parameters: crId
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/  
    public void getRecord(ID CPA_PWOID){
        CPAPwoObject = [select id,txta_Request_for_Termination__c,pkl_Status__c  from CPA_project_work_order__c where id =:CPA_PWOID];
        strReason = CPAPwoObject.txta_Request_for_Termination__c;
    }
    
    /*******************************************************************
    Purpose: This method saves the cancel reason
    Parameters:
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/
    public PageReference  SaveCancelReason(){
        CPAPwoObject.txta_Request_for_Termination__c = strReason;
        CPAPwoObject.pkl_Status__c= CPA_ConstantsForContractingAppClasses.REQUESTFORTERMINATION;
        update CPAPwoObject;  
        PageReference ReturnPage = new PageReference('/' + CPAPwoObject.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;
    }
    /*******************************************************************
    Purpose: This method redirects to PWO page
    Parameters:
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/
    public PageReference  CancelReason(){
        PageReference ReturnPage = new PageReference('/' + CPAPwoObject.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;  
    }
}