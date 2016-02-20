@isTest
public with sharing class Amr_QuoteFinal_tst {
	 static testMethod void testMethod1(){
	 	
	 	Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com'
                                            );
        insert jobDetailsObj;
        
        Amr_Saving__c savingObj = new Amr_Saving__c(Duration_of_Additional_Films__c = 12.4,Duration_of_Masters__c = 5,Job_Details__c = jobDetailsObj.id,
                                  Monthly_Submitted__c = 'January' );
                                  
        insert savingObj;
        
        Amr_Quote__c  QuoteObj1 = new Amr_Quote__c(Saving__c = savingObj.id, Name =  'test1',Quote_Number__c = 1,Is_PC_part_of_the_Roster__c = 'Yes',PC_name__c = 'test',
        							PC_Country__c= 'Aruba' ,Service_Company_Name__c = 'svc' ,Local_Currency_of_PC_Costs__c = 'Peso',Local_Amount_of_PC__c = 1,PPC_Costs_Euro_Amount__c = 5,
        							Is_the_PPC_part_of_the_Roster__c = 'Yes',PPC_Name__c = 'testPPC',PPC_Country__c = 'Aruba',Local_Currency_of_PPC_Costs__c = 'Peso',
        							Local_Amount_of_PPC__c = 3,CA_Costs_Euro_Amount__c = 6,CA_Additional_agency_Name__c = 'testCa',CA_Location__c  = 'Aruba', Is_Accepted__c = true, Local_Currency_of_CA_Costs__c= 'Peso',
        							Local_Amount_of_CA__c = 5, PC_Costs_Euro_Amount__c= 7, Folder__c= 'Brief');
        
        //insert QuoteObj;
        
        Document documentObj = new Document(body = Blob.valueOf('test'),name = 'test1');
         
	 	ApexPages.currentPage().getParameters().put('id',savingObj.id);
	 	
	 	Amr_QuoteFinalController controller = new Amr_QuoteFinalController();
	 	
	 	controller.quoteNewRow.add(QuoteObj1);
	 	controller.document = documentObj;
	 	controller.addRowQuote(); 
	 	controller.SaveNewData();
	 	system.assert(controller!= null);
	 	
	 }
	 
	  static testMethod void testMethod2(){
	 	
	 	Amr_Job_Details__c jobDetailsObj = new Amr_Job_Details__c(name = 'test1',Agency_Contact_Account_Director_Email__c = 'test@gmail.com',
                                            Digital_Agency_Name__c = 'test',Target_Air_Date__c = Date.Today(),Your_Email_Address__c = 'abc@gmail.com',
                                            Any_other_agencies_involved__c = 'abc',Budget_Allocated_Input_Value__c = 5,Campaign_Name__c = 'xyz',
                                            Final_Approver_Of_Material_Email__c = 'xas@gmail.com',Unilever_Finance_Member_Email__c = 'pqe@gmail.com'
                                            );
        insert jobDetailsObj;
        
        Amr_Saving__c savingObj = new Amr_Saving__c(Duration_of_Additional_Films__c = 12.4,Duration_of_Masters__c = 5,Job_Details__c = jobDetailsObj.id,
                                  Monthly_Submitted__c = 'January' );
                                  
        insert savingObj;
        
        Amr_Quote__c  QuoteObj1 = new Amr_Quote__c(Saving__c = savingObj.id, Name =  'test1',Quote_Number__c = 1,Is_PC_part_of_the_Roster__c = 'Yes',PC_name__c = 'test',
        							PC_Country__c= 'Aruba' ,Service_Company_Name__c = 'svc' ,Local_Currency_of_PC_Costs__c = 'Peso',Local_Amount_of_PC__c = 1,PPC_Costs_Euro_Amount__c = 5,
        							Is_the_PPC_part_of_the_Roster__c = 'Yes',PPC_Name__c = 'testPPC',PPC_Country__c = 'Aruba',Local_Currency_of_PPC_Costs__c = 'Peso',
        							Local_Amount_of_PPC__c = 3,CA_Costs_Euro_Amount__c = 6,CA_Additional_agency_Name__c = 'testCa',CA_Location__c  = 'Aruba', Is_Accepted__c = true, Local_Currency_of_CA_Costs__c= 'Peso',
        							Local_Amount_of_CA__c = 5, PC_Costs_Euro_Amount__c= 7, Folder__c= 'Brief');
        
         Amr_Quote__c  QuoteObj2 = new Amr_Quote__c(Saving__c = savingObj.id, Name =  'test1',Quote_Number__c = 1,Is_PC_part_of_the_Roster__c = 'Yes',PC_name__c = 'test',
        							PC_Country__c= 'Aruba' ,Service_Company_Name__c = 'svc' ,Local_Currency_of_PC_Costs__c = 'Peso',Local_Amount_of_PC__c = 1,PPC_Costs_Euro_Amount__c = 5,
        							Is_the_PPC_part_of_the_Roster__c = 'Yes',PPC_Name__c = 'testPPC',PPC_Country__c = 'Aruba',Local_Currency_of_PPC_Costs__c = 'Peso',
        							Local_Amount_of_PPC__c = 3,CA_Costs_Euro_Amount__c = 6,CA_Additional_agency_Name__c = 'testCa',CA_Location__c  = 'Aruba', Is_Accepted__c = true, Local_Currency_of_CA_Costs__c= 'Peso',
        							Local_Amount_of_CA__c = 5, PC_Costs_Euro_Amount__c= 7, Folder__c= 'Brief');
        insert QuoteObj2;
        
        Document documentObj = new Document(body = Blob.valueOf('test'),name = 'test1');
         
	    ApexPages.currentPage().getParameters().put('id',savingObj.id);
	 	
	 	Amr_QuoteFinalController controller = new Amr_QuoteFinalController();
	 	
	 	controller.quoteNewRow.add(QuoteObj1);
	 	controller.document = documentObj;
	 	
	 	controller.addRowQuote(); 
	 	controller.IdDeleted = QuoteObj1.id;
	 	controller.deleteQuote();
	 	controller.appraisalId = QuoteObj2.id;
	 	
	 	controller.displayAppraisal();
	 	controller.saveAppraisal();
	 	controller.UpdateAcceptedQuote();
	 	controller.getAppraisalRating();
	 	system.assert(controller!= null);
	 	
	 }
}