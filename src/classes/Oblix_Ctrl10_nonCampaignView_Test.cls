@isTest 
private class Oblix_Ctrl10_nonCampaignView_Test {
 
    static testMethod void nonCampaignView_Test() {
        
        Profile p=[Select Id from Profile where Name='System Administrator' or Name='Système Administrateur'];       
     
         //Insert User 
         User u= new User(Alias = 'test123', Email='standarduser@unilever.com', 
         EmailEncodingKey='UTF-8', LastName='af test', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id,firstname='sf test one', 
         TimeZoneSidKey='Europe/London',AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
         UserName='testuser@test123321.com');//,AF_Brand__c='Test Brand1',AF_Category__c='Test Beverages1'
         insert u; 
         
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