/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_ApprovalProcessForBrandEstController_TEST
@CreateDate : 12/9/2014
@Description : This is a Test class for AF_ApprovalProcessForBrandEstController class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_ApprovalProcessForBrandEstContro_Test 
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    static user usrforapprovalProcessForBrandEst;
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : approvalProcessForBrandEstController
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_approvalProcessForBrandEstController()
    {
        Test.startTest();
        usrforapprovalProcessForBrandEst=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:usrforapprovalProcessForBrandEst.id LIMIT 1];
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
            for(AF_Brand_Estimate__c Brand:BrandEst ){
            Brand.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_WITH_AGENCY;
            BrandEstlist.add(Brand);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Dummyuser Custom settings
            List<DummyUser__c> duuser = AF_TestFactory_Helper.createDummyUser(true);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert controller review
            List<AF_Controller_Review__c> AFCurrenc = AF_TestFactory_Helper.AfcontrollerReview(1,true);
            List<AF_Controller_Review__c> AFCurrencyQuer = [SELECT Id FROM AF_Controller_Review__c where Id IN:AFCurrenc LIMIT 1];
            System.Assert(AFCurrencyQuer[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert agency estimate
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Adaptation_Local__c=23;
                agency.AF_Adaptation__c=324;
                agency.AF_Digital__c=12;
                agency.AF_Digital_Local__c=12;
                agency.AF_Agency_Exchange_Rate__c=21;
                agency.AF_Traditional__c=46;
                agency.AF_Traditional_Local__c=23;
                agency.AF_Brand_Estimate__c=BrandEst[0].id;
                AgencyEsitmatelist.add(agency);  
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            AF_Brand_Estimate__c BrandEstRecord=[select id,AF_Pilot_Model__c,AF_No_Bonus__c,AF_Basefee_Estimate_Initial_Quarter__c,AF_Category_Finance_Flag__c,Brand__c,AF_Fiscal_Year__c,AF_Category_Finance_Approved__c,AF_CMCO_Rejected__c,AF_Status_Base_Fees__c,AF_Agency__c,AF_Controller_Flag__c,ExceptionsComplete__c,AF_No_of_Central_Billing__c from AF_Brand_Estimate__c  where id=:brandEst[0].Id  limit 1 ];
            ApexPages.currentPage().getParameters().put('id',brandEst[0].id); 
            List<AggregateResult> AgencyEstimateTotalCountByCountry = [SELECT SUM(AF_Total__c) CountryTotal,AF_Unilever_Entity__r.AF_Country__c CountryName FROM AF_Agency_Estimate__c  where AF_Brand_Estimate__c=: brandEst[0].Id GROUP BY AF_Unilever_Entity__r.AF_Country__c];
            List<AF_Bonus_Threshold__c> BonusThresholdCollection = [Select a.Year__c,a.Country_Name__c, a.SystemModstamp, a.OwnerId, a.Name, a.LastViewedDate,  a.Id,a.Brand_Name__c, a.Bonus_Measure__c, a.Agency_Name__c, a.AF_Unique_Thresholds__c, a.AF_Traditional__c, a.AF_Stretching__c, a.AF_Pilot_Model__c, a.AF_Outstanding__c, a.AF_Minimum__c, a.AF_Digital__c, a.AF_Country__c, a.AF_Country_Full_Name__c, a.AF_Category__c, a.AF_Brand_Estimate__c, a.AF_Bonusable_Fee__c From AF_Bonus_Threshold__c a where Agency_Name__c=:brandEst[0].AF_Agency__c and Brand_Name__c=:brandEst[0].Brand__c and Year__c =: brandEst[0].AF_Fiscal_Year__c ];
            AF_ApprovalProcessForBrandEstController approvProceBrandEst=new AF_ApprovalProcessForBrandEstController();
            approvProceBrandEst.BrandEstRecord=BrandEstRecord;
            approvProceBrandEst.RejectBrandEstComment();
            approvProceBrandEst.RejectBrandWithComments();
            approvProceBrandEst.ApproveRecord();
            approvProceBrandEst.RejectRecord();
            approvProceBrandEst.closePopupReject();
            approvProceBrandEst.closePopup();
            approvProceBrandEst.closePopupRejComment();
            approvProceBrandEst.showPopup();
            approvProceBrandEst.SubmitApprovalPopup();
            approvProceBrandEst.Submit();
            approvProceBrandEst.SubitforApproval();
            approvProceBrandEst.TempConstructor();
            approvProceBrandEst.closeApprovalPopup();
            approvProceBrandEst.RejectBrandestiamteFinance();
            approvProceBrandEst.ApproveBrandEst();
            approvProceBrandEst.RejectBrandEst();
            approvProceBrandEst.TrueControllerFlag();
            approvProceBrandEst.changeBrandStatus();
        }
    }
      /***********************************************************************************
*  @Description: this method will the test data
*  @name : approvalProcessForBrandEstController1
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_approvalProcessForBrandEstController1()
    {
        Test.startTest();
        usrforapprovalProcessForBrandEst=AF_TestFactory_Helper.createUserAdmin2(true);
        User u=[SELECT id FROM user WHERE id=:usrforapprovalProcessForBrandEst.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,true);
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert controller review
            List<AF_Controller_Review__c> AFCurrenc = AF_TestFactory_Helper.AfcontrollerReview(1,false);
            List<AF_Controller_Review__c> AFCurrenclist=new List<AF_Controller_Review__c>();
            for(AF_Controller_Review__c contr:AFCurrenc ){
            contr.Brand_Estimate__c=BrandEst[0].id;
            AFCurrenclist.add(contr);
            }
            insert AFCurrenclist;
            List<AF_Controller_Review__c> AFCurrencyQuer = [SELECT Id FROM AF_Controller_Review__c where Id IN:AFCurrenc LIMIT 1];
            System.Assert(AFCurrencyQuer[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert agency estimate
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Adaptation_Local__c=23;
                agency.AF_Adaptation__c=324;
                agency.AF_Digital__c=12;
                agency.AF_Digital_Local__c=12;
                agency.AF_Agency_Exchange_Rate__c=21;
                agency.AF_Traditional__c=46;
                agency.AF_Traditional_Local__c=23;
                agency.AF_Brand_Estimate__c=BrandEst[0].id;
                AgencyEsitmatelist.add(agency);  
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            AF_Brand_Estimate__c BrandEstRecord=[select id,AF_Pilot_Model__c,AF_No_Bonus__c,AF_Basefee_Estimate_Initial_Quarter__c,AF_Category_Finance_Flag__c,Brand__c,AF_Fiscal_Year__c,AF_Category_Finance_Approved__c,AF_CMCO_Rejected__c,AF_Status_Base_Fees__c,AF_Agency__c,AF_Controller_Flag__c,ExceptionsComplete__c,AF_No_of_Central_Billing__c from AF_Brand_Estimate__c  where id=:brandEst[0].Id  limit 1 ];
            ApexPages.currentPage().getParameters().put('id',brandEst[0].id); 
            List<AggregateResult> AgencyEstimateTotalCountByCountry = [SELECT SUM(AF_Total__c) CountryTotal,AF_Unilever_Entity__r.AF_Country__c CountryName FROM AF_Agency_Estimate__c  where AF_Brand_Estimate__c=: brandEst[0].Id GROUP BY AF_Unilever_Entity__r.AF_Country__c];
            List<AF_Bonus_Threshold__c> BonusThresholdCollection = [Select a.Year__c,a.Country_Name__c, a.SystemModstamp, a.OwnerId, a.Name, a.LastViewedDate,  a.Id,a.Brand_Name__c, a.Bonus_Measure__c, a.Agency_Name__c, a.AF_Unique_Thresholds__c, a.AF_Traditional__c, a.AF_Stretching__c, a.AF_Pilot_Model__c, a.AF_Outstanding__c, a.AF_Minimum__c, a.AF_Digital__c, a.AF_Country__c, a.AF_Country_Full_Name__c, a.AF_Category__c, a.AF_Brand_Estimate__c, a.AF_Bonusable_Fee__c From AF_Bonus_Threshold__c a where Agency_Name__c=:brandEst[0].AF_Agency__c and Brand_Name__c=:brandEst[0].Brand__c and Year__c =: brandEst[0].AF_Fiscal_Year__c ];
            AF_ApprovalProcessForBrandEstController approvProceBrandEst=new AF_ApprovalProcessForBrandEstController();
            approvProceBrandEst.BrandEstRecord=BrandEstRecord;
            approvProceBrandEst.RejectBrandEstComment();
            approvProceBrandEst.RejectBrandWithComments();
            approvProceBrandEst.ApproveRecord();
            approvProceBrandEst.RejectRecord();
            approvProceBrandEst.closePopupReject();
            approvProceBrandEst.closePopup();
            approvProceBrandEst.closePopupRejComment();
            approvProceBrandEst.showPopup();
            approvProceBrandEst.SubmitApprovalPopup();
            //approvProceBrandEst.Submit();
            approvProceBrandEst.SubitforApproval();
            approvProceBrandEst.TempConstructor();
            approvProceBrandEst.closeApprovalPopup();
            approvProceBrandEst.RejectBrandestiamteFinance();
            approvProceBrandEst.ApproveBrandEst();
            approvProceBrandEst.RejectBrandEst();
            approvProceBrandEst.TrueControllerFlag();
            approvProceBrandEst.changeBrandStatus();
        }
    }
}