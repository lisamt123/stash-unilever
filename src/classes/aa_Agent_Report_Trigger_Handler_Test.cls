@IsTest(seeAllData=true)
public with sharing class aa_Agent_Report_Trigger_Handler_Test {

    //private static aa_Agent_Report__c objReport = null;
    static testMethod void callTriggerHandlerTest(){

       SObject so=new aa_Agent_Report__c();
       SObject oldSo=new aa_Agent_Report__c();
       aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = AA_Constants.RetailerSample);
       insert retailerData;
       aa_Cluster__c clusterData = new aa_Cluster__c(Name = AA_Constants.ClusterSample);
       insert clusterData;
       aa_Country__c countryData = new aa_Country__c(Name = AA_Constants.CountrySample,Cluster_Id__c = clusterData.id);
       insert countryData;
       aa_Agent_Report__c unileverReport1 = new aa_Agent_Report__c(Report_Title__c = AA_Constants.ReportNameSample,Country__c =countryData.id,Reporting_on__c = AA_Constants.ReportingOnSample,Town__c = AA_Constants.TownSample,Retailer__c =retailerData.id,Status__c='New',CreatedById=userinfo.getUserid());
       insert unileverReport1;
        
       aa_Agent_Report__c unileverReport2 =[Select Id, Status__c From aa_Agent_Report__c Where Id=:unileverReport1.Id];
       unileverReport2.Status__c='Published (Public)';
       update unileverReport2; 
     
        
        new aa_Agent_Report_Trigger_Handler().beforeDelete(so);
        new aa_Agent_Report_Trigger_Handler().afterInsert(so);
        new aa_Agent_Report_Trigger_Handler().afterUpdate(oldSo, so);
        new aa_Agent_Report_Trigger_Handler().afterDelete(so);
        new aa_Agent_Report_Trigger_Handler().andFinally();

    }
    
}