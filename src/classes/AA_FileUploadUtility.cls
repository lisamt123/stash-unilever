public with sharing class AA_FileUploadUtility {

    public static Id saveTheFile(String fileName, String base64Data, String contentType){
        String base64DataParam = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion newContentVersion = new ContentVersion();
       
        newContentVersion.Title = fileName;
        newContentVersion.PathOnClient = fileName;
        newContentVersion.VersionData = EncodingUtil.base64Decode(base64DataParam);
        newContentVersion.Origin = 'H'; 
        newContentVersion.IsMajorVersion = false;
        newContentVersion.CMS_ID__c='';
        insert newContentVersion;
        //ContentVersion c = [Select Id, ContentDocumentId from ContentVersion where id =: newContentVersion.Id LIMIT 1]; 
        
            return newContentVersion.Id;
    } 
    @AuraEnabled
    public static Id saveTheChunk(String fileName, String base64Data, String contentType, String fileId) { 
        system.debug('Inside saveTheChuck: AA_FileUploadUtility');
        String fileIdParam=fileId;
        if (fileIdParam == '') {
            fileIdParam = saveTheFile(fileName, base64Data, contentType);
        } else {
            appendToFile(fileIdParam, base64Data);
        }
        return Id.valueOf(fileIdParam);
    }
    @future 
    public static void appendToFile(Id fileId, String base64Data) {
            String base64DataParam = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            ContentVersion a = [Select Id, ContentDocumentId,VersionData from ContentVersion where id =: fileId];
            a.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(a.VersionData) + base64DataParam); 
            update a;
    }
}