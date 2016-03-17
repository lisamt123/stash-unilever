@isTest
public with sharing class Amr_ReportTrigger_Test{
    
    static testMethod void testMethod1() {
         MDO_Category__c productCategory = new MDO_Category__c(name = 'Soups');
         insert productCategory;
         
         MDO_Category__c productCategory1 = new MDO_Category__c(name = 'Advanced Toothpaste');
         insert productCategory1;        
         
         Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com',
                                            Function_You_Are_Part__c = 'BB',Project_Location_Cluster__c = 'Latin America',ProductCategory__c = productCategory.id);
         insert jobDetailsObj;
        
         Amr_Job_Details__c jobDetailsObj1 = new Amr_Job_Details__c(name = 'test2',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com',
                                            Function_You_Are_Part__c = 'BD',Project_Location_Cluster__c = 'Latin America',ProductCategory__c = productCategory1.id);
        insert jobDetailsObj1;
        
        system.assert(jobDetailsObj1!=null);
    }
    
}