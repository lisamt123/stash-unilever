@isTest
public class VPM_SubController_Test {
    public String positions {get; set;}
    public string test2 {get;set;}
    
    static  VPM_PurchasingRequests__c createRecord()
    {
        VPM_PurchasingRequests__c pr = new VPM_PurchasingRequests__c( );
        pr.VPM_CountryRequestingVendor__c='Algeria';
        pr.VPM_WhatAreYouBuying__c='test';
        pr.VPM_VendorName1__c='test';
        pr.VPM_Country__c ='DZ_Algeria';
        pr.VPM_Comments__c='test';
        pr.VPM_VendorPhone__c='1234567895';
        pr.VPM_CompanyCode__c ='a4K190000000ILI'  ;        
        insert pr;  
        return pr;     
    }
    
    static testmethod void MyUntitest()
    {
        Test.startTest();
        VPM_PurchasingRequests__c pr = new VPM_PurchasingRequests__c( );
        pr = createRecord();
        ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pr);
        VPM_SubController VendorDetail = new VPM_SubController(VendorDetailPage);
        VendorDetail.wsBankCountryKey='test';
        VendorDetail.wsBankAccountNumber='test';
        VendorDetail.wsBankKey='test';
        VendorDetail.wsReferenceSpecificationsBankDetail='test';
        VendorDetail.wsBankControlKey='test';
        VendorDetail.wsIBAN='test';
        VendorDetail.wsCollectionAuthorization='test';
        VendorDetail.wsPartnerBankType='test';
        VendorDetail.wsBankName='test';
        VendorDetail.wsSwiftKey='test';
        VendorDetail.MaintainStatus='test';
        VendorDetail.wsAccountHolderName='test';
        Test.stopTest(); 
    }
    
    static testmethod void Positive(){
        Test.startTest();
        VPM_PurchasingRequests__c pr = new VPM_PurchasingRequests__c( );
        pr = createRecord();
        ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(pr);
        VPM_SubController VendorDetail = new VPM_SubController(VendorDetailPage);
        system.debug(pr); 
        VendorDetail.Save(); 
        System.Assert(pr.Id != null, 'Error');
        VendorDetail.SaveMethod(); 
        System.Assert(pr.Id != null, 'Error');
        VendorDetail.saveAndExit();
        System.Assert(pr.Id != null, 'Error');
        pr.VPM_Country__c ='DZ_Algeria';
        pr.VPM_Incoterms1__c='23';          
        update pr;
        VendorDetail.newMethod();
        System.Assert(pr.Id != null, 'Error'); 
        VendorDetail.backToFlow();
        System.assertNotEquals(null,VendorDetail.backToFlow());
        Test.stopTest();   
    }

    static  VPM_PurchasingRequests__c createRecord1()
    {
        VPM_PurchasingRequests__c pr = new VPM_PurchasingRequests__c( );
        pr.VPM_CountryRequestingVendor__c='Algeria';
        pr.VPM_WhatAreYouBuying__c='test';
        pr.VPM_VendorName1__c='test';
        pr.VPM_Country__c ='DZ_Algeria';
        pr.VPM_Comments__c='test';
        pr.VPM_VendorPhone__c='1234567895';
        pr.VPM_CompanyCode__c ='a4K190000000ILI'  ;        
        insert pr;  
        return pr;    
    }
    
    static testmethod void Negative(){
        Test.startTest();
        VPM_PurchasingRequests__c pr = new VPM_PurchasingRequests__c( );
        pr = createRecord1();
        VPM_PurchasingRequests__c PrResult = [SELECT Id, VPM_DeletionBlockFlag__c FROM VPM_PurchasingRequests__c WHERE Id = :pr.Id];
        PrResult.VPM_DeletionBlockFlag__c='No';
        update prResult;
        system.debug('aLSANA  @@@@@@@'+prResult);
        Test.setCurrentPageReference(new PageReference('Page.VPM_BlockDeleteUnBlockUnDelet'));
        System.currentPageReference().getParameters().put('id', prResult.id);
        System.currentPageReference().getParameters().put('maintainScreen','Maintain');
        System.currentPageReference().getParameters().put('wsBankName','HDFC');
        ApexPages.StandardController VendorDetailPage = new ApexPages.StandardController(prResult);
        VPM_SubController VendorDetail = new VPM_SubController(VendorDetailPage);
        VendorDetail.UnblockBlockUnDeleteDelete='';
        VendorDetail.options='MDM Ops Review - Block';
        VendorDetail.positions='No';
        VendorDetail.saveAndExit();
        System.Assert(pr.Id != null, 'Error');
        VendorDetail.save();
        System.Assert(pr.Id != null, 'Error');
        VendorDetail.newMethod();
        System.Assert(pr.Id != null, 'Error');
        Test.stopTest();   
        system.debug('aFTER dATA @@@@@@@'+prResult);         
    }  
}