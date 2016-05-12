@isTest(seeAllData=false)
public class AF_AdjustQuater_Homepage_lightbox_Test 
{  
    Private Static Integer IcurrYear = System.Today().year();
    Private Static string currYear=string.valueof(IcurrYear);
    private static String agencyFeesUserType = 'Agency';
    private static String Fyear = 'Year';
    Private static user usrforlightbox;
    Static testMethod void AF_adjustQuater_Homepage_lightbox()
    {
        Test.startTest();
        usrforlightbox = AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:usrforlightbox.id LIMIT 1];
        System.runAs(u)
        {
            
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            for(Account loopacc : acc){
                loopacc.published__c = true;
            }
            insert acc;
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null,AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.CATEGORY_RECORD);
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,true);
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c LIMIT 2]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            ApexPages.currentPage().getParameters().put('Category',AFCategoryBrand[0].id);
            ApexPages.currentPage().getParameters().put(Fyear,currYear);    
            AF_AdjustQuater_Homepage_lightbox adjHome=new AF_AdjustQuater_Homepage_lightbox();
            adjHome.saveBrandEstimate();
            adjHome.showPopup();
            adjHome.closePopup();
            Test.stopTest();
            
            
        }
    }
    Static testMethod void AF_adjustQuater_Homepage_lightbox1()
    {
        Test.startTest();
        usrforlightbox = AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:usrforlightbox.id LIMIT 1];
        System.runAs(u)
        {
            //insert Account.
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            for(Account loopacc : acc){
                loopacc.published__c = true;
            }
            insert acc;
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null,AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,false);
            for(AF_Category_Brand__c AFCate : Cb){
                AFCate.AF_Pilot_Model__c=false;
                AFCate.AF_Super_category__c = AF_Constants.TEST_SUPER_CATEGORY;
            }
            insert cb;
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
            // Insert BrandEstimate.
            List<AF_Brand_Estimate__c> BrandEstList = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstimateList = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c BrandEst : BrandEstList){
                BrandEst.AF_Basefee_Estimate_Initial_Quarter__c='Q1;Q2;Q3;Q4';
                BrandEst.AF_Status_Base_Fees__c=AF_Constants.CATEGORY_FINANCE; 
                BrandEst.AF_Fiscal_Year__c=currYear;
                BrandEst.AF_Pilot_Model__c=false;
                BrandEstimateList.add(BrandEst);
            }
            insert BrandEstimateList;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c LIMIT 2]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            
            List<AF_AdjustQuater_Homepage_lightbox.wrapChechbox> brandEstimateRecords=new List<AF_AdjustQuater_Homepage_lightbox.wrapChechbox>();
            ApexPages.currentPage().getParameters().put('Category',cb[0].id);
            ApexPages.currentPage().getParameters().put('brandEstimate',BrandEstList[0].id);
            ApexPages.currentPage().getParameters().put(Fyear,currYear);    
            AF_AdjustQuater_Homepage_lightbox adjHome=new AF_AdjustQuater_Homepage_lightbox();
            AF_AdjustQuater_Homepage_lightbox.wrapChechbox wr=new AF_AdjustQuater_Homepage_lightbox.wrapChechbox(BrandEstList[0],BrandEstList[0].Name,true,false,false,false);
            wr.Selected=true;
            brandEstimateRecords.add(wr);
            adjHome.QuarterEstimate=brandEstimateRecords;      
            adjHome.saveBrandEstimate();
            Test.stopTest();
        }
    }
    Static testMethod void AF_adjustQuater_Homepage_lightbox2()
    {
        Test.startTest();
        usrforlightbox = AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:usrforlightbox.id LIMIT 1];
        System.runAs(u)
        {
            //insert Account.
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            for(Account loopacc : acc){
                loopacc.published__c = true;
            }
            insert acc;
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null,AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,false);
            for(AF_Category_Brand__c AFCate : Cb){
                AFCate.AF_Pilot_Model__c=false;
                AFCate.AF_Super_category__c = AF_Constants.TEST_SUPER_CATEGORY;
            }
            insert cb;
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
            // Insert BrandEstimate.
            List<AF_Brand_Estimate__c> BrandEstList = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstimateList1 = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c BrandEst : BrandEstList){
                BrandEst.AF_Basefee_Estimate_Initial_Quarter__c='Q1;Q2;Q3;Q4';
                //BrandEst.AF_RaiseNewPOQuarters__c=AF_Constants.QUARTER4;
                BrandEst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;
                BrandEst.AF_Fiscal_Year__c=currYear;
                BrandEst.AF_Pilot_Model__c=false;
                //BrandEst.AF_BackupQuarter__c='Q1; Q2; Q3; Q4';
                BrandEstimateList1.add(BrandEst);
            }
            insert BrandEstimateList1;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c LIMIT 2]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            List<AF_AdjustQuater_Homepage_lightbox.wrapChechbox> brandEstimateRecords=new List<AF_AdjustQuater_Homepage_lightbox.wrapChechbox>();
            ApexPages.currentPage().getParameters().put('Category',cb[0].id);
            ApexPages.currentPage().getParameters().put(Fyear,currYear);    
            AF_AdjustQuater_Homepage_lightbox adjHome=new AF_AdjustQuater_Homepage_lightbox();
            AF_AdjustQuater_Homepage_lightbox.wrapChechbox wr=new AF_AdjustQuater_Homepage_lightbox.wrapChechbox(BrandEstList[0],BrandEstList[0].Name,true,true,true,true);
            wr.Selected=true;
            brandEstimateRecords.add(wr);
            adjHome.QuarterEstimate=brandEstimateRecords;      
            adjHome.showPopup();
            adjHome.saveBrandEstimate();
            Test.stopTest();
        }
    }
    Static testMethod void AF_adjustQuater_Homepage_lightbox3()
    {
        Test.startTest();
        usrforlightbox = AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:usrforlightbox.id LIMIT 1];
        System.runAs(u)
        {
            //insert Account.
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            for(Account loopacc : acc){
                loopacc.published__c = true;
            }
            insert acc;
            
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,false);
            for(AF_Category_Brand__c AFCate : Cb){
                AFCate.AF_Pilot_Model__c=false;
                AFCate.AF_Super_category__c = AF_Constants.TEST_SUPER_CATEGORY;
            }
            insert cb;
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
            //insert BrandEstimate.
            List<AF_Brand_Estimate__c> BrandEstList = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstimateList2 =new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c BrandEst : BrandEstList){
                //BrandEst.AF_Basefee_Estimate_Initial_Quarter__c='Q1;Q2;Q3;Q4';
                //BrandEst.AF_RaiseNewPOQuarters__c='3';
                BrandEst.AF_Fiscal_Year__c=currYear;
                BrandEst.AF_Pilot_Model__c=false;
                BrandEst.AF_Status_Base_Fees__c = AF_Constants.CATEGORY_FINANCE;
                BrandEstimateList2.add(BrandEst);
            }
            insert BrandEstimateList2;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c LIMIT 2]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRAND_RECORD);
            List<AF_AdjustQuater_Homepage_lightbox.wrapChechbox> brandEstimateRecords=new List<AF_AdjustQuater_Homepage_lightbox.wrapChechbox>();
            ApexPages.currentPage().getParameters().put('Category',Cb[0].id);
            ApexPages.currentPage().getParameters().put(Fyear,currYear);    
            AF_AdjustQuater_Homepage_lightbox adjHome=new AF_AdjustQuater_Homepage_lightbox();
            AF_AdjustQuater_Homepage_lightbox.wrapChechbox wr = new AF_AdjustQuater_Homepage_lightbox.wrapChechbox(BrandEstList[0],BrandEstList[0].Name,true,true,true,true);
            list<AF_Brand_Estimate__c> brlist=new list<AF_Brand_Estimate__c>();
            wr.Selected=true;
            adjHome.displaypopquarter=false;
            brandEstimateRecords.add(wr);
            adjHome.QuarterEstimate=brandEstimateRecords;      
            adjHome.showPopup();
            adjHome.saveBrandEstimate();
            adjHome.displayPopup=false;
            Test.stoptest();
        }
    }
}