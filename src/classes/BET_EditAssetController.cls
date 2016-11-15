/**********************************************************************
Name: BET_EditAssetController 
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Class for editing asset propose
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             22/12/2014      INITIAL DEVELOPMENT
1.1 -   Blessy Voola            28 Apr 2015   T0- Move BET to final release if a key visual and BET presentation is uploaded and approved irrespective of their order of uploading.
**********************************************************************/
public with sharing class BET_EditAssetController {
    @TestVisible private Integer throwUTException;
    public uw_BET__C bet{get;set;}
    public uw_Asset__c file {get; set;}
    public String parentId{get;set;}

    public Boolean displayForm{get;set;}
    public Boolean runJsSuccess{get;set;}
    public Boolean isPresentationUploaded{get;set;}
    public String message{get;set;}
    public Boolean hasModifyAccess {get; protected set;}

    private final SObject parent;
    
    PageReference pageRef = null;

    /*******************************************************************
    Purpose: Constructior
    ********************************************************************/
    public BET_EditAssetController(Apexpages.Standardcontroller sc)
    {
        throwUTException = 0;
        runJsSuccess = false;
        Id assetId = sc.getId();
        
        displayForm = false;            
        if (assetId != null) {
            file = [SELECT Name, Sub_Function__c, Studio_Asset_Type__c, Media_Type__c, Country__c, Status__c, Is_bucket_field__c, Id, uw_BET__c, Related_Feed_Item__c FROM uw_Asset__c WHERE Id =: assetId LIMIT 1];
            if (file != null) {
                displayForm = true;
                pepareForm();
            }
        }
    }

    /*******************************************************************
    Purpose: Prepare data based on info if user has access to modify BET or not
    ********************************************************************/
    private void pepareForm(){
        bet = [SELECT Presentation_Id__c, Status__c FROM uw_BET__c WHERE id =: file.uw_BET__c LIMIT 1];
        hasModifyAccess = BET_CommonService.canModify(bet.Id);

        if(hasModifyAccess){
            file.Sub_Function__c = 'Brand Development';
        }else{
            file.Sub_Function__c = 'Brand Building';
            file.Status__c = 'Shared';
        }
    } 
    /*T0-Begin*/  
    /*******************************************************************
    Purpose: Method to check if key visual file is uploaded and approved.
    Returns: Boolean
    Author: Blessy Voola
    ********************************************************************/
    public boolean isVisualApproved()
    {
    List<uw_Asset__c> fl=  [SELECT Name, Sub_Function__c, Studio_Asset_Type__c, Media_Type__c, Country__c, Status__c, Is_bucket_field__c, Id, uw_BET__c, Related_Feed_Item__c FROM uw_Asset__c WHERE uw_bet__c =: file.uw_BET__c];
              for(uw_Asset__c flist:fl)
              {
              if(flist.Media_Type__c == 'Key Visual'&&flist.Status__c == 'Approved')
              return true;
              }
              return false;
    }
        /*T0-End*/
    
    /*******************************************************************
    Purpose: Updates metadata for asset
    Returns: PageReference
    ********************************************************************/
    public PageReference updateMetadata(){     
        runJsSuccess = false;
        isPresentationUploaded = false;
        message = '';

        List<String> errorResult = validateData();
        if (errorResult.size()>0){
            for(string error : errorResult){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, + error ));
            }
            return null;
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
                    updateBet = true;
                    message = 'Your BET is now in Final Release';
                }
             
            }
        }  

        Id caId;
        if (Test.isRunningTest()) {
            caId = Id.valueOf('069000000000001');
        } else {
            ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.getFeedItem(null, file.Related_Feed_Item__c);      
            ConnectApi.ContentAttachment ca = (ConnectApi.ContentAttachment) fi.attachment;
            caId = ca.Id;
        }
        if(file.Studio_Asset_Type__c == 'Brand Experience Presentation'){
            file.Think_Big_Promotion_Date__c = Datetime.now();
            file.Big_Think_Pack__c = true;
            if (bet.Presentation_Id__c != caId) {
                bet.Presentation_Id__c = caId;
                updateBet = true;
            }
            file.Media_Type__c = 'BET Presentation';
            isPresentationUploaded = true;
        }else{
            if (bet.Presentation_Id__c == caId) {
                bet.Presentation_Id__c = null;
                updateBet = true;
                isPresentationUploaded = true;
            }
        }

        Savepoint sp = Database.setSavepoint();
        try {
            if (Test.isRunningTest() && throwUTException == 1) {
                file.Agency__c = 'A01123456789012';
            }
            update file;
            if (updateBet) {
                BET_CommonService.updateBET(bet);
            }
        } catch (Exception e) {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));  
            return null;
        }

        runJsSuccess = true;

        return null;           
    }

    /*******************************************************************
    Purpose: Validate data given from frontend
    Returns: List<String>
    ********************************************************************/
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