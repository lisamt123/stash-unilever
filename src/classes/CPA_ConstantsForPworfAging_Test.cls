/**********************************************************************
Name: CPA_ConstantsForPworfAging_Test()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: This is the test class for CPA_ConstantsForPworfAging
-------
======================================================
======================================================
History : AC.08.12.01, AC.10.07.03
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       15/10/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest 
public class CPA_ConstantsForPworfAging_Test {

 static testMethod void constantsforPworfagingTest() {

        //CPA_ConstantsForPworfAging con = new CPA_ConstantsForPworfAging();
        Test.startTest();
        System.assertEquals(CPA_ConstantsForPworfAging.RESUBMITTED,CPA_ConstantsForPworfAging.RESUBMITTED);
        System.assertEquals(CPA_ConstantsForPworfAging.SUBMITTED,CPA_ConstantsForPworfAging.SUBMITTED);
        System.assertEquals(CPA_ConstantsForPworfAging.CANCELLED,CPA_ConstantsForPworfAging.CANCELLED);
        System.assertEquals(CPA_ConstantsForPworfAging.ACCEPTED,CPA_ConstantsForPworfAging.ACCEPTED);
        System.assertEquals(CPA_ConstantsForPworfAging.ANSWERED,CPA_ConstantsForPworfAging.ANSWERED);
        System.assertEquals(CPA_ConstantsForPworfAging.SIGNED,CPA_ConstantsForPworfAging.SIGNED);
        System.assertEquals(CPA_ConstantsForPworfAging.RETURNED,CPA_ConstantsForPworfAging.RETURNED);
        System.assertEquals(CPA_ConstantsForPworfAging.DELIVERED,CPA_ConstantsForPworfAging.DELIVERED);
        System.assertEquals(CPA_ConstantsForPworfAging.SentForClosure,CPA_ConstantsForPworfAging.SentForClosure);
        System.assertEquals(CPA_ConstantsForPworfAging.CLOSED,CPA_ConstantsForPworfAging.CLOSED);
        System.assertEquals(CPA_ConstantsForPworfAging.SentForTermination,CPA_ConstantsForPworfAging.SentForTermination);
        System.assertEquals(CPA_ConstantsForPworfAging.TERMINATED,CPA_ConstantsForPworfAging.TERMINATED);
        Test.stopTest();
}







}