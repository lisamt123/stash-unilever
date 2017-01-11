/**********************************************************************
Name: BEN_CategoryDetailsTriggerTest()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: This is the test class for Approval Process on Category Details -------
======================================================
======================================================
History
-------
VERSION     AUTHOR       DATE            DETAIL Description
V1.0       Swathi.K     21/12/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest
private class BEN_CategoryDetailsTriggerTest {
  //This method is used to cover BEN_CategoryDetailsTriggerHandler   
     static testMethod void testCategory_Validation() {
         
      BEN_Category_Details__c  categorydetails= createCategoryDetails(); 
   
         
         categorydetails.pkl_Status__c= 'Rejected';
          categorydetails.In_Approval__c=true;
        
         update  categorydetails;
        
          
         
         categorydetails.pkl_Status__c= 'Saved';
         categorydetails.bln_Mark_for_Deletion__c=true;
         update  categorydetails;
         
       /* 
        List<ProcessInstance> ap = [SELECT ID,Status, TargetObjectID
        FROM ProcessInstance
        WHERE TargetObjectID= :categorydetails.id];
        system.debug('processInstance List' + ap);
        
        ProcessInstance processInstance = new ProcessInstance();
        processInstance.TargetObjectId = categorydetails.Id;
        processInstance.Status = 'Rejected';
        insert processInstance;
        List<ProcessInstanceStep> actor = [SELECT ActorID,ProcessInstanceID
        FROM ProcessInstanceStep
        WHERE (StepStatus='Approved' OR StepStatus='Rejected') AND ProcessInstanceID in: ap];
        system.debug('processInstanceStep List' + actor);
        
        ProcessInstanceStep piStep = new ProcessInstanceStep();
        piStep.StepStatus = 'Rejected';
        piStep.ProcessInstanceID = processInstance.ID;
        piStep.ActorId = '00590000000vc59';
        
        insert piStep; */
        
//         BEN_Category_Details__c categorydetails1 = categorydetails;
//        categorydetails.In_Approval__c=false;
        //categorydetails.pkl_Status__c= 'Rejected';
        //update  categorydetails;
         
                 
    }
    
     static testMethod void testCategory_ValidationSecondStep() {
         
        BEN_Category_Details__c  categorydetailsecondstep= createCategoryDetails();
         
         categorydetailsecondstep.pkl_Status__c= 'Rejected';
         categorydetailsecondstep.Approval_Status__c='In Second Step';
        
         update  categorydetailsecondstep;
               
                 
    }
    
    static testMethod void testCategory_ValidationMarkDeletion() {
         
        BEN_Category_Details__c  categorydetailmarkdeletion= createCategoryDetails(); 
         
          categorydetailmarkdeletion.In_Approval__c=true;
         
         categorydetailmarkdeletion.pkl_Status__c= 'Saved';
         categorydetailmarkdeletion.bln_Mark_for_Deletion__c=true;
        
         update  categorydetailmarkdeletion;
               
                 
    }
    
     static testMethod void testCategory_ValidationReTest() {
         
        
         
         BEN_Category_Details__c  categorydetailsretet= createCategoryDetails();
         
         categorydetailsretet.pkl_Status__c= 'Saved';
         categorydetailsretet.bln_Flag_for_Retest__c=true;
        
         update  categorydetailsretet;
               
                 
    }
    
      static testMethod BEN_Category_Details__c createCategoryDetails() {
         
         BEN_Category_Master__c CategoryMaster1=new BEN_Category_Master__c(Name='Beverages123');
         insert CategoryMaster1;
         
         BEN_Category_CUC_Codes__c ccc = new BEN_Category_CUC_Codes__c();
         ccc.Name = 'Test';
         insert ccc;
         
         BEN_Category_Details__c categorydetails = new BEN_Category_Details__c();
         categorydetails.Product_Category__c = CategoryMaster1.Id;
         categorydetails.pkl_Region__c='South Asia' ;
         categorydetails.pkl_Brand__c='Lipton Yellow Label' ;
         categorydetails.txt_Title__c='Test123' ;
         categorydetails.pkl_Year__c='2016' ;
         categorydetails.pkl_Quarter__c='Q4' ;
         categorydetails.pkl_Logic__c='WIN on OO & KA' ;
         categorydetails.pkl_Key_Attributes__c='Parity' ;
       //categorydetails.pkl_OVERALL_SCORE__c='Parity' ;
         categorydetails.lkp_CUC_Codes__c=ccc.Id;
         categorydetails.pkl_Product_Format__c='Flavoured & Speciality' ;
         categorydetails.pkl_Product__c='Beceda' ;
         categorydetails.pkl_Country__c='India' ;
         categorydetails.pkl_Status__c='Saved' ;
         categorydetails.pkl_Key_Attribute_1_Appraisal__c = 'Parity';
         categorydetails.pkl_Key_Attribute_2_Consumer_Test__c = 'Parity';
         categorydetails.pkl_Benchmark__c = 'Barrys Gold';
         categorydetails.pkl_Blind_OO__c = 'Parity';
         categorydetails.txt_Unilever_Formula__c = 'testing';
         categorydetails.txt_Agency_Name__c = 'samsung';
         categorydetails.txt_Agency_Job_Number__c = '12345';
         categorydetails.txt_Reason_for_Deletion__c = 'dont want';
         insert categorydetails ; 
       
         
         Group testGroup = new Group(Name='BEN_Beverages123', Type='Queue');
         insert testGroup;
        
         System.runAs(new User(Id=UserInfo.getUserId())){
             QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
             insert testQueue;
             GroupMember GM = new GroupMember();
             GM.GroupId = testGroup.Id;
             GM.UserOrGroupId = UserInfo.getUserId();
             insert gm;
         }
        
         BEN_CategoryDetails__c bcd = new BEN_CategoryDetails__c();
         bcd.Name = 'Beverages123';
         bcd.QueueId__c = testGroup.Id;
         insert bcd;
         
        return  categorydetails ;
               
                 
    }
   
    
   
}