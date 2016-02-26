@isTest(SeeAllData=true)
private class Test_CPA_UtilMethods {
    
    public Static testMethod  void Test_CPA_PWORF_Util(){  
        Test.startTest();   
                        
            CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
            objPworf1.Name = 'PWORF-'+system.Now()+1;
           objPworf1.mpkl_Project_Phases__c = 'Design; Build; Test; Deploy';
            insert objPworf1;
            
            objPworf1.pkl_Status__c = 'Submitted';
            update objPworf1;
            
            objPworf1.pkl_Status__c = 'Auto Accepted';
            update objPworf1;
            
           
            CPA_PWORF__c objPworf2 = CPA_testClass_util.createTest_other_PWORF();
             objPworf2.name='PWORF-'+system.Now()+2;
            objPworf2.mpkl_Project_Phases__c = 'Plan;Analyse;Design;Build;Test;Deploy';
            
            insert objPworf2;
            
            objPworf2.pkl_Status__c = 'Submitted';
            update objPworf1;           
           
            
            
            CPA_PWORF__c objPworf3 = CPA_testClass_util.createTest_other_PWORF();
             objPworf3.name='PWORF-'+system.Now()+3;
            objPworf3.mpkl_Project_Phases__c = 'Other';
            
            insert objPworf3;
            
            objPworf3.pkl_Status__c = 'Submitted';
            update objPworf1;
                                 
            
            
             CPA_PWORF__c objPworf4 = CPA_testClass_util.createTest_other_PWORF();
             objPworf4.name='PWORF-'+system.Now()+4;
            objPworf4.mpkl_Project_Phases__c = 'Plan;Analyse;';
            
            insert objPworf4;
            
            objPworf4.pkl_Status__c = 'Submitted';
           
            update objPworf4;
        CPA_PWORF_TriggerUtil.isSubmitted=false;
            objPworf4.pkl_Status__c = 'Withhold';
           
            update objPworf4;
            
        Test.stopTest();

        
    }
    
    public Static testMethod  void Test_CPA_PWO_Util(){ 
        Test.startTest();
            CPA_PWORF__c objPworf10 = CPA_testClass_util.createTest_other_PWORF();
            insert objPworf10;
            objPworf10.pkl_Status__c = 'Answered';
            update objPworf10;                      
            
            CPA_project_work_order__c objPWO = CPA_testClass_util.createotherPWO(objPworf10);
            insert objPWO;
             CPA_Project_Work_Order_TriggerUtil.isSubmitted=false;
            objPWO.pkl_Status__c = 'Submitted';
            update objPWO;
         CPA_Project_Work_Order_TriggerUtil.isSubmitted=false;
            objPWO.pkl_Status__c = 'Cancelled';
            update objPWO;
        Test.stopTest();    
    }   
public Static testMethod  void Test_CPA_PWO1_Util(){ 
        Test.startTest();			
            CPA_PWORF__c objPworf11 = CPA_testClass_util.createTest_other_PWORF();
            insert objPworf11;
			objPworf11.pkl_Status__c = 'Answered';
            update objPworf11;
            CPA_project_work_order__c objPWO2 = CPA_testClass_util.createotherPWO(objPworf11);
             objPWO2.RecordTypeid = label.Lbl_PWO_CNF_RecordTypeId;
            insert objPWO2;
        Test.stopTest();    
    } 
public Static testMethod  void Test_CPA_PWO2_Util(){ 
        Test.startTest();			
            CPA_PWORF__c objPworf12 = CPA_testClass_util.createTest_RA_PWORF();
            insert objPworf12;
			objPworf12.pkl_Status__c = 'Answered';
            update objPworf12;
            CPA_project_work_order__c objPWO2 = CPA_testClass_util.createotherPWO(objPworf12);
             objPWO2.RecordTypeid = label.Lbl_PWO_TNF_RecordTypeId;
            insert objPWO2;
        Test.stopTest();    
    }   	
    public Static testMethod  void Test_CPA_LOI_Util(){ 
       Test.startTest();
            CPA_PWORF__c objPworf13 = CPA_testClass_util.createTest_other_PWORF();
            insert objPworf13;
            objPworf13.pkl_Status__c = 'Answered';
            update objPworf13;
            
            CPA_LOI__c objLOI = CPA_testClass_util.createLOI(objPworf13);
            insert objLOI;
            
            objLOI.pkl_Status__c = 'Submitted';
            update objLOI;
            CPA_LOI_TriggerUtil.isSubmitted  = false;
            objLOI.pkl_Status__c = 'Cancelled';
            update objLOI;           
        Test.stopTest();
    }

  public Static testMethod  void Test_CPA_CR_Util(){ 
        Test.startTest();
            CPA_PWORF__c objPworf14 = CPA_testClass_util.createTest_other_PWORF();
            insert objPworf14;
            objPworf14.pkl_Status__c = 'Answered';
            update objPworf14;
            
            CPA_project_work_order__c objPWO = CPA_testClass_util.createPWO(objPworf14);
            insert objPWO;

            objPWO.pkl_Status__c = 'Accepted';
            update objPWO;          
            
            
            CPA_CR__c objCR = CPA_testClass_util.createCR(objPWO);
            insert objCR;
            CPA_project_work_order__c pwo = [Select Id,pkl_Status__c from CPA_project_work_order__c where Id=:objCR.CPA_Project_Work_Order__c];
            objCR.pkl_Status__c = 'Submitted';
            update objCR;
            CPA_CR_TriggerUtil.isSubmitted  = false;
            objCR.pkl_Status__c = 'Cancelled';
            update objCR;           
            
            
        Test.stopTest();    
    }   
 public Static testMethod  void Test_CPA_CR1_Util(){ 
        Test.startTest();

            CPA_CR__c objCR1 = CPA_testClass_util.standAloneCR();
            insert objCR1;          
        Test.stopTest();    
    }      
 public Static testMethod  void Test_CPA_CR2_Util(){ 
        Test.startTest();
		CPA_PWORF__c objPworf15 = CPA_testClass_util.createTest_other_PWORF();
            insert objPworf15;
            objPworf15.pkl_Status__c = 'Answered';
            update objPworf15;
            
            CPA_project_work_order__c objPWO = CPA_testClass_util.createPWO(objPworf15);
            insert objPWO;

            objPWO.pkl_Status__c = 'Accepted';
            update objPWO; 
            CPA_CR__c objCR2 = CPA_testClass_util.blankCR(objPWO);
            insert objCR2;          
        Test.stopTest();    
    }         
  public Static testMethod  void Test_CPA_HLE_Request_Util(){ 
        Test.startTest(); 
            CPA_HLE_Request__c objHLERequest = CPA_testClass_util.CreateHLERequest();
            insert objHLERequest;
            objHLERequest.pkl_Status__c = 'Submitted';
            update objHLERequest;
           CPA_HLERequest_TriggerUtil.isSubmitted  = false;
           objHLERequest.pkl_Status__c = 'Cancelled';
            update objHLERequest;
        Test.stopTest();    
    }   
}