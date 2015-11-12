@isTest 
private class Oblix_Ctrl10_nonCampaignView_Test {
 
    static testMethod void nonCampaignView_Test() {
        
        User u = Oblix_TestUtils.createTestUser();  
         
        System.runAs(u){
            Marketing_SOW__c marketingSow = new Marketing_SOW__c();
                marketingSow.Active__c = true;
                marketingSow.Name = 'Marketinf Sow Approval Test';
                marketingSow.SOW_Status__c = 'Open';
                marketingSow.Financial_Year__c = 'FY2015';
                insert marketingSow;
                
           
                
           
                Test.startTest();
                    PageReference pageref = Page.Oblix_VF02OverrideAsetNewLookup ; 
                       Test.setCurrentPage(pageref) ;
                  Oblix_Ctrl10_nonCampaignView  controller = new Oblix_Ctrl10_nonCampaignView();
                 //   System.assertEquals(controller.asset.Id, asset.Id); // assert that the controller take the ID from params
                 System.assertEquals(controller.activities.size(),0);
                 controller.addnewItems();
                 controller.back();
               Test.stopTest();
        }
    }
}