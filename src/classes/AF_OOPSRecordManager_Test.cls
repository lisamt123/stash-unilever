/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_OOPSRecordManager
@Created Date : 08/08/2014.
@Description : This Test class for  AF_OOPSRecordManager  apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_OOPSRecordManager_Test
{ 
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    static user userforoopsRecordManager;
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : oopsRecordManager
*  @param : none
*  @return : none
*************************************************************************/ 
    Static testMethod void oopsRecordManager()
    {
        Test.startTest();
        userforoopsRecordManager=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforoopsRecordManager.id LIMIT 1];
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
            //insert oops setting.
            List<AF_OOPS_Settings__c> oopsettingLst = AF_TestFactory_Helper.insertOOPsetting(true,1);
            List<AF_OOPS_Settings__c> oopsettingLstQuery = [SELECT Id FROM AF_OOPS_Settings__c LIMIT 1];
            Set<Id> brandEstSet=new Set<Id>();
            brandEstSet.add(brandEst[0].Id);
            List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList(1,true);
            List<AF_Brand_Estimate__c> BrandEst1Query =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst1 LIMIT 1]; 
            System.assertEquals(BrandEst1Query[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            brandEstSet.add(brandEst1[0].Id);
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
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Brand_Estimate__c=BrandEst1Query[0].id;
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                AgencyEsitmatelist.add(agency);
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst1[0].id, AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            List<AF_OOPS_Actual__c> OopsactualList1 = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery1 = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList1 LIMIT 1];
            System.assertEquals(OopsactualListQuery1[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList1 = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery1 =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList1 LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery1[0].AF_OOPS_Actual__c, OopsactualList1[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            AF_OOPSRecordManager oopsRecMan=new AF_OOPSRecordManager();
            AF_OOPSRecordManager oopsRecMan1=new AF_OOPSRecordManager(brandEst[0]);
            AF_OOPSRecordManager oopsRecMan2=new AF_OOPSRecordManager(brandEstSet);
            oopsRecMan.bulkRecalculateOOPSEstimates();
            oopsRecMan2.bulkOOPSEstimateCollection=OOPSEstimateList1;
            oopsRecMan2.MatrixErrorMessage=OOPSEstimateList1[0].id;
            oopsRecMan2.IsMatrixError=true;
            oopsRecMan2.bulkLoadOOPSEstimateRecordsByCollection();
            oopsRecMan2.CreateOOPSEstimateRecordsByCollection();
            oopsRecMan2.RecalculateOOPSEstimates();
            oopsRecMan2.DeleteOOPSActualRecordsByCollection();
            Test.stopTest();
        }
    }
}