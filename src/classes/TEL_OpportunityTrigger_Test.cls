@isTest
public class TEL_OpportunityTrigger_Test {
    
    @testSetup
    public static void createData() {
        Account accObj = new Account();
        accObj.Name = 'Acc 1';
        System.Database.insert(accObj);
        
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'Opp 1';
        oppObj.AccountId = accObj.Id;
        oppObj.StageName = 'Transmitted';
        oppObj.CloseDate = Date.today().addDays(15);
        System.Database.insert(oppObj);
    }
    
    static testMethod void createOppLog() {
        Opportunity opp = [SELECT Id, StageName, CloseDate FROM Opportunity LIMIT 1];
        opp.StageName = 'Released';
        
        System.Test.startTest();
        System.Database.update(opp);
        System.Test.stopTest();
    }
}