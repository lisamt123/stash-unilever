/**********************************************************************
Name: CPA_PWORF_PWO_UtilMethods_Test()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This is the util class of rest of the test classes.
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR       DATE            DETAIL Description
1.0         Name      01/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest
private class CPA_PWORF_PWO_UtilMethods_Test {
    /*******************************************************************
    Purpose: This method is used to cover custom settings status methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static  void CPA_StatusMsgCustomSetting(){
        CPA_Status_Msg__c saveStatus = CPA_testStatusMsgCustomSettingClass.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c acceptedStatus = CPA_testStatusMsgCustomSettingClass.createTest_CPA_Status_Msg1();
        insert acceptedStatus;
        CPA_Status_Msg__c SubMsg = CPA_testStatusMsgCustomSettingClass.createTest_SubMsg();
        insert SubMsg;
        CPA_Status_Msg__c AnsweredMsg = CPA_testStatusMsgCustomSettingClass.createTest_AnsweredMsg();
        insert AnsweredMsg;
        CPA_Status_Msg__c CancelMsg = CPA_testStatusMsgCustomSettingClass.createTest_CancelMsg();
        insert CancelMsg;
        CPA_Status_Msg__c AutoAcceMsg = CPA_testStatusMsgCustomSettingClass.createTest_AutoAcceMsg();
        insert AutoAcceMsg;
    
    }       
    /*******************************************************************
    Purpose: This method is used to cover PWORF utilities
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void CPA_PWORF_Util_Test(){ 
        CPA_StatusMsgCustomSetting();
        
        CPA_Trigger_Pattern__c PWORFTriggerPattern = CPA_testCustomSettingClass_util.createTest_PWORFTriggerPattern();
        insert PWORFTriggerPattern;
        
        Test.startTest();   
                        
        CPA_PWORF__c objPworf1 = CPA_testPWORFClass_util.createTest_other_PWORF();
            objPworf1.Name = 'PWORF-'+system.Now()+1;
           objPworf1.mpkl_Project_Phases__c = 'Design; Build; Test; Deploy';
           objPworf1.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SAVED;
            insert objPworf1;
             System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPworf1.pkl_Status__c); 
            
            objPworf1.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            update objPworf1;
            System.assert (CPA_ConstantsForContractingAppClasses.SUBMITTED == objPworf1.pkl_Status__c);
            
            objPworf1.pkl_Status__c = CPA_ConstantsForContractingAppClasses.AUTOACCEPT;
            update objPworf1;
             System.assert (CPA_ConstantsForContractingAppClasses.AUTOACCEPT == objPworf1.pkl_Status__c);
           
            CPA_PWORF__c objPworf2 = CPA_testPWORFClass_util.createTest_other_PWORF();
             objPworf2.name='PWORF-'+system.Now()+2;
            objPworf2.mpkl_Project_Phases__c = 'Plan;Analyse;Design;Build;Test;Deploy';
            objPworf2.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SAVED;
            insert objPworf2;
            System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPworf2.pkl_Status__c); 
            objPworf2.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            update objPworf1;           
             System.assert (CPA_ConstantsForContractingAppClasses.SUBMITTED == objPworf2.pkl_Status__c);
            
            CPA_PWORF__c objPworf3 = CPA_testPWORFClass_util.createTest_other_PWORF();
             objPworf3.name='PWORF-'+system.Now()+3;
            objPworf3.mpkl_Project_Phases__c = CPA_ConstantsForContractingAppClasses.OTHER;
            objPworf3.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SAVED;
            insert objPworf3;
            System.assertNotEquals(CPA_ConstantsForContractingAppClasses.CANCELLED, objPworf3.pkl_Status__c);   
            objPworf3.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            update objPworf3;
                                 
             System.assert (CPA_ConstantsForContractingAppClasses.SUBMITTED == objPworf3.pkl_Status__c);
            
             CPA_PWORF__c objPworf4 = CPA_testPWORFClass_util.createTest_other_PWORF();
             objPworf4.name='PWORF-'+system.Now()+4;
            objPworf4.mpkl_Project_Phases__c = CPA_ConstantsForContractingAppClasses.PLAN_ANALYSE;
            
            insert objPworf4;
             System.assert (CPA_ConstantsForContractingAppClasses.PLAN_ANALYSE == objPworf4.mpkl_Project_Phases__c);
            objPworf4.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
           
            update objPworf4;
        CPA_PWORF_TriggerUtil.isSubmitted=false;
            objPworf4.pkl_Status__c = CPA_ConstantsForContractingAppClasses.WITHHOLD;
           
            update objPworf4;
             System.assert (CPA_ConstantsForContractingAppClasses.WITHHOLD != objPworf2.pkl_Status__c);
        Test.stopTest();

        
    }
    /*******************************************************************
    Purpose: This method is used to cover PWO utilities
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void  CPA_PWO_Util_Test(){ 
        CPA_StatusMsgCustomSetting();
        
        CPA_Trigger_Pattern__c PWORFTriggerPattern = CPA_testCustomSettingClass_util.createTest_PWORFTriggerPattern();
        insert PWORFTriggerPattern;
        CPA_Trigger_Pattern__c PWOTriggerPattern = CPA_testCustomSettingClass_util.createTest_PWOTriggerPattern();
        insert PWOTriggerPattern;
        
        Test.startTest();
            CPA_PWORF__c objPworf10 = CPA_testPWORFClass_util.createTest_other_PWORF();
            insert objPworf10;
            objPworf10.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
            update objPworf10;                      
            
            CPA_project_work_order__c objPWO = CPA_testContractClass.createotherPWO(objPworf10);
            insert objPWO;
             CPA_Project_Work_Order_TriggerUtil.isSubmitted=false;
            objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            update objPWO;
         CPA_Project_Work_Order_TriggerUtil.isSubmitted=false;
            objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.CANCELLED;
            update objPWO;
              System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED!= objPworf10.pkl_Status__c);
             System.assert (CPA_ConstantsForContractingAppClasses.CANCELLED== objPWO.pkl_Status__c);
        Test.stopTest();    
    }
    /*******************************************************************
    Purpose: This method is used to cover PWO utilities
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void  CPA_PWO1_Util_Test(){
        CPA_StatusMsgCustomSetting();
        
        CPA_Trigger_Pattern__c PWOTriggerPattern = CPA_testCustomSettingClass_util.createTest_PWOTriggerPattern();
        insert PWOTriggerPattern;
    
        Test.startTest();           
            CPA_PWORF__c objPworf11 = CPA_testPWORFClass_util.createTest_other_PWORF();
            insert objPworf11;
            objPworf11.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
            update objPworf11;
            CPA_project_work_order__c objPWO2 = CPA_testContractClass.createotherPWO(objPworf11);
            RecordType rt =[select id,Name from RecordType where sObjectType='CPA_project_work_order__c' AND Name='PWO CNF' limit 1] ;
             objPWO2.RecordTypeid = rt.id;
             objPWO2.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SAVED;
            insert objPWO2;
             System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED != objPworf11.pkl_Status__c);
             System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPWO2.pkl_Status__c);
        Test.stopTest();    
    }
    /*******************************************************************
    Purpose: This method is used to cover PWO utilities
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void  CPA_PWO2_Util_Test(){
        CPA_StatusMsgCustomSetting();
        
        CPA_Trigger_Pattern__c PWORFTriggerPattern = CPA_testCustomSettingClass_util.createTest_PWORFTriggerPattern();
        insert PWORFTriggerPattern;
        CPA_Trigger_Pattern__c PWOTriggerPattern = CPA_testCustomSettingClass_util.createTest_PWOTriggerPattern();
        insert PWOTriggerPattern;
        
        Test.startTest();           
            CPA_PWORF__c objPworf12 = CPA_testPWORFClass_util.createTest_RA_PWORF();
            insert objPworf12;
            objPworf12.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
            update objPworf12;
            CPA_PWORF_Record_type__c customSettingPworfRT = CPA_testCustomSettingClass_util.createTest_PWORF_All_recordtType(objPworf12.id);
        insert customSettingPworfRT;
            CPA_project_work_order__c objPWO2 = CPA_testContractClass.createotherPWO(objPworf12);
            RecordType rt =[select id,Name from RecordType where sObjectType='CPA_project_work_order__c' AND Name='PWO TNF' limit 1] ;
             objPWO2.RecordTypeid = rt.id;
            insert objPWO2;
             System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED != objPworf12.pkl_Status__c);
           
        Test.stopTest();    
    }
}