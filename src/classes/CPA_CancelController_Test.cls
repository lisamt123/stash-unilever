/**********************************************************************
Name: CPA_CancelController_Test()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This test class provides test coverage of cancel functionality
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Shreyas    29/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest 
public class CPA_CancelController_Test { 
    /*******************************************************************
    Purpose: This method is used to create LOI cancel test data and coverage
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void LOICancelController_Test() {
        
        
        CPA_PWORF__c objPworf = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf;
        
        objPworf.pkl_Status__c ='Accepted' ;
        update objPworf;
        
        CPA_LOI__c objLOI =CPA_testContractClass.createLOI (objPworf);
         objLOI .pkl_Status__c =CPA_ConstantsForContractingAppClasses.CANCELLED;
        insert  objLOI;
	 Test.startTest();
        Test.setCurrentPage(new PageReference('CPA_LOI_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objLOI.id);
        CPA_LOI_CancelReasonController   controller = new CPA_LOI_CancelReasonController  (new ApexPages.StandardController(objLOI));
        objLOI.txta_Reason_for_Cancellation__c = 'TEST';
        PageReference obj = controller.SaveCancelReason();
        CPA_LOI__c objLOIFinal = [Select Id,pkl_Status__c from CPA_LOI__c where Id =:objLOI.id ];               
        System.assert(CPA_ConstantsForContractingAppClasses.CANCELLED  == objLOIFinal.pkl_Status__c);
        
        CPA_LOI__c objLOI1 = new CPA_LOI__c ();
        insert objLOI1;
        objLOI1.pkl_Status__c ='Accepted' ;
        Test.setCurrentPage(new PageReference('CPA_LOI_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objLOI1.id);
        CPA_LOI_CancelReasonController   controller1 = new CPA_LOI_CancelReasonController  (new ApexPages.StandardController(objLOI1));
        controller1.SaveCancelReason();
        objLOI1.txta_Reason_for_Cancellation__c = 'TEST';
        PageReference obj1 = controller1.CancelReason();
	 Test.stopTest();
        CPA_LOI__c objLOIFinal1 = [Select Id,pkl_Status__c from CPA_LOI__c where Id =:objLOI1.id ];               
        System.assert(CPA_ConstantsForContractingAppClasses.CANCELLED  == objLOIFinal1.pkl_Status__c);
        
     
    
    }
    /*******************************************************************
    Purpose: This method is used to create CR cancel test data and coverage
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void CRCancelController_Test() {
        
        CPA_PWORF__c objPworf = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf;

       objPworf.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED;
        update objPworf;
        System.assert(CPA_ConstantsForContractingAppClasses.ANSWERED == objPworf.pkl_Status__c );
        
        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf);
        insert  objPWO;
        
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.DELIVERED;
        update objPWO;
        System.assert(CPA_ConstantsForContractingAppClasses.DELIVERED == objPWO.pkl_Status__c );
        
        CPA_CR__c objCR1 = CPA_testContractClass.createCR(objPWO);      
        objCR1.pkl_Status__c = CPA_ConstantsForContractingAppClasses.CANCELLED;
        insert objCR1;
        
	  Test.startTest();
        Test.setCurrentPage(new PageReference('CPA_CR_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objCR1.id);
        CPA_CR_CancelReasonController   controller = new CPA_CR_CancelReasonController  (new ApexPages.StandardController(objCR1));
        controller.SaveCancelReason();
        controller.CancelReason();
      Test.stopTest();
        CPA_CR__c objCRFinal = [Select Id,pkl_Status__c from CPA_CR__c where Id =:objCR1.id ];	  
        System.assert(CPA_ConstantsForContractingAppClasses.CANCELLED  == objCRFinal.pkl_Status__c);
    }
    /*******************************************************************
    Purpose: This method is used to create HLE cancel test data and coverage
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
     static testmethod void HLECancelController_Test() {
        
        CPA_HLE_Request__c objHLE = CPA_testContractClass.CreateHLERequest(); 
        objHLE.pkl_Status__c= CPA_ConstantsForContractingAppClasses.CANCELLED;
        insert objHLE;
      Test.startTest();  
        Test.setCurrentPage(new PageReference('CPA_HLE_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objHLE.id);
        CPA_HLE_CancelReasonController   controller = new CPA_HLE_CancelReasonController  (new ApexPages.StandardController(objHLE));
        controller.SaveCancelReason();
		controller.CancelReason();
	  Test.stopTest();
	  
       CPA_HLE_Request__c objHLERFinal = [Select Id,pkl_Status__c from CPA_HLE_Request__c where Id =:objHLE.id ];                        
       System.assert(CPA_ConstantsForContractingAppClasses.CANCELLED==objHLERFinal.pkl_Status__c);
      
    }
    /*******************************************************************
    Purpose: This method is used to create PWO cancel test data and coverage
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
     static testmethod void PWOcancelController_Test() {

        CPA_PWORF__c objPworf1 = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf1;
	  
        objPworf1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED;
        update objPworf1;
		CPA_PWORF__c objPWORFFinal = [Select Id,pkl_Status__c from CPA_PWORF__c where Id =:objPworf1.id ];               
        System.assert(CPA_ConstantsForContractingAppClasses.ANSWERED  == objPWORFFinal.pkl_Status__c);

        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf1);
        insert  objPWO;
        
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SIGNED;
        update objPWO; 
	  Test.startTest();
        Test.setCurrentPage(new PageReference('CPA_PwoCnfTnf_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put('recordType', 'PWO');  
        CPA_PwoCnfTnf_CancelReasonController   controller = new CPA_PwoCnfTnf_CancelReasonController  (new ApexPages.StandardController(objPWO));
        controller.getRecord(objPWO.id);
        controller.SaveCancelReason();
	  Test.stopTest();
	   CPA_project_work_order__c objPWOFinal = [Select Id,pkl_Status__c from CPA_project_work_order__c where Id =:objPWO.id ];               
       System.assert(CPA_ConstantsForContractingAppClasses.CANCELLED== objPWOFinal.pkl_Status__c);     
    }
    /*******************************************************************
    Purpose: This method is used to create CNF cancel test data and coverage
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void CNFcancelController_Test() {
      
        CPA_PWORF__c objPworf1 = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf1;

        objPworf1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED;
        update objPworf1;
		CPA_PWORF__c objPWORFFinal = [Select Id,pkl_Status__c from CPA_PWORF__c where Id =:objPworf1.id ];               
        System.assert(CPA_ConstantsForContractingAppClasses.ANSWERED== objPWORFFinal.pkl_Status__c);
        
        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf1);
        insert  objPWO;
        
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.DELIVERED;
        update objPWO;       
        CPA_project_work_order__c objPWOFinal = [Select Id,pkl_Status__c from CPA_project_work_order__c where Id =:objPWO.id ];               
        System.assert(CPA_ConstantsForContractingAppClasses.DELIVERED== objPWOFinal.pkl_Status__c);
      Test.startTest();  
        Test.setCurrentPage(new PageReference('CPA_PwoCnfTnf_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put('recordType', 'CNF');  
        CPA_PwoCnfTnf_CancelReasonController   controller = new CPA_PwoCnfTnf_CancelReasonController  (new ApexPages.StandardController(objPWO));
        controller.getRecord(objPWO.id);
        controller.SaveCancelReason();
	  Test.stopTest();
	    CPA_project_work_order__c objPWOFinal1 = [Select Id,pkl_Status__c from CPA_project_work_order__c where Id =:objPWO.id ];               
        System.assert(CPA_ConstantsForContractingAppClasses.DELIVERED== objPWOFinal1.pkl_Status__c);    
    }
    /*******************************************************************
    Purpose: This method is used to create TNF cancel test data and coverage
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void TNFcancelController_Test() {
        
        CPA_PWORF__c objPworf1 = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED;
        update objPworf1;
        
        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf1);
        insert  objPWO;
        
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SIGNED;
        update objPWO;       
	  Test.startTest(); 
        Test.setCurrentPage(new PageReference('CPA_PwoCnfTnf_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put('recordType', 'TNF');  
        CPA_PwoCnfTnf_CancelReasonController   controller = new CPA_PwoCnfTnf_CancelReasonController  (new ApexPages.StandardController(objPWO));
        controller.getRecord(objPWO.id);
        controller.SaveCancelReason();
	  Test.stopTest();
	    CPA_project_work_order__c objPWOFinal = [Select Id,pkl_Status__c from CPA_project_work_order__c where Id =:objPWO.id ];               
        System.assert(CPA_ConstantsForContractingAppClasses.SIGNED== objPWOFinal.pkl_Status__c);    
    }
    /*******************************************************************
    Purpose: This method is used to create PWO cancel test data and coverage
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void PWOcancelledController_Test() {  
        CPA_PWORF__c objPworf1 = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf1;

        objPworf1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED;
        update objPworf1;
        
        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf1);
        insert  objPWO;
        
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SIGNED;
        update objPWO; 
			
	 Test.startTest();
        Test.setCurrentPage(new PageReference('CPA_PwoCnfTnf_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put('recordType', 'PWO');  
        CPA_PwoCnfTnf_CancelReasonController   controller = new CPA_PwoCnfTnf_CancelReasonController  (new ApexPages.StandardController(objPWO));
        controller.getRecord(objPWO.id);
        controller.CancelReason();
	  Test.stopTest();
        CPA_project_work_order__c objPWOFinal = [Select Id,pkl_Status__c from CPA_project_work_order__c where Id =:objPWO.id ];               
        System.assert(CPA_ConstantsForContractingAppClasses.SIGNED== objPWOFinal.pkl_Status__c);
        
    }
    /*******************************************************************
    Purpose: This method is used to create PWORF cancel test data and coverage
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void PWORFcancelledController_Test() {

        CPA_PWORF__c objPworf5 = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf5;

       objPworf5.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED;
        update objPworf5;
        
        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf5);
        insert  objPWO;
	
	  Test.startTest();
        Test.setCurrentPage(new PageReference('CPA_PWORF_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objPworf5.id);
        CPA_PWORF_CancelReasonController   controller = new CPA_PWORF_CancelReasonController  (new ApexPages.StandardController(objPworf5));
        controller.SaveCancelReason();
	  Test.stopTest();
        CPA_PWORF__c objPWORFFinal = [Select Id,pkl_Status__c from CPA_PWORF__c where Id =:objPworf5.id ];               
        System.assert(CPA_ConstantsForContractingAppClasses.CANCELLED== objPWORFFinal.pkl_Status__c);
        
    }
    /*******************************************************************
    Purpose: This method is used to create PWORF cancel test data and coverage
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void PWORFcancelController_Test() {
 
        CPA_PWORF__c objPworf2 = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf2;
	  Test.startTest();
        Test.setCurrentPage(new PageReference('CPA_PWORF_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objPworf2.id);
        CPA_PWORF_CancelReasonController   controller = new CPA_PWORF_CancelReasonController  (new ApexPages.StandardController(objPworf2));
        controller.CancelReason();
	  Test.stopTest();
        CPA_PWORF__c objPWORFFinal = [Select Id,pkl_Status__c from CPA_PWORF__c where Id =:objPworf2.id ];               
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED== objPWORFFinal.pkl_Status__c);
        
    }
    /*******************************************************************
    Purpose: This method is used to create PWORF cancel test data and coverage
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void PWORFcancelController1_Test() {
 
        CPA_PWORF__c objPworf2 = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf2;
        
        objPworf2.pkl_Status__c ='Auto Accepted';
        update objPworf2;
     Test.startTest();
        Test.setCurrentPage(new PageReference('CPA_PWORF_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objPworf2.id);
        CPA_PWORF_CancelReasonController   controller = new CPA_PWORF_CancelReasonController  (new ApexPages.StandardController(objPworf2));

        controller.SaveCancelReason();
	  Test.stopTest();	
        CPA_PWORF__c objPWORFFinal = [Select Id,pkl_Status__c from CPA_PWORF__c where Id =:objPworf2.id ];               
        System.assert(CPA_ConstantsForContractingAppClasses.CANCELLED== objPWORFFinal.pkl_Status__c);
        
    }
    /*******************************************************************
    Purpose: This method is used to create PWORF cancel test data and coverage
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void PWORFcancelController2_Test() {
 
        CPA_PWORF__c objPworf2 = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf2;
        
        objPworf2.pkl_Status__c ='Auto Accepted';
        update objPworf2;
        
        CPA_LOI__c objLOI =CPA_testContractClass.createLOI (objPworf2);
        insert  objLOI;
      Test.startTest();
        Test.setCurrentPage(new PageReference('CPA_PWORF_Cancel_Reason'));
        System.currentPageReference().getParameters().put('id', objPworf2.id);
        CPA_PWORF_CancelReasonController   controller = new CPA_PWORF_CancelReasonController  (new ApexPages.StandardController(objPworf2));
	  Test.stopTest();
        controller.SaveCancelReason();
        CPA_PWORF__c objPWORFFinal = [Select Id,pkl_Status__c from CPA_PWORF__c where Id =:objPworf2.id ];               
        System.assert(CPA_ConstantsForContractingAppClasses.CANCELLED== objPWORFFinal.pkl_Status__c);
        
    }
    /*******************************************************************
    Purpose: This method is used to create PWO cancel test data and coverage
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void PWO_RFTer_Controller_Test() {

        CPA_PWORF__c objPworf6= CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf6;

       objPworf6.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED;
        update objPworf6;
        
        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf6);
        insert  objPWO;
        
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SIGNED;
        update objPWO;       
	  Test.startTest();
        Test.setCurrentPage(new PageReference('CPA_PWO_Request_For_Termination'));
        System.currentPageReference().getParameters().put('id', objPWO.id); 
        CPA_PWO_RFTer_Controller   controller = new CPA_PWO_RFTer_Controller  (new ApexPages.StandardController(objPWO));
        controller.getRecord(objPWO.id);
        controller.SaveCancelReason();
        controller.CancelReason();
	  Test.stopTest();
	    CPA_project_work_order__c objPWOFinal = [Select Id,pkl_Status__c from CPA_project_work_order__c where Id =:objPWO.id ];               
        System.assert(CPA_ConstantsForContractingAppClasses.REQUESTFORTERMINATION== objPWOFinal.pkl_Status__c);
        
    }
}