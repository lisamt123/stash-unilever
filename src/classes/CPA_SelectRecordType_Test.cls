/********************************************************************
 Name:  CPA_SelectRecordType_Test()
 Copyright © 2015  Unilever
 ======================================================
======================================================
Purpose:  Test class to cover record type                                                     
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR    DATE              DETAIL                 Description
   1.0   Name      03/04/2015        INITIAL DEVELOPMENT           
***********************************************************************/
@isTest
public class CPA_SelectRecordType_Test {
    
   
     /*******************************************************************
    Purpose: This method is used to create record type tests
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static testMethod void getRecordTypeListpwo_tst() {
     
     CPA_PWORF__c objPworf = CPA_testPWORFClass_util.createTest_other_PWORF();
     objPworf.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
     insert objPworf;
     System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED == objPworf.pkl_Status__c); 
     
     CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf);
     objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
        insert  objPWO;
    
      System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED == objPWO.pkl_Status__c); 
     Test.startTest(); 
       
       Apexpages.currentPage().getParameters().put('id',objPWO.id);
        CPA_SelectRecordTypeController controller = new CPA_SelectRecordTypeController();
        
         System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED == objPWO.pkl_Status__c); 
         
        
        Test.stopTest();
     
     }
    /*******************************************************************
    Purpose: This method is used to create record type tests for LOI
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
      public static testMethod void getRecordTypeListLoi_tst() {
     
     CPA_PWORF__c objPworf = CPA_testPWORFClass_util.createTest_other_PWORF();
      objPworf.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
     insert objPworf;
     System.assert (CPA_ConstantsForContractingAppClasses.ANSWERED == objPworf.pkl_Status__c); 
     
     CPA_project_work_order__c objPWO =CPA_testContractClass.createPWO(objPworf);
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