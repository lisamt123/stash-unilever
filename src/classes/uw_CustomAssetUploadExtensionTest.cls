@isTest
private class uw_CustomAssetUploadExtensionTest {
    private static BET_TestingHelper.BET_TestingData prepareData() {
        return prepareData(false, BET_TestingHelper.BET_STATUS_UNRELEASED);
    }

    private static BET_TestingHelper.BET_TestingData prepareData(Boolean addMember) {
        return prepareData(addMember, BET_TestingHelper.BET_STATUS_UNRELEASED);
    }

    private static BET_TestingHelper.BET_TestingData prepareData(Boolean addMember, String status) {
        BET_TestingHelper.BET_TestingData betWrapper = BET_TestingHelper.initBET(
            BET_TestingHelper.getDefaultOwner(), 'UT_BET', status, true, true);

        if (addMember) {
            betWrapper.addMember();
        }

        Id parentId = betWrapper.BET.Studio_Chatter_Group__c; 
            
        System.Test.setCurrentPageReference(Page.uw_CustomAssetUpload);
        System.currentPageReference().getParameters().put('id', parentId);

        return betWrapper; 
    }

    static testMethod void uploadDraftPresentationAsOwner(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        uw_CustomAssetUploadExtension controller;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed(); 
            System.assertEquals('', controller.errorMessage);
            System.assertEquals(true, controller.displayForm);
            System.assertEquals(betWrapper.BET.Id, controller.bet.Id);

            //add file to chatter. page is using salesforce ajax toolkit
            betWrapper.addUnlabelledFile('new file.pdf');
            controller.setFeedid(betWrapper.unlabelledFeedItem.Id);
            
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_DRAFT;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_PRESENTATION;
            controller.saveFileAndConnect();            
        }         

        System.assertEquals(BET_TestingHelper.ASSET_SUBFUNCTION_BD, controller.file.Sub_Function__c);
        System.assertEquals(true, controller.hasModifyAccess);
        System.assertEquals(true, controller.runJsSuccess);
        System.assertEquals('', controller.message);
        System.assertEquals(true, controller.isPresentationUploaded);

