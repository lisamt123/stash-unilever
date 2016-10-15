/**********************************************************************
Name: CPA_Commercials_Threshold_Test ()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This is the test class for CPA_Commercials_Threshold_Test
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       09/05/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest
public  class CPA_Commercials_Threshold_Test {

    /*******************************************************************
    Purpose: This method covers PWO  Commercials Threshold method
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  PWOInformationController_Test() {
        CPA_Status_Msg__c saveStatus = CPA_testStatusMsgCustomSettingClass.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c READYTOSUBMIT= CPA_testStatusMsgCustomSettingClass.createTest_READYTOSUBMIT();
        insert READYTOSUBMIT;
        
        CPA_Commercials_Threshold__c Commercials_Threshold = CPA_testGroupNameCustomSettingClass.createTest_CPA_Commercials_Threshold();
        insert Commercials_Threshold;
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testPWORFClass_util.createTest_other_PWORF();
        
        objPworf.pkl_Project_Scale__c = 'Large Project (>2000 days)';
        
        
        insert objPworf;
        objPworf.mpkl_Project_Phases__c = 'Plan; Analyse; Design; Build; Test; Deploy; Other';
        objPworf.pkl_Status__c=CPA_ConstantsForContractingAppClasses.ACCEPTED ;
        update objPworf;
        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf);
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SAVED;
        insert  objPWO;
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPWO.pkl_Status__c);

        Test.setCurrentPage(new PageReference('CPA_PWO_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        CPA_ContractInformationController   controller = new CPA_ContractInformationController  (new ApexPages.StandardController(objPWO));
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED ==objPWO.pkl_Status__c);
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED ==objPWO.pkl_Status__c);
       
        CPA_project_work_order__c objPwo1 = new CPA_project_work_order__c();
        objPwo1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SAVED;
        objPwo1.txt_PWO_title__c  = null;
        objPwo1.mpkl_Project_Phases__c  = 'Plan; Analyse; Design; Build; Test; Deploy; Other';
        insert objPwo1;
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPwo1.pkl_Status__c);
        Test.setCurrentPage(new PageReference('CPA_PWO_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objPwo1.id);
        CPA_ContractInformationController   controller1 = new CPA_ContractInformationController  (new ApexPages.StandardController(objPwo1));
       
        CPA_ContractInformationController act = new CPA_ContractInformationController ();     
        boolean flage = CPA_ContractInformationController.checkIsValidated(objPwo1.Id );
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPwo1.pkl_Status__c);
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPwo1.pkl_Status__c);
        System.assert (controller1.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.PWOTITLE ) != null);
        System.assert (controller1.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.PWOTITLE ) == CPA_ConstantsForContractingAppClasses.MANDATORY);
        Test.stopTest();
    }
 
    /*******************************************************************
    Purpose: This method covers CR mandatory fields methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  CRInformationController_Test() {
        CPA_Status_Msg__c saveStatus = CPA_testStatusMsgCustomSettingClass.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c READYTOSUBMIT= CPA_testStatusMsgCustomSettingClass.createTest_READYTOSUBMIT();
        insert READYTOSUBMIT;
        CPA_Commercials_Threshold__c Commercials_Threshold = CPA_testGroupNameCustomSettingClass.createTest_CPA_Commercials_Threshold();
        insert Commercials_Threshold;
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testPWORFClass_util.createTest_other_PWORF();
        objPworf.mpkl_Project_Phases__c = 'Plan; Analyse; Design; Build; Test; Deploy; Other';
        objPworf.pkl_Project_Scale__c = 'Large Project (>2000 days)';
        insert objPworf;       
        
        objPworf.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ACCEPTED ;
        update objPworf;
        System.assert (CPA_ConstantsForContractingAppClasses.ACCEPTED == objPworf.pkl_Status__c);
        
        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf);
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SAVED;
        objPWO.pkl_PWORFDelta_Project_Scale__c = 'Large Project (>2000 days)';
        insert  objPWO;
       
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPWO.pkl_Status__c);
         
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.Accepted;
        update objPWO;
        System.assert(CPA_ConstantsForContractingAppClasses.Accepted == objPWO.pkl_Status__c);
        List<CPA_CR__c> lst  =new List<CPA_CR__c>();
        
        CPA_CR__c objCR1 = CPA_testContractClass.createCR(objPWO);
        objCR1.pkl_Status__c=CPA_ConstantsForContractingAppClasses.SAVED;
        objCR1.eml_Unilever_Content_Approver_Email__c   = null;
        objCR1.pkl_PWORFDelta_Project_Scale__c ='Large Project (>2000 days)';
        objCR1.pkl_Project_Phases__c = 'Plan; Analyse; Design; Build; Test; Deploy; Other';
        insert objCR1;
     
        System.assert ( CPA_ConstantsForContractingAppClasses.SAVED == objCR1.pkl_Status__c);
        
        Test.setCurrentPage(new PageReference('CPA_CR_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objCR1.id);
        CPA_CRInformationController   controller = new CPA_CRInformationController  (new ApexPages.StandardController(objCR1));
        System.assert ( CPA_ConstantsForContractingAppClasses.SAVED == objCR1.pkl_Status__c);
        
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objCR1.pkl_Status__c);
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objCR1.pkl_Status__c);
        System.assert (controller.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.ULCAEMAIL ) != null);
        System.assert (controller.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.ULCAEMAIL ) == CPA_ConstantsForContractingAppClasses.MANDATORY);
 
        CPA_CRInformationController act = new CPA_CRInformationController();     
        boolean flage = CPA_CRInformationController.checkIsValidated(objCR1.Id );
        
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objCR1.pkl_Status__c);
        System.assert (controller.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.ULCAEMAIL ) != null);
        System.assert (controller.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.ULCAEMAIL ) == CPA_ConstantsForContractingAppClasses.MANDATORY);
        Test.stopTest();
    
    }
}