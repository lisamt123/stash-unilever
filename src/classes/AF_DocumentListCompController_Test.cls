/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_DocumentListCompController_Test
@CreateDate : 22/9/2014
@Description : This is a Test class for AF_DocumentListCompController class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_DocumentListCompController_Test
{
    private static string ATTACHMENT_RECORD='The attachment Record is inserted';
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    static user userforDocumentListComp;
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_addDocumentListCompController
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_addDocumentListCompController()
    {
        Test.startTest();
        userforDocumentListComp=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforDocumentListComp.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEstLst = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br: BrandEst){           
                br.Name='Test br';
                br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;   
                br.AF_Fiscal_Year__c=currYear;
                br.AF_Active__c = true;
                br.AF_Locked__c  = false;
                br.AF_Notified_To_CatFinance__c  = false;
                br.AF_Cat_Finance_Approver_1__c=u.Id;    
                BrandEstLst.add(br);
            }
            insert BrandEstLst;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstLst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert OOPs Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
            List<AF_OOPS_Actual__c> OopsactualListNew = new List<AF_OOPS_Actual__c>();
            for(AF_OOPS_Actual__c oopact :OopsactualList){
                oopact.AF_Agency_lk__c=acc[0].Id;     
                oopact.AF_Status__c = AF_Constants.OOPS_ACTUAL_READYFORPO;
                OopsactualListNew.add(oopact);
            }
            insert OopsactualListNew;
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualListNew LIMIT 1];
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
            List<AF_Agency_Estimate__c> AgencyEsitmatelist=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                agency.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                AgencyEsitmatelist.add(agency);
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,false);
            List<AF_OOPS_Estimate__c> OOPSEstimateListNew = new  List<AF_OOPS_Estimate__c> ();
            for(AF_OOPS_Estimate__c oopEst : OOPSEstimateList){
                oopEst.AF_Estimate__c=55;
                OOPSEstimateListNew.add(oopEst);
            }
            insert OOPSEstimateListNew;
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateListNew LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //Insert Bonus Summary
            List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> AFBonusSummaryLst = new  List<AF_Bonus_Summary__c>();
            for(AF_Bonus_Summary__c bs: AFBonusSummary){
                bs.AF_Fiscal_Year__c=currYear;
                bs.AF_Status__c = AF_Constants.BONUS_SUMMARY_READYFORPO;
                AFBonusSummaryLst.add(bs);
            }
            insert AFBonusSummaryLst;
            List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummaryLst LIMIT 1];
            System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id,AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Insert Bonus Results 
            List<AF_Bonus_Results__c> AFBonusRes = AF_TestFactory_Helper.insertBonusResults(1,false);
            List<AF_Bonus_Results__c> AFBonusResLst = new List<AF_Bonus_Results__c> ();
            for(Af_Bonus_Results__c bres : AFBonusRes){
                bres.AF_Total_Bonus_Value__c=23;
                AFBonusResLst.add(bres);
            }
            insert AFBonusResLst;
            List<AF_Bonus_Results__c> AFBonusResQuery = [Select AF_Bonus_Thresholds__c from AF_Bonus_Results__c where Id IN:AFBonusResLst LIMIT 1];
            System.assertEquals(AFBonusResQuery[0].AF_Bonus_Thresholds__c,BonusThresholdQuery[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            //Insert Bonus Matrix
            List<AF_Bonus_Matrix__c> AFBonusMat = AF_TestFactory_Helper.insertBonusMatrix(1,false);
            List<AF_Bonus_Matrix__c> AFBonusMatLst = new   List<AF_Bonus_Matrix__c>();
            for(AF_Bonus_Matrix__c bonmat :AFBonusMat){
                bonMat.AF_Value__c=55;     
                bonMat.AF_Base_Fee_Country_Total__c =35353;  
                bonMat.AF_BonusableFee__c=86588;  
                AFBonusMatLst.add(bonmat);
            }
            insert AFBonusMatLst;
            List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMatLst LIMIT 1];
            System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id, AF_TestFactory_Helper.BONUSMATRIX_RECORD);
            //insert Attachment.
            List<Attachment> attach1 = AF_TestFactory_Helper.insertAttachment(1,false);
            List<Attachment> attach1List = new List<Attachment>();
            for(Attachment attach:attach1){
                attach.description='vtest';
                attach.contenttype='test';
                attach1List.add(attach);
            }
            insert attach1List;
            List<Attachment> attach1Query = [SELECT Id from Attachment where id in :attach1List Limit 1];
            system.assert(attach1Query[0].Id!=null,ATTACHMENT_RECORD);
            AF_DocumentListCompController doc1 = new AF_DocumentListCompController();
            doc1.ParentRecordId = brandEst[0].id;
            doc1.IsViewAll = AF_Constants.AF_TRUE;
            doc1.getAttachmentList();
            doc1.docId = attach1[0].id;
            doc1.delDocument();
            List<Attachment> attach2 = AF_TestFactory_Helper.insertAttachment1(1,true);
            List<Attachment> attachQuery1 = [SELECT Id from Attachment Limit 1];
            system.assert(attachQuery1[0].Id!=null,ATTACHMENT_RECORD);
            AF_DocumentListCompController doc2 = new AF_DocumentListCompController();
            doc2.ParentRecordId = OopsactualList[0].id;
            doc2.IsViewAll = 'true';
            doc2.getAttachmentList();
            doc2.docId = attach2[0].id;
            doc2.isAgencyFlag=true;
            doc2.delDocument();
            List<Attachment> attach3 = AF_TestFactory_Helper.insertAttachment2(1,true);
            List<Attachment> attachQuery3 = [SELECT Id from Attachment Limit 1];
            system.assert(attachQuery3[0].Id!=null,ATTACHMENT_RECORD);
            ApexPages.currentPage().getParameters().get('id');
            AF_DocumentListCompController doc3 = new AF_DocumentListCompController();
            doc3.ParentRecordId = AFBonusSummary[0].id;
            doc3.ParentObjectType=AFBonusSummary[0].id;
            doc3.DocumentsList=attach2;
            doc3.IsViewAll = 'true';
            doc3.getAttachmentList();
            doc3.isAgencyFlag=true;
            doc3.docId = attach3[0].id;
            doc3.delDocument();
            Test.stopTest();
        }
    }
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_addDocumentListCompController1
*  @param : none.
*  @return: none.
*************************************************************************************/
     Static testMethod void AF_addDocumentListCompController1()
    {
        Test.startTest();
        userforDocumentListComp=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforDocumentListComp.id LIMIT 1];
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
            List<AF_Brand_Estimate__c> BrandEstLst = new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br: BrandEst){           
                br.Name='Test br';
                br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;   
                br.AF_Fiscal_Year__c=currYear;
                br.AF_Active__c = true;
                br.AF_Locked__c  = false;
                br.AF_Notified_To_CatFinance__c  = false;
                br.AF_Cat_Finance_Approver_1__c=u.Id;    
                BrandEstLst.add(br);
            }
            insert BrandEstLst;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstLst LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Currency
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c where Id IN:AFCurrency LIMIT 1];
            System.Assert(AFCurrencyQuery[0].Id != null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //insert OOPs Actual.
            List<AF_OOPS_Actual__c> OopsactualList = AF_TestFactory_Helper.insertOOPSActual(1,false);
            List<AF_OOPS_Actual__c> OopsactualListNew = new List<AF_OOPS_Actual__c>();
            for(AF_OOPS_Actual__c oopact :OopsactualList){
                oopact.AF_Agency_lk__c=acc[0].Id;     
                oopact.AF_Status__c = AF_Constants.OOPS_ACTUAL_READYFORPO;
                OopsactualListNew.add(oopact);
            }
            insert OopsactualListNew;
            List<AF_OOPS_Actual__c> OopsactualListQuery = [SELECT ID,AF_Agency__c FROM AF_OOPS_Actual__c WHERE ID IN : OopsactualListNew LIMIT 1];
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
            List<AF_Agency_Estimate__c> AgencyEsitmatelist=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Status__c = AF_Constants.BASE_FEES_WITH_AGENCY;
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Traditional__c=22;
                agency.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;
                AgencyEsitmatelist.add(agency);
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            //Insert OOPS Estimate.
            List<AF_OOPS_Estimate__c> OOPSEstimateList = AF_TestFactory_Helper.InsertOOPsEstimate(1,false);
            List<AF_OOPS_Estimate__c> OOPSEstimateListNew = new  List<AF_OOPS_Estimate__c> ();
            for(AF_OOPS_Estimate__c oopEst : OOPSEstimateList){
                oopEst.AF_Estimate__c=55;
                OOPSEstimateListNew.add(oopEst);
            }
            insert OOPSEstimateListNew;
            List<AF_OOPS_Estimate__c> OOPSEstimateListQuery =[SELECT ID,AF_OOPS_Actual__c FROM AF_OOPS_Estimate__c WHERE ID IN :OOPSEstimateListNew LIMIT 1];
            System.assertEquals(OOPSEstimateListQuery[0].AF_OOPS_Actual__c, OopsactualList[0].id,AF_TestFactory_Helper.OOPSESTIMATE_RECORD);
            //Insert Bonus Summary
            List<AF_Bonus_Summary__c> AFBonusSummary = AF_TestFactory_Helper.insertBonusSummary(1,false);
            List<AF_Bonus_Summary__c> AFBonusSummaryLst = new  List<AF_Bonus_Summary__c>();
            for(AF_Bonus_Summary__c bs: AFBonusSummary){
                bs.AF_Fiscal_Year__c=currYear;
                bs.AF_Status__c = AF_Constants.BONUS_SUMMARY_READYFORPO;
                AFBonusSummaryLst.add(bs);
            }
            insert AFBonusSummaryLst;
            List<AF_Bonus_Summary__c> AFBonusSummaryQuery = [Select AF_Agency__c from AF_Bonus_Summary__c where Id IN:AFBonusSummaryLst LIMIT 1];
            System.assertEquals(AFBonusSummaryQuery[0].AF_Agency__c,acc[0].id,AF_TestFactory_Helper.BONUSSUMMARY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,true);
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c where Id IN:BonusThreshold LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            //Insert Bonus Results 
            List<AF_Bonus_Results__c> AFBonusRes = AF_TestFactory_Helper.insertBonusResults(1,false);
            List<AF_Bonus_Results__c> AFBonusResLst = new List<AF_Bonus_Results__c> ();
            for(Af_Bonus_Results__c bres : AFBonusRes){
                bres.AF_Total_Bonus_Value__c=23;
                AFBonusResLst.add(bres);
            }
            insert AFBonusResLst;
            List<AF_Bonus_Results__c> AFBonusResQuery = [Select AF_Bonus_Thresholds__c from AF_Bonus_Results__c where Id IN:AFBonusResLst LIMIT 1];
            System.assertEquals(AFBonusResQuery[0].AF_Bonus_Thresholds__c,BonusThresholdQuery[0].id, AF_TestFactory_Helper.BONUSRESULT_RECORD);
            //Insert Bonus Matrix
            List<AF_Bonus_Matrix__c> AFBonusMat = AF_TestFactory_Helper.insertBonusMatrix(1,false);
            List<AF_Bonus_Matrix__c> AFBonusMatLst = new   List<AF_Bonus_Matrix__c>();
            for(AF_Bonus_Matrix__c bonmat :AFBonusMat){
                bonMat.AF_Value__c=55;     
                bonMat.AF_Base_Fee_Country_Total__c =35353;  
                bonMat.AF_BonusableFee__c=86588;  
                AFBonusMatLst.add(bonmat);
            }
            insert AFBonusMatLst;
            List<AF_Bonus_Matrix__c> AFBonusMatQuery = [Select AF_Bonus_Results__c from AF_Bonus_Matrix__c where Id IN:AFBonusMatLst LIMIT 1];
            System.assertEquals(AFBonusMatQuery[0].AF_Bonus_Results__c,AFBonusResQuery[0].id, AF_TestFactory_Helper.BONUSMATRIX_RECORD);
            //insert Attachment.
            List<Attachment> attach1 = AF_TestFactory_Helper.insertAttachment(1,false);
            List<Attachment> attach1List = new List<Attachment>();
            for(Attachment attach:attach1){
                attach.description='vtest';
                attach.contenttype='test';
                attach1List.add(attach);
            }
            insert attach1List;
            List<Attachment> attach1Query = [SELECT Id from Attachment where id in :attach1List Limit 1];
            system.assert(attach1Query[0].Id!=null,ATTACHMENT_RECORD);
            AF_DocumentListCompController doc1 = new AF_DocumentListCompController();
            doc1.ParentRecordId = brandEst[0].id;
            doc1.IsViewAll = 'true';
            doc1.getAttachmentList();
            doc1.docId = attach1[0].id;
            doc1.delDocument();
            List<Attachment> attach2 = AF_TestFactory_Helper.insertAttachment1(1,true);
            List<Attachment> attachQuery1 = [SELECT Id from Attachment Limit 1];
            system.assert(attachQuery1[0].Id!=null,ATTACHMENT_RECORD);
            AF_DocumentListCompController doc2 = new AF_DocumentListCompController();
            doc2.ParentRecordId = OopsactualList[0].id;
            doc2.IsViewAll = AF_Constants.AF_FALSE;
            doc2.getAttachmentList();
            doc2.docId = attach2[0].id;
            doc2.isAgencyFlag=true;
            doc2.delDocument();
            List<Attachment> attach3 = AF_TestFactory_Helper.insertAttachment2(1,true);
            List<Attachment> attachQuery3 = [SELECT Id from Attachment Limit 1];
            system.assert(attachQuery3[0].Id!=null,ATTACHMENT_RECORD);
            ApexPages.currentPage().getParameters().get('id');
            AF_DocumentListCompController doc3 = new AF_DocumentListCompController();
            doc3.ParentRecordId = AFBonusSummary[0].id;
      
        }
    }
}