@isTest
private class PQN_singleEntryScreenTest{
    private static testMethod void testPQN_singleEntryScreen(){
    Test.startTest();
        
        Supplier__c s=PQN_TestLibraryUtil.createSupplier();
        insert s;
        
        PQN_Pallet_Quality_Non_Conformance__c pqn=PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(s.id);
        insert pqn;
         
        PageReference pageRef = Page.PQN_SingleEntryScreen_VF;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', pqn.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(pqn);
        PQN_singleEntryScreen testPQN = new PQN_singleEntryScreen(sc);
        
        testPQN.validate();
        testPQN .savePQN();
        testPQN .cancelPQN();
                
        PageReference pageRef1 = Page.PQN_SingleEntryScreen_VF;
        Test.setCurrentPage(pageRef1);
   
        ApexPages.StandardController sc1 = new ApexPages.StandardController(pqn);
        PQN_singleEntryScreen testPQN1 = new PQN_singleEntryScreen(sc1);
        testPQN1.validate();
        testPQN1.savePQN();
        testPQN1.cancelPQN();
        
        Apexpages.currentPage().getParameters().put('skuName',pqn.SKU__c);
        ApexPages.StandardController sc2 = new ApexPages.StandardController(pqn);
        PQN_singleEntryScreen testPQN2 = new PQN_singleEntryScreen(sc2);
        testPQN2.validate();
              
        Apexpages.currentPage().getParameters().put('skuname','' );
        ApexPages.StandardController sc3 = new ApexPages.StandardController(pqn);
        PQN_singleEntryScreen testPQN3 = new PQN_singleEntryScreen(sc3);
        testPQN3.validate();
        
        Apexpages.currentPage().getParameters().put('skuname','2#2' );
        ApexPages.StandardController sc4 = new ApexPages.StandardController(pqn);
        PQN_singleEntryScreen testPQN4 = new PQN_singleEntryScreen(sc4);
        testPQN4.validate();
                  
    Test.stopTest();
    }
    }