<<<<<<< HEAD
@IsTest
=======
@IsTest(SeeAllData=true)

>>>>>>> develop
public class AA_theAgent_ChatterPost_FutureClass_Test {

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
       aa_Agent_Report__c unileverReport = new aa_Agent_Report__c(Report_Title__c = AA_Constants.ReportNameSample,Country__c =countryData.id,Reporting_on__c = AA_Constants.ReportingOnSample,Town__c = AA_Constants.TownSample,Retailer__c =retailerData.id,Agent_App_Unilever_Brand__c =uniBrand.id,TF_Mention_User__c='1234',TF_Topic_Name__c='2345',Status__c='Published (Public)',CreatedById=userinfo.getUserid());
       insert unileverReport;
       Map<string,string> reportMap=new Map<string,string>();
       reportMap.put(unileverReport.Country__c ,JSON.serialize(unileverReport));
       test.starttest();
<<<<<<< HEAD
      // AA_theAgent_ChatterPost_FutureClass.CallSendToChatter(reportMap);
=======
      AA_theAgent_ChatterPost_FutureClass.CallSendToChatter(reportMap);
>>>>>>> develop
      system.assert(unileverReport.id!=null);
       test.stoptest();
    }
}