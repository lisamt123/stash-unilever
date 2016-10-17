@isTest
public class BFM_MDFEvalidationController_CC_Test{
    private static testMethod void testDuplicateRecordCheck(){        
        List<BFM_MDF_e__c> MDFeRecord = new List<BFM_MDF_e__c>();
        BFM_MDF_e__c mdf = new BFM_MDF_e__c();  
        mdf.Name='test1';
        mdf.MDFE_Access_Key__c='7647267677';
        mdf.MDF_e_Duplicate_Record_Check__c=true;
        mdf.MDF_e_Status__c='In Progress';
        MDFeRecord.add(mdf);
        insert MDFeRecord;
        test.starttest();
        BFM_MDFEvalidationController_CC.DuplicateRecordCheck();
        test.stoptest();     
    }
}