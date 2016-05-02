/**********************************************************************
 Name:  CEC_AlertFulfilmentEnclosureHelper()
 Copyright ? 2013  Unilever
======================================================================
======================================================================
Purpose:  
1. enclosures automatically populated in the enclosure fields based on my selection of product and reason code and letter                                  
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
   1.0 - Sarmin     15/12/2015       INITIAL DEVELOPMENT     enclosures automatically populated in the enclosure fields based on my selection of product and reason code and letter 
****************************************************************************/
global class CEC_AlertFulfilmentEnclosureHelper
{
    // This method will take CaseId  as a i/p parameter and call enclosuresAutoPopulates method to get the latest Enclosures for fulfillment base on Prodcut & Reason Code.
   webservice static AlertFulfilmentEnclosureHelperWrapperResponse populateEnclosureDetails(string CaseId,String CountryName)
    {     
       CEC_FulfilmentHelper fulfilmentHelper = new CEC_FulfilmentHelper();
       return fulfilmentHelper.populateEnclosureDetails(CaseId,CountryName);    
   }
    
    global class AlertFulfilmentEnclosureHelperWrapperResponse {
        webservice string status;
        webservice string message;
        webservice List<String> enclosuresList = new List<String>();
    }
    
}