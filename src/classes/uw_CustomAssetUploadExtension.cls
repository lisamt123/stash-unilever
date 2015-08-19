/**********************************************************************
Name: uw_CustomAssetUploadExtension 
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Class for handling customer publisher action
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             22/12/2014      INITIAL DEVELOPMENT
1.1 -   Blessy Voola            28 Apr 2015   T0- Move BET to final release if a key visual and BET presentation is uploaded and approved irrespective of their order of uploading.
**********************************************************************/

public with sharing class uw_CustomAssetUploadExtension {
    @TestVisible private Integer throwUTException;
    public uw_BET__C bet{get;set;}
    public uw_Asset__c file {get; set;}
    public String parentId{get;set;}

    public Boolean displayForm{get;set;}
    public Boolean runJsSuccess{get;set;}
    public Boolean isPresentationUploaded{get;set;}
    public String message{get;set;}
    public String errorMessage{get; protected set;}    
    public Boolean hasModifyAccess {get; protected set;}

    private final SObject parent;
    private String feedid = '';    
    
    PageReference pageRef = null;

    public void setFeedid(String n) {
        feedid = n;
    }
    
    public String getFeedid() {
        return feedid;
    }
            
    /*****************************************************************************************
    Purpose: Check if customer publisher action should be shown in chatter 
    ******************************************************************************************/ 
    public void checkfeed(){
        errorMessage = '';
        if (parentId != null && parentId.startsWith( CollaborationGroup.sObjectType.getDescribe().getKeyPrefix()) ){
            parentId = String.valueOf(Id.valueOf(parentId));
            List<uw_BET__C> betList = [SELECT Id, Status__c, Presentation_Id__c FROM uw_BET__C WHERE Studio_Chatter_Group__c = :parentId LIMIT 1];
            if(betList.size() > 0){
                list<CollaborationGroup> chatterGroups = [SELECT IsArchived FROM CollaborationGroup WHERE Id =: parentId];
                if (chatterGroups.isEmpty()) {
                    errorMessage = 'You don\'t have access to this group.';
                    displayForm = false;
                } else if (chatterGroups[0].IsArchived) {
                    errorMessage = 'This chatter group has been archived. Please contact your group owner/manager for reactivation.';
                    displayForm = false;
                }else {
                    bet = betList[0];
                    file.uw_BET__c = bet.Id;
                    displayForm = true;
                    pepareForm();
                }
            }else{
                displayForm = false;
                errorMessage = 'Sorry, but this page can be opened only on BET context.';
            }            
        }else{
            displayForm = false;
            errorMessage = 'Sorry, but this page can be opened only on BET context.';
        }
    }

    /*****************************************************************************************
    Purpose: Called to set correct values while init depends on is user can modify BET 
    ******************************************************************************************/ 
    private void pepareForm(){
        hasModifyAccess = BET_CommonService.canModify(bet.Id);

        if(hasModifyAccess){
            file.Sub_Function__c = 'Brand Development';
        }else{
            file.Sub_Function__c = 'Brand Building';
            file.Status__c = 'Shared';
        }
    }
    
    /*****************************************************************************************
    Purpose: Constructor 
    ******************************************************************************************/ 
    public uw_CustomAssetUploadExtension() {
        throwUTException = 0;
        pageRef = ApexPages.currentPage();
        parentId = ApexPages.currentPage().getParameters().get('id');

        runJsSuccess = false;
        isPresentationUploaded = false;
        message = '';

        file = new uw_Asset__c();
    }   
    
     /*T0-Begin*/  
    /*******************************************************************
    Purpose: Method to check if key visual file is uploaded and approved.
    Returns: Boolean
    Author: Blessy Voola
    ********************************************************************/
    public boolean isVisualApproved()
    {
    List<uw_Asset__c> fl=  [SELECT Name, Is_bucket_field__c, Id, uw_BET__c, Related_Feed_Item__c FROM uw_Asset__c WHERE uw_bet__c =: file.uw_BET__c];
              for(uw_Asset__c flist:fl)
              {
              if(flist.Media_Type__c == 'Key Visual'&&flist.Status__c == 'Approved')
              return true;
              }
              return false;
    }
        /*T0-End*/
        
    /*****************************************************************************************
    Purpose: Saves matadata of file, create relation between feed and asset 
    ******************************************************************************************/ 
    public PageReference saveFileAndConnect(){     
        runJsSuccess = false;
        isPresentationUploaded = false;
        Boolean brandExperiencePresnetationIsThere = false;
        message = '';
        System.debug('__________________________'+feedid );
        
        List<FeedItem> chatterContentPostList = [SELECT Id, RelatedRecordId, ContentDescription, Type, ContentFileName FROM FeedItem WHERE Id = :feedid LIMIT 1];
        if ( chatterContentPostList.size() == 0 ) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No file uploaded.')); 
           return null;
        }

        List<String> errorResult = validateData();
        if (errorResult.size()>0){
            for(string error : errorResult){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, + error ));
            }
            //delete feed
            delete chatterContentPostList[0];
            return null;
        }  

        FeedItem chatterContentPost = chatterContentPostList[0];   
        file.Related_Feed_Item__c = chatterContentPost.Id;        
        ConnectApi.FeedItem fi;
        ConnectApi.ContentAttachment ca;
        //We cannot use Connect API in UT for objects created by test classes
        if (Test.isRunningTest()) {
            file.URL_of_Asset__c = BET_TestingHelper.UT_ASSETDOWNLOADLINK;
            file.thumbnail__c = BET_TestingHelper.UT_ASSETTHUMBLINK;
        } else {
            fi = ConnectApi.ChatterFeeds.getFeedItem(null, file.Related_Feed_Item__c);      
            ca = (ConnectApi.ContentAttachment) fi.attachment;
            file.URL_of_Asset__c = ca.downloadUrl;
            file.thumbnail__c = ca.renditionUrl;
        }
        Boolean updateBet = false;
        if(file.Sub_Function__c == 'Brand Development' && file.Status__c == 'Approved'){
            if( file.Studio_Asset_Type__c == 'Brand Experience Presentation'){
                if(bet.Status__c != 'Final release' && bet.Status__c != 'First release'){
                 /*T0-Begin*/
                if(isVisualApproved()){
                             bet.Status__c = 'Final release';
                             updateBet=true;
                              message = 'Your BET is now in Final Release';
                     }
                    
                else{
                    bet.Status__c = 'First release';
                    updateBet = true;
                    message = 'Your BET is now in First Release';
                    }
                }
                
               /*T0-End*/      
                   
                
            }else if(file.Studio_Asset_Type__c == 'Creative Work'){

                if(file.Media_Type__c == 'Key Visual' && bet.Status__c == 'First release'){
                    bet.Status__c = 'Final release';
                    message = 'Your BET is now in Final Release';
                    updateBet = true;
                }

                if(file.Media_Type__c == 'Key Visual' && file.Status__c == 'Approved'){ // IPM-BET US43
                    brandExperiencePresnetationIsThere = ![select Media_Type__c,Status__c,Studio_Asset_Type__c from uw_Asset__c 
                                                          where Studio_Asset_Type__c = 'Brand Experience Presentation'
                                                          and Status__c = 'Approved'
                                                          and uw_bet__c =: file.uw_BET__c].isEmpty();
                    if(brandExperiencePresnetationIsThere) {
                        bet.FinalReleaseDate__c = date.today();
                        updateBet = true;
                    }
                }

            }
        }

        //@todo: how to determine if it's main presentation or not
        if(file.Studio_Asset_Type__c == 'Brand Experience Presentation'){

            if(file.Status__c == 'Approved'){ // IPM-BET US43
                bet.FirstReleaseDate__c = date.today();

                Boolean keyVisualIsThere = ![select Media_Type__c,Status__c,Studio_Asset_Type__c from uw_Asset__c 
                                                          where Studio_Asset_Type__c = 'Creative Work'
                                                          and Media_Type__c = 'Key Visual'
                                                          and Status__c = 'Approved'
                                                          and uw_bet__c =: file.uw_BET__c].isEmpty();
                if(keyVisualIsThere){
                    bet.FinalReleaseDate__c = date.today();
                }
            }

            file.Think_Big_Promotion_Date__c = Datetime.now();
            file.Big_Think_Pack__c = true;
            file.Media_Type__c = 'BET Presentation';
            if (Test.isRunningTest()) {
                bet.Presentation_Id__c = BET_TestingHelper.UT_PRESENTATIONID;
            } else {
                bet.Presentation_Id__c = ca.id;
            }
            updateBet = true;
            isPresentationUploaded = true;
        }

        if (String.isEmpty(file.Name)) {
            file.Name = chatterContentPost.ContentFileName;
        }
        Savepoint sp = Database.setSavepoint();
        try {
            if (Test.isRunningTest() && throwUTException == 1) {
                file.Agency__c = 'A01123456789012';
            } 
            insert file;
            if (Test.isRunningTest() && throwUTException == 2) {
                BET.Inoplan_Project__c = 'A01123456789012';
            } 
            if (updateBet) {
                BET_CommonService.updateBET(bet);
            }
        } catch (Exception e) {
            Database.rollback(sp);
            //delete feed
            delete chatterContentPostList[0];

            if (file.Id != null) {
                //required if error occured
                uw_Asset__c assetTmp = new uw_Asset__c();
                assetTmp.Name = file.Name;
                assetTmp.Sub_Function__c = file.Sub_Function__c;
                assetTmp.Studio_Asset_Type__c = file.Studio_Asset_Type__c;
                assetTmp.Media_Type__c = file.Media_Type__c;
                assetTmp.Country__c = file.Country__c;
                assetTmp.Status__c = file.Status__c;
                assetTmp.Think_Big_Promotion_Date__c = file.Think_Big_Promotion_Date__c;
                assetTmp.Big_Think_Pack__c = file.Big_Think_Pack__c;
                assetTmp.uw_BET__c = file.uw_BET__c;
                file = assetTmp;
            }

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));  
            return null;
        }


        runJsSuccess = true;
        file = new uw_Asset__c();
        checkfeed();                
        return null;           
    }

    /*****************************************************************************************
    Purpose: validate data provided in frontend 
    ******************************************************************************************/ 
    public List<String> validateData(){
        List<String> errorList = new List<String>();

        if( file.Sub_Function__c == null || file.Sub_Function__c == ''){
            errorList.add('Sub Function cannot be empty.');
        }else{
            if(file.Sub_Function__c == 'Brand Development'){
                if(! hasModifyAccess){
                    errorList.add('Not allowed to add Brand Development.');
                }

                if(file.Status__c == null || file.Status__c == ''){
                    errorList.add('Status cannot be empty.');
                }

                if(file.Studio_Asset_Type__c == null || file.Studio_Asset_Type__c == ''){
                    errorList.add('Type cannot be empty.');
                }else{
                    if(file.Studio_Asset_Type__c == 'Creative Work'){
                        if(file.Media_Type__c == null || file.Media_Type__c == ''){
                            errorList.add('Media Type cannot be empty.');
                        }

                        if(file.Media_Type__c != null && file.Media_Type__c == 'BET Presentation'){
                            errorList.add('Media Type cannot be Brand Experience Presentation.');
                        }

                        if(file.Country__c == null || file.Country__c == ''){
                            errorList.add('Country cannot be empty.');
                        }
                    }else{
                        file.Country__c = null;
                        file.Media_Type__c = null;
                    }            
                }
            }else{
                if(hasModifyAccess){
                    errorList.add('Not allowed to add Brand Building.');
                }

                file.Studio_Asset_Type__c = null;
                //members should only upload shared documents
                file.Status__c = 'Shared';
         
                if(file.Media_Type__c == null || file.Media_Type__c == ''){
                    errorList.add('Media Type cannot be empty.');
                }

                if(file.Media_Type__c != null && file.Media_Type__c == 'BET Presentation'){
                    errorList.add('Media Type cannot be Brand Experience Presentation.');
                }

                if(file.Country__c == null || file.Country__c == ''){
                    errorList.add('Country cannot be empty.');
                } 
            }
        }
        return errorList;
    }
}