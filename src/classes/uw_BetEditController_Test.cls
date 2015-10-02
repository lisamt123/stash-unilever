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

    private static final String TEST_BLOB = 'aGVsbG8=';

    static testMethod void testMethodOne(){     
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET1_'+system.now(), true);

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
        
        System.assertEquals(controller.runJsSuccess, true);
        System.assertNotEquals(b.Banner_1_Location__c, null);
        System.assertNotEquals(b.Icon_Location__c, null);
        /*Test.startTest();
        controller.saveBET();
        Test.stopTest();
        controller.clearIcon();
        controller.clearBanner();
        Test.startTest();
        controller.saveBET();
        Test.stopTest();

        b = BET_TestingHelper.getBET(wrap.BET.Id);
        System.assertEquals(controller.runJsSuccess, true);
        System.assertEquals(b.Banner_1_Location__c, null);
        System.assertEquals(b.Icon_Location__c, null);
        Test.startTest();*/
        controller.archiveBET();
        Test.stopTest();
        b = BET_TestingHelper.getBET(wrap.BET.Id);
        System.assertEquals(b.Is_Archived__c, true);

        User usr = BET_TestingHelper.getDefaultNotMember();
        controller.bet.ownerId = usr.Id;
        System.assert(controller.saveBET() == null);
    }

    static testMethod void testMethodTwo(){     
        //BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET1_'+system.now(), true);
        ///BET_TestingHelper.BET_TestingData wrap2 = BET_Testinbet_gHelper.initBET('Test BET2_'+system.now(), true);
        //BET_TestingHelper.initBET('Test BET3', true);
        //BET_TestingHelper.initBET('Test BET4', true);

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

        //to cover catch
        //delete wrap2.BET;
        //wrap.BET.OwnerId = wrap2.BET.OwnerId;
        //controller.saveBET();

        //delete wrap.BET;
        //controller.saveBET();

        //controller.archiveBET();
        Folder currentfolder = [select Id,name from Folder where Name = 'BET Branding'];
        controller.throwUTException = 2;
        controller.icon = new Document(FolderId = currentfolder.Id, Name = 'Banner', Body = Blob.valueOf(TEST_BLOB));
        controller.saveDocument(controller.icon);
        System.assert(controller.saveBET() == null);
        Test.stopTest();
    }
    
    static testMethod void testMethodThree(){     
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET1_'+system.now(), true);
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
        System.assert(controller.saveBET() == null);
        Test.stopTest();
    }
}