/**********************************************************************
Name: CPA_CRListController_Test()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose:This is the test class for CPA_CRListController
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR       DATE            DETAIL Description
1.0         Name      15/10/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest
public class CPA_CRListController_Test {
    /*******************************************************************
    Purpose: This method is used to cover custom settings status methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testMethod void Test_CPA_CRListController(){
    
     Test.startTest();  
        CPA_PWORF__c objPworf13 = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf13;
        objPworf13.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
        update objPworf13;
        CPA_project_work_order__c objPWO = CPA_testContractClass.createotherPWO(objPworf13);
        insert objPWO;
        objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ACCEPTED;
        objPWO.num_Effort_Cost__c =20;
        update objPWO;   
        CPA_CR__c objCR = CPA_testContractClass.createCR(objPWO);
        insert objCR;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(objPWO);
        CPA_CRListController ccc =  new CPA_CRListController(stdController);
        ccc.getPwoList();
        system.assertNotEquals(0,ccc.effortstotal );
         Test.stopTest();  
        
    }
}