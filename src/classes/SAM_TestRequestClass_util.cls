/**********************************************************************
Name: SAM_TestRequestClass_util()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This is the util class of test of the test classes.
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR       DATE            DETAIL Description
1.0      Pooja Kanani   28/07/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class SAM_TestRequestClass_util {
    
    /*******************************************************************
    Purpose: This method is used to create test data for SAM_Request__c
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static SAM_Request__c SAM_Request(){
        RecordType rt =[select id,Name from RecordType where sObjectType='SAM_Request__c' AND Name='Project' limit 1] ;
        SAM_Request__c reqRec = new SAM_Request__c();
        reqRec.txt_Deployments_Any_other_please_specify__c = SAM_Constants.TEST;
        reqRec.txt_Other_Landscape_Details__c = SAM_Constants.TEST;
        reqRec.mpkl_Cloud_Platforms__c = 'Amazon';
        reqRec.pkl_Deployments__c = 'On-premise';
        reqRec.eml_Financial_Manager_Email__c = SAM_Constants.TEST_EMAIL ;
        reqRec.txt_Financial_Manager_Name__c = SAM_Constants.TEST;
        reqRec.date_Go_Live_Date__c = system.today();
        reqRec.pkl_SAAS_Yes_No__c = SAM_Constants.No;
        reqRec.txt_SA_Clarity_Id__c = SAM_Constants.TEST;
        reqRec.pkl_Any_infrastructural_requirements__c = SAM_Constants.No;
        reqRec.eml_Infrastructure_Manager_Email__c = SAM_Constants.TEST_EMAIL ;
        reqRec.txt_Infrastructure_Manager_Name__c = SAM_Constants.TEST;
        reqRec.mpkl_Landscape_Details__c = 'Cordillera';
        reqRec.txt_Master_Clarity_Id__c = SAM_Constants.TEST;
        reqRec.txt_Scope_of_the_Project__c = SAM_Constants.TEST;
        reqRec.txt_Name_of_the_Project__c = SAM_Constants.TEST;
        reqRec.num_No_of_Users__c = 2;
        reqRec.txt_Portfolio__c = SAM_Constants.TEST;
        reqRec.eml_Portfolio_Manager_Email__c = SAM_Constants.TEST_EMAIL ;
        reqRec.txt_Portfolio_Manager_Name__c = SAM_Constants.TEST;
        reqRec.eml_Program_Owner_Email__c = SAM_Constants.TEST_EMAIL ;
        reqRec.txt_Program_Owner_Name__c = SAM_Constants.TEST;
        reqRec.mpkl_Country_of_Deployment__c = 'India';
        reqRec.eml_Project_Manager_Email__c = SAM_Constants.TEST_EMAIL ;
        reqRec.txt_Project_Manager_Name__c = SAM_Constants.TEST;
        reqRec.eml_Project_Technical_Architect_Email__c = SAM_Constants.TEST_EMAIL ;
        reqRec.txt_Project_Technical_Architect_Name__c = SAM_Constants.TEST;
        reqRec.txt_Budget_Owner_Name__c = SAM_Constants.TEST_EMAIL ;
        reqRec.eml_Budget_Owner_Email__c = SAM_Constants.TEST_EMAIL ;  
        reqRec.txt_ICC_GLC_LCC__c = SAM_Constants.TEST;
        reqRec.txt_Cost_Center_CC__c = SAM_Constants.TEST;
        reqRec.txt_CrossCharge_Cost_Code__c = SAM_Constants.TEST;
        reqRec.txt_Entity_Code__c = SAM_Constants.TEST;
        reqRec.txt_GL_Account__c = SAM_Constants.TEST;
        reqRec.txt_Invoice_Approver_Name__c= SAM_Constants.TEST ;
        reqRec.eml_Invoice_Approver_Email__c= SAM_Constants.TEST_EMAIL ;
        reqRec.pkl_Software_Purchase_Req__c = SAM_Constants.YES ;
        reqRec.recordtypeid = rt.id;
        return reqRec;
    }

    /*******************************************************************
    Purpose: This method is used to create Product Details
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static SAM_Request_Line_Item__c createProductDetails (SAM_Request__c objReq){
        RecordType rt =[select id,Name from RecordType where sObjectType='SAM_Request_Line_Item__c' AND Name='IBM' limit 1] ;
        SAM_Request_Line_Item__c objPD = new SAM_Request_Line_Item__c();
        objPD.Name= rt.name;
        objPD.recordtypeid = rt.id;
        objPD.txt_Publisher__c = SAM_Constants.TEST;
        objPD.md_Request_ID__c = objReq.id; 
        return objPD;
    }
    /*******************************************************************
    Purpose: This method is used to create Quotation Details
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static SAM_Quote_Line_Item__c createQuotationDetails (SAM_Request__c objReq){
        RecordType rt =[select id,Name from RecordType where sObjectType='SAM_Quote_Line_Item__c' AND Name='SAM Quote RW' limit 1] ;
        SAM_Quote_Line_Item__c objQD = new SAM_Quote_Line_Item__c();
        objQD.Name= rt.name;
        objQD.recordtypeid = rt.id;
        objQD.pkl_Charging_Type__c = 'Cross Charge Applicable (X)';
        objQD.md_Request__c = objReq.id;
        objQD.pkl_Build_Details_Applicable__c = SAM_Constants.YES;
        objQD.pkl_DO_PO_Details_Applicable__c = SAM_Constants.NO;
        objQD.pkl_Run_Cost_Applicable__c = SAM_Constants.NO;
        objQD.pkl_Line_Status__c = 'Completed';
        return objQD;
    }
    /*******************************************************************
    Purpose: This method is used to create attachment
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
   public static void  addBuild_DetailsAttachmentToParent(Id parentId) {  
    Blob b = Blob.valueOf('Test Data');  
      
    Attachment attachment = new Attachment();  
    attachment.ParentId = parentId;  
    attachment.Name = 'Build_Details';  
    attachment.Body = b;  
      
    insert (attachment);   
}  
    /*******************************************************************
    Purpose: This method is used to create attachment
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
   public static void addApproval_EmailsAttachmentToParent(Id parentId) {  
    Blob b = Blob.valueOf('Test Data');  
      
    Attachment attachment = new Attachment();  
    attachment.ParentId = parentId;  
    attachment.Name = 'Approval_Emails';  
    attachment.Body = b;  
      
    insert (attachment); 
}  
}