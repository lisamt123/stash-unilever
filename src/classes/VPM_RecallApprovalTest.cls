@isTest(seealldata=false)
public with sharing class VPM_RecallApprovalTest {

     public static User insertUser()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Read Only'];
        User u = new User(LastName = 'Testing', 
                          Username = 'VPMtestuser@test00DE0000000bbLj.org', 
                          Email = 'testuser@test.com', 
                          Alias = 'utest', 
                          TimeZoneSidKey = 'Europe/London', 
                          LocaleSidKey = 'en_GB', 
                          EmailEncodingKey = 'UTF-8', 
                          ProfileId = p.Id, 
                          LanguageLocaleKey = 'en_US',
                          UserPermissionsKnowledgeUser = true);  
        
        insert u;
        List<PermissionSet> pslist = [SELECT Id FROM PermissionSet WHERE Name IN ('VPM - Business Requestor')];
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
    
    
static testMethod void verifyPurchasingRequestsIsLock(){ 
 
        Test.startTest();
        User u = insertUser();
        System.runAs(u)
        {
        VPM_PurchasingRequests__c p = new VPM_PurchasingRequests__c(VPM_Status__c='Draft Request',VPM_Spend__c='50',
                                                                    VPM_VendorContactDetail__c='samrin.shaikh@Capgemini.com',
                                                                    VPM_VendorPhone__c='9892940558',
                                                                    VPM_VendorName1__c='Test Vendor',
                                                                    VPM_CountryRequestingVendor__c='UK',
                                                                    VPM_Comments__c='Test Class'); 
        insert p;
        p.VPM_Status__c='FLS Requested Re-Work';
        p.VPM_Rework__c='Yes';
        update p;
     // 
     VPM_PurchasingRequests__c[] LstPurchReq = [SELECT VPM_Rework__c from VPM_PurchasingRequests__c 
                                                WHERE VPM_VendorName1__c='Test Vendor'];
    
    // Record are lock & VPM_Rework =Yes  
    Approval.LockResult[] lrList = Approval.lock(LstPurchReq, false);

    VPM_PurchasingRequests__c[] PurchReq = [SELECT VPM_Rework__c from VPM_PurchasingRequests__c 
                                                WHERE VPM_VendorName1__c='Test Vendor'];
    for(VPM_PurchasingRequests__c pi : PurchReq){
        if(pi.VPM_Rework__c=='Yes')
        {
          Approval.UnLockResult lr = Approval.Unlock(pi,False);
           System.assertEquals(False, lr.isSuccess()); 
           
        }
        }
            
    }
    
    Test.stopTest();
        
    
 
} 

   
}