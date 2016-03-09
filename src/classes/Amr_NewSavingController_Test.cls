@isTest
public with sharing class Amr_NewSavingController_Test {
  /* utkarsh   
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
        Amr_NewSavingController_CC controller = new Amr_NewSavingController_CC();
        controller.addRowQuote();
        Amr_Quote__c  QuoteObj1 = new Amr_Quote__c(Saving__c = savingObj.id, Name =  'test2');
        
        insert QuoteObj1;
        
        controller.addRowQuote();
        system.assert(controller!= null);
        
     }
     
     static testMethod void testMethod2() {
        Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com'
                                            );
        insert jobDetailsObj;
        
        Amr_Saving__c savingObj = new Amr_Saving__c(Duration_of_Additional_Films__c = 12.4,Duration_of_Masters__c = 5,Job_Details__c = jobDetailsObj.id,
                                  Monthly_Submitted__c = 'January' );
                                  
        ApexPages.currentPage().getParameters().put('id',jobDetailsObj.id);
        Amr_NewSavingController_CC controller = new Amr_NewSavingController_CC();
        controller.SaveAllData();
        system.assert(controller!= null);
        
        
     }
     
      static testMethod void testMethod3() {
        
        Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com'
                                            );
        insert jobDetailsObj;
        
        Amr_Saving__c savingObj = new Amr_Saving__c(Duration_of_Additional_Films__c = 12.4,Duration_of_Masters__c = 5,Job_Details__c = jobDetailsObj.id,
                                  Monthly_Submitted__c = 'January' );
       
        
        Document dummyDocument = new Document();
        dummyDocument.name = 'test';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        dummyDocument.body=bodyBlob;
                                  
        ApexPages.currentPage().getParameters().put('id',jobDetailsObj.id);
        
        Amr_NewSavingController_CC controller = new Amr_NewSavingController_CC();
        controller.selectedCountry = new List<String>();
        controller.selectedCountry.add('test');
        controller.document = dummyDocument;
        controller.SaveSaving();
        controller.SaveAllData();
        system.assert(controller!= null);
     }
     
     static testMethod void testMethod4() {
        Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com'
                                            );
        insert jobDetailsObj;
        
        Amr_Saving__c savingObj1 = new Amr_Saving__c(Duration_of_Additional_Films__c = 12.4,Duration_of_Masters__c = 5,Job_Details__c = jobDetailsObj.id,
                                  Monthly_Submitted__c = 'January' );
       
        insert savingObj1;
        
        Amr_Quote__c  QuoteObj = new Amr_Quote__c(Name =  'test1',Local_Currency_of_PC_Costs__c ='Euro',Local_Amount_of_PC__c = 22,PC_Costs_Euro_Amount__c = 3,
                                                    Local_Currency_of_PPC_Costs__c = 'Euro',Local_Amount_of_PPC__c = 22,PPC_Costs_Euro_Amount__c=2,Local_Currency_of_CA_Costs__c= 'Euro',
                                                    Local_Amount_of_CA__c = 11,CA_Costs_Euro_Amount__c = 11,Is_Accepted__c = true);
        
        Document dummyDocument = new Document();
        dummyDocument.name = 'test';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        dummyDocument.body=bodyBlob;

        Amr_NewSavingController_CC controller = new Amr_NewSavingController_CC();
        controller.savingObj = savingObj1;
        controller.QuoteNumber = 1;
        Amr_NewSavingController_CC.InnerSavingClass innerController = new Amr_NewSavingController_CC.InnerSavingClass(1,true,QuoteObj);
        //innerController.quoteObj = QuoteObj;
        innerController.attachmentObj = dummyDocument;
        controller.docAndQuoteLst.add(innerController);
        controller.SaveAllData();
        system.assert(controller!= null);
     }
     
      static testMethod void testMethod5() {
        Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com'
                                            );
        insert jobDetailsObj;
        
        Amr_Saving__c savingObj1 = new Amr_Saving__c(Duration_of_Additional_Films__c = 12.4,Duration_of_Masters__c = 5,Job_Details__c = jobDetailsObj.id,
                                  Monthly_Submitted__c = 'January' );
       
        insert savingObj1;
        
        Amr_Quote__c  QuoteObj = new Amr_Quote__c(Saving__c = savingObj1.id,Name =  'test1',Local_Currency_of_PC_Costs__c ='Euro',Local_Amount_of_PC__c = 22,PC_Costs_Euro_Amount__c = 3,
                                                    Local_Currency_of_PPC_Costs__c = 'Euro',Local_Amount_of_PPC__c = 22,PPC_Costs_Euro_Amount__c=2,Local_Currency_of_CA_Costs__c= 'Euro',
                                                    Local_Amount_of_CA__c = 11,CA_Costs_Euro_Amount__c = 11,Is_Accepted__c = true);
        insert QuoteObj;
        
        Document dummyDocument = new Document();
        dummyDocument.name = 'test';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        dummyDocument.body=bodyBlob;

        Amr_NewSavingController_CC controller = new Amr_NewSavingController_CC();
        controller.savingObj = savingObj1;
        controller.uploadQuoteDocument(QuoteObj,dummyDocument);
        controller.acceptedQuote = QuoteObj;
        controller.UpdateAcceptedQuote();
        controller.pcTimeMangCategoryValue = 1;
        controller.pcTimeMangCategoryClass = '1';
        controller.pcCostMangCategoryValue = 1;
        controller.pcCostMangCategoryClass = '1';
        controller.pcProcessMangCategoryValue = 1;
        controller.pcProcessMangCategoryClass = '1';
        controller.pcOutputQualityCategoryValue = 1;
        controller.pcOutputQualityCategoryClass = '1';
        controller.pccTimeMangCategoryValue = 1;
        controller.pccTimeMangCategoryClass = '1';
        controller.pccCostMangCategoryValue = 1;
        controller.pccCostMangCategoryClass = '1';
        controller.pccProcessMangCategoryValue =  1;
        controller.pccProcessMangCategoryClass = '1';
        controller.pccOutputQualityCategoryValue = 1;
        controller.pccOutputQualityCategoryClass = '1';
        controller.caTimeMangCategoryValue = 1;
        controller.caTimeMangCategoryClass = '1';
        controller.caCostMangCategoryValue = 1;
        controller.caCostMangCategoryClass = '1';
        controller.caProcessMangCategoryValue = 1;
        controller.caProcessMangCategoryClass = '1';
        controller.caOutputQualityCategoryValue = 1;
        controller.caOutputQualityCategoryClass = '1';
        controller.AllValues();
        system.assert(controller!= null);
     }
     
     */ 
}