/**********************************************************************
 Name:  CEC_ChequeProcess()
 Copyright ? 2013  Unilever
======================================================================
======================================================================
Purpose:  
1. Populate latest Cheque number on Fulfilment object based on Brand & Company                                 
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
   1.0 - Rajesh       19/11/2015       INITIAL DEVELOPMENT     Populate latest Cheque number on Fulfilment object based on Brand & Company 
****************************************************************************/
global class CEC_ChequeProcess
{
    // This method will take fulfilmentId as a i/p parameter and call generateChequeNumber method to get the latest Cheque code.
    webservice static chequeProcessWrapperResponse generateChequeNumber(string fulfilmentId) 
    {     
        CEC_FulfilmentHelper fulfilmentHelper = new CEC_FulfilmentHelper();
        return fulfilmentHelper.getChequeNumber(fulfilmentId);        
    }
    
    global class chequeProcessWrapperResponse {
        webservice string status;
        webservice string message;                
    }
    
}