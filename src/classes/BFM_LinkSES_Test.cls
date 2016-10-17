@isTest
public class BFM_LinkSES_Test{
    private static testMethod void testCteSESLink(){
        list<BFM_CT_e__c> listCTe = new list<BFM_CT_e__c>();
        list<BFM_NF_e__c > listNFe = new list<BFM_NF_e__c >();
        list<BFM_NFS__c> listNFs = new list<BFM_NFS__c>();
        list<BFM_SES__c> listSES = new list<BFM_SES__c>();
        
        //BFM_CheckRecursive checkres = new BFM_CheckRecursive ();
        
        
        //list<BFM_Carrier_Account__c> ca = [SELECT RecordTypeId FROM BFM_Carrier_Account__c limit 1  ];
        
        account carrier = new account();
        /*carrier.name='kavya';
        carrier.RecordTypeid='0128A0000008b6qQAA' ;*/
        carrier.name = 'aswin';
        insert carrier;
        
        BFM_Shipment__c ship = new BFM_Shipment__c();
        ship.Carrier_Account__c=carrier.id;
        insert ship;
        
        BFM_Stage__c newStage = new BFM_Stage__c();
        newStage.Shipment__c=ship.id;
        insert newstage;
        
        BFM_CT_e__c cte1 = new BFM_CT_e__c();
        
        
        BFM_NFS__c nfs1 = new BFM_NFS__c();
        nfs1.NFS_Link_Check_Status__c='Missing NF-es on the NFS';
        listNFs.add(nfs1);
        
        BFM_NFS__c nfs2 = new BFM_NFS__c();
        nfs2.NFS_Link_Check_Status__c='Link OK';
        listNFs.add(nfs2);
        
        BFM_NFS__c nfs3 = new BFM_NFS__c();
        nfs3.NFS_Link_Check_Status__c='Pending Link';
        listNFs.add(nfs3);
        
        BFM_SES__c ses = new BFM_SES__c();
        ses.CT_E__c = cte1.id;
        ses.NFS__c =nfs1 .id;
        ses.Stage__c = newStage.id;
        insert ses;
        listSES.add(ses);
        BFM_NF_e__c nfe = new BFM_NF_e__c();
        nfe.NF_e_access_key__c=ses.id;
        
        
        nfe.NFS__c=nfs1.id;
        nfe.NFS__c=nfs2.id;
        nfe.NFS__c=nfs3.id;
        
        cte1.Link_Status__c='Link Ok';
        cte1.Cte_Status__c='Link OK';
        cte1.CT_e_Valid_CNPJ_Status__c='valid CNPJ';
        cte1.CT_e_Duplicate_Record_Status__c='Validation OK';
        
        
        BFM_CT_e__c cte3 = new BFM_CT_e__c();
        cte3.Link_Status__c='Missing NF-es on the CT-e';
        cte3.Cte_Status__c='Missing NF-es on the CT-e';
               
        BFM_CT_e__c cte2 = new BFM_CT_e__c();
        cte2.Link_Status__c='Pending Link';
        cte2.Cte_Status__c='Pending Link';
        
        listNFe.add(nfe);
        listCTe.add(cte1);
        listCTe.add(cte2);
        listCTe.add(cte3);
        test.starttest();
        BFM_CheckRecursive.firstRun = true;       
        BFM_LinkSES.cteSESLink(listCTe);
        BFM_LinkSES.NFSSESLink(listNFs);
        test.isRunningTest();
        test.stoptest();     
    }
}