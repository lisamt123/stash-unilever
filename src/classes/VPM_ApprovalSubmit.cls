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

public class VPM_ApprovalSubmit {
@InvocableMethod(label='Submit for approval Process')
  public static void SubmitApproval(List<VPM_PurchasingRequests__c> purclst)
    {
        try
        {
        System.debug('------SubmitApproval');
        string ProcessName ='';
        System.debug('------SubmitApproval' + purclst);
        for(VPM_PurchasingRequests__c purc : purclst)
        {
            // Create an approval request for the account
            
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
 	        req1.setComments('');
            req1.setObjectId(purc.Id);
		    // Submit the record to specific process and skip the criteria evaluation
		   // Get Process Name
		    String Country1 = Purc.VPM_CRVT__c.left(1);
            String Country2 = Purc.VPM_CRVT__c.left(2);
            String Country3 = Purc.VPM_CRVT__c.left(3);
            
            if(purc.VPM_BusinessRequestorSubmitted__c=='Yes' && purc.VPM_Rework__c=='No')
               ProcessName='VPM_PurchasingRequestFLSApprovals'; // FLS Approval Process 
            else if(purc.VPM_Rework__c=='No' && Purc.VPM_AdvancedFormSubmitted__c=='Yes' && purc.VPM_ProcurementApprovalRequired__c==true && purc.VPM_ProcurementSubmitted__c=='No' && (purc.VPM_IsInApprovalProcess__c=='' || purc.VPM_IsInApprovalProcess__c==null)
                   )
                ProcessName='VPM_Procurement_Approval';  // Procurement approval Process 
            else if(purc.VPM_Rework__c=='No' && Purc.VPM_AdvancedFormSubmitted__c=='Yes'
                    && purc.VPM_RussianTaxApprovalRequired__c==true && purc.VPM_RussiaSubmitted__c=='No'
                    && (purc.VPM_IsInApprovalProcess__c=='' || purc.VPM_IsInApprovalProcess__c==null)
                   )
                ProcessName='VPM_RussianCustomTaxApproval'; // Russian Tax Approval process 
            else if(purc.VPM_Rework__c=='No' && Purc.VPM_AdvancedFormSubmitted__c=='Yes'
                    && purc.VPM_FreightApprovalRequired__c==true && purc.VPM_FreightSubmitted__c=='No'
                     && (purc.VPM_IsInApprovalProcess__c=='' || purc.VPM_IsInApprovalProcess__c==null)
                   )
                ProcessName='VPM_VendorRequestFreightApprovals'; // Freight approval process 
            else  if(purc.VPM_Rework__c=='No' && Purc.VPM_AdvancedFormSubmitted__c=='Yes'
                    && purc.VPM_FinanceApprovalRequired__c==true && purc.VPM_FinanceSubmitted__c=='No'
                    && (purc.VPM_IsInApprovalProcess__c=='' || purc.VPM_IsInApprovalProcess__c==null)
                    && (  Country1.contains('A') || 
                          Country1.contains('B') ||
                          Country1.contains('C') ||
                          Country1.contains('D') ||
                          Country1.contains('E') ||
                          Country1.contains('G') ||
                          Country2.contains('Ga') ||
                          Country2.contains('Ge') ||
                          Country1.contains('F')
                       )
                   )
                ProcessName='VPM_VendorRequestFinanceApproval'; // Finance  A-G  Approval Process 
            else if(purc.VPM_Rework__c=='No' && Purc.VPM_AdvancedFormSubmitted__c=='Yes'
                    && purc.VPM_FinanceApprovalRequired__c==true && purc.VPM_FinanceSubmitted__c=='No'
                    && (purc.VPM_IsInApprovalProcess__c=='' || purc.VPM_IsInApprovalProcess__c==null)
                    && (  Country1.contains('H') || 
                          Country1.contains('I') ||
                          Country1.contains('J') ||
                          Country1.contains('K') ||
                          Country1.contains('L') ||
                          Country1.contains('M') ||
                          (Country1.contains('G') && ((!Country2.contains('Ge')) || (!Country2.contains('Ga')) ) )||
                          (Country1.contains('N') && ((!Country2.contains('Na')) || (!Country2.contains('Ne')) || (!Country3.contains('Nic'))) )                       
                       )
                   )
                ProcessName='VPM_VendorRequestFinanceApproval2'; // Finance  G-N  Approval Process 
            else  if(purc.VPM_Rework__c=='No' && Purc.VPM_AdvancedFormSubmitted__c=='Yes'
                    && purc.VPM_FinanceApprovalRequired__c==true && purc.VPM_FinanceSubmitted__c=='No'
                    && (purc.VPM_IsInApprovalProcess__c=='' || purc.VPM_IsInApprovalProcess__c==null)
                    && (  Country1.contains('N') || 
                          Country1.contains('M') ||
                          Country1.contains('O') ||
                          Country1.contains('P') ||
                          Country1.contains('q') ||
                          Country1.contains('R') ||
                          Country1.contains('S') ||
                          (Country1.contains('T') && (!Country3.contains('Tur')) )
                       )
                   )
                ProcessName='VPM_VendorRequestFinanceApproval3'; // Finance  N-T  Approval Process 
            else  if(purc.VPM_Rework__c=='No' && Purc.VPM_AdvancedFormSubmitted__c=='Yes'
                    && purc.VPM_FinanceApprovalRequired__c==true && purc.VPM_FinanceSubmitted__c=='No'
                    && (purc.VPM_IsInApprovalProcess__c=='' || purc.VPM_IsInApprovalProcess__c==null)
                    && (  Country1.contains('T') || 
                          Country1.contains('U') ||
                          Country1.contains('V') ||
                          Country1.contains('W') ||
                          Country1.contains('X') ||
                          Country1.contains('Y') ||
                          Country1.contains('Z') 
                       )
                   )
                ProcessName='VPM_VendorRequestFinanceApproval4'; // Finance  T-Z  Approval Process 
            else if(purc.VPM_Rework__c=='No' && Purc.VPM_AdvancedFormSubmitted__c=='Yes'
                    && purc.VPM_BankDataValidationRequired__c==true && purc.VPM_BankDataValidationSubmitted__c=='No'
                     && (purc.VPM_IsInApprovalProcess__c=='' || purc.VPM_IsInApprovalProcess__c==null)
                   )
                ProcessName='VPM_BankValidation'; // Bank Validation Approval 
            
             	System.debug('------ProcessName' + ProcessName);
		    	req1.setProcessDefinitionNameOrId(ProcessName);
 
			// Submit the approval request for the account
			Approval.ProcessResult result = Approval.process(req1);
           System.debug('Approval.isLocked(purc)-------'+ Approval.isLocked(purc));
 			if(Approval.isLocked(purc))
               Approval.unlock(purc.Id);
             System.debug('Approval.unlock(purc)-------'+ Approval.unlock(purc));
        }
        }
        catch(exception ex){
            System.debug('Exception in VPM_ApprovalSubmit Function' + Ex.getStacktraceString());
            
           
        }   
    }
    
    }