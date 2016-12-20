@RestResource(urlMapping='/MulesoftMock/v1/InvoiceProcessing/v1/*')
global class BFM_MulesoftMock_InvoiceProcessing {

    @HttpPost
    global static String invoiceProcessing(){
    	String response = '{';
  			      response += '"RequestInvoiceProcessingResponse": {';
    		         response += '"errorCode": "",';
    		         response += '"errorMessage": ""';
  			      response += '}';
               response+= '}';
        return response;
    }
}