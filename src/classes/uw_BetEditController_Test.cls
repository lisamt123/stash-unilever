/**********************************************************************
Name: uw_BetEditController_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for uw_BetEditController
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             16/01/2014      INITIAL DEVELOPMENT
***********************************************************************/
@isTest
private class uw_BetEditController_Test {


    private static final String EMPTY_PAGE_REFERENCE = 'Page refrence should be set to null';

    private static final String TEST_BLOB = 'aGVsbG8=';

    private static final String TEST_BET_NAME = 'Test BET1_';

    static testMethod void testMethodOne(){     
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET(TEST_BET_NAME+system.now(), true);

        uw_Bet__c tbet = BET_TestUtils.getTestBet();
        tbet.Launch_Date__c = date.today();
        insert tbet;

        wrap.BET = tbet;

        System.CurrentPageReference().getParameters().put('Id', wrap.BET.Id);

        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(wrap.BET);
        uw_BetEditController controller = new uw_BetEditController(sc);
        
        Folder currentfolder = [select Id,name from Folder where Name = 'BET Branding'];
        controller.icon = new Document(FolderId = currentfolder.Id, Name = 'Icon', Body = Blob.valueOf(TEST_BLOB));
        controller.banner = new Document(FolderId = currentfolder.Id, Name = 'Banner', Body = Blob.valueOf(TEST_BLOB));
        Test.startTest();
        controller.saveBET();
        uw_BET__c b = BET_TestingHelper.getBET(wrap.BET.Id);
        
        System.assertEquals(controller.runJsSuccess, true, 'JS validation flag should be set to true');
        System.assertNotEquals(b.Banner_1_Location__c, null, 'Banner Location should be set');
        System.assertNotEquals(b.Icon_Location__c, null, 'Icon location should be set');

        controller.archiveBET();
        Test.stopTest();
        b = BET_TestingHelper.getBET(wrap.BET.Id);
        System.assertEquals(b.Is_Archived__c, true, 'Bet should be archived');

        User usr = BET_TestingHelper.getDefaultNotMember();
        controller.bet.ownerId = usr.Id;
        System.assert(controller.saveBET() == null,EMPTY_PAGE_REFERENCE);
    }

    static testMethod void testMethodTwo(){     

        uw_Bet__c tbet = BET_TestUtils.getTestBet();
        tbet.Launch_Date__c = date.today();
        tbet.Banner_1_Location__c = 'testurl';
        tbet.Icon_Location__c = 'testurl2';
        insert tbet;

        System.CurrentPageReference().getParameters().put('Id', tbet.Id);

        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(tbet);
        uw_BetEditController controller = new uw_BetEditController(sc);

        Test.startTest();
        controller.saveDocument(controller.icon);

        Folder currentfolder = [select Id,name from Folder where Name = 'BET Branding'];
        controller.throwUTException = 2;
        controller.icon = new Document(FolderId = currentfolder.Id, Name = 'Banner', Body = Blob.valueOf(TEST_BLOB));
        controller.saveDocument(controller.icon);
        System.assert(controller.saveBET() == null,EMPTY_PAGE_REFERENCE);
        Test.stopTest();
    }
    
    static testMethod void testMethodThree(){     
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET(TEST_BET_NAME+system.now(), true);
        BET_TestingHelper.initBET('Test BET2', true);
        
        uw_Bet__c tbet = BET_TestUtils.getTestBet();
        tbet.Launch_Date__c = date.today();
        insert tbet;
        wrap.BET = tbet;
        
        User usr = BET_TestingHelper.getDefaultNotMember();

        System.CurrentPageReference().getParameters().put('Id', wrap.BET.Id);

        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(wrap.BET);
        uw_BetEditController controller = new uw_BetEditController(sc);
        
        Folder currentfolder = [select Id,name from Folder where Name = 'BET Branding'];
        controller.icon = new Document(FolderId = currentfolder.Id, Name = 'Icon', Body = Blob.valueOf(TEST_BLOB));
        controller.banner = new Document(FolderId = currentfolder.Id, Name = 'Banner', Body = Blob.valueOf(TEST_BLOB));
        
        controller.throwUTException = 1;
        controller.icon = null;
        controller.banner = null;
        
        controller.bet.OwnerId = usr.Id;
        Test.startTest();
        System.assert(controller.saveBET() == null,EMPTY_PAGE_REFERENCE);
        Test.stopTest();
    }

    static testMethod void softDeleteTest(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET(TEST_BET_NAME+system.now(), true);
        BET_TestingHelper.initBET('Test BET2', true);
        
        uw_Bet__c tbet = BET_TestUtils.getTestBet();
        tbet.Launch_Date__c = date.today();
        insert tbet;
        wrap.BET = tbet;

        System.CurrentPageReference().getParameters().put('Id', wrap.BET.Id);

        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(wrap.BET);
        uw_BetEditController controller = new uw_BetEditController(sc);

        Test.startTest();
        System.assert(controller.softDeleteBET() == null,EMPTY_PAGE_REFERENCE);
        Test.stopTest();

    }

    static testMethod void updateBetTest(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET(TEST_BET_NAME+system.now(), true);
        BET_TestingHelper.initBET('Test BET2', true);
        
        uw_Bet__c tbet = BET_TestUtils.getTestBet();
        tbet.Launch_Date__c = date.today();
        insert tbet;

        tbet.Status__c = 'First release';

        tbet.Launch_Date__c = date.today().addDays(180);
        
        tbet.FinalReleaseDate__c = date.today().addDays(1);

        tbet.FirstReleaseDate__c = date.today().addDays(1);

        update tbet;

        tbet = [select Status__c from uw_Bet__c where id =: tbet.id];

        Test.startTest();
        System.assertEquals(tbet.Status__c,'First release','Status should be First release');
        Test.stopTest();

    }
}