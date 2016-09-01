@IsTest

public class AA_Agent_Report_util_Test {

    static testMethod void CallSendToChatterTest() {
        User user = new User();
        user.Username ='testagentuserLightning307@gmail.com';
        user.LastName = 'LastTestName';
        user.Email = AA_Constants.Stringtestemail;
        user.alias = 'testAl';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = AA_Constants.Stringen_us;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = [select id from Profile where Name='System Administrator'].Id;
        user.LanguageLocaleKey = AA_Constants.Stringen_us;
        insert user;
        
        User user1 = new User();
        user1.Username ='testagentuserLightning308@gmail.com';
        user1.LastName = 'LastTestName';
        user1.Email = AA_Constants.Stringtestemail;
        user1.alias = 'testAl';
        user1.TimeZoneSidKey = 'America/New_York';
        user1.LocaleSidKey = AA_Constants.Stringen_us;
        user1.EmailEncodingKey = 'ISO-8859-1';
        user1.ProfileId = [select id from Profile where Name='System Administrator'].Id;
        user1.LanguageLocaleKey = AA_Constants.Stringen_us;
        insert user1;
    
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
       aa_Agent_Report__c unileverReport1 = new aa_Agent_Report__c(Report_Title__c = AA_Constants.ReportNameSample,
                                                                   Country__c =countryData.id,Reporting_on__c = AA_Constants.ReportingOnSample,Town__c = AA_Constants.TownSample,
                                                                   Retailer__c =retailerData.id,Agent_App_Unilever_Brand__c =uniBrand.id,TF_Mention_User__c='1234',TF_Topic_Name__c='2345',
                                                                   Status__c='Published (Public)',CreatedById=user.Id);
       insert unileverReport1;
         aa_Agent_Report__c unileverReport2 = new aa_Agent_Report__c(Report_Title__c = AA_Constants.ReportNameSample,Country__c =countryData.id,Reporting_on__c = AA_Constants.ReportingOnSample,Town__c = AA_Constants.TownSample,Retailer__c =retailerData.id,Agent_App_Unilever_Brand__c =uniBrand.id,TF_Mention_User__c='1234',TF_Topic_Name__c='2345',Status__c='Published (Public)',CreatedById=user.Id);
       insert unileverReport2;
         aa_Agent_Report__c unileverReport3 = new aa_Agent_Report__c(Report_Title__c = AA_Constants.ReportNameSample,Country__c =countryData.id,Reporting_on__c = AA_Constants.ReportingOnSample,Town__c = AA_Constants.TownSample,Retailer__c =retailerData.id,Agent_App_Unilever_Brand__c =uniBrand.id,TF_Mention_User__c='1234',TF_Topic_Name__c='2345',Status__c='Published (Public)',CreatedById=user1.Id);
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
        aa_Agent_Report_util.Agent_After_Insert(listAgentNew);
    //  AA_theAgent_ChatterPost_FutureClass.CallSendToChatter(reportMap);
      system.assert(unileverReport1.id!=null);
       test.stoptest();
    }
    
    static testMethod void CallDeleteAgentReportTest() {
         User user = new User();
        user.Username ='testagentuserLightning307@gmail.com';
        user.LastName = 'LastTestName';
        user.Email = AA_Constants.Stringtestemail;
        user.alias = 'testAl';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = AA_Constants.Stringen_us;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = [select id from Profile where Name='System Administrator'].Id;
        user.LanguageLocaleKey = AA_Constants.Stringen_us;
        insert user;
        
        User user1 = new User();
        user1.Username ='testagentuserLightning308@gmail.com';
        user1.LastName = 'LastTestName';
        user1.Email = AA_Constants.Stringtestemail;
        user1.alias = 'testAl';
        user1.TimeZoneSidKey = 'America/New_York';
        user1.LocaleSidKey = AA_Constants.Stringen_us;
        user1.EmailEncodingKey = 'ISO-8859-1';
        user1.ProfileId = [select id from Profile where Name='System Administrator'].Id;
        user1.LanguageLocaleKey = AA_Constants.Stringen_us;
        insert user1;
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
        aa_Agent_Report__c competitorReport = new aa_Agent_Report__c(Report_Title__c = AA_Constants.CompReportTitle,Report_Description__c = AA_Constants.Stringwhatever ,Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = AA_Constants.TownSample,Retailer__c = retailerData.id,TF_Mention_User__c='12345',TF_Topic_Name__c='2345',Status__c='Rejected',CreatedById=user.Id);
        insert competitorReport;
        aa_Agent_Report__c competitorReport1 = new aa_Agent_Report__c(Report_Title__c = AA_Constants.CompReportTitle,Report_Description__c = AA_Constants.Stringwhatever ,Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = AA_Constants.TownSample,Retailer__c = retailerData.id,TF_Mention_User__c='12345',TF_Topic_Name__c='2345',Status__c='Rejected',CreatedById=user.Id);
        insert competitorReport1;
        aa_Agent_Report__c competitorReport2 = new aa_Agent_Report__c(Report_Title__c = AA_Constants.CompReportTitle,Report_Description__c = AA_Constants.Stringwhatever ,Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = AA_Constants.TownSample,Retailer__c = retailerData.id,TF_Mention_User__c='12345',TF_Topic_Name__c='2345',Status__c='Rejected',CreatedById=user1.Id);
        insert competitorReport2;
       List<aa_Agent_Report__c> listAgentNew =new List<aa_Agent_Report__c>();
        listAgentNew.add(competitorReport);
        listAgentNew.add(competitorReport1);
        listAgentNew.add(competitorReport2);
        test.starttest();
        aa_Agent_Report_util.addTosendChatter(competitorReport);
        aa_Agent_Report_util.CallDeleteAgentReport(listAgentNew);
        aa_Agent_Report_util.AgentReportRejected_Email(listAgentNew);
         system.assert(competitorReport.id!=null);
        test.stoptest();
        
    }
         
}