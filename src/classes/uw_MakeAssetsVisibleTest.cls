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
@IsTest(SeeAllData=true)
private class uw_MakeAssetsVisibleTest {

   private static uw_BET__c init1() {
        uw_Brand__c brand = uw_UnitTestDataFactory.createParentBrand();
        insert brand;
        
        //IDC- 14 Jun - Creating test data for Inoplan object
        uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
        insert inoPlanProject;
        
        uw_BET__c bet = uw_UnitTestDataFactory.createBet(brand, 'name',inoPlanProject);
        insert bet;
        
        return bet;
    }
    private static List<uw_Asset__c> init2(uw_BET__c bet) {
        ContentVersion cv = uw_UnitTestDataFactory.initContentVersion();
        uw_Asset__c a = uw_UnitTestDataFactory.initAsset('1',cv,bet); 
        List<uw_Asset__c> assets = new List<uw_Asset__c>();
        assets.add(a);
        return assets;
    }

    private static testmethod void test() {     
        uw_UnitTestDataFactory.initInternalProfile();
        User user1 = uw_UnitTestDataFactory.initInternalUser('u1xyz', 'u1xyz@accenture.com', 'Tester1', '1xyz@unileverxyz.com');
        uw_UnitTestDataFactory.initCollaborationGroup(uw_MakeAssetsVisible.PUBLIC_ASSET_GROUP_TEST, 'Public');

        System.runAs(user1) {
            uw_BET__c bet = init1();
            List<uw_Asset__c> assets = init2(bet);
            // requery to get any trigger added values
            bet = [SELECT CollaborationGroupId__c FROM uw_BET__c WHERE Id=:bet.id];
            system.assert(bet!=null);
            CollaborationGroup cg = new CollaborationGroup(Id=bet.CollaborationGroupId__c);
            uw_MakeAssetsVisible mav = new uw_MakeAssetsVisible();
            Integer i;
            
            try {
                i = mav.openUp(assets);
                system.assertEquals(1, i);
                /* not yet
                List<FeedItem> fis = [SELECT Id FROM FeedItem WHERE ParentId=:cg.Id AND type='ContentPost'];        
                system.assert(fis != null);
                system.assertEquals(1, fis.size());
                */                   
            } catch (Exception e) {
            } 
            
            try {
                i = mav.closeDown(assets);
                system.assertEquals(0, i);
            } catch (Exception e) {
                
            }      
        }
    }
}