@isTest
public class JE_UpdateMDRpointsHandlerTest{
 
public static testmethod void jePositiveTest(){
    boolean errorMessage = false; 
    JE_TestFactory.JE_Points_Insertion(2);
    Test.startTest();    
    LIST<JE_Job_Evaluation__c> jeJob = JE_TestFactory.JE_Job_Insertion(1);
    JE_Job_Evaluation__c je = [select id,Range_of_salary__c from JE_Job_Evaluation__c limit 1];    
    errorMessage  = je.Range_of_salary__c.contains(Label.JE_Salary_Range_Error)?true:false;
    Test.stopTest();
    System.assertEquals(false, errorMessage);
}
public static testmethod void jeNegativeTest(){
    boolean errorMessage = false; 
    JE_TestFactory.JE_Points_Insertion(5);
    Test.startTest();    
    LIST<JE_Job_Evaluation__c> jeJob = JE_TestFactory.JE_Job_Insertion(1);
    JE_Job_Evaluation__c je = [select id,Range_of_salary__c from JE_Job_Evaluation__c limit 1];     
    errorMessage  = je.Range_of_salary__c.contains(Label.JE_Salary_Range_Error)?true:false;
    Test.stopTest();
    System.assertEquals(true, errorMessage);
}
public static testmethod void jePositiveTestOne(){
    boolean errorMessage = false; 
    JE_TestFactory.JE_Points_Insertion(-1);
    Test.startTest();    
    LIST<JE_Job_Evaluation__c> jeJob = JE_TestFactory.JE_Job_Insertion(1);
    JE_Job_Evaluation__c je = [select id,Paypoint_Based_on_Range_Penetration__c from JE_Job_Evaluation__c limit 1];    
    errorMessage  = je.Paypoint_Based_on_Range_Penetration__c.contains(Label.JE_Salary_Range_Error)?true:false;
    Test.stopTest();
    System.assertEquals(false, errorMessage);
}
public static testmethod void jeNegativeTestOne(){
    boolean errorMessage = false; 
    JE_TestFactory.JE_Points_Insertion(1);
    Test.startTest();    
    LIST<JE_Job_Evaluation__c> jeJob = JE_TestFactory.JE_Job_Insertion(1);
    JE_Job_Evaluation__c je = [select id,Paypoint_Based_on_Range_Penetration__c from JE_Job_Evaluation__c limit 1];    
    errorMessage  = je.Paypoint_Based_on_Range_Penetration__c.contains(Label.JE_Penetration_Range_Error)?true:false;
    Test.stopTest();
    System.assertEquals(true, errorMessage);
}
}