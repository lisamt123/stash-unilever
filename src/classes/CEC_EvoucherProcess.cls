/**********************************************************************
 Name:  CEC_EvoucherProcess()
 Copyright ? 2016  Unilever
======================================================================
======================================================================
Purpose:  
1. Populate e-Voucher number on Fulfilment object based on Account Id, Fulfilment Id, Country Name                               
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
   1.0 - Rajesh       08/03/2016       INITIAL DEVELOPMENT     Populate e-Voucher number on Fulfilment object based on Account Id, Fulfilment Id, Country Name  
****************************************************************************/
global class CEC_EvoucherProcess
{
    // This method will take fulfilmentId as a i/p parameter and call updateEvoucherDetails method to get the E-Voucher Number.
    webservice static eVoucherProcessWrapperResponse getEvoucherNumber(string fulfilmentId) 
    {     
        CEC_FulfilmentHelper fulfilmentHelper = new CEC_FulfilmentHelper();
        return fulfilmentHelper.updateEvoucherDetails(fulfilmentId);        
    }
    
    global class eVoucherProcessWrapperResponse {
        webservice string status;
        webservice string message;                
    }
    
}