@isTest 
public class VPM_PurchaseRequestsExtensionTest{
 
 static string Company = 'PH01';
 static string Ecc = 'U2K2';
 static string country = 'Algeria';
 static String ErrorMsg = 'Error';
 static string buyingStuff = 'test';
 static string phone='1234567895';
 static string code = '5001010';
 static string bussReq = 'Business Requestor';
 static string Status = 'Approval Pending';
 static string Request ='FLS';
 static string reworkStat = 'Yes';
 static boolean FLSInCountryReqVen = true;
 
    static void grpmethod() {
        Group grp = new Group(Name='Queue',Type='Queue');
        insert grp;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = grp.Id, SobjectType = 'VPM_PurchasingRequests__c');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}
    }
 
  static testMethod void ManuallyMarkAsCompleteActionTest()
    {
       // map<string,string> userRole =new map<string,string>();
    VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = 'Fusion';
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    //
     VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_DeletionBlockFlag__c='Block',
    VPM_Status__c ='MDM Ops Review - Unblock',
    VPM_ApprovalWorkerID__c='Test');
        //purList.add(pur);
     insert pur;
        //insert purList;
     grpmethod();
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_DeletionBlockFlag__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       List<VPM_PurchasingRequests__c> purList = [select VPM_CountryRequestingVendor__c,VPM_DeletionBlockFlag__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       system.assertEquals(pur.Id,pur1.Id);
      ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
      VPM_PurchaseRequestsControllerExtension VendorDetail1 = new VPM_PurchaseRequestsControllerExtension(new ApexPages.StandardSetController(purList));  
      VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
      VendorDetail.recId=pur.Id;
        VendorDetail.ManuallyMarkAsCompleteAction();
        vendorDetail.changeButtonValues();
        vendorDetail.isGBCountry = true;
        vendorDetail.setPaymentTermsDefaultValues();
        vendorDetail.approvalWorker='';
        vendorDetail.approvalWorkerID='';
        vendorDetail.vendorDefaultPaymentTerm='';
        pur1.VPM_Status__c ='MDM Ops Review - block';
        UPDATE pur1;
         VendorDetail.ManuallyMarkAsCompleteAction();
         VendorDetail.brStatusMethod();
       
    }
    
    
 static testMethod void checkForUserTestMethod() {

  
 // map<string,string> userRole =new map<string,string>();
   
   
        
    VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c ='United Kingdom';
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c='United Kingdom',
    VPM_CompanyCode__c=companyCode.id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_Country__c='IE_Ireland',
    VPM_VendorPhone__c=phone,
    VPM_IsVendorSME__c ='No',
    VPM_PaymentTermsIfNoneSelected__c = null);
     insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_IsVendorSME__c,VPM_PaymentTermsIfNoneSelected__c,VPM_Country__c,VPM_Comments__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c from VPM_PurchasingRequests__c where id=:pur.Id ];
       
       system.assertEquals(pur.Id,pur1.Id);
     
      ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
      VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
      vendorDetail.isProcure =true;
      vendorDetail.isGBCountry = true;
      vendorDetail.setPaymentTermsDefaultValues();
     
      vendorDetail.saveFromUser();
      vendorDetail.saveUserValues();
      vendorDetail.cancelFromUser();
      //vendordetail.AssigneeApproval(UserInfo.getUserId(),pur.Id);
      
      pur.VPM_Status__c = 'Bank Data Validation Requested Re-Work' ;
      pur.VPM_Rework__c = reworkStat;
      test.startTest();
      update pur;
      vendorDetail.SubmitRequestAction();
      test.stopTest();
      
  
 }

 public static mdm_Vendors__c setMDMData()
 {
    List<mdm_Vendors__c> vendorList = new List<mdm_Vendors__c>();
    mdm_Vendors__c vendor = new mdm_Vendors__c();
    vendor.mdm_Code__c = code;
    vendor.mdm_City__c = 'Andorra';
    vendor.mdm_Country__c ='DZ_Algeria';
    vendor.mdm_Name1__c ='Test Sirius';
    vendor.mdm_Street__c = 'Test Street';
    vendor.mdm_Postcode__c = '54132';
    vendor.mdm_Country__c = 'India';
    vendor.mdm_ID__c = '1234';
    vendor.mdm_vCodeFusion__c=code;
    vendor.mdm_vCodeCordillera__c=code;
    vendor.mdm_vCodeSirius__c=code;
    vendor.mdm_vCodeU2K2__c=code;
    vendorList.add(vendor);
    insert vendorList;
    return vendor ;
 }

  public static VPM_CompanyCode__c setCompanyCode()
 {
    VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = 'Sirius';
    companyCode.VPM_Country__c =country;
    insert companyCode;
    return companyCode;
 }

   public static  VPM_PurchasingRequests__c setVendorRequest(string companyCodeId, string vendorListId)
 {
     VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCodeId,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorCodeLookup__c = vendorListId,
    //recordTypeId=recordTypeId,
    VPM_VendorPhone__c=phone);
     insert pur;
     return pur;
 }
    static testMethod void callSendToSAPAPITest() {
   
   string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id; 
   
    List<mdm_Vendors__c> vendorList = new List<mdm_Vendors__c>();
    mdm_Vendors__c vendor = new mdm_Vendors__c();
    vendor.mdm_Code__c = code;
    vendor.mdm_City__c = 'Andorra';
    vendor.mdm_Country__c ='DZ_Algeria';
    vendor.mdm_Name1__c ='Test Sirius';
    vendor.mdm_Street__c = 'Test Street';
    vendor.mdm_Postcode__c = '54132';
    vendor.mdm_Country__c = 'India';
    vendor.mdm_ID__c = '1234';
    vendor.mdm_vCodeFusion__c=code;
    vendor.mdm_vCodeCordillera__c=code;
    vendor.mdm_vCodeSirius__c=code;
    vendor.mdm_vCodeU2K2__c=code;
    vendorList.add(vendor);
    insert vendorList;
    system.debug('@@vendorList' + vendorList);
    system.assert(vendor.Id!=null,ErrorMsg);
    
    
    VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = 'Sirius';
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorCodeLookup__c = vendorList[0].id,
    //recordTypeId=recordTypeId,
    VPM_VendorPhone__c=phone);
     insert pur;
        pur.recordTypeId = recordTypeId;
        update pur;
         VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_Comments__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_VendorCodeLookup__c,recordTypeId from VPM_PurchasingRequests__c where id=:pur.Id ];
       grpmethod();
       system.assertEquals(pur.Id,pur1.Id);
              ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
  VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
        VendorDetail.vendorReqId= pur.id;
        vendorDetail.isGBCountry = true;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
        VendorDetail.callSendToSAPAPI();
          test.stopTest();
        
        

    }

    static testMethod void callSendToSAPAPIMaintainTest() {
      mdm_Vendors__c vendor = setMDMData();
      VPM_CompanyCode__c companyCode = setCompanyCode();
      VPM_PurchasingRequests__c pur = setVendorRequest(companyCode.id, vendor.id);
      string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Maintain)'].Id; 
        pur.recordTypeId = recordTypeId;
       // pur.VPM_Fieldtype__c ='Regional';
        pur.VPM_PaymentTerms__c ='02D_Within 2 days Due net (2NET)';
        pur.VPM_fieldUpdated__c ='VPM_PaymentTerms__c';
        update pur;
         ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
  VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
        VendorDetail.vendorReqId= pur.id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
        VendorDetail.callSendToSAPAPI();
          test.stopTest();
      }

    static testMethod void callSendToSAPAPIExtendTest() {
      mdm_Vendors__c vendor = setMDMData();
      VPM_CompanyCode__c companyCode = setCompanyCode();
       VPM_PurchasingRequests__c pur = setVendorRequest(companyCode.id, vendor.id);
      string  recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Extend)'].Id; 
        pur.recordTypeId = recordTypeId;
        update pur;
         ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
  VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
        VendorDetail.vendorReqId= pur.id;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new VPM_maintainGlobalVendorCalloutMock(200));
        VendorDetail.callSendToSAPAPI();
          test.stopTest();
      }
    
    public static User insertUser()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name= : System.Label.VPM_Profile];
        //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        //UserRole r = [SELECT Id,name FROM UserRole WHERE Name = 'CEC Global Head'];
        //System.debug('Role' + r.name);
        User u = new User(LastName = 'Testing', 
                          Username = 'cectestuser@test00DE0000000bbLj.org', 
                          Email = 'testuser@test.com', 
                          Alias = 'utest', 
                          TimeZoneSidKey = 'Europe/London', 
                          LocaleSidKey = 'en_GB', 
                          EmailEncodingKey = 'UTF-8', 
                          ProfileId = p.Id, 
                          LanguageLocaleKey = 'en_US',
                          UserPermissionsKnowledgeUser = true);  
        
        insert u;
        List<PermissionSet> pslist = [SELECT Id FROM PermissionSet WHERE Name IN ('VPM_FLS','VPM_Business_Requestor')];
        List<PermissionSetAssignment> psalist = new List<PermissionSetAssignment>();
        for(PermissionSet ps:pslist)
        {
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = u.Id;
            psa.PermissionSetId = ps.Id;
            
            psalist.add(psa);
            
        }
        
        insert psalist;

        
        return u;
        
    }
    
    
        static testMethod void reworkActionMDM() {
    
            User u = insertUser();
        
        System.runAs(u)
        {
    VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_RequestFromFLSOrBR__c =bussReq);
    insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       
       system.assertEquals(pur.Id,pur1.Id);
          ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
         VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
         pur.VPM_RequestFromFLSOrBR__c=bussReq;
         pur.VPM_Status__c ='MDM Ops Review';
         test.startTest();
         update pur;
         VendorDetail.ReworkAction();
         test.stopTest();
        } 
     }
     
      static testMethod void reworkActionMDM2() {
    
            User u = insertUser();
        
        System.runAs(u)
        {
    VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_RequestFromFLSOrBR__c ='FLS');
    insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       
       system.assertEquals(pur.Id,pur1.Id);
          ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
         VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
         pur.VPM_RequestFromFLSOrBR__c='FLS';
         pur.VPM_Status__c ='MDM Ops Review';
         test.startTest();
         update pur;
         VendorDetail.ReworkAction();
         test.stopTest();
        } 
     }
    
    
      static testMethod void reworkActionTest1() {
    
            User u = insertUser();
        
        System.runAs(u)
        {
    VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_RequestFromFLSOrBR__c =bussReq);
    insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       
       system.assertEquals(pur.Id,pur1.Id);
          ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
         VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
         pur.VPM_RequestFromFLSOrBR__c=bussReq;
         pur.VPM_Status__c ='FLS Review';
         test.startTest();
         update pur;
         VendorDetail.ReworkAction();
         test.stopTest();
        } 
     }

     static testMethod void reworkActionTest2() {
     VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
     VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_RequestFromFLSOrBR__c =bussReq);
    insert pur;
    grpmethod();     
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       
       system.assertEquals(pur.Id,pur1.Id);
          ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
         VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
         pur.VPM_RequestFromFLSOrBR__c=bussReq;
         pur.VPM_Status__c = Status;
         pur.VPM_ProcurementApprovalRequired__c=true;
         //pur.VPM_FinanceApprovalRequired__c = true;
        
         test.startTest();
         update pur;
         VendorDetail.ReworkAction();
         test.stopTest();
        
     }

     static testMethod void reworkActionTest3() {
     VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
     VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_RequestFromFLSOrBR__c =bussReq);
    insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       grpmethod();
       system.assertEquals(pur.Id,pur1.Id);
          ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
         VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
         pur.VPM_RequestFromFLSOrBR__c=bussReq;
         pur.VPM_ProcurementApprovalRequired__c=false;
         pur.VPM_FreightApprovalRequired__c=false;
         pur.VPM_RussianTaxApprovalRequired__c=false;
         pur.VPM_FinanceApprovalRequired__c =true;
         pur.VPM_status__c=Status;
         
         test.startTest();
          update pur;
          VendorDetail.ReworkAction();
          test.stopTest();
         pur.VPM_status__c='FLS Rejected';
         update pur; 
         
        
     }

    static testMethod void reworkActionTest4() {
    VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
     VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_RequestFromFLSOrBR__c =bussReq);
    insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       grpmethod();
       system.assertEquals(pur.Id,pur1.Id);
          ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
         VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
          pur.VPM_ProcurementApprovalRequired__c=true;
          pur.VPM_FreightApprovalRequired__c=false;
          pur.VPM_RussianTaxApprovalRequired__c=false;
          pur.VPM_FinanceApprovalRequired__c =false;
          pur.VPM_RequestFromFLSOrBR__c=Request;
          pur.VPM_status__c=Status;
          
          test.startTest();
          update pur;
          VendorDetail.ReworkAction();
          test.stoptest();
        
     }

     static testMethod void reworkActionTest5() {
     VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
     VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_RequestFromFLSOrBR__c =bussReq);
    insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       grpmethod();
       system.assertEquals(pur.Id,pur1.Id);
          ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
         VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
         pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=false;
          pur.VPM_RussianTaxApprovalRequired__c=false;
          pur.VPM_FinanceApprovalRequired__c =true;
          pur.VPM_RequestFromFLSOrBR__c=Request;
          pur.VPM_status__c=Status;
          test.startTest();
          update pur;
          VendorDetail.ReworkAction();
          test.stoptest();
        
     }

     static testMethod void reworkActionTest6() {
     VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
     VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_RequestFromFLSOrBR__c =bussReq);
    insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       grpmethod();
       system.assertEquals(pur.Id,pur1.Id);
          ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
         VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
          pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=false;
          pur.VPM_RussianTaxApprovalRequired__c=true;
          pur.VPM_FinanceApprovalRequired__c =false;
          pur.VPM_RequestFromFLSOrBR__c=Request;
          pur.VPM_status__c=Status;
          
          test.startTest();
          update pur;
          VendorDetail.ReworkAction();
          test.stoptest();
        
     }

     static testMethod void reworkActionTest7() {
     VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
     VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_RequestFromFLSOrBR__c =bussReq);
    insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       grpmethod();
       system.assertEquals(pur.Id,pur1.Id);
          ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
         VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
          pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=true;
          pur.VPM_RussianTaxApprovalRequired__c=false;
          pur.VPM_FinanceApprovalRequired__c =false;
          pur.VPM_RequestFromFLSOrBR__c=Request;
          pur.VPM_status__c=Status;
          test.startTest();
          update pur;
          VendorDetail.ReworkAction();
          test.stopTest();
        
     }

     static testMethod void reworkActionTest8() {
     VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
     VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_RequestFromFLSOrBR__c =bussReq);
    insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       grpmethod();
       system.assertEquals(pur.Id,pur1.Id);
          ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
         VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
          pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=true;
          pur.VPM_RussianTaxApprovalRequired__c=false;
          pur.VPM_FinanceApprovalRequired__c =true;
          pur.VPM_RequestFromFLSOrBR__c=Request;
          pur.VPM_status__c=Status;
          test.startTest();
          update pur;
          VendorDetail.ReworkAction();
          test.stopTest();
        
     }

     static testMethod void reworkActionTest9() {
     VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
     VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_RequestFromFLSOrBR__c =bussReq);
    insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       grpmethod();
       system.assertEquals(pur.Id,pur1.Id);
          ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
         VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
          pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=false;
          pur.VPM_RussianTaxApprovalRequired__c=true;
          pur.VPM_FinanceApprovalRequired__c =false;
          pur.VPM_RequestFromFLSOrBR__c=bussReq;
          pur.VPM_status__c=Status;
          test.startTest();
          update pur;
          VendorDetail.ReworkAction();
          test.stopTest();
        
     }

     static testMethod void reworkActionTest10() {
     VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
     VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_RequestFromFLSOrBR__c =bussReq);
    insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       grpmethod();
       system.assertEquals(pur.Id,pur1.Id);
          ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
         VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
           pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=true;
          pur.VPM_RussianTaxApprovalRequired__c=false;
          pur.VPM_FinanceApprovalRequired__c =false;
          pur.VPM_RequestFromFLSOrBR__c=bussReq;
          pur.VPM_status__c=Status;
          test.startTest();
          update pur;
          VendorDetail.ReworkAction();
          test.stopTest();
        
     }

     static testMethod void reworkActionTest11() {
     VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
     VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_RequestFromFLSOrBR__c =bussReq);
    insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       grpmethod();
       system.assertEquals(pur.Id,pur1.Id);
          ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
         VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
            pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=true;
          pur.VPM_RussianTaxApprovalRequired__c=false;
          pur.VPM_FinanceApprovalRequired__c =true;
          pur.VPM_RequestFromFLSOrBR__c=bussreq;
          pur.VPM_status__c=Status;
          test.startTest();
          update pur;
          VendorDetail.ReworkAction();
          test.stopTest();
        
     }

     static testMethod void reworkActionTest12() {
     VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
     VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_RequestFromFLSOrBR__c =bussReq);
    insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       grpmethod();
       system.assertEquals(pur.Id,pur1.Id);
          ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
         VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
          pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=false;
          pur.VPM_RussianTaxApprovalRequired__c=false;
          pur.VPM_FinanceApprovalRequired__c =false;
          pur.VPM_BankDataValidationRequired__c = true;
          pur.VPM_RequestFromFLSOrBR__c=Request;
          pur.VPM_status__c=Status;
          test.startTest();
          update pur;
          VendorDetail.ReworkAction();
          test.stopTest();
        
     }

      static testMethod void reworkActionTest13() {
      VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
     VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_RequestFromFLSOrBR__c =bussReq);
    insert pur;
     VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       grpmethod();
       system.assertEquals(pur.Id,pur1.Id);
          ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
         VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
           pur.VPM_ProcurementApprovalRequired__c=false;
          pur.VPM_FreightApprovalRequired__c=false;
          pur.VPM_RussianTaxApprovalRequired__c=false;
          pur.VPM_FinanceApprovalRequired__c =false;
          pur.VPM_BankDataValidationRequired__c = true;
          pur.VPM_RequestFromFLSOrBR__c=bussReq;
          pur.VPM_status__c=Status;
          test.startTest();
          update pur;
          VendorDetail.ReworkAction();
          test.stopTest();
        
     }
   
    
    static testMethod void changeButtonValues(){
        Profile p = [SELECT Id FROM Profile WHERE Name=:System.Label.VPM_Profile];
     User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',     UserName='testpermissionsetuser@testorg.com');
        insert u;
        
       
       VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
       companyCode.VPM_CompanyCode__c = Company;
       companyCode.ECC__c = Ecc;
       companyCode.VPM_Country__c =country;
       insert companyCode;
       system.assert(companyCode.Id!=null,ErrorMsg);
       
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
        VPM_CountryRequestingVendor__c=country,
        VPM_CompanyCode__c=companyCode.Id,
        VPM_WhatAreYouBuying__c=buyingStuff,
        VPM_ApprovalWorkerID__c=null,
        VPM_ApprovalWorker__c = null,
        VPM_VendorPhone__c=phone,
        OwnerId =u.Id,
        VPM_Status__c ='Draft Request');
     insert pur;
      ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
      VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
        grpmethod();
       VendorDetail.changeButtonValues();
       VPM_PurchasingRequests__c pur1 = [select VPM_CountryRequestingVendor__c,OwnerId,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_ApprovalWorkerID__c,VPM_ApprovalWorker__c ,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       
       system.assertEquals(pur.Id,pur1.Id);
      
       //pur.VPM_ApprovalWorkerID__c='User';
       //update pur;
       
       //pur1 = [select VPM_CountryRequestingVendor__c,OwnerId,VPM_CompanyCode__c,VPM_WhatAreYouBuying__c,VPM_ApprovalWorkerID__c,VPM_ApprovalWorker__c ,VPM_VendorPhone__c,VPM_Status__c  from VPM_PurchasingRequests__c where id=:pur.Id ];
       //system.assertEquals(pur.VPM_ApprovalWorkerID__c,pur1.VPM_ApprovalWorkerID__c);
       //VendorDetail.changeButtonValues();
       
    }
    
   
    
     static testMethod void EnableManuallyMarkAsCompleteBtn(){
    
         string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        string country1 = 'Algeria';
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = 'Sirius';
    companyCode.VPM_Country__c =country1;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
        VPM_CountryRequestingVendor__c=country1,
        VPM_CompanyCode__c=companyCode.Id,
        VPM_WhatAreYouBuying__c=buyingStuff,
        VPM_IsVendorSME__c=reworkStat,
        VPM_ExceptionType__c= 'E001',
        VPM_VendorPhone__c=phone,
        recordTypeId=recordTypeId,
        VPM_Status__c ='Draft Request');
     insert pur;
      ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
      VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
         
       VendorDetail.EnableManuallyMarkAsCompleteBtn();
        VendorDetail.isApprover1=true;
         VendorDetail.isApprover2=true;
         VendorDetail.isApprover3=true;
         VendorDetail.isApprover4=true;
         VendorDetail.isApprover5=true;
         VendorDetail.isApprover6=true;
         VendorDetail.isApprover7=true;
         VendorDetail.isApprover8=true;
         VendorDetail.isApprover9=true;
         VendorDetail.isApprover10=true;
         VendorDetail.internationalVersion='';
         VendorDetail.exceptionType='';
         VendorDetail.isVenderSME='';
         VendorDetail.commodityApproverId='';
         VendorDetail.showManuallyMarkAsComplete=true;
             VendorDetail.isCordillera=false;
             VendorDetail.renderSAPBtn=false;
             VendorDetail.manuallyMarkAsCompleteBtn=false;
             VendorDetail.reworkBtn=false;
             VendorDetail.AlertMsg='';
             VendorDetail.isDisplay=false;
         VendorDetail.commodityApproverId='';
         VendorDetail.manuallyMarkAsCompleteFlag=false;
         
             
         
         
    }
    
    static testMethod void checkForBusinessReqUserTest(){
    
        
        VPM_PurchaseRequestsControllerExtension.checkForBusinessReqUser();  
    }
    
    static testMethod void SubmitRequestActionTest1()
    {
        Group grp = new Group(Name='Procurement',Type='Queue');
        insert grp;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = grp.Id, SobjectType = 'VPM_PurchasingRequests__c');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}
    
    VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_FLSInCountryReqVen__c=FLSInCountryReqVen,
    VPM_AdvancedFormSubmitted__c = 'No',
    VPM_Status__c ='FLS Requested Re-Work',
    OwnerId = grp.Id);
     insert pur;
     
      ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
      VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
      vendorDetail.SubmitRequestAction();
      
      pur.VPM_Rework__c = reworkStat;
      pur.VPM_Status__c = 'FLS Requested Re-Work' ;
      test.startTest();
      pur.OwnerId = grp.Id;    
      update pur;
      system.assertEquals(pur.VPM_Status__c,'FLS Requested Re-Work');
      vendorDetail.SubmitRequestAction();
      test.stopTest();
      
      
    }
    
     static testMethod void SubmitRequestActionTest2()
    {
    
        Group grp = new Group(Name='Procurement',Type='Queue');
        insert grp;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = grp.Id, SobjectType = 'VPM_PurchasingRequests__c');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}
        
    
    VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_FLSInCountryReqVen__c=FLSInCountryReqVen,
    VPM_AdvancedFormSubmitted__c = 'No',
    VPM_Status__c ='Procurement Requested Re-Work',
    VPM_Rework__c =reworkStat,
    OwnerId = grp.Id);
     insert pur;
     
      ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
      VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
      vendorDetail.SubmitRequestAction();
      
      
      pur.VPM_Status__c = 'Finance Requested Re-Work' ;
      test.startTest();
      pur.OwnerId = grp.Id;    
      update pur;
      system.assertEquals(pur.VPM_Status__c,'Finance Requested Re-Work');
      vendorDetail.SubmitRequestAction();
      test.stopTest();
      
      
    }
    
     static testMethod void SubmitRequestActionTest3()
    {
        Group grp = new Group(Name='Procurement',Type='Queue');
        insert grp;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = grp.Id, SobjectType = 'VPM_PurchasingRequests__c');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}
    
       VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_FLSInCountryReqVen__c=FLSInCountryReqVen,
    VPM_AdvancedFormSubmitted__c = 'No',
    VPM_Status__c ='Russian Custom Tax Requested Re-Work',
    VPM_Rework__c =reworkStat ,
    OwnerId = grp.Id);
     insert pur;
     
      ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
      VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
      vendorDetail.SubmitRequestAction();
      
      
      pur.VPM_Status__c = 'Freight Requested Re-Work' ;
      test.startTest();
        pur.OwnerId = grp.Id;  
      update pur;
      system.assertEquals(pur.VPM_Status__c,'Freight Requested Re-Work');
      vendorDetail.SubmitRequestAction();
      test.stopTest();
      
      
    }
    
    static testMethod void SubmitRequestActionTest4()
    {
    
     Group grp = new Group(Name='Procurement',Type='Queue');
        insert grp;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = grp.Id, SobjectType = 'VPM_PurchasingRequests__c');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}   
        
       VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_FLSInCountryReqVen__c=FLSInCountryReqVen,
    VPM_AdvancedFormSubmitted__c = 'No',
    VPM_Status__c ='',
    VPM_Rework__c = reworkStat,
    OwnerId = grp.Id);
     insert pur;
        
        
     
      ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
      VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
      vendorDetail.SubmitRequestAction();
      
      
      pur.VPM_Status__c = 'Procurement Requested Re-Work' ;
      test.startTest();
      pur.OwnerId = grp.Id;  
      update pur;
      system.assertEquals(pur.VPM_Status__c,'Procurement Requested Re-Work');
      //vendorDetail.SubmitRequestAction();
      test.stopTest();
      
      
    }
    
    static testMethod void SubmitRequestActionTest5()
    {
         Group grp = new Group(Name='Procurement',Type='Queue');
        insert grp;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = grp.Id, SobjectType = 'VPM_PurchasingRequests__c');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}   
    
       VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
    companyCode.VPM_CompanyCode__c = Company;
    companyCode.ECC__c = Ecc;
    companyCode.VPM_Country__c =country;
    insert companyCode;
    system.assert(companyCode.Id!=null,ErrorMsg);
    
    VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c(
    VPM_CountryRequestingVendor__c=country,
    VPM_CompanyCode__c=companyCode.Id,
    VPM_WhatAreYouBuying__c=buyingStuff,
    VPM_Comments__c=buyingStuff,
    VPM_VendorPhone__c=phone,
    VPM_FLSInCountryReqVen__c=FLSInCountryReqVen,
    VPM_AdvancedFormSubmitted__c = 'No',
    VPM_Status__c ='',
    VPM_Rework__c =reworkStat ,
        OwnerId = grp.Id);
     insert pur;
     
      ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pur);
      VPM_PurchaseRequestsControllerExtension VendorDetail = new VPM_PurchaseRequestsControllerExtension(VendorDetailPage);
      vendorDetail.SubmitRequestAction();
      
      
      pur.VPM_Status__c = 'Russian Custom Tax Requested Re-Work' ;
      test.startTest();
      pur.OwnerId = grp.Id;  
      update pur;
      system.assertEquals(pur.VPM_Status__c,'Russian Custom Tax Requested Re-Work');
      vendorDetail.SubmitRequestAction();
      test.stopTest();
      
      
    }
    static VPM_PurchasingRequests__c TestDataFreightApprovalMethod(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = 'U2K2';
        companyCode.VPM_Country__c ='Algeria';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='U2K2';
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,'Error');
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c ='Test User2';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c='Test Street';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX AFR ASIA SEAA_VMBA CAPEX AAR';
        
        //pur.VPM_PaymentTerms__c ='Payment Terms';
       // pur.VPM_BankCountryKey__c ='Bank Country Key';
       // pur.VPM_ReconciliationAccount__c ='Recouncil';
       // pur.VPM_DeletionBlockFlag__c='Undelete';
       // pur.VPM_DeletionBlockFlag__c ='delete';
         pur.VPM_Incoterms1__c='UN _Not Free';
       
        pur.VPM_VendorType__c  = 'FRGT_Freight Vendor_G001';
         pur.VPM_GlobalAuthorisationGroup__c='Freight_Freight';
        pur.VPM_IsInApprovalProcess__c='';
        pur.VPM_FreightApprovalRequired__c=false;
        pur.VPM_FreightSubmitted__c='No';
        pur.VPM_AdvancedFormSubmitted__c='Yes';
        pur.VPM_Rework__c='No';
        
        insert pur;
        
        system.assert(pur.Id!=null,'Error');
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
 /*   
     static testMethod void VPM_ApprovalMethodRussian(){
        
         VPM_PurchasingRequests__c purId = TestDataApprovalMethod();
         ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
         VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         purId.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
        purid.VPM_BusinessRequestorSubmitted__c='Yes';
         purid.VPM_Rework__c='No';
        // update purId;
          system.debug('purId '+purId+'    '+purId.VPM_Commodity_Family__c);
        goldenData.approvalCallMethod();
         List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(purId);
        VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
    
    } */
    
    static testMethod void VPM_ApprovalMethodFreight(){
        
         VPM_PurchasingRequests__c purId = TestDataFreightApprovalMethod();
       //  ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        // VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         purId.VPM_VendorType__c  = 'FRGT_Freight Vendor_G001';
         purid.VPM_GlobalAuthorisationGroup__c='Freight_Freight';        
        purId.VPM_FreightApprovalRequired__c=true;
        
        
       List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(purId);
       
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
    }
    
        static VPM_PurchasingRequests__c TestDataRussainApprovalMethod(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = 'U2K2';
        companyCode.VPM_Country__c ='Algeria';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='U2K2';
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,'Error');
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c ='Test User2';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c='Test Street';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c ='54132';
        //pur.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX AFR ASIA SEAA_VMBA CAPEX AAR';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
         pur.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
         pur.VPM_GlobalAuthorisationGroup__c='3PM--3PM South & North Asia & SEAA_VMBA 3PM Asia SEAA';
         pur.VPM_RussianTaxApprovalRequired__c=false;
        
         pur.VPM_Rework__c='No';
         pur.VPM_AdvancedFormSubmitted__c='Yes';
         pur.VPM_RussiaSubmitted__c='No';
         pur.VPM_IsInApprovalProcess__c='';

        insert pur;
        
        system.assert(pur.Id!=null,'Error');
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
  static testMethod void VPM_ApprovalMethodRussian(){
        
         VPM_PurchasingRequests__c purId = TestDataRussainApprovalMethod();
       
         List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(purId);
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
    }
    
    static VPM_PurchasingRequests__c TestDataBankApprovalMethod(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = 'U2K2';
        companyCode.VPM_Country__c ='Algeria';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='U2K2';
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,'Error');
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c ='Test User2';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c='Test Street';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        //pur.VPM_Commodity__c=commodityCode.id;
        pur.VPM_ZIPPostcode__c ='54132';
        //pur.VPM_GlobalAuthorisationGroup__c='SCS-CAPEX AFR ASIA SEAA_VMBA CAPEX AAR';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
         pur.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
         pur.VPM_GlobalAuthorisationGroup__c='3PM--3PM South & North Asia & SEAA_VMBA 3PM Asia SEAA';
         pur.VPM_BankDataValidationRequired__c=false;
      pur.VPM_FinanceApprovalRequired__c=true;
            pur.VPM_Rework__c='No';
         pur.VPM_AdvancedFormSubmitted__c='Yes';
         pur.VPM_BankDataValidationSubmitted__c='No';
         pur.VPM_IsInApprovalProcess__c='';

        insert pur;
        
        system.assert(pur.Id!=null,'Error');
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
     static testMethod void VPM_ApprovalMethodBank(){
        
         VPM_PurchasingRequests__c purId = TestDataBankApprovalMethod();
       //  ApexPages.StandardController vendorDetail = new ApexPages.StandardController(purId);
        // VPM_GoldenDataController2 goldenData = new VPM_GoldenDataController2(vendorDetail);
         purId.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
         purid.VPM_GlobalAuthorisationGroup__c='3PM--3PM South & North Asia & SEAA_VMBA 3PM Asia SEAA';
        purId.VPM_BankDataValidationRequired__c=true;
         List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
       purcReqlst.add(purId);
       // VPM_ApprovalSubmit newApproval = new VPM_ApprovalSubmit();
       VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
        
    }
    
    static VPM_PurchasingRequests__c TestDataPositive1(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = 'U2K2';
        companyCode.VPM_Country__c ='Algeria';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='U2K2';
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,'Error');
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c ='Test User2';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c='Test Street';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
        pur.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
        pur.VPM_GlobalAuthorisationGroup__c='3PM--3PM South & North Asia & SEAA_VMBA 3PM Asia SEAA';
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        
        system.assert(pur.Id!=null,'Error');
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c='Yes';
        pur.VPM_ProcurementApprovalRequired__c = true;
        pur.VPM_ProcurementSubmitted__c = 'No';
        pur.VPM_IsInApprovalProcess__c='';
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
    static testMethod void positiveMethod1() {        
        VPM_PurchasingRequests__c purId = TestDataPositive1();
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
        purcReqlst.add(purId);
        VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
    }
    
    static VPM_PurchasingRequests__c TestDataPositive2(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = 'U2K2';
        companyCode.VPM_Country__c ='Algeria';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='U2K2';
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,'Error');
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c ='Test User2';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c='Test Street';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
        pur.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
        pur.VPM_GlobalAuthorisationGroup__c='3PM--3PM South & North Asia & SEAA_VMBA 3PM Asia SEAA';
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        
        system.assert(pur.Id!=null,'Error');
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c='Yes';
        pur.VPM_FreightApprovalRequired__c = true;
        pur.VPM_FreightSubmitted__c = 'No';
        pur.VPM_IsInApprovalProcess__c='';
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
    static testMethod void positiveMethod2() {        
        VPM_PurchasingRequests__c purId = TestDataPositive2(); 
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
        purcReqlst.add(purId);
        VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
    }
    
    static VPM_PurchasingRequests__c TestDataPositive3(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = 'U2K2';
        companyCode.VPM_Country__c ='Algeria';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='U2K2';
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,'Error');
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c ='Test User2';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c='Test Street';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
        pur.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
        pur.VPM_GlobalAuthorisationGroup__c='3PM--3PM South & North Asia & SEAA_VMBA 3PM Asia SEAA';
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        
        system.assert(pur.Id!=null,'Error');
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c='Yes';
        pur.VPM_FinanceApprovalRequired__c = true;
        pur.VPM_RussianTaxApprovalRequired__c = true;
        pur.VPM_BankDataValidationRequired__c = true;
        pur.VPM_BankDataValidationSubmitted__c = 'No';
        pur.VPM_IsInApprovalProcess__c='';
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
    static testMethod void positiveMethod3() {        
        VPM_PurchasingRequests__c purId = TestDataPositive3(); 
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
        purcReqlst.add(purId);
        VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
    }
    
    static VPM_PurchasingRequests__c TestDataPositive4(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = 'U2K2';
        companyCode.VPM_Country__c ='Algeria';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='U2K2';
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,'Error');
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c ='Test User2';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c='Test Street';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_AdvancedFormSubmitted__c ='Yes';
        pur.VPM_VendorType__c  = 'RCT_Russian Customs Tax Vendor_G001';
        pur.VPM_GlobalAuthorisationGroup__c='3PM--3PM South & North Asia & SEAA_VMBA 3PM Asia SEAA';
        pur.VPM_BankDataValidationRequired__c=false;
        pur.VPM_FinanceApprovalRequired__c=true;        

        insert pur;
        
        system.assert(pur.Id!=null,'Error');
        pur.VPM_Rework__c='No';
        pur.VPM_AdvancedFormSubmitted__c='Yes';
        pur.VPM_FinanceApprovalRequired__c = true;
        pur.VPM_RussianTaxApprovalRequired__c = true;
        pur.VPM_RussiaSubmitted__c = 'No';
        pur.VPM_IsInApprovalProcess__c='';
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
    static testMethod void positiveMethod4() {        
        VPM_PurchasingRequests__c purId = TestDataPositive4(); 
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
        purcReqlst.add(purId);
        VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
    }
    
    static VPM_PurchasingRequests__c TestDataPositive5(){
    
        string recordTypeId= [Select Id From RecordType Where SobjectType = 'VPM_PurchasingRequests__c' and Name = 'Vendor Request (Create)'].Id;
        
        mdm_Vendors__c vendor = new mdm_Vendors__c();
        vendor.mdm_Code__c = '5001010';
        vendor.mdm_City__c = 'Andorra';
        vendor.mdm_Country__c ='DZ_Algeria';
        vendor.mdm_Name1__c ='Test Sirius';
        vendor.mdm_ID__c = '1234';
        insert vendor;
        system.assert(vendor.Id!=null,'Error');
        
        VPM_CompanyCode__c companyCode = new VPM_CompanyCode__c();
        companyCode.VPM_CompanyCode__c = 'PH01';
        companyCode.ECC__c = 'U2K2';
        companyCode.VPM_Country__c ='Algeria';
        insert companyCode;
        system.assert(companyCode.Id!=null,'Error');
        
         VPM_CommodityCode__c commodityCode=new VPM_CommodityCode__c();
        commodityCode.VPM_VendorType__c ='MBS_Marketing Business Services_G001';
        commodityCode.VPM_AuthorisationGroup__c ='MBS--Marketing Services';
        commodityCode.VPM_CommodityClass__c = 'Ad-hoc Research'; 
        commodityCode.Name='Ad-hoc Market Research - Qualitative';
        commodityCode.VPM_CommodityCode__c='5702 - UN01580115';
        commodityCode.VPM_CommodityClass__c='Market Research';
        commodityCode.VPM_Region__c='U2K2';
          
        insert commodityCode;
        system.assert(commodityCode.Id!=null,'Error');
        
        VPM_PurchasingRequests__c pur = new VPM_PurchasingRequests__c();
        pur.VPM_ECC__c = 'U2K2';
       // pur.VPM_ProvidedBankDetails__c = TRUE;
        pur.VPM_VendorName1__c ='Test User2';
        pur.VPM_Status__c = 'Draft Request';
        pur.VPM_AccountGroup__c ='ZGS1';
        pur.VPM_VendorCodeLookup__c =vendor.Id;
        pur.recordTypeId=recordTypeId;
        pur.VPM_CompanyCode__c=companyCode.Id;
        pur.VPM_City__c='Test Street';
        pur.VPM_Street1__c='Test Street';
        pur.VPM_CountryRequestingVendor__c='Algeria';
        pur.VPM_VendorPhone__c='1234567895';
        pur.VPM_ZIPPostcode__c ='54132';
        pur.VPM_BusinessRequestorSubmitted__c = ''; 
        
        insert pur;
        
        system.assert(pur.Id!=null,'Error');
        
        pur.VPM_Commodity__c=commodityCode.id;
        update pur;
       VPM_PurchasingRequests__c  pur1 = [select VPM_Commodity__c,VPM_VendorType__c,VPM_Country__c,VPM_AccountGroup__c,VPM_ReconciliationAccount__c ,VPM_DeletionBlockFlag__c,
               VPM_BankCountryKey__c ,VPM_PaymentTerms__c ,VPM_AdvancedFormSubmitted__c ,VPM_GlobalAuthorisationGroup__c,VPM_ZIPPostcode__c ,VPM_VendorPhone__c, 
               VPM_CountryRequestingVendor__c,VPM_Street1__c,VPM_CompanyCode__c,recordTypeId,VPM_VendorCodeLookup__c ,VPM_Status__c ,VPM_ECC__c ,VPM_VendorName1__c ,
               VPM_Commodity_Family__c,VPM_CRVT__c ,VPM_FreightSubmitted__c,VPM_FreightApprovalRequired__c,VPM_IsInApprovalProcess__c from VPM_PurchasingRequests__c  where id =: pur.id limit 1];
       system.assertEquals(pur.VPM_Commodity__c,pur1.VPM_Commodity__c);
        return pur1;    
    }
    
    static testMethod void positiveMethod5() {        
        VPM_PurchasingRequests__c pur = TestDataPositive5(); 
        pur.VPM_BusinessRequestorSubmitted__c = 'Yes'; 
        pur.VPM_Rework__c= 'No';
        List<VPM_PurchasingRequests__c> purcReqlst = new List<VPM_PurchasingRequests__c>();
        purcReqlst.add(pur);
        VPM_ApprovalSubmit.SubmitApproval(purcReqlst);
    }     
}