public with sharing class CORE_LA_FileUploadUtility {
     @AuraEnabled    
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
        return newContentVersion.Id;
    }
    
    @AuraEnabled
    public static Id saveTheChunk(String fileName, String baseData, String contentType, String fileId) { 
        String fileIdParam=fileId;
        if (fileIdParam == '') {
            fileIdParam = saveTheFile(fileName, baseData, contentType);
        } else {
            fileIdParam = appendToFile(fileIdParam, baseData);
        }
        return Id.valueOf(fileIdParam);
    }

    public static String appendToFile(Id fileId, String base64Data) {
            /*String base64DataParam = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            ContentVersion a = [Select Id, ContentDocumentId,VersionData from ContentVersion where id =: fileId];
            a.VersionData = EncodingUtil.base64Decode(EncodingUtil.base64Encode(a.VersionData) + base64DataParam); 
            update a;*/
        system.debug('=============> appendToFile====> '+ fileId);
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');

        ContentVersion oldContentVersion = [
            SELECT Id, VersionData,Title, PathOnClient, ContentDocumentId
            FROM ContentVersion
            WHERE Id = :fileId
        ];

        String existingBody = EncodingUtil.base64Encode(oldContentVersion.VersionData);
 
        ContentVersion newContentVersion = new ContentVersion();
        // see https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_contentversion.htm
        newContentVersion.Title = oldContentVersion.Title;
        newContentVersion.PathOnClient = oldContentVersion.PathOnClient;
        newContentVersion.VersionData = EncodingUtil.base64Decode(existingBody + base64Data);
        newContentVersion.Origin = 'H';
        
        insert newContentVersion;
        
       /* ContentVersion c = [Select Id, ContentDocumentId from ContentVersion where id =: newContentVersion.Id LIMIT 1]; 
        
        ContentDocument cd = new ContentDocument();
        cd.Id = oldContentVersion.ContentDocumentId;
        delete cd;
        */
        
         ContentVersion c = [Select Id, ContentDocumentId from ContentVersion where id =: newContentVersion.Id LIMIT 1]; 
        
        ContentDocument cd = new ContentDocument();
        cd.Id = oldContentVersion.ContentDocumentId;
        delete cd;
        
        
        return newContentVersion.Id;
    }
}