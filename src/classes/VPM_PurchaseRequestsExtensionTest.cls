@isTest 
private class VPM_PurchaseRequestsExtensionTest{
 static testMethod void checkForUserTestMethod() {
  
 // map<string,string> userRole =new map<string,string>();
    VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = 'PH01';
    companyCode.ECC__c = 'U2K2';
    companyCode.VPM_Country__c ='Algeria';
    insert companyCode;
    system.assert(companyCode.Id!=null,'Error');
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c='Algeria',
    VPM_CompanyCode__c=companyCode.id,
    VPM_WhatAreYouBuying__c='test',
    VPM_Comments__c='test',
    VPM_Country__c='IE_Ireland',
    VPM_VendorPhone__c='1234567895',
    VPM_IsVendorSME__c ='No');
     insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_IsVendorSME__c,VPM_Country__c,VPM_Comments__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c from VPM_PurchasingRequests__c where id=:pur.Id ];
       
       system.assertEquals(pur.Id,pur1.Id);
      ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
      VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
      vendorDetail.isProcure =true;
      vendorDetail.setPaymentTermsDefaultValues();
      
  
 }
    static testMethod void callSendToSAPAPITest() {
   
   string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id; 
   
    List<mdm_Vendors__c> vendorList = new List<mdm_Vendors__c>();
    mdm_Vendors__c vendor = new mdm_Vendors__c();
    vendor.mdm_Code__c = '5001010';
    vendor.mdm_City__c = 'Andorra';
    vendor.mdm_Country__c ='DZ_Algeria';
    vendor.mdm_Name1__c ='Test Sirius';
    vendor.mdm_Street__c = 'Test Street';
    vendor.mdm_Postcode__c = '54132';
    vendor.mdm_Country__c = 'India';
    vendor.mdm_ID__c = '1234';
    vendor.mdm_vCodeFusion__c='5001010';
    vendor.mdm_vCodeCordillera__c='5001010';
    vendor.mdm_vCodeSirius__c='5001010';
    vendor.mdm_vCodeU2K2__c='5001010';
    vendorList.add(vendor);
    insert vendorList;
    system.debug('@@vendorList' + vendorList);
    system.assert(vendor.Id!=null,'Error');
    
    
    VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = 'PH01';
    companyCode.ECC__c = 'U2K2';
    companyCode.VPM_Country__c ='Algeria';
    insert companyCode;
    system.assert(companyCode.Id!=null,'Error');
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c='Algeria',
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c='test',
    VPM_Comments__c='test',
    VPM_VendorCodeLookup__c = vendorList[0].id,
    //recordTypeId=recordTypeId,
    VPM_VendorPhone__c='1234567895');
     insert pur;
        pur.recordTypeId = recordTypeId;
        update pur;
         VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_Comments__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_VendorCodeLookup__c,recordTypeId from VPM_PurchasingRequests__c where id=:pur.Id ];
       
       system.assertEquals(pur.Id,pur1.Id);
              ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
  VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
        VendorDetail.vendorReqId= pur.id;
        VendorDetail.callSendToSAPAPI();
        
        recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Maintain)'].Id; 
        pur.recordTypeId = recordTypeId;
       // pur.VPM_Fieldtype__c ='Regional';
        pur.VPM_PaymentTerms__c ='02D_Within 2 days Due net (2NET)';
        pur.VPM_fieldUpdated__c ='VPM_PaymentTerms__c';
        update pur;
             // ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
  //VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
        VendorDetail.vendorReqId= pur.id;
        VendorDetail.callSendToSAPAPI();
        
                recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Extend)'].Id; 
        pur.recordTypeId = recordTypeId;
        update pur;
              //ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
  //VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
        VendorDetail.vendorReqId= pur.id;
        VendorDetail.callSendToSAPAPI();
        

    }
     static testMethod void reworkActionTest() {
    
    VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = 'PH01';
    companyCode.ECC__c = 'U2K2';
    companyCode.VPM_Country__c ='Algeria';
    insert companyCode;
    system.assert(companyCode.Id!=null,'Error');
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c='Algeria',
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c='test',
    VPM_Comments__c='test',
    VPM_VendorPhone__c='1234567895');
    insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       
       system.assertEquals(pur.Id,pur1.Id);
          ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
         VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
         pur.VPM_RequestLastWithGroup__c ='Business Requestor';
         pur.VPM_Status__c ='FLS Review';
         update pur;
         VendorDetail.ReworkAction();
         pur.VPM_Status__c = 'Approval Pending';
         pur.VPM_ProcurementApprovalRequired__c=true;
         pur.VPM_FinanceApprovalRequired__c = true;
         update pur;
         VendorDetail.ReworkAction();
         
         pur.VPM_ProcurementApprovalRequired__c=false;
         pur.VPM_FinanceApprovalRequired__c = true;
         update pur;
         VendorDetail.ReworkAction();
         pur.VPM_ProcurementApprovalRequired__c=true;
         pur.VPM_FinanceApprovalRequired__c = false;
         update pur;
         VendorDetail.ReworkAction();
         
          pur.VPM_RequestLastWithGroup__c ='FLS';
         pur.VPM_Status__c = 'Approval Pending';
         pur.VPM_ProcurementApprovalRequired__c=true;
         pur.VPM_FinanceApprovalRequired__c = true;
         update pur;
         VendorDetail.ReworkAction();
         
         pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=false;
          pur.VPM_RussianTaxApprovalRequired__c=false;
          pur.VPM_FinanceApprovalRequired__c =true;
          pur.VPM_status__c='Approval Pending';
          pur.VPM_RequestLastWithGroup__c = 'FLS';
          update pur;
          VendorDetail.ReworkAction();
          
          pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=false;
          pur.VPM_RussianTaxApprovalRequired__c=true;
          pur.VPM_FinanceApprovalRequired__c =true;
          pur.VPM_status__c='Approval Pending';
          pur.VPM_RequestLastWithGroup__c = 'FLS';
          update pur;
          VendorDetail.ReworkAction();
          
          pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=true;
          pur.VPM_RussianTaxApprovalRequired__c=false;
          pur.VPM_FinanceApprovalRequired__c =false;
          pur.VPM_status__c='Approval Pending';
          pur.VPM_RequestLastWithGroup__c = 'FLS';
          update pur;
          VendorDetail.ReworkAction();
          
          pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=false;
          pur.VPM_RussianTaxApprovalRequired__c=true;
          pur.VPM_FinanceApprovalRequired__c =false;
          pur.VPM_status__c='Approval Pending';
          pur.VPM_RequestLastWithGroup__c = 'Business Requestor';
          update pur;
          VendorDetail.ReworkAction();
          
          pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=true;
          pur.VPM_RussianTaxApprovalRequired__c=false;
          pur.VPM_FinanceApprovalRequired__c =false;
          pur.VPM_status__c='Approval Pending';
          pur.VPM_RequestLastWithGroup__c = 'Business Requestor';
          update pur;
          VendorDetail.ReworkAction();
          
          pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=false;
          pur.VPM_RussianTaxApprovalRequired__c=true;
          pur.VPM_FinanceApprovalRequired__c =false;
          pur.VPM_BankDataValidationRequired__c = false;
          pur.VPM_status__c='Approval Pending';
          pur.VPM_RequestLastWithGroup__c = 'FLS';
          update pur;
          VendorDetail.ReworkAction();
          
          pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=true;
          pur.VPM_RussianTaxApprovalRequired__c=false;
          pur.VPM_FinanceApprovalRequired__c =true;
          pur.VPM_BankDataValidationRequired__c = false;
          pur.VPM_status__c='Approval Pending';
          pur.VPM_RequestLastWithGroup__c = 'FLS';
          update pur;
          VendorDetail.ReworkAction();
          
          pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=true;
          pur.VPM_RussianTaxApprovalRequired__c=false;
          pur.VPM_FinanceApprovalRequired__c =true;
          pur.VPM_BankDataValidationRequired__c = false;
          pur.VPM_status__c='Approval Pending';
          pur.VPM_RequestLastWithGroup__c = 'Business Requestor';
          update pur;
          VendorDetail.ReworkAction();
          
          pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=false;
          pur.VPM_RussianTaxApprovalRequired__c=false;
          pur.VPM_FinanceApprovalRequired__c =false;
          pur.VPM_BankDataValidationRequired__c = true;
          pur.VPM_status__c='Approval Pending';
          pur.VPM_RequestLastWithGroup__c = 'FLS';
          update pur;
          VendorDetail.ReworkAction();
          
          pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=false;
          pur.VPM_RussianTaxApprovalRequired__c=false;
          pur.VPM_FinanceApprovalRequired__c =false;
          pur.VPM_BankDataValidationRequired__c = true;
          pur.VPM_status__c='Approval Pending';
          pur.VPM_RequestLastWithGroup__c = 'Business Requestor';
          update pur;
          VendorDetail.ReworkAction();
          
          vendorDetail.cancelFromUser();
          vendorDetail.saveFromUser();
          
       
  
     }
    static testMethod void ManuallyMarkAsCompleteActionTest()
    {
        map<string,string> userRole =new map<string,string>();
    VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = 'PH01';
    companyCode.ECC__c = 'U2K2';
    companyCode.VPM_Country__c ='Algeria';
    insert companyCode;
    system.assert(companyCode.Id!=null,'Error');
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c='Algeria',
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c='test',
    VPM_Comments__c='test',
    VPM_VendorPhone__c='1234567895',
    VPM_DeletionBlockFlag__c='Block',
    VPM_Status__c ='MDM Ops Review - Block');
     insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_DeletionBlockFlag__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       
       system.assertEquals(pur.Id,pur1.Id);
      ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
      VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
        VendorDetail.ManuallyMarkAsCompleteAction();
        
        
        
    }
    static testMethod void SubmitRequestActionTest()
    {
        
    VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = 'PH01';
    companyCode.ECC__c = 'U2K2';
    companyCode.VPM_Country__c ='Algeria';
    insert companyCode;
    system.assert(companyCode.Id!=null,'Error');
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c='Algeria',
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c='test',
    VPM_Comments__c='test',
    VPM_VendorPhone__c='1234567895',
    VPM_Status__c ='Draft Request');
     insert pur;
      ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
      VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
       VendorDetail.SubmitRequestAction();
        pur.VPM_Status__c='FLS Requested Re-Work';
        pur.VPM_Rework__c ='Yes';
        update pur;
         VendorDetail.SubmitRequestAction();
        pur.VPM_Status__c='Procurement Requested Re-Work';
        update pur;
         VendorDetail.SubmitRequestAction();
         pur.VPM_Status__c='Finance Requested Re-Work';
        update pur;
         VendorDetail.SubmitRequestAction();
        pur.VPM_Status__c='FLS Review';
        pur.VPM_Rework__c ='Yes';
        update pur;
         VendorDetail.SubmitRequestAction();
         pur.VPM_Status__c='Russian Custom Tax Requested Re-Work';
        pur.VPM_Rework__c ='Yes';
        update pur;
         VendorDetail.SubmitRequestAction();
         pur.VPM_Status__c='Russian Custom Tax Requested Re-Work';
        pur.VPM_Rework__c ='Yes';
        update pur;
         VendorDetail.SubmitRequestAction();
         pur.VPM_Status__c='Freight Requested Re-Work';
        pur.VPM_Rework__c ='Yes';
        update pur;
         VendorDetail.SubmitRequestAction();
         pur.VPM_Status__c='Bank Data Validation Requested Re-Work';
        pur.VPM_Rework__c ='Yes';
        update pur;
         VendorDetail.SubmitRequestAction();
         
    }
    
    static testMethod void changeButtonValues(){
        string ownerId= [Select Id From User limit 1].Id; 
       
       VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
       companyCode.VPM_CompanyCode__c = 'PH01';
       companyCode.ECC__c = 'U2K2';
       companyCode.VPM_Country__c ='Algeria';
       insert companyCode;
       system.assert(companyCode.Id!=null,'Error');
       
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
        VPM_CountryRequestingVendor__c='Algeria',
        VPM_CompanyCode__c=companyCode.Id,
        VPM_WhatAreYouBuying__c='test',
        VPM_ApprovalWorkerID__c=null,
        VPM_ApprovalWorker__c = null,
        VPM_VendorPhone__c='1234567895',
        OwnerId =ownerId,
        VPM_Status__c ='Draft Request');
     insert pur;
      ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
      VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
       VendorDetail.changeButtonValues();
       VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,OwnerId,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_ApprovalWorkerID__c,VPM_ApprovalWorker__c ,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       
       system.assertEquals(pur.Id,pur1.Id);
      
       pur.VPM_ApprovalWorkerID__c='User';
       update pur;
       
       pur1 = [select VPM_CountryRequestingVendor__c,OwnerId,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_ApprovalWorkerID__c,VPM_ApprovalWorker__c ,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       system.assertEquals(pur.VPM_ApprovalWorkerID__c,pur1.VPM_ApprovalWorkerID__c);
       VendorDetail.changeButtonValues();
       
    }
    
    /*static testMethod void fetchisVenderSMETest(){
    
    VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = 'PH01';
    companyCode.ECC__c = 'Sirius';
    companyCode.VPM_Country__c ='Algeria';
    insert companyCode;
    system.assert(companyCode.Id!=null,'Error');
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
        VPM_CountryRequestingVendor__c='Algeria',
        VPM_CompanyCode__c=companyCode.Id,
        VPM_WhatAreYouBuying__c='test',
        VPM_IsVendorSME__c='Yes',
        VPM_ExceptionType__c= 'E001',
        VPM_VendorPhone__c='1234567895',
        VPM_InternationalVersion__c='International Version',
        VPM_Status__c ='Draft Request');
     insert pur;
      ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
      VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
       VendorDetail.fetchisVenderSME();

    }*/
    
    static testMethod void checkLoggedInUserRole(){
    
     Profile p = [SELECT Id FROM Profile WHERE Name='VPM - No Access'];
     User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',     UserName='testpermissionsetuser@testorg.com');
        insert u;
        
         //for FLS User
        PermissionSet psf = [SELECT Id FROM PermissionSet WHERE Name = 'VPM_FLS'];
       
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psaf = new PermissionSetAssignment();
        psaf.AssigneeId = u.Id;
        psaf.PermissionSetId = psf.Id;
        insert psaf;
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = 'PH01';
    companyCode.ECC__c = 'U2K2';
    companyCode.VPM_Country__c ='Algeria';
    insert companyCode;
    system.assert(companyCode.Id!=null,'Error');
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
        VPM_CountryRequestingVendor__c='Algeria',
        VPM_CompanyCode__c=companyCode.Id,
        VPM_WhatAreYouBuying__c='test',
        VPM_IsVendorSME__c='Yes',
        VPM_ExceptionType__c= 'E001',
        VPM_VendorPhone__c='1234567895',
        VPM_InternationalVersion__c='International Version',
        VPM_Status__c ='Draft Request');
     insert pur;
     
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_IsVendorSME__c,VPM_ExceptionType__c,VPM_VendorPhone__c,VPM_InternationalVersion__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
     system.assertEquals(pur.Id,pur1.Id);
        system.runAs(u){
            ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
            VPM_PurchaseRequestsControllerExtension vendor=new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
            VPM_PurchaseRequestsControllerExtension.checkForBusinessReqUser();
            VPM_PurchaseRequestsControllerExtension.checkLoggedInUserRole();
            vendor.checkUser();
        }
        
        //for MDM User
        
        PermissionSet pm = [SELECT Id FROM PermissionSet WHERE Name = 'VPM_MDM_Ops'];
       
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psam = new PermissionSetAssignment();
        psam.AssigneeId = u.Id;
        psam.PermissionSetId = pm.Id;
        insert psam;
        
        system.runAs(u){
            ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
            VPM_PurchaseRequestsControllerExtension vendor=new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
            VPM_PurchaseRequestsControllerExtension.checkLoggedInUserRole();
            vendor.checkUser();
        }
        //VPM_PurchaseRequestsControllerExtension.checkLoggedInUserRole();
        
        //for Finance User
        PermissionSet psfi = [SELECT Id FROM PermissionSet WHERE Name = 'VPM_Finance'];
       
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psafi = new PermissionSetAssignment();
        psafi.AssigneeId = u.Id;
        psafi.PermissionSetId = psfi.Id;
        insert psafi;
        
        system.runAs(u){
            ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
            VPM_PurchaseRequestsControllerExtension vendor=new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
            VPM_PurchaseRequestsControllerExtension.checkForBusinessReqUser();
            VPM_PurchaseRequestsControllerExtension.checkLoggedInUserRole();
            vendor.checkUser();
        }
        
         //For Procurement User
        PermissionSet psp = [SELECT Id FROM PermissionSet WHERE Name = 'VPM_Procurement'];
       
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psap = new PermissionSetAssignment();
        psap.AssigneeId = u.Id;
        psap.PermissionSetId = psp.Id;
        insert psap;
        
        system.runAs(u){
            ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
            VPM_PurchaseRequestsControllerExtension vendor=new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
            VPM_PurchaseRequestsControllerExtension.checkForBusinessReqUser();
            VPM_PurchaseRequestsControllerExtension.checkLoggedInUserRole();
            vendor.checkUser();
        }
        
        //for Freight user
        PermissionSet psfe = [SELECT Id FROM PermissionSet WHERE Name = 'VPM_Freight'];
       
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psafe = new PermissionSetAssignment();
        psafe.AssigneeId = u.Id;
        psafe.PermissionSetId = psfe.Id;
        insert psafe;
        
       system.runAs(u){
            ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
            VPM_PurchaseRequestsControllerExtension vendor=new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
            VPM_PurchaseRequestsControllerExtension.checkForBusinessReqUser();
            VPM_PurchaseRequestsControllerExtension.checkLoggedInUserRole();
            vendor.checkUser();
        }
        
        //for Russian user
        PermissionSet psr = [SELECT Id FROM PermissionSet WHERE Name = 'VPM_RussianTax'];
       
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psar = new PermissionSetAssignment();
        psar.AssigneeId = u.Id;
        psar.PermissionSetId = psr.Id;
        insert psar;
        
        system.runAs(u){
           ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
            VPM_PurchaseRequestsControllerExtension vendor=new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
            VPM_PurchaseRequestsControllerExtension.checkForBusinessReqUser();
            VPM_PurchaseRequestsControllerExtension.checkLoggedInUserRole();
            vendor.checkUser();
        }
        
        //for Bank Data User
        PermissionSet psb = [SELECT Id FROM PermissionSet WHERE Name = 'VPM_BankDatavalidation'];
       
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psab = new PermissionSetAssignment();
        psab.AssigneeId = u.Id;
        psab.PermissionSetId = psb.Id;
        insert psab;
        
        system.runAs(u){
            ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
            VPM_PurchaseRequestsControllerExtension vendor=new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
            VPM_PurchaseRequestsControllerExtension.checkForBusinessReqUser();
            VPM_PurchaseRequestsControllerExtension.checkLoggedInUserRole();
            vendor.checkUser();
        }
        
     
    }
    
     static testMethod void EnableManuallyMarkAsCompleteBtn(){
    
         string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = 'PH01';
    companyCode.ECC__c = 'Sirius';
    companyCode.VPM_Country__c ='Algeria';
    insert companyCode;
    system.assert(companyCode.Id!=null,'Error');
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
        VPM_CountryRequestingVendor__c='Algeria',
        VPM_CompanyCode__c=companyCode.Id,
        VPM_WhatAreYouBuying__c='test',
        VPM_IsVendorSME__c='Yes',
        VPM_ExceptionType__c= 'E001',
        VPM_VendorPhone__c='1234567895',
        recordTypeId=recordTypeId,
        VPM_Status__c ='Draft Request');
     insert pur;
      ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
      VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
       VendorDetail.EnableManuallyMarkAsCompleteBtn();
    }
     
}