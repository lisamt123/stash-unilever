@isTest
public class Amr_UploadSavingFilesController_Test {
     
        static testMethod void testMethod1() {
        Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com'
                                            );
        insert jobDetailsObj;
        
        Amr_Saving__c savingObj = new Amr_Saving__c(Duration_of_Additional_Films__c = '12.4',Duration_of_Masters__c = '5',Job_Details__c = jobDetailsObj.id,
                                  Monthly_Submitted__c = 'January',Folder_Name__c = 'Brief');
                                  
        insert savingObj;
        
        Document documentObj = new Document(body = Blob.valueOf('test'),name = 'test1');
        
        
        Amr_UploadSavingFilesController_CC.MultipleDocumentInner innerObj  = new Amr_UploadSavingFilesController_CC.MultipleDocumentInner();
        innerObj.document = documentObj;
        innerObj.savingObj = savingObj;
        
        ApexPages.currentPage().getParameters().put('id',savingObj.id);
        
        Amr_UploadSavingFilesController_CC controller = new Amr_UploadSavingFilesController_CC();
        controller.FileCount = '1';
        
        controller.ChangeCount();
        controller.allFileList.add(innerObj);
        controller.SaveAttachments();
        system.assert(controller!= null);
    }
     
}