/**********************************************************************
Name:  CEC_CaseTransferControllerTest
Copyright @ 2015  Unilever
======================================================================
=======================================================================
Purpose: This is the test class for CEC_CaseTransferController.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0        Mahesh           May-2016        INITIAL DEVELOPMENT   
***********************************************************************/
@isTest
public class CEC_CaseTransferControllerTest {
    static list<String> countries = new list<String>{'India','United Kingdom'};
    @testSetup static void setUpTestData() {
        
        User usr = CEC_TestDataFactory.createStandardCECTestUser();
        Group ukQueue = CEC_TestDataFactory.createQueue('CEC UKI Queue','Queue',new List<String> {'case','CEC_Case_Market_Mapping__c'},UserInfo.getUserId());
        Group indQueue = CEC_TestDataFactory.createQueue('CEC India Queue','Queue',new List<String> {'case','CEC_Case_Market_Mapping__c'},UserInfo.getUserId());
        Id defaultAcctOwnerId = userInfo.getUserId();      
        System.runas(usr){ 

            List<mdm_Product_Category__c> prodCategoryList = CEC_TestDataFactory.createProductCategory(5);
            insert prodCategoryList;
            
            List<mdm_Case_Product__c> caseProductList = CEC_TestDataFactory.createCaseProduct(1, prodCategoryList.get(0).Id);
            insert caseProductList;
            
            List<mdm_Global_Listening_Tree__c> globalListeningTreeList =  CEC_TestDataFactory.createGlobalListeningTree(1);
            insert globalListeningTreeList;
            
            List<mdm_Reason_Code__c> reasonCodeList = CEC_TestDataFactory.createReasonCode(1, globalListeningTreeList.get(0).Id);
            insert reasonCodeList;
            
            List<CEC_Case_Market_Mapping__c> cmmList = CEC_TestDataFactory.createCaseMarketMapping(countries[1],1); 
            cmmList.addAll(CEC_TestDataFactory.createCaseMarketMapping(countries[0],1)); 
            cmmList.addAll(CEC_TestDataFactory.createCaseMarketMapping('United States',200)); 
              
            CEC_Case_Market_Mapping__c cmmUk,cmmInd = new CEC_Case_Market_Mapping__c();
            list<CEC_Case_Market_Mapping__c> updCaseMrktMapOwner = new list<CEC_Case_Market_Mapping__c>();
            for(CEC_Case_Market_Mapping__c cmm : [SELECT Id,Market__c,Country__r.ISO_Country_Dependency_Medium_Name__c FROM CEC_Case_Market_Mapping__c
                                                 WHERE Market__c = :countries[1] OR Market__c = :countries[0]]) {
                if (cmm.Market__c == countries[1]) {
                     cmmUk = cmm;

                }else if (cmm.Market__c == countries[0]) {
                     cmmInd = cmm;
                    
                }
            }
            cmmUk.OwnerId = ukQueue.Id;
            cmmInd.OwnerId = indQueue.Id;
            cmmUk.DefaultAccountOwnerId__c =  defaultAcctOwnerId;
            cmmInd.DefaultAccountOwnerId__c =  defaultAcctOwnerId;
            updCaseMrktMapOwner.add(cmmUk);
            updCaseMrktMapOwner.add(cmmInd);
            update updCaseMrktMapOwner;
            
           
            List<cec_Store__c> stores = CEC_TestDataFactory.createStore(new List<String>{'United Kingdom'}); 
           
            system.debug('******stores*******'+ stores);
            List<Account> accounts = CEC_TestDataFactory.createTestAccounts(1,'john','john@yahoo.unilever.com','101 street','56789','New York','USA','Frequent');
            insert accounts;
       
            List<case> cases =  CEC_TestDataFactory.createTestCases(1,'New','Email','','',caseProductList[0].Id,reasonCodeList[0].Id,accounts[0].Id,cmmUk.Id,false);
            cases[0].store__c = stores[0].Id;
            insert cases; 
            cases = [SELECT Case_Market_Mapping_Country__c,Country_Name__c,Case_Market__c, Country__c, Country__r.name, owner.Name, Store__c, Store__r.name, 
                                    CEC_Product__r.Name, Account.Name, Reason_Code__c, Reason_Code__r.Name FROM case limit 1];
            System.debug('******cases*********'+ cases);
            
            
            
          }
         
    }
    
