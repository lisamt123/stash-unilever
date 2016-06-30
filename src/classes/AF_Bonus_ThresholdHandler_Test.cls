/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_Bonus_ThresholdHandler 
@CreateDate : 10/9/2014
@Description : This is a Test class for AF_Agency_EstimateHandler  class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_Bonus_ThresholdHandler_Test
{    
    Static Integer IcurrYear = System.Today().year();
    Static string currYear=string.valueof(IcurrYear);
    static user UserForAF_Bonus_ThresholdHandler ;
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : AF_Bonus_ThresholdHandler
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void AF_Bonus_ThresholdHandler()
    {
        Test.startTest();
        UserForAF_Bonus_ThresholdHandler = AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id,Email FROM user WHERE id=:UserForAF_Bonus_ThresholdHandler.id LIMIT 1];
        System.runAs(u)
        {
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,false);
               List<Account> accList = new List<Account>();
            for(Account loopacc : acc){
                loopacc.published__c = true;
                accList.add(loopacc);
            }
            insert acc;
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert contact.
            List<Contact> contactList = AF_TestFactory_Helper.AFInsertContact(1,false);
            List<Contact> contactList1=new List<Contact>();
            for(contact con : contactList){
                con.Email = 'test@test.com ';
                con.AF_Send_Email_Notification__c=true;
                contactList1.add(con);
            }
            insert contactList1;
            List<contact> conQuery = [SELECT id From Contact LIMIT 1];
            system.assert(conQuery[0].id!=null,AF_TestFactory_Helper.CONTACT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist=new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c  loopBrandEst : BrandEst)
            {
                loopbrandEst.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_READYFORPO;  
                loopbrandEst.AF_Fiscal_Year__c=currYear;
                loopbrandEst.AF_Active__c = true;
                loopbrandEst.AF_Copied__c= false;
                loopbrandEst.AF_Locked__c = false; 
                loopbrandEst.AF_Controller_Flag__c=false;
                loopbrandEst.AF_AgencyUsers1__c=u.Email;
                loopbrandEst.AF_Traditional__c=23;
                loopbrandEst.AF_Digital__c=24;
                loopbrandEst.AF_Adaptive__c=44;
                loopbrandEst.AF_BackupQuarter__c = 'Q1;Q2;Q3';
                loopBrandEst.Archived_BrandEstimate_Quarter__c='Q1;Q2;Q3';
                BrandEstlist.add(loopbrandEst);
            }
            insert BrandEstlist;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c LIMIT 2]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntityQuery[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
            List<AF_Entity__c> AFUnileverEntity = AF_TestFactory_Helper.insertUnileverEntityListRec(1,true);
            List<AF_Entity__c> AFUnileverEntityQuery = [SELECT Id FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_UNILIVER_ENTITY_RECTYPE and Id IN:AFUnileverEntity LIMIT 1];
            System.Assert(AFUnileverEntityQuery[0].Id != null, AF_TestFactory_Helper.UNILEVER_ENTITY);
             //inset Agency Estimate.           
           List<AF_Agency_Estimate__c> AgencyEsitmate = AF_TestFactory_Helper.insertAgencyEstimate(1,false);
            List<AF_Agency_Estimate__c> AgencyEsitmatelist=new List<AF_Agency_Estimate__c>();
            for(AF_Agency_Estimate__c agency : AgencyEsitmate){
                agency.AF_Fiscal_Year__c=currYear;
                agency.AF_Adaptation__c=22;
                agency.AF_Digital__c=22;
                agency.AF_Digital_Local__c=12;
                agency.AF_Traditional__c=22; 
                agency.AF_Status__c=AF_Constants.BASE_FEES_WITH_AGENCY;  
                AgencyEsitmatelist.add(agency);
            }
            insert AgencyEsitmatelist;
            List<AF_Agency_Estimate__c> AgencyQuery = [SELECT Id ,AF_Brand_Estimate__c FROM AF_Agency_Estimate__c WHERE ID IN : AgencyEsitmate limit 1];
            System.assertEquals(AgencyQuery[0].AF_Brand_Estimate__c, BrandEst[0].id,AF_TestFactory_Helper.AGENCYESTIMATE_RECORD);
            // insert currency.
            List<AF_Currency__c> AFCurrency = AF_TestFactory_Helper.insertAFcurrencyList(1,true);
            List<AF_Currency__c> AFCurrencyQuery = [SELECT Id FROM AF_Currency__c LIMIT 1];
            System.AssertEquals(AFCurrencyQuery[0].Id != null,AFCurrency!=null, AF_TestFactory_Helper.CURRENCY_RECORD);
            //Insert Bonus Threshold
            List<AF_Bonus_Threshold__c> BonusThreshold =  AF_TestFactory_Helper.insertBonusThreshhold(1,false);
              List<AF_Bonus_Threshold__c> BonusThresholdLSt = new   List<AF_Bonus_Threshold__c>();
              for(AF_Bonus_Threshold__c bonThres :BonusThreshold){
               bonThres.AF_Traditional__c=true;
                 bonThres.AF_Digital__c=true;
                 bonThres.Year__c=currYear;
                 bonThres.AF_Minimum__c=5;
                 bonThres.AF_Stretching__c=6;
                 bonThres.AF_Outstanding__c=7;
                 BonusThresholdLSt.add(bonThres);
              }
              insert BonusThresholdLSt;
            List<AF_Bonus_Threshold__c> BonusThresholdQuery = [Select Agency_Name__c from AF_Bonus_Threshold__c WHERE ID IN :BonusThresholdLSt LIMIT 1];
            System.assertEquals(BonusThresholdQuery[0].Agency_Name__c,acc[0].id, AF_TestFactory_Helper.BONUSTHERSHOLD_RECORD);
            AF_Bonus_ThresholdHandler threshhold =  new AF_Bonus_ThresholdHandler();
            AF_Bonus_Threshold__c so = new AF_Bonus_Threshold__c();
            AF_Bonus_Threshold__c oldso = new AF_Bonus_Threshold__c();
            threshhold.bulkBefore();
            threshhold.bulkAfter();
            threshhold.beforeInsert(so);
            threshhold.beforeUpdate(oldso,so);
            threshhold.beforeDelete(so);
            threshhold.afterInsert(so);
            threshhold.afterUpdate(oldso,so);
            threshhold.afterDelete(so);
            threshhold.andFinally();
        }
    }
}