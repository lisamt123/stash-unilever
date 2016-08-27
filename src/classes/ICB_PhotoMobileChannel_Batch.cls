/**********************************************************************
Name: ICB_PhotoMobileChannel_Batch
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Class for set photo in user based in post of feedItem.
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.1    Antonio Raul 25/08/2016  Class Updated  
 1.0    Thiago Oliveira 24/08/2016  Class creation  
***********************************************************************/
global with sharing class ICB_PhotoMobileChannel_Batch implements DataBase.Batchable<Sobject> 
{
    
    private static List<String> idRecord;
    private static List<String> idParent;
    private static List<String> idFeed;
    private static Map<Id,user> userMap;
    private static Map<Id,ICB_Setup_Photo__c> idsSetup;
    
    Static
    {
        idRecord = new List<String>();
        idParent = new List<String>();
        idFeed = new List<String>();
        userMap = new Map<Id,user>();
        idsSetup = new Map<Id,ICB_Setup_Photo__c>();
    }

    /*******************************************************************
    Purpose: This method execute the query in Event object.
    Parameters: [Database.Batchablecontext]
    Returns: [Database.Querylocator]
    Throws [Exceptions]: [NONE]
    ********************************************************************/
    global Database.Querylocator start(Database.BatchableContext bc) 
    {
        system.debug('Entering <start>');
        String query =  'SELECT  Id,'+
            					'ICB_Parent_Id__c,'+
            					'ICB_Related_Record_Id__c'+
            			' FROM ICB_Setup_Photo__c';
        system.debug('Exiting <start>: ' + Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }
    /*******************************************************************
     Purpose: This method set the photo in user based in feedItem contact post.
     Parameters: [Database.Batchablecontext, List<sObject> ]
     Returns: [VOID]
     Throws [Exceptions]: [Exception]
     ********************************************************************/
    global void execute(Database.BatchableContext BC, List<ICB_Setup_Photo__c> scope)
    {
        system.debug('Entering <execute>: ' + scope);
        
        try
        {
            setVariables(scope);
            for(ContentVersion cont : [Select Id, ContentDocumentId From ContentVersion Where Id IN: idRecord])
            {
                if(userMap.get(idsSetup.get(cont.Id).ICB_Parent_Id__c) != null)
                {
                    ConnectApi.PhotoInput imageProfile = new  ConnectApi.PhotoInput();
                    imageProfile.cropSize 	= 10;
                    imageProfile.cropX 		= 10;
                    imageProfile.cropY 		= 10;
                    imageProfile.fileId 	= cont.ContentDocumentId; 
                    ConnectApi.Photo photo = ConnectApi.UserProfiles.setPhotoWithAttributes(null, userMap.get(idsSetup.get(cont.Id).ICB_Parent_Id__c).Id, imageProfile); 
                }
            }
            
            Database.delete([Select Id From ICB_Setup_Photo__c Where ICB_Parent_Id__c IN: idParent]); 
        }
        catch(Exception e)
        {
            System.debug(Label.ICB_ERROR_MESSAGE + ' ' + e.getCause() +	' ' +e.getMessage() +' ' + e.getLineNumber());
        }
        
        system.debug('Exiting <execute>: ');
    }
    
    global void finish(Database.BatchableContext BC){}
    
    /*******************************************************************
     Purpose: This method set variables for using in batch.
     Parameters: [List<ICB_Setup_Photo__c>]
     Returns: [VOID]
     Throws [Exceptions]: [NONE]
     ********************************************************************/
    private static void setVariables(List<ICB_Setup_Photo__c> scope)
    {
        system.debug('Entering <setVariables>: ' + scope);
        for(ICB_Setup_Photo__c SetUpPhoto: scope)
        {
            idRecord.add(SetUpPhoto.ICB_Related_Record_Id__c);
            idParent.add(SetUpPhoto.ICB_Parent_Id__c);
            idsSetup.put(SetUpPhoto.ICB_Related_Record_Id__c, SetUpPhoto);
        }
        
        for(User user : [Select Id,ContactId From User Where ContactId =: idParent])
        {
            userMap.put(user.ContactId, user);
        }
        system.debug('Exiting <setVariables>: ');
    }
}