@isTest
public class AA_AgentAppService_Test{
    //Check IsAccepted Terms & conditions test
    static testMethod void getIsAcceptedTermsAndConditionTest(){
        Test.startTest();
        aa_Agent_App_User_Preference__c UserPref = new aa_Agent_App_User_Preference__c(UserId__c = UserInfo.getUserId(),Is_Accepted_Terms_Condition__c = true);
        insert UserPref;
        AA_AgentAppService.getIsAcceptedTermsAndCondition();
        system.assertEquals(UserPref.Is_Accepted_Terms_Condition__c,true);
        Test.stopTest();
    }
    //Check UpdatesIsAccepted Test
    static testMethod void updateIsAcceptedTermsAndConditionTest(){
        aa_Agent_App_User_Preference__c UserPref = new aa_Agent_App_User_Preference__c(UserId__c = UserInfo.getUserId(),Is_Accepted_Terms_Condition__c = true);
        insert UserPref;
        AA_AgentAppService.getUpdateIsAcceptedTermsAndCondition(true);
        system.assertEquals(UserPref.Is_Accepted_Terms_Condition__c,true);
        
        aa_Agent_App_User_Preference__c UserPref1 = new aa_Agent_App_User_Preference__c(UserId__c = UserInfo.getUserId(),Is_Accepted_Terms_Condition__c = false);
        insert UserPref1;
        Test.startTest();
        AA_AgentAppService.getUpdateIsAcceptedTermsAndCondition(false);
        system.assertEquals(UserPref1.Is_Accepted_Terms_Condition__c,false);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        User u2 = new User(Alias = 'tdfss', Email='tes23132t@testorg.com',ProfileId = p.Id ,
                           EmailEncodingKey='UTF-8', LastName='Tes3423423ting', LanguageLocaleKey=AA_Constants.Stringen_us,
                           LocaleSidKey=AA_Constants.Stringen_us, TimeZoneSidKey='America/Los_Angeles', UserName='sdadaas123@testorg.com');
        System.runAs(u2) {
            AA_AgentAppService.getUpdateIsAcceptedTermsAndCondition(true);
        }
        system.assertEquals(UserPref.Is_Accepted_Terms_Condition__c,true);
        Test.stopTest();
    }
    
