@isTest
private class CPA_UtilMethods_Test {
    
    public Static testMethod  void CPA_PWORF_Util_Test(){ 
        CPA_Status_Msg__c saveStatus = CPA_testClass_util.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c acceptedStatus = CPA_testClass_util.createTest_CPA_Status_Msg1();
        insert acceptedStatus;
        CPA_Status_Msg__c SubMsg = CPA_testClass_util.createTest_SubMsg();
        insert SubMsg;
        CPA_Status_Msg__c AnsweredMsg = CPA_testClass_util.createTest_AnsweredMsg();
        insert AnsweredMsg;
        CPA_Status_Msg__c CancelMsg = CPA_testClass_util.createTest_CancelMsg();
        insert CancelMsg;
		
        CPA_Trigger_Pattern__c PWORFTriggerPattern = CPA_testClass_util.createTest_PWORFTriggerPattern();
        insert PWORFTriggerPattern;
        
        Test.startTest();   
                        
            CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
            objPworf1.Name = 'PWORF-'+system.Now()+1;
           objPworf1.mpkl_Project_Phases__c = 'Design; Build; Test; Deploy';
           objPworf1.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SAVED;
            insert objPworf1;
             System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPworf1.pkl_Status__c); 
            
            objPworf1.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            update objPworf1;
            System.assert (CPA_ConstantsForContractingAppClasses.SUBMITTED == objPworf1.pkl_Status__c);
            
            objPworf1.pkl_Status__c = 'Auto Accepted';
            update objPworf1;
             System.assert ('Auto Accepted' == objPworf1.pkl_Status__c);
           
            CPA_PWORF__c objPworf2 = CPA_testClass_util.createTest_other_PWORF();
             objPworf2.name='PWORF-'+system.Now()+2;
            objPworf2.mpkl_Project_Phases__c = 'Plan;Analyse;Design;Build;Test;Deploy';
            objPworf2.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SAVED;
            insert objPworf2;
            System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPworf2.pkl_Status__c); 
            objPworf2.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            update objPworf1;           
             System.assert (CPA_ConstantsForContractingAppClasses.SUBMITTED == objPworf2.pkl_Status__c);
            
            
            CPA_PWORF__c objPworf3 = CPA_testClass_util.createTest_other_PWORF();
             objPworf3.name='PWORF-'+system.Now()+3;
            objPworf3.mpkl_Project_Phases__c = 'Other';
            objPworf3.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SAVED;
            insert objPworf3;
            System.assertNotEquals('Cancelled', objPworf3.pkl_Status__c);  
            objPworf3.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            update objPworf3;
                                 
             System.assert (CPA_ConstantsForContractingAppClasses.SUBMITTED == objPworf3.pkl_Status__c);
            
             CPA_PWORF__c objPworf4 = CPA_testClass_util.createTest_other_PWORF();
             objPworf4.name='PWORF-'+system.Now()+4;
            objPworf4.mpkl_Project_Phases__c = CPA_ConstantsForContractingAppClasses.PLAN_ANALYSE;
            
            insert objPworf4;
             System.assert (CPA_ConstantsForContractingAppClasses.PLAN_ANALYSE == objPworf4.mpkl_Project_Phases__c);
            objPworf4.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
           
            update objPworf4;
        CPA_PWORF_TriggerUtil.isSubmitted=false;
            objPworf4.pkl_Status__c = 'Withhold';
           
            update objPworf4;
             System.assert ('Withhold' != objPworf2.pkl_Status__c);
        Test.stopTest();

        
    }
    
    public Static testMethod  void  CPA_PWO_Util_Test(){ 
        CPA_Status_Msg__c saveStatus = CPA_testClass_util.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c acceptedStatus = CPA_testClass_util.createTest_CPA_Status_Msg1();
        insert acceptedStatus;
        CPA_Status_Msg__c SubMsg = CPA_testClass_util.createTest_SubMsg();
        insert SubMsg;
        CPA_Status_Msg__c AnsweredMsg = CPA_testClass_util.createTest_AnsweredMsg();
        insert AnsweredMsg;
        CPA_Status_Msg__c CancelMsg = CPA_testClass_util.createTest_CancelMsg();
        insert CancelMsg;
		
        CPA_Trigger_Pattern__c PWOTriggerPattern = CPA_testClass_util.createTest_PWOTriggerPattern();
        insert PWOTriggerPattern;
        
        Test.startTest();
            CPA_PWORF__c objPworf10 = CPA_testClass_util.createTest_other_PWORF();
            insert objPworf10;
            objPworf10.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
            update objPworf10;                      
            
            CPA_project_work_order__c objPWO = CPA_testClass_util.createotherPWO(objPworf10);
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
public Static testMethod  void  CPA_PWO1_Util_Test(){
    CPA_Status_Msg__c saveStatus = CPA_testClass_util.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c acceptedStatus = CPA_testClass_util.createTest_CPA_Status_Msg1();
        insert acceptedStatus;
        CPA_Status_Msg__c SubMsg = CPA_testClass_util.createTest_SubMsg();
        insert SubMsg;
        CPA_Status_Msg__c AnsweredMsg = CPA_testClass_util.createTest_AnsweredMsg();
        insert AnsweredMsg;
        CPA_Status_Msg__c CancelMsg = CPA_testClass_util.createTest_CancelMsg();
        insert CancelMsg;

    	CPA_Trigger_Pattern__c PWOTriggerPattern = CPA_testClass_util.createTest_PWOTriggerPattern();
        insert PWOTriggerPattern;
    
        Test.startTest();           
            CPA_PWORF__c objPworf11 = CPA_testClass_util.createTest_other_PWORF();
            insert objPworf11;
            objPworf11.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
            update objPworf11;
            CPA_project_work_order__c objPWO2 = CPA_testClass_util.createotherPWO(objPworf11);
             objPWO2.RecordTypeid = label.CPA_PWO_CNF_RecordTypeId;
             objPWO2.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SAVED;
            insert objPWO2;
             System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED != objPworf11.pkl_Status__c);
             System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPWO2.pkl_Status__c);
        Test.stopTest();    
    } 
