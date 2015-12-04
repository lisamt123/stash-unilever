@istest
private class BET_EditAssetController1_Test {

	private static final String RESULT_NOT_NULL = 'Result should not be null';
    private static final String RESULT_NULL = 'Result should be null';
    private static final String ERROR_MESSAGE_MATCH = 'Error message should match';
    private static final String ONE_RECORD = 'There should be one record';
    private static final String BLANK_MESSAGE = 'Message should be blank';
    private static final String MOD_ACCESS = 'User should have mod access';
    private static final String JS_FLAG_SET = 'Run JS flag should be set';
    private static final String FORM_DISPLAYED = 'Form should be displayed';
    private static final String BET_ID_MATCH = 'Bet is should match';
    private static final String STATUS_MATCH = 'Status should match';

	private static BET_TestingHelper.BET_TestingData prepareData() {
        return prepareData(false, BET_TestingHelper.BET_STATUS_UNRELEASED);
    }

    private static BET_TestingHelper.BET_TestingData prepareData(Boolean addMember) {
        return prepareData(addMember, BET_TestingHelper.BET_STATUS_UNRELEASED);
    }

    private static BET_TestingHelper.BET_TestingData prepareData(Boolean addMember, String status) {
        BET_TestingHelper.BET_TestingData betWrapper = BET_TestingHelper.initBET(
            BET_TestingHelper.getDefaultOwner(), 'UT_BET', status, true, true);
        uw_Asset__c asset = betWrapper.addCreativeWork('creative-work.pdf', BET_TestingHelper.ASSET_STATUS_DRAFT);

        if (addMember) {
            betWrapper.addMember();
        }

        System.Test.setCurrentPageReference(Page.BET_EditAsset);
        return betWrapper;
	}

    static testMethod void validateDataBBInvalidMediaType(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        BET_EditAssetController controller;
        List<String> result;
        
        Test.startTest();
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BB;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION;
            result = controller.validateData();            
        }         
        Test.stopTest();

