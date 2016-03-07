/**********************************************************************
Name: CPA_ReturnController_Test()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: Test class for LOI functionality
-------
======================================================
======================================================
History 
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       01/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest//(SeeAllData=true)
public class CPA_ReturnController_Test {
    
    /*******************************************************************
    Purpose: This method covers basic functionality of LOI
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void LOIreturnController_Test() {
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf;
        
        objPworf.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ACCEPTED ;
        update objPworf;
        
        CPA_LOI__c objLOI =CPA_testClass_util.createLOI (objPworf);
        objLOI.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SAVED;
        insert  objLOI;

        Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.LOIREASONFORRETURN));
        System.currentPageReference().getParameters().put('id', objLOI.id);
        CPA_LOI_ReturnReasonController   controller = new CPA_LOI_ReturnReasonController  (new ApexPages.StandardController(objLOI));
        
        controller.SaveCancelReason();
         CPA_LOI__c objLOIfINAL1 = [Select Id,pkl_Status__c from CPA_LOI__c where id= :objLOI.id ];
        system.assertEquals(CPA_ConstantsForContractingAppClasses.RETURNED,objLOIfINAL1.pkl_Status__c);

        //System.assert(CPA_ConstantsForContractingAppClasses.RETURNED == objLOI.pkl_Status__c);
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;
        
        objPworf1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ACCEPTED ;
        update objPworf1;
        
        CPA_LOI__c objLOI1 =CPA_testClass_util.createLOI (objPworf1);
        objLOI1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ACCEPTED;
        insert  objLOI1;

        Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.LOIREASONFORRETURN));
        System.currentPageReference().getParameters().put('id', objLOI1.id);
        CPA_LOI_ReturnReasonController   controller1 = new CPA_LOI_ReturnReasonController  (new ApexPages.StandardController(objLOI1));
        controller.CancelReason();
        
        CPA_LOI__c objLOIfINAL = [Select Id,pkl_Status__c from CPA_LOI__c where id= :objLOI1.id ];
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED   == objLOIfINAL.pkl_Status__c);
        
        Test.stopTest();
    }
    
    /*******************************************************************
    Purpose: This method covers LOI test
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void PWOreturnController_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED ;
        update objPworf1;
        System.assert(CPA_ConstantsForContractingAppClasses.ANSWERED == objPworf1.pkl_Status__c);
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf1);
        
        insert  objPWO;
        
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SIGNED;
        update objPWO;       
        System.assert(CPA_ConstantsForContractingAppClasses.SIGNED == objPWO.pkl_Status__c);
        Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.PWOCNFTNFRETURNREASON));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put(CPA_ConstantsForContractingAppClasses.RECORDTYPE, CPA_ConstantsForContractingAppClasses.PWO);  
        CPA_PwoCnfTnf_ReturnReasonController   controller = new CPA_PwoCnfTnf_ReturnReasonController  (new ApexPages.StandardController(objPWO));
       controller.getRecord(objPWO.id);
       controller.SaveCancelReason();
       CPA_project_work_order__c objPWOFinal = [Select Id,pkl_Status__c from CPA_project_work_order__c where id=:objPWO.id ];
       system.assertEquals(CPA_ConstantsForContractingAppClasses.RETURNED,objPWOFinal.pkl_Status__c);
       System.assert(CPA_ConstantsForContractingAppClasses.RETURNED == objPWOFinal.pkl_Status__c);
        Test.stopTest();
    }
    /*******************************************************************
    Purpose: This method covers CNF test
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  CNFreturnController_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED ;
        update objPworf1;
       
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf1);
        insert  objPWO;
        
        objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SentForClosure ;
        objPWO.CNF_Status__c = CPA_ConstantsForContractingAppClasses.SAVED ;
        update objPWO;       
        System.assert(CPA_ConstantsForContractingAppClasses.SentForClosure == objPWO.pkl_Status__c);
        Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.PWOCNFTNFRETURNREASON));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put(CPA_ConstantsForContractingAppClasses.RECORDTYPE, CPA_ConstantsForContractingAppClasses.CNF);  
        CPA_PwoCnfTnf_ReturnReasonController   controller = new CPA_PwoCnfTnf_ReturnReasonController  (new ApexPages.StandardController(objPWO));
       controller.getRecord(objPWO.id);
       controller.SaveCancelReason();
       CPA_project_work_order__c objPWOFinal = [Select Id,pkl_Status__c,CNF_Status__c from CPA_project_work_order__c where Id =:objPWO.id ];
        System.assert(CPA_ConstantsForContractingAppClasses.SentForClosure== objPWOFinal.pkl_Status__c);
        System.assert(CPA_ConstantsForContractingAppClasses.RETURNED == objPWOFinal.CNF_Status__c);
        Test.stopTest();
    }
    /*******************************************************************
    Purpose: This method covers TNF test
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  TNFreturnController_Test() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf1 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED ;
        update objPworf1;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf1);
        insert  objPWO;
        
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SentForTermination ;
        objPWO.TNF_Status__c = CPA_ConstantsForContractingAppClasses.SAVED ;
        update objPWO;       
        System.assert(CPA_ConstantsForContractingAppClasses.SentForTermination == objPWO.pkl_Status__c);
        Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.PWOCNFTNFRETURNREASON));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put(CPA_ConstantsForContractingAppClasses.RECORDTYPE, CPA_ConstantsForContractingAppClasses.TNF);  
        CPA_PwoCnfTnf_ReturnReasonController   controller = new CPA_PwoCnfTnf_ReturnReasonController  (new ApexPages.StandardController(objPWO));
        controller.getRecord(objPWO.id);
       
       CPA_project_work_order__c objPWOFinal = [Select Id,pkl_Status__c,TNF_Status__c from CPA_project_work_order__c where Id =:objPWO.id ];
         System.assert(CPA_ConstantsForContractingAppClasses.SentForTermination == objPWOFinal.pkl_Status__c);
         controller.SaveCancelReason();
        System.assert(CPA_ConstantsForContractingAppClasses.RETURNED == objPWOFinal.TNF_Status__c);
         
        Test.stopTest();
    }
    /*******************************************************************
    Purpose: This method covers CR test
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
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
       

        Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.CRREASONFORRETURN));
        System.currentPageReference().getParameters().put('id', objCR1.id);
        CPA_CR_ReturnReasonController   controller = new CPA_CR_ReturnReasonController  (new ApexPages.StandardController(objCR1));
       controller.SaveCancelReason();
      //controller.CancelReason();
      
      
       CPA_CR__c  objCRFinal = [Select Id,pkl_Status__c from CPA_CR__c where Id =:objCR1.id ];      
         
        System.assert(CPA_ConstantsForContractingAppClasses.RETURNED == objCRFinal.pkl_Status__c);
        Test.stopTest();
    
    }
    
      /*******************************************************************
    Purpose: This method covers CR test
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  CRreturnController_Cancel_Test() {
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
        objCR1.pkl_Status__c= CPA_ConstantsForContractingAppClasses.SAVED;
        insert objCR1;
       

        Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.CRREASONFORRETURN));
        System.currentPageReference().getParameters().put('id', objCR1.id);
        CPA_CR_ReturnReasonController   controller = new CPA_CR_ReturnReasonController  (new ApexPages.StandardController(objCR1));
       //controller.SaveCancelReason();
      controller.CancelReason();
      
      
       CPA_CR__c objCRFinal = [Select Id,pkl_Status__c from CPA_CR__c where Id =:objCR1.id ];      
         
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED == objCRFinal.pkl_Status__c);
        Test.stopTest();
    
    }
    
    
    
    /*******************************************************************
    Purpose: This method covers PWO withhold test
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  PWORFwithholdController_Test() {
        
     CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
     objPworf.pkl_Status__c = CPA_ConstantsForContractingAppClasses.CANCELLED;
        insert objPworf;
        System.assert(CPA_ConstantsForContractingAppClasses.CANCELLED == objPworf.pkl_Status__c);
        Test.startTest();

        Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.PWORFREASONFORWITHHOLD));
        System.currentPageReference().getParameters().put('id', objPworf.id);
        CPA_PWORF_WithholdReasonController  controller = new CPA_PWORF_WithholdReasonController (new ApexPages.StandardController(objPworf));
        controller.SaveCancelReason();
     // controller.CancelReason();
     // System.assert(CPA_ConstantsForContractingAppClasses.CANCELLED == objPworf.pkl_Status__c);
      
      CPA_PWORF__c objPWORFFinal = [Select Id,pkl_Status__c from CPA_PWORF__c where Id =:objPworf.id ];      
         
        System.assert(CPA_ConstantsForContractingAppClasses.WITHHOLD  == objPWORFFinal.pkl_Status__c);
        Test.stopTest();
    }
    /*******************************************************************
    Purpose: This method covers PWO withhold test
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  PWORFwithholdController_Cancel_Test() {
        
     CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
     objPworf.pkl_Status__c = CPA_ConstantsForContractingAppClasses.CANCELLED;
        insert objPworf;
        objPworf.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SAVED;
        Test.startTest();

        Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.PWORFREASONFORWITHHOLD));
        System.currentPageReference().getParameters().put('id', objPworf.id);
        CPA_PWORF_WithholdReasonController  controller = new CPA_PWORF_WithholdReasonController (new ApexPages.StandardController(objPworf));
        //controller.SaveCancelReason();
         controller.CancelReason();
         System.assert(CPA_ConstantsForContractingAppClasses.SAVED == objPworf.pkl_Status__c);
      
     /* CPA_project_work_order__c objPWORFFinal = [Select Id,pkl_Status__c from CPA_PWORF__c where Id =:objPworf.id ];      
         
        System.assert(CPA_ConstantsForContractingAppClasses.DELIVERED == objPWORFFinal.pkl_Status__c);*/
        Test.stopTest();
    }
}