@isTest(SeeAllData=true)
public class BFM_SESSearch_CC_Test{
    private static testMethod void searchses(){
    list<BFM_SES__c> listSES = new list<BFM_SES__c>();
    list<BFM_CT_e__c> listCTe = new list<BFM_CT_e__c>();
    
    BFM_CT_e__c cte = new BFM_CT_e__c();
    account carrier = new account();
    carrier.name = 'aswin';
    insert carrier;
    system.assertEquals('aswin',carrier.name);
    BFM_Shipment__c ship = new BFM_Shipment__c();
    ship.Carrier_Account__c=carrier.id;
    insert ship;
        
    BFM_Stage__c newStage = new BFM_Stage__c();
    newStage.Shipment__c=ship.id;
    insert newStage;
    
    BFM_NFS__c nfs1 = new BFM_NFS__c();
    nfs1.Carrier__c=carrier.id;
    insert nfs1;
    
    BFM_Occurrence__c occur = new BFM_Occurrence__c();
    insert occur;
    
    BFM_SES__c ses = new BFM_SES__c();
    ses.SES_Number__c='57685326';
    ses.CT_E__c = cte.id;
    ses.NFS__c =nfs1.id;
    ses.Stage__c = newStage.id;
    test.starttest();
    system.assertEquals('57685326',ses.SES_Number__c);
    insert ses;
    listSES.add(ses);
    
    BFM_SES__c ses1 = new BFM_SES__c();
    ses1.SES_Number__c='57685926';
    ses1.CT_E__c = cte.id;
    ses1.NFS__c =nfs1.id;
    ses1.Stage__c = newStage.id;
   
    system.assertEquals('57685926',ses1.SES_Number__c);
    insert ses1;
    listSES.add(ses1);
    
    BFM_SES__c ses2 = new BFM_SES__c();
    ses2.SES_Number__c='57685396';
    ses2.CT_E__c = cte.id;
    ses2.NFS__c =nfs1.id;
    ses2.Stage__c = newStage.id;
    
    system.assertEquals('57685396',ses2.SES_Number__c);
    insert ses2;
    listSES.add(ses2);
    
    BFM_SES__c ses3 = new BFM_SES__c();
    ses3.SES_Number__c='57685376';
    ses3.CT_E__c = cte.id;
    ses3.NFS__c =nfs1.id;
    ses3.Stage__c = newStage.id;
    
    system.assertEquals('57685376',ses3.SES_Number__c);
    insert ses3 ;
    listSES.add(ses3);
    
    BFM_SES__c ses4= new BFM_SES__c();
    ses4.SES_Number__c='57681396';
    ses4.CT_E__c = cte.id;
    ses4.NFS__c =nfs1.id;
    ses4.Stage__c = newStage.id;
    
    system.assertEquals('57681396',ses4.SES_Number__c);
    insert ses4;
    listSES.add(ses4);
    
    //insert listSES;
    BFM_SESSearch_CC search = new BFM_SESSearch_CC();
    search.searchses();
    search.FirstPage();
    //search.previous();
    search.next();
   // search.LastPage();
    //search.getprev();
    //search.getnxt();
    test.isRunningTest();
    test.stoptest();          
   }
}