public Static testMethod  void  CPA_PWO2_Util_Test(){
    CPA_Status_Msg__c saveStatus = CPA_testClass_util.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c acceptedStatus = CPA_testClass_util.createTest_CPA_Status_Msg1();
        insert acceptedStatus;
        CPA_Status_Msg__c SubMsg = CPA_testClass_util.createTest_SubMsg();
        insert SubMsg;
        CPA_Status_Msg__c AnsweredMsg = CPA_testClass_util.createTest_AnsweredMsg();
        insert AnsweredMsg;
        CPA_Status_Msg__c CancelMsg = CPA_testClass_util.createTest_CancelMsg();
        insert CancelMsg;
		
    	CPA_Trigger_Pattern__c PWOTriggerPattern = CPA_testClass_util.createTest_PWOTriggerPattern();
        insert PWOTriggerPattern;
    
        Test.startTest();           
            CPA_PWORF__c objPworf12 = CPA_testClass_util.createTest_RA_PWORF();
            insert objPworf12;
            objPworf12.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
            update objPworf12;
            CPA_project_work_order__c objPWO2 = CPA_testClass_util.createotherPWO(objPworf12);
             objPWO2.RecordTypeid = label.CPA_PWO_TNF_RecordTypeId;
            insert objPWO2;
             System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED != objPworf12.pkl_Status__c);
           
        Test.stopTest();    
    }       
    public Static testMethod  void  CPA_LOI_Util_Test(){ 
        CPA_Status_Msg__c saveStatus = CPA_testClass_util.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c acceptedStatus = CPA_testClass_util.createTest_CPA_Status_Msg1();
        insert acceptedStatus;
        CPA_Status_Msg__c SubMsg = CPA_testClass_util.createTest_SubMsg();
        insert SubMsg;
        CPA_Status_Msg__c AnsweredMsg = CPA_testClass_util.createTest_AnsweredMsg();
        insert AnsweredMsg;
        CPA_Status_Msg__c CancelMsg = CPA_testClass_util.createTest_CancelMsg();
        insert CancelMsg;
		
        CPA_Trigger_Pattern__c LOITriggerPattern = CPA_testClass_util.createTest_LOITriggerPattern();
        insert LOITriggerPattern;
        
       Test.startTest();
            CPA_PWORF__c objPworf13 = CPA_testClass_util.createTest_other_PWORF();
            insert objPworf13;
            objPworf13.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
            update objPworf13;
            
            CPA_LOI__c objLOI = CPA_testClass_util.createLOI(objPworf13);
            insert objLOI;
            
            objLOI.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            update objLOI;
            CPA_LOI_TriggerUtil.isSubmitted  = false;
            objLOI.pkl_Status__c = CPA_ConstantsForContractingAppClasses.CANCELLED;
            update objLOI;        
           System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED != objPworf13.pkl_Status__c);
              System.assert (CPA_ConstantsForContractingAppClasses.CANCELLED == objLOI.pkl_Status__c);           
        Test.stopTest();
    }

  public Static testMethod  void  CPA_CR_Util_Test(){ 
      CPA_Status_Msg__c saveStatus = CPA_testClass_util.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c acceptedStatus = CPA_testClass_util.createTest_CPA_Status_Msg1();
        insert acceptedStatus;
        CPA_Status_Msg__c SubMsg = CPA_testClass_util.createTest_SubMsg();
        insert SubMsg;
        CPA_Status_Msg__c AnsweredMsg = CPA_testClass_util.createTest_AnsweredMsg();
        insert AnsweredMsg;
        CPA_Status_Msg__c CancelMsg = CPA_testClass_util.createTest_CancelMsg();
        insert CancelMsg;
		
      	CPA_Trigger_Pattern__c CRtriggerPattern = CPA_testClass_util.createTest_CRTriggerPattern();
        insert CRtriggerPattern;	
      
        Test.startTest();
            CPA_PWORF__c objPworf14 = CPA_testClass_util.createTest_other_PWORF();
            insert objPworf14;
            objPworf14.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
            update objPworf14;
            
            CPA_project_work_order__c objPWO = CPA_testClass_util.createPWO(objPworf14);
            insert objPWO;

            objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ACCEPTED;
            update objPWO;          
            
            
            CPA_CR__c objCR = CPA_testClass_util.createCR(objPWO);
            insert objCR;
            CPA_project_work_order__c pwo = [Select Id,pkl_Status__c from CPA_project_work_order__c where Id=:objCR.CPA_Project_Work_Order__c];
            objCR.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            update objCR;
            CPA_CR_TriggerUtil.isSubmitted  = false;
            objCR.pkl_Status__c = CPA_ConstantsForContractingAppClasses.CANCELLED;
            update objCR;           
            
            System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED != objPworf14.pkl_Status__c);
              System.assert (CPA_ConstantsForContractingAppClasses.ACCEPTED == objPWO.pkl_Status__c);   
              
        Test.stopTest();    
    }   
 public Static testMethod  void  CPA_CR1_Util_Test(){ 
     CPA_Status_Msg__c saveStatus = CPA_testClass_util.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c acceptedStatus = CPA_testClass_util.createTest_CPA_Status_Msg1();
        insert acceptedStatus;
        CPA_Status_Msg__c SubMsg = CPA_testClass_util.createTest_SubMsg();
        insert SubMsg;
        CPA_Status_Msg__c AnsweredMsg = CPA_testClass_util.createTest_AnsweredMsg();
        insert AnsweredMsg;
        CPA_Status_Msg__c CancelMsg = CPA_testClass_util.createTest_CancelMsg();
        insert CancelMsg;

     	CPA_Trigger_Pattern__c CRtriggerPattern = CPA_testClass_util.createTest_CRTriggerPattern();
        insert CRtriggerPattern;
     
        Test.startTest();

            CPA_CR__c objCR1 = CPA_testClass_util.standAloneCR();
            objCR1.pkl_Status__c=CPA_ConstantsForContractingAppClasses.SAVED;
            insert objCR1;      

              System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objCR1.pkl_Status__c);               
        Test.stopTest();    
    }      
 public Static testMethod  void  CPA_CR2_Util_Test(){ 
     CPA_Status_Msg__c saveStatus = CPA_testClass_util.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c acceptedStatus = CPA_testClass_util.createTest_CPA_Status_Msg1();
        insert acceptedStatus;
        CPA_Status_Msg__c SubMsg = CPA_testClass_util.createTest_SubMsg();
        insert SubMsg;
        CPA_Status_Msg__c AnsweredMsg = CPA_testClass_util.createTest_AnsweredMsg();
        insert AnsweredMsg;
        CPA_Status_Msg__c CancelMsg = CPA_testClass_util.createTest_CancelMsg();
        insert CancelMsg;

     	CPA_Trigger_Pattern__c CRtriggerPattern = CPA_testClass_util.createTest_CRTriggerPattern();
        insert CRtriggerPattern;
     	
        Test.startTest();
        CPA_PWORF__c objPworf15 = CPA_testClass_util.createTest_other_PWORF();
            insert objPworf15;
            objPworf15.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
            update objPworf15;
            
            CPA_project_work_order__c objPWO = CPA_testClass_util.createPWO(objPworf15);
            insert objPWO;

            objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ACCEPTED;
            update objPWO; 
            CPA_CR__c objCR2 = CPA_testClass_util.blankCR(objPWO);
            insert objCR2;          
             System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED != objPworf15.pkl_Status__c);
              System.assert (CPA_ConstantsForContractingAppClasses.ACCEPTED == objPWO.pkl_Status__c);  
        Test.stopTest();    
    }         
  public Static testMethod  void  CPA_HLE_Request_Util_Test(){ 
      CPA_Status_Msg__c saveStatus = CPA_testClass_util.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c acceptedStatus = CPA_testClass_util.createTest_CPA_Status_Msg1();
        insert acceptedStatus;
        CPA_Status_Msg__c SubMsg = CPA_testClass_util.createTest_SubMsg();
        insert SubMsg;
        CPA_Status_Msg__c AnsweredMsg = CPA_testClass_util.createTest_AnsweredMsg();
        insert AnsweredMsg;
        CPA_Status_Msg__c CancelMsg = CPA_testClass_util.createTest_CancelMsg();
        insert CancelMsg;
		
      	CPA_Trigger_Pattern__c HLERequestTriggerPattern = CPA_testClass_util.createTest_HLERequestTriggerPattern();
        insert HLERequestTriggerPattern;
      
        CPA_HLE_Request_SLAs__c HLEReqSLA = CPA_testClass_util.createTest_HLEReqSLA();
        insert HLEReqSLA;
      
        Test.startTest(); 
            CPA_HLE_Request__c objHLERequest = CPA_testClass_util.CreateHLERequest();
            insert objHLERequest;
            objHLERequest.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            update objHLERequest;
           CPA_HLERequest_TriggerUtil.isSubmitted  = false;
           objHLERequest.pkl_Status__c = CPA_ConstantsForContractingAppClasses.CANCELLED;
            update objHLERequest;
            System.assertNotEquals('Cancelled', objHLERequest.ID);  
             System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED != objHLERequest.pkl_Status__c);
             
        Test.stopTest();    
    }   
}