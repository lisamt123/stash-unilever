@isTest
public with sharing class Amr_DownloadSavingFilesController_Test {

    static testMethod void testMethod1() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='AMR']; 
        User u = new User(Alias = 'stan21', Email='standuser21@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing21', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standuser@org.com');
        insert u;
        Id permissionSetId =  [select id, PermissionSet.Name from PermissionSet  where Name = 'RAP' Limit 1].Id;  
        PermissionSetAssignment permission= new PermissionSetAssignment(PermissionSetId = permissionSetId, AssigneeId = u.id);
        insert permission; 
        
        System.runAs(u){
        Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com'
                                            );
        insert jobDetailsObj;
        
        Amr_Saving__c savingObj = new Amr_Saving__c(Duration_of_Additional_Films__c = '12.4',Duration_of_Masters__c = '5',Job_Details__c = jobDetailsObj.id,
                                  Monthly_Submitted__c = 'January' );
                                  
        insert savingObj;
        
        Amr_Quote__c  QuoteObj = new Amr_Quote__c(Saving__c = savingObj.id, Name =  'test1');
        
        insert QuoteObj;
        
        FeedItem feedObject = new FeedItem(ParentId = savingObj.id,Body = 'Attachment added');
        insert feedObject;
       // feedObject.Name = 'test';
        //feedObject.ContentFileName = 'test*Brief';
        
            ApexPages.currentPage().getParameters().put('id',savingObj.id);
            Amr_DownloadSavingFilesController_CC controller = new Amr_DownloadSavingFilesController_CC();
            controller.folderselected = 'Brief';
            controller.folerName = 'Brief';
            controller.attachedList.add(feedObject);
            controller.downloadFile();
            controller.DisplayList.add(feedObject);
            controller.savingObj = savingObj;
         system.assert(controller!= null);
        
    }
    }
    
    static testMethod void testMethod2() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='AMR']; 
        User u = new User(Alias = 'stan21', Email='standuser21@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing21', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standuser@org.com');
        insert u;
        Id permissionSetId =  [select id, PermissionSet.Name from PermissionSet  where Name = 'CAP' Limit 1].Id;  
        PermissionSetAssignment permission= new PermissionSetAssignment(PermissionSetId = permissionSetId, AssigneeId = u.id);
        insert permission; 
        
        System.runAs(u){
        Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com'
                                            );
        insert jobDetailsObj;
        
        Amr_Saving__c savingObj = new Amr_Saving__c(Duration_of_Additional_Films__c = '12.4',Duration_of_Masters__c = '5',Job_Details__c = jobDetailsObj.id,
                                  Monthly_Submitted__c = 'January' );
                                  
        insert savingObj;
        
        Amr_Quote__c  QuoteObj = new Amr_Quote__c(Saving__c = savingObj.id, Name =  'test1');
        
        insert QuoteObj;
        
        FeedItem feedObject = new FeedItem(ParentId = savingObj.id,Body = 'Attachment added');
        insert feedObject;
       // feedObject.Name = 'test';
        //feedObject.ContentFileName = 'test*Brief';
        
            ApexPages.currentPage().getParameters().put('id',savingObj.id);
            Amr_DownloadSavingFilesController_CC  controller = new Amr_DownloadSavingFilesController_CC();
            controller.folderselected = 'Brief';
            controller.folerName = 'Brief';
            controller.attachedList.add(feedObject);
            controller.downloadFile();
            controller.DisplayList.add(feedObject);
            controller.savingObj = savingObj;
         system.assert(controller!= null);
        
    }
    }
    
    
    static testMethod void testMethod3() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='AMR']; 
        User u = new User(Alias = 'stan21', Email='standuser21@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing21', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standuser@org.com');
        insert u;
        Id permissionSetId =  [select id, PermissionSet.Name from PermissionSet  where Name = 'CAP' Limit 1].Id;  
        PermissionSetAssignment permission= new PermissionSetAssignment(PermissionSetId = permissionSetId, AssigneeId = u.id);
        insert permission; 
        
        System.runAs(u){
        Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com'
                                            );
        insert jobDetailsObj;
        
        Amr_Saving__c savingObj = new Amr_Saving__c(Duration_of_Additional_Films__c = '12.4',Duration_of_Masters__c = '5',Job_Details__c = jobDetailsObj.id,
                                  Monthly_Submitted__c = 'January' );
                                  
        insert savingObj;
        
        Amr_Quote__c  QuoteObj = new Amr_Quote__c(Saving__c = savingObj.id, Name =  'test1');
        
        insert QuoteObj;
        
        FeedItem feedObject = new FeedItem(ParentId = savingObj.id,Body = 'Attachment added');
        insert feedObject;
       // feedObject.Name = 'test';
        //feedObject.ContentFileName = 'test*Brief';
        
            ApexPages.currentPage().getParameters().put('id',savingObj.id);
            Amr_DownloadSavingFilesController_CC controller = new Amr_DownloadSavingFilesController_CC();
            controller.folderselected = NULL;
            controller.folerName = 'Brief';
            controller.attachedList.add(feedObject);
            controller.downloadFile();
            controller.DisplayList.add(feedObject);
            controller.savingObj = savingObj;
         system.assert(controller!= null);
        
    }
    }
}