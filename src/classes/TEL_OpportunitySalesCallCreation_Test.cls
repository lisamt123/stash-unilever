@isTest
public class TEL_OpportunitySalesCallCreation_Test {
	
    static testMethod void oppSalesCallCreation() {
        Account accObj = new Account();
        accObj.Name = 'Acc 1';
        //accObj.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'TEL_Telesales_Account' LIMIT 1].Id;
        accObj.Sales_ORG__c = 'ULUK';
        System.Database.insert(accObj);
        
        TEL_OpportunitySalesCallCreation.lstAccount = [SELECT Id FROM Account LIMIT 1];
        TEL_OpportunitySalesCallCreation.oppName = 'Telesales - Sales Call Quarter';
        TEL_OpportunitySalesCallCreation.oppRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND DeveloperName = 'TEL_Telesales' LIMIT 1].Id;
        TEL_OpportunitySalesCallCreation.oppStageName = 'Pending Call';
        
        TEL_SalesCallCreationScheduler salesCallCreation = new TEL_SalesCallCreationScheduler();
        DateTime dt = System.now().addSeconds(15);
        String sch = dt.second() + ' ' + dt.minute() + ' ' + dt.hour() + ' * * ?'; 
        String jobID = system.schedule('Sales Call Creation', sch, salesCallCreation);
    }
}