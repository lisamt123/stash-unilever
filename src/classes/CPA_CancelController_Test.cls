@isTest(SeeAllData=true)
public class CPA_CancelController_Test {
    static testmethod void LOICancelController_Test() {
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf;
        
        objPworf.pkl_Status__c ='Accepted' ;
        update objPworf;
        
        CPA_LOI__c objLOI =CPA_testClass_util.createLOI (objPworf);
        insert  objLOI;

        Test.setCurrentPage(new PageReference('CPA_LOI_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objLOI.id);
        CPA_LOI_CancelReasonController   controller = new CPA_LOI_CancelReasonController  (new ApexPages.StandardController(objLOI));
        System.assertNotEquals('Cancelled', objLOI.pkl_Status__c);
        
        CPA_LOI__c objLOI1 = new CPA_LOI__c ();
        insert objLOI1;

        Test.setCurrentPage(new PageReference('CPA_LOI_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objLOI1.id);
        CPA_LOI_CancelReasonController   controller1 = new CPA_LOI_CancelReasonController  (new ApexPages.StandardController(objLOI1));
        controller1.SaveCancelReason();
        System.assertNotEquals('Cancelled', objLOI1.pkl_Status__c);
     Test.stopTest();
    
    }
    static testmethod void CRCancelController_Test() {
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf;

       objPworf.pkl_Status__c ='Answered' ;
        update objPworf;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf);
        insert  objPWO;
        
        objPWO.pkl_Status__c ='Delivered';
        update objPWO;
        System.assertEquals('Delivered', objPWO.pkl_Status__c );
        
        CPA_CR__c objCR1 = CPA_testClass_util.createCR(objPWO);      
        insert objCR1;
        

        Test.setCurrentPage(new PageReference('CPA_CR_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objCR1.id);
        CPA_CR_CancelReasonController   controller = new CPA_CR_CancelReasonController  (new ApexPages.StandardController(objCR1));
       controller.SaveCancelReason();
       
       System.assertNotEquals('Cancelled', objCR1.pkl_Status__c);
        Test.stopTest();
    
    }
 static testmethod void HLECancelController_Test() {
        Test.startTest();
        CPA_HLE_Request__c objHLE = CPA_testClass_util.CreateHLERequest();      
        insert objHLE;
        
        Test.setCurrentPage(new PageReference('CPA_HLE_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objHLE.id);
        CPA_HLE_CancelReasonController   controller = new CPA_HLE_CancelReasonController  (new ApexPages.StandardController(objHLE));
       controller.SaveCancelReason();
     controller.CancelReason();
      System.assertNotEquals('Cancelled', objHLE.pkl_Status__c);
        Test.stopTest();
    
    }
 static testmethod void PWOcancelController_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c ='Answered' ;
        update objPworf1;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf1);
        insert  objPWO;
        
        objPWO.pkl_Status__c ='Signed';
        update objPWO;       
        System.assertEquals('Signed', objPWO.pkl_Status__c);
        Test.setCurrentPage(new PageReference('CPA_PwoCnfTnf_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put('recordType', 'PWO');  
        CPA_PwoCnfTnf_CancelReasonController   controller = new CPA_PwoCnfTnf_CancelReasonController  (new ApexPages.StandardController(objPWO));
       controller.getRecord(objPWO.id);
       controller.SaveCancelReason();
       System.assertEquals('Signed', objPWO.pkl_Status__c);
     
        Test.stopTest();
    }
    static testmethod void CNFcancelController_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c ='Answered' ;
        update objPworf1;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf1);
        insert  objPWO;
        
        objPWO.pkl_Status__c ='Delivered';
        update objPWO;       

        Test.setCurrentPage(new PageReference('CPA_PwoCnfTnf_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put('recordType', 'CNF');  
        CPA_PwoCnfTnf_CancelReasonController   controller = new CPA_PwoCnfTnf_CancelReasonController  (new ApexPages.StandardController(objPWO));
       controller.getRecord(objPWO.id);
       controller.SaveCancelReason();
       System.assertEquals('Delivered', objPWO.pkl_Status__c);
     
        Test.stopTest();
    }
 static testmethod void TNFcancelController_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c ='Answered' ;
        update objPworf1;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf1);
        insert  objPWO;
        
        objPWO.pkl_Status__c ='Signed';
        update objPWO;       

        Test.setCurrentPage(new PageReference('CPA_PwoCnfTnf_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put('recordType', 'TNF');  
        CPA_PwoCnfTnf_CancelReasonController   controller = new CPA_PwoCnfTnf_CancelReasonController  (new ApexPages.StandardController(objPWO));
       controller.getRecord(objPWO.id);
       controller.SaveCancelReason();
        System.assertEquals('Signed', objPWO.pkl_Status__c);
        Test.stopTest();
    }
 static testmethod void PWOcancelledController_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c ='Answered' ;
        update objPworf1;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf1);
        insert  objPWO;
        
        objPWO.pkl_Status__c ='Signed';
        update objPWO;       

        Test.setCurrentPage(new PageReference('CPA_PwoCnfTnf_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put('recordType', 'PWO');  
        CPA_PwoCnfTnf_CancelReasonController   controller = new CPA_PwoCnfTnf_CancelReasonController  (new ApexPages.StandardController(objPWO));
       controller.getRecord(objPWO.id);
       controller.CancelReason();
     //System.assertEquals('Signed', objPWO.pkl_Status__c);
     System.assertEquals('Signed', objPWO.pkl_Status__c);
        Test.stopTest();
    }
 static testmethod void PWORFcancelledController_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf5 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf5;

       objPworf5.pkl_Status__c ='Answered' ;
        update objPworf5;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf5);
        insert  objPWO;
        
        //CPA_LOI__c objLOI =CPA_testClass_util.createLOI (objPworf5);
        //insert  objLOI;

        Test.setCurrentPage(new PageReference('CPA_PWORF_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objPworf5.id);
        CPA_PWORF_CancelReasonController   controller = new CPA_PWORF_CancelReasonController  (new ApexPages.StandardController(objPworf5));
       controller.SaveCancelReason();
     System.assertEquals('Auto Accepted', objPworf5.pkl_Status__c);
        Test.stopTest();
    }
    static testmethod void PWORFcancelController_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf2 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf2;

        Test.setCurrentPage(new PageReference('CPA_PWORF_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objPworf2.id);
        CPA_PWORF_CancelReasonController   controller = new CPA_PWORF_CancelReasonController  (new ApexPages.StandardController(objPworf2));

       controller.CancelReason();
     System.assertEquals('Saved', objPworf2.pkl_Status__c);
        Test.stopTest();
    }
    static testmethod void PWORFcancelController1_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf2 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf2;
        
        objPworf2.pkl_Status__c ='Auto Accepted';
        update objPworf2;
        
        Test.setCurrentPage(new PageReference('CPA_PWORF_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objPworf2.id);
        CPA_PWORF_CancelReasonController   controller = new CPA_PWORF_CancelReasonController  (new ApexPages.StandardController(objPworf2));

       controller.SaveCancelReason();
      System.assertEquals('Auto Accepted', objPworf2.pkl_Status__c);
        Test.stopTest();
    }
    static testmethod void PWORFcancelController2_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf2 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf2;
        
        objPworf2.pkl_Status__c ='Auto Accepted';
        update objPworf2;
        
        CPA_LOI__c objLOI =CPA_testClass_util.createLOI (objPworf2);
        insert  objLOI;
        
        Test.setCurrentPage(new PageReference('CPA_PWORF_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objPworf2.id);
        CPA_PWORF_CancelReasonController   controller = new CPA_PWORF_CancelReasonController  (new ApexPages.StandardController(objPworf2));

       controller.SaveCancelReason();
      System.assertEquals('Auto Accepted', objPworf2.pkl_Status__c);
        Test.stopTest();
    }
 static testmethod void PWO_RFTer_Controller_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf6= CPA_testClass_util.createTest_other_PWORF();
        insert objPworf6;

       objPworf6.pkl_Status__c ='Answered' ;
        update objPworf6;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf6);
        insert  objPWO;
        
        objPWO.pkl_Status__c ='Signed';
        update objPWO;       

        Test.setCurrentPage(new PageReference('CPA_PWO_Request_For_Termination'));
        System.currentPageReference().getParameters().put('id', objPWO.id); 
        CPA_PWO_RFTer_Controller   controller = new CPA_PWO_RFTer_Controller  (new ApexPages.StandardController(objPWO));
       controller.getRecord(objPWO.id);
       controller.SaveCancelReason();
       controller.CancelReason();
        System.assertEquals('Signed', objPWO.pkl_Status__c);
        Test.stopTest();
    }
}