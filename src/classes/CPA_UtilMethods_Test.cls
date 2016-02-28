@isTest(SeeAllData=true)
private class CPA_UtilMethods_Test {
    
    public Static testMethod  void CPA_PWORF_Util_Test(){  
        Test.startTest();   
                        
            CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
            objPworf1.Name = 'PWORF-'+system.Now()+1;
           objPworf1.mpkl_Project_Phases__c = 'Design; Build; Test; Deploy';
            insert objPworf1;
            
            objPworf1.pkl_Status__c = 'Submitted';
            update objPworf1;
            
            objPworf1.pkl_Status__c = 'Auto Accepted';
            update objPworf1;
            System.assertNotEquals('Cancelled', objPworf1.pkl_Status__c);   
           
            CPA_PWORF__c objPworf2 = CPA_testClass_util.createTest_other_PWORF();
             objPworf2.name='PWORF-'+system.Now()+2;
            objPworf2.mpkl_Project_Phases__c = 'Plan;Analyse;Design;Build;Test;Deploy';
            
            insert objPworf2;
            System.assertNotEquals('Cancelled', objPworf2.pkl_Status__c);   
            objPworf2.pkl_Status__c = 'Submitted';
            update objPworf1;           
            System.assertNotEquals('Cancelled', objPworf1.pkl_Status__c);  
            
            
            CPA_PWORF__c objPworf3 = CPA_testClass_util.createTest_other_PWORF();
             objPworf3.name='PWORF-'+system.Now()+3;
            objPworf3.mpkl_Project_Phases__c = 'Other';
            
            insert objPworf3;
            System.assertNotEquals('Cancelled', objPworf3.pkl_Status__c);  
            objPworf3.pkl_Status__c = 'Submitted';
            update objPworf3;
                                 
            System.assertNotEquals('Cancelled', objPworf3.pkl_Status__c);  
            
             CPA_PWORF__c objPworf4 = CPA_testClass_util.createTest_other_PWORF();
             objPworf4.name='PWORF-'+system.Now()+4;
            objPworf4.mpkl_Project_Phases__c = 'Plan;Analyse;';
            
            insert objPworf4;
            
            objPworf4.pkl_Status__c = 'Submitted';
           
            update objPworf4;
        CPA_PWORF_TriggerUtil.isSubmitted=false;
            objPworf4.pkl_Status__c = 'Withhold';
           
            update objPworf4;
             System.assertNotEquals('Cancelled', objPworf4.pkl_Status__c);
        Test.stopTest();

        
    }
    
    public Static testMethod  void  CPA_PWO_Util_Test(){ 
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
              System.assertNotEquals('Cancelled', objPworf10.pkl_Status__c);
              System.assertNotEquals('Cancelled', objPWO.ID);
        Test.stopTest();    
    }   
public Static testMethod  void  CPA_PWO1_Util_Test(){ 
        Test.startTest();           
            CPA_PWORF__c objPworf11 = CPA_testClass_util.createTest_other_PWORF();
            insert objPworf11;
            objPworf11.pkl_Status__c = 'Answered';
            update objPworf11;
            CPA_project_work_order__c objPWO2 = CPA_testClass_util.createotherPWO(objPworf11);
             objPWO2.RecordTypeid = label.CPA_PWO_CNF_RecordTypeId;
            insert objPWO2;
             System.assertNotEquals('Cancelled', objPworf11.pkl_Status__c);
              System.assertNotEquals('Cancelled', objPWO2.ID);
        Test.stopTest();    
    } 
public Static testMethod  void  CPA_PWO2_Util_Test(){ 
        Test.startTest();           
            CPA_PWORF__c objPworf12 = CPA_testClass_util.createTest_RA_PWORF();
            insert objPworf12;
            objPworf12.pkl_Status__c = 'Answered';
            update objPworf12;
            CPA_project_work_order__c objPWO2 = CPA_testClass_util.createotherPWO(objPworf12);
             objPWO2.RecordTypeid = label.CPA_PWO_TNF_RecordTypeId;
            insert objPWO2;
            System.assertNotEquals('Cancelled', objPworf12.pkl_Status__c);
              System.assertNotEquals('Cancelled', objPWO2.ID);
        Test.stopTest();    
    }       
    public Static testMethod  void  CPA_LOI_Util_Test(){ 
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
            System.assertNotEquals('Cancelled', objPworf13.pkl_Status__c);
              System.assertNotEquals('Cancelled', objLOI.ID);           
        Test.stopTest();
    }

  public Static testMethod  void  CPA_CR_Util_Test(){ 
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
            
            System.assertNotEquals('Cancelled', objPworf14.pkl_Status__c);
              System.assertNotEquals('Cancelled', objCR.ID);    
        Test.stopTest();    
    }   
 public Static testMethod  void  CPA_CR1_Util_Test(){ 
        Test.startTest();

            CPA_CR__c objCR1 = CPA_testClass_util.standAloneCR();
            insert objCR1;      

              System.assertNotEquals('Cancelled', objCR1.ID);               
        Test.stopTest();    
    }      
 public Static testMethod  void  CPA_CR2_Util_Test(){ 
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
             System.assertNotEquals('Cancelled', objCR2.ID);    
              System.assertNotEquals('Cancelled', objPworf15.pkl_Status__c);
        Test.stopTest();    
    }         
  public Static testMethod  void  CPA_HLE_Request_Util_Test(){ 
        Test.startTest(); 
            CPA_HLE_Request__c objHLERequest = CPA_testClass_util.CreateHLERequest();
            insert objHLERequest;
            objHLERequest.pkl_Status__c = 'Submitted';
            update objHLERequest;
           CPA_HLERequest_TriggerUtil.isSubmitted  = false;
           objHLERequest.pkl_Status__c = 'Cancelled';
            update objHLERequest;
            System.assertNotEquals('Cancelled', objHLERequest.ID);  
             // System.assertNotEquals('Cancelled', objPworf15.pkl_Status__c);
        Test.stopTest();    
    }   
}