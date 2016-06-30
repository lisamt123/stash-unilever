/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BrandEstimateUpdate_Test
@CreateDate : 13/9/2014
@Description : This is a Test class for AF_BrandEstimateUpdate class, 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@isTest(SeeAlldata=false)
public class AF_BrandEstimateUpdate_Test
{    
    public static string AGNECY_DATE =' The Agency date record is inserted';
    static user userforbrandestimateupdate;
    /***********************************************************************************
*  @Description: this method will the test data
*  @name : closeandRefresh
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void SchedulableContext()
    {
    Test.startTest();
        userforbrandestimateupdate=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userforbrandestimateupdate.id LIMIT 1];
        System.runAs(u)
        { 
        //insert custom setting.
        List<AF_AgencyDate__c> agencydateLst = AF_TestFactory_Helper.insertAgencyDate(1,true);
        List<AF_AgencyDate__c> agencydateLstQuery = [SELECT ID FROM AF_AgencyDate__c LIMIT 1];
        system.assertEquals(agencydateLstQuery[0].Id!=null,agencydateLst!=null,AGNECY_DATE );
        //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
            List<Account> acctQuery = [SELECT id FROM account Where id IN:acc LIMIT 1 ];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null,AF_TestFactory_Helper.CATEGORY_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
             //insert brandestimate
            List<AF_Brand_Estimate__c> BrandEst1 = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
            List<AF_Brand_Estimate__c> BrandEstlist1=new List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br : BrandEst1){
                br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_INITIATE;
                br.AF_Active__c=true;
                BrandEstlist1.add(br);
            }
            insert BrandEstlist1;
            AF_BrandEstimateUpdate_schedule reminder =new AF_BrandEstimateUpdate_schedule();
            String CRON_EXP = '0 0 3 ? * *';
            system.schedule('AF_Bonusquarterly_Reminder-yearly (TEST)', CRON_EXP, reminder );
            Test.stopTest();
    }
   }
}