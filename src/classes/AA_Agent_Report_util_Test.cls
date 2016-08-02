@IsTest

public class AA_Agent_Report_util_Test {

    static testMethod void CallSendToChatterTest() {
    
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
       aa_Agent_Report__c unileverReport1 = new aa_Agent_Report__c(Report_Title__c = AA_Constants.ReportNameSample,Country__c =countryData.id,Reporting_on__c = AA_Constants.ReportingOnSample,Town__c = AA_Constants.TownSample,Retailer__c =retailerData.id,Agent_App_Unilever_Brand__c =uniBrand.id,TF_Mention_User__c='1234',TF_Topic_Name__c='2345',Status__c='Published (Public)',CreatedById=userinfo.getUserid());
       insert unileverReport1;
         aa_Agent_Report__c unileverReport2 = new aa_Agent_Report__c(Report_Title__c = AA_Constants.ReportNameSample,Country__c =countryData.id,Reporting_on__c = AA_Constants.ReportingOnSample,Town__c = AA_Constants.TownSample,Retailer__c =retailerData.id,Agent_App_Unilever_Brand__c =uniBrand.id,TF_Mention_User__c='1234',TF_Topic_Name__c='2345',Status__c='Published (Public)',CreatedById=userinfo.getUserid());
       insert unileverReport2;
         aa_Agent_Report__c unileverReport3 = new aa_Agent_Report__c(Report_Title__c = AA_Constants.ReportNameSample,Country__c =countryData.id,Reporting_on__c = AA_Constants.ReportingOnSample,Town__c = AA_Constants.TownSample,Retailer__c =retailerData.id,Agent_App_Unilever_Brand__c =uniBrand.id,TF_Mention_User__c='1234',TF_Topic_Name__c='2345',Status__c='Published (Public)',CreatedById=userinfo.getUserid());
       insert unileverReport3;
        List<aa_Agent_Report__c> listAgentNew =new List<aa_Agent_Report__c>();
        listAgentNew.add(unileverReport1);
        listAgentNew.add(unileverReport2);
        listAgentNew.add(unileverReport3);
           unileverReport1.Status__c= 'New';
        update unileverReport1;
           unileverReport2.Status__c= 'New';
        update unileverReport2;
        unileverReport3.Status__c= 'New';
        update unileverReport3;
        List<aa_Agent_Report__c> listAgentOld =new List<aa_Agent_Report__c>();
        listAgentOld.add(unileverReport1);
        listAgentOld.add(unileverReport2);
        listAgentOld.add(unileverReport3);
       test.starttest();
        aa_Agent_Report_util.addTosendChatter(unileverReport1);
        aa_Agent_Report_util.create_Chatter_posting(listAgentNew, listAgentOld);
    //  AA_theAgent_ChatterPost_FutureClass.CallSendToChatter(reportMap);
      system.assert(unileverReport1.id!=null);
       test.stoptest();
    }
}