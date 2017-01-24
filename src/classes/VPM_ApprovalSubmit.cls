/**********************************************************************
Name:  VPM_ApprovalSubmit()
Copyright ? 2016  Unilever
======================================================================
======================================================================
Purpose:  Used to trigger the Approval process 
1. Base on the Values trigger the appropriate approval process from process builder 
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
1.0 - Samrin       09/09/2016       INITIAL DEVELOPMENT     Invocable method which is call in PB to trigger the approval process 
****************************************************************************/

public  class VPM_ApprovalSubmit {
    public static final string YES = 'Yes';
    public static final string NO = 'No';
    public static final string FLS = 'FLS';
    public static final string DRAFT = 'Draft';
@InvocableMethod(label='Submit for approval Process')
  public static void SubmitApproval(List<VPM_PurchasingRequests__c> purclst)
    {
      try
        {
        System.debug('------SubmitApproval');
        string ProcessName ='';
        System.debug('------SubmitApproval' + purclst);
            Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();
        for(VPM_PurchasingRequests__c purc : purclst)
        {
            // Create an approval request for the account
            
            
            submitRequest.setComments('');
            
             if((String.isNotBlank(Purc.VPM_Status__c) && Purc.VPM_Status__c.contains(FLS )) 
             ||
              (String.isNotBlank(Purc.VPM_Status__c) && Purc.VPM_Status__c.contains(DRAFT))
                ) 
             {
                   submitRequest.setSubmitterId(UserInfo.getUserId()); 
             }
                 
            submitRequest.setObjectId(purc.Id);
            // Submit the record to specific process 
           // Get Process Name
           system.debug('@@purc' + purc);
                if(purc.VPM_BusinessRequestorSubmitted__c==YES && purc.VPM_Rework__c==NO)
                { ProcessName='VPM_PurchasingRequestFLSApprovals'; // FLS Approval Process 
                }
            else if(purc.VPM_Rework__c==NO && Purc.VPM_AdvancedFormSubmitted__c==YES && purc.VPM_ProcurementApprovalRequired__c && purc.VPM_ProcurementSubmitted__c==NO && (purc.VPM_IsInApprovalProcess__c=='' || purc.VPM_IsInApprovalProcess__c==null)
                   )
            {   ProcessName='VPM_ProcurementApproval';  // Procurement approval Process 
            }
            
            else if(purc.VPM_Rework__c==NO && Purc.VPM_AdvancedFormSubmitted__c==YES
                    && purc.VPM_FreightApprovalRequired__c && purc.VPM_FreightSubmitted__c==NO
                     && (purc.VPM_IsInApprovalProcess__c=='' || purc.VPM_IsInApprovalProcess__c==null)
                   )
            {   ProcessName='VPM_VendorRequestFreightApprovals'; // Freight approval process 
            }
            else if(purc.VPM_Rework__c==NO && Purc.VPM_AdvancedFormSubmitted__c==YES
                    && (purc.VPM_FinanceApprovalRequired__c || purc.VPM_RussianTaxApprovalRequired__c)  && purc.VPM_BankDataValidationRequired__c && purc.VPM_BankDataValidationSubmitted__c==NO && (purc.VPM_IsInApprovalProcess__c=='' || purc.VPM_IsInApprovalProcess__c==null)
                   )
            {   ProcessName='VPM_BankValidation'; // Bank Validation Approval 
            }
            else if(purc.VPM_Rework__c==NO && Purc.VPM_AdvancedFormSubmitted__c==YES  && purc.VPM_RussianTaxApprovalRequired__c && purc.VPM_RussiaSubmitted__c==NO&& (purc.VPM_IsInApprovalProcess__c=='' || purc.VPM_IsInApprovalProcess__c==null)
                   )
            {   ProcessName='VPM_RussianCustomTaxApproval'; // Russian Tax Approval process 
            }
            else  if(purc.VPM_Rework__c==NO && Purc.VPM_AdvancedFormSubmitted__c==YES  && purc.VPM_FinanceApprovalRequired__c && purc.VPM_FinanceSubmitted__c==NO && (purc.VPM_IsInApprovalProcess__c=='' || purc.VPM_IsInApprovalProcess__c==null)
                   )
            {    ProcessName='VPM_VendorRequestFinaceApproval'; // Finance  T-Z  Approval Process
            }
                System.debug('------ProcessName' + ProcessName);
                submitRequest.setProcessDefinitionNameOrId(ProcessName);
 
                // Submit the approval request for the account
              //  Approval.ProcessResult result = 
              Approval.process(submitRequest);
                System.debug('Approval.isLocked(purc)-------'+ Approval.isLocked(purc));
                if(Approval.isLocked(purc))
                {
                        Approval.unlock(purc.Id);
                }
                System.debug('Approval.unlock(purc)-------'+ Approval.unlock(purc));
            }
        }
       catch(exception ex){
         System.debug('Exception in VPM_ApprovalSubmit Function' + Ex.getStacktraceString());
            
           
       }   
    }
    
    
    }