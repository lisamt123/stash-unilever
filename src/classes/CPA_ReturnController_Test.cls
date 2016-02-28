@isTest(SeeAllData=true)
public class CPA_ReturnController_Test {
    static testmethod void LOIreturnController_Test() {
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf;
        
        objPworf.pkl_Status__c ='Accepted' ;
        update objPworf;
        
        CPA_LOI__c objLOI =CPA_testClass_util.createLOI (objPworf);
        insert  objLOI;

        Test.setCurrentPage(new PageReference('CPA_LOI_Reason_for_return'));
        System.currentPageReference().getParameters().put('id', objLOI.id);
        CPA_LOI_ReturnReasonController   controller = new CPA_LOI_ReturnReasonController  (new ApexPages.StandardController(objLOI));
        System.assertNotEquals('Cancelled', objLOI.pkl_Status__c);
        controller.SaveCancelReason();
        controller.CancelReason();
        System.assertNotEquals('Cancelled', objLOI.pkl_Status__c);
     Test.stopTest();
    
    }
 static testmethod void PWOreturnController_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c ='Answered' ;
        update objPworf1;
        System.assertNotEquals('Cancelled', objPworf1.pkl_Status__c);
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf1);
        insert  objPWO;
        System.assertNotEquals('Cancelled', objPWO.pkl_Status__c);
        objPWO.pkl_Status__c ='Signed';
        update objPWO;       
        System.assertNotEquals('Cancelled', objPWO.pkl_Status__c);
        Test.setCurrentPage(new PageReference('CPA_PwoCnfTnf_Return_Reason'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put('recordType', 'PWO');  
        CPA_PwoCnfTnf_ReturnReasonController   controller = new CPA_PwoCnfTnf_ReturnReasonController  (new ApexPages.StandardController(objPWO));
       controller.getRecord(objPWO.id);
       controller.SaveCancelReason();
       controller.CancelReason();
       System.assertNotEquals('Cancelled', objPWO.pkl_Status__c);
        Test.stopTest();
    }
    static testmethod void  CNFreturnController_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;
System.assertNotEquals('Cancelled', objPworf1.pkl_Status__c);
       objPworf1.pkl_Status__c ='Answered' ;
        update objPworf1;
        System.assertNotEquals('Cancelled', objPworf1.pkl_Status__c);
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf1);
        insert  objPWO;
        System.assertNotEquals('Cancelled', objPWO.pkl_Status__c);
        objPWO.pkl_Status__c ='Signed';
        update objPWO;       
System.assertNotEquals('Cancelled', objPWO.pkl_Status__c);
        Test.setCurrentPage(new PageReference('CPA_PwoCnfTnf_Return_Reason'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put('recordType', 'CNF');  
        CPA_PwoCnfTnf_ReturnReasonController   controller = new CPA_PwoCnfTnf_ReturnReasonController  (new ApexPages.StandardController(objPWO));
       controller.getRecord(objPWO.id);
       controller.SaveCancelReason();
     System.assertNotEquals('Cancelled', objPWO.pkl_Status__c);
        Test.stopTest();
    }
 static testmethod void  TNFreturnController_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c ='Answered' ;
        update objPworf1;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf1);
        insert  objPWO;
        System.assertNotEquals('Cancelled', objPWO.pkl_Status__c);
        objPWO.pkl_Status__c ='Signed';
        update objPWO;       
System.assertNotEquals('Cancelled', objPWO.pkl_Status__c);
        Test.setCurrentPage(new PageReference('CPA_PwoCnfTnf_Return_Reason'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put('recordType', 'TNF');  
        CPA_PwoCnfTnf_ReturnReasonController   controller = new CPA_PwoCnfTnf_ReturnReasonController  (new ApexPages.StandardController(objPWO));
       controller.getRecord(objPWO.id);
       controller.SaveCancelReason();
     System.assertNotEquals('Cancelled', objPWO.pkl_Status__c);
        Test.stopTest();
    }
  static testmethod void  CRreturnController_Test() {
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf;

       objPworf.pkl_Status__c ='Answered' ;
        update objPworf;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf);
        insert  objPWO;
        System.assertNotEquals('Cancelled', objPWO.pkl_Status__c);
        objPWO.pkl_Status__c ='Delivered';
        update objPWO;
        System.assertNotEquals('Cancelled', objPWO.pkl_Status__c);
        
        CPA_CR__c objCR1 = CPA_testClass_util.createCR(objPWO);      
        insert objCR1;
        System.assertNotEquals('Cancelled', objCR1.pkl_Status__c);

        Test.setCurrentPage(new PageReference('CPA_CR_Reason_for_return'));
        System.currentPageReference().getParameters().put('id', objCR1.id);
        CPA_CR_ReturnReasonController   controller = new CPA_CR_ReturnReasonController  (new ApexPages.StandardController(objCR1));
       controller.SaveCancelReason();
      controller.CancelReason();
      System.assertNotEquals('Cancelled', objCR1.pkl_Status__c);
        Test.stopTest();
    
    }
 static testmethod void  PWORFwithholdController_Test() {
        
     CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf;
System.assertNotEquals('Cancelled', objPworf.pkl_Status__c);
        Test.startTest();

        Test.setCurrentPage(new PageReference('CPA_PWORF_Reason_for_Withhold'));
        System.currentPageReference().getParameters().put('id', objPworf.id);
        CPA_PWORF_WithholdReasonController  controller = new CPA_PWORF_WithholdReasonController (new ApexPages.StandardController(objPworf));
        controller.SaveCancelReason();
      controller.CancelReason();
      System.assertNotEquals('Cancelled', objPworf.pkl_Status__c);
        Test.stopTest();
    }
}