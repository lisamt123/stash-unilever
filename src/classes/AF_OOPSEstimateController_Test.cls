/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_OOPSEstimateController_Test
@Created Date : 08/08/2014.
@Description : This Test class for  AF_OOPSEstimateController   apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_OOPSEstimateController_Test
{ 
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    static user userforoopsestimate;
    string result;
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : oopsEstimateController
*  @param : none
*  @return : none
*************************************************************************/ 
    Static testMethod void oopsEstimateController()
    { 
        Test.startTest();
        userforoopsestimate=AF_TestFactory_Helper.createUserAdmin3(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforoopsestimate.id LIMIT 1];
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
                br.AF_Basefee_Estimate_Initial_Quarter__c =AF_Constants.QUARTER1;
                BrandEstlist.add(br);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
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
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            ApexPages.currentPage().getParameters().put('id',OOPSEstimateList[0].id);         
            AF_OOPSEstimateController oopsEstCtrl=new AF_OOPSEstimateController();
            oopsEstCtrl.Save();
            oopsEstCtrl.SavePO();
            oopsEstCtrl.OverridePO();
            //insert OOPs Actual.
            List<AF_OOPS_Actual__c> OopsactualList1 = AF_TestFactory_Helper.insertOOPSActual(1,false);
            List<AF_OOPS_Actual__c> Oopsactual=new List<AF_OOPS_Actual__c>();
            for(AF_OOPS_Actual__c oops:OopsactualList1){
            oops.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
            Oopsactual.add(oops);
            }
            insert Oopsactual;
            List<AF_OOPS_Actual__c> OopsactualListQuery1 = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery1[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList1 = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery1 =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList1 LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery1[0].AF_OOPS_Actual__c, OopsactualList1[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            ApexPages.currentPage().getParameters().put('id',OOPSEstimateList1[0].id);         
            AF_OOPSEstimateController oopsEstCtrl1=new AF_OOPSEstimateController();
            oopsEstCtrl1.Save();
            oopsEstCtrl1.SavePO();
            oopsEstCtrl1.confirmBox();
            oopsEstCtrl1.closePopupReject();
            delete OopsactualList1;
            AF_OOPSEstimateHandler  handler=new AF_OOPSEstimateHandler();
            Test.stopTest();
        }
    }
      /**********************************************************************
*  @Description: This method will have Test data.
*  @name : oopsEstimateController1
*  @param : none
*  @return : none
*************************************************************************/ 
    Static testMethod void oopsEstimateController1()
    { 
        Test.startTest();
        userforoopsestimate=AF_TestFactory_Helper.createuser(true);
        User u=[SELECT id,Email FROM user WHERE id=:userforoopsestimate.id LIMIT 1];
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
                br.AF_Basefee_Estimate_Initial_Quarter__c =AF_Constants.QUARTER1;
                BrandEstlist.add(br);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
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
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,false);
            List<AF_OOPS_Estimate__c> OOPSEstimateList2=new  List<AF_OOPS_Estimate__c>();
            for(AF_OOPS_Estimate__c oops:OOPSEstimateList){
            oops.AF_Estimate__c=0;
            oops.AF_Status__c=AF_Constants.OOPS_ACTUAL_READYFORPO;
            oops.AF_PO_Number__c=AF_Constants.OOPS_ACTUAL_READYFORPO;
            OOPSEstimateList2.add(oops);
            }
            insert OOPSEstimateList2;
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            ApexPages.currentPage().getParameters().put('id',OOPSEstimateList[0].id);         
            AF_OOPSEstimateController oopsEstCtrl=new AF_OOPSEstimateController();
            oopsEstCtrl.Save();
            oopsEstCtrl.SavePO();
            oopsEstCtrl.OverridePO();
            //insert OOPs Actual.
            List<AF_OOPS_Actual__c> OopsactualList1 = AF_TestFactory_Helper.insertOOPSActual(1,true);
            List<AF_OOPS_Actual__c> OopsactualListQuery1 = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualList LIMIT 1];
            System.assertEquals(OopsactualListQuery1[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.OOPSACTUCAL_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList1 = AF_TestFactory_Helper.InsertOOPsEstimate(1,true);
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery1 =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateList1 LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery1[0].AF_OOPS_Actual__c, OopsactualList1[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            ApexPages.currentPage().getParameters().put('id',OOPSEstimateList1[0].id);         
            AF_OOPSEstimateController oopsEstCtrl1=new AF_OOPSEstimateController();
            oopsEstCtrl1.Save();
            oopsEstCtrl1.SavePO();
            oopsEstCtrl1.confirmBox();
            oopsEstCtrl1.isOopsEditable=true;
            oopsEstCtrl1.closePopupReject();
            delete OopsactualList1;
            AF_OOPSEstimateHandler  handler=new AF_OOPSEstimateHandler();
            Test.stopTest();
        }
    }
}