        uw_BET__c updatedBET = BET_TestingHelper.getBET(betWrapper.BET.Id);
        System.assertNotEquals(betWrapper.BET.Presentation_Id__c, updatedBET.Presentation_Id__c);
        System.assertEquals(betWrapper.BET.Status__c, updatedBET.Status__c);
    }   

    static testMethod void uploadApprovedPresentationAsOwner(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        uw_CustomAssetUploadExtension controller;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed(); 
            System.assertEquals('', controller.errorMessage);
            System.assertEquals(true, controller.displayForm);
            System.assertEquals(betWrapper.BET.Id, controller.bet.Id);

            //add file to chatter. page is using salesforce ajax toolkit
            betWrapper.addUnlabelledFile('new file.pdf');
            controller.setFeedid(betWrapper.unlabelledFeedItem.Id);
            
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_APPROVED;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_PRESENTATION;
            controller.saveFileAndConnect();            
        }         

        System.assertEquals(BET_TestingHelper.ASSET_SUBFUNCTION_BD, controller.file.Sub_Function__c);
        System.assertEquals(true, controller.hasModifyAccess);
        System.assertEquals(true, controller.runJsSuccess);
        System.assertEquals('Your BET is now in First Release', controller.message);
        System.assertEquals(true, controller.isPresentationUploaded);

        uw_BET__c updatedBET = BET_TestingHelper.getBET(betWrapper.BET.Id);
        System.assertNotEquals(betWrapper.BET.Presentation_Id__c, updatedBET.Presentation_Id__c);
        System.assertEquals(BET_TestingHelper.BET_STATUS_FIRSTRELEASE, updatedBET.Status__c);
    }

    static testMethod void uploadDraftCreativeWorkAsOwner(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(false, BET_TestingHelper.BET_STATUS_FIRSTRELEASE);

        uw_CustomAssetUploadExtension controller;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed(); 
            System.assertEquals('', controller.errorMessage);
            System.assertEquals(true, controller.displayForm);
            System.assertEquals(betWrapper.BET.Id, controller.bet.Id);

            //add file to chatter. page is using salesforce ajax toolkit
            betWrapper.addUnlabelledFile('new file.pdf');
            controller.setFeedid(betWrapper.unlabelledFeedItem.Id);
            
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_DRAFT;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            controller.saveFileAndConnect();            
        }         

        System.assertEquals(BET_TestingHelper.ASSET_SUBFUNCTION_BD, controller.file.Sub_Function__c);
        System.assertEquals(true, controller.hasModifyAccess);
        System.assertEquals(true, controller.runJsSuccess);
        System.assertEquals('', controller.message);
        System.assertEquals(false, controller.isPresentationUploaded);

        uw_BET__c updatedBET = BET_TestingHelper.getBET(betWrapper.BET.Id);
        System.assertEquals(betWrapper.BET.Presentation_Id__c, updatedBET.Presentation_Id__c);
        System.assertEquals(BET_TestingHelper.BET_STATUS_FIRSTRELEASE, updatedBET.Status__c);
    }   

    static testMethod void uploadApprovedCreativeWorkAsOwner(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(false, BET_TestingHelper.BET_STATUS_FIRSTRELEASE);

        uw_CustomAssetUploadExtension controller;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed(); 
            System.assertEquals('', controller.errorMessage);
            System.assertEquals(true, controller.displayForm);
            System.assertEquals(betWrapper.BET.Id, controller.bet.Id);

            //add file to chatter. page is using salesforce ajax toolkit
            betWrapper.addUnlabelledFile('new file.pdf');
            controller.setFeedid(betWrapper.unlabelledFeedItem.Id);
            
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_APPROVED;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            controller.saveFileAndConnect();            
        }         

        System.assertEquals(BET_TestingHelper.ASSET_SUBFUNCTION_BD, controller.file.Sub_Function__c);
        System.assertEquals(true, controller.hasModifyAccess);
        System.assertEquals(true, controller.runJsSuccess);
        System.assertEquals('Your BET is now in Final Release', controller.message);
        System.assertEquals(false, controller.isPresentationUploaded);

        uw_BET__c updatedBET = BET_TestingHelper.getBET(betWrapper.BET.Id);
        System.assertEquals(betWrapper.BET.Presentation_Id__c, updatedBET.Presentation_Id__c);
        System.assertEquals(BET_TestingHelper.BET_STATUS_FINALRELEASE, updatedBET.Status__c);
    }   

    static testMethod void uploadAssetAsMember(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        uw_CustomAssetUploadExtension controller;
        
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed(); 
            System.assertEquals('', controller.errorMessage);
            System.assertEquals(true, controller.displayForm);
            System.assertEquals(betWrapper.BET.Id, controller.bet.Id);

            //add file to chatter. page is using salesforce ajax toolkit
            betWrapper.addUnlabelledFile('new file.pdf');
            controller.setFeedid(betWrapper.unlabelledFeedItem.Id);
            
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            controller.saveFileAndConnect();            
        }         

        System.assertEquals(BET_TestingHelper.ASSET_SUBFUNCTION_BB, controller.file.Sub_Function__c);
        System.assertEquals(BET_TestingHelper.ASSET_STATUS_SHARED, controller.file.Status__c);
        System.assertEquals(false, controller.hasModifyAccess);
        System.assertEquals(true, controller.runJsSuccess);
        System.assertEquals('', controller.message);
        System.assertEquals(false, controller.isPresentationUploaded);

        uw_BET__c updatedBET = BET_TestingHelper.getBET(betWrapper.BET.Id);
        System.assertEquals(betWrapper.BET.Presentation_Id__c, updatedBET.Presentation_Id__c);
        System.assertEquals(BET_TestingHelper.BET_STATUS_UNRELEASED, updatedBET.Status__c);
    }   

    static testMethod void checkFeedEmptyParentId(){
        System.Test.setCurrentPageReference(Page.uw_CustomAssetUpload);

        uw_CustomAssetUploadExtension controller;
        
        controller = new uw_CustomAssetUploadExtension();
        controller.checkfeed(); 

        System.assertEquals('Sorry, but this page can be opened only on BET context.', controller.errorMessage);
        System.assertEquals(false, controller.displayForm);
    }
    
    static testMethod void checkFeedInvalidIdPrefix(){
        System.Test.setCurrentPageReference(Page.uw_CustomAssetUpload);
        System.currentPageReference().getParameters().put('id', 'a01123456123123');

        uw_CustomAssetUploadExtension controller;
        
        controller = new uw_CustomAssetUploadExtension();
        controller.checkfeed(); 

        System.assertEquals('Sorry, but this page can be opened only on BET context.', controller.errorMessage);
        System.assertEquals(false, controller.displayForm);
    }
    
    static testMethod void checkFeedNotExistingId(){
        System.Test.setCurrentPageReference(Page.uw_CustomAssetUpload);
        System.currentPageReference().getParameters().put('id', CollaborationGroup.sObjectType.getDescribe().getKeyPrefix() + '000000000012');

        uw_CustomAssetUploadExtension controller;
        
        controller = new uw_CustomAssetUploadExtension();
        controller.checkfeed(); 

        System.assertEquals('Sorry, but this page can be opened only on BET context.', controller.errorMessage);
        System.assertEquals(false, controller.displayForm);
    }

    static testMethod void checkFeedNotChatterGroupMember(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);
        //remove set chatter group id to invalid id
        betWrapper.BET.Studio_Chatter_Group__c = String.valueOf(Id.valueOf('0F9L00000000001'));
        update betWrapper.BET;

        Id parentId = betWrapper.BET.Studio_Chatter_Group__c; 
        System.currentPageReference().getParameters().put('id', parentId);

        uw_CustomAssetUploadExtension controller;
        
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed(); 
        }

        System.assertEquals('You don\'t have access to this group.', controller.errorMessage);
        System.assertEquals(false, controller.displayForm);
    }
    
    static testMethod void checkFeedGroupIsArchived(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);
        betWrapper.archiveGroup();

        uw_CustomAssetUploadExtension controller;
        
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed(); 
        }

        System.assertEquals('This chatter group has been archived. Please contact your group owner/manager for reactivation.', controller.errorMessage);
        System.assertEquals(false, controller.displayForm);
    }

    static testMethod void saveFileAndConnectMissingFeedItemId(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        uw_CustomAssetUploadExtension controller;
        PageReference result;
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed(); 
            result = controller.saveFileAndConnect();
        }

        System.assertEquals(null, result);
        System.assert(BET_TestingHelper.checkifPageMessageExists(
            'No file uploaded.',
            ApexPages.Severity.ERROR
        ));
    }

   static testMethod void saveFileAndConnectValidationError(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        uw_CustomAssetUploadExtension controller;
        PageReference result;
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed(); 
            //add file to chatter. page is using salesforce ajax toolkit
            betWrapper.addUnlabelledFile('new file.pdf');
            controller.setFeedid(betWrapper.unlabelledFeedItem.Id);
            
            result = controller.saveFileAndConnect();
        }

        System.assertEquals(null, result);
        System.assert(BET_TestingHelper.checkifPageMessageExists(
            'Status cannot be empty.',
            ApexPages.Severity.ERROR
        ));
        System.assertEquals(0, [SELECT COUNT() FROM FeedItem WHERE Id =: betWrapper.unlabelledFeedItem.Id]);
    }

   static testMethod void saveFileAndConnectExceptionOnFileInsert(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        uw_CustomAssetUploadExtension controller;
        PageReference result;
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed(); 
            //add file to chatter. page is using salesforce ajax toolkit
            betWrapper.addUnlabelledFile('new file.pdf');
            controller.setFeedid(betWrapper.unlabelledFeedItem.Id);
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_DRAFT;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_PRESENTATION;
            controller.throwUTException = 1;

            result = controller.saveFileAndConnect();
        }

        System.assertEquals(null, result);
        System.assertEquals(null, controller.file.Id);
        System.assert(BET_TestingHelper.checkIfAnyPageMessageExists(ApexPages.Severity.ERROR));
        System.assertEquals(0, [SELECT COUNT() FROM FeedItem WHERE Id =: betWrapper.unlabelledFeedItem.Id]);
        uw_BET__c updatedBET = BET_TestingHelper.getBET(betWrapper.BET.Id);
        System.assertEquals(betWrapper.BET.Presentation_Id__c, updatedBET.Presentation_Id__c);
   }

    static testMethod void saveFileAndConnectExceptionOnBETUpdate(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        uw_CustomAssetUploadExtension controller;
        PageReference result;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed(); 
            System.assertEquals('', controller.errorMessage);
            System.assertEquals(true, controller.displayForm);
            System.assertEquals(betWrapper.BET.Id, controller.bet.Id);

            //add file to chatter. page is using salesforce ajax toolkit
            betWrapper.addUnlabelledFile('new file.pdf');
            controller.setFeedid(betWrapper.unlabelledFeedItem.Id);
            
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_DRAFT;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_PRESENTATION;
            controller.throwUTException = 2;
            result = controller.saveFileAndConnect();            
        }         

        System.assertEquals(null, result);
        System.assertEquals(null, controller.file.Id);
        System.assert(BET_TestingHelper.checkIfAnyPageMessageExists(ApexPages.Severity.ERROR));
        System.assertEquals(0, [SELECT COUNT() FROM FeedItem WHERE Id =: betWrapper.unlabelledFeedItem.Id]);
        uw_BET__c updatedBET = BET_TestingHelper.getBET(betWrapper.BET.Id);
        System.assertEquals(betWrapper.BET.Presentation_Id__c, updatedBET.Presentation_Id__c);
    }

    static testMethod void validateDataBDEmptySubFunction(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        uw_CustomAssetUploadExtension controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed(); 
            controller.file.Sub_Function__c = null;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals('Sub Function cannot be empty.', result[0]);
    }
    
    static testMethod void validateDataBDEmptyStatusAndStudioAssetType(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        uw_CustomAssetUploadExtension controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed();
            controller.file.Status__c = null;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals('Status cannot be empty.', result[0]);
    }

    static testMethod void validateDataBDInvalidSubFunctionForUser(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        uw_CustomAssetUploadExtension controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed();
            controller.file.Sub_Function__c = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c = null;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(2, result.size());
        System.assertEquals('Not allowed to add Brand Development.', result[0]);
        System.assertEquals('Status cannot be empty.', result[1]);
    }

    static testMethod void validateDataBDEmptyMediaType(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        uw_CustomAssetUploadExtension controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed();
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_DRAFT;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals('Media Type cannot be empty.', result[0]);
    }

    static testMethod void validateDataBDInvalidInvalidMediaType(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        uw_CustomAssetUploadExtension controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed();
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_DRAFT;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals('Media Type cannot be Brand Experience Presentation.', result[0]);
    }

    static testMethod void validateDataBDEmptyCountry(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        uw_CustomAssetUploadExtension controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed();
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_DRAFT;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals('Country cannot be empty.', result[0]);
    }

    static testMethod void validateDataBDBDClearCountryAndMediaType(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        uw_CustomAssetUploadExtension controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed();
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_DRAFT;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_PRESENTATION;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(0, result.size());
        System.assertEquals(null, controller.file.Media_Type__c );
        System.assertEquals(null, controller.file.Country__c );
    }    

    static testMethod void validateDataBBEnforceStatus(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        uw_CustomAssetUploadExtension controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed();
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BB;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_DRAFT;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_PRESENTATION;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(0, result.size());
        System.assertEquals(BET_TestingHelper.ASSET_STATUS_SHARED, controller.file.Status__c);
        System.assertEquals(null, controller.file.Studio_Asset_Type__c );
    }    

    static testMethod void validateDataBBEmptyMediaType(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        uw_CustomAssetUploadExtension controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed();
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BB;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals('Media Type cannot be empty.', result[0]);
    }  

    static testMethod void validateDataBBInvalidMediaType(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        uw_CustomAssetUploadExtension controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new uw_CustomAssetUploadExtension();
            controller.checkfeed();
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BB;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals('Media Type cannot be Brand Experience Presentation.', result[0]);
    }
}