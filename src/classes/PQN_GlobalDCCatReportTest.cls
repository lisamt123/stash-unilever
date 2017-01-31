@isTest
private class PQN_GlobalDCCatReportTest{
    private static testMethod void testPQN_GlobalReport(){
  
    PQN_Sourcing_Unit__c sour=PQN_TestLibraryUtil.createSourcingUnit();
    insert sour;
    
    PQN_Sourcing_Unit__c source5=PQN_TestLibraryUtil.createSourcingUnit();
    source5.Year__c='2016';
    insert source5;
    
    
    PQN_Supplier__c  supplier=PQN_TestLibraryUtil.createSupplier();
    insert supplier;
    
    PQN_DC_Volumes__c dcvolume=PQN_TestLibraryUtil.createDCvolumes();
    insert dcvolume;
    
    Account acc=PQN_TestLibraryUtil.createpqnAccount('abc','srilanka');
    insert acc;
    
     PQN_Pallet_Quality_Non_Conformance__c PQN = PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(supplier.id,acc.id,dcvolume.id);
     insert PQN;
     
         
     
        PQN_Pallet_Quality_Non_Conformance__c PQN1 = PQN_TestLibraryUtil.createPQN_Pallet_Quality_Non_Conformance(supplier.id,acc.id,dcvolume.id);
        PQN1.Date_Pallet_Received__c=date.newInstance(2016,1,15);
        PQN1.Supplier_Cluster__c='Europe';
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
          Test.startTest();
    
        
        
        list<PQN_Pallet_Loss_Tree__c> losstreelst=new list<PQN_Pallet_Loss_Tree__c>();
        PQN_Pallet_Loss_Tree__c losstree=new PQN_Pallet_Loss_Tree__c();
        losstree.name='110';
        losstree.Loss_Code__c=110;
        losstree.Loss_L1__c='Distribution Pack / Pallet';
        losstree.Loss_L2__c='Configuration / Build';
        losstree.Loss_L3__c='Assembly Missing / Wrong, Component Missing / Wrong';
        losstree.Loss_L4__c='Missing Cases';
        
         PQN_Pallet_Loss_Tree__c losstree1=new PQN_Pallet_Loss_Tree__c();
        losstree1.name='111';
        losstree1.Loss_Code__c=111;
        losstree1.Loss_L1__c='Distribution Pack / Pallet';
        losstree1.Loss_L2__c='Configuration / Build';
        losstree1.Loss_L3__c='Assembly Missing / Wrong, Component Missing / Wrong';
        losstree1.Loss_L4__c='Missing Cases';
        
         PQN_Pallet_Loss_Tree__c losstree2=new PQN_Pallet_Loss_Tree__c();
        losstree2.name='112';
        losstree2.Loss_Code__c=112;
        losstree2.Loss_L1__c='Distribution Pack / Pallet';
        losstree2.Loss_L2__c='Configuration / Build';
        losstree2.Loss_L3__c='Assembly Missing / Wrong, Component Missing / Wrong';
        losstree2.Loss_L4__c='Missing Cases';
        
         PQN_Pallet_Loss_Tree__c losstree3=new PQN_Pallet_Loss_Tree__c();
        losstree3.name='113';
        losstree3.Loss_Code__c=113;
        losstree3.Loss_L1__c='Distribution Pack / Pallet';
        losstree3.Loss_L2__c='Configuration / Build';
        losstree3.Loss_L3__c='Assembly Missing / Wrong, Component Missing / Wrong';
        losstree3.Loss_L4__c='Missing Cases';
        
         PQN_Pallet_Loss_Tree__c losstree4=new PQN_Pallet_Loss_Tree__c();
        losstree4.name='114';
        losstree4.Loss_Code__c=114;
        losstree4.Loss_L1__c='Distribution Pack / Pallet';
        losstree4.Loss_L2__c='Stretch Wrap Integrity';
        losstree4.Loss_L3__c='Assembly Missing / Wrong, Component Missing / Wrong';
        losstree4.Loss_L4__c='Missing Cases';
        
         PQN_Pallet_Loss_Tree__c losstree5=new PQN_Pallet_Loss_Tree__c();
        losstree5.name='115';
        losstree5.Loss_Code__c=115;
        losstree5.Loss_L1__c='Distribution Pack / Pallet';
        losstree5.Loss_L2__c='Stretch Wrap Integrity';
        losstree5.Loss_L3__c='Assembly Missing / Wrong, Component Missing / Wrong';
        losstree5.Loss_L4__c='Missing Cases';
        
         PQN_Pallet_Loss_Tree__c losstree6=new PQN_Pallet_Loss_Tree__c();
        losstree6.name='116';
        losstree6.Loss_Code__c=116;
        losstree6.Loss_L1__c='Distribution Pack / Pallet';
        losstree6.Loss_L2__c='Stretch Wrap Integrity';
        losstree6.Loss_L3__c='Assembly Missing / Wrong, Component Missing / Wrong';
        losstree6.Loss_L4__c='Missing Cases';
        
         PQN_Pallet_Loss_Tree__c losstree7=new PQN_Pallet_Loss_Tree__c();
        losstree7.name='117';
        losstree7.Loss_Code__c=117;
        losstree7.Loss_L1__c='Distribution Pack / Pallet';
        losstree7.Loss_L2__c='Stretch Wrap Integrity';
        losstree7.Loss_L3__c='Assembly Missing / Wrong, Component Missing / Wrong';
        losstree7.Loss_L4__c='Missing Cases';
        
         PQN_Pallet_Loss_Tree__c losstree8=new PQN_Pallet_Loss_Tree__c();
        losstree8.name='118';
        losstree8.Loss_Code__c=118;
        losstree8.Loss_L1__c='Distribution Pack / Pallet';
        losstree8.Loss_L2__c='Stretch Wrap Integrity';
        losstree8.Loss_L3__c='Assembly Missing / Wrong, Component Missing / Wrong';
        losstree8.Loss_L4__c='Missing Cases';
        
         PQN_Pallet_Loss_Tree__c losstree9=new PQN_Pallet_Loss_Tree__c();
        losstree9.name='119';
        losstree9.Loss_Code__c=119;
        losstree9.Loss_L1__c='Distribution Pack / Pallet';
        losstree9.Loss_L2__c='Pallet Label';
        losstree9.Loss_L3__c='Assembly Missing / Wrong, Component Missing / Wrong';
        losstree9.Loss_L4__c='Missing Cases';
        
         PQN_Pallet_Loss_Tree__c losstree10=new PQN_Pallet_Loss_Tree__c();
        losstree10.name='120';
        losstree10.Loss_Code__c=120;
        losstree10.Loss_L1__c='Distribution Pack / Pallet';
        losstree10.Loss_L2__c='Pallet Label';
        losstree10.Loss_L3__c='Assembly Missing / Wrong, Component Missing / Wrong';
        losstree10.Loss_L4__c='Missing Cases';
        
         PQN_Pallet_Loss_Tree__c losstree11=new PQN_Pallet_Loss_Tree__c();
        losstree11.name='121';
        losstree11.Loss_Code__c=121;
        losstree11.Loss_L1__c='Distribution Pack / Pallet';
        losstree11.Loss_L2__c='Pallet Label';
        losstree11.Loss_L3__c='Assembly Missing / Wrong, Component Missing / Wrong';
        losstree11.Loss_L4__c='Missing Cases';
        
         PQN_Pallet_Loss_Tree__c losstree12=new PQN_Pallet_Loss_Tree__c();
        losstree12.name='122';
        losstree12.Loss_Code__c=122;
        losstree12.Loss_L1__c='Distribution Pack / Pallet';
        losstree12.Loss_L2__c='Pallet Label';
        losstree12.Loss_L3__c='Assembly Missing / Wrong, Component Missing / Wrong';
        losstree12.Loss_L4__c='Missing Cases';
        
         PQN_Pallet_Loss_Tree__c losstree13=new PQN_Pallet_Loss_Tree__c();
        losstree13.name='123';
        losstree13.Loss_Code__c=123;
        losstree13.Loss_L1__c='Distribution Pack / Pallet';
        losstree13.Loss_L2__c='Pallet Board';
        losstree13.Loss_L3__c='Assembly Missing / Wrong, Component Missing / Wrong';
        losstree13.Loss_L4__c='Missing Cases';
        
        PQN_Pallet_Loss_Tree__c losstree14=new PQN_Pallet_Loss_Tree__c();
        losstree14.name='124';
        losstree14.Loss_Code__c=124;
        losstree14.Loss_L1__c='Distribution Pack / Pallet';
        losstree14.Loss_L2__c='Pallet Board';
        losstree14.Loss_L3__c='Assembly Missing / Wrong, Component Missing / Wrong';
        losstree14.Loss_L4__c='Missing Cases';
        
        losstreelst.add(losstree);
        losstreelst.add(losstree1);
        losstreelst.add(losstree2);
        losstreelst.add(losstree3);
        losstreelst.add(losstree4);
        losstreelst.add(losstree5);
        losstreelst.add(losstree6);
        losstreelst.add(losstree7);
        losstreelst.add(losstree8);
        losstreelst.add(losstree9);
        losstreelst.add(losstree10);
        losstreelst.add(losstree11);
        losstreelst.add(losstree12);
        losstreelst.add(losstree13);
        losstreelst.add(losstree14);
       
        
        insert losstreelst;
        
       /* PQN_GlobalCategoryReport category=new PQN_GlobalCategoryReport();
          category.getcategories();
          category.getsuppliers();
          category.Searchby();
        PQN_Global_DCReport reportDC=new PQN_Global_DCReport();
          reportDC.getcategories();
          reportDC.getsuppliers();
          reportDC.Searchby();
        PQN_GlobalSUReport SU=new PQN_GlobalSUReport();
          SU.getcategories();
          SU.getsuppliers();
          SU.Searchby();*/
          
          PQN_GlobalGeographyReport report=new PQN_GlobalGeographyReport();
          report.getcategories();
          report.getsuppliers();
          report.Searchby();
                  
          ApexPages.StandardController sc = new ApexPages.StandardController(PQN4);
         PQN_Global_Overview_Geography overview=new PQN_Global_Overview_Geography(sc);
         PQN_Global_Overview_Geography.generateStackData('mapStr');
         PQN_Global_Overview_Geography.generateCatStackData('asd');
          overview.getcategories();
          overview.getsuppliers();
          overview.Searchby();
     
        PQN_Country_Report country=new PQN_Country_Report();
      
          
     test.stoptest();
     }
  }