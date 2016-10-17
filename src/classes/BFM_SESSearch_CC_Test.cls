@isTest
public class BFM_SESSearch_CC_Test{
    private static testMethod void searchses(){
    list<BFM_SES__c> listSES = new list<BFM_SES__c>();
    list<BFM_CT_e__c> listCTe = new list<BFM_CT_e__c>();
    
    BFM_CT_e__c cte = new BFM_CT_e__c();
    account carrier = new account();
    carrier.name = 'aswin';
    insert carrier;
    
    BFM_Shipment__c ship = new BFM_Shipment__c();
    ship.Carrier_Account__c=carrier.id;
    insert ship;
        
    BFM_Stage__c newStage = new BFM_Stage__c();
    newStage.Shipment__c=ship.id;
    insert newStage;
    
    BFM_NFS__c nfs1 = new BFM_NFS__c();
    insert nfs1;
    
    BFM_Occurrence__c occur = new BFM_Occurrence__c();
    insert occur;
    
    BFM_SES__c ses = new BFM_SES__c();
    ses.SES_Number__c='57685326';
    ses.CT_E__c = cte.id;
    ses.NFS__c =nfs1.id;
    ses.Stage__c = newStage.id;
    insert ses;
    listSES.add(ses);
    
    //insert listSES;
    test.starttest();
    BFM_SESSearch_CC search = new BFM_SESSearch_CC();
    search.searchses();
    search.FirstPage();
    search.previous();
    search.next();
    //search.LastPage();
    //search.getprev();
    //search.getnxt();
    test.isRunningTest();
    test.stoptest();          
   }
}