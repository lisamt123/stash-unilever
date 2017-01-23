@isTest
public class BFM_SearchOccurrenceController_CC_Test{
    private static testMethod void testSearchOccurence(){
      Test.startTest();
        Account acc = BFM_TestUtils.createCarrierAccount();
        acc.cnpj__c = '03189042000100';
        acc.name='carrier';
        insert acc;
        system.assertEquals('carrier',acc.name);
      
        BFM_Occurrence__c occ = new BFM_Occurrence__c();
        occ.Carrier__c = 'carrier';
        occ.Carrier_Account__c = acc.id;
        occ.Company_Code__c = '3123';
        insert occ;
        system.assertEquals('3123',occ.Company_Code__c);
      
        BFM_SearchOccurrenceController_CC search = new BFM_SearchOccurrenceController_CC(null);
        BFM_SearchShipmentCTeController_CC.accountwrapper wrap = new BFM_SearchShipmentCTeController_CC.accountwrapper(occ.Id);
        search.occurNumber = '12345';
        search.occCarrierVendor = 'Test';
        search.occStatus = 'test';
        search.occCarrierAccount = acc.Id;
        search.occurCode = 'Testcode';
    search.occFromAccount = '12345678900000';
        search.occurStart = Date.today();
        search.recordscount='10';
        search.recordscount='25';
        search.recordscount='50';
        search.recordscount='100';
        PageReference pageRef = page.BFM_SearchOccurrences_VF;
        Test.setCurrentPage(pageRef);
        
        search.searchoccurs();
      search.redirectPage();
        search.getoccurences();
        search.first();
        search.last();
        search.previous();
        search.next();
        search.cancel();
        search.hasPrevious = true;
        search.hasNext=true;
        Test.stoptest();
    } 
}