      static testMethod void NoSearchInputTest(){
           User usr = CEC_TestDataFactory.getStandardCECTestUser();
          
          System.runas(usr){
              case cse = [SELECT Id FROM case limit 1];
              ApexPages.StandardController controller = new ApexPages.StandardController(cse);
              CEC_CaseTransferController caseTransferCtrl = new CEC_CaseTransferController(controller);
              caseTransferCtrl.searchMarketMap();
              ApexPages.Message[] pageMessages = ApexPages.getMessages();
              System.assertNotEquals(0, pageMessages.size());
              
              for(ApexPages.Message message : pageMessages) {
                  System.assertEquals(Label.CEC_EnterMktMappingMsg, message.getSummary()); 
                  System.assertEquals( ApexPages.Severity.Info,message.getSeverity()); 
                  System.assertEquals(Label.CEC_EnterMktMappingMsg,message.getDetail()); 
              }
             
          }
      }
    
    static testMethod void searchMktNoInpTest(){
           User usr = CEC_TestDataFactory.getStandardCECTestUser();
          
          System.runas(usr){
              case cse = [SELECT Id,Case_Market__c FROM case limit 1];
              ApexPages.StandardController controller = new ApexPages.StandardController(cse);
              CEC_CaseTransferController caseTransferCtrl = new CEC_CaseTransferController(controller);
              caseTransferCtrl.marketMapping = countries[1];
              caseTransferCtrl.searchMarketMap();
              ApexPages.Message[] pageMessages = ApexPages.getMessages();
              System.assertNotEquals(0, pageMessages.size());
              
              for(ApexPages.Message message : pageMessages) {
                  System.assertEquals(Label.CEC_NoResultFoundMsg, message.getSummary()); 
                  System.assertEquals( ApexPages.Severity.Info,message.getSeverity()); 
                  System.assertEquals(Label.CEC_NoResultFoundMsg,message.getDetail()); 
              }
              
              
          }
      }
    static testMethod void searchMktMoreThan200(){
           User usr = CEC_TestDataFactory.getStandardCECTestUser();
          
          System.runas(usr){
              case cse = [SELECT Id,Case_Market__c FROM case limit 1];
              List<CEC_Case_Market_Mapping__c> caseMktMappings = [SELECT Id, Name, Market__c, Language__c, Country__r.ISO_3166_1_Code__c, DefaultCaseOwnerId__c, Country__r.Name FROM CEC_Case_Market_Mapping__c limit 250];
              system.debug('******caseMktMappings******'+ caseMktMappings.size());
              ApexPages.StandardController controller = new ApexPages.StandardController(cse);
              CEC_CaseTransferController caseTransferCtrl = new CEC_CaseTransferController(controller);
              caseTransferCtrl.marketMapping = 'United';
              caseTransferCtrl.searchMarketMap();
              system.debug('******controller caseMarketMappings******'+ caseTransferCtrl.caseMarketMappings.size());
              ApexPages.Message[] pageMessages = ApexPages.getMessages();
              System.assertNotEquals(0, pageMessages.size());
              
              for(ApexPages.Message message : pageMessages) {
                  System.assertEquals(Label.CEC_SearchWarningMsg, message.getSummary()); 
                  System.assertEquals( ApexPages.Severity.Warning,message.getSeverity()); 
                  System.assertEquals(Label.CEC_SearchWarningMsg,message.getDetail()); 
              }
              
          }
      }
    
    
     static testMethod void testTransCaseNoRecordSelection(){
           User usr = CEC_TestDataFactory.getStandardCECTestUser();
          
          System.runas(usr){
              case cse = [SELECT Id,Case_Market__c FROM case limit 1];
              List<CEC_Case_Market_Mapping__c> caseMktMappings = [SELECT Id, Name, Market__c, Language__c, Country__r.ISO_3166_1_Code__c, DefaultCaseOwnerId__c, Country__r.Name FROM CEC_Case_Market_Mapping__c
                                                                  WHERE Name ='India'];
              system.debug('******caseMktMappings******'+ caseMktMappings.size());
              ApexPages.StandardController controller = new ApexPages.StandardController(cse);
              CEC_CaseTransferController caseTransferCtrl = new CEC_CaseTransferController(controller);
              caseTransferCtrl.marketMapping = 'India';
              caseTransferCtrl.searchMarketMap();
              system.debug('******controller caseMarketMappings******'+ caseTransferCtrl.caseMarketMappings.size());
              caseTransferCtrl.transferCase();
              
              ApexPages.Message[] pageMessages = ApexPages.getMessages();
              System.assertNotEquals(0, pageMessages.size());
               for(ApexPages.Message message : pageMessages) {
                  System.assertEquals(Label.CEC_SelectMktMappingMsg, message.getSummary()); 
                  System.assertEquals( ApexPages.Severity.Info,message.getSeverity()); 
                  System.assertEquals(Label.CEC_SelectMktMappingMsg,message.getDetail()); 
              }
                           
          }
      }
    
