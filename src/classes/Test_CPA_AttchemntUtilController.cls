@isTest(SeeAllData=true)
public class Test_CPA_AttchemntUtilController {

    static testmethod void Test_CPA_AttchemntUtil() {   
        CPA_PWORF__c objPworf14 = CPA_testClass_util.createTest_other_PWORF();
        insert objPworf14;
        objPworf14.pkl_Status__c = 'Answered';
        update objPworf14;
        
    List<Attachment>  listAttachment = new List<Attachment>();             
        CPA_LOI__c objLOI =CPA_testClass_util.createLOI (objPworf14);
        insert  objLOI;
        objLOI.pkl_Status__c ='Submitted';
        update objLOI;
        Blob bBlob5 = Blob.valueOf('Test');
        Attachment attachment5 = new Attachment();
        attachment5.ParentId = objLOI.ID;
        attachment5.Name = 'LOI RentReceipt.pdf.pdf';
        attachment5.ContentType = 'application/pdf';
        attachment5.Body = bBlob5;
        //insert(attachment5);
        listAttachment.add(attachment5);
        
        CPA_project_work_order__c objPWO = CPA_testClass_util.createPWO(objPworf14);
        insert objPWO;
        
        Blob bBlob = Blob.valueOf('Entity Type,Entity Name,Role,Location,Resource Level,Rate,Cost Name,Year,Month,Effort (Man Days),Expense\n1,1,Senior SME,USA,8,191,1,2015,Sep,21,1');
        Attachment attachment = new Attachment();
        attachment.ParentId = objPWO.ID;
        attachment.Name = 'Commercial for PWO.csv';
        attachment.ContentType = 'application/vnd.ms-excel';
        attachment.Body = bBlob;
        //insert(attachment);
        listAttachment.add(attachment);
        
        Blob bBlob1 = Blob.valueOf('Test');
        Attachment attachment1 = new Attachment();
        attachment1.ParentId = objPWO.ID;
        attachment1.Name = 'PWO RentReceipt.pdf.pdf';
        attachment1.ContentType = 'application/pdf';
        attachment1.Body = bBlob1;
       // insert(attachment1);
        listAttachment.add(attachment1);

        objPWO.pkl_Status__c = 'Accepted';
        update objPWO;    
    CPA_Commercial_Details__c obj1 = new CPA_Commercial_Details__c();
    obj1.Project_Work_Order__c = objPWO.id;
    insert  obj1;    
        
        
        CPA_CR__c objCR = CPA_testClass_util.createCR(objPWO);
        insert objCR;
        CPA_project_work_order__c pwo = [Select Id,pkl_Status__c from CPA_project_work_order__c where Id=:objCR.CPA_Project_Work_Order__c];
        Blob bBlob2 = Blob.valueOf('Entity Type,Entity Name,Role,Location,Resource Level,Rate,Cost Name,Year,Month,Effort (Man Days),Expense\n1,1,Senior SME,USA,8,191,1,2015,Sep,21,1');
        Attachment attachment2 = new Attachment();
        attachment2.ParentId = objCR.ID;
        attachment2.Name = 'Commercial for CR.csv';
        attachment2.ContentType = 'application/vnd.ms-excel';
        attachment2.Body = bBlob2;
        //insert(attachment2);
        listAttachment.add(attachment2);
    
    CPA_Commercial_Details__c obj = new CPA_Commercial_Details__c();
    obj.CR__c = objCR.id;
    insert  obj;
    
        
        
        Blob bBlob13 = Blob.valueOf('Test');
        Attachment attachment3 = new Attachment();
        attachment3.ParentId = objCR.ID;
        attachment3.Name = 'CR RentReceipt.pdf.pdf';
        attachment3.ContentType = 'application/pdf';
        attachment3.Body = bBlob13;
       // insert(attachment3);
        listAttachment.add(attachment3);
        
        
        insert listAttachment;
        
        List<Attachment> listLOi = [Select Id,ParentId from Attachment where ParentId=:objLOI.Id];
		listLOi.add(attachment5);
		CPA_AttchemntUnit.updateLOI(listLOi);
		CPA_AttchemntUnit.DeleteLOI(listLOi);
	}
    static testmethod void Test_CPA_AttchemntUtil1() { 
    //*---------------------------------------------------------------*//
	   CPA_PWORF__c objPworf15 = CPA_testClass_util.createTest_other_PWORF();
			insert objPworf15;
			objPworf15.pkl_Status__c = 'Answered';
			update objPworf15;
		 
		List<Attachment>  listAttachment = new List<Attachment>();             
		   
			
			CPA_project_work_order__c objPWO151 = CPA_testClass_util.createPWO(objPworf15);
			insert objPWO151;
			
			Blob bBlob11 = Blob.valueOf('Entity Type,Entity Name,Role,Location,Resource Level,Rate,Cost Name,Year,Month,Effort (Man Days),Expense\n1,1,Senior SME,USA,8,191,1,2015,Sep,21,1');
			Attachment attachment78 = new Attachment();
			CPA_project_work_order__c obj = [Select Id from CPA_project_work_order__c where Id =: objPWO151.Id];
			attachment78.ParentId = obj.ID;
			attachment78.Name = 'Commercial for PWO.csv';
			attachment78.ContentType = 'application/vnd.ms-excel';
			attachment78.Body = bBlob11;
			insert(attachment78);
         system.debug('attachment78.ParentId--->'+attachment78.ParentId);
			//listAttachment.add(attachment78);
			
			Blob bBlob12 = Blob.valueOf('Test');
			Attachment attachment17 = new Attachment();
			attachment17.ParentId = objPWO151.ID;
			attachment17.Name = 'PWO RentReceipt.pdf.pdf';
			attachment17.ContentType = 'application/pdf';
			attachment17.Body = bBlob12;
		   // insert(attachment1);
			listAttachment.add(attachment17);

			objPWO151.pkl_Status__c = 'Accepted';
			update objPWO151;    
		CPA_Commercial_Details__c obj15 = new CPA_Commercial_Details__c();
		obj15.Project_Work_Order__c = objPWO151.id;
		insert  obj15;    
			
			
			CPA_CR__c objCR1 = CPA_testClass_util.createCR(objPWO151);
			insert objCR1;
			CPA_project_work_order__c pwo12 = [Select Id,pkl_Status__c from CPA_project_work_order__c where Id=:objCR1.CPA_Project_Work_Order__c];
		   // objCR1.CPA_project_work_order__c = pwo12.id;
			Blob bBlob21 = Blob.valueOf('Entity Type,Entity Name,Role,Location,Resource Level,Rate,Cost Name,Year,Month,Effort (Man Days),Expense\n1,1,Senior SME,USA,8,191,1,2015,Sep,21,1');
			Attachment attachment21 = new Attachment();
			attachment21.ParentId = objCR1.ID;
			attachment21.Name = 'Commercial for CR.csv';
			attachment21.ContentType = 'application/vnd.ms-excel';
			attachment21.Body = bBlob21;
			//insert(attachment2);
			listAttachment.add(attachment21);
		
		CPA_Commercial_Details__c obj11 = new CPA_Commercial_Details__c();
		obj11.CR__c = objCR1.id;
		insert  obj11;
		
			
			
			Blob bBlob131 = Blob.valueOf('Test');
			Attachment attachment31 = new Attachment();
			attachment31.ParentId = objCR1.ID;
			attachment31.Name = 'CR RentReceipt.pdf.pdf';
			attachment31.ContentType = 'application/pdf';
			attachment31.Body = bBlob131;
		   // insert(attachment3);
			listAttachment.add(attachment31);
			
			
			
		
		
		
		CPA_CR__c objCR2 = CPA_testClass_util.createCR(objPWO151);
			insert objCR2;
			//CPA_project_work_order__c pwo = [Select Id,pkl_Status__c from CPA_project_work_order__c where Id=:objCR2.CPA_Project_Work_Order__c];
			Blob bBlob6 = Blob.valueOf('Entity Type,Entity Name,Role,Location,Resource Level,Rate,Cost Name,Year,Month,Effort (Man Days),Expense\n1,1,Senior SME,USA,8,191,1,2015,Sep,21,1');
			Attachment attachment6 = new Attachment();
			attachment6.ParentId = objCR2.ID;
			attachment6.Name = 'Commercial for CR.csv';
			attachment6.ContentType = 'application/vnd.ms-excel';
			attachment6.Body = bBlob6;
			//insert(attachment6);
			listAttachment.add(attachment6);
		
		CPA_Commercial_Details__c obj9 = new CPA_Commercial_Details__c();
		obj9.CR__c = objCR2.id;
		insert  obj9;
		
			
			
			Blob bBlob18 = Blob.valueOf('Test');
			Attachment attachment7 = new Attachment();
			attachment7.ParentId = objCR2.ID;
			attachment7.Name = 'CR RentReceipt.pdf.pdf';
			attachment7.ContentType = 'application/pdf';
			attachment7.Body = bBlob18;
		   
			listAttachment.add(attachment7);
			
			List <Attachment> lstDel = new List<Attachment>();
			lstDel.add(attachment7);
			
			List <Attachment> lstDel2 = new List<Attachment>();
			lstDel2.add(attachment6);
			List <Attachment> lstDel3 = new List<Attachment>();
			lstDel2.add(attachment78);
			
			List <Attachment> lstDel1 = new List<Attachment>();
			lstDel1.add( attachment17);
			
		   insert listAttachment;
			objCR1.pkl_Status__c = 'Submitted';
			Update objCR1;
			objCR2.pkl_Status__c = 'Submitted';
			Update objCR2;
			
        	CPA_AttchemntUnit.ReadFile(attachment78);
        system.debug('attachment78.ParentId--->'+attachment78.ParentId);
        system.debug('attachment78-->'+attachment78);
        CPA_AttchemntUnit.ReadFile(attachment6);
        system.debug('attachment6-->'+attachment6);
        
			CPA_AttchemntUnit.deleteContract(lstDel);
			CPA_AttchemntUnit.deleteContract(lstDel1);
    
			CPA_AttchemntUnit.deleteCommericalData(lstDel2);
			CPA_AttchemntUnit.deleteCommericalData(lstDel3); 
			
			
        
    }
}