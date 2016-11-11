/***************************************************
* @author: Cognizant
* @date:  11/11/2016
* @description: Used for PDF File Name Logic
***************************************************/
public with sharing class IPM_GateDocumentPDFDownloadController {
    
    public string fileName{get;set;}  
    
    public IPM_GateDocumentPDFDownloadController() {
         
        fileName = IPM_ConstantUtils.ATTACHMENT_FILE_APPLICATION_TYPE 
            + ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.PROJECTNAME_PARAMETER)
            + '_'
            + ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.PRINTDOC_PARAMETER)
            + IPM_ConstantUtils.ATTACHMENT_DOCUMENT
            + system.today().format()
            + IPM_ConstantUtils.ATTACHMENT_FILE_TYPE;
    }

}