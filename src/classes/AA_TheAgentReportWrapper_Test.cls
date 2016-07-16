@isTest
private class AA_TheAgentReportWrapper_Test {

    static testMethod void myUnitTest() {
       Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
       Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
       Id recTypeId = (RT.get('Unilever Agent Report')).getRecordTypeId();
       
        Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
        Id recTypeId1 = (RT1.get('Unilever Brand')).getRecordTypeId();
        
        
       aa_Agent_App_Competitor_Brand__c uniBrand = new aa_Agent_App_Competitor_Brand__c(Name='Dove',RecordTypeId=recTypeId1);
       insert uniBrand;
       aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = '7-Eleven');
       insert retailerData;
       aa_Cluster__c clusterData = new aa_Cluster__c(Name = 'South Asia');
       insert clusterData;
       aa_Country__c countryData = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
       insert countryData;
       aa_Agent_Report__c unileverReport = new aa_Agent_Report__c(Report_Title__c = 'Unilever Report 1',Country__c = countryData.id,Reporting_on__c = 'Look-a-like',Town__c = 'Pune',Retailer__c = retailerData.id,Agent_App_Unilever_Brand__c = uniBrand.id);
       insert unileverReport;
       
       
       AA_TheAgentReportWrapper obj = new AA_TheAgentReportWrapper();
       AA_TheAgentReportWrapper obj1 = new AA_TheAgentReportWrapper(unileverReport);
       system.assert(obj != null);
       
       aa_Agent_Report__c report=new aa_Agent_Report__c(Report__c='test test');
       obj.display_report_summary(report);
       
       aa_Agent_Report__c report1=new aa_Agent_Report__c(Report__c='test testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest t testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtest testtesttest');
       obj.display_report_summary(report1);
      
       aa_Agent_Report__c report2=new aa_Agent_Report__c(report_title__c='test');
      // ContentDocumentLink =new ContentDocumentLink(LinkedEntityId=report2.Id);
       StaticResource res=new StaticResource(Name='test'); 
     
      AA_TheAgentReportWrapper.GetResourceURL('test');
      AA_TheAgentReportWrapper.GetResourceURL('tesForceTK');
      
      obj.first_chatter_pic_content_id(unileverReport);
      obj.first_chatter_pic_id(unileverReport);
     // obj1.get_number_of_likes(unileverReport);
    
    }
}