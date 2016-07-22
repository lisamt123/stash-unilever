/**********************************************************************
Name: CPA_InformationController_Test ()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This is the test class for PWORF
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       12/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest
public  class CPA_InformationController_Test {

    /*******************************************************************
    Purpose: This method covers PWORF mandatory fields methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void PWORFInformationController_Test() {
        CPA_Status_Msg__c saveStatus = CPA_testStatusMsgCustomSettingClass.createTest_CPA_Status_Msg();
        insert saveStatus;
         CPA_Status_Msg__c READYTOSUBMIT= CPA_testStatusMsgCustomSettingClass.createTest_READYTOSUBMIT();
        insert READYTOSUBMIT;
        CPA_PWORF__c objPworf = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf;

        Test.startTest();

        Test.setCurrentPage(new PageReference('CPA_PWORF_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objPworf.id);
        CPA_PWORFInformationController  controller = new CPA_PWORFInformationController (new ApexPages.StandardController(objPworf));
        
        CPA_PWORF__c objPworf1 = new CPA_PWORF__c();
        objPworf1.pkl_Status__c =  CPA_ConstantsForContractingAppClasses.SAVED;
        objPworf1.Business_Case__c = null;
        insert objPworf1;
        
       Test.setCurrentPage(new PageReference('CPA_PWORF_Information_Display_Page'));
       System.currentPageReference().getParameters().put('id', objPworf1.id);
       CPA_PWORFInformationController  controller1 = new CPA_PWORFInformationController (new ApexPages.StandardController(objPworf1));
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPworf1.pkl_Status__c);
        System.assert (controller1.objectMap.get(CPA_ConstantsForContractingAppClasses.BUSINESSCASE) != null);
        System.assert (controller1.objectMap.get(CPA_ConstantsForContractingAppClasses.BUSINESSCASE) == CPA_ConstantsForContractingAppClasses.MANDATORY);
        
        
        CPA_PWORF__c objPworf2 = CPA_testPWORFClass_util.createTest_RA_PWORF();
        objPworf2.name = 'Test--->'+system.now()+ ' 2';
        objPworf2.txt_Resource_Location__c  = null;
        insert objPworf2;
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPworf2.pkl_Status__c);

        Test.setCurrentPage(new PageReference('CPA_PWORF_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objPworf2.id);
        CPA_PWORFInformationController  controller2 = new CPA_PWORFInformationController (new ApexPages.StandardController(objPworf2));
        
        CPA_PWORFInformationController act = new CPA_PWORFInformationController();     
        boolean flage = CPA_PWORFInformationController.checkIsValidated(objPworf2.Id );
        
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPworf2.pkl_Status__c);    
        System.assert (controller2.objectMap.get(CPA_ConstantsForContractingAppClasses.RESOURCELOCATION ) == null);
        System.assert (controller2.objectMap.get(CPA_ConstantsForContractingAppClasses.RESOURCELOCATION ) != CPA_ConstantsForContractingAppClasses.MANDATORY);
      
        
        Test.stopTest();
    }
    
    /*******************************************************************
    Purpose: This method covers PWORF mandatory fields methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  PWOInformationController_Test() {
        CPA_Status_Msg__c saveStatus = CPA_testStatusMsgCustomSettingClass.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c READYTOSUBMIT= CPA_testStatusMsgCustomSettingClass.createTest_READYTOSUBMIT();
        insert READYTOSUBMIT;
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testPWORFClass_util.createTest_other_PWORF();
        objPworf.pkl_Status__c=CPA_ConstantsForContractingAppClasses.ACCEPTED ;
        
        insert objPworf;
        
        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf);
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SAVED;
        objPWO.txt_PWO_title__c  = null;
        insert  objPWO;
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPWO.pkl_Status__c);

        Test.setCurrentPage(new PageReference('CPA_PWO_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        CPA_ContractInformationController   controller = new CPA_ContractInformationController  (new ApexPages.StandardController(objPWO));
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED ==objPWO.pkl_Status__c);
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED ==objPWO.pkl_Status__c);
        System.assert (controller.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.PWOTITLE ) != null);
        System.assert (controller.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.PWOTITLE ) == CPA_ConstantsForContractingAppClasses.MANDATORY);
       
        CPA_project_work_order__c objPwo1 = new CPA_project_work_order__c();
        objPwo1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SAVED;
        objPwo1.txt_PWO_title__c  = null;
        insert objPwo1;
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPwo1.pkl_Status__c);
        Test.setCurrentPage(new PageReference('CPA_PWO_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objPwo1.id);
        CPA_ContractInformationController   controller1 = new CPA_ContractInformationController  (new ApexPages.StandardController(objPwo1));
       
        CPA_ContractInformationController act = new CPA_ContractInformationController ();     
        boolean flage = CPA_ContractInformationController.checkIsValidated(objPwo1.Id );
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPwo1.pkl_Status__c);
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPwo1.pkl_Status__c);
        System.assert (controller1.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.PWOTITLE ) != null);
        System.assert (controller1.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.PWOTITLE ) == CPA_ConstantsForContractingAppClasses.MANDATORY);
        Test.stopTest();
    }
    
    /*******************************************************************
    Purpose: This method covers LOI mandatory fields methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  LOIInformationController_Test() {
        CPA_Status_Msg__c saveStatus = CPA_testStatusMsgCustomSettingClass.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c READYTOSUBMIT= CPA_testStatusMsgCustomSettingClass.createTest_READYTOSUBMIT();
        insert READYTOSUBMIT;
        
        /*CPA_LOIMandatoryMessages__c objMSG = CPA_testCustomSettingClass_util.createTest_LOI_message();
        insert objMSG;*/
        
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf;
        
        
        
        objPworf.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ACCEPTED ;
        update objPworf;
        System.assert (CPA_ConstantsForContractingAppClasses.ACCEPTED ==objPworf.pkl_Status__c);
        CPA_LOI__c objLOI =CPA_testContractClass.createLOI (objPworf);
        objLOI.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SAVED;
        objLOI.num_Expense_charges_of_LOI__c = null;
        objLOI.dt_LOI_Start_Date__c= null;
        insert  objLOI;
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objLOI.pkl_Status__c);
       
        Test.setCurrentPage(new PageReference('CPA_LOI_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objLOI.id);
        CPA_LOI_InformationController   controller = new CPA_LOI_InformationController  (new ApexPages.StandardController(objLOI));
       
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED == objLOI.pkl_Status__c);
       System.assert(CPA_ConstantsForContractingAppClasses.SAVED == objLOI.pkl_Status__c);
        System.assert (controller.mandatoryStringFlag != null);        
        System.assert (controller.mandatoryStringFlag == System.Label.CPA_Mandatory_Fields_Message); 
        
        CPA_LOI__c objLOI1 = new CPA_LOI__c ();
        objLOI1.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SAVED;
        objLOI1.num_Expense_charges_of_LOI__c = null;
        objLOI1.dt_LOI_Start_Date__c= null;
        insert objLOI1;
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objLOI1.pkl_Status__c);
        Test.setCurrentPage(new PageReference('CPA_LOI_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objLOI1.id);
        CPA_LOI_InformationController   controller1 = new CPA_LOI_InformationController  (new ApexPages.StandardController(objLOI1));

        CPA_LOI_InformationController act = new CPA_LOI_InformationController();     
        boolean flage = CPA_LOI_InformationController.checkIsValidated(objLOI1.Id );
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objLOI1.pkl_Status__c);
         System.assert (controller1.mandatoryStringFlag != null);        
        System.assert (controller1.mandatoryStringFlag == System.Label.CPA_Mandatory_Fields_Message);
       
        Test.stopTest();
    
    }

    /*******************************************************************
    Purpose: This method covers CR mandatory fields methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  CRInformationController_Test() {
        CPA_Status_Msg__c saveStatus = CPA_testStatusMsgCustomSettingClass.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c READYTOSUBMIT= CPA_testStatusMsgCustomSettingClass.createTest_READYTOSUBMIT();
        insert READYTOSUBMIT;
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf;       
        
        objPworf.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ACCEPTED ;
        update objPworf;
        System.assert (CPA_ConstantsForContractingAppClasses.ACCEPTED == objPworf.pkl_Status__c);
        
        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf);
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SAVED; 
        insert  objPWO;
       
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objPWO.pkl_Status__c);
         
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.Accepted;
        update objPWO;
        System.assert(CPA_ConstantsForContractingAppClasses.Accepted == objPWO.pkl_Status__c);
        List<CPA_CR__c> lst  =new List<CPA_CR__c>();
        
        CPA_CR__c objCR1 = new CPA_CR__c ();
        objCR1.pkl_Status__c=CPA_ConstantsForContractingAppClasses.SAVED;
        objCR1.eml_Unilever_Content_Approver_Email__c   = null;
        insert objCR1;
     
        System.assert ( CPA_ConstantsForContractingAppClasses.SAVED == objCR1.pkl_Status__c);
        

        Test.setCurrentPage(new PageReference('CPA_CR_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objCR1.id);
        CPA_CRInformationController   controller = new CPA_CRInformationController  (new ApexPages.StandardController(objCR1));
        System.assert ( CPA_ConstantsForContractingAppClasses.SAVED == objCR1.pkl_Status__c);
        
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objCR1.pkl_Status__c);
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objCR1.pkl_Status__c);
        System.assert (controller.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.ULCAEMAIL ) != null);
        System.assert (controller.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.ULCAEMAIL ) == CPA_ConstantsForContractingAppClasses.MANDATORY);
        
        
        
        
        CPA_CRInformationController act = new CPA_CRInformationController();     
        boolean flage = CPA_CRInformationController.checkIsValidated(objCR1.Id );
        
        System.assert (CPA_ConstantsForContractingAppClasses.SAVED == objCR1.pkl_Status__c);
        System.assert (controller.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.ULCAEMAIL ) != null);
        System.assert (controller.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.ULCAEMAIL ) == CPA_ConstantsForContractingAppClasses.MANDATORY);
        Test.stopTest();
    
    }
    
    /*******************************************************************
    Purpose: This method covers CNF mandatory fields methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  CNFInformationController_Test() {
        CPA_Status_Msg__c saveStatus = CPA_testStatusMsgCustomSettingClass.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c READYTOSUBMIT= CPA_testStatusMsgCustomSettingClass.createTest_READYTOSUBMIT();
        insert READYTOSUBMIT;
        ID CNFRecordtype = Schema.SObjectType.CPA_project_work_order__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_CNF_RecordTypeId ).getRecordTypeId();
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf;
        
        objPworf.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ACCEPTED ;
        update objPworf;
        System.assert (CPA_ConstantsForContractingAppClasses.ACCEPTED == objPworf.pkl_Status__c);
         
        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf);
        objPWO.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SAVED;
        insert  objPWO;
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED == objPWO.pkl_Status__c);
        Test.setCurrentPage(new PageReference('CPA_PWO_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        CPA_ContractInformationController   controller = new CPA_ContractInformationController  (new ApexPages.StandardController(objPWO));   
            
        objPWO.CNF_Status__c=CPA_ConstantsForContractingAppClasses.SAVED;
        
        objPWO.RecordTypeid =CNFRecordtype;
        //objPWO.RecordTypeid = label.CPA_PWO_CNF_RecordTypeId;
        objPWO.eml_CNF_Unilever_Content_Approver_Email__c  = null;
        update  objPWO;
        
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED == objPWO.pkl_Status__c);
        Test.setCurrentPage(new PageReference('CPA_CNF_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        CPA_ContractInformationController  controller1 = new CPA_ContractInformationController  (new ApexPages.StandardController(objPWO));
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED == objPWO.pkl_Status__c);
        
        System.assert (controller1.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.CNFULCAEMAIL ) != null);
        System.assert (controller1.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.CNFULCAEMAIL ) == CPA_ConstantsForContractingAppClasses.MANDATORY);
       
        Test.stopTest();
    }
    
    /*******************************************************************
    Purpose: This method covers TNF mandatory fields methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  TNFInformationController_Test() {
        CPA_Status_Msg__c saveStatus = CPA_testStatusMsgCustomSettingClass.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c READYTOSUBMIT= CPA_testStatusMsgCustomSettingClass.createTest_READYTOSUBMIT();
        insert READYTOSUBMIT;
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf;
        
        objPworf.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ACCEPTED ;
        update objPworf;
        System.assert (CPA_ConstantsForContractingAppClasses.ACCEPTED == objPworf.pkl_Status__c);
        
        CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf);
        objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SAVED;
        insert  objPWO;
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED == objPWO.pkl_Status__c);
        
        Test.setCurrentPage(new PageReference('CPA_PWO_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        CPA_ContractInformationController   controller = new CPA_ContractInformationController  (new ApexPages.StandardController(objPWO));   
            
        objPWO.TNF_Status__c=CPA_ConstantsForContractingAppClasses.SAVED ;
        ID TNFRecordtype = Schema.SObjectType.CPA_project_work_order__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_TNF_RecordTypeId  ).getRecordTypeId();
        //objPWO.RecordTypeid = label.CPA_PWO_TNF_RecordTypeId;
        objPWO.RecordTypeid =TNFRecordtype;
        objPWO.eml_TNF_Unilever_Contact_Email__c   = null;
        update  objPWO;
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED == objPWO.TNF_Status__c);
        Test.setCurrentPage(new PageReference('CPA_TNF_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        CPA_ContractInformationController  controller1 = new CPA_ContractInformationController  (new ApexPages.StandardController(objPWO));
       
        
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED == objPWO.pkl_Status__c);
        
        System.assert (controller1.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.TNFULCONTACTEMAIL ) != null);
        System.assert (controller1.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.TNFULCONTACTEMAIL ) == CPA_ConstantsForContractingAppClasses.MANDATORY);
       
        Test.stopTest();
    }
        
    /*******************************************************************
    Purpose: This method covers HLE Request mandatory fields methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  HLERequestInformationController_Test(){
        CPA_Status_Msg__c saveStatus = CPA_testStatusMsgCustomSettingClass.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c READYTOSUBMIT= CPA_testStatusMsgCustomSettingClass.createTest_READYTOSUBMIT();
        insert READYTOSUBMIT;
        Test.startTest();
        CPA_HLE_Request__c objHLE = new CPA_HLE_Request__c();
        objHLE.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SAVED;
        objHLE.txt_Assumptions__c  = null;
        insert objHLE; 
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED==objHLE.pkl_Status__c);
        Test.setCurrentPage(new PageReference('CPA_HLE_Request_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objHLE.id);
        CPA_HLERequInformationController  controller1 = new CPA_HLERequInformationController  (new ApexPages.StandardController(objHLE));
        System.assert(CPA_ConstantsForContractingAppClasses.SAVED==objHLE.pkl_Status__c);
                
        System.assert (controller1.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.ASSUMPTIONS ) != null);
        System.assert (controller1.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.ASSUMPTIONS ) == CPA_ConstantsForContractingAppClasses.MANDATORY);
        Test.stopTest();
    }
    
    /*******************************************************************
    Purpose: This method covers BPE mandatory fields methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  BPEInformationController_Test(){
        CPA_Status_Msg__c saveStatus = CPA_testStatusMsgCustomSettingClass.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c READYTOSUBMIT= CPA_testStatusMsgCustomSettingClass.createTest_READYTOSUBMIT();
        insert READYTOSUBMIT;
        CPA_Status_Msg__c acceptedStatus = CPA_testStatusMsgCustomSettingClass.createTest_CPA_Status_Msg1();
        ID BPERecordType = Schema.SObjectType.CPA_HLE_Request__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_BPE_Recordtype).getRecordTypeId();

        insert acceptedStatus;
        Test.startTest(); 
        CPA_HLE_Request__c objHLE1 = CPA_testContractClass.CreateHLERequest();
        objHLE1.txt_Assumptions__c  = null;     
        objHLE1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SAVED  ;   
        insert objHLE1; 
        objHLE1.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ACCEPTED  ;  
        objHLE1.txt_BPE_Title__c =null;     
        update objHLE1;
        System.assert(CPA_ConstantsForContractingAppClasses.ACCEPTED== objHLE1.pkl_Status__c);
      
        //objHLE1.recordtypeid = label.CPA_BPE_Recordtype;
        objHLE1.recordtypeid = BPERecordType ;
        update objHLE1;
        System.currentPageReference().getParameters().put('id', objHLE1.id);
        CPA_HLERequInformationController  controller2 = new CPA_HLERequInformationController  (new ApexPages.StandardController(objHLE1));
       
        
        System.assert (controller2.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.BPETITLE ) != null);
        System.assert (controller2.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.BPETITLE ) == CPA_ConstantsForContractingAppClasses.MANDATORY);
        Test.stopTest();
    }
    /*******************************************************************
    Purpose: This method covers HLE mandatory fields methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void  HLEInformationController_Test(){
        CPA_Status_Msg__c saveStatus = CPA_testStatusMsgCustomSettingClass.createTest_CPA_Status_Msg();
        insert saveStatus;
        CPA_Status_Msg__c READYTOSUBMIT= CPA_testStatusMsgCustomSettingClass.createTest_READYTOSUBMIT();
        insert READYTOSUBMIT;
        Id HLERecordType = Schema.SObjectType.CPA_HLE_Request__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_HLE_Recordtype).getRecordTypeId();
        CPA_Status_Msg__c acceptedStatus = CPA_testStatusMsgCustomSettingClass.createTest_CPA_Status_Msg1();
        insert acceptedStatus;
      Test.startTest(); 
        CPA_HLE_Request__c objHLE2 = CPA_testContractClass.CreateHLERequest();        
         objHLE2.pkl_Status__c=CPA_ConstantsForContractingAppClasses.SAVED;
         objHLE2.txt_Assumptions__c  = null;    
        insert objHLE2; 
        objHLE2.pkl_Status__c =CPA_ConstantsForContractingAppClasses.ACCEPTED  ;   
        update objHLE2;
        System.assert(CPA_ConstantsForContractingAppClasses.ACCEPTED== objHLE2.pkl_Status__c);
       
        objHLE2.recordtypeid = HLERecordType;
        objHLE2.txt_HLE_PB_Name__c =null;
        update objHLE2;
        
        System.currentPageReference().getParameters().put('id', objHLE2.id);
        CPA_HLERequInformationController  controller3 = new CPA_HLERequInformationController  (new ApexPages.StandardController(objHLE2));
        Test.stopTest(); 
         System.assert (controller3.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.HLENAME ) != null);
        System.assert (controller3.RequiredFieldMap.get(CPA_ConstantsForContractingAppClasses.HLENAME ) == CPA_ConstantsForContractingAppClasses.MANDATORY);
        
    }
}