        System.assertNotEquals(null, result,RESULT_NOT_NULL);
        System.assertEquals(1, result.size(),ONE_RECORD);
        System.assertEquals('Media Type cannot be Brand Experience Presentation.', result[0],ERROR_MESSAGE_MATCH);
    }  

    static testMethod void validateDataBBEmptyCountry(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        BET_EditAssetController controller;
        List<String> result;
        
        Test.startTest();
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BB;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.file.Country__c           = null;
            result = controller.validateData();            
        }
        Test.stopTest();         

        System.assertNotEquals(null, result,RESULT_NOT_NULL);
        System.assertEquals(1, result.size(),ONE_RECORD);
        System.assertEquals('Country cannot be empty.', result[0],ERROR_MESSAGE_MATCH);
    }  

    static testMethod void validateDataBBNotAllowed(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        BET_EditAssetController controller;
        List<String> result;
        
        Test.startTest();
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BB;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            result = controller.validateData();            
        }         
        Test.stopTest();

        System.assertNotEquals(null, result,RESULT_NOT_NULL);
        System.assertEquals(1, result.size(),ONE_RECORD);
        System.assertEquals('Not allowed to add Brand Building.', result[0],ERROR_MESSAGE_MATCH);
    }

    static testMethod void updateMetadataBBEmptyCountry(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        BET_EditAssetController controller;
        PageReference result;
        
        Test.startTest();
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BB;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.file.Country__c           = null;
            result = controller.updateMetadata();            
        }         
        Test.stopTest();

        System.assertEquals(null, result,RESULT_NULL);
        System.assert(BET_TestingHelper.checkifPageMessageExists(
            'Country cannot be empty.',
            ApexPages.Severity.ERROR
        ),'Message should exist');
    }  

    static testMethod void updateToApprovedPresentationAsOwner(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        BET_EditAssetController controller;
        
        Test.startTest();
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            System.assert(String.isBlank(controller.message),BLANK_MESSAGE);
            System.assertEquals(true, controller.displayForm,FORM_DISPLAYED);
            System.assertEquals(betWrapper.BET.Id, controller.bet.Id,BET_ID_MATCH);
            
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_APPROVED;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_PRESENTATION;
            controller.updateMetadata();            
        }         
        Test.stopTest();

        System.assertEquals(BET_TestingHelper.ASSET_SUBFUNCTION_BD, controller.file.Sub_Function__c,'Subfunction should match');
        System.assertEquals(true, controller.hasModifyAccess,MOD_ACCESS);
        System.assertEquals(true, controller.runJsSuccess,JS_FLAG_SET);
        System.assertEquals('Your BET is now in First Release', controller.message,'Message should be : Your BET is now in First Release');
        System.assertEquals(true, controller.isPresentationUploaded,'Presentations should be uploaded');
        System.assertEquals(BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION, controller.file.Media_Type__c,'Media Type should match');

        uw_BET__c updatedBET = BET_TestingHelper.getBET(betWrapper.BET.Id);
        System.assertNotEquals(betWrapper.BET.Presentation_Id__c, updatedBET.Presentation_Id__c,'Presentations id should be different');
        System.assertEquals(BET_TestingHelper.BET_STATUS_FIRSTRELEASE, updatedBET.Status__c,STATUS_MATCH);
    }
    static testMethod void updateToApprovedCreativeWorkAsOwner(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(false, BET_TestingHelper.BET_STATUS_FIRSTRELEASE);

        BET_EditAssetController controller;
        
        Test.startTest();
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            System.assert(String.isBlank(controller.message),BLANK_MESSAGE);
            System.assertEquals(true, controller.displayForm,FORM_DISPLAYED);
            System.assertEquals(betWrapper.BET.Id, controller.bet.Id,BET_ID_MATCH);
            
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_APPROVED;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.updateMetadata();            
        }         
        Test.stopTest();

        System.assertEquals(BET_TestingHelper.ASSET_SUBFUNCTION_BD, controller.file.Sub_Function__c,'Sub function should match');
        System.assertEquals(true, controller.hasModifyAccess,MOD_ACCESS);
        System.assertEquals(true, controller.runJsSuccess,JS_FLAG_SET);
        System.assertEquals('Your BET is now in Final Release', controller.message,'Message should be equal to : Your BET is now in Final Release');
        System.assertEquals(false, controller.isPresentationUploaded,'Presentations should not be uploaded');

        uw_BET__c updatedBET = BET_TestingHelper.getBET(betWrapper.BET.Id);
        System.assertEquals(betWrapper.BET.Presentation_Id__c, updatedBET.Presentation_Id__c,'Presentations ids should match');
        System.assertEquals(BET_TestingHelper.BET_STATUS_FINALRELEASE, updatedBET.Status__c,STATUS_MATCH);
    }
    static testMethod void changePresentationToCreativeWorkAsOwner(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();
        betWrapper.addPresentation('Presentation.ppt', BET_TestingHelper.ASSET_STATUS_DRAFT);
        betWrapper.BET.Presentation_Id__c = '069000000000001';
        update betWrapper.BET;

        BET_EditAssetController controller;
        
        Test.startTest();
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            System.assert(String.isBlank(controller.message),BLANK_MESSAGE);
            System.assertEquals(true, controller.displayForm,FORM_DISPLAYED);
            System.assertEquals(betWrapper.BET.Id, controller.bet.Id,BET_ID_MATCH);
            
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_APPROVED;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.updateMetadata();            
        }      
        Test.stopTest();   

        System.assertEquals(BET_TestingHelper.ASSET_SUBFUNCTION_BD, controller.file.Sub_Function__c,'Sub function should match');
        System.assertEquals(true, controller.hasModifyAccess, MOD_ACCESS);
        System.assertEquals(true, controller.runJsSuccess,JS_FLAG_SET);
        System.assertEquals('', controller.message,'Message should be empty');
        System.assertEquals(true, controller.isPresentationUploaded,'Presentations should be uploaded');

        uw_BET__c updatedBET = BET_TestingHelper.getBET(betWrapper.BET.Id);
        System.assertEquals(null, updatedBET.Presentation_Id__c,RESULT_NULL);
    }
    static testMethod void handleDMLException(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(false, BET_TestingHelper.BET_STATUS_FIRSTRELEASE);

        BET_EditAssetController controller;
        
        Test.startTest();
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            System.assert(String.isBlank(controller.message),BLANK_MESSAGE);
            System.assertEquals(true, controller.displayForm,FORM_DISPLAYED);
            System.assertEquals(betWrapper.BET.Id, controller.bet.Id,BET_ID_MATCH);
            
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_APPROVED;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.throwUTException          = 1;
            controller.updateMetadata();            
        }   
        Test.stopTest();      

        System.assertEquals(false, controller.runJsSuccess,'Run JS flag should not be set');
        System.assertEquals(false, controller.isPresentationUploaded,'Presentations should not be uploaded');

        System.assert(BET_TestingHelper.checkIfAnyPageMessageExists(ApexPages.Severity.ERROR),'There should be some page messages');

        uw_BET__c updatedBET = BET_TestingHelper.getBET(betWrapper.BET.Id);
        System.assertEquals(betWrapper.BET.Presentation_Id__c, updatedBET.Presentation_Id__c,'Presentation id should match');
        System.assertEquals(BET_TestingHelper.BET_STATUS_FIRSTRELEASE, updatedBET.Status__c,STATUS_MATCH);
    }
}