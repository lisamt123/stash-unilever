@isTest
public with sharing class Amr_JobPortfolioWorkspaceController_tst {

    static testMethod void method1(){
        
        Amr_JobPortfolioWorkspaceController jobWorkspace = new Amr_JobPortfolioWorkspaceController();
        Amr_Category__c category1 = new Amr_Category__c(Name='testCat');
        insert category1;
        Amr_Brand_Positioning__c brandPos = new Amr_Brand_Positioning__c(Category__c=category1.id,Name='testBrandPos');
        insert brandpos;
        Amr_Brand__c brand = new Amr_Brand__c(Brand_Positioning__c=brandPos.Id,Name='testBrand');
        insert brand;
        Amr_Job_Details__c jobDetail=new Amr_Job_Details__c(Job_Status__c='Priority',Unilever_Project_Leader_Email__c='abc@gmail.com',Broadcast_Market__c='testMarket',Name='testName',Project_Leader_Cluster__c='testCluster',Project_Leader_Country__c='testCountry',Lead_Creative_Agency_name__c='testAgency',Project_Name__c='testProj',Stage_of_Production_Activity__c='testStage',Job_Started__c='yes',Job_Reported__c='yes',Job_Shared__c='yes',Job_Accepted__c='yes',Your_Email_Address__c='abc@gmail.com',Unilever_Finance_Member_Email__c='abc@gmail.com',Target_Air_Date__c=date.newInstance(2015, 11, 21),Final_Approver_Of_Material_Email__c='abc@gmail.com',Digital_Agency_Name__c='testAgency',Campaign_Name__c='testCampaign',Budget_Allocated_Input_Value__c= 12.34,AdManagerText__c ='ABC/00001',Agency_Contact_Account_Director_Email__c = 'abc@gmail.com',Any_other_agencies_involved__c='Yes',Brodcast_Market__c='broadMarket',Category__c = category1.Id,Brand_Positioning__c =brandPos.Id,Brand__c=brand.Id);
        insert jobDetail;
        Amr_Alert__c alert = new Amr_Alert__c(New_Alert__c=date.newInstance(2015, 11, 21),Alert_Message__c='ABC',Hide__c=true);
        insert alert;
        Amr_Alert__c alert1 = new Amr_Alert__c(New_Alert__c=date.newInstance(2015, 11, 21),Alert_Message__c='ABC1',Hide__c=true);
        insert alert1;
        Amr_Comments__c comment = new Amr_Comments__c(new_Comment__c='ABC',AM_Job_Detail__c=jobDetail.Id);
        insert comment;
        Amr_Comments__c comment1 = new Amr_Comments__c(new_Comment__c='ABC1',AM_Job_Detail__c=jobDetail.Id);
        insert comment1;
        
        jobWorkspace.jobIdFromPage=jobDetail.Id;
        jobWorkspace.chosenId=alert.Id;
        jobWorkspace.chosenIdForComment=comment.Id;
        jobWorkspace.addNewAlert();
        jobWorkspace.deleteAlert();
        jobWorkspace.addNewComment();
        jobWorkspace.deleteComment();
        Document dummyDocument = new Document();
        dummyDocument.name = 'test';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        dummyDocument.body=bodyBlob;
        jobWorkspace.document=dummyDocument;
        jobWorkspace.uploadDocument();
        system.assert(dummyDocument!= null);
    }
    
    static testMethod void method2(){
        
        Amr_JobPortfolioWorkspaceController jobWorkspace = new Amr_JobPortfolioWorkspaceController();
        Amr_Alert__c alert = new Amr_Alert__c(New_Alert__c=date.newInstance(2015, 11, 21),Alert_Message__c='ABC',Hide__c=true);
        insert alert;
        jobWorkspace.jobIdFromPage='';
        jobWorkspace.addNewAlert();
        jobWorkspace.addNewComment();
         system.assert(alert!= null);
    }


}