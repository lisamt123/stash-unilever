public with sharing class ipmDownloadTemplateController
{
    // Zip file paths
    public List<String> paths {get;set;}
    
    // Generated zip file data (see receiveZipFile)
    public transient String zipFileData {get;set;}
    public String fileId {get;set;}
    public IPM_Project__c project {get; set;}
    
    //private ApexPages.StandardController controller;
    
    public ipmDownloadTemplateController(){
        //IE-9 Fix
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');

        String projectId = ApexPages.currentPage().getParameters().get('Id');
        if (projectId != NULL){
            project = [SELECT Id, IPM_Project_Name__c, Sustainability_Period__c, IPMProject_Span__c, Market_Cluster__c, IPM_Parent_Project__c, IPM_Parent_Project__r.Market_Cluster__c, IPM_Phase__c 
                        FROM IPM_Project__C 
                        WHERE Id=:projectId];
        fileId = ApexPages.currentPage().getParameters().get('fileId');
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'The template is being generated, please wait'));
            
        List<Attachment> attachments = [select Name from Attachment where ParentId =: fileId];
        paths = new List<String>();
        for(Attachment attachment : attachments)
          paths.add(attachment.Name);      
        }
    }
    
    public PageReference receiveZipFile(){
        // Receive the generated zip file and store it (in this case as a Document)
        IPM_Financial_File__c zipFile = [select Name from IPM_Financial_File__c where Id =: fileId]; 
        Database.SaveResult saveResult = Database.insert(
            new Attachment(
                Name = zipFile.Name,
                Body = EncodingUtil.base64Decode(zipFileData),
                ParentId = zipFile.Id
            )
        );
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'The template has been generated and downloaded'));
        
        return new PageReference('/servlet/servlet.FileDownload?file='+saveResult.getId());
    }
    
    @RemoteAction
    public static String getZipFileEntry(String path, String state){
        // Retrieve or generate the Base64 encoded data for each file path to be added to the zip
        Attachment attachment = [select Name, Body from Attachment where ParentId =:state and Name =:path];
        return EncodingUtil.base64Encode(attachment.body);
    }  
}