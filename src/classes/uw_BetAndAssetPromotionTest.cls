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
private class uw_BetAndAssetPromotionTest {

    static testMethod void myUnitTest() {
        uw_Brand__c brand = uw_UnitTestDataFactory.createParentBrand();
        insert brand;
        //IDC- 14 Jun - Creating test data for Inoplan object
         uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
         insert inoPlanProject;
        //IDC- 14 Jun - new Inoplan parameter added          
         uw_Bet__c bet = uw_UnitTestDataFactory.createBet(brand, 'my test bet',inoPlanProject );
         insert bet;
        
        ContentVersion cv1 = uw_UnitTestDataFactory.initContentVersion();
        ContentVersion cv2 = uw_UnitTestDataFactory.initContentVersion();

        uw_Asset__c a1 = uw_UnitTestDataFactory.initAsset('1',cv1,bet); 
        uw_Asset__c a2 = uw_UnitTestDataFactory.initAsset('2',cv2,bet); 
        List<uw_Asset__c> assets = new List<uw_Asset__c>();
        assets.add(a1);
        assets.add(a2);
        
        // set the asset to be public
        a1.Promoted__c = true;
        a2.Promoted__c = true;
        update assets;
        
        // set the bet to be public
        bet.Sharing__c = 'Public';
        update bet;
        
        // make the asset private
        a1.Promoted__c = false;
        a2.Promoted__c = false;
        update assets;
        
        // make the bet private
        //bet.Sharing__c = 'Private';
        //update bet;
    }
}