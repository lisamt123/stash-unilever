/**********************************************************************
Name: ICB_SetupPhotoMobileChannel
Copyright © 2016 Unilever

======================================================
Purpose: Class which set the profile photo related to user.
======================================================

History
VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	RONALDO GARCIA		20/08/2016  INITIAL DEVELOPMENT.
***********************************************************************/
public with sharing class ICB_SetupPhotoMobileChannel
{
    
    public static final ICB_SetupPhotoMobileChannel instance = new ICB_SetupPhotoMobileChannel();
    
    public ICB_SetupPhotoMobileChannel() {}
    
    public static ICB_SetupPhotoMobileChannel getInstance() 
    {
        return instance;
    }
    /*******************************************************************
    Purpose: Method to change the profile photo of user based on realted contact post.
    Parameters: List<FeedItem> 
    Returns: None
    Throws [Exceptions]: Exception
    ********************************************************************/ 
    public void changePhoto(List<FeedItem> feed)
    {
        
        System.debug('Entering <changePhoto>' + JSON.serializePretty(feed));
        
        try
        {
            // Variables
            String 	strRelatedRecord 	= null; // Store the content version id which will be used to retrieve the content document. 
            String 	strBody 			= null; // Store the post content used to retrieve the hastag used to initiate the process. 
            String 	strCheckHashtag		= Label.ICB_CHECK_HASHTAG; // Store the variable used to entry in the condition. 
            Id 		idContact 			= null; // Store the contact id to retrieve the related user which will be used to reset the photo. 
            
            // Retrieve the feed
            for(FeedItem fi : feed)
            {
                strRelatedRecord 	= fi.RelatedRecordId;
                strBody				= fi.Body;
                idContact 			= fi.ParentId;
            }        
            System.debug('Entering <strRelatedRecord>'+strRelatedRecord);
            System.debug('Entering <strBody>: '+strBody);
            System.debug('Entering <idContact>'+idContact);
            
            // Check if the post has a key hashtag requesting to change a photo. 
            if(!String.isEmpty(strBody) && strBody.contains(strCheckHashtag))
            {
                System.debug('Entering <if>');
                
                ICB_Setup_Photo__c setupPhoto = new ICB_Setup_Photo__c();
                setupPhoto.ICB_Parent_Id__c = idContact;
                setupPhoto.ICB_Related_Record_Id__c = strRelatedRecord;
                database.insert(setupPhoto);
            }  
        } catch (Exception e)
        {
            System.debug(Label.ICB_ERROR_MESSAGE + ' ' + e.getCause() + e.getMessage() + e.getLineNumber());
        }
        System.debug('Exiting <changePhoto>');
    }
}