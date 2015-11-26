@isTest 
private class Oblix_Ctrl001DeepCloneSOW_CC_Test{

    static testMethod void controllerInitializationTest() {
        
        User u = Oblix_TestUtils.createTestUser();
         
        System.runAs(u){
            Marketing_SOW__c marketingSow = new Marketing_SOW__c();
                marketingSow.Active__c = true;
                marketingSow.Name = 'Marketinf Sow Approval Test';
                marketingSow.SOW_Status__c = 'Open';
                marketingSow.Financial_Year__c = 'FY2015';
                marketingSow.RecordTypeId = Oblix_Utils.MapRecordType('Marketing_SOW__c').get('ParentSowMarketing');
                try{
                  insert marketingSow;
               }catch(DMLException le){
                 
                  if(le.getMessage().contains('DUPLICATE_VALUE')){
                          marketingSow.Name = marketingSow.Name + Math.round(Math.random() * (10 - 1)) + 1;  
                           insert marketingSow;
                   }
                }  
            Marketing_Basics__c basicParent = new Marketing_Basics__c();
                basicParent.Oblix_SOWMarketing__c = marketingSow.Id;
                insert basicParent;
                
            Oblix_SOW_Projects__c project = new Oblix_SOW_Projects__c();
                project.Name = 'Project #2';
                project.Financial_Year__c = marketingSow.Id;
                insert project;
             System.assertEquals(project.Financial_Year__c, marketingSow.Id);
             
            Asset_Scoring__c assetScoring = new Asset_Scoring__c();
                assetScoring.Type__c = 'Static Imagery';
                assetScoring.Sub_Category__c = 'Origination';
                assetScoring.Point_Score__c = 150;
                insert assetScoring;
            
            Asset_Scoring__c assetScoring2 = new Asset_Scoring__c();
                assetScoring2.Type__c = 'Static Imagery';
                assetScoring2.Sub_Category__c = 'Adaptation';
                assetScoring2.Point_Score__c = 120;
                insert assetScoring2;   
                
                
            Oblix_Project_Assets__c asset = new Oblix_Project_Assets__c();
                asset.Quantity__c = 2;
                asset.Sub_Category__c = 'Origination';  
                asset.Agency_Projects__c = project.Id;
                asset.FULL_Description__c = assetScoring.Id;
                insert asset;
            
            //Clone : 
                Marketing_SOW__c marketingSowClone = new Marketing_SOW__c();
                marketingSowClone.Active__c = false;
                marketingSowClone.Name = 'Marketinq Sow Clone123456';
                marketingSowClone.SOW_Status__c = 'Open';
                marketingSowClone.Financial_Year__c = 'FY2015';   
                marketingSowClone.Type_of_SOW__c = 'Baseline'  ;
                marketingSowClone.MarketingSOWParent__c = marketingSow.Id;
                marketingSowClone.RecordTypeId = Oblix_Utils.MapRecordType('Marketing_SOW__c').get('ChildSowMarketing');
                insert marketingSowClone;
            Test.startTest();       
                 PageReference pageref = Page.Oblix_VF01DeepCloneSOW ; 
                  //Add params
                  pageRef.getParameters().put('sowId', marketingSow.Id);
                  pageRef.getParameters().put('fyear', marketingSow.Financial_Year__c);
                  Test.setCurrentPage(pageref) ;
                  Oblix_Ctrl001DeepCloneSOW_CC controller = new Oblix_Ctrl001DeepCloneSOW_CC();
                  
                    controller.init();
                    controller.CloneSowParent();
                        System.assertEquals(controller.nextStageTypeSow, marketingSowClone.Financial_Year__c+'Baseline');
                    marketingSowClone.Type_of_SOW__c = 'Q1';
                    update marketingSowClone;
                    controller.init();
                    controller.CloneSowParent();
                        //System.assertEquals(controller.nextStageTypeSow, marketingSowClone.Financial_Year__c+'Q1');
                    delete marketingSowClone;
                    controller.init();
                     System.assertEquals(controller.isEnaughCopies, false);
            Test.stopTest();    
        }
    }
}