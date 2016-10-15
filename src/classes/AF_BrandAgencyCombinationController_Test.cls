/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BrandAgencyCombinationController_Test
@CreateDate : 12/9/2014
@Description : This is a Test class for AF_BrandAgencyCombinationController class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_BrandAgencyCombinationController_Test
{ 
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static Integer IcurrYear1 = System.Today().year()-1;
    Static string currYear1=string.valueof(IcurrYear1);
    static user userforBrandAgencyCombinationController;
    private static string year='Year';
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_BrandAgencyCombinationController
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_BrandAgencyCombinationController()
    {
        Test.startTest();
        userforBrandAgencyCombinationController=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforBrandAgencyCombinationController.id LIMIT 1];
        System.runAs(u)
        { 
            //Insert Account
            RecordType AccountRT = [select id,Name from RecordType where SobjectType='Account' and Name='Agency Fee' Limit 1];
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            List<Account> acclist=new List<Account>();
            for(Account Acco:acc){
                Acco.RecordTypeId=AccountRT.id;
                acclist.add(Acco);
            }
            insert acclist;
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstLst = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c Bst : BrandEst){
                Bst.AF_Adaptive__c=20;
                Bst.AF_Digital__c=20;
                Bst.AF_Traditional__c=20;    
                Bst.Brand__c=AFCategoryBrand[0].id;
                Bst.AF_Agency__c=acc[0].Id;
                Bst.AF_Fiscal_Year__c=currYear;
                Bst.AF_Cat_Finance_Approver_1__c=u.Id; 
                BrandEstLst.add(Bst);
            }
            insert BrandEstLst;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstLst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            ApexPages.currentPage().getParameters().put(year,currYear);  
            AF_BrandAgencyCombinationController brandAg=new AF_BrandAgencyCombinationController();
            brandAg.selectedoption=AFCategoryBrand[0].Id+'::'+AFCategoryBrand[0].Name;
            brandAg.selectedoptionAgency=acc[0].Id+'::'+acc[0].Name;
            brandAg.Save();
            brandAg.showSuccess=true;
            brandAg.showFailure=true;
            brandAg.closePopup();
            ApexPages.currentPage().getParameters().put(year,currYear1);  
            AF_BrandAgencyCombinationController brandAg1=new AF_BrandAgencyCombinationController();
            Test.stopTest(); 
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_BrandAgencyCombinationController1
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_BrandAgencyCombinationController1()
    {
        Test.startTest();
        userforBrandAgencyCombinationController=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforBrandAgencyCombinationController.id LIMIT 1];
        System.runAs(u)
        { 
            //Insert Account
            RecordType AccountRT = [select id,Name from RecordType where SobjectType='Account' and Name='Agency Fee' Limit 1];
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            List<Account> acclist=new List<Account>();
            for(Account Acco:acc){
                Acco.RecordTypeId=AccountRT.id;
                acclist.add(Acco);
            }
            insert acclist;
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);    
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstLst = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c Bst : BrandEst){
                Bst.AF_Adaptive__c=20;
                Bst.AF_Digital__c=20;
                Bst.AF_Traditional__c=20;    
                Bst.AF_Cat_Finance_Approver_1__c=u.Id; 
                BrandEstLst.add(Bst);
            }
            insert BrandEstLst;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstLst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            ApexPages.currentPage().getParameters().put(year,currYear);  
            AF_BrandAgencyCombinationController brandAg=new AF_BrandAgencyCombinationController();
            brandAg.selectedoption=AFCategoryBrand[0].Id+'::'+AFCategoryBrand[0].Name;
            brandAg.selectedoptionAgency=acc[0].Id+'::'+acc[0].Name;
            brandAg.Save();
            brandAg.closePopup();
            ApexPages.currentPage().getParameters().put(year,currYear1);  
            AF_BrandAgencyCombinationController brandAg1=new AF_BrandAgencyCombinationController();
            Test.stopTest(); 
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_BrandAgencyCombinationController2
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_BrandAgencyCombinationController2()
    {
        Test.startTest();
        userforBrandAgencyCombinationController=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforBrandAgencyCombinationController.id LIMIT 1];
        System.runAs(u)
        { 
            //Insert Account
            RecordType AccountRT = [select id,Name from RecordType where SobjectType='Account' and Name='Agency Fee' Limit 1];
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            List<Account> acclist=new List<Account>();
            for(Account Acco:acc){
                Acco.RecordTypeId=AccountRT.id;
                acclist.add(Acco);
            }
            insert acclist;
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);    
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstLst = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c Bst : BrandEst){
                Bst.AF_Adaptive__c=20;
                Bst.AF_Digital__c=20;
                Bst.AF_Traditional__c=20;    
                Bst.AF_Cat_Finance_Approver_1__c=u.Id; 
                BrandEstLst.add(Bst);
            }
            insert BrandEstLst;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstLst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            ApexPages.currentPage().getParameters().put(year,currYear);  
            AF_BrandAgencyCombinationController brandAg=new AF_BrandAgencyCombinationController();
            brandAg.Save();
            brandAg.closePopup();
            ApexPages.currentPage().getParameters().put(year,currYear1);  
            AF_BrandAgencyCombinationController brandAg1=new AF_BrandAgencyCombinationController();
            Test.stopTest(); 
        }
    }
}