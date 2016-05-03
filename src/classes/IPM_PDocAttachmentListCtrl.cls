/**
    @Description: A controller class to list out all the attachment documents to a project that are filled backend
    @Author: Cognizant Technology
    @Date: Apr 2015
**/
public with sharing class IPM_PDocAttachmentListCtrl {
    
    private final IPM_Project__c project; //project sObject depending on the stnadard controller record
    public String projectId{get;set;} //project id from the url
    public DocumentWrapper[] documentList{get;set;} // wrapper list which wraps all the attachments
    public Boolean isExist {get;set;} //boolean property if there are any records exists.
    
    //SC constructor
    public IPM_PDocAttachmentListCtrl(ApexPages.StandardController stdController) {
        //Initialising variables
        isExist = false;
        this.project = (IPM_Project__c)stdController.getRecord();
        documentList = new list<DocumentWrapper>();
        projectId = ApexPages.currentPage().getParameters().get('id');
        String[] gatesList = IPM_Utils.getPicklistValues(new IPM_Project_Document__c(), 'IPM_GateDocuments__c');//Ext Variable to initialise picklist values per Gates
        IPM_Project_Document__c[] projectDocumentsLst = [SELECT IPM_GateDocuments__c, 
                                                                 (SELECT Name FROM Attachments ORDER BY CreatedDate LIMIT 999) 
                                                            FROM IPM_Project_Document__c
                                                            WHERE IPM_Project__c = :projectId
                                                              ORDER BY CreatedDate ASC
                                                              LIMIT 999];
        for(IPM_Project_Document__c eachDocument : projectDocumentsLst) {
            for(String eachGate : gatesList) {
                if(eachGate == eachDocument.IPM_GateDocuments__c) {
                    //We are only aniticipating not more than one attachment per Gate but the number will increase in the next enhancement
                    Attachment attachment = eachDocument.Attachments.size() > 0 ? eachDocument.Attachments[0] : new Attachment();
                    if(attachment != null && attachment.Name != null
                        && attachment.Name.contains(IPM_ConstantUtils.GD_ATTACHMENT_SUFFIX)) {
                        isExist = true;
                        documentList.add(new DocumentWrapper(eachGate + ' Gate Document', eachGate, '/servlet/servlet.FileDownload?file='+attachment.Id));
                    }
                }
            }
        }
        
    }
    
    /**
    @Description: Wrapper class to wrap the documents
    **/
    public class DocumentWrapper {
        
        public String fileName {get; set;} // the name of the file
        public String fileGate {get; set;} // the gate it belongs to
        public String fileLink {get; set;} // the document uploaded link from SF
        
        /**
        @Description: Constructor of the wrapper class
        **/
        public DocumentWrapper(String fName, String fGate, String fLink) {
            fileName = fName;
            fileGate = fGate;
            fileLink = fLink;
        }
    }
}