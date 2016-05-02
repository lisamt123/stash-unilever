/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class uw_MiscTest {

    private static testmethod void test_uw_TacAcceptController() {
        final String userName = 'roman.white@indiana.porto.madrid.com';
        
        Test.setCurrentPage(Page.TermsAndConditionsAcceptPage2);
        ApexPages.currentPage().getParameters().put('un',userName);
        uw_TacAcceptController con = new uw_TacAcceptController();
        system.assert(con!=null);
        PageReference pr = con.doAction();
        String url = pr.getUrl();
        system.assert(url.contains('roman.white'));
    }
    
    private static testmethod void test_uw_EnableExternalUserBatchJob() {
        uw_Custom_Setting__c cs = new uw_Custom_Setting__c();
        cs.Name = 'SEND_INVITE_BATCH_JOB_ID';
        cs.Text_Value__c = '2112';
        insert cs;
        system.assert(cs.Id != null);

        List<uw_Terms_Conditions__c> TaCList = new List<uw_Terms_Conditions__c>();
        //IDC- 14 Jun - Creating test data for Inoplan object
        uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
        insert inoPlanProject;
        uw_BET__c bet = uw_UnitTestDataFactory.initBET('betName', true,inoPlanProject);
        uw_Terms_Conditions__c tac = uw_UnitTestDataFactory.initTac(bet, 'xyz@xyz.xyz.ajh', 'Enable User', true, true);
        tac.Status__c = 'Accepted';
        tac.Action_On_Accept__c = 'Enable User';
        update tac;

        uw_EnableExternalUserBatchJob eeubj = new uw_EnableExternalUserBatchJob();
        
        Test.startTest();
        ID batchprocessid = Database.executeBatch(eeubj);
        Test.stopTest();
    }
    
    private static testmethod void test_uw_helperMethods() {
        String server = uw_HelperMethods.getSalesforceLogonServer();
        if (uw_HelperMethods.isProductionOrg()) {
            system.assert(server.contains('login.salesforce.com'));         
        } else if (uw_HelperMethods.isSandboxOrg()) {
            system.assert(server.contains('test.salesforce.com'));                  
        } else {
            system.assert(false);
        }
        
        ContentVersion cv1 = uw_UnitTestDataFactory.initContentVersion();
        ContentVersion cv2 = uw_UnitTestDataFactory.initContentVersion();
        ContentVersion cv3 = uw_UnitTestDataFactory.initContentVersion();
        List<ContentVersion> cv1List = new List<ContentVersion>();
        List<ContentVersion> cv2List = new List<ContentVersion>();
        List<ContentVersion> cv3List = new List<ContentVersion>();
        List<String> stringList = new List<String>();
        cv1List.add(cv1);
        cv2List.add(cv2);
        cv3List.add(cv3);
        stringList.add(cv1.Id);
        Map<String,String> stringMap = uw_HelperMethods.getMapOfLatestPublishedContentVersions(stringList);
        
        Set<String> idSet = uw_HelperMethods.makeIdSet(cv1List, 'ContentDocumentId', 'link');
        system.assert(idSet!=null);
        system.assertEquals(1,idSet.size());
        system.assertEquals(true, idSet.contains(cv1.ContentDocumentId));
        
        Map<Id, SObject> cdId1Map = uw_HelperMethods.makeMap(cv1List, 'ContentDocumentId');
        system.assert(cdId1Map!=null);
        system.assertEquals(1,cdId1Map.size());
        system.assertEquals(true, cdId1Map.containsKey(cv1.ContentDocumentId));
        
        // compare two identical sets
        uw_HelperMethods.MapDiffs md1 = uw_HelperMethods.compareMapMap(cdId1Map,cdId1Map);
        system.assert(md1!=null);
        system.assertEquals(0, md1.inCollection1Only.size());
        system.assertEquals(0, md1.inCollection2Only.size());
        system.assertEquals(1, md1.inBothCollections.size());

        // compare two different sets
        // make maps for diff test
        Map<Id, SObject> cdId2Map = uw_HelperMethods.makeMap(cv2List, 'Id');
        system.assert(cdId2Map!=null);
        // make maps for diff test
        Map<Id, SObject> cdId3Map = uw_HelperMethods.makeMap(cv3List, 'Id');
        system.assert(cdId3Map!=null);


        uw_HelperMethods.MapDiffs md2 = uw_HelperMethods.compareMapMap(cdId2Map,cdId3Map);
        system.assert(md2!=null);
        system.debug('cdId2Map: '+cdId2Map);
        system.debug('cdId3Map: '+cdId3Map);
        system.debug('md2.inCollection1Only: '+md2.inCollection1Only);
        system.debug('md2.inCollection2Only: '+md2.inCollection2Only);
        system.debug('md2.inBothCollections: '+md2.inBothCollections);
        system.assertEquals(1, md2.inCollection1Only.size());
        system.assertEquals(1, md2.inCollection2Only.size());
        system.assertEquals(0, md2.inBothCollections.size());

    }    
    private static testmethod void test_uw_BatchJobHelper() {
        uw_Custom_Setting__c cs = new uw_Custom_Setting__c();
        cs.Name = 'SEND_INVITE_BATCH_JOB_ID';
        cs.Text_Value__c = '2112';
        insert cs;
        system.assert(cs.Id != null);

        List<uw_Terms_Conditions__c> TaCList = new List<uw_Terms_Conditions__c>();

        //IDC- 14 Jun - Creating test data for Inoplan object
        uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
        insert inoPlanProject;
                uw_BET__c bet = uw_UnitTestDataFactory.initBET('betName',true,inoPlanProject);
        uw_Terms_Conditions__c tac = uw_UnitTestDataFactory.initTac(bet, 'xyz@xyz.xyz.ajh', 'Enable User', true, true);
        TaCList.add(tac);
        
        uw_BatchJobHelper bjh = new uw_BatchJobHelper();
        system.assert(bjh != null);
        
        bjh.finishEnableExternalUsersForTsAndCs(TaCList);
        bjh.enableExternalUsersForTsAndCs(TaCList);
        bjh.sendCollaborationInvitesForAcceptedTsAndCs(TaCList);
        bjh.markSendInviteJobAsFinished();
        bjh.cancelSendInviteJob();
        bjh.scheduleNextSendInviteBatchJob();
    }
    
    // try to improve coverage by sweeping odd bits and pieces
    private static TestMethod void test_uw_BatchJobManagerController() {
        uw_Custom_Setting__c cs = new uw_Custom_Setting__c();
        cs.Name = 'SEND_INVITE_BATCH_JOB_ID';
        cs.Text_Value__c = '2112';
        insert cs;
        system.assert(cs.Id != null);
        
        
    }    
}