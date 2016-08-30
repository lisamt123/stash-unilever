/**********************************************************************  
Name:  Amr_ReportTrigger_Test  ()  Copyright © 2015  Salesforce  
====================================================== 
====================================================== 
Purpose:                                                           
-------   This class used to test Amr_Report_Trigger trigger                                                        
 ====================================================== 
 ====================================================== 
 History                                                             
 -------                                                             
 VERSION   AUTHOR                        DATE              DETAIL                    Description    
 1.0       Mindtree                  04/02/2016      INITIAL DEVELOPMENT            CSR: 
 ***********************************************************************/
@isTest
public with sharing class Amr_ReportTrigger_Test{
    
    static testMethod void testMethod1() {
         Amr_Trigger_Pattern__c customSetting = new Amr_Trigger_Pattern__c(Check_Run__c = true,name = 'Amr_Report');
         insert customSetting;
          
         MDO_Category__c productCategory = new MDO_Category__c(name = 'Soups', category_type__c = ‘Category’);
         insert productCategory;
         
         MDO_Category__c productCategory1 = new MDO_Category__c(name = 'Advanced Toothpaste', category_type__c = ‘Category’);
         insert productCategory1;    
         
         Amr_Summary_Plan__c plan = new Amr_Summary_Plan__c(ProductCategory__c = productCategory.id,Year__c = String.valueOf(System.Today().year()));
        insert plan;
        
            
        Amr_Summary_Plan__c plan1 = new Amr_Summary_Plan__c(ProductCategory__c = productCategory1.id, Year__c = String.valueOf(System.Today().year()));
        insert plan1;    
         
         Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com',
                                            Function_You_Are_Part__c = 'BB',Project_Location_Cluster__c = Amr_ConstantForAdManager.CLUSTERLA,ProductCategory__c = productCategory.id,
                                            Project_Leader_Cluster__c = 'Africa',Stage_of_Production_Activity__c = 'Before briefing the agency',Budget_Responsibility__c = 'BD');
         insert jobDetailsObj;
         
          Amr_Job_Details__c jobDetailsObjnew = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com',
                                            Function_You_Are_Part__c = 'BD',Project_Location_Cluster__c = Amr_ConstantForAdManager.CLUSTERLA,ProductCategory__c = productCategory.id,
                                            Project_Leader_Cluster__c = 'Africa',Stage_of_Production_Activity__c = 'Before briefing the agency',Budget_Responsibility__c= 'BD');
         insert jobDetailsObjnew;
        
         Amr_Job_Details__c jobDetailsObj1 = new Amr_Job_Details__c(name = 'test2',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com',
                                            Function_You_Are_Part__c = 'BD',Project_Location_Cluster__c = Amr_ConstantForAdManager.CLUSTERLA,ProductCategory__c = productCategory1.id,
                                            Project_Leader_Cluster__c = Amr_ConstantForAdManager.CLUSTERLA,Stage_of_Production_Activity__c = 'Before getting quotations',Budget_Responsibility__c = 'BB');
        insert jobDetailsObj1;  
         
         Amr_Job_Details__c jobDetailsObj2 = new Amr_Job_Details__c(name = 'test2',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com',
                                            Function_You_Are_Part__c = 'BB',Project_Location_Cluster__c = Amr_ConstantForAdManager.CLUSTERLA,ProductCategory__c = productCategory1.id,
                                            Project_Leader_Cluster__c = Amr_ConstantForAdManager.CLUSTERLA,Stage_of_Production_Activity__c = 'Before getting quotations',Budget_Responsibility__c= 'BD');
        insert jobDetailsObj2; 
        jobDetailsObj2.name = 'Test3'; 
        update jobDetailsObj2;  
        
        Amr_Job_DetailsTrigger_Handler handler = new Amr_Job_DetailsTrigger_Handler();
        handler.bulkBefore();
        handler.bulkAfter();
        //sObject s = new Amr_Job_Details__c();
        handler.beforeInsert();
        handler.beforeUpdate();
        handler.beforeDelete();
        handler.afterDelete();
        handler.andFinally();
        system.assert(jobDetailsObj1!=null);
    }
    
}