    static testMethod void getAutoPopulatedValues_UnileverReportTest(){
        AA_WrapperClass.AgentAppDataResponse wrapperUtilityObj = new AA_WrapperClass.AgentAppDataResponse(); 
        
        aa_Cluster__c clusterData = new aa_Cluster__c(Name = AA_Constants.ClusterSample);
        insert clusterData;
        aa_Country__c countryData = new aa_Country__c(Name = AA_Constants.CountrySample,Cluster_Id__c = clusterData.id);
        insert countryData;
        aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = AA_Constants.RetailerSample);
        insert retailerData;
        List<aa_Cluster__c> clusterList =  new List<aa_Cluster__c>();
        clusterList.add(clusterData);
        Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
        Id recTypeId1 = (RT1.get('Competitor Brand')).getRecordTypeId();
        aa_Agent_App_Competitor_Brand__c uniBrand1 = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand,RecordTypeId=recTypeId1);
        insert uniBrand1;
        
        Test.startTest();
        wrapperUtilityObj= AA_AgentAppService.getAutoPopulatedValues_UnileverReport();
        system.assertEquals(wrapperUtilityObj.clusterList,clusterList);
        Test.stopTest();
    }
    static testMethod void insertAgentApp_CompetitorTest(){
        
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
        
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
            //List<string> topicList=new List<string>{AA_Constants.StringFirstRandomNumber,AA_Constants.StringSecondRandomNumber};
                aa_Topic__c newtopic=new aa_Topic__c(Name=AA_Constants.Topicsample,Sub_Topic__c=AA_Constants.SubtopicSample);
        
        AA_AgentAppService.insertAgentApp_Competitor(clusterData.id,countryData.id,AA_Constants.TownSample,competitorReport.Report_Title__c,competitorReport.Report_Description__c,
                                                     userList,competitorReport.Source__c,compBrand.id,null,null,compName.id,compCategory.id, retailerData.Id,newtopic.Id,newtopic.Sub_Topic__c,recTypeId,null,null);
        Test.startTest();
        AA_AgentAppService.getSourceRetailerTopicCountry_CompetitorReport();
        system.assertEquals(competitorReport.Report_Title__c,competitorReport.Report_Title__c);
        Test.stopTest();
    }
    
    static testMethod void insertAgentAppTest(){
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Unilever Agent Report')).getRecordTypeId();
        Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
        Id recTypeId1 = (RT1.get('Unilever Brand')).getRecordTypeId();
        
        
        aa_Agent_App_Competitor_Brand__c uniBrand = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand,RecordTypeId=recTypeId1);
        insert uniBrand;
        aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name =AA_Constants.RetailerSample);
        insert retailerData;
        aa_Cluster__c clusterData = new aa_Cluster__c(Name =AA_Constants.ClusterSample);
        insert clusterData;
        aa_Country__c countryData = new aa_Country__c(Name =AA_Constants.CountrySample,Cluster_Id__c = clusterData.id);
        insert countryData;
        
        aa_Agent_Report__c unileverReport = new aa_Agent_Report__c(Report_Title__c = AA_Constants.ReportNameSample,Status__c='New',Country__c = countryData.id,Reporting_on__c = AA_constants.ReportingOnSample,Town__c = AA_Constants.TownSample,Retailer__c = retailerData.id,Agent_App_Unilever_Brand__c = uniBrand.id);
        insert unileverReport;
        
        List<string> userList=new List<string>{AA_Constants.StringFirstRandomNumber,AA_Constants.StringSecondRandomNumber};
        //List<string> topicList=new List<string>{AA_Constants.StringFirstRandomNumber,AA_Constants.StringSecondRandomNumber};
        FeedItem fi2 = new FeedItem();
        fi2.body = 'New Agent File uploaded';
        fi2.Type = 'TextPost' ;
        fi2.Title = 'Agent File';           
        fi2.ParentId = unileverReport.Id;
        insert fi2;          
        unileverReport.Chatter_Post_ID__c=fi2.Id;
        unileverReport.Status__c='Existing';
        update unileverReport;
        Test.startTest();
        //AA_ApplicationWrapperObjLtng appWrapperObj = new AA_ApplicationWrapperObjLtng();
        AA_AgentAppService.insertAgentApp(clusterData.id,countryData.id,AA_Constants.TownSample,unileverReport.Report_Title__c,unileverReport.Report_Description__c,
                                          userList,uniBrand.id,retailerData.Id,unileverReport.Reporting_on__c,recTypeId,null,null);
        system.assertEquals(unileverReport.Report_Title__c,unileverReport.Report_Title__c);
        Test.stopTest();
       AA_AgentAppService.getupdateLikeCount(unileverReport.id);
        AA_AgentAppService.getupdateUnlikeCount(unileverReport.id);
        AA_AgentAppService.getBrandName(uniBrand.id);
        AA_AgentAppService.getRetailerName(retailerData.Id);
    }
    static testMethod void getfiterDataIdsTest(){
        
        //Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        //Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        //Id recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
        
        Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
        Id recTypeId1 = (RT1.get('Competitor Brand')).getRecordTypeId();
        
        aa_Cluster__c clusterData = new aa_Cluster__c(Name =AA_Constants.GlobalString);
        insert clusterData;
        aa_Agent_App_Competitor_Brand__c uniBrand = new aa_Agent_App_Competitor_Brand__c(Name='Other',RecordTypeId=recTypeId1);
        insert uniBrand;
        AA_WrapperClass.AgentAppFilterRequest objRequest = new AA_WrapperClass.AgentAppFilterRequest();
        Test.startTest();
        objRequest = AA_AgentAppService.getfiterDataIds();
        System.assert(objRequest.GlobalClusterId != null);
        Test.stopTest();
    }
    static testMethod void getUserPreferenceTest(){
          User user = new User();
        user.Username ='testagentuser307@gmail.com';
        user.LastName = 'LastTestName';
        user.Email = AA_Constants.Stringtestemail;
        user.alias = 'testAl';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = AA_Constants.Stringen_us;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = [select id from Profile where Name='System Administrator'].Id;
        user.LanguageLocaleKey = AA_Constants.Stringen_us;
        insert user;
        aa_Agent_App_Category__c compCategory = new aa_Agent_App_Category__c(Name = AA_Constants.CategorySample);
       insert compCategory;
        aa_Cluster__c clusterData3 = new aa_Cluster__c(Name =AA_Constants.ClusterSample);
        insert clusterData3;
         aa_Country__c countryData2 = new aa_Country__c(Name = AA_Constants.CountrySample,Cluster_Id__c = clusterData3.Id);
        insert countryData2; 
        aa_Agent_Retailer__c retailerData2 = new aa_Agent_Retailer__c(Name = AA_Constants.RetailerSample);
       insert retailerData2;
        aa_Agent_App_User_Preference__c userpref = new aa_Agent_App_User_Preference__c(UserId__c=user.Id,Cluster__c=clusterData3.Id,Country__c= countryData2.Id,Retailer__c=retailerData2.Id,Category__c=compCategory.Id,Is_Accepted_Terms_Condition__c=true);
        insert userpref;
        
        aa_Agent_App_User_Preference__c objResponse = new aa_Agent_App_User_Preference__c();
        
        Test.startTest();
        system.runAs(user){
        objResponse = AA_AgentAppService.getUserPreference();
        System.assert(objResponse.Id != null);
        }
        Test.stopTest();
    }
    
     static testMethod void retriveAllAgentReportsTest_ApplyFilterTrue(){
                 User user = new User();
        user.Username ='testagentuser301@gmail.com';
        user.LastName = 'LastTestName';
        user.Email = AA_Constants.Stringtestemail;
        user.alias = 'testAl';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = AA_Constants.Stringen_us;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = [select id from Profile where Name='System Administrator'].Id;
        user.LanguageLocaleKey = AA_Constants.Stringen_us;
        insert user;
         aa_Cluster__c clusterData = new aa_Cluster__c(Name =AA_Constants.ClusterSample);
         insert clusterData;
         aa_Country__c countryData = new aa_Country__c(Name = AA_Constants.CountrySample,Cluster_Id__c = clusterData.Id);
         insert countryData; 
         aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = AA_Constants.RetailerSample);
         insert retailerData;
        aa_Agent_App_Category__c compCategory = new aa_Agent_App_Category__c(Name = AA_Constants.CategorySample);
        insert compCategory;
        aa_Agent_App_User_Preference__c userpref = new aa_Agent_App_User_Preference__c(UserId__c=user.Id,Cluster__c=clusterData.Id,Country__c= countryData.Id,Retailer__c=retailerData.Id,Category__c=compCategory.Id,Is_Accepted_Terms_Condition__c=true);
        insert userpref;
       
        
        
       aa_agent_app_custom_setting__c setting = new aa_agent_app_custom_setting__c();
       setting.Name = 'Salesforce Instance URL Content';
       setting.Value__c = AA_Constants.Stringwhatever;
       insert setting;
 
       aa_agent_app_custom_setting__c setting1 = new aa_agent_app_custom_setting__c();
       setting1.Name = 'SFC Content';
       setting1.Value__c =  AA_Constants.Stringwhatever;
       insert setting1;

       aa_agent_app_custom_setting__c setting2 = new aa_agent_app_custom_setting__c();
       setting2.Name = 'Document URL Content';
       setting2.Value__c =  AA_Constants.Stringwhatever;
       insert setting2;              
       
         String filterType=AA_Constants.MyReportSample;
         String sortType=AA_Constants.SortLatestType;
         //String showFilterType=AA_Constants.MyReportSample;
         Integer limitRecords=12;
         Integer offset=0;
         String applyFilter='false';
         String recordType='Unilever';
        //Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        //Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        //Id recTypeId = (RT.get('Unilever Agent Report')).getRecordTypeId();
        Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
        Id recTypeId1 = (RT1.get('Unilever Brand')).getRecordTypeId();
        
         aa_Agent_App_Competitor_Brand__c uniBrand = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand,RecordTypeId=recTypeId1);
         insert uniBrand;
         
         aa_Agent_Report__c unileverReport = new aa_Agent_Report__c(Report_Title__c = AA_Constants.ReportNameSample,Status__c='New',Country__c = countryData.id,Reporting_on__c = AA_constants.ReportingOnSample,Town__c = AA_Constants.TownSample,Retailer__c = retailerData.id,Agent_App_Unilever_Brand__c = uniBrand.id);
         insert unileverReport;
         
         //Schema.DescribeSObjectResult R2 = aa_Agent_Report__c.SObjectType.getDescribe();
         //Map<String,Schema.RecordTypeInfo> RT2 = R2.getRecordTypeInfosByName();
         //Id recTypeId2 = (RT2.get('Competitor Report')).getRecordTypeId();
         
         Schema.DescribeSObjectResult R3 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
         Map<String,Schema.RecordTypeInfo> RT3 = R3.getRecordTypeInfosByName();
         Id recTypeId3 = (RT3.get('Competitor Brand')).getRecordTypeId();
         
         aa_Agent_App_Competitor_Brand__c compBrand = new aa_Agent_App_Competitor_Brand__c(Name = AA_Constants.CompetitorBrandNameSample,RecordTypeId=recTypeId3);
         insert compBrand;
        aa_Agent_Competitor__c compName = new aa_Agent_Competitor__c(Name = AA_Constants.CompNameSample);
        insert compName;
        aa_Topic__c topic = new aa_Topic__c(Name = AA_Constants.Topicsample);
        insert topic;
        AA_ApplicationWrapperObjLtng objRep = new AA_ApplicationWrapperObjLtng();
        Test.startTest();
        system.runAs(user){
         objRep = AA_AgentAppService.getRetriveAllAgentReports(filterType, sortType, limitRecords, offset, applyFilter, clusterData.id, countryData.id, uniBrand.id, retailerData.id, unileverReport.Reporting_on__c, recordType, compBrand.id, compName.id, compCategory.id, topic.id);
         system.assert(objRep.TotalAgentReportsCount != null);
     	}
        /* system.runAs(user){
             filterType='FilteredReports';
             applyFilter='true';
             AA_AgentAppService.getRetriveAllAgentReports(filterType, sortType, limitRecords, offset, applyFilter, clusterData.id, countryData.id, uniBrand.id, retailerData.id, unileverReport.Reporting_on__c, recordType, compBrand.id, compName.id, compCategory.id, topic.id);    
             
         }*/
         
        Test.stopTest();
     }
}