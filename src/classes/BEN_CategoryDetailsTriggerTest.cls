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
    
    static testMethod void testRejectRecordResubmition(){
        
        BEN_Category_Details__c  categorydetailsecondstep= createCategoryDetails();
        categorydetailsecondstep.In_Approval__c=true;
        categorydetailsecondstep.pkl_Status__c= 'Rejected';
        categorydetailsecondstep.Approval_Status__c='In Second Step';
        categorydetailsecondstep.bln_Flag_for_Retest__c=true; 
        update  categorydetailsecondstep;
        system.debug('categorydetailsecondstep status after update (Rejected) : '+ [Select ID, pkl_Status__c from BEN_Category_Details__c where ID = :categorydetailsecondstep.Id ]);
        
        BEN_Category_Details__c  cd2 = new  BEN_Category_Details__c();
        cd2 = categorydetailsecondstep;
        cd2.pkl_Status__c = 'Approved';
        cd2.In_Approval__c=true;
        cd2.bln_Mark_for_Deletion__c = false;
        update cd2;
        
         system.debug('cd2 status after update(Approved)  : '+ [Select ID, pkl_Status__c from BEN_Category_Details__c where ID = :categorydetailsecondstep.Id ]);  
             
        List<BEN_Category_Details__c> trigNewList = new List<BEN_Category_Details__c>();
        Map<ID, BEN_Category_Details__c> trigNewMap = new Map<ID, BEN_Category_Details__c>();
        Map<ID, BEN_Category_Details__c> trigOldMap = new Map<ID, BEN_Category_Details__c>();
        trigNewList.add(cd2);
        trigNewMap.put(cd2.Id, cd2);
        trigOldMap.put(categorydetailsecondstep.id, categorydetailsecondstep);
        
        BEN_CategoryDetailsTriggerHandler.rejectedRecord = true;
        BEN_CategoryDetailsTriggerHandler.SendRecordForApproval(trigNewList, trigOldMap, trigNewMap);
        List<String> usrList = new List<String>();
        usrList.add(UserInfo.getUserId());
        
        Map<Id,BEN_Category_Details__c> categoryMap = new Map<Id,BEN_Category_Details__c>([select Id,In_Approval__c,
                                                                                               Product_Category__c,
                                                                                               Product_Category__r.Name,txt_Reason_for_Deletion__c,
                                                                                               CreatedBy.Name,LastModifiedBy.Name
                                                                                               from BEN_Category_Details__c
                                                                                               where Id In :trigNewList]);
        
        BEN_CategoryDetailsTriggerHandler.sendEmail(categorydetailsecondstep, usrList, categoryMap);
        
    }
    
    
    static testMethod void testCategory_ValidationSecondStep() {
        
        BEN_Category_Details__c  categorydetailsecondstep= createCategoryDetails();
        
        categorydetailsecondstep.pkl_Status__c= 'Rejected';
        categorydetailsecondstep.Approval_Status__c='In Second Step';
        
        update  categorydetailsecondstep;
    }
    
     public static boolean checkEmpty(List<sObject> objs){
        
        if(objs == null){
            return true;
        }else if(objs.size()==0){
            return true;
        }else
            return false;
    }
    
    public static Id getWorkItemId(Id targetObjectId)
    {
        Id retVal = null;

        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
            where p.ProcessInstance.TargetObjectId =: targetObjectId])
        {
            retVal  =  workItem.Id;
        }

        return retVal;
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
        
        BEN_Category_Master__c CategoryMaster1=new BEN_Category_Master__c(Name='Beverages',pkl_Super_Category__c='Home Care');
        
        insert CategoryMaster1;
        
        /*BEN_CU_GTIN__c ccc = new BEN_CU_GTIN__c();
        ccc.Name = 'Beverages';
        insert ccc;*/
        
        BEN_Benchmark__c benchamrking = new BEN_Benchmark__c();
        benchamrking.CurrencyIsoCode = 'EUR';
        benchamrking.Name = 'Barrys Gold';
        insert benchamrking; 
       
        
        BEN_Category_Details__c categorydetails = new BEN_Category_Details__c();
        categorydetails.Product_Category__c = CategoryMaster1.Id;
        categorydetails.pkl_Category_Master__c= 'Beverages'; 
        categorydetails.pkl_Region__c='South Asia' ;
        categorydetails.pkl_Brand__c='Lipton Yellow Label' ;
        categorydetails.txt_Title__c='Test123' ;
        categorydetails.pkl_Year__c='2016' ;
        categorydetails.pkl_Quarter__c='Q4' ;
        categorydetails.pkl_Logic__c='WIN on OO & KA' ;
        categorydetails.pkl_Key_Attributes__c='Parity' ;
        //categorydetails.pkl_OVERALL_SCORE__c='Parity' ;
        categorydetails.txt_CUC_Code__c='test';
        categorydetails.pkl_Product_Format__c='Flavoured & Speciality' ;
        categorydetails.pkl_Product__c='Beceda' ;
        categorydetails.pkl_Country__c='India' ;
        categorydetails.pkl_Status__c='Saved' ;
        categorydetails.pkl_Key_Attribute_1_Appraisal__c = 'Parity';
        categorydetails.pkl_Key_Attribute_2_Consumer_Test__c = 'Parity';
        categorydetails.lkp_Benchmark__c = benchamrking.Id; 
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
        bcd.Name = 'Beverages';
        bcd.QueueId__c = testGroup.Id;
        insert bcd;
        
        return  categorydetails ;
        
        
    }

}