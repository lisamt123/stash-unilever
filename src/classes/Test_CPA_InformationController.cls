@isTest(SeeAllData=true)
public  class Test_CPA_InformationController {

    static testmethod void Test_PWORFInformationController() {
        
     CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf;

        Test.startTest();

        Test.setCurrentPage(new PageReference('CPA_PWORF_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objPworf.id);
        CPA_PWORFInformationController  controller = new CPA_PWORFInformationController (new ApexPages.StandardController(objPworf));
        
        CPA_PWORF__c objPworf1 = new CPA_PWORF__c();
       
        insert objPworf1;
        
       Test.setCurrentPage(new PageReference('CPA_PWORF_Information_Display_Page'));
       System.currentPageReference().getParameters().put('id', objPworf1.id);
       CPA_PWORFInformationController  controller1 = new CPA_PWORFInformationController (new ApexPages.StandardController(objPworf1));
      
        
        
        CPA_PWORF__c objPworf2 = CPA_testClass_util.createTest_RA_PWORF();
        objPworf2.name = 'Test--->'+system.now()+ ' 2';
        insert objPworf2;


        Test.setCurrentPage(new PageReference('CPA_PWORF_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objPworf2.id);
        CPA_PWORFInformationController  controller2 = new CPA_PWORFInformationController (new ApexPages.StandardController(objPworf2));
        
         CPA_PWORFInformationController act = new CPA_PWORFInformationController();     
      boolean flage = CPA_PWORFInformationController.checkIsValidated(objPworf2.Id );
        
        Test.stopTest();
    }
    
    static testmethod void Test_PWOInformationController() {
        
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf);
        insert  objPWO;

        Test.setCurrentPage(new PageReference('CPA_PWO_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        CPA_ContractInformationController   controller = new CPA_ContractInformationController  (new ApexPages.StandardController(objPWO));
       

       
        CPA_project_work_order__c objPwo1 = new CPA_project_work_order__c();
        insert objPwo1;
        
       Test.setCurrentPage(new PageReference('CPA_PWO_Information_Display_Page'));
       System.currentPageReference().getParameters().put('id', objPwo1.id);
       CPA_ContractInformationController   controller1 = new CPA_ContractInformationController  (new ApexPages.StandardController(objPwo1));
       
       CPA_ContractInformationController act = new CPA_ContractInformationController ();     
      boolean flage = CPA_ContractInformationController.checkIsValidated(objPwo1.Id );
      
       
        Test.stopTest();
    }
    
    static testmethod void Test_LOIInformationController() {
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf;
        /*objPworf.pkl_Status__c ='Submitted' ;
        update objPworf;
        */
        objPworf.pkl_Status__c ='Accepted' ;
        update objPworf;
        
        CPA_LOI__c objLOI =CPA_testClass_util.createLOI (objPworf);
        insert  objLOI;

        Test.setCurrentPage(new PageReference('CPA_LOI_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objLOI.id);
        CPA_LOI_InformationController   controller = new CPA_LOI_InformationController  (new ApexPages.StandardController(objLOI));
       

       
        CPA_LOI__c objLOI1 = new CPA_LOI__c ();
        insert objLOI1;
        
        Test.setCurrentPage(new PageReference('CPA_LOI_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objLOI1.id);
        CPA_LOI_InformationController   controller1 = new CPA_LOI_InformationController  (new ApexPages.StandardController(objLOI1));
       // controller1.UpdateLOI();  
       
       
      CPA_LOI_InformationController act = new CPA_LOI_InformationController();     
      boolean flage = CPA_LOI_InformationController.checkIsValidated(objLOI1.Id );
      
     Test.stopTest();
    
    }

   static testmethod void Test_CRInformationController() {
        Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf;       
       objPworf.pkl_Status__c ='Accepted' ;
        update objPworf;
               
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf);
       objPWO.pkl_Status__c ='Accepted'; 
       insert  objPWO;
        
        objPWO.pkl_Status__c ='Accepted';
        update objPWO;
       List<CPA_CR__c> lst  =new List<CPA_CR__c>();
        
       // CPA_CR__c objCR1 = CPA_testClass_util.createCR(objPWO);
        CPA_CR__c objCR1 = new CPA_CR__c ();
        
        insert objCR1;
     
        

        Test.setCurrentPage(new PageReference('CPA_CR_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objCR1.id);
        CPA_CRInformationController   controller = new CPA_CRInformationController  (new ApexPages.StandardController(objCR1));
        
        //insert objCR2;
        
       /* Test.setCurrentPage(new PageReference('CPA_CR_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', lst[1].id);
        CPA_CRInformationController   controller1 = new CPA_CRInformationController  (new ApexPages.StandardController(objCR2));
       */
       CPA_CRInformationController act = new CPA_CRInformationController();     
      boolean flage = CPA_CRInformationController.checkIsValidated(objCR1.Id );
       
        Test.stopTest();
    
    }
    
    static testmethod void Test_CNFInformationController() {

        
          Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf);
        insert  objPWO;

        Test.setCurrentPage(new PageReference('CPA_PWO_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        CPA_ContractInformationController   controller = new CPA_ContractInformationController  (new ApexPages.StandardController(objPWO));   
            
        objPWO.CNF_Status__c='Saved';
        objPWO.RecordTypeid = label.Lbl_PWO_CNF_RecordTypeId;
        update  objPWO;
        
        Test.setCurrentPage(new PageReference('CPA_CNF_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        CPA_ContractInformationController  controller1 = new CPA_ContractInformationController  (new ApexPages.StandardController(objPWO));
       

       
        Test.stopTest();
    
    }
    
 static testmethod void Test_TNFInformationController() {
         Test.startTest();
        
        CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf;
        
        CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf);
        insert  objPWO;

        Test.setCurrentPage(new PageReference('CPA_PWO_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        CPA_ContractInformationController   controller = new CPA_ContractInformationController  (new ApexPages.StandardController(objPWO));   
            
        objPWO.TNF_Status__c='Saved';
        objPWO.RecordTypeid = label.Lbl_PWO_TNF_RecordTypeId;
        update  objPWO;
        
        Test.setCurrentPage(new PageReference('CPA_TNF_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objPWO.id);
        CPA_ContractInformationController  controller1 = new CPA_ContractInformationController  (new ApexPages.StandardController(objPWO));
       

       
        Test.stopTest();
    
    }
        

    static testmethod void Test_HLERequestInformationController(){
      Test.startTest();
        CPA_HLE_Request__c objHLE = new CPA_HLE_Request__c();
        insert objHLE; 
        
        Test.setCurrentPage(new PageReference('CPA_HLE_Request_Information_Display_Page'));
        System.currentPageReference().getParameters().put('id', objHLE.id);
        CPA_HLERequInformationController  controller1 = new CPA_HLERequInformationController  (new ApexPages.StandardController(objHLE));
        Test.stopTest();
    }
static testmethod void Test_BPEInformationController(){
      Test.startTest(); 
        CPA_HLE_Request__c objHLE1 = CPA_testClass_util.CreateBEP();    	
        insert objHLE1; 
        objHLE1.pkl_Status__c = ConstantsForContractingAppClasses.ACCEPTED;
        update objHLE1;
        objHLE1.recordtypeid = label.CPA_BPE_Recordtype;
        update objHLE1;
        System.currentPageReference().getParameters().put('id', objHLE1.id);
        CPA_HLERequInformationController  controller2 = new CPA_HLERequInformationController  (new ApexPages.StandardController(objHLE1));
        Test.stopTest();
    }
static testmethod void Test_HLEInformationController(){
      Test.startTest(); 
        CPA_HLE_Request__c objHLE2 = CPA_testClass_util.CreateBEP();    	
        insert objHLE2; 
        objHLE2.pkl_Status__c = ConstantsForContractingAppClasses.ACCEPTED;
        update objHLE2;
        objHLE2.recordtypeid = label.CPA_HLE_Recordtype;
        update objHLE2;
        System.currentPageReference().getParameters().put('id', objHLE2.id);
        CPA_HLERequInformationController  controller3 = new CPA_HLERequInformationController  (new ApexPages.StandardController(objHLE2));
        Test.stopTest();
    }
    }