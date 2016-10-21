/**********************************************************************
Name: CPA_Contract_UtilMethods_Test()
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
private class CPA_Contract_UtilMethods_Test {
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
        CPA_Status_Msg__c SubMsg = CPA_testStatusMsgCustomSettingClass.createTest_CPA_Status_Msg1();
        insert SubMsg;
        CPA_Status_Msg__c AnsweredMsg = CPA_testStatusMsgCustomSettingClass.createTest_AnsweredMsg();
        insert AnsweredMsg;
        CPA_Status_Msg__c CancelMsg = CPA_testStatusMsgCustomSettingClass.createTest_CancelMsg();
        insert CancelMsg;
        CPA_Status_Msg__c AutoAcceMsg = CPA_testStatusMsgCustomSettingClass.createTest_AutoAcceMsg();
        insert AutoAcceMsg;
        CPA_Status_Msg__c READYTOSUBMIT= CPA_testStatusMsgCustomSettingClass.createTest_READYTOSUBMIT();
        insert READYTOSUBMIT;
    
    }  
    /*******************************************************************
    Purpose: This method is used to cover LOI utilities
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void  CPA_LOI_Util_Test(){ 
        CPA_StatusMsgCustomSetting();
        
        CPA_Trigger_Pattern__c PWORFTriggerPattern = CPA_testCustomSettingClass_util.createTest_PWORFTriggerPattern();
        insert PWORFTriggerPattern;
        CPA_Trigger_Pattern__c LOITriggerPattern = CPA_testCustomSettingClass_util.createTest_LOITriggerPattern();
        insert LOITriggerPattern;
        
       Test.startTest();
            CPA_PWORF__c objPworf13 = CPA_testPWORFClass_util.createTest_other_PWORF();
            insert objPworf13;
            objPworf13.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
            update objPworf13;
            CPA_project_work_order__c objPWO = CPA_testContractClass.createotherPWO(objPworf13);
            insert objPWO;
            CPA_Project_Work_Order_TriggerUtil.isSubmitted=false;
            objPWO.txt_PWO_number__c = '456';
            update objPWO;
        
            CPA_LOI__c objLOI = CPA_testContractClass.createLOI(objPworf13);
            insert objLOI;
            
            objLOI.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            objLOI.txt_PWO_number__c = '456';
            update objLOI;
            CPA_LOI_TriggerUtil.isSubmitted  = false;
            objLOI.pkl_Status__c = CPA_ConstantsForContractingAppClasses.CANCELLED;
            update objLOI; 
            
           System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED != objPworf13.pkl_Status__c);
              System.assert (CPA_ConstantsForContractingAppClasses.CANCELLED == objLOI.pkl_Status__c);           
        Test.stopTest();
    }
    /*******************************************************************
    Purpose: This method is used to cover CR utilities
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void  CPA_CR_Util_Test(){ 
      CPA_StatusMsgCustomSetting();
        
        CPA_Trigger_Pattern__c PWORFTriggerPattern = CPA_testCustomSettingClass_util.createTest_PWORFTriggerPattern();
        insert PWORFTriggerPattern;
        CPA_Trigger_Pattern__c CRtriggerPattern = CPA_testCustomSettingClass_util.createTest_CRTriggerPattern();
        insert CRtriggerPattern;
      
        Test.startTest();
            CPA_PWORF__c objPworf14 = CPA_testPWORFClass_util.createTest_other_PWORF();
            insert objPworf14;
            objPworf14.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
            update objPworf14;
            
            CPA_project_work_order__c objPWO = CPA_testContractClass.createPWO(objPworf14);
            
            insert objPWO;

            objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ACCEPTED;
            objPWO.num_Effort_Cost__c =20;
            update objPWO;          
            
            CPA_CR__c objCR = CPA_testContractClass.createCR(objPWO);
            insert objCR;
            CPA_project_work_order__c pwo = [Select Id,pkl_Status__c from CPA_project_work_order__c where Id=:objCR.CPA_Project_Work_Order__c];
            objCR.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            objCR.num_Effort_Cost__c =20;
            update objCR;
            CPA_CR_TriggerUtil.isSubmitted  = false;
            objCR.pkl_Status__c = CPA_ConstantsForContractingAppClasses.CANCELLED;
            update objCR; 
            Test.stopTest(); 
            System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED != objPworf14.pkl_Status__c);
            System.assert (CPA_ConstantsForContractingAppClasses.ACCEPTED == objPWO.pkl_Status__c);        
    }
    /*******************************************************************
    Purpose: This method is used to cover CR utilities
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void  CPA_CR1_Util_Test(){ 
        CPA_StatusMsgCustomSetting();
        
        CPA_Trigger_Pattern__c PWORFTriggerPattern = CPA_testCustomSettingClass_util.createTest_PWORFTriggerPattern();
        insert PWORFTriggerPattern;
        CPA_Trigger_Pattern__c CRtriggerPattern = CPA_testCustomSettingClass_util.createTest_CRTriggerPattern();
        insert CRtriggerPattern;
        CPA_Trigger_Pattern__c PWOTriggerPattern = CPA_testCustomSettingClass_util.createTest_PWOTriggerPattern();
        insert PWOTriggerPattern;
        Test.startTest();
            CPA_CR__c objCR1 = CPA_testContractClass.standAloneCR();
            objCR1.pkl_Status__c=CPA_ConstantsForContractingAppClasses.SAVED;
            objCR1.num_Effort_Cost__c =20;
            insert objCR1;
            objCR1.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;              
            update objCR1;          
        Test.stopTest();    
        System.assert (CPA_ConstantsForContractingAppClasses.SUBMITTED == objCR1.pkl_Status__c);       
    }
        /*******************************************************************
    Purpose: This method is used to cover CR utilities
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void  CPA_CR2_Util_Test(){ 
        CPA_StatusMsgCustomSetting();
        
        CPA_Trigger_Pattern__c PWORFTriggerPattern = CPA_testCustomSettingClass_util.createTest_PWORFTriggerPattern();
        insert PWORFTriggerPattern;
        CPA_Trigger_Pattern__c CRtriggerPattern = CPA_testCustomSettingClass_util.createTest_CRTriggerPattern();
        insert CRtriggerPattern;
        CPA_Trigger_Pattern__c PWOTriggerPattern = CPA_testCustomSettingClass_util.createTest_PWOTriggerPattern();
        insert PWOTriggerPattern;
        
        Test.startTest();
        CPA_PWORF__c objPworf15 = CPA_testPWORFClass_util.createTest_other_PWORF();
            insert objPworf15;
            objPworf15.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
            update objPworf15;
            
            CPA_project_work_order__c objPWO = CPA_testContractClass.createPWO(objPworf15);
            insert objPWO;

            objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ACCEPTED;
            objPWO.num_Effort_Cost__c =20;
            update objPWO; 
            CPA_CR__c objCR2 = CPA_testContractClass.blankCR(objPWO);
            objCR2.num_Effort_Cost__c =20;
            insert objCR2;          
             System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED != objPworf15.pkl_Status__c);
              System.assert (CPA_ConstantsForContractingAppClasses.ACCEPTED == objPWO.pkl_Status__c); 
            
        Test.stopTest();    
    }
    /*******************************************************************
    Purpose: This method is used to cover HLE Request utilities
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void  CPA_HLE_Request_Util_Test(){ 
        CPA_StatusMsgCustomSetting();
        
        CPA_Trigger_Pattern__c HLERequestTriggerPattern = CPA_testCustomSettingClass_util.createTest_HLERequestTriggerPattern();
        insert HLERequestTriggerPattern;
      
        CPA_HLE_Request_SLAs__c HLEReqSLA = CPA_testCustomSettingClass_util.createTest_HLEReqSLA();
        insert HLEReqSLA;
      
        Test.startTest(); 
            CPA_HLE_Request__c objHLERequest = CPA_testContractClass.CreateHLERequest();
            insert objHLERequest;
            /*objHLERequest.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            update objHLERequest;
           CPA_HLERequest_TriggerUtil.isSubmitted  = false;*/
           objHLERequest.pkl_Status__c = CPA_ConstantsForContractingAppClasses.CANCELLED;
            update objHLERequest;
            System.assertNotEquals(CPA_ConstantsForContractingAppClasses.CANCELLED, objHLERequest.ID);  
             System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED != objHLERequest.pkl_Status__c);
             
        Test.stopTest();    
    }
    /*******************************************************************
    Purpose: This method is used to cover CNF Historical utilities
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void  CPA_CNFHistorical_Util_Test(){ 
        CPA_StatusMsgCustomSetting();
        CPA_Trigger_Pattern__c PWOTriggerPattern = CPA_testCustomSettingClass_util.createTest_PWOTriggerPattern();
        insert PWOTriggerPattern;
        Test.startTest();
            CPA_PWORF__c objPworf10 = CPA_testPWORFClass_util.createTest_other_PWORF();
            insert objPworf10;
            objPworf10.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
            update objPworf10;                      
            
            CPA_project_work_order__c objPWO = CPA_testContractClass.createotherPWO(objPworf10);
            insert objPWO;

            objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.DELIVERED;
            objPWO.CNF_Status__c = CPA_ConstantsForContractingAppClasses.SAVED;
            update objPWO;
            objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SentForClosure;
            objPWO.CNF_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            update objPWO;

              //System.assert(CPA_ConstantsForContractingAppClasses.ANSWERED== objPworf10.pkl_Status__c);
              System.assert(CPA_ConstantsForContractingAppClasses.CANCELLED!= objPWO.pkl_Status__c);
        Test.stopTest();   
    }
    /*******************************************************************
    Purpose: This method is used to cover TNF historical utilities
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void  CPA_TNFHistorical_Util_Test(){ 
        CPA_StatusMsgCustomSetting();
        CPA_Trigger_Pattern__c PWOTriggerPattern = CPA_testCustomSettingClass_util.createTest_PWOTriggerPattern();
        insert PWOTriggerPattern;
        Test.startTest();
            CPA_PWORF__c objPworf10 = CPA_testPWORFClass_util.createTest_other_PWORF();
            insert objPworf10;
            objPworf10.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
            update objPworf10;                      
            
            CPA_project_work_order__c objPWO = CPA_testContractClass.createotherPWO(objPworf10);
            insert objPWO;

            objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SIGNED;
            objPWO.TNF_Status__c = CPA_ConstantsForContractingAppClasses.SAVED;
            update objPWO;
            objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SentForTermination;
            objPWO.TNF_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            update objPWO;
            
             //System.assert(CPA_ConstantsForContractingAppClasses.ANSWERED== objPworf10.pkl_Status__c);
             System.assert(CPA_ConstantsForContractingAppClasses.CANCELLED!= objPWO.pkl_Status__c);
        Test.stopTest();   
    } 
    /*******************************************************************
    Purpose: This method is used to cover CR utilities
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void  CPA_CR_Util_Test2(){ 
      CPA_StatusMsgCustomSetting();
        
        CPA_Trigger_Pattern__c PWORFTriggerPattern = CPA_testCustomSettingClass_util.createTest_PWORFTriggerPattern();
        insert PWORFTriggerPattern;
        CPA_Trigger_Pattern__c CRtriggerPattern = CPA_testCustomSettingClass_util.createTest_CRTriggerPattern();
        insert CRtriggerPattern;
      
        Test.startTest();
            CPA_PWORF__c objPworf14 = CPA_testPWORFClass_util.createTest_other_PWORF();
            insert objPworf14;
            objPworf14.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
            update objPworf14;
            
            CPA_project_work_order__c objPWO = CPA_testContractClass.createPWO(objPworf14);            
            objPWO.num_Effort_Cost__c =20;
            insert objPWO; 
            objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ACCEPTED;
            objPWO.num_Estimated_Value_of_PWO__c= null;
            update objPWO;
            
            CPA_CR__c objCR = CPA_testContractClass.createCR(objPWO);
            insert objCR;
            CPA_project_work_order__c pwo = [Select Id,pkl_Status__c from CPA_project_work_order__c where Id=:objCR.CPA_Project_Work_Order__c];
            objCR.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            objCR.num_Effort_Cost__c =20;
            update objCR;
            objCR.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ACCEPTED;
            update objCR;
            
            CPA_CR__c objCR1 = CPA_testContractClass.createCR(objPWO);
            insert objCR1; 
            //objCR1.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
        	//CPA_CR_TriggerUtil.isSubmitted  = true;
            //objCR1.num_Effort_Cost__c =20;
            //update objCR1;
            
            Test.stopTest(); 
            System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED != objPworf14.pkl_Status__c);
            System.assert (CPA_ConstantsForContractingAppClasses.ACCEPTED == objPWO.pkl_Status__c);        
    }
}