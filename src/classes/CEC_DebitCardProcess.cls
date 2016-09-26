/**********************************************************************
 Name:  CEC_DebitProcess()
 Copyright ? 2016  Unilever
======================================================================
======================================================================
Purpose:  
1. Populate Debit Card number on Fulfilment object based on Account Id, Fulfilment Id, Country Name                               
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
   1.0 - Rajesh       08/03/2016       INITIAL DEVELOPMENT     Populate Debit Card number on Fulfilment object based on Account Id, Fulfilment Id, Country Name  
****************************************************************************/
global class CEC_DebitCardProcess
{
    // This method will take fulfilmentId as a i/p parameter and call generateChequeNumber method to get the latest Cheque code.
    webservice static debitProcessWrapperResponse getDebitCardNumber(string fulfilmentId) 
    {     
        CEC_FulfilmentHelper fulfilmentHelper = new CEC_FulfilmentHelper();
        return fulfilmentHelper.updateDebitCardDetails(fulfilmentId);        
    }
    
    global class debitProcessWrapperResponse {
        webservice string status;
        webservice string message;                
    }
    
}