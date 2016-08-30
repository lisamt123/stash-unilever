@isTest(seeAllData=false)
Public class FS_SendMDMRequestEmail_CX_Test{
    @isTest static void SendMDMRequest() {
        
        //Set up Custom settings for Opportunity Trigger
        FSOpportunityTriggerSettings__c OppCustomSettings=new FSOpportunityTriggerSettings__c(name='isEnabled',Enabled__c=true);
        insert OppCustomSettings; 
    
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
                     FS_Title__c = 'FS_Title__c'
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
        
        /*FS_MDMRequestRecipient__c emailRecipient = new FS_MDMRequestRecipient__c(
                Name = 'testEmail',
                FS_EmailAddress__c = 'test@test.com' 
                );
        insert emailRecipient;*/
        
        Id operatorAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        Id distributorAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
              
        //set operatorAccount
        Account operatorAccount = new Account(
            Name = 'Operator Account',
            RecordTypeId = operatorAccountRecordType
            
        );
        insert operatorAccount;
        
        //set distributorAccount
        Account distributorAccount = new Account(
            Name = 'Account Distributor',
            RecordTypeId = distributorAccountRecordType
        );
        insert distributorAccount;
        
        //set Product
        Product2 prod = new Product2();
        prod.Name = 'Product Test';
        prod.StartDate__c = date.today();
        prod.EndDate__c = date.today() + 30;
        prod.MarketType__c='BOH MAYO';
        prod.IsActive = true;
        prod.FS_stdPerUnit__c = 333.23;
        prod.FS_temporaryTPR__c = 0.00;
        prod.FS_VATRU__c = 2;
        prod.FS_VATUA__c = 2;
        prod.FS_ZSU__c = 4;
        insert prod;
        
        //Fetch standard Price Book     
        System.debug('Test.getStandardPricebookId(): ' + Test.getStandardPricebookId());
        Id pricebookId = Test.getStandardPricebookId();
        
        //set PricebookEntry
        PriceBookEntry pbe = new PriceBookEntry();
        pbe.Pricebook2Id = pricebookId;
        pbe.Product2Id = prod.Id;
        pbe.UnitPrice = 2631.15;
        pbe.IsActive = true;
        pbe.UseStandardPrice = false;
        pbe.CurrencyIsoCode = 'RUB';
        pbe.FS_salesOrgCode__c = 'R002';
        
        insert pbe;     
        
        //set Opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.AccountId = operatorAccount.Id;
        opp.FS_distributor__c = distributorAccount.Id;
        opp.StageName = '01 – Universe';
        opp.CloseDate = date.today() + 30;
        opp.CurrencyIsoCode = 'RUB';
        opp.FS_casesPiece__c = 'piece';
        opp.FS_DateOfSend__c = date.today();
        opp.FS_endDateTPR__c = date.today() + 30;        
        opp.FS_selfCollection__c = true;
        opp.FS_prePaid__c = true;
        opp.Owner =[SELECT Id, Email FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        insert opp;  
        
        OpportunityLineItem oppProd = new OpportunityLineItem();
            oppProd.OpportunityId = opp.Id;
            oppProd.Quantity = 500;
            oppProd.PricebookEntryId = pbe.Id;
            oppProd.TotalPrice = 3946725;
            oppProd.FS_tprPercent__c = 2;
        insert oppProd;
        
        
        // Create an approval request for the opportunity
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setObjectId(opp.id);
        
        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('FS_TPR_Opportunity_Process');
        req1.setSkipEntryCriteria(true);
        
        // Submit the approval request for the opportunity
        Approval.ProcessResult result = Approval.process(req1);
        
        
        PageReference pageRef = Page.FS_SendMDMRequestEmail;
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(opp);
        FS_SendMDMRequestEmail_CX controller = new FS_SendMDMRequestEmail_CX(stdController);
        
        controller.createExcelAttachment();
        controller.returnToOpportunity();
     }       
}