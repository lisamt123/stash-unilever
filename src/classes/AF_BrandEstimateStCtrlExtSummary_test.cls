/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BrandEstimateStCtrlExtSummary
@CreateDate : 8/9/2014
@Description : This is a Test class for AF_BrandEstimateStCtrlExtSummary class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(seeAllData=false)
public class AF_BrandEstimateStCtrlExtSummary_test
{
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    static user userforBrandEstimateCtrlExtsummary;
    static string current_year='2015';
    static string current_fiscalyear=String.valueOf(Date.Today().year());
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : afBrandEstimateStCtrlExtSummary
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AfBrandEstimateStCtrlExtSummary1()
    {
        Test.startTest();
        userforBrandEstimateCtrlExtsummary=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforBrandEstimateCtrlExtsummary.id LIMIT 1];
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
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            //Insert Brand estimate
            List<AF_Brand_Estimate__c> AFBrandlist = AF_TestFactory_Helper.insertAFBrandEstList(1,true);
            List<AF_Brand_Estimate__c> brandQuerylist = [SELECT Brand__c FROM AF_Brand_Estimate__c LIMIT 1];
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist =new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br : BrandEst){
                br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;
                br.AF_Cat_Finance_Approver_1__c=u.id;
                br.AF_Active__c=true;
                br.AF_Fiscal_Year__c=current_fiscalyear;
                BrandEstlist.add(br); 
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert OOPS Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity1 = AF_TestFactory_Helper.insertEntity3(1,true);
            List<AF_Entity__c> AFEntityQuery1 = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity1 LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity1 = AF_TestFactory_Helper.insertEntity4(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery1 = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity1 LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmate1=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                agency.AF_Agency_Entity__c=AFEntityQuery1[0].id;
                agency.AF_Unilever_Entity__c=AFUnileverEntityQuery[0].id;
                agency.AF_Fiscal_Year__c=current_fiscalyear;
                agency.AF_Brand_Estimate__c=BrandEstlist[0].id;
                AgencyEsitmate1.add(agency);
            }
            insert AgencyEsitmate1;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            // insert agency estimate
            List<AF_Agency_Estimate__c> AGENCYestimateList = AF_TestFactory_Helper.insertAgencyEstimate1(1,true);
            List<AF_Agency_Estimate__c> AGENCYestimateQuery =[SELECT ID,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE AF_Brand_Estimate__c IN :brandQuerylist LIMIT 1];
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //Insert Bonus Summary
            List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummary LIMIT 1];
            System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id, AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Insert Bonus Results 
            List<AF_Bonus_Results__c> AFBonusRes = AF_TestFactory_Helper.insertBonusResults(1,true);
            List<AF_Bonus_Results__c> AFBonusResQuery = [Select AF_Bonus_Thresholds__c from AF_Bonus_Results__c where Id IN:AFBonusRes LIMIT 1];
            System.assertEquals(AFBonusResQuery[0].AF_Bonus_Thresholds__c,BonusThresholdQuery[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            //Insert Bonus Matrix
            List<AF_Bonus_Matrix__c> AFBonusMat = AF_TestFactory_Helper.insertBonusMatrix(1,false);
            List<AF_Bonus_Matrix__c> AFBonusMat1=new List<AF_Bonus_Matrix__c> ();
            for(AF_Bonus_Matrix__c bm : AFBonusMat){
                bm.AF_Value__c=55;
                bm.AF_Base_Fee_Country_Total__c =35353;
                bm.AF_BonusableFee__c=86588;  
                AFBonusMat1.add(bm); 
            }
            insert AFBonusMat1;
            List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMat LIMIT 1];
            System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id, AF_TestFactory_Helper.BONUSMATRIX_RECORD);
            //Insert comments.
            List<AF_Comments__c> commentsLst = AF_TestFactory_Helper.insertcomments(1,true);
            List<AF_comments__c> commentsLstQuery = [SELECT Id,AF_Brand_Estimate__c FROM AF_comments__c WHERE ID IN :commentsLst LIMIT 1];
            system.assertEquals(commentsLstQuery[0].AF_Brand_Estimate__c,BrandEst[0].Id,AF_TestFactory_Helper.COMMENT_RECORD);
            //insert controller Review.
            List<AF_Controller_Review__c> controllerReviewLst = AF_TestFactory_Helper.AfcontrollerReview(1,false);
            List<AF_Controller_Review__c> controllerReviewLst1=new List<AF_Controller_Review__c>();
            for(AF_controller_Review__c  cr : controllerReviewLst){
                cr.Controller_Group__c = 'LATAM';
                cr.Review_Completed__c = true;
                controllerReviewLst1.add(cr);
            }
            insert controllerReviewLst1;
            List<AF_Controller_Review__c> controllerReviewLstQuery = [SELECT Id,Brand_Estimate__c FROM AF_Controller_Review__c WHERE ID IN : controllerReviewLst LIMIT 1];
            System.assertEquals(controllerReviewLstQuery[0].Brand_Estimate__c,BrandEst[0].Id ,AF_TestFactory_Helper.CONTROLLERREVIEW_RECORD);
            ApexPages.StandardController sc = new ApexPages.StandardController(brandEst[0]);
            ApexPages.currentPage().getParameters().put('id',brandEst[0].id); 
            AF_BrandEstimateStCtrlExtSummary bes=new AF_BrandEstimateStCtrlExtSummary(sc);  
            bes.financialYear=current_year;
            bes.getbrandEstimateDetailList();      
            bes.categoryStr='Test Beverages1::'+cb[0].Id;
            bes.changeCatName();
            Test.stopTest(); 
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : afBrandEstimateStCtrlExtSummary2
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void afBrandEstimateStCtrlExtSummary2()
    {
        Test.startTest();
        userforBrandEstimateCtrlExtsummary=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforBrandEstimateCtrlExtsummary.id LIMIT 1];
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
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist =new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br : BrandEst){
                br.AF_Traditional__c=23;
                br.AF_Digital__c=23;
                br.AF_Adaptive__c=23;
                br.AF_Active__c=true;
                br.AF_Fiscal_Year__c=currYear;
                BrandEstlist.add(br); 
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert OOPS Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmate1=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY ;
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmate1.add(agency);
            }
            insert AgencyEsitmate1;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //Insert Bonus Summary
            List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,true);
            List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummary LIMIT 1];
            System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id, AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Insert Bonus Results 
            List<AF_Bonus_Results__c> AFBonusRes = AF_TestFactory_Helper.insertBonusResults(1,true);
            List<AF_Bonus_Results__c> AFBonusResQuery = [Select AF_Bonus_Thresholds__c from AF_Bonus_Results__c where Id IN:AFBonusRes LIMIT 1];
            System.assertEquals(AFBonusResQuery[0].AF_Bonus_Thresholds__c,BonusThresholdQuery[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            //Insert Bonus Matrix
            List<AF_Bonus_Matrix__c> AFBonusMat = AF_TestFactory_Helper.insertBonusMatrix(1,false);
            List<AF_Bonus_Matrix__c> AFBonusMat1=new List<AF_Bonus_Matrix__c>();
            for(AF_Bonus_Matrix__c bm : AFBonusMat){
                bm.AF_Value__c=decimal.valueOf(5500);
                bm.AF_Base_Fee_Country_Total__c =35353;
                bm.AF_BonusableFee__c=86588;   
                AFBonusMat1.add(bm);
            }
            insert AFBonusMat1;
            List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMat LIMIT 1];
            System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id, AF_TestFactory_Helper.BONUSMATRIX_RECORD);
            //Insert comments.
            List<AF_Comments__c> commentsLst = AF_TestFactory_Helper.insertcomments(1,true);
            List<AF_comments__c> commentsLstQuery = [SELECT Id,AF_Brand_Estimate__c FROM AF_comments__c WHERE ID IN :commentsLst LIMIT 1];
            system.assertEquals(commentsLstQuery[0].AF_Brand_Estimate__c,BrandEst[0].Id,AF_TestFactory_Helper.COMMENT_RECORD);
            //insert controller Review.
            List<AF_Controller_Review__c> controllerReviewLst = AF_TestFactory_Helper.AfcontrollerReview(1,false);
            List<AF_Controller_Review__c> controllerReviewLst1=new List<AF_Controller_Review__c>();
            for(AF_controller_Review__c  cr : controllerReviewLst){
                cr.Controller_Group__c = 'LATAM';
                cr.Review_Completed__c = true;
                controllerReviewLst1.add(cr);
            }
            insert controllerReviewLst1;
            List<AF_Controller_Review__c> controllerReviewLstQuery = [SELECT Id,Brand_Estimate__c FROM AF_Controller_Review__c WHERE ID IN : controllerReviewLst LIMIT 1];
            System.assertEquals(controllerReviewLstQuery[0].Brand_Estimate__c,BrandEst[0].Id ,AF_TestFactory_Helper.CONTROLLERREVIEW_RECORD);
            ApexPages.StandardController sc = new ApexPages.StandardController(brandEst[0]);
            ApexPages.currentPage().getParameters().put('id',brandEst[0].id);         
            //Instantiating the Class AFBrandEstimateStCtrlExtSummary    
            AF_BrandEstimateStCtrlExtSummary bes=new AF_BrandEstimateStCtrlExtSummary(sc);  
            bes.financialYear=current_fiscalyear;
            bes.getbrandEstimateDetailList(); 
            bes.categoryStr='Test Beverages2::'+cb[0].Id;
            bes.changeCatName();
            Test.stopTest(); 
        }
    }
}