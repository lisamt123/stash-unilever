@isTest(seeAllData=true)
private class NFS_OpportunityTrigger_Test {
    static testMethod void OppUnitTest() {
      
        Test.startTest();
            Account acc= new Account();
            acc.Name = 'Test Customer';
            insert acc;
            
            Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true);
            
            Opportunity opp = new Opportunity();
            opp.StageName = 'Sourcing Demand';
            opp.CloseDate = System.today();
            opp.AccountId = acc.id;
            opp.Name = 'Test Opportunity Triggers';
            insert opp;
            opp.StageName='Shipped';
            update opp;
            
            
        Test.stopTest();
        
    }
    
}