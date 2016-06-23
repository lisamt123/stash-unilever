/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_AgencyReviewCommentsExtension
@CreateDate : 20/9/2014
@Description : This is a Test class for AF_AgencyReviewCommentsExtension class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_AgencyReviewCommentsExtension_Test
{    
    Static Integer IcurrYear = System.Today().year()-1;
    Static string currYear=string.valueof(IcurrYear);
    static user AgencyReviewCommentsExtension;
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AFagencyReviewCommentsExtension
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AFagencyReviewCommentsExtension()
    {
        Test.startTest();
        AgencyReviewCommentsExtension = AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:AgencyReviewCommentsExtension.id LIMIT 1];
        System.runAs(u)
        { 
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
            List<Account> acctQuery = [SELECT id FROM account where id IN:acc LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEstimate=new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c loopbrandEst : BrandEst){
                loopbrandEst.AF_Fiscal_Year__c=currYear;
                loopbrandEst.AF_Pilot_Model__c=true;
                BrandEstimate.add(loopbrandEst);
            }
            insert BrandEstimate;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert controller Review.
            List<AF_Controller_Review__c> ControllerReview = AF_TestFactory_Helper.AfcontrollerReview(1,false);
            List<AF_Controller_Review__c> ControllerReviewlist=new List<AF_Controller_Review__c>();
            for(AF_Controller_Review__c controll : ControllerReview){
                controll.Controller_Group__c='Europe';
                controll.Review_Completed__c=true;
                ControllerReviewlist.add(controll);
            }
            insert ControllerReviewlist;
            List<AF_Controller_Review__c> ControllerReviewQuery = [SELECT Id,Brand_Estimate__c FROM AF_Controller_Review__c WHERE ID IN :ControllerReview LIMIT 1];
            System.assertEquals(ControllerReviewQuery[0].Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.CONTROLLERREVIEW_RECORD);
            ApexPages.currentPage().getParameters().put('id',brandEst[0].Id);   
            //Instantiating the class AF_AgencyReviewCommentsExtension 
            ApexPages.StandardController sc = new ApexPages.StandardController(brandEst[0]);
            AF_AgencyReviewCommentsExtension agencRevControl=new AF_AgencyReviewCommentsExtension (sc);
            agencRevControl.saveControllerReview();
            agencRevControl.checkReview=false;
            agencRevControl.saveControllerReview();
            Test.stopTest(); 
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AFagencyReviewCommentsExtension2
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AFagencyReviewCommentsExtension2()
    {
        Test.startTest();
        AgencyReviewCommentsExtension = AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:AgencyReviewCommentsExtension.id LIMIT 1];
        System.runAs(u)
        { 
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
            List<Account> acctQuery = [SELECT id FROM account where id IN:acc LIMIT 1];
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
            for(AF_Brand_Estimate__c loopbrandEst : BrandEst){
                loopbrandEst.AF_Fiscal_Year__c=currYear;
                loopbrandEst.AF_Pilot_Model__c=true;
                BrandEstlist.add(loopbrandEst);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert controller Review.
            List<AF_Controller_Review__c> ControllerReview = AF_TestFactory_Helper.AfcontrollerReview(1,false);
            List<AF_Controller_Review__c> ControllerReviewlist=new List<AF_Controller_Review__c>();
            for(AF_Controller_Review__c controll : ControllerReview){
                controll.Controller_Group__c='Europe';
                controll.Review_Completed__c=false;
                ControllerReviewlist.add(controll);
            }
            insert ControllerReviewlist;
            List<AF_Controller_Review__c> ControllerReviewQuery = [SELECT Id,Brand_Estimate__c FROM AF_Controller_Review__c WHERE ID IN :ControllerReview LIMIT 1];
            System.assertEquals(ControllerReviewQuery[0].Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.CONTROLLERREVIEW_RECORD);
            ApexPages.currentPage().getParameters().put('id',brandEst[0].Id);   
            //Instantiating the class AF_AgencyReviewCommentsExtension 
            ApexPages.StandardController sc = new ApexPages.StandardController(brandEst[0]);
            AF_AgencyReviewCommentsExtension agencRevControl=new AF_AgencyReviewCommentsExtension (sc);
            agencRevControl.saveControllerReview();
            agencRevControl.checkReview=false;
            agencRevControl.saveControllerReview();
            Test.stopTest(); 
        }
    }
}