    static testMethod void testTransferCase(){
           User usr = CEC_TestDataFactory.getStandardCECTestUser();
          
          System.runas(usr){
              List<CEC_Case_Market_Mapping__c> caseMktMappings = [SELECT Id, Account_Owner_Active_Flag__c,Name, Market__c, Language__c, Country__r.ISO_3166_1_Code__c, DefaultCaseOwnerId__c,DefaultAccountOwnerId__c, Country__r.Name FROM CEC_Case_Market_Mapping__c
                                                                  WHERE Name ='India' ];
              
              case cse = [SELECT Id,Case_Market__c, Country__c, Country__r.name,CMM_Account_Owner_Active_Flag__c,DefaultCMMAccountOwner_Id__c,
                          owner.Name, Store__c, Store__r.name, 
                          CEC_Product__r.Name, Account.Name, Reason_Code__c, Reason_Code__r.Name FROM case limit 1];

              system.debug('******caseMktMappings******'+ caseMktMappings.size());
              ApexPages.StandardController controller = new ApexPages.StandardController(cse);
              CEC_CaseTransferController caseTransferCtrl = new CEC_CaseTransferController(controller);
              caseTransferCtrl.marketMapping = countries[0];
              caseTransferCtrl.searchMarketMap();
              system.debug('******controller caseMarketMappings******'+ caseTransferCtrl.caseMarketMappings.size());
              caseTransferCtrl.caseMktMapIdStr = caseMktMappings[0].id;
              caseTransferCtrl.transferCase();
              Case caseAftermktTransfer = [SELECT Id,Case_Market__c, Country__c, Country__r.name, owner.Name, Store__c, 
                                          CEC_Product__c, AccountId, Reason_Code__c FROM case WHERE Id =: cse.id];
              System.assertEquals(1, [SELECT id FROM casecomment WHERE ParentId =:cse.id].size()); 
              System.assertEquals(null, caseAftermktTransfer.Store__c);
              System.assertEquals('India', caseAftermktTransfer.Country__r.name);
              System.assertEquals(null, caseAftermktTransfer.CEC_Product__c);
              //System.assertEquals(null, caseAftermktTransfer.AccountId);
              System.assertEquals(null, caseAftermktTransfer.Reason_Code__c);
              
          }
      }
    
   
}