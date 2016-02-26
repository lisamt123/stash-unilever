@isTest(SeeAllData=true)
public class Test_CPA_SelectRecordType_tst {

     public static testMethod void getRecordTypeList_tst() {
     
     CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
     insert objPworf;
         
       Test.startTest(); 
       
        Apexpages.currentPage().getParameters().put('id',objPworf.id);
        SelectRecordTypeController controller = new SelectRecordTypeController();
        controller.redirectToPageNewItem();
        controller.cancelRedirect();
           
         
        
        Test.stopTest();
     
     }
      public static testMethod void getRecordTypeListpwo_tst() {
     
     CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
     insert objPworf;
     
     
     CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf);
        insert  objPWO;

      
     Test.startTest(); 
       
       Apexpages.currentPage().getParameters().put('id',objPWO.id);
        SelectRecordTypeController controller = new SelectRecordTypeController();
        
           
         
        
        Test.stopTest();
     
     }
     
      public static testMethod void getRecordTypeListLoi_tst() {
     
     CPA_PWORF__c objPworf = CPA_testClass_util.createTest_other_PWORF();
     insert objPworf;
     
     
     CPA_project_work_order__c objPWO =CPA_testClass_util.createPWO(objPworf);
        insert  objPWO;

      
     Test.startTest(); 
       
       Apexpages.currentPage().getParameters().put('id',objPWO.id);
       Apexpages.currentPage().getParameters().put('flag','Loi');
        SelectRecordTypeController controller = new SelectRecordTypeController();
        
           
         
        
        Test.stopTest();
     
     }

}