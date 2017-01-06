@isTest
private class PQN_GlobalGeographyReportTest{
    private static testMethod void testPQN_GlobalGeographyReport(){
    Test.startTest();
    
    PQN_Sourcing_Unit__c source=PQN_TestLibraryUtil.createSourcingUnit();
    insert source;
    
    PQN_Sourcing_Unit__c source1=PQN_TestLibraryUtil.createSourcingUnit();
    source1.Year__c='2016';
    insert source1;
    
    
    PQN_Supplier__c  supplier=PQN_TestLibraryUtil.createSupplier();
    insert supplier;
    
    PQN_DC_Volumes__c dcvolume=PQN_TestLibraryUtil.createDCvolumes();
    insert dcvolume;
    
    Account acc=PQN_TestLibraryUtil.createpqnAccount('abc','srilanka');
    insert acc;
    
     PQN_Pallet_Quality_Non_Conformance__c PQN = PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(supplier.id,acc.id,dcvolume.id);
     insert PQN;
     
      PQN_GlobalGeographyReport report=new PQN_GlobalGeographyReport();
     
        PQN_Pallet_Quality_Non_Conformance__c PQN1 = PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(supplier.id,acc.id,dcvolume.id);
        PQN1.Date_Pallet_Received__c=date.newInstance(2016,1,15);
        insert PQN1;
        
        PQN_Pallet_Quality_Non_Conformance__c PQN2 = PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(supplier.id,acc.id,dcvolume.id);
        PQN2.Supplier_type__c='DC';
        PQN2.Date_Pallet_Received__c=date.newInstance(2016,1,15);
    
     insert PQN2 ;
     
        PQN_Pallet_Quality_Non_Conformance__c PQN3= PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(supplier.id,acc.id,dcvolume.id);
        PQN3.Supplier_type__c='SU';
        PQN3.Date_Pallet_Received__c=date.newInstance(2016,1,15);
        PQN3.SKU__c='9026734';
        PQN3.Product_Group__c='Personal Care';
        PQN3.Product_Category__c='Hair Care';
        insert PQN3 ;
        System.assertEquals(PQN3.Product_Category__c, 'Hair Care');
        
        PQN_Pallet_Quality_Non_Conformance__c PQN4= PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(supplier.id,acc.id,dcvolume.id);
        PQN3.Supplier_type__c='DC';
        PQN4.Date_Pallet_Received__c=date.newInstance(2017,1,15);
        PQN4.SKU__c='9026734';
        //PQN4.Product_Group__c='Personal Care';
        PQN4.Product_Category__c='Hair Care';
        insert PQN4 ;
        System.assertEquals(PQN4.Product_Category__c, 'Hair Care');
     
     
     
     PQN_GlobalGeographyReport report1=new PQN_GlobalGeographyReport();
    
     PQN_Global_Overview_Geography overviewreport=new PQN_Global_Overview_Geography();
       PQN_Global_DCReport reportDC=new PQN_Global_DCReport();
     PQN_Global_Overview_Category_Report overviewcateary=new PQN_Global_Overview_Category_Report();
     PQN_GlobalSUReport SU=new PQN_GlobalSUReport();
     PQN_Country_Report country=new PQN_Country_Report();
     PQN_GlobalCategoryReport category=new PQN_GlobalCategoryReport();
          
     test.stoptest();
     }
  }