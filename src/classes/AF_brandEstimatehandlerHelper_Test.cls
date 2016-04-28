/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_brandEstimatehandlerHelper_Test
@CreateDate : 16/9/2014
@Description : This is a Test class for AF_brandEstimatehandlerHelper class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_brandEstimatehandlerHelper_Test
{ 
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    static user userforBrandEstimateController2;
    static user userforBrandEstimateController1;
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_brandEstimatehandlerHelper
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_brandEstimatehandlerHelper()
    {
        Test.startTest();
        userforBrandEstimateController2=AF_TestFactory_Helper.createUserAdmin2(true);
        User u=[SELECT id FROM user WHERE id=:userforBrandEstimateController2.id LIMIT 1];
        userforBrandEstimateController1=AF_TestFactory_Helper.createuser(true);
        User u1=[SELECT id FROM user WHERE id=:userforBrandEstimateController1.id LIMIT 1];
        System.runAs(u)
        { 
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            for(Account ac : acc){
                ac.published__c=true;
            }
            insert acc;
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT Name,AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
            set <string> brand=new set<string>();   
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br : BrandEst){
                br.AF_Status_Base_Fees__c=AF_Constants.CATEGORY_FINANCE;
                br.AF_Active__c=true;
                BrandEstlist.add(br);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist1 = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br : BrandEst1){
                br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                br.AF_Active__c=true;
                BrandEstlist1.add(br);
            }
            insert BrandEstlist1;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            //insert OOPs Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //controller review
            List<AF_Controller_Review__c> conrev =AF_TestFactory_Helper.AfcontrollerReview(1,true);
            List<AF_Controller_Review__c> conrev1 =AF_TestFactory_Helper.AfcontrollerReview1(1,true);
            List<AF_Controller_Review__c> conrevQuery = [SELECT ID ,Brand_Estimate__c FROM AF_Controller_Review__c WHERE ID IN : conrev LIMIT 1];
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist = new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Brand_Estimate__c=BrandEstlist1[0].id;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmatelist.add(agency);
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmatelist limit 1];
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
            List<AF_Bonus_Threshold__c> BonusThresholdlist=new List<AF_Bonus_Threshold__c>();
            for(AF_Bonus_Threshold__c bthrshold : BonusThreshold){
                bthrshold.Year__c=currYear;
                BonusThresholdlist.add(bthrshold);
            }
            insert BonusThresholdlist;
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Instantiate AF_BrandEstimateController  Class
            set <string> brands=new set<string>();
            brands.add(AFCategoryBrand[0].Name);
            AF_brandEstimatehandlerHelper.brandEstimatehandlerMethod(brands);
            AF_brandEstimatehandlerHelper.oopsActualhandlerMethod(brands);
            Test.stopTest();
        }
    }
     /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_brandEstimatehandlerHelper1
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_brandEstimatehandlerHelper1()
    {
        Test.startTest();
        userforBrandEstimateController2=AF_TestFactory_Helper.createUserAdmin2(true);
        User u=[SELECT id FROM user WHERE id=:userforBrandEstimateController2.id LIMIT 1];
        userforBrandEstimateController1=AF_TestFactory_Helper.createuser(true);
        User u1=[SELECT id FROM user WHERE id=:userforBrandEstimateController1.id LIMIT 1];
        System.runAs(u)
        { 
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
            for(Account ac : acc){
                ac.published__c=true;
            }
            insert acc;
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT Name,AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
            set <string> brand=new set<string>();   
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br : BrandEst){
                br.AF_Status_Base_Fees__c=AF_Constants.CATEGORY_FINANCE;
                br.AF_Active__c=true;
                BrandEstlist.add(br);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist1 = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br : BrandEst1){
                br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                br.AF_Active__c=true;
                BrandEstlist1.add(br);
            }
            insert BrandEstlist1;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            //insert OOPs Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
            List<AF_OOPS_Actual__c> OopsactualList1=new List<AF_OOPS_Actual__c>();
            for(AF_OOPS_Actual__c oops:OopsactualList ){
            oops.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
            OopsactualList1.add(oops);
            }
            insert OopsactualList1;
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //controller review
            List<AF_Controller_Review__c> conrev =AF_TestFactory_Helper.AfcontrollerReview(1,true);
            List<AF_Controller_Review__c> conrev1 =AF_TestFactory_Helper.AfcontrollerReview1(1,true);
            List<AF_Controller_Review__c> conrevQuery = [SELECT ID ,Brand_Estimate__c FROM AF_Controller_Review__c WHERE ID IN : conrev LIMIT 1];
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist = new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Brand_Estimate__c=BrandEstlist1[0].id;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmatelist.add(agency);
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmatelist limit 1];
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
            List<AF_Bonus_Threshold__c> BonusThresholdlist=new List<AF_Bonus_Threshold__c>();
            for(AF_Bonus_Threshold__c bthrshold : BonusThreshold){
                bthrshold.Year__c=currYear;
                BonusThresholdlist.add(bthrshold);
            }
            insert BonusThresholdlist;
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Instantiate AF_BrandEstimateController  Class
            set <string> brands=new set<string>();
            brands.add(AFCategoryBrand[0].Name);
            AF_brandEstimatehandlerHelper.brandEstimatehandlerMethod(brands);
            AF_brandEstimatehandlerHelper.oopsActualhandlerMethod(brands);
            Test.stopTest();
        }
    }
}