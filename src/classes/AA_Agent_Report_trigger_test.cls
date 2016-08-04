@isTest
public class AA_Agent_Report_trigger_test {
    static testMethod void insertAgentApp_CompetitorTest() {
 Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
        
        AA_AgentAppServiceController obj =new AA_AgentAppServiceController();
       
        Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
        Id recTypeId1 = (RT1.get('Competitor Brand')).getRecordTypeId();
        
        
       aa_Agent_App_Competitor_Brand__c compBrand = new aa_Agent_App_Competitor_Brand__c(Name = AA_Constants.CompetitorBrandNameSample,RecordTypeId=recTypeId1);
       insert compBrand;
       aa_Agent_Competitor__c compName = new aa_Agent_Competitor__c(Name = AA_Constants.CompNameSample);
       insert compName;
       aa_Agent_App_Category__c compCategory = new aa_Agent_App_Category__c(Name = AA_Constants.CategorySample);
       insert compCategory;
       aa_Topic__c topic = new aa_Topic__c(Name = AA_Constants.Topicsample);
       insert topic;
       aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = AA_Constants.RetailerSample);
       insert retailerData;
       aa_Cluster__c clusterData = new aa_Cluster__c(Name = AA_Constants.ClusterSample);
       insert clusterData;
       aa_Country__c countryData = new aa_Country__c(Name = AA_Constants.CountrySample,Cluster_Id__c = clusterData.id);
       insert countryData;
       aa_Agent_Report__c competitorReport = new aa_Agent_Report__c(Report_Title__c = AA_Constants.CompReportTitle,Report_Description__c = AA_Constants.Stringwhatever ,Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = AA_Constants.TownSample,Retailer__c = retailerData.id,TF_Mention_User__c='12345',TF_Topic_Name__c='2345');
       insert competitorReport;
       List<string> userList=new List<string>{AA_Constants.StringFirstRandomNumber,AA_Constants.StringSecondRandomNumber};
       List<string> topicList=new List<string>{AA_Constants.StringFirstRandomNumber,AA_Constants.StringSecondRandomNumber};
       aa_Topic__c newtopic=new aa_Topic__c(Name=AA_Constants.Topicsample,Sub_Topic__c=AA_Constants.SubtopicSample);
       AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
       
       objAgentApp.ReportName = competitorReport.Report_Title__c;
       objAgentApp.ReportDesc = competitorReport.Report_Description__c;
       objAgentApp.CompetitorId = compName.id;
       objAgentApp.CompetitorBrandId = compBrand.id;
       objAgentApp.CategoryId = compCategory.id;
       objAgentApp.ClusterId = clusterData.id;
       objAgentApp.CodeOfConduct = 'true';
       objAgentApp.Source = competitorReport.Source__c;
       objAgentApp.Retailer = retailerData.Id;
       objAgentApp.ReportingOn = AA_constants.ReportingOnSample;
       objAgentApp.CountryId = countryData.id;
       objAgentApp.Town = AA_Constants.TownSample;
       objAgentApp.Latitude = AA_Constants.LatSample;
       objAgentApp.Longitude = AA_Constants.LongSample;
       objAgentApp.RecordTypeId = recTypeId;
       objAgentApp.TopicId=newtopic.Id;
       objAgentApp.SubTopic=newtopic.Sub_Topic__c;
       objAgentApp.usertomentionIds=userList; 
        objAgentApp.topicIds=topicList;    
       obj.convertRequestAgentReport_Competitor(objAgentApp);
       AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
       obj1.objAgentAppDataRequest = objAgentApp;
       obj.insertAgentApp_Competitor(obj1);
       obj.getCompetitorNameAndCategory_CompetitorReport(obj1);
       
       aa_Agent_App_Competitor_Brand__c uniBrand1 = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand,RecordTypeId=recTypeId1);
       insert uniBrand1;
       aa_Agent_Retailer__c retailerData1 = new aa_Agent_Retailer__c(Name = AA_Constants.RetailerSample);
       insert retailerData1;
       aa_Cluster__c clusterData1 = new aa_Cluster__c(Name =AA_Constants.ClusterSample);
       insert clusterData1;
       aa_Country__c countryData1 = new aa_Country__c(Name = AA_Constants.CountrySample,Cluster_Id__c = clusterData.id);
       insert countryData1;
       aa_Topic__c topic1=new aa_Topic__c();
       insert topic1;
       
       aa_Agent_Competitor__c competitor1=new aa_Agent_Competitor__c();
       insert competitor1;
       
       aa_Agent_App_Category__c cate=new aa_Agent_App_Category__c();
       insert cate;
       
       obj.getSourceRetailerTopicCountry_CompetitorReport(obj1);
       system.assertEquals(objAgentApp.ReportName,competitorReport.Report_Title__c);
    }
}