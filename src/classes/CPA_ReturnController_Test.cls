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
       
        
        CPA_PWORF__c objPworf = CPA_testPWORFClass_util.createTest_other_PWORF();      
        insert objPworf;
        
        objPworf.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ACCEPTED ;
        update objPworf;
        
        CPA_LOI__c objLOI =CPA_testContractClass.createLOI (objPworf);
        objLOI.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SAVED;
        insert  objLOI;
    Test.startTest();
        Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.LOIREASONFORRETURN));
        System.currentPageReference().getParameters().put('id', objLOI.id);
        CPA_LOI_ReturnReasonController   controller = new CPA_LOI_ReturnReasonController  (new ApexPages.StandardController(objLOI));
        
        controller.SaveCancelReason();
        CPA_LOI__c objLOIfINAL1 = [Select Id,pkl_Status__c from CPA_LOI__c where id= :objLOI.id ];
    
        CPA_PWORF__c objPworf1 = CPA_testPWORFClass_util.createTest_other_PWORF();
        objPworf1.name = objPworf.name+'test123'+system.now();
        insert objPworf1;
        
        objPworf1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ACCEPTED ;
        update objPworf1;
        
        CPA_LOI__c objLOI1 =CPA_testContractClass.createLOI (objPworf1);
        objLOI1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ACCEPTED;
        insert  objLOI1;
    
        Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.LOIREASONFORRETURN));
        System.currentPageReference().getParameters().put('id', objLOI1.id);
        CPA_LOI_ReturnReasonController   controller1 = new CPA_LOI_ReturnReasonController  (new ApexPages.StandardController(objLOI1));
        controller.CancelReason();
        
        CPA_LOI__c objLOIfINAL = [Select Id,pkl_Status__c from CPA_LOI__c where id= :objLOI1.id ];
    Test.stopTest();
        system.assert(objLOIfINAL1.pkl_Status__c ==CPA_ConstantsForContractingAppClasses.RETURNED);
        System.assert(objLOIfINAL.pkl_Status__c == CPA_ConstantsForContractingAppClasses.SAVED);
        
        
    }
    
    /*******************************************************************
    Purpose: This method covers LOI test
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void PWOreturnController_Test() {
        
        
        
        CPA_PWORF__c objPworf1 = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED ;
        update objPworf1;
       
        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf1);
        
        insert  objPWO;
        
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SIGNED;
        update objPWO;       
    Test.startTest();   
        Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.PWOCNFTNFRETURNREASON));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put(CPA_ConstantsForContractingAppClasses.RECORDTYPE, CPA_ConstantsForContractingAppClasses.PWO);  
        CPA_PwoCnfTnf_ReturnReasonController   controller = new CPA_PwoCnfTnf_ReturnReasonController  (new ApexPages.StandardController(objPWO));
       controller.getRecord(objPWO.id);
       controller.SaveCancelReason();
       CPA_project_work_order__c objPWOFinal = [Select Id,pkl_Status__c from CPA_project_work_order__c where id=:objPWO.id ];
    Test.stopTest();
       system.assertEquals(CPA_ConstantsForContractingAppClasses.RETURNED,objPWOFinal.pkl_Status__c);
       System.assert(CPA_ConstantsForContractingAppClasses.RETURNED == objPWOFinal.pkl_Status__c);
        
    }
    /*******************************************************************
    Purpose: This method covers CNF test
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  CNFreturnController_Test() {
        
       
        
        CPA_PWORF__c objPworf1 = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED ;
        update objPworf1;
       
        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf1);
        insert  objPWO;
        
        objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SentForClosure ;
        objPWO.CNF_Status__c = CPA_ConstantsForContractingAppClasses.SAVED ;
        update objPWO;       
    Test.startTest(); 
        Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.PWOCNFTNFRETURNREASON));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put(CPA_ConstantsForContractingAppClasses.RECORDTYPE, CPA_ConstantsForContractingAppClasses.CNF);  
        CPA_PwoCnfTnf_ReturnReasonController   controller = new CPA_PwoCnfTnf_ReturnReasonController  (new ApexPages.StandardController(objPWO));
       controller.getRecord(objPWO.id);
       controller.SaveCancelReason();
       CPA_project_work_order__c objPWOFinal = [Select Id,pkl_Status__c,CNF_Status__c from CPA_project_work_order__c where Id =:objPWO.id ];
    Test.stopTest();
        System.assert(CPA_ConstantsForContractingAppClasses.SentForClosure== objPWOFinal.pkl_Status__c);
        System.assert(CPA_ConstantsForContractingAppClasses.RETURNED == objPWOFinal.CNF_Status__c);
        
    }
    /*******************************************************************
    Purpose: This method covers TNF test
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  TNFreturnController_Test() {
        
    
        
        CPA_PWORF__c objPworf1 = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf1;

       objPworf1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED ;
        update objPworf1;
        
        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf1);
        insert  objPWO;
        
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SentForTermination ;
        objPWO.TNF_Status__c = CPA_ConstantsForContractingAppClasses.SAVED ;
        update objPWO;       
   Test.startTest(); 
        Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.PWOCNFTNFRETURNREASON));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        System.currentPageReference().getParameters().put(CPA_ConstantsForContractingAppClasses.RECORDTYPE, CPA_ConstantsForContractingAppClasses.TNF);  
        CPA_PwoCnfTnf_ReturnReasonController   controller = new CPA_PwoCnfTnf_ReturnReasonController  (new ApexPages.StandardController(objPWO));
        controller.getRecord(objPWO.id);
       
       CPA_project_work_order__c objPWOFinal = [Select Id,pkl_Status__c,TNF_Status__c from CPA_project_work_order__c where Id =:objPWO.id ];
         
         controller.SaveCancelReason();
    Test.stopTest();
        System.assert(CPA_ConstantsForContractingAppClasses.SentForTermination == objPWOFinal.pkl_Status__c);
         
        
    }
    /*******************************************************************
    Purpose: This method covers CR test
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  CRreturnController_Test() {
     
        
        CPA_PWORF__c objPworf = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf;

       objPworf.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED ;
        update objPworf;
        
        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf);
        insert  objPWO;
        
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.DELIVERED ;
        update objPWO;
      
        
        CPA_CR__c objCR1 = CPA_testContractClass.createCR(objPWO);      
        objCR1.pkl_Status__c= CPA_ConstantsForContractingAppClasses.DELIVERED;
        insert objCR1;
    Test.startTest();  

        Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.CRREASONFORRETURN));
        System.currentPageReference().getParameters().put('id', objCR1.id);
        CPA_CR_ReturnReasonController   controller = new CPA_CR_ReturnReasonController  (new ApexPages.StandardController(objCR1));
       controller.SaveCancelReason();
       CPA_CR__c  objCRFinal = [Select Id,pkl_Status__c from CPA_CR__c where Id =:objCR1.id ];      
    Test.stopTest();    
        System.assert(CPA_ConstantsForContractingAppClasses.RETURNED == objCRFinal.pkl_Status__c);
     
    
    }
    
      /*******************************************************************
    Purpose: This method covers CR test
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  CRreturnController_Cancel_Test() {
        
        
        CPA_PWORF__c objPworf = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf;

       objPworf.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ANSWERED ;
        update objPworf;
        System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED== objPworf.pkl_Status__c);
        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf);
        insert  objPWO;
        
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.DELIVERED ;
        update objPWO;
        System.assert (CPA_ConstantsForContractingAppClasses.DELIVERED == objPWO.pkl_Status__c);
        
        CPA_CR__c objCR1 = CPA_testContractClass.createCR(objPWO);      
        objCR1.pkl_Status__c= CPA_ConstantsForContractingAppClasses.SAVED;
        insert objCR1;
     Test.startTest(); 
        Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.CRREASONFORRETURN));
        System.currentPageReference().getParameters().put('id', objCR1.id);
        CPA_CR_ReturnReasonController   controller = new CPA_CR_ReturnReasonController  (new ApexPages.StandardController(objCR1));
        controller.CancelReason();
        CPA_CR__c objCRFinal = [Select Id,pkl_Status__c from CPA_CR__c where Id =:objCR1.id ];      
     Test.stopTest();     
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED == objCRFinal.pkl_Status__c);
       
    
    }
    
    
    
    /*******************************************************************
    Purpose: This method covers PWO withhold test
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  PWORFwithholdController_Test() {
        
     CPA_PWORF__c objPworf = CPA_testPWORFClass_util.createTest_other_PWORF();
     objPworf.pkl_Status__c = CPA_ConstantsForContractingAppClasses.CANCELLED;
        insert objPworf;
       
    
    Test.startTest();
        Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.PWORFREASONFORWITHHOLD));
        System.currentPageReference().getParameters().put('id', objPworf.id);
        CPA_PWORF_WithholdReasonController  controller = new CPA_PWORF_WithholdReasonController (new ApexPages.StandardController(objPworf));
        controller.SaveCancelReason();         
        CPA_PWORF__c objPWORFFinal = [Select Id,pkl_Status__c from CPA_PWORF__c where Id =:objPworf.id ];      
    Test.stopTest(); 
        System.assert(CPA_ConstantsForContractingAppClasses.WITHHOLD  == objPWORFFinal.pkl_Status__c);
        
    }
    /*******************************************************************
    Purpose: This method covers PWO withhold test
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  PWORFwithholdController_Cancel_Test() {
        
     CPA_PWORF__c objPworf = CPA_testPWORFClass_util.createTest_other_PWORF();
     objPworf.pkl_Status__c = CPA_ConstantsForContractingAppClasses.CANCELLED;
        insert objPworf;
        objPworf.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SAVED;
        
        Test.startTest();
            Test.setCurrentPage(new PageReference(CPA_ConstantsForContractingAppClasses.PWORFREASONFORWITHHOLD));
            System.currentPageReference().getParameters().put('id', objPworf.id);
            CPA_PWORF_WithholdReasonController  controller = new CPA_PWORF_WithholdReasonController (new ApexPages.StandardController(objPworf));
           
             controller.CancelReason();
        Test.stopTest();
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED == objPworf.pkl_Status__c);
    }
}