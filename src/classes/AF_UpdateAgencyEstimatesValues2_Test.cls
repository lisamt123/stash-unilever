/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_UpdateBonusEstimatesValues5_Test
@Created Date : 05/08/2014.
@Description : This Test class for AF_UpdateBonusEstimatesValues5  apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_UpdateAgencyEstimatesValues2_Test
{
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    Static Integer IcurrYear1 = System.Today().year();
    Static string currYear1=string.valueof(IcurrYear1); 
    static user userforupdatebonusEstimatevalues2;
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : UpdateBonusEstimates
*  @param : none
*  @return : none
*************************************************************************/  
    Static testMethod void UpdateBonusEstimates()
    {
        Test.startTest();
        userforupdatebonusEstimatevalues2 =AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforupdatebonusEstimatevalues2.id LIMIT 1];
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
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id, AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,false);
            List<AF_Currency__c> AFCurrencylist=new List<AF_Currency__c>();
            for(AF_Currency__c curr:AFCurrency){
                curr.Locked__c=false;
                curr.AF_Currency_Code__c=AF_Constants.AF_CURRENCY_USD;
                curr.AF_Fiscal_Year_new__c=currYear1;
                curr.AF_Average_Exchange_Rate_To_EUR__c=123;
                AFCurrencylist.add(curr);
            }
            insert AFCurrencylist;
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            list<AF_Agency_Estimate__c> agencylist=new list<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_WIHTCMCO;
                agency.AF_Agency_Spot_Rate__c=22;
                agency.AF_Fiscal_Year__c=currYear1;
                agency.AF_Agency_Exchange_Rate__c=99;
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                agencylist.add(agency);
            }
            insert agencylist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
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
            List<AF_Bonus_Matrix__c> AFBonusMat = AF_TestFactory_Helper.insertBonusMatrix(1,true);
            List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMat LIMIT 1];
            System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id, AF_TestFactory_Helper.BONUSMATRIX_RECORD);
            List<AF_Bonus_Matrix__c> bonMatrixList=new List<AF_Bonus_Matrix__c>();
            bonMatrixList.add(AFBonusMat[0]);
            //insert Matrix Table.
            List<AF_Matrix_Table__c> MatrixTableList = AF_TestFactory_Helper.insertmatrixtable(1,true);
            List<AF_Matrix_Table__c> MatrixTableListQuery = [SELECT Id FROM AF_Matrix_Table__c where id IN:MatrixTableList LIMIT 1];
            system.assert(MatrixTableListQuery[0].Id!=null ,AF_TestFactory_Helper.MATRIX_RECORD);
            AF_UpdateAgencyEstimatesValues2.UpdateExchageRates(agencylist);
        }
    }
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : UpdateBonusEstimates1
*  @param : none
*  @return : none
*************************************************************************/  
    Static testMethod void UpdateBonusEstimates1()
    {
        Test.startTest();
        userforupdatebonusEstimatevalues2 =AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforupdatebonusEstimatevalues2.id LIMIT 1];
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
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id, AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,false);
            List<AF_Currency__c> AFCurrencyQuerylist =new List<AF_Currency__c>();
            for(AF_Currency__c curr:AFCurrency){
                curr.Locked__c=false;
                curr.Country_Currency__c=AF_Constants.TEST_UNILEVER_ENTITY_COUNTRY;
                curr.AF_Currency_Code__c=AF_Constants.AF_CURRENCY_EUR;
                curr.Ready_For_PO_Exchange_Rate_To_EUR__c=345;
                curr.AF_Fiscal_Year_new__c=currYear;
                AFCurrencyQuerylist.add(curr);
            }
            insert AFCurrencyQuerylist;
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrencyQuerylist LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Country__c, AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id,AF_Country__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            list<AF_Agency_Estimate__c> agencylist=new list<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_READYFORPO;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                agency.AF_Agency_Spot_Rate__c=12;
                agency.AF_Agency_Exchange_Rate__c=123;
                agency.Indicative_Gain_in_USD__c=1234;
                agencylist.add(agency);
            }
            insert agencylist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
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
            List<AF_Bonus_Matrix__c> AFBonusMat = AF_TestFactory_Helper.insertBonusMatrix(1,true);
            List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMat LIMIT 1];
            System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id, AF_TestFactory_Helper.BONUSMATRIX_RECORD);
            List<AF_Bonus_Matrix__c> bonMatrixList=new List<AF_Bonus_Matrix__c>();
            bonMatrixList.add(AFBonusMat[0]);
            // insert Matrix Table.
            List<AF_Matrix_Table__c> MatrixTableLst =AF_TestFactory_Helper.insertmatrixtable(1,false);
            List<AF_Matrix_Table__c> MatrixTableList =new List<AF_Matrix_Table__c>();
            for(AF_Matrix_Table__c matrix:MatrixTableLst){
                matrix.AF_Matrix_Country__c=AF_Constants.TEST_UNILEVER_ENTITY_COUNTRY;
                matrix.AF_Matrix_Currency_Code__c=AF_Constants.TEST_UNILEVER_ENTITY_COUNTRY;
                matrix.AF_Ready_For_PO_Country__c=AF_Constants.TEST_CURRENCY_COUNTRY ;
                matrix.AF_Ready_For_PO_Currency_Code__c=AF_Constants.TEST_COUNTRY_CODE;
                matrix.Ready_For_PO_Conversion__c=AF_Constants.AF_CURRENCY_USD;
                matrix.AF_Unilver_Country__c=AFUnileverEntityQuery[0].AF_Country__c;
                matrix.AF_Agency_Country__c=AFEntityQuery[0].AF_Country__c;
                MatrixTableList.add(matrix);
            }
            insert MatrixTableList;
            List<AF_Matrix_Table__c> MatrixTableLstQuery = [SELECT ID FROM AF_Matrix_Table__c  WHERE ID IN:MatrixTableList  LIMIT 1];
            System.assert(MatrixTableLstQuery[0]!=null,AF_TestFactory_Helper.MATRIX_RECORD);
            //insert matrix table
            List<AF_Matrix_Table__c> MatrixTableList1 = AF_TestFactory_Helper.insertmatrixtable(1,true);
            List<AF_Matrix_Table__c> MatrixTableListQuery1 = [SELECT Id FROM AF_Matrix_Table__c where id IN:MatrixTableList1 LIMIT 1];
            system.assert(MatrixTableListQuery1[0].Id!=null ,AF_TestFactory_Helper.MATRIX_RECORD);
            AF_UpdateAgencyEstimatesValues2.UpdateExchageRates(agencylist);
        }
    }
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : UpdateBonusEstimates2
*  @param : none
*  @return : none
*************************************************************************/ 
     Static testMethod void UpdateBonusEstimates2()
    {
        Test.startTest();
        userforupdatebonusEstimatevalues2 =AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforupdatebonusEstimatevalues2.id LIMIT 1];
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
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id, AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,false);
            List<AF_Currency__c> AFCurrencyQuerylist =new List<AF_Currency__c>();
            for(AF_Currency__c curr:AFCurrency){
                curr.Locked__c=false;
                curr.Country_Currency__c=AF_Constants.TEST_UNILEVER_ENTITY_COUNTRY;
                curr.AF_Currency_Code__c=AF_Constants.AF_CURRENCY_GBP;
                curr.Ready_For_PO_Exchange_Rate_To_EUR__c=345;
                curr.AF_Fiscal_Year_new__c=currYear;
                AFCurrencyQuerylist.add(curr);
            }
            insert AFCurrencyQuerylist;
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrencyQuerylist LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Country__c, AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id,AF_Country__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert Agency Estimate.
            List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            list<AF_Agency_Estimate__c> agencylist=new list<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_READYFORPO;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                agency.AF_Agency_Spot_Rate__c=12.55;
                agency.AF_Agency_Exchange_Rate__c=123.345;
                agency.Indicative_Gain_in_USD__c=1234;
                agencylist.add(agency);
            }
            insert agencylist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
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
            List<AF_Bonus_Matrix__c> AFBonusMat = AF_TestFactory_Helper.insertBonusMatrix(1,true);
            List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMat LIMIT 1];
            System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id, AF_TestFactory_Helper.BONUSMATRIX_RECORD);
            List<AF_Bonus_Matrix__c> bonMatrixList=new List<AF_Bonus_Matrix__c>();
            bonMatrixList.add(AFBonusMat[0]);
            // insert Matrix Table.
            List<AF_Matrix_Table__c> MatrixTableLst =AF_TestFactory_Helper.insertmatrixtable(1,false);
            List<AF_Matrix_Table__c> MatrixTableList =new List<AF_Matrix_Table__c>();
            for(AF_Matrix_Table__c matrix:MatrixTableLst){
                matrix.AF_Matrix_Country__c=AF_Constants.TEST_UNILEVER_ENTITY_COUNTRY;
                matrix.AF_Matrix_Currency_Code__c=AF_Constants.TEST_UNILEVER_ENTITY_COUNTRY;
                matrix.AF_Ready_For_PO_Country__c=AF_Constants.TEST_CURRENCY_COUNTRY ;
                matrix.AF_Ready_For_PO_Currency_Code__c=AF_Constants.TEST_COUNTRY_CODE;
                matrix.Ready_For_PO_Conversion__c=AF_Constants.AF_CURRENCY_GBP;
                matrix.AF_Unilver_Country__c=AFUnileverEntityQuery[0].AF_Country__c;
                matrix.AF_Agency_Country__c=AFEntityQuery[0].AF_Country__c;
                MatrixTableList.add(matrix);
            }
            insert MatrixTableList;
            List<AF_Matrix_Table__c> MatrixTableLstQuery = [SELECT ID FROM AF_Matrix_Table__c  WHERE ID IN:MatrixTableList  LIMIT 1];
            System.assert(MatrixTableLstQuery[0]!=null,AF_TestFactory_Helper.MATRIX_RECORD);
            AF_UpdateAgencyEstimatesValues2.UpdateExchageRates(agencylist);
        }
    }

}