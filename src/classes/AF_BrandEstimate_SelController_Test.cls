/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BrandEstimate_SelController_Test
@CreateDate : 2/10/2014
@Description : This is a Test class for AF_BrandEstimate_SelController class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_BrandEstimate_SelController_Test
{
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static Integer IcurrYear1 = System.Today().year()-1;
    Static string currYear1=string.valueof(IcurrYear1);
    static user userforBrandEstimatesel;
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : selController
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void selController()
    {
        Test.startTest();
        userforBrandEstimatesel=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforBrandEstimatesel.id LIMIT 1];
        System.runAs(u)
        { 
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
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
            List<AF_Brand_Estimate__c> BrandEstlist=new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br : BrandEst){
                br.AF_Fiscal_year__c=currYear1; 
                br.Brand__c=AFCategoryBrand[0].id;
                br.AF_Agency__c=acc[0].id;
                BrandEstlist.add(br);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            /* Adding parameters to page URL */
            //For Brand Id
            ApexPages.currentPage().getParameters().put('bId',cb[0].id);         
            //For Agency Id
            ApexPages.currentPage().getParameters().put('aId',acc[0].Id);
            //For Fiscal year
            ApexPages.currentPage().getParameters().put('fy',currYear1);   
            //Instantiate AF_OOPS_SelectionController  Class
            AF_BrandEstimate_SelController selCtrl=new AF_BrandEstimate_SelController();
            selCtrl.linkRed=BrandEstlist[0].id;
            Test.stopTest();
        }
    }
}