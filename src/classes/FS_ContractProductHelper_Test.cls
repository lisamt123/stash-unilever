/**********************************************************************
Purpose: Test class for ContractProduct Trigger.
History :
VERSION  AUTHOR         DATE          DETAIL Description
1.0     Accenture     22/Aug/2016     Created
                          
***********************************************************************/
@isTest
private class FS_ContractProductHelper_Test {
    //@testSetup static void setupTestData(){
    static testMethod void test(){
    
        String profile_salesrep='Unilever - Salesforce MultiApp Standard';
        String profile='System Administrator';
        String permissionset='FS_Sales_Rep';         
        Profile p = [SELECT Id, Name FROM Profile WHERE Name=:profile];
        Profile p_rep = [SELECT Id, Name FROM Profile WHERE Name=:profile_salesrep];
        Userrole managerRole=[SELECT Id, Name FROM UserRole WHERE Name = 'FS 59005 East CDM Regional Manager'];
        
        User SysAdmin = new User(Alias = 'newUser', Email='newuser1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId=managerRole.id,
        TimeZoneSidKey='America/Los_Angeles', UserName='manager@testorg.com');
        insert SysAdmin;
        
        Userrole role=[SELECT Id, Name FROM UserRole WHERE Name = 'FS 59005 Sales Rep'];
        User SalesRepUser = new User(Alias = 'newsUser', Email='newuser1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p_rep.Id, UserRoleId=role.id,
        TimeZoneSidKey='America/Los_Angeles', UserName='salesrep@testorg.com', ManagerId=SysAdmin.id);
        insert SalesRepUser;
        
        PermissionSet ps = [SELECT Id, Name FROM PermissionSet WHERE Name =:permissionset];
        PermissionSetAssignment psetassignment = new PermissionSetAssignment();
        psetassignment.AssigneeId = SalesRepUser.Id;
        psetassignment.PermissionSetId = ps.Id;
        insert psetassignment;  
        
             
        system.runAs(SalesRepUser){
            FSOpportunityTriggerSettings__c OppCustomSettings=new FSOpportunityTriggerSettings__c(name='isEnabled',Enabled__c=true);
            insert OppCustomSettings;  
        Id accRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operator').getRecordTypeId();
        Account acc = new Account(Name = 'Bahama', recordtypeid= accRecType, CurrencyIsoCode = 'EUR' );
        INSERT acc;
        
        Contract con = new Contract();
        con.AccountId= acc.Id; 
        con.StartDate= Date.today();
        con.ContractTerm = 12;
        con.Status = 'Draft';
        con.CurrencyIsoCode = 'EUR';
        INSERT con;
        
        Id oppRecType1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Existing').getRecordTypeId();
        Opportunity oppExisting = new Opportunity(Name = 'Existing Opp', recordtypeid=oppRecType1,AccountId = acc.Id,StageName = '03 - Proposal',CloseDate = Date.today(), Contract=con);
        INSERT oppExisting;
        
        Id oppRecType2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity with Pricing (MA-BE)').getRecordTypeId();
        Opportunity oppNew = new Opportunity(Name = 'Opp1', recordtypeid=oppRecType2,AccountId = acc.Id,StageName = '03 - Proposal',CloseDate = Date.today(), Contract=con);
        INSERT oppNew;
        
        Product2 prod = new Product2(Name = 'Test Prod',isActive=true,MarketType__c='BOH MAYO',StartDate__c=date.today(),EndDate__c=date.today()+1,CanUseQuantitySchedule=true);
        Insert Prod;
        Id pricebookId = Test.getStandardPricebookId();
        PriceBookEntry pbe = new priceBookEntry ( pricebook2id = pricebookId,Product2Id = prod.id,  unitPrice = 1000, IsActive = true,UseStandardPrice = false); 
        insert pbe;
        
        OpportunityLineItem oppProd = new OpportunityLineItem(OpportunityId = oppNew.Id, Quantity = 500, PricebookEntryId = pbe.Id, TotalPrice = 3946725);
        insert oppProd;
        
        OpportunityLineItemSchedule schedule = new OpportunityLineItemSchedule(OpportunityLineItemId = oppProd.Id, Quantity= 500,ScheduleDate=date.today(), Type = 'Quantity');
        Insert schedule;
        
        oppNew.DealApproved__c = true;
        oppNew.AgreementDate__c = date.today();
        oppNew.StageName = '04 - Verbal Commitment';
        UPDATE oppNew;
        oppNew.StageName = '05 – Won';
        UPDATE oppNew;
        
        
    }}
}