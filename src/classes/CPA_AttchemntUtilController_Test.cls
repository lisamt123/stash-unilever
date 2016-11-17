/**********************************************************************
Name: CPA_AttchemntUtilController_Test()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This is the test class for attachment functionality
-------
======================================================
======================================================
History : AC.08.12.01, AC.10.07.03
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       01/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest 
public class CPA_AttchemntUtilController_Test { 
    public static final String  BLOBDATA = 'Entity Type,Entity Name,Role,Location,Resource Level,Rate,Cost Name,Year,Month,Effort (Man Days),Expense\n1,1,Senior SME,USA,8,191,1,2015,Sep,21,1';
    /*******************************************************************
    Purpose: This method covers attachment functionality
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void CPA_AttchemntUtilController_Test() {   
        CPA_PWORF__c objPworf14 = CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPworf14;
        objPworf14.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
        update objPworf14;
        
        CPA_Trigger_Pattern__c ATTACHMENTTRIGERNAME = CPA_testCustomSettingClass_util.createTest_AfterAttachmentTriggerPattern();
        insert ATTACHMENTTRIGERNAME;
        
        List<Attachment>  listAttachment = new List<Attachment>();             
        CPA_LOI__c objLOI =CPA_testContractClass.createLOI (objPworf14);
        insert  objLOI;
        objLOI.pkl_Status__c =CPA_ConstantsForContractingAppClasses.SUBMITTED;
        update objLOI;
        Blob bBlob5 = Blob.valueOf(CPA_ConstantsForContractingAppClasses.TEST);
        Attachment attachment5 = new Attachment();
        attachment5.ParentId = objLOI.ID;
        attachment5.Name = CPA_ConstantsForContractingAppClasses.LOIFILENAME;//'LOI RentReceipt.pdf.pdf'
        attachment5.ContentType = CPA_ConstantsForContractingAppClasses.APPLICATIONPDF;
        attachment5.Body = bBlob5;
       
        listAttachment.add(attachment5);
        
        CPA_project_work_order__c objPWO = CPA_testContractClass.createPWO(objPworf14);
        insert objPWO;

        Blob bBlob = Blob.valueOf(BLOBDATA);
        Attachment attachment = new Attachment();
        attachment.ParentId = objPWO.ID;
        attachment.Name = CPA_ConstantsForContractingAppClasses.COMMERCIALPWOCSV;//'Commercial for PWO.csv'
        attachment.ContentType = CPA_ConstantsForContractingAppClasses.APPLICATIONEXCEL;
        attachment.Body = bBlob;
        
        listAttachment.add(attachment);
        
        Blob bBlob1 = Blob.valueOf(CPA_ConstantsForContractingAppClasses.TEST);
        Attachment attachment1 = new Attachment();
        attachment1.ParentId = objPWO.ID;
        attachment1.Name = CPA_ConstantsForContractingAppClasses.PWOPDFFILENAME;
        attachment1.ContentType = CPA_ConstantsForContractingAppClasses.APPLICATIONPDF;
        attachment1.Body = bBlob1;
      
        listAttachment.add(attachment1);

        objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ACCEPTED;
        update objPWO;    
         
        CPA_Commercial_Details__c obj1 = new CPA_Commercial_Details__c();
        obj1.Project_Work_Order__c = objPWO.id;
        insert  obj1;    

        CPA_CR__c objCR = CPA_testContractClass.createCR(objPWO);
        insert objCR;
        //CPA_project_work_order__c pwo = [Select Id,pkl_Status__c from CPA_project_work_order__c where Id=:objCR.CPA_Project_Work_Order__c];
        Blob bBlob2 = Blob.valueOf(BLOBDATA);
        Attachment attachment2 = new Attachment();
        attachment2.ParentId = objCR.ID;
        attachment2.Name = CPA_ConstantsForContractingAppClasses.COMMERCIALCRCSV;
        attachment2.ContentType = CPA_ConstantsForContractingAppClasses.APPLICATIONEXCEL;
        attachment2.Body = bBlob2;
       
        listAttachment.add(attachment2);
    
        CPA_Commercial_Details__c obj = new CPA_Commercial_Details__c();
        obj.CR__c = objCR.id;
        insert  obj;
    
        Blob bBlob13 = Blob.valueOf(CPA_ConstantsForContractingAppClasses.TEST);
        Attachment attachment3 = new Attachment();
        attachment3.ParentId = objCR.ID;
        attachment3.Name = CPA_ConstantsForContractingAppClasses.CRPDFFILENAME;
        attachment3.ContentType = CPA_ConstantsForContractingAppClasses.APPLICATIONPDF;
        attachment3.Body = bBlob13;
       
        listAttachment.add(attachment3);
        Test.startTest();
            insert listAttachment;
            List<Attachment> listLOi = [Select Id,ParentId from Attachment where ParentId=:objLOI.Id];
            listLOi.add(attachment5);
            CPA_LOI__c objLOICheck = [Select Id,chk_Contract_Attached__c from CPA_LOI__c where Id = : objLOI.Id ];
            CPA_project_work_order__c objPWOCheck = [Select Id,chk_Excel_Attached__c,chk_PDF_Attached__c from CPA_project_work_order__c where id=: objPWO.id];
            CPA_CR__c objCRChek = [Select Id,chk_Contract_Excel_Attached__c,chk_Contract_Attached__c from CPA_CR__c where id =:objCR.id];
           
            System.Assert(CPA_ConstantsForContractingAppClasses.APPLICATIONPDF == attachment3.ContentType);
            System.Assert(CPA_ConstantsForContractingAppClasses.APPLICATIONEXCEL == attachment2.ContentType);
            CPA_AttachmentUtil.updateLOI(listLOi);
            CPA_AttachmentUtil.DeleteLOI(listLOi);
                   
           // CPA_AttachmentUtil.deleteCommericalData(listLOi);
        Test.stopTest();
        
        System.Assert(objLOICheck.chk_Contract_Attached__c);
        System.Assert(objPWOCheck.chk_Excel_Attached__c);
        System.Assert(objPWOCheck.chk_PDF_Attached__c);
        
        
        System.Assert(objCRChek.chk_Contract_Excel_Attached__c);
        System.Assert(objCRChek.chk_Contract_Attached__c);
        
        System.Assert(CPA_ConstantsForContractingAppClasses.APPLICATIONPDF == attachment3.ContentType);
        System.Assert(CPA_ConstantsForContractingAppClasses.APPLICATIONEXCEL == attachment2.ContentType);
    }
    /*******************************************************************
    Purpose: This method covers attachment util functionality
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void Test_CPA_AttchemntUtil1() { 
    //*---------------------------------------------------------------*//
       CPA_PWORF__c objPworf15 = CPA_testPWORFClass_util.createTest_other_PWORF();
            insert objPworf15;
            objPworf15.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
            update objPworf15;
         
            List<Attachment>  listAttachment = new List<Attachment>();             
            
            CPA_project_work_order__c objPWO151 = CPA_testContractClass.createPWO(objPworf15);
            insert objPWO151;
            
            Blob bBlob11 = Blob.valueOf(BLOBDATA);
            Attachment attachment78 = new Attachment();
            CPA_project_work_order__c obj = [Select Id from CPA_project_work_order__c where Id =: objPWO151.Id];
            attachment78.ParentId = obj.ID;
            attachment78.Name = CPA_ConstantsForContractingAppClasses.COMMERCIALPWOCSV;
            attachment78.ContentType = CPA_ConstantsForContractingAppClasses.APPLICATIONEXCEL;
            attachment78.Body = bBlob11;
            insert(attachment78);
            
          
            Blob bBlob12 = Blob.valueOf(CPA_ConstantsForContractingAppClasses.TEST);
            Attachment attachment17 = new Attachment();
            attachment17.ParentId = objPWO151.ID;
            attachment17.Name = CPA_ConstantsForContractingAppClasses.PWOPDFFILENAME;
            attachment17.ContentType = CPA_ConstantsForContractingAppClasses.APPLICATIONPDF;
            attachment17.Body = bBlob12;
           // insert(attachment1);
            listAttachment.add(attachment17);

            objPWO151.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ACCEPTED;
            update objPWO151;    
            CPA_Commercial_Details__c obj15 = new CPA_Commercial_Details__c();
            obj15.Project_Work_Order__c = objPWO151.id;
            insert  obj15;    
            
            CPA_CR__c objCR1 = CPA_testContractClass.createCR(objPWO151);
            insert objCR1;
            //CPA_project_work_order__c pwo12 = [Select Id,pkl_Status__c from CPA_project_work_order__c where Id=:objCR1.CPA_Project_Work_Order__c];
            //objCR1.CPA_project_work_order__c = pwo12.id;
            Blob bBlob21 = Blob.valueOf(BLOBDATA);
            Attachment attachment21 = new Attachment();
            attachment21.ParentId = objCR1.ID;
            attachment21.Name = CPA_ConstantsForContractingAppClasses.COMMERCIALCRCSV;
            attachment21.ContentType = CPA_ConstantsForContractingAppClasses.APPLICATIONEXCEL;
            attachment21.Body = bBlob21;
            //insert(attachment2);
            listAttachment.add(attachment21);
        
            CPA_Commercial_Details__c obj11 = new CPA_Commercial_Details__c();
            obj11.CR__c = objCR1.id;
            insert  obj11;
    
            Blob bBlob131 = Blob.valueOf(CPA_ConstantsForContractingAppClasses.TEST);
            Attachment attachment31 = new Attachment();
            attachment31.ParentId = objCR1.ID;
            attachment31.Name = CPA_ConstantsForContractingAppClasses.CRPDFFILENAME;
            attachment31.ContentType = CPA_ConstantsForContractingAppClasses.APPLICATIONPDF;
            attachment31.Body = bBlob131;
          
            listAttachment.add(attachment31);
            
            System.Assert(CPA_ConstantsForContractingAppClasses.APPLICATIONPDF == attachment31.ContentType);
            CPA_CR__c objCR2 = CPA_testContractClass.createCR(objPWO151);
            insert objCR2;
            //CPA_project_work_order__c pwo = [Select Id,pkl_Status__c from CPA_project_work_order__c where Id=:objCR2.CPA_Project_Work_Order__c];
            Blob bBlob6 = Blob.valueOf(BLOBDATA);
            Attachment attachment6 = new Attachment();
            attachment6.ParentId = objCR2.ID;
            attachment6.Name = CPA_ConstantsForContractingAppClasses.COMMERCIALCRCSV;
            attachment6.ContentType = CPA_ConstantsForContractingAppClasses.APPLICATIONEXCEL;
            attachment6.Body = bBlob6;
            
            listAttachment.add(attachment6);
        
            CPA_Commercial_Details__c obj9 = new CPA_Commercial_Details__c();
            obj9.CR__c = objCR2.id;
            insert  obj9;
            
            Blob bBlob18 = Blob.valueOf(CPA_ConstantsForContractingAppClasses.TEST);
            Attachment attachment7 = new Attachment();
            attachment7.ParentId = objCR2.ID;
            attachment7.Name = CPA_ConstantsForContractingAppClasses.CRPDFFILENAME;
            attachment7.ContentType = CPA_ConstantsForContractingAppClasses.APPLICATIONPDF;
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
            objCR1.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            Update objCR1;
            objCR2.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SUBMITTED;
            Update objCR2;
        Test.startTest();
            CPA_AttachmentUtil.ReadFile(attachment78);
            CPA_AttachmentUtil.ReadFile(attachment6);
            
            CPA_project_work_order__c objPWOCheck1 = [Select Id,chk_Excel_Attached__c,chk_PDF_Attached__c from CPA_project_work_order__c where id=: obj.id];
            CPA_CR__c objCRChek1 = [Select Id,chk_Contract_Excel_Attached__c,chk_Contract_Attached__c from CPA_CR__c where id =:objCR2.id];            
            System.Assert(objPWOCheck1.chk_Excel_Attached__c);  // Attachement is there so Check box will be check
            System.Assert(!objCRChek1.chk_Contract_Excel_Attached__c); // Attachement is there so Check box will be check
           
           
           CPA_AttachmentUtil.deleteContract(lstDel);
            CPA_AttachmentUtil.deleteContract(lstDel1);     // It's Delete the attachment Contact file
    
            CPA_AttachmentUtil.deleteCommericalData(lstDel2); // It's Delete the attachment Commercial cover
             delete lstDel3;                                    // Attachment deleted which neither contract not commercial
           
           /* delete lstDel;
            delete lstDel1;
            delete lstDel2;*/
            delete lstDel3;
        Test.stopTest();

            CPA_project_work_order__c objPWOCheck = [Select Id,chk_Excel_Attached__c,chk_PDF_Attached__c from CPA_project_work_order__c where id=: obj.id];
            CPA_CR__c objCRChek = [Select Id,chk_Contract_Excel_Attached__c,chk_Contract_Attached__c from CPA_CR__c where id =:objCR2.id];            
            System.Assert(objPWOCheck.chk_Excel_Attached__c);  // Attachement is deleted so Check box will be uncheck
            System.Assert(!objCRChek.chk_Contract_Excel_Attached__c); // Attachement is deleted so Check box will be uncheck
            
            
    }
    
     /*******************************************************************
    Purpose: This method covers attachment commercial util functionality
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void Test_CPA_AttchemntCommerical_util() { 
    //*---------------------------------------------------------------*//
    //CPA_AttchemntCommerical_util  objCPA_AttchemntCommerical_util  = new CPA_AttchemntCommerical_util();
    CPA_project_work_order__c cpaobj = new CPA_project_work_order__c();
    CPA_CR__c cpaobj1 = new CPA_CR__c();
  
    
     Test.startTest();
     cpaobj =CPA_AttchemntCommerical_util.CommericalDataBlankPWO(cpaobj);
     cpaobj1 =CPA_AttchemntCommerical_util.CommericalDataBlankCR(cpaobj1);
     system.assert(!cpaobj.chk_Excel_Attached__c);
     system.assertEquals(NULL,cpaobj.num_Expense_charges_of_work_order__c);
     system.assert(!cpaobj1.chk_Contract_Excel_Attached__c );
     system.assertEquals(NULL,cpaobj1.num_Estimated_Man_days_of_CR__c);
     Test.stopTest();
    
    
    
    }
    
    
    static testmethod void CPA_AttchemntUtilController_DeleteTest() {   
        CPA_PWORF__c objPWORF= CPA_testPWORFClass_util.createTest_other_PWORF();
        insert objPWORF;
        objPWORF.pkl_Status__c = CPA_ConstantsForContractingAppClasses.ANSWERED;
        update objPWORF;
        
        
        CPA_Trigger_Pattern__c ATTACHMENTTRIGERNAME = CPA_testCustomSettingClass_util.createTest_AfterAttachmentTriggerPattern();
        insert ATTACHMENTTRIGERNAME;
        
        List<Attachment>  listAttachment = new List<Attachment>();             
        
               
       // CPA_project_work_order__c objPWO = CPA_testContractClass.createPWO(14);
        CPA_project_work_order__c objPwo = new CPA_project_work_order__c();
        User testUSer = createTestUser();
        
        CPA_Requirements_and_Deliverables__c objRaD = CPA_testPWORFClass_util.createRequirementsDeliverables(objPWORF);
        insert objRaD;
        CPA_Risk_Assessment_and_Mitigation__c objRAM = CPA_testPWORFClass_util.createRiskAssessment(objPWORF);
        insert objRAM;
        CPA_Key_Contacts__c objKCs = CPA_testPWORFClass_util.CreateKeyContacts(objPWORF);
        insert objKCs;
        
        /*objPWORF.pkl_Status__c = 'Submitted';
        update  objPWORF;*/
       // objPWORF.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SAVED;
       // update  objPWORF;
        
        objPwo.txt_Accenture_Project_Manager__c = CPA_ConstantsForContractingAppClasses.TEST;
        objPwo.num_Authorisation_charges__c = 100;
        objPwo.num_Authorisation_man_days__c = 100;
        objPwo.pkl_Billing_Details__c = 'Unilever Europe';
        objPwo.Comments__c = CPA_ConstantsForContractingAppClasses.TEST;
        objPwo.Currency__c = 'EUR';
        objPwo.num_Estimated_Man_days_of_PWO__c = 10;
        objPwo.pec_Estimated_Off_shore__c = 1;
        objPwo.pec_Estimated_On_shore__c=1;
        objPwo.num_Estimated_Value_of_PWO__c =10;
        objPwo.pec_Expense__c =1;
        objPwo.num_Expense_charges_of_work_order__c=10;
        
        objPwo.num_ITC_resources_man_days__c = 10;
        objPwo.num_On_shore_senior_resources_man_days__c  =10;
        objPwo.txt_Previous_Status_Value__c='sdkj';
        objPwo.pkl_Pricing_Model__c = 'Fixed Price';
        objPwo.mpkl_Project_Classification__c = 'Complex';
        objPwo.mpkl_Project_Phases__c = CPA_ConstantsForContractingAppClasses.PLAN_ANALYSE;
        objPwo.txt_PWO_number__c = 'PWO-001';
        objPwo.PWORF_ID__c = objPWORF.Id;
        objPwo.txt_PWO_title__c = 'Titke';
        objPwo.pkl_Region__c = CPA_ConstantsForContractingAppClasses.EUROPE;
        objPwo.num_RMS_value__c = 1;
        objPwo.num_Senior_resources_man_days__c=1;
        objPwo.num_Target_Blend_Rate__c = 1;
        objPwo.num_Total_work_order_charge__c =1;
        objPwo.mpkl_Unilever_Innovation_Area__c = 'HR';
        objPwo.txt_Unilever_Project_Name__c = CPA_ConstantsForContractingAppClasses.TEST;
        objPwo.txt_Unilever_Reference__c = 'Uni';
        objPwo.pec_Variance__c =1;
        objPwo.num_Varied_Target_Blend_Rate__c = 1;
        objPwo.dt_Date_PWORF_accepted__c = system.Today();
        objPwo.dt_Project_Initiation_Date__c = system.today();
        objPwo.dt_Expected_Start_Date__c = system.today();
        objPwo.dt_Expected_End_date__c = system.today();
        objPWO.lkp_Unilever_budget_approver__c = testUSer.Id;
        objPWO.lkp_Unilever_content_approver__c =testUSer.Id;
        objPWO.lkp_Unilever_Finance_BP_Contact__c = testUSer.Id;
       // objPWO.pkl_Status__c=CPA_ConstantsForContractingAppClasses.SAVED;
        insert objPWO;
        
        

        Blob bBlob = Blob.valueOf(BLOBDATA);
        Attachment attachment = new Attachment();
        attachment.ParentId = objPWO.ID;
        attachment.Name = CPA_ConstantsForContractingAppClasses.COMMERCIALPWOCSV;//'Commercial for PWO.csv'
        attachment.ContentType = CPA_ConstantsForContractingAppClasses.APPLICATIONEXCEL;
        attachment.Body = bBlob;
        
        listAttachment.add(attachment);
        
        Blob bBlob1 = Blob.valueOf(CPA_ConstantsForContractingAppClasses.TEST);
        Attachment attachment1 = new Attachment();
        attachment1.ParentId = objPWO.ID;
        attachment1.Name = CPA_ConstantsForContractingAppClasses.PWOPDFFILENAME;
        attachment1.ContentType = CPA_ConstantsForContractingAppClasses.APPLICATIONPDF;
        attachment1.Body = bBlob1;
      
        listAttachment.add(attachment1);
        
       /*CPA_project_work_order__c objPWOCheck1 = [Select Id,chk_Excel_Attached__c,chk_PDF_Attached__c from CPA_project_work_order__c where id=: objPWO.id];
        objPWOCheck1 .pkl_Status__c = CPA_ConstantsForContractingAppClasses.SAVED;
        update objPWOCheck1;  */   

        objPWO.pkl_Status__c = CPA_ConstantsForContractingAppClasses.SAVED;
        update objPWO;    
         
        CPA_Commercial_Details__c obj1 = new CPA_Commercial_Details__c();
        obj1.Project_Work_Order__c = objPWO.id;
        insert  obj1;    
       
        Test.startTest();
            insert listAttachment;
           
            CPA_project_work_order__c objPWOCheck = [Select Id,chk_Excel_Attached__c,chk_PDF_Attached__c from CPA_project_work_order__c where id=: objPWO.id];
           
           
           // System.Assert(CPA_ConstantsForContractingAppClasses.APPLICATIONPDF == attachment3.ContentType);
           // System.Assert(CPA_ConstantsForContractingAppClasses.APPLICATIONEXCEL == attachment2.ContentType);
           
           
           DELETE listAttachment;
        Test.stopTest();
        
  
        System.Assert(objPWOCheck.chk_Excel_Attached__c);
        System.Assert(objPWOCheck.chk_PDF_Attached__c);
        
        
       // System.Assert(objCRChek.chk_Contract_Excel_Attached__c);
        //System.Assert(objCRChek.chk_Contract_Attached__c);
        
       // System.Assert(CPA_ConstantsForContractingAppClasses.APPLICATIONPDF == attachment3.ContentType);
       // System.Assert(CPA_ConstantsForContractingAppClasses.APPLICATIONEXCEL == attachment2.ContentType);
    }
    
    public static User createTestUser (){
        //User testUser; - commented as this variable not used anywhere, just initialized on line number 7, but returning testUser1
        Profile p = [select id from profile where name='system Administrator'];
        
        //testUser = new User(alias = 'u1', email='u1@unilever.com',
        //emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        //localesidkey='en_US', profileid = p.Id, country='United States',
        //timezonesidkey='America/Los_Angeles', username='u1@unilever.com');
        User testUser1 = [Select Id,profileid,isactive from user where profileid  =: p.Id AND isactive = true limit 1];
        return testUser1;
    
    }

    
}