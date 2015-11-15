/**
* @author       Cognizant (Vipul)
* @date         27/04/2015
* @description  This class is used for managing the downloading of financial templates
*/
public with sharing class IPM_DownloadTemplateController extends IPM_ProjectIntermediateController {
    
    public List<String> paths {get;set;} // Zip file paths

    public Boolean isError {get; set;} //Boolean variable to indicate error on page
    public String errorMessage {get; set;} //Error Message to be displayed on the page

    public transient String zipFileData {get;set;} // Generated zip file data (see receiveZipFile)
    public String fileId {get;set;} //Financial File Id
    public IPM_Project__c project {get; set;} //The project record for which the financial business cases are being downloaded

    private static final String CLASS_NAME = 'IPM_DownloadTemplateController'; //Class Name for Exception Logging
    
    /*******************************************************************************************************
    * @description  Constructor
    * @param        NONE
    * @return       NONE
    */
    public IPM_DownloadTemplateController(){
        try{
            //IE-9 Fix
            Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');
    
            String projectId = ApexPages.currentPage().getParameters().get('Id');
            if (projectId != null){
                project = [SELECT Id, IPM_Project_Name__c, Sustainability_Period__c, IPMProject_Span__c, Market_Cluster__c, IPM_Parent_Project__c, IPM_Parent_Project__r.Market_Cluster__c, IPM_Phase__c 
                            FROM IPM_Project__C 
                            WHERE Id=:projectId];
                fileId = ApexPages.currentPage().getParameters().get('fileId');
                if (fileId != null){
                    List<Attachment> attachments = [SELECT Name 
                                                        FROM Attachment 
                                                        WHERE ParentId =: fileId];
                    paths = new List<String>();
                    for(Attachment attachment : attachments){
                        paths.add(attachment.Name);      
                    }
                }
            }
            
        } catch (Exception ex) {
            ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),CLASS_NAME,
                            'constructor',ex.getMessage(),ex, 'Error', null, null, null); 
            if(ApexPages.currentPage() != null){  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage() + '\n' + ex.getStackTraceString()));
            }
        }
    }
    
    /*******************************************************************************************************
    * @description  Receive the generated zip file and store it (in this case as a IPM_Financial_File__c)
    * @param        NONE
    * @return       NONE
    */
    public PageReference receiveZipFile(){

        try {
            IPM_Financial_File__c zipFile = [SELECT Name 
                                                FROM IPM_Financial_File__c 
                                                WHERE Id =: fileId]; 
            if (fileId != null) {
                Database.SaveResult saveResult = Database.insert(
                    new Attachment(
                        Name = zipFile.Name,
                        Body = EncodingUtil.base64Decode(zipFileData),
                        ParentId = zipFile.Id
                    )
                );
                
                return new PageReference(IPM_ConstantUtils.SERVLET_URL + saveResult.getId());
            }
            return null;
            
        } catch (Exception ex) {
            ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),CLASS_NAME,
                            'receiveZipFile',ex.getMessage(),ex, 'Error', null, null, null); 
            if(ApexPages.currentPage() != null){  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage() + '\n' + ex.getStackTraceString()));
            }
            return null;
        }
    }
    
    /*******************************************************************************************************
    * @description      Javascript Remote action to retrieve or generate the Base64 encoded data 
    *                   for each file path to be added to the zip
    * @param path       File Path
    * @param state      Record Id
    * @return           Attachment body as string
    */
    @RemoteAction
    public static String getZipFileEntry(String path, String state){
        try {
            Attachment attachment = [select Name, Body from Attachment where ParentId =:state and Name =:path];
            return EncodingUtil.base64Encode(attachment.body);
            
        } catch (Exception ex) {
            ExceptionLoggingHelper.createErrorLogofIPM(UserInfo.getUserId(),CLASS_NAME,
                            'getZipFileEntry',ex.getMessage(),ex, 'Error', null, null, null); 
            if(ApexPages.currentPage() != null){  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage() + '\n' + ex.getStackTraceString()));
            }
            return null;
        }
    }  
}