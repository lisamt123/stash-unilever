@isTest
public class BFM_ShipmentDocumentGeneration_Test {
    private static testMethod void testshipmentgeneration(){
        Test.startTest();
        account carrier = new account();
        carrier.name = 'testname';
        insert carrier;
        system.assertEquals('testname',carrier.name);
        
        BFM_Shipment__c ship = new BFM_Shipment__c();
        ship.Carrier_Account__c=carrier.id;
        ship.Company_Code__c = '3123';
        insert ship;
        system.assertEquals('3123',ship.Company_Code__c);
        
        BFM_Stage__c newStage = new BFM_Stage__c();
        newstage.Free_freight__c = True;
        newstage.Shipment__c = ship.id;
        insert newStage;
        system.assertEquals(True,newstage.Free_freight__c);
        
        BFM_SES__c ses = new BFM_SES__c();
        ses.SES_Number__c='57685326';
        ses.Stage__c = newStage.id;
        insert ses;
        system.assertEquals('57685326',ses.SES_Number__c);
        
        BFM_NF_e__c nfe = new BFM_NF_e__c();
        nfe.SES__c = ses.id;
        nfe.NF_e_number__c = '13213';
        insert nfe;
        system.assertEquals('13213',nfe.NF_e_number__c);
        ApexPages.StandardController sc = new ApexPages.standardController(newStage); 
        BFM_ShipmentDocumentGeneration_CC shipdoc = new BFM_ShipmentDocumentGeneration_CC(sc);
        shipdoc.getNFes();
        Test.stopTest();
    }
}