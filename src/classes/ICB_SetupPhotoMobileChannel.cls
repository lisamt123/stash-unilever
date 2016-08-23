/**********************************************************************
Name: ICB_SetupPhotoMobileChannel
Copyright © 2016 Unilever

Purpose: Class which set the profile photo related to user.

History 

VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	RONALDO GARCIA		20/08/2016  INITIAL DEVELOPMENT.
***********************************************************************/
public class ICB_SetupPhotoMobileChannel {

    public static final ICB_SetupPhotoMobileChannel instance = new ICB_SetupPhotoMobileChannel();
    
    public ICB_SetupPhotoMobileChannel() {}
    
    public static ICB_SetupPhotoMobileChannel getInstance() {
        return instance;
    }
    
    // Method to change the profile photo of user based on realted contact post. 
    public void changePhoto(List<FeedItem> feed){
        
        System.debug('Entering <changePhoto>'+feed);
        
        // Variables
		String 	strRelatedRecord 	= null; // Store the content version id which will be used to retrieve the content document. 
        String 	strBody 			= null; // Store the post content used to retrieve the hastag used to initiate the process. 
        String 	strCheckHashtag		= Label.ICB_CHECK_HASHTAG; // Store the variable used to entry in the condition. 
        Id 		idContact 			= null; // Store the contact id to retrieve the related user which will be used to reset the photo. 
        Id 		idDocument 			= null; // Store the content document id which will be used to set the photo on profile. 
        
        // Retrieve the feed
        for(FeedItem fi : feed){
            strRelatedRecord 	= fi.RelatedRecordId;
            strBody 			= fi.Body;
            idContact 			= fi.ParentId;
        }        
        System.debug('Entering <strRelatedRecord>'+strRelatedRecord);
        System.debug('Entering <strBody>: '+strBody);
        System.debug('Entering <idContact>'+idContact);
        
        // Check if the post has a key hashtag requesting to change a photo. 
        if(strBody.contains(strCheckHashtag)){
        	
            System.debug('Entering <if>');
            try{
                // Retrieve the document attachment id. 
                idDocument = [Select ContentDocumentId From ContentVersion Where Id =: strRelatedRecord].ContentDocumentId;
                System.debug('Entering <idDocument>'+idDocument);
                
                // Retrieve the user Id based on contact id.           
                User user = [Select ContactId From User Where isPortalEnabled = true And ContactId =: idContact LIMIT 1];
                System.debug('Entering <user.Id>'+user.Id);
                
                // Set the photo updated to the contact profile. 
                ConnectApi.PhotoInput imageProfile = new  ConnectApi.PhotoInput();
                imageProfile.cropSize 	= 200;
                imageProfile.cropX 		= 200;
                imageProfile.cropY 		= 200;
                imageProfile.fileId 	= idDocument;
        
                // Set the image to profile.         
                ConnectApi.Photo photo = ConnectApi.UserProfiles.setPhotoWithAttributes(null, user.Id, imageProfile);
            }
            catch (Exception e){
                System.debug('' + e.getCause() + e.getMessage() + e.getLineNumber());
            } 
        }
    }
}