/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_Utils_Test 
@CreateDate : 16/9/2014
@Description : This is a Test class for AF_Utils apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
 @isTest(SeeAlldata=false)
public class AF_Utils_Test
{    
    static user userForutil;
    /***********************************************************************************
*  @Description: this method will have the test data.
*  @name : afutil
*  @param : none.
*  @return: none.
*************************************************************************************/
    Static testMethod void afutil()
    {
         Test.startTest();
        userForutil=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userForutil.id LIMIT 1];
        System.runAs(u)
        { 
            //Insert Account
            List<Account> acc=AF_TestFactory_Helper.insertAFaccList(1,true);
            List<Account> acctQuery = [SELECT id FROM account LIMIT 1];
            System.Assert(acctQuery[0].Id != null, AF_TestFactory_Helper.ACCOUNT_RECORD);
            //Insert category
            List<AF_Category_Brand__c> cb = AF_TestFactory_Helper.insertAFCBList(1,true);
            List<AF_Category_Brand__c> categoryQuery = [SELECT id FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_CATEGORY_RECTYPE and Id IN:cb LIMIT 1];
            System.Assert(categoryQuery[0].Id != null, AF_TestFactory_Helper.CONTACT_RECORD);
            //Insert Brand
            List<AF_Category_Brand__c> AFCategoryBrand = AF_TestFactory_Helper.insertBrand(1,true);
            List<AF_Category_Brand__c> brandQuery = [SELECT AF_Category_Brands__c FROM AF_Category_Brand__c where RecordTypeId=:AF_TestFactory_Helper.AF_BRAND_RECTYPE and Id IN:AFCategoryBrand LIMIT 1];
            System.assertEquals(brandQuery[0].AF_Category_Brands__c,categoryQuery[0].Id, AF_TestFactory_Helper.BRAND_RECORD);
            //Insert BrandEstimate
            List<AF_Brand_Estimate__c> BrandEst = AF_TestFactory_Helper.insertAFBrandEstList(1,false);
             List<AF_Brand_Estimate__c> BrandEstList = new  List<AF_Brand_Estimate__c>();
            for(AF_Brand_Estimate__c br : BrandEst){
                br.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_WIHTCMCO;  
                br.AF_Pilot_Model__c=false;
                BrandEstList.add(br);
            }
            insert BrandEstList;
            List<AF_Brand_Estimate__c> BrandEstQuery =[SELECT Brand__c FROM AF_Brand_Estimate__c where Id IN:BrandEstList LIMIT 1]; 
            System.assertEquals(BrandEstQuery[0].Brand__c, brandQuery[0].id,AF_TestFactory_Helper.BRANDESTIMATE_RECORD);
            //Insert Agency Entity
            List<AF_Entity__c> AFEntity = AF_TestFactory_Helper.insertAgencyEntityList(1,true);
            List<AF_Entity__c> AFEntityQuery = [SELECT AF_Agency__c FROM AF_Entity__c where RecordTypeId=:AF_TestFactory_Helper.AF_AGENCY_ENTITY_RECTYPE and Id IN:AFEntity LIMIT 1];
            System.assertEquals(AFEntity[0].AF_Agency__c, acc[0].id,AF_TestFactory_Helper.AGENCY_ENTITY);
             AF_Utils.getRecordId('Brand Estimate');
             AF_Utils.getEntityRecordId('Agency Entity');
             AF_Utils.getBonusResRecordId('Bonus Annual');
             AF_Utils.isAgencyUser(u.id);
             AF_Utils.getResourceURL('AF_isComment');
             AF_Utils.isValidID(u.id);
             Map<Id,sObject> maptest = new  Map<Id,sObject>();
             AF_Brand_Estimate__c obj = new AF_Brand_Estimate__c();
             maptest.put(brandEst[0].id,obj );
             AF_Utils.ConvertMapValuesToList(maptest);
             AF_Utils.EntityNameValue(AFEntityQuery[0].id);
        }
    }
}