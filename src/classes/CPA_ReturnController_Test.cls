@isTest(SeeAllData=true)
public class CPA_ReturnController_Test {
    static testmethod void LOIreturnController_Test() {
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf;
        
        objPworf.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ACCEPTED ;
        update objPworf;
        
        CPA_LOI__c objLOI =CPA_testClass_util.createLOI (objPworf);
        objLOI.pkl_Status__c =CPA_ConstantsForContractingAppClasses.RETURNED;
        insert  objLOI;

        Test.setCurrentPage(new PageReference('CPA_LOI_Reason_for_return'));
        System.currentPageReference().getParameters().put('id', objLOI.id);
        CPA_LOI_ReturnReasonController   controller = new CPA_LOI_ReturnReasonController  (new ApexPages.StandardController(objLOI));
        System.assert(CPA_ConstantsForContractingAppClasses.RETURNED == objLOI.pkl_Status__c);
        controller.SaveCancelReason();
        
        System.assert(CPA_ConstantsForContractingAppClasses.RETURNED== objLOI.pkl_Status__c);
        
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;
        
        objPworf1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ACCEPTED ;
        update objPworf1;
        
        CPA_LOI__c objLOI1 =CPA_testClass_util.createLOI (objPworf1);
        objLOI1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ACCEPTED;
        insert  objLOI1;

        Test.setCurrentPage(new PageReference('CPA_LOI_Reason_for_return'));
        System.currentPageReference().getParameters().put('id', objLOI1.id);
        CPA_LOI_ReturnReasonController   controller1 = new CPA_LOI_ReturnReasonController  (new ApexPages.StandardController(objLOI1));
        controller.CancelReason();
        System.assert(CPA_ConstantsForContractingAppClasses.ACCEPTED == objLOI1.pkl_Status__c);
       // System.assertEquals(CPA_ConstantsForContractingAppClasses.ACCEPTED, objLOI1.pkl_Status__c);
        
        
     Test.stopTest();
    
    }
 static testmethod void PWOreturnController_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED ;
        update objPworf1;
        System.assert(CPA_ConstantsForContractingAppClasses.ANSWERED== objPworf1.pkl_Status__c);
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf1);
        
        insert  objPWO;
        
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SIGNED;
        update objPWO;       
        System.assert(CPA_ConstantsForContractingAppClasses.SIGNED == objPWO.pkl_Status__c);
        Test.setCurrentPage(new PageReference('CPA_PwoCnfTnf_Return_Reason'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put('recordType', 'PWO');  
        CPA_PwoCnfTnf_ReturnReasonController   controller = new CPA_PwoCnfTnf_ReturnReasonController  (new ApexPages.StandardController(objPWO));
       controller.getRecord(objPWO.id);
       controller.SaveCancelReason();
       
       System.assert(CPA_ConstantsForContractingAppClasses.SIGNED == objPWO.pkl_Status__c);
        Test.stopTest();
    }
    static testmethod void  CNFreturnController_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED ;
        update objPworf1;
       
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf1);
        insert  objPWO;
        
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SIGNED;
        update objPWO;       
        System.assert(CPA_ConstantsForContractingAppClasses.SIGNED == objPWO.pkl_Status__c);
        Test.setCurrentPage(new PageReference('CPA_PwoCnfTnf_Return_Reason'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put('recordType', 'CNF');  
        CPA_PwoCnfTnf_ReturnReasonController   controller = new CPA_PwoCnfTnf_ReturnReasonController  (new ApexPages.StandardController(objPWO));
       controller.getRecord(objPWO.id);
       controller.SaveCancelReason();
        System.assert(CPA_ConstantsForContractingAppClasses.SIGNED== objPWO.pkl_Status__c);
        Test.stopTest();
    }
 static testmethod void  TNFreturnController_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED ;
        update objPworf1;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf1);
        insert  objPWO;
        
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SIGNED;
        update objPWO;       
        System.assert(CPA_ConstantsForContractingAppClasses.SIGNED == objPWO.pkl_Status__c);
        Test.setCurrentPage(new PageReference('CPA_PwoCnfTnf_Return_Reason'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put('recordType', 'TNF');  
        CPA_PwoCnfTnf_ReturnReasonController   controller = new CPA_PwoCnfTnf_ReturnReasonController  (new ApexPages.StandardController(objPWO));
        controller.getRecord(objPWO.id);
       
         System.assert (CPA_ConstantsForContractingAppClasses.SIGNED == objPWO.pkl_Status__c);
         controller.SaveCancelReason();
        Test.stopTest();
    }
  static testmethod void  CRreturnController_Test() {
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf;

       objPworf.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED ;
        update objPworf;
        System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED== objPworf.pkl_Status__c);
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf);
        insert  objPWO;
        
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.DELIVERED ;
        update objPWO;
        System.assert (CPA_ConstantsForContractingAppClasses.DELIVERED == objPWO.pkl_Status__c);
        
        CPA_CR__c objCR1 = CPA_testClass_util.createCR(objPWO);      
        objCR1.pkl_Status__c= CPA_ConstantsForContractingAppClasses.DELIVERED;
        insert objCR1;
       

        Test.setCurrentPage(new PageReference('CPA_CR_Reason_for_return'));
        System.currentPageReference().getParameters().put('id', objCR1.id);
        CPA_CR_ReturnReasonController   controller = new CPA_CR_ReturnReasonController  (new ApexPages.StandardController(objCR1));
       controller.SaveCancelReason();
      controller.CancelReason();
      System.assert(CPA_ConstantsForContractingAppClasses.DELIVERED == objCR1.pkl_Status__c);
        Test.stopTest();
    
    }
 static testmethod void  PWORFwithholdController_Test() {
        
     CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
     objPworf.pkl_Status__c = CPA_ConstantsForContractingAppClasses.CANCELLED;
        insert objPworf;
        System.assert(CPA_ConstantsForContractingAppClasses.CANCELLED == objPworf.pkl_Status__c);
        Test.startTest();

        Test.setCurrentPage(new PageReference('CPA_PWORF_Reason_for_Withhold'));
        System.currentPageReference().getParameters().put('id', objPworf.id);
        CPA_PWORF_WithholdReasonController  controller = new CPA_PWORF_WithholdReasonController (new ApexPages.StandardController(objPworf));
        controller.SaveCancelReason();
      controller.CancelReason();
      System.assert(CPA_ConstantsForContractingAppClasses.CANCELLED == objPworf.pkl_Status__c);
        Test.stopTest();
    }
}