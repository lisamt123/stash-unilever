/**********************************************************************
Name: CPA_batchProrfAgeUpdate_test()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This is the batch class of PWORF Age
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR       DATE            DETAIL Description
1.0         Name      20/04/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest
private class CPA_batchProrfAgeUpdate_test {

    static testmethod void test() {
        
        CPA_Trigger_Pattern__c PWORFTriggerPattern = CPA_testCustomSettingClass_util.createTest_PWORFTriggerPattern();
        insert PWORFTriggerPattern; 
                        
        CPA_PWORF__c objPworf1 = CPA_testPWORFClass_util.createTest_other_PWORF();
            objPworf1.Name = 'PWORF-'+system.Now()+1;
            objPworf1.mpkl_Project_Phases__c = 'Design; Build; Test; Deploy';
            objPworf1.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SAVED;
            insert objPworf1;
			objPworf1.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            update objPworf1;

       CPA_PWORF_Ageing__c[] ml = new List<CPA_PWORF_Ageing__c>();
       for (Integer i=0;i<10;i++) {
           CPA_PWORF_Ageing__c m = new CPA_PWORF_Ageing__c(
               PWORF_ID__c=objPworf1.id);
               
           ml.add(m);
       }
       insert ml;

       Test.startTest();
       CPA_batchProrfAgeUpdate batchProrfAgeUpdate = new CPA_batchProrfAgeUpdate ();

	   Database.executebatch(batchProrfAgeUpdate);
       Test.stopTest();
	   System.assert (CPA_ConstantsForContractingAppClasses.SUBMITTED == objPworf1.pkl_Status__c);
    }
}