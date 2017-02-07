@isTest 
private class PQN_UploadNCData_CloneTest {
    static testMethod void PQN_M1() {
        
        List<PQN_DC_Hierarchy__c> pdh = new List<PQN_DC_Hierarchy__c>();
        PQN_DC_Hierarchy__c dc1 = new PQN_DC_Hierarchy__c(name ='Cannock',dc__c = 'Cannock',region__c = 'Americas',cluster__c = 'Latin America',sub_cluster__c = 'Latin America',mco__c ='mco');
        PQN_DC_Hierarchy__c dc2 = new PQN_DC_Hierarchy__c(name ='Heilbronn auto',dc__c = 'Heilbronn auto',region__c = 'Americas',cluster__c = 'Latin America',sub_cluster__c = 'Latin America',mco__c ='mco');
        PQN_DC_Hierarchy__c dc3 = new PQN_DC_Hierarchy__c(name ='DC1',dc__c = 'DC1',region__c = 'Americas',cluster__c = 'Latin America',sub_cluster__c = 'Latin America',mco__c ='mco');
        pdh.add(dc1);
        pdh.add(dc2);
        pdh.add(dc3);
        insert pdh;
    
        List<Account> listacc = new List<Account>();    
          Account acc=new account();
          acc.name='Error DC';
          listacc.add(acc);
          Account acc1=new account();
          acc1.name='DC1';
          listacc.add(acc1);
          Account acc2=new account();
          acc2.name='Cannock';
          listacc.add(acc2);
          Account acc3=new account();
          acc3.name='Heilbronn auto';
          listacc.add(acc3);
          insert listacc;
          PQN_DC_Volumes__c dcv=PQN_TestLibraryUtil.createDCvolumes();
            insert dcv;
            PQN_Supplier__c  sup=PQN_TestLibraryUtil.createSupplier();
            insert sup;
          
         PQN_Pallet_Quality_Non_Conformance__c pqn=PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(sup.id,acc.id,dcv.id);
         pqn.Reporting_DC__c = 'ULDC';
         pqn.SKU__c ='12345';
         pqn.Supplier__c='sail';
         pqn.Non_compliance_reason_code__c=123;
         pqn.account__c =null;
         //insert pqn;
     
     
     
        test.starttest();
        
            List<PQN_Pallet_Quality_Non_Conformance__c> xPQN = new List<PQN_Pallet_Quality_Non_Conformance__c>();
            xPQN.add(pqn);
            PQN_UploadNCData_Clone pU = new PQN_UploadNCData_Clone();
            //PQN_UploadNCData_Clone.getSheetData(xPQN,'Unilever');
           // PQN_UploadNCData_Clone.getSheetData(xPQN,'Cannock');
            PQN_UploadNCData_Clone.getSheetStatus('902102912');
            PQN_UploadNCData_Clone.getSheetData(xPQN,'Cannock123','abc');
            
            PQN_Pallet_Quality_Non_Conformance__c pqn1=PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(sup.id,acc.id,dcv.id);
            pqn1.account__c =null;
            List<PQN_Pallet_Quality_Non_Conformance__c> xPQN1 = new List<PQN_Pallet_Quality_Non_Conformance__c>();
            xPQN1.add(pqn1);
     
            PQN_UploadNCData_Clone.getSheetData(xPQN1,'Cannock','abc');
            
             PQN_Pallet_Quality_Non_Conformance__c pqn2=PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(sup.id,acc.id,dcv.id);
            pqn2.account__c =null;
            List<PQN_Pallet_Quality_Non_Conformance__c> xPQN2 = new List<PQN_Pallet_Quality_Non_Conformance__c>();
            xPQN2.add(pqn2);
            PQN_UploadNCData_Clone.getSheetData(xPQN2,'Heilbronn','abc');
            
            PQN_Pallet_Quality_Non_Conformance__c pqn3=PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(sup.id,acc.id,dcv.id);
            pqn3.account__c =null;
            List<PQN_Pallet_Quality_Non_Conformance__c> xPQN3 = new List<PQN_Pallet_Quality_Non_Conformance__c>();
            xPQN3.add(pqn3);
            PQN_UploadNCData_Clone.getSheetData(xPQN3,'Unilever','abc');
            
        test.stoptest();
    
    }

}