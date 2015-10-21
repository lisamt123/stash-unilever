@istest
private class BET_EditAssetController_Test {
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

    static testMethod void validateDataBDEmptySubFunction(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        BET_EditAssetController controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c = null;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals('Sub Function cannot be empty.', result[0]);
    }

    static testMethod void validateDataBDEmptyStatusAndStudioAssetType(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        BET_EditAssetController controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Status__c = null;
            controller.file.Studio_Asset_Type__c = null;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(2, result.size());
        System.assertEquals('Status cannot be empty.', result[0]);
        System.assertEquals('Type cannot be empty.', result[1]);
    }

    static testMethod void validateDataBDInvalidSubFunctionForUser(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        BET_EditAssetController controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c = null;
            controller.file.Studio_Asset_Type__c = null;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(3, result.size());
        System.assertEquals('Not allowed to add Brand Development.', result[0]);
        System.assertEquals('Status cannot be empty.', result[1]);
        System.assertEquals('Type cannot be empty.', result[2]);
    }

    static testMethod void validateDataBDEmptyMediaType(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        BET_EditAssetController controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_DRAFT;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            controller.file.Media_Type__c        = null;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals('Media Type cannot be empty.', result[0]);
    }

    static testMethod void validateDataBDInvalidInvalidMediaType(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        BET_EditAssetController controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
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

        BET_EditAssetController controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_DRAFT;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.file.Country__c           = null;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals('Country cannot be empty.', result[0]);
    }

    static testMethod void validateDataBDBDClearCountryAndMediaType(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        BET_EditAssetController controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
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

        BET_EditAssetController controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
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

        BET_EditAssetController controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BB;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            controller.file.Media_Type__c        = null;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals('Media Type cannot be empty.', result[0]);
    }  

    static testMethod void validateDataBBInvalidMediaType(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        BET_EditAssetController controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BB;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals('Media Type cannot be Brand Experience Presentation.', result[0]);
    }  

    static testMethod void validateDataBBEmptyCountry(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        BET_EditAssetController controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BB;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.file.Country__c           = null;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals('Country cannot be empty.', result[0]);
    }  

    static testMethod void validateDataBBNotAllowed(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        BET_EditAssetController controller;
        List<String> result;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BB;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.file.Country__c           = BET_TestingHelper.UT_COUNTRY;
            result = controller.validateData();            
        }         
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals('Not allowed to add Brand Building.', result[0]);
    }

    static testMethod void updateMetadataBBEmptyCountry(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(true);

        BET_EditAssetController controller;
        PageReference result;
        
        System.runAs(BET_TestingHelper.getDefaultMember()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BB;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.file.Country__c           = null;
            result = controller.updateMetadata();            
        }         
        System.assertEquals(null, result);
        System.assert(BET_TestingHelper.checkifPageMessageExists(
            'Country cannot be empty.',
            ApexPages.Severity.ERROR
        ));
    }  

    static testMethod void updateToApprovedPresentationAsOwner(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();

        BET_EditAssetController controller;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            System.assert(String.isBlank(controller.message));
            System.assertEquals(true, controller.displayForm);
            System.assertEquals(betWrapper.BET.Id, controller.bet.Id);
            
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_APPROVED;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_PRESENTATION;
            controller.updateMetadata();            
        }         

        System.assertEquals(BET_TestingHelper.ASSET_SUBFUNCTION_BD, controller.file.Sub_Function__c);
        System.assertEquals(true, controller.hasModifyAccess);
        System.assertEquals(true, controller.runJsSuccess);
        System.assertEquals('Your BET is now in First Release', controller.message);
        System.assertEquals(true, controller.isPresentationUploaded);
        System.assertEquals(BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION, controller.file.Media_Type__c);

        uw_BET__c updatedBET = BET_TestingHelper.getBET(betWrapper.BET.Id);
        System.assertNotEquals(betWrapper.BET.Presentation_Id__c, updatedBET.Presentation_Id__c);
        System.assertEquals(BET_TestingHelper.BET_STATUS_FIRSTRELEASE, updatedBET.Status__c);
    }
    static testMethod void updateToApprovedCreativeWorkAsOwner(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(false, BET_TestingHelper.BET_STATUS_FIRSTRELEASE);

        BET_EditAssetController controller;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            System.assert(String.isBlank(controller.message));
            System.assertEquals(true, controller.displayForm);
            System.assertEquals(betWrapper.BET.Id, controller.bet.Id);
            
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_APPROVED;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.updateMetadata();            
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
    static testMethod void changePresentationToCreativeWorkAsOwner(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData();
        betWrapper.addPresentation('Presentation.ppt', BET_TestingHelper.ASSET_STATUS_DRAFT);
        betWrapper.BET.Presentation_Id__c = '069000000000001';
        update betWrapper.BET;

        BET_EditAssetController controller;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            System.assert(String.isBlank(controller.message));
            System.assertEquals(true, controller.displayForm);
            System.assertEquals(betWrapper.BET.Id, controller.bet.Id);
            
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_APPROVED;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.updateMetadata();            
        }         

        System.assertEquals(BET_TestingHelper.ASSET_SUBFUNCTION_BD, controller.file.Sub_Function__c);
        System.assertEquals(true, controller.hasModifyAccess);
        System.assertEquals(true, controller.runJsSuccess);
        System.assertEquals('', controller.message);
        System.assertEquals(true, controller.isPresentationUploaded);

        uw_BET__c updatedBET = BET_TestingHelper.getBET(betWrapper.BET.Id);
        System.assertEquals(null, updatedBET.Presentation_Id__c);
    }
    static testMethod void handleDMLException(){
        BET_TestingHelper.BET_TestingData betWrapper = prepareData(false, BET_TestingHelper.BET_STATUS_FIRSTRELEASE);

        BET_EditAssetController controller;
        
        System.runAs(BET_TestingHelper.getDefaultOwner()){
            controller = new BET_EditAssetController(new ApexPages.StandardController(betWrapper.creativeWork));
            System.assert(String.isBlank(controller.message));
            System.assertEquals(true, controller.displayForm);
            System.assertEquals(betWrapper.BET.Id, controller.bet.Id);
            
            controller.file.Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
            controller.file.Status__c            = BET_TestingHelper.ASSET_STATUS_APPROVED;
            controller.file.Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
            controller.file.Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
            controller.throwUTException          = 1;
            controller.updateMetadata();            
        }         

        System.assertEquals(false, controller.runJsSuccess);
        System.assertEquals(false, controller.isPresentationUploaded);

        System.assert(BET_TestingHelper.checkIfAnyPageMessageExists(ApexPages.Severity.ERROR));

        uw_BET__c updatedBET = BET_TestingHelper.getBET(betWrapper.BET.Id);
        System.assertEquals(betWrapper.BET.Presentation_Id__c, updatedBET.Presentation_Id__c);
        System.assertEquals(BET_TestingHelper.BET_STATUS_FIRSTRELEASE, updatedBET.Status__c);
    }
}