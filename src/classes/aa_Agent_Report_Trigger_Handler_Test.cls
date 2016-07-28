@IsTest(seeAlldata=true)
public with sharing class aa_Agent_Report_Trigger_Handler_Test {

    //private static aa_Agent_Report__c objReport = null;
    static testMethod void callTriggerHandlerTest(){
        //insert new aa_Trigger_pattern__c(Name='aa_Agent_Report_Trigger',chk_Check_Run__c = TRUE);    
        //aa_Agent_Report_Trigger_Handler.aa_Agent_Report_Trigger_Handler();
        new aa_Agent_Report_Trigger_Handler().bulkBefore();
        new aa_Agent_Report_Trigger_Handler().bulkAfter();
        SObject so;
        SObject oldSo;
        //new aa_Agent_Report_Trigger_Handler().beforeInsert(so);
        /***********************/
        Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
       Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
       Id recTypeId1 = (RT1.get('Unilever Brand')).getRecordTypeId();
       
     //Insert Report
       aa_Agent_App_Competitor_Brand__c uniBrand = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand,RecordTypeId=recTypeId1);
       insert uniBrand;
       aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = AA_Constants.RetailerSample);
       insert retailerData;
       aa_Cluster__c clusterData = new aa_Cluster__c(Name = AA_Constants.ClusterSample);
       insert clusterData;
       aa_Country__c countryData = new aa_Country__c(Name = AA_Constants.CountrySample,Cluster_Id__c = clusterData.id);
       insert countryData;
       aa_Agent_Report__c unileverReport1 = new aa_Agent_Report__c(Report_Title__c = AA_Constants.ReportNameSample,Country__c =countryData.id,Reporting_on__c = AA_Constants.ReportingOnSample,Town__c = AA_Constants.TownSample,Retailer__c =retailerData.id,Agent_App_Unilever_Brand__c =uniBrand.id,TF_Mention_User__c='1234',TF_Topic_Name__c='2345',Status__c='New',CreatedById=userinfo.getUserid());
       insert unileverReport1;
        
       aa_Agent_Report__c unileverReport2 =[Select Id, Status__c From aa_Agent_Report__c Where Id=:unileverReport1.Id];
       unileverReport2.Status__c='Published (Public)';
       //unileverReport2 = new aa_Agent_Report__c(Report_Title__c = AA_Constants.ReportNameSample,Country__c =countryData.id,Reporting_on__c = AA_Constants.ReportingOnSample,Town__c = AA_Constants.TownSample,Retailer__c =retailerData.id,Agent_App_Unilever_Brand__c =uniBrand.id,TF_Mention_User__c='1234',TF_Topic_Name__c='2345',Status__c='Published (Public)',CreatedById=userinfo.getUserid());
       update unileverReport2; 
       //new aa_Agent_Report_Trigger_Handler().beforeUpdate(unileverReport1, unileverReport2);  
    
        /***********************/
        
        
        new aa_Agent_Report_Trigger_Handler().beforeDelete(so);
        new aa_Agent_Report_Trigger_Handler().afterInsert(so);
        new aa_Agent_Report_Trigger_Handler().afterUpdate(oldSo, so);
        new aa_Agent_Report_Trigger_Handler().afterDelete(so);
        new aa_Agent_Report_Trigger_Handler().andFinally();
    }
    
}