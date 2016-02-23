@isTest(SeeAllData=true)
public class Test_CPA_ReturnController {
	static testmethod void Test_LOIreturnController() {
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

        controller.SaveCancelReason();
        controller.CancelReason();
     Test.stopTest();
    
    }
 static testmethod void Test_PWOreturnController() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c ='Answered' ;
        update objPworf1;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf1);
        insert  objPWO;
        
        objPWO.pkl_Status__c ='Signed';
        update objPWO;       

        Test.setCurrentPage(new PageReference('CPA_PwoCnfTnf_Return_Reason'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
     	System.currentPageReference().getParameters().put('recordType', 'PWO');  
        CPA_PwoCnfTnf_ReturnReasonController   controller = new CPA_PwoCnfTnf_ReturnReasonController  (new ApexPages.StandardController(objPWO));
       controller.getRecord(objPWO.id);
       controller.SaveCancelReason();
       controller.CancelReason();
        Test.stopTest();
    }
    static testmethod void Test_CNFreturnController() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c ='Answered' ;
        update objPworf1;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf1);
        insert  objPWO;
        
        objPWO.pkl_Status__c ='Signed';
        update objPWO;       

        Test.setCurrentPage(new PageReference('CPA_PwoCnfTnf_Return_Reason'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
     	System.currentPageReference().getParameters().put('recordType', 'CNF');  
        CPA_PwoCnfTnf_ReturnReasonController   controller = new CPA_PwoCnfTnf_ReturnReasonController  (new ApexPages.StandardController(objPWO));
       controller.getRecord(objPWO.id);
       controller.SaveCancelReason();
     
        Test.stopTest();
    }
 static testmethod void Test_TNFreturnController() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c ='Answered' ;
        update objPworf1;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf1);
        insert  objPWO;
        
        objPWO.pkl_Status__c ='Signed';
        update objPWO;       

        Test.setCurrentPage(new PageReference('CPA_PwoCnfTnf_Return_Reason'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
     	System.currentPageReference().getParameters().put('recordType', 'TNF');  
        CPA_PwoCnfTnf_ReturnReasonController   controller = new CPA_PwoCnfTnf_ReturnReasonController  (new ApexPages.StandardController(objPWO));
       controller.getRecord(objPWO.id);
       controller.SaveCancelReason();
     
        Test.stopTest();
    }
  static testmethod void Test_CRreturnController() {
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf;

       objPworf.pkl_Status__c ='Answered' ;
        update objPworf;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf);
        insert  objPWO;
        
        objPWO.pkl_Status__c ='Delivered';
        update objPWO;
        
        
        CPA_CR__c objCR1 = CPA_testClass_util.createCR(objPWO);      
        insert objCR1;
        

        Test.setCurrentPage(new PageReference('CPA_CR_Reason_for_return'));
        System.currentPageReference().getParameters().put('id', objCR1.id);
        CPA_CR_ReturnReasonController   controller = new CPA_CR_ReturnReasonController  (new ApexPages.StandardController(objCR1));
       controller.SaveCancelReason();
      controller.CancelReason();
        Test.stopTest();
    
    }
 static testmethod void Test_PWORFwithholdController() {
        
     CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf;

        Test.startTest();

        Test.setCurrentPage(new PageReference('CPA_PWORF_Reason_for_Withhold'));
        System.currentPageReference().getParameters().put('id', objPworf.id);
        CPA_PWORF_WithholdReasonController  controller = new CPA_PWORF_WithholdReasonController (new ApexPages.StandardController(objPworf));
		controller.SaveCancelReason();
      controller.CancelReason();
        Test.stopTest();
    }
}