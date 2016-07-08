/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_Brand_Controller_Review_Test
@CreateDate : 15/9/2014
@Description : This is a Test class for AF_Brand_Controller_Review class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_Brand_Controller_Review_Test 
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    static user userForBrandControllerReview;
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : brandControllerReview
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void brandControllerReview()
    {
        Test.startTest();
        userForBrandControllerReview=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userForBrandControllerReview.id LIMIT 1];
        System.runAs(u)
        { 
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
            List<Account> acctQuery = [SELECT id FROM account where id IN:acc LIMIT 1];
            System.Assert(acctQuery[0].Id != null,AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id,AF_TestFactory_Helper.BRAND_RECORD);
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist=new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br : BrandEst){
                br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_WIHTCMCO ;  
                br.AF_Basefee_Estimate_Initial_Quarter__c=AF_Constants.QUARTER4 ;  
                br.AF_Pilot_Model__c=false;
                BrandEstlist.add(br);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert controller Review.
            List<AF_Controller_Review__c> conrev =AF_TestFactory_Helper.AfcontrollerReview(1,true);
            List<AF_Controller_Review__c> conrev1 =AF_TestFactory_Helper.AfcontrollerReview1(1,true);
            List<AF_Controller_Review__c> conrevQuery = [SELECT ID ,Brand_Estimate__c FROM AF_Controller_Review__c WHERE ID IN : conrev LIMIT 1];
            System.assertEquals(conrev1!=null,conrevQuery[0].id!=null,AF_TestFactory_Helper.CONTROLLERREVIEW_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntity1 = AF_TestFactory_Helper.insertEntity3(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntityQuery[0].id!=null, AFEntity1!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,false);
            List<AF_Entity__c> AFUnileverEntitylist=new List<AF_Entity__c>();
            for(AF_Entity__c entity:AFUnileverEntity){
                entity.Controller_Group__c=AF_Constants.TEST_CURRENCY_COUNTRY;
                AFUnileverEntitylist.add(entity);
            }
            insert AFUnileverEntitylist;
            List<AF_Entity__c> AFUnileverEntity1 = AF_TestFactory_Helper.insertEntity4(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.AssertEquals(AFUnileverEntityQuery[0].Id != null,AFUnileverEntity1!=null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agenEst : AgencyEsitmate){
                agenEst.AF_Adaptation__c=324;
                agenEst.AF_Adaptation_Local__c=23;
                agenEst.AF_Digital__c=12;
                agenEst.AF_Digital_Local__c=12;
                agenEst.AF_Agency_Exchange_Rate__c=21;
                agenEst.AF_Traditional__c=46;
                agenEst.AF_Traditional_Local__c=23;  
                AgencyEsitmatelist.add(agenEst);   
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyEsitmate1 = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist1=new  List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agenEst : AgencyEsitmate1){
                agenEst.AF_Adaptation__c=324;
                agenEst.AF_Adaptation_Local__c=23;
                agenEst.AF_Digital__c=12;
                agenEst.AF_Digital_Local__c=12;
                agenEst.AF_Agency_Exchange_Rate__c=21;
                agenEst.AF_Traditional__c=46;
                agenEst.AF_Traditional_Local__c=23; 
                AgencyEsitmatelist1.add(agenEst);    
            }
            insert AgencyEsitmatelist1;
            brandEst[0].AF_Fiscal_Year__c=currYear ;
            update brandEst;
            Set<Id> brandEstIdSet=new Set<Id>();
            brandEstIdSet.add(brandEst[0].Id);
            AF_Brand_Controller_Review brandCtrlRev=new AF_Brand_Controller_Review();
            brandCtrlRev.Create_Review(brandEstIdSet);
            Test.stopTest();
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : brandControllerReview1
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void brandControllerReview1()
    {
        Test.startTest();
        userForBrandControllerReview=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userForBrandControllerReview.id LIMIT 1];
        System.runAs(u)
        { 
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
            List<Account> acctQuery = [SELECT id FROM account where id IN:acc LIMIT 1];
            System.Assert(acctQuery[0].Id != null,AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id,AF_TestFactory_Helper.BRAND_RECORD);
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist=new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br : BrandEst){
                br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_WIHTCMCO;  
                BrandEstlist.add(br);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstlist LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntity1 = AF_TestFactory_Helper.insertEntity3(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntityQuery[0].id!=null, AFEntity1!=null,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,false);
            List<AF_Entity__c> AFUnileverEntitylist=new List<AF_Entity__c>();
            for(AF_Entity__c entity:AFUnileverEntity){
                entity.Controller_Group__c=AF_Constants.TEST_CURRENCY_COUNTRY;
                AFUnileverEntitylist.add(entity);
            }
            insert AFUnileverEntitylist;
            List<AF_Entity__c> AFUnileverEntity1 = AF_TestFactory_Helper.insertEntity4(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity1 LIMIT 1];
            System.Assert(AFUnileverEntityQuery!= null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //insert controller Review.
            List<AF_Controller_Review__c> conrev =AF_TestFactory_Helper.AfcontrollerReview(1,false);
            List<AF_Controller_Review__c> conrevlist=new List<AF_Controller_Review__c>();
            for(AF_Controller_Review__c contr:conrev){
                contr.Review_Completed__c=false;
                contr.Brand_Estimate__c=BrandEstlist[0].id;
                conrevlist.add(contr);
            }
            insert conrevlist;
            List<AF_Controller_Review__c> conrevQuery = [SELECT ID ,Brand_Estimate__c FROM AF_Controller_Review__c WHERE ID IN : conrev  LIMIT 1];
            System.assertEquals(conrevQuery[0].Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.CONTROLLERREVIEW_RECORD);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agenEst : AgencyEsitmate){
                agenEst.AF_Adaptation__c=324;
                agenEst.AF_Adaptation_Local__c=23;
                agenEst.AF_Digital__c=12;
                agenEst.AF_Digital_Local__c=12;
                agenEst.AF_Agency_Exchange_Rate__c=21;
                agenEst.AF_Traditional__c=46;
                agenEst.AF_Traditional_Local__c=23;  
                AgencyEsitmatelist.add(agenEst);   
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyEsitmate1 = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist1=new  List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agenEst : AgencyEsitmate1){
                agenEst.AF_Adaptation__c=324;
                agenEst.AF_Adaptation_Local__c=23;
                agenEst.AF_Digital__c=12;
                agenEst.AF_Digital_Local__c=12;
                agenEst.AF_Agency_Exchange_Rate__c=21;
                agenEst.AF_Traditional__c=46;
                agenEst.AF_Traditional_Local__c=23; 
                AgencyEsitmatelist1.add(agenEst);    
            }
            insert AgencyEsitmatelist1;
            BrandEst[0].AF_Fiscal_Year__c=currYear ;
            update BrandEstlist;
            Set<Id> brandEstIdSet=new Set<Id>();
            AF_Brand_Controller_Review brandCtrlRev=new AF_Brand_Controller_Review();
            brandCtrlRev.Create_Review(brandEstIdSet);
            Test.stopTest();
        }
    }
}