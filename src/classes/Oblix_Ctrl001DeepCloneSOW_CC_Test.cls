@isTest 
private class Oblix_Ctrl001DeepCloneSOW_CC_Test {


    
    private static  Marketing_SOW__c createMaketingSow (){
      
         Account myAccount = new Account();
             myAccount.Name = 'AgencyAccount';
         insert myAccount;
         Marketing_SOW__c marketingSow = new Marketing_SOW__c();
            marketingSow.Active__c = true;
            marketingSow.Name = 'Marketinf Sow Approval';
            marketingSow.SOW_Status__c = 'Open';
            marketingSow.Financial_Year__c = 'FY2015';
            marketingSow.Oblix_AgencyEstimate__c = myAccount.Id;
        	marketingSow.RecordTypeId = Oblix_Utils.MapRecordType('Marketing_SOW__c').get('ParentSowMarketing');
            insert marketingSow;
            return marketingSow;
       }
 
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
                    PageReference pageref = Page.Oblix_VF01DeepCloneSOW ; 
                       Test.setCurrentPage(pageref) ;
                 
                  Oblix_Ctrl001DeepCloneSOW_CC controller = new Oblix_Ctrl001DeepCloneSOW_CC();
             	  Id sowId = createMaketingSow().id;
             	  ApexPages.currentPage().getParameters().put('sowId',sowId);
                  controller.sowRecordID=  sowId;
                  controller.isEnaughCopies= false;
                  controller.nextStageTypeSow ='0';
                  controller.canClone =false;
    
                  System.assertEquals(controller.canClone, false); // assert that the controller take the ID from params
                 
              //   controller.sowParent =  createMaketingSow ();
                 //controller.CloneSowParent();
                
                 controller.init();
                 
               Test.stopTest();
            }
         
    }
}