@isTest(seeAllData=false)
Public class FS_SendEmailWithMDMRequest_CX_Test{
    
    static Opportunity opp;
    static OpportunityLineItem oppProd;
    static PriceBookEntry pbe;
    static Product2 prod;
    static Account distributorAccount;
    static Account operatorAccount;
    static User testUser;
    
    @isTest static void SendMDMRequest() {
        
        setData();

        system.runAs(testUser){
	        opp = createOpportunity();
	        opp.FS_MDMRequestSent__c = false;
	        insert opp;
	        
	        oppProd = createOLI();
	        insert oppProd;
	        
	        
	        // Create an approval request for the opportunity
	        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
	        req1.setObjectId(opp.id);
	        
	        // Submit the record to specific process and skip the criteria evaluation
	        req1.setProcessDefinitionNameOrId('FS_TPR_Opportunity_Process');
	        req1.setSkipEntryCriteria(true);
	        
	        // Submit the approval request for the opportunity
	        Approval.ProcessResult result = Approval.process(req1);
	        system.assert(result <> null);//Avoid Sonarcube error 'unused local variables'
	        
	        
	        PageReference pageRef = Page.FS_SendEmailWithMDMRequest;
	        Test.setCurrentPage(pageRef);
	        
	        ApexPages.StandardController stdController = new ApexPages.StandardController(opp);
	        FS_SendEmailWithMDMRequest_CX controller = new FS_SendEmailWithMDMRequest_CX(stdController);
	        
	        controller.identifyAction();
	        controller.sendEmailAttachment();
	        controller.returnToOpportunity();
	        controller.getMDMDefaultValue();        
        }
    } 
    
        
    static void setData(){
    	FS_UtilTestDataSetup testData=new FS_UtilTestDataSetup();
        testUser = testData.createTestUser();
        
        system.runAs(testUser){ 
        
	        //set up custom setting for opportunity stages
            testData.setUpOpportunityStages();
            //Set up Custom settings for Opportunity Trigger
            testdata.enableOpportunityTrigger(); 
	    
	        //Custom Settings
	        FS_MDMEmailRequestDefaultValue__c MDMDefaultValue = 
	                 New FS_MDMEmailRequestDefaultValue__c( 
	                     FS_ApprovedByText__c = 'FS_ApprovedByText__c',
	                     FS_CaptionText__c = 'FS_CaptionText__c',
	                     FS_CompanyAddress__c = 'FS_CompanyAddress__c',
	                     FS_CompanyCity__c = 'FS_CompanyCity__c',
	                     FS_CompanyFax__c = '111-11-11',
	                     FS_CompanyFaxText__c = 'FS_CompanyFaxText__c',
	                     FS_CompanyName__c = 'FS_CompanyName__c',
	                     FS_CompanyNote__c = 'FS_CompanyNote__c',
	                     FS_CompanyPhone__c = '111-11-11',
	                     FS_CompanyPhoneText__c = 'FS_CompanyPhoneText__c',
	                     FS_ConditionTypeValue__c = 'FS_ConditionTypeValue__c',
	                     FS_FinanceManagerName__c = 'FS_FinanceManagerName__c',
	                     FS_FinanceManagerPosition__c =  'FS_FinanceManagerPosition__c',
	                     FS_NameText__c = 'FS_NameText__c',
	                     FS_PositionText__c = 'FS_PositionText__c',
	                     FS_SalesManagerName__c = 'FS_SalesManagerName__c',
	                     FS_SalesManagerPosition__c = 'FS_SalesManagerPosition__c',
	                     FS_SalesOrganisation__c = 'FS_SalesOrganisation__c',
	                     FS_TargetOfDiscountValue__c = 'FS_TargetOfDiscountValue__c',
	                     FS_Title__c = 'FS_Title__c',
	                     FS_AttachmentFileName__c = 'FS_AttachmentFileName__c',
	                     FS_ExcelAttachmentFileName__c = 'FS_ExcelAttachmentFileName__c'
	                 );
	        insert MDMDefaultValue;
	        
	        FS_MDMEmailRequestTemplate__c MDMTemplate = 
	                New FS_MDMEmailRequestTemplate__c(
	                    FS_Amount__c = 'FS_Amount__c',
	                    FS_ConditionType__c = 'FS_ConditionType__c',
	                    FS_CustomerCode__c = 'FS_CustomerCode__c',
	                    FS_CustomerCodeDescription__c = 'FS_CustomerCodeDescription__c',
	                    FS_HierarchyLevel__c = 'FS_HierarchyLevel__c',
	                    FS_InternalOrder__c = 'FS_InternalOrder__c',
	                    FS_MaterialCode__c = 'FS_MaterialCode__c',
	                    FS_MaterialDescription__c = 'FS_MaterialDescription__c',
	                    FS_ProductExpirationDate__c = 'FS_ProductExpirationDate__c',
	                    FS_ProductHierarchy__c = 'FS_ProductHierarchy__c',
	                    FS_SalesOrganisation__c = 'FS_SalesOrganisation__c',
	                    FS_TargetOfDiscount__c = 'FS_TargetOfDiscount__c',
	                    FS_Unit__c = 'FS_Unit__c',
	                    FS_ValidityEnd__c = 'FS_ValidityEnd__c',
	                    FS_ValidityStart__c = 'FS_ValidityStart__c'
	                );
	        insert MDMTemplate;
	        
	        FS_MDMRequestPageMessages__c MDMPageMessage = 
	                New FS_MDMRequestPageMessages__c (
	                    FS_NotApprovedMessage__c = 'FS_NotApprovedMessage__c',
	                    FS_AlreadySentMessage__c = 'FS_AlreadySentMessage__c',
	                    FS_NoAccessMessage__c = 'FS_NoAccessMessage__c'
	                    );
	        insert MDMPageMessage;
	        
	        FS_MDMRequestRecipient__c emailRecipient = new FS_MDMRequestRecipient__c(
	                Name = 'testEmail',
	                FS_EmailAddress__c = 'test@test.com' 
	                );
	        insert emailRecipient;
	        
	        Id operatorAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
	        Id distributorAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
	              
	        //set operatorAccount
	        operatorAccount = new Account(
	            Name = 'Operator Account',
	            RecordTypeId = operatorAccountRecordType
	            
	        );
	        insert operatorAccount;
	        
	        //set distributorAccount
	        distributorAccount = new Account(
	            Name = 'Account Distributor',
	            RecordTypeId = distributorAccountRecordType
	        );
	        insert distributorAccount;
	        
	        //set Product
	        prod = new Product2();
	        prod.Name = 'Product Test';
	        prod.StartDate__c = date.today();
	        prod.EndDate__c = date.today() + 30;
	        prod.MarketType__c='BOH MAYO';
	        prod.IsActive = true;
	        prod.FS_stdPerUnit__c = 333.23;
	        prod.FS_VATRU__c = 2;
	        prod.FS_VATUA__c = 2;
	        prod.FS_ZSU__c = 4;
	        insert prod;
	        
	        //Fetch standard Price Book     
	        System.debug('Test.getStandardPricebookId(): ' + Test.getStandardPricebookId());
	        Id pricebookId = Test.getStandardPricebookId();
	        
	        //set PricebookEntry
	        pbe = new PriceBookEntry();
	        pbe.Pricebook2Id = pricebookId;
	        pbe.Product2Id = prod.Id;
	        pbe.UnitPrice = 2631.15;
	        pbe.IsActive = true;
	        pbe.UseStandardPrice = false;
	        pbe.CurrencyIsoCode = 'RUB';
	        pbe.FS_salesOrgCode__c = 'R002';
	        
	        insert pbe;     
	        
	        //set Opportunity
	        opp = new Opportunity();
	        opp.Name = 'Test Opportunity';
	        opp.AccountId = operatorAccount.Id;
	        opp.FS_distributor__c = distributorAccount.Id;
	        opp.StageName = '01 – Universe';
	        opp.CloseDate = date.today() + 30;
	        opp.CurrencyIsoCode = 'RUB';
	        opp.FS_casesPiece__c = 'piece';
	        opp.FS_endDateTPR__c = date.today() + 30;        
	        opp.FS_selfCollection__c = true;
	        opp.FS_prePaid__c = true;
	        opp.Owner =[SELECT Id, Email FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
	        insert opp;  
	        
	            oppProd = new OpportunityLineItem();
	            oppProd.OpportunityId = opp.Id;
	            oppProd.Quantity = 500;
	            oppProd.PricebookEntryId = pbe.Id;
	            oppProd.TotalPrice = 3946725;
	            oppProd.FS_tprPercent__c = 2;
	        insert oppProd;
        
        }
        
     }  
     
     static Opportunity createOpportunity(){
        Opportunity oppRecord = null;
         
        //set Opportunity
        oppRecord = new Opportunity();
        oppRecord.Name = 'Test Opportunity';
        oppRecord.AccountId = operatorAccount.Id;
        oppRecord.FS_distributor__c = distributorAccount.Id;
        oppRecord.StageName = '01 – Universe';
        oppRecord.CloseDate = date.today() + 30;
        oppRecord.CurrencyIsoCode = 'RUB';
        oppRecord.FS_casesPiece__c = 'piece';
        oppRecord.FS_endDateTPR__c = date.today() + 30;        
        oppRecord.FS_selfCollection__c = true;
        oppRecord.FS_prePaid__c = true;
        oppRecord.Owner =[SELECT Id, Email FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        
        return oppRecord;
     }
     
     static OpportunityLineItem createOLI(){
        OpportunityLineItem oLI = null;
            oLI = new OpportunityLineItem();
            oLI.OpportunityId = opp.Id;
            oLI.Quantity = 500;
            oLI.PricebookEntryId = pbe.Id;
            oLI.TotalPrice = 3946725;
            oLI.FS_tprPercent__c = 2;
        return oLI;
     }     
}