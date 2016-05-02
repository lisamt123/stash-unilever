/**********************************************************************
Name: WINatPOSDropDownController_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for WINatPOSDropDownController
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          14/12/2014      INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class WINatPOSDropDownController_Test {
	
	public static final String GLOBALSTR = 'Global';
	public static final String APPROVEDSTR = 'Approved';
	public static final String TESTSTR = 'test';
	/*******************************************************************
    Purpose: Helper class to create test data
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public class TestingHelper{
        public TestingHelper(){}
        public List<Category__c> finalTestCategory=new List<Category__c>();
        public List<Brand_Master__c> finalTestBrands=new List<Brand_Master__c>();
        public List<Category_Brands__c> finalCategoryBrand=new List<Category_Brands__c>();
        public list<Asset__c> finalTestAsset=new List<Asset__c>();
        public list<File__c> finalTestFiles=new List<File__c>();
        public List<Asset_Group__c> finalTestAssetGroup = new List<Asset_Group__c>();
        
        
        /*******************************************************************
        Purpose: Helper method to create test data
        Parameters: Void
        Returns: Void
        Throws [Exceptions]: [optional]
        ********************************************************************/
        public void prepareTestDataEnv(){
            List<Category__c> testCategories=new List<Category__c>();
            List<Brand_Master__c> testBrands=new List<Brand_Master__c>();
            List<Category_Brands__c> testCategoryBrand=new List<Category_Brands__c>();
            //start creating categories
            Category__c mainCat = new Category__c();
            mainCat.Name = 'Personal Care Test';
            mainCat.Type__c = 'Category Group';
            insert mainCat;
            
            //subCategory
            Category__c cat = new Category__c();
            cat.Name = 'Deodorants Test';     
            cat.Type__c = 'Category';
            cat.Category_Logo__c='<img alt="User-added image" data-cke-saved-src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png" src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png">';
            cat.Parent_Category__c = mainCat.Id;
            testCategories.add(cat);
            
            Category__c cat1 = new Category__c();
            cat1.Name = 'Hair Test';     
            cat1.Type__c = 'Category';
            cat1.Category_Logo__c='<img alt="User-added image" data-cke-saved-src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png" src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png">';
            cat1.Parent_Category__c = mainCat.Id;
            testCategories.add(cat1);
            
            insert testCategories;
            finalTestCategory=testCategories;
            
            
            //crete brands
            Brand_Master__c brandAxe=new Brand_Master__c();
            brandAxe.Primary_Category__c=cat.id;
            brandAxe.Name='Axe Test';
            brandAxe.Brand_Logo__c='<img alt="User-added image" data-cke-saved-src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png" src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png">';
            testBrands.add(brandAxe);
            
            Brand_Master__c brandDove=new Brand_Master__c();
            brandDove.Primary_Category__c=cat1.id;
            brandDove.Name='Dove Test';
            brandDove.Brand_Logo__c='<img alt="User-added image" data-cke-saved-src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png" src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png">';
            testBrands.add(brandDove);
            insert testBrands;
            finalTestBrands=testBrands;
            
            //create category brand mappings
            Category_Brands__c catBrand=new Category_Brands__c();
            catBrand.Name='Deodorants - Axe Test';
            catBrand.Brand__c=brandAxe.id;
            catBrand.Category__c=cat.id;
            testCategoryBrand.add(catBrand);
            
            Category_Brands__c catBrand1=new Category_Brands__c();
            catBrand1.Name='Deodorants - Dove Test';
            catBrand1.Brand__c=brandDove.id;
            catBrand1.Category__c=cat1.id;
            testCategoryBrand.add(catBrand1);
            
            Category_Brands__c catBrand2=new Category_Brands__c();
            catBrand2.Name='Hair - Axe Test';
            catBrand2.Brand__c=brandAxe.id;
            catBrand2.Category__c=cat1.id;
            testCategoryBrand.add(catBrand2);
            
            Category_Brands__c catBrand3=new Category_Brands__c();
            catBrand3.Name='Hair - Dove Test';
            catBrand3.Brand__c=brandDove.id;
            catBrand3.Category__c=cat1.id;
            testCategoryBrand.add(catBrand3);
			
			insert  testCategoryBrand;
            finalCategoryBrand=testCategoryBrand;
            
            //create Assets
            Asset_Group__c assetGroup=new Asset_Group__c();
            assetGroup.Name='TestAssetGroup';
            assetGroup.Type__c='Masterbrand';
            assetGroup.Category__c=cat.Id;
            insert assetGroup;
            finalTestAssetGroup.add(assetGroup);
            
            Asset__c asset = new Asset__c();
            asset.Name = 'Uniq Test Asset';
            asset.Asset_Group__c=assetGroup.id;
            asset.Category__c = cat.Id;
            asset.Brand__c = brandAxe.id;
            asset.Placement__c = 'Primary';
            asset.POS_Asset_Type__c = 'Masterbrand';
            asset.Market_Cluster__c = GLOBALSTR;
            asset.Channels__c='Cash & Carry;Convenience';
            asset.Status__c = APPROVEDSTR;
            asset.Country__c='UK';
            asset.Carousel_Published__c=true;
            asset.Description__c='test';
            finalTestAsset.add(asset);
            
            Asset__c asset1 = new Asset__c();
            asset1.Name = 'Uniq Test Asset 1';
            asset1.Category__c = cat1.Id;
            asset1.Brand__c=brandDove.id;
            asset1.Placement__c = 'Secondary';
            asset1.POS_Asset_Type__c = 'Innovation';
            asset1.Market_Cluster__c = GLOBALSTR;
            asset1.Channels__c='Hypermarkets';
            asset1.Status__c = APPROVEDSTR;
            asset1.Description__c='test';
            finalTestAsset.add(asset1);
            
            
            Asset__c asset2 = new Asset__c();
            asset2.Name = 'Uniq Test Asset 2';
            asset2.Category__c = cat1.Id;
            asset2.Brand__c=brandDove.id;
            asset2.Placement__c = 'Secondary';
            asset2.POS_Asset_Type__c = 'Innovation';
            asset2.Market_Cluster__c = GLOBALSTR;
            asset2.Channels__c='Hypermarkets';
            asset2.Status__c = APPROVEDSTR;
            asset2.Description__c='test';
            finalTestAsset.add(asset2);
            
            Asset__c asset3 = new Asset__c();
            asset3.Name = 'Uniq Test Asset 3';
            asset3.Category__c = cat1.Id;
            asset3.Brand__c=brandDove.id;
            asset3.Placement__c = 'Secondary';
            asset3.POS_Asset_Type__c = 'Best Practices';
            asset3.Market_Cluster__c = GLOBALSTR;
            asset3.Channels__c='Hypermarkets';
            asset3.Status__c = APPROVEDSTR;
            asset3.Description__c='test';
            finalTestAsset.add(asset3);
            
            Asset__c asset4 = new Asset__c();
            asset4.Name = 'Uniq Test Asset 4';
            asset4.Category__c = cat1.Id;
            asset4.Brand__c=brandDove.id;
            asset4.Placement__c = 'Secondary';
            asset4.POS_Asset_Type__c = 'Repeatable Model';
            asset4.Market_Cluster__c = GLOBALSTR;
            asset4.Channels__c='Hypermarkets';
            asset4.Status__c = APPROVEDSTR;
            asset4.Description__c='test';
            finalTestAsset.add(asset4);
        }
    }
    
    /*******************************************************************
    Purpose: Test method for new Asset creating/editing 
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void  testControllerForAsset(){
        TestingHelper ts =new TestingHelper();
        //create test data
        ts.prepareTestDataEnv();
        //start test for creating new asset
        Test.setCurrentPage(Page.WINatPOSNewAsset);
        Asset__c initialAsset = new Asset__c();
        Test.startTest();
        WINatPOSDropDownController cont=new WINatPOSDropDownController(new ApexPages.StandardController(initialAsset));
        
        //Simulate creating asset under asset group
        String retUrl='/apex/WinatPOSAssetGroupView?id='+ts.finalTestAssetGroup.get(0).id;
        ApexPages.currentPage().getParameters().put('retURL',retUrl);
        WINatPOSDropDownController contFromAssetGroup=new WINatPOSDropDownController(new ApexPages.StandardController(initialAsset));
        
        cont.selectedAgenciesEdit = new List<SelectOption>{new SelectOption('EditValue1', 'EditLabel1'), new SelectOption('EditValue2', 'EditLabel2')};
        cont.selectedAgenciesView = new List<SelectOption>{new SelectOption('ViewValue1', 'ViewLabel1'), new SelectOption('ViewValue2', 'ViewLabel2')};
        
        PageReference resultPageReference = cont.saveAsset();
        
        List<selectOption> catList=cont.getCategories();
        List<selectOption> brandList=cont.getBrands();
        List<selectOption> assetGroupList= cont.getAssetGroups();
        cont.currentAsset.Category__c=ts.finalTestCategory.get(0).Id;
        List<selectOption> brandListNarrowDowned=cont.getBrands();
        //cont.currentAsset.
        Test.stopTest();

        //check if picklist for lookup fields are populated
        system.assertEquals(true, catList.size()>0);
        system.assertEquals(true, brandList.size()>0);
        system.assertEquals(true, assetGroupList.size()>0);
        system.debug('check list sizes');
        system.debug(brandListNarrowDowned.size());
        system.debug(brandList.size());
        //system.assertEquals(true, brandListNarrowDowned.size()<brandList.size(), 'Brand picklist should be narrowed down when catogory is selected');
        system.assertEquals(true, cont.currentAsset != null, 'Asset record should be initialized inside controller');
        System.assert(resultPageReference != null);
        
        Asset__c resultAsset = [SELECT Agency_Read_Access_Text__c, Agency_Edit_Access_Text__c FROM Asset__c WHERE Id = :cont.currentAsset.Id];
        System.assert(!String.isBlank(resultAsset.Agency_Read_Access_Text__c));
        System.assert(!String.isBlank(resultAsset.Agency_Edit_Access_Text__c));
        //check if fields were populared from Asset Group when Asset Created under asset group
        Asset_Group__c parentAssetGroup=ts.finalTestAssetGroup.get(0);
        system.assertEquals(true, contFromAssetGroup.currentAsset.Asset_Group__c == parentAssetGroup.id);
        system.assertEquals(true, contFromAssetGroup.currentAsset.Brand__c == parentAssetGroup.Brand__c);
        system.assertEquals(true, contFromAssetGroup.currentAsset.Category__c == parentAssetGroup.Category__c);
        system.assertEquals(true, contFromAssetGroup.currentAsset.Market_Cluster__c == parentAssetGroup.Market_Cluster__c);
        system.assertEquals(true, contFromAssetGroup.currentAsset.POS_Asset_Type__c == parentAssetGroup.Type__c);

        
    }
    
    /*******************************************************************
    Purpose: Test method for new Asset Group creating/editing 
    test for page WINatPOSNewAssetGroup
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void  testControllerForAssetGroup(){
        TestingHelper ts =new TestingHelper();
        //create test data
        ts.prepareTestDataEnv();
        //start test for creating new asset group 
        Test.setCurrentPage(Page.WINatPOSNewAssetGroup);
        Asset_Group__c initialAssetGroup = new Asset_Group__c();
        Test.startTest();
        WINatPOSDropDownController contNewAssetGroup=new WINatPOSDropDownController(new ApexPages.StandardController(initialAssetGroup));
        WINatPOSDropDownController contEditAssetGroup=new WINatPOSDropDownController(new ApexPages.StandardController(ts.finalTestAssetGroup.get(0)));
        List<selectOption> catList=contNewAssetGroup.getCategories();
        List<selectOption> brandList=contNewAssetGroup.getBrands();
        List<selectOption> assetGroupList= contNewAssetGroup.getAssetGroups();
        String OwnerName=contEditAssetGroup.getOwnerName();
        Test.stopTest();
        //check if picklist for lookup fields are populated
        system.assertEquals(true, catList.size()>0);
        system.assertEquals(true, brandList.size()>0);
        system.assertEquals(true, assetGroupList.size()>0);
        //
        system.assertEquals(true, contNewAssetGroup.currentAssetGroup != null, 'Asset Group record should be initialized inside controller');
        system.assertEquals(true, contEditAssetGroup.currentAssetGroup.id != null, 'Asset Group extent controller should have record id for edited record');
    }
    
    /*******************************************************************
    Purpose: Test method for new Category creating/editing 
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void  testControllerForCategory(){
        TestingHelper ts =new TestingHelper();
        //create test data
        ts.prepareTestDataEnv();
        //start test for creating new asset
        Test.setCurrentPage(Page.WINatPOSNewCategory);
        Category__c initialCategory = new Category__c();
        Test.startTest();
        WINatPOSDropDownController cont=new WINatPOSDropDownController(new ApexPages.StandardController(initialCategory));
        List<selectOption> catList=cont.getParentCategories();
        Test.stopTest();
        //check if picklist for lookup fields are populated
        system.assertEquals(true, catList.size()>0);
        //
        system.assertEquals(true, cont.currentCategory != null, 'Category record should be initialized inside controller');
        
    }
    
    /*******************************************************************
    Purpose: Test method for new Brand creating/editing 
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void  testControllerForBrand(){
        TestingHelper ts =new TestingHelper();
        //create test data
        ts.prepareTestDataEnv();
        //start test for creating new asset
        Test.setCurrentPage(Page.WINatPOSNewBrand);
        Brand_Master__c initialBrand = new Brand_Master__c();
        Test.startTest();
        WINatPOSDropDownController cont=new WINatPOSDropDownController(new ApexPages.StandardController(initialBrand));
        List<selectOption> catList=cont.getCategories();
        Test.stopTest();
        //check if picklist for lookup fields are populated
        system.assertEquals(true, catList.size()>0);
        //
        system.assertEquals(true, cont.currentBrand != null, 'Brand record should be initialized inside controller');
        
    }
    
    /*******************************************************************
    Purpose: Test method for new Category Brands creating/editing 
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void  testControllerForCategoryBrand(){
        TestingHelper ts =new TestingHelper();
        //create test data
        ts.prepareTestDataEnv();
        //start test for creating new asset
        Test.setCurrentPage(Page.WINatPOSNewCategoryBrands);
        //Category Brand record created under Brand record
        String retUrl='/apex/WinAtPOSBrandView?id='+ts.finalTestBrands.get(0).id;
        ApexPages.currentPage().getParameters().put('retURL',retUrl);
        
        Category_Brands__c initialCategoryBrand = new Category_Brands__c();
        Category_Brands__c initialCategoryBrand1 = ts.finalCategoryBrand.get(0);
        Test.startTest();
        
        WINatPOSDropDownController cont=new WINatPOSDropDownController(new ApexPages.StandardController(initialCategoryBrand));
        WINatPOSDropDownController cont1=new WINatPOSDropDownController(new ApexPages.StandardController(initialCategoryBrand1));
        
        //Category Brand record created under Category record
        String retUrl1='/apex/WinatPOSCategoryView?id='+ts.finalTestCategory.get(0).id;
        ApexPages.currentPage().getParameters().put('retURL',retUrl1);
        WINatPOSDropDownController cont2=new WINatPOSDropDownController(new ApexPages.StandardController(initialCategoryBrand));
        
        List<selectOption> catList=cont.getCategories();
        List<selectOption> brandList=cont.getBrands();
        List<selectOption> catList1=cont1.getCategories();
        List<selectOption> brandList1=cont1.getBrands();
        Test.stopTest();
        //check if picklist for lookup fields are populated
        system.assertEquals(true, catList.size()>0);
        system.assertEquals(true, brandList.size()>0);
        system.assertEquals(true, catList1.size()>0);
        system.assertEquals(true, brandList1.size()>0);
        //
        system.assertEquals(true, cont.currentCategoryBrand != null, 'Category Brand record should be initialized inside controller');
        system.assertEquals(true, cont1.currentCategoryBrand != null, 'Category Brand record should be initialized inside controller');
        
    }
}