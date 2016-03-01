@isTest
public class CPA_SelectRecordType_Test {

     public static testMethod void getRecordTypeList_tst() {
     
     CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
     objPworf.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
    insert objPworf;
         
       Test.startTest(); 
       
        Apexpages.currentPage().getParameters().put('id',objPworf.id);
        CPA_SelectRecordTypeController controller= new CPA_SelectRecordTypeController();
        controller.redirectToPageNewItem();
        
        System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED ==  objPworf.pkl_Status__c);   
         controller.cancelRedirect();
        
        Test.stopTest();
     
     }
      public static testMethod void getRecordTypeListpwo_tst() {
     
     CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
     objPworf.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
     insert objPworf;
     System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED == objPworf.pkl_Status__c); 
     
     CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf);
     objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
        insert  objPWO;
    
      System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED == objPWO.pkl_Status__c); 
     Test.startTest(); 
       
       Apexpages.currentPage().getParameters().put('id',objPWO.id);
        CPA_SelectRecordTypeController controller = new CPA_SelectRecordTypeController();
        
         System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED == objPWO.pkl_Status__c); 
         
        
        Test.stopTest();
     
     }
     
      public static testMethod void getRecordTypeListLoi_tst() {
     
     CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
      objPworf.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
     insert objPworf;
     System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED == objPworf.pkl_Status__c); 
     
     CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf);
     objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
        insert  objPWO;

       System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED == objPWO.pkl_Status__c); 
     Test.startTest(); 
       
       Apexpages.currentPage().getParameters().put('id',objPWO.id);
       Apexpages.currentPage().getParameters().put('flag','Loi');
        CPA_SelectRecordTypeController controller = new CPA_SelectRecordTypeController();
        
            System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED == objPWO.pkl_Status__c); 
         
        
        Test.stopTest();
     
     }

}