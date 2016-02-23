@isTest
public class Amr_JobSheetPageController_tst{

    static testMethod void testMethod1() {
        
        Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com'
                                            );
        insert jobDetailsObj;
        
        Amr_Saving__c savingObj = new Amr_Saving__c(Duration_of_Additional_Films__c = 12.4,Duration_of_Masters__c = 5,Job_Details__c = jobDetailsObj.id,
                                  Monthly_Submitted__c = 'January' );
                                  
        insert savingObj;
        
        Amr_Quote__c  QuoteObj = new Amr_Quote__c(Saving__c = savingObj.id, Name =  'test1');
        
        insert QuoteObj;
        
        ApexPages.currentPage().getParameters().put('id',jobDetailsObj.id);
        Amr_JobSheetPageController_anjali controller = new Amr_JobSheetPageController_anjali();
        controller.addRowSavingLine();
        system.assert(controller!= null);
    }
    
    static testMethod void testMethod2_savingNull() {
        
        Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com'
                                            );
        insert jobDetailsObj;
        
        ApexPages.currentPage().getParameters().put('id',jobDetailsObj.id);
        Amr_JobSheetPageController_anjali controller = new Amr_JobSheetPageController_anjali();
        controller.addRowSavingLine();
        system.assert(controller!= null);
    }
    
    static testMethod void uploadDocument() {
        
        Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com'
                                            );
        insert jobDetailsObj;
        
        Amr_Saving__c savingObj = new Amr_Saving__c(Duration_of_Additional_Films__c = 5,Duration_of_Masters__c = 5,Job_Details__c = jobDetailsObj.id,
                                  Monthly_Submitted__c = 'January' );
                                  
        insert savingObj;
        
        Amr_Quote__c  QuoteObj = new Amr_Quote__c(Saving__c = savingObj.id, Name =  'test1');
        
        insert QuoteObj;
        
        ApexPages.currentPage().getParameters().put('id',jobDetailsObj.id);
        
        
        Document dummyDocument = new Document();
        dummyDocument.name = 'test';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        dummyDocument.body=bodyBlob;
        
         
        Amr_JobSheetPageController_anjali controller = new Amr_JobSheetPageController_anjali();
        controller.document = dummyDocument;
        
        List<Amr_Saving__c> amrSavinglst = new List<Amr_Saving__c>();
        amrSavinglst.add(savingObj);
        
        controller.uploadDocument(amrSavinglst);
        system.assert(controller!= null);
    }
    
    static testMethod void addNewRowDocument() {
        
        Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com'
                                            );
        insert jobDetailsObj;
        
        Amr_Saving__c savingObj = new Amr_Saving__c(Duration_of_Additional_Films__c = 6,Duration_of_Masters__c = 5,Job_Details__c = jobDetailsObj.id,
                                  Monthly_Submitted__c = 'January' );

        
        ApexPages.currentPage().getParameters().put('id',jobDetailsObj.id);
        
        Document dummyDocument = new Document();
        dummyDocument.name = 'test';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        dummyDocument.body=bodyBlob;
        
         
        Amr_JobSheetPageController_anjali controller = new Amr_JobSheetPageController_anjali();
        controller.document = dummyDocument;
        
        List<Amr_Saving__c> amrSavinglst = new List<Amr_Saving__c>();
        amrSavinglst.add(savingObj);
        controller.lstQuoteToaddRow = amrSavinglst;
        controller.addRowSavingLine();
        
        controller.IdValue = ApexPages.currentPage().getParameters().put('id',jobDetailsObj.id);
        controller.SaveUpdatedData();
        controller.SaveNewData();
        	
        controller.redirectNewPage();
        controller.quoteList.add(savingObj);
        controller.deleteQuote();
        system.assert(controller!= null);
    }

}