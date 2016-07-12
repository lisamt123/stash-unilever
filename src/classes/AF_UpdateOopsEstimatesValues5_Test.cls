/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_UpdateOopsEstimatesValues5_Test
@Created Date : 05/08/2014.
@Description : This Test class for AF_UpdateOopsEstimatesValues5 apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_UpdateOopsEstimatesValues5_Test
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    static user userforOOPsEstimatevalues1;
    private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : updateOopsEstimatesValues5
*  @param : none
*  @return : none
*************************************************************************/  
    Static testMethod void updateOopsEstimatesValues5()
    {
        Test.startTest();
        userforOOPsEstimatevalues1=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforOOPsEstimatevalues1.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br : BrandEst){
                br.AF_AgencyUsers1__c=u.Email;
                br.AF_Active__c = true;
                br.AF_Copied__c= false;
                br.AF_Locked__c = false;
                br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;  
                br.AF_Fiscal_Year__c=currYear;
                BrandEstNew.add(br);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,false);
            List<AF_Currency__c> AFCurrencyQuerylist =new List<AF_Currency__c>();
            for(AF_Currency__c curr:AFCurrency){
                curr.Locked__c=false;
                curr.Country_Currency__c= AF_Constants.TEST_AGENCY_ENTITY_COUNTRY +'-'+ AF_Constants.TEST_UNILEVER_ENTITY_COUNTRY;
                curr.AF_Fiscal_Year_new__c=currYear;
                AFCurrencyQuerylist.add(curr);
            }
            try{
                insert AFCurrencyQuerylist;
            }catch(Exception e){
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'updateOopsEstimatesValues',e.getMessage(),e.getTypeName(),e.getStackTraceString());
            }
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrencyQuerylist LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert OOPs Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,false);
            List<AF_Entity__c> AFEntityLst = new List<AF_Entity__c>();
            for(AF_Entity__c en: AFEntity){
                en.AF_Country__c=AF_Constants.AF_ALGERIA;
                AFEntityLst.add(en);
            }   
            insert AFEntityLst;
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntityLst LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,false);
            List<AF_Entity__c> AFUnileverEntityLst = new  List<AF_Entity__c>();
            for(AF_Entity__c enti1 : AFUnileverEntity){
                enti1.AF_Country__c='Indonesia';
                AFUnileverEntityLst.add(enti1);
            }
            insert AFUnileverEntityLst;
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntityLst LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,false);
            List<AF_OOPS_Estimate__c> OOPSEstimatenewLst =new List<AF_OOPS_Estimate__c>();
            for(AF_OOPS_Estimate__c oopEst : OOPSEstimateList){
                oopEst.AF_Estimate__c=55;
                oopEst.AF_Status__c=AF_Constants.BASE_FEES_READYFORPO;
                oopEst.AF_Ready_For_PO_Entry_Currency__c =AF_Constants.AF_CURRENCY_USD;
                oopEst.AF_OOPS_Estimate_Local__c=123;
                oopEst.AF_Agency_Exchange_Rate__c=245;
                oopEst.AF_Ready_For_PO_Exchange_Rate__c = 1.6112;
                oopEst.AF_OOPS_Estimate_Local__c=98.12;
                oopEst.AF_Agency_Exchange_Rate__c=12.12;
                oopEst.AF_Fiscal_Year__c=currYear;
                OOPSEstimatenewLst.add(oopEst);
            }
            insert OOPSEstimatenewLst;
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimatenewLst LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            // insert Matrix Table.
            List<AF_Matrix_Table__c> MatrixTableLst =AF_TestFactory_Helper.insertmatrixtable(1,false);
            List<AF_Matrix_Table__c> MatrixTableList =new List<AF_Matrix_Table__c>();
            for(AF_Matrix_Table__c matrix:MatrixTableLst){
                matrix.AF_Agency_Country__c=AFEntityLst[0].AF_Country__c;
                matrix.AF_Unilver_Country__c=AFUnileverEntityLst[0].AF_Country__c;
                matrix.AF_Matrix_Country__c=AF_Constants.TEST_AGENCY_ENTITY_COUNTRY;
                matrix.AF_Matrix_Currency_Code__c=AF_Constants.TEST_UNILEVER_ENTITY_COUNTRY;
                matrix.AF_Ready_For_PO_Country__c=AF_Constants.TEST_CURRENCY_COUNTRY ;
                matrix.AF_Ready_For_PO_Currency_Code__c=AF_Constants.TEST_COUNTRY_CODE;
                matrix.Ready_For_PO_Conversion__c=AF_Constants.AF_CURRENCY_GBP;
                MatrixTableList.add(matrix);
            }
            insert MatrixTableList;
            List<AF_Matrix_Table__c> MatrixTableLstQuery = [SELECT ID FROM AF_Matrix_Table__c  WHERE ID IN:MatrixTableList  LIMIT 1];
            System.assert(MatrixTableLstQuery[0]!=null,AF_TestFactory_Helper.MATRIX_RECORD);
            AF_UpdateOopsEstimatesValues5.UpdateExchageRates(OOPSEstimatenewLst);
            AF_UpdateOopsEstimatesValues5.retrieveMatrixTable(OOPSEstimatenewLst);
            AF_UpdateOopsEstimatesValues5.retrieveCurrency(OOPSEstimatenewLst,MatrixTableList);
            Test.stopTest();
        }
    }
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : updateOopsEstimatesValues2
*  @param : none
*  @return : none
*************************************************************************/  
    Static testMethod void updateOopsEstimatesValues2()
    {
        Test.startTest();
        userforOOPsEstimatevalues1=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforOOPsEstimatevalues1.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br : BrandEst){
                br.AF_AgencyUsers1__c=u.Email;
                br.AF_Active__c = true;
                br.AF_Copied__c= false;
                br.AF_Locked__c = false;
                br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;  
                br.AF_Fiscal_Year__c=currYear;
                BrandEstNew.add(br);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert OOPs Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,false);
            List<AF_Entity__c> AFEntityLst = new List<AF_Entity__c>();
            for(AF_Entity__c en: AFEntity){
                en.AF_Country__c='Algeria';
                AFEntityLst.add(en);
            }   
            insert AFEntityLst;
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntityLst LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,false);
            List<AF_Entity__c> AFUnileverEntityLst = new  List<AF_Entity__c>();
            for(AF_Entity__c enti1 : AFUnileverEntity){
                enti1.AF_Country__c='Indonesia';
                AFUnileverEntityLst.add(enti1);
            }
            insert AFUnileverEntityLst;
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntityLst LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,false);
            List<AF_OOPS_Estimate__c> OOPSEstimatenewLst =new List<AF_OOPS_Estimate__c>();
            for(AF_OOPS_Estimate__c oopEst : OOPSEstimateList){
                oopEst.AF_Estimate__c=55;
                OOPSEstimatenewLst.add(oopEst);
            }
            insert OOPSEstimatenewLst;
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimatenewLst LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //matrix table
            List<AF_Matrix_Table__c> MatrixTableLst =AF_TestFactory_Helper.insertmatrixtable(1,false);
            List<AF_Matrix_Table__c> MatrixTableList =new List<AF_Matrix_Table__c>();
            for(AF_Matrix_Table__c matrix:MatrixTableLst){
                matrix.AF_Agency_Country__c=AFEntityLst[0].AF_Country__c;
                matrix.AF_Unilver_Country__c=AFUnileverEntityLst[0].AF_Country__c;
                matrix.AF_Matrix_Country__c=AF_Constants.TEST_AGENCY_ENTITY_COUNTRY;
                matrix.AF_Matrix_Currency_Code__c=AF_Constants.TEST_UNILEVER_ENTITY_COUNTRY;
                matrix.AF_Ready_For_PO_Country__c=AF_Constants.TEST_CURRENCY_COUNTRY ;
                matrix.AF_Ready_For_PO_Currency_Code__c=AF_Constants.TEST_COUNTRY_CODE;
                matrix.Ready_For_PO_Conversion__c=AF_Constants.AF_CURRENCY_USD;
                MatrixTableList.add(matrix);
            }
            insert MatrixTableList;
            List<AF_Matrix_Table__c> MatrixTableLstQuery = [SELECT ID FROM AF_Matrix_Table__c  WHERE ID IN:MatrixTableList  LIMIT 1];
            System.assert(MatrixTableLstQuery[0]!=null,AF_TestFactory_Helper.MATRIX_RECORD);
            AF_UpdateOopsEstimatesValues5.UpdateExchageRates(OOPSEstimatenewLst);
            AF_UpdateOopsEstimatesValues5.retrieveCurrency(OOPSEstimatenewLst,MatrixTableList);
            Test.stopTest();
        }
    }
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : updateOopsEstimatesValues3
*  @param : none
*  @return : none
*************************************************************************/ 
    Static testMethod void updateOopsEstimatesValues3()
    {
        Test.startTest();
        userforOOPsEstimatevalues1=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforOOPsEstimatevalues1.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br : BrandEst){
                br.AF_AgencyUsers1__c=u.Email;
                br.AF_Active__c = true;
                br.AF_Copied__c= false;
                br.AF_Locked__c = false;
                br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;  
                br.AF_Fiscal_Year__c=currYear;
                BrandEstNew.add(br);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,false);
            List<AF_Currency__c> AFCurrencyQuerylist =new List<AF_Currency__c>();
            for(AF_Currency__c curr:AFCurrency){
                curr.Locked__c=false;
                curr.Country_Currency__c=AF_Constants.TEST_UNILEVER_ENTITY_COUNTRY;
                curr.AF_Fiscal_Year_new__c=currYear;
                AFCurrencyQuerylist.add(curr);
            }
            try{
                insert AFCurrencyQuerylist;
            }catch(Exception e){
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'updateOopsEstimatesValues3',e.getMessage(),e.getTypeName(),e.getStackTraceString());
            }
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrencyQuerylist LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert OOPs Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,false);
            List<AF_Entity__c> AFEntityLst = new List<AF_Entity__c>();
            for(AF_Entity__c en: AFEntity){
                en.AF_Country__c=AF_Constants.AF_ALGERIA;
                AFEntityLst.add(en);
            }   
            insert AFEntityLst;
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntityLst LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,false);
            List<AF_Entity__c> AFUnileverEntityLst = new  List<AF_Entity__c>();
            for(AF_Entity__c enti1 : AFUnileverEntity){
                enti1.AF_Country__c='Indonesia';
                AFUnileverEntityLst.add(enti1);
            }
            insert AFUnileverEntityLst;
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntityLst LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,false);
            List<AF_OOPS_Estimate__c> OOPSEstimatenewLst =new List<AF_OOPS_Estimate__c>();
            for(AF_OOPS_Estimate__c oopEst : OOPSEstimateList){
                oopEst.AF_Estimate__c=55;
                oopEst.AF_Status__c=AF_Constants.BASE_FEES_READYFORPO;
                oopEst.AF_Ready_For_PO_Entry_Currency__c =AF_Constants.AF_CURRENCY_USD;
                oopEst.AF_Ready_For_PO_Exchange_Rate__c = 1.6112;
                oopEst.AF_OOPS_Estimate_Local__c=98.12;
                oopEst.AF_Agency_Exchange_Rate__c=12.12;
                OOPSEstimatenewLst.add(oopEst);
            }
            insert OOPSEstimatenewLst;
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimatenewLst LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            // insert Matrix Table.
            List<AF_Matrix_Table__c> MatrixTableLst =AF_TestFactory_Helper.insertmatrixtable(1,false);
            List<AF_Matrix_Table__c> MatrixTableList =new List<AF_Matrix_Table__c>();
            for(AF_Matrix_Table__c matrix:MatrixTableLst){
                matrix.AF_Agency_Country__c=AFEntityLst[0].AF_Country__c;
                matrix.AF_Unilver_Country__c=AFUnileverEntityLst[0].AF_Country__c;
                matrix.AF_Matrix_Country__c=AF_Constants.TEST_AGENCY_ENTITY_COUNTRY;
                matrix.AF_Matrix_Currency_Code__c=AF_Constants.TEST_UNILEVER_ENTITY_COUNTRY;
                matrix.AF_Ready_For_PO_Country__c=AF_Constants.TEST_CURRENCY_COUNTRY ;
                matrix.AF_Ready_For_PO_Currency_Code__c=AF_Constants.TEST_COUNTRY_CODE;
                matrix.Ready_For_PO_Conversion__c=AF_Constants.AF_CURRENCY_USD;
                MatrixTableList.add(matrix);
            }
            insert MatrixTableList;
            List<AF_Matrix_Table__c> MatrixTableLstQuery = [SELECT ID FROM AF_Matrix_Table__c  WHERE ID IN:MatrixTableList  LIMIT 1];
            System.assert(MatrixTableLstQuery[0]!=null,AF_TestFactory_Helper.MATRIX_RECORD);
            AF_UpdateOopsEstimatesValues5.UpdateExchageRates(OOPSEstimatenewLst);
            AF_UpdateOopsEstimatesValues5.retrieveCurrency(OOPSEstimatenewLst,MatrixTableList);
            Test.stopTest();
        }
    }
     Static testMethod void updateOopsEstimatesValues9()
    {
        Test.startTest();
        userforOOPsEstimatevalues1=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforOOPsEstimatevalues1.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEstNew = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br : BrandEst){
                br.AF_AgencyUsers1__c=u.Email;
                br.AF_Active__c = true;
                br.AF_Copied__c= false;
                br.AF_Locked__c = false;
                br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;  
                br.AF_Fiscal_Year__c=currYear;
                BrandEstNew.add(br);
            }
            insert BrandEstNew;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstNew LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,false);
            List<AF_Currency__c> AFCurrencyQuerylist =new List<AF_Currency__c>();
            for(AF_Currency__c curr:AFCurrency){
                curr.Locked__c=false;
                curr.Country_Currency__c=AF_Constants.TEST_UNILEVER_ENTITY_COUNTRY;
                curr.AF_Fiscal_Year_new__c=currYear;
                AFCurrencyQuerylist.add(curr);
            }
            try{
                insert AFCurrencyQuerylist;
            }catch(Exception e){
                AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'updateOopsEstimatesValues',e.getMessage(),e.getTypeName(),e.getStackTraceString());
            }
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrencyQuerylist LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert OOPs Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,false);
            List<AF_Entity__c> AFEntityLst = new List<AF_Entity__c>();
            for(AF_Entity__c en: AFEntity){
                en.AF_Country__c=AF_Constants.AF_ALGERIA;
                AFEntityLst.add(en);
            }   
            insert AFEntityLst;
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntityLst LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            //Insert Unilever Entity
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,false);
            List<AF_Entity__c> AFUnileverEntityLst = new  List<AF_Entity__c>();
            for(AF_Entity__c enti1 : AFUnileverEntity){
                enti1.AF_Country__c='Indonesia';
                AFUnileverEntityLst.add(enti1);
            }
            insert AFUnileverEntityLst;
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntityLst LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,false);
            List<AF_OOPS_Estimate__c> OOPSEstimatenewLst =new List<AF_OOPS_Estimate__c>();
            for(AF_OOPS_Estimate__c oopEst : OOPSEstimateList){
                oopEst.AF_Status__c=AF_Constants.BASE_FEES_READYFORPO;
                oopEst.AF_Ready_For_PO_Entry_Currency__c =AF_Constants.AF_CURRENCY_USD;
                oopEst.AF_Ready_For_PO_Exchange_Rate__c = 1.6112;
                OOPSEstimatenewLst.add(oopEst);
            }
            insert OOPSEstimatenewLst;
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimatenewLst LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            // insert Matrix Table.
            List<AF_Matrix_Table__c> MatrixTableLst =AF_TestFactory_Helper.insertmatrixtable(1,false);
            List<AF_Matrix_Table__c> MatrixTableList =new List<AF_Matrix_Table__c>();
            for(AF_Matrix_Table__c matrix:MatrixTableLst){
                matrix.AF_Agency_Country__c=AFEntityLst[0].AF_Country__c;
                matrix.AF_Unilver_Country__c=AFUnileverEntityLst[0].AF_Country__c;
                matrix.AF_Matrix_Country__c=AF_Constants.TEST_UNILEVER_ENTITY_COUNTRY;
                matrix.AF_Matrix_Currency_Code__c=AF_Constants.TEST_UNILEVER_ENTITY_COUNTRY;
                matrix.AF_Ready_For_PO_Country__c=AF_Constants.TEST_CURRENCY_COUNTRY ;
                matrix.AF_Ready_For_PO_Currency_Code__c=AF_Constants.TEST_COUNTRY_CODE;
                matrix.Ready_For_PO_Conversion__c=AF_Constants.AF_CURRENCY_GBP;
                MatrixTableList.add(matrix);
            }
            insert MatrixTableList;
            List<AF_Matrix_Table__c> MatrixTableLstQuery = [SELECT ID FROM AF_Matrix_Table__c  WHERE ID IN:MatrixTableList  LIMIT 1];
            System.assert(MatrixTableLstQuery[0]!=null,AF_TestFactory_Helper.MATRIX_RECORD);
            AF_UpdateOopsEstimatesValues5.UpdateExchageRates(OOPSEstimatenewLst);
            AF_UpdateOopsEstimatesValues5.retrieveCurrency(OOPSEstimatenewLst,MatrixTableList);
            Test.stopTest();
        }
    }
}