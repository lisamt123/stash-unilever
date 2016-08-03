@isTest
/**
 * Name:        -   AA_AgentAppService_Test
 * @description -   This is the test class for AA_AgentAppService Class to verify the code  for the services requested from frontend & which includes the business logic.
 * @Author      -   Ipsita S    
 */
private class AA_AgentAppService_Test {      
        
   //Check IsAccepted Terms & conditions test
    static testMethod void getIsAcceptedTermsAndConditionTest(){
    Test.startTest();
        aa_Agent_App_User_Preference__c UserPref = new aa_Agent_App_User_Preference__c(UserId__c = UserInfo.getUserId(),Is_Accepted_Terms_Condition__c = true);
        insert UserPref;
        
        aa_Agent_App_User_Preference__c UserPref1 = new aa_Agent_App_User_Preference__c(UserId__c = UserInfo.getUserId(),Is_Accepted_Terms_Condition__c = false);
        insert UserPref1 ;

       AA_AgentAppService.getIsAcceptedTermsAndCondition();
         
       system.assertEquals(UserPref.Is_Accepted_Terms_Condition__c,true);
       system.assertEquals(UserPref1.Is_Accepted_Terms_Condition__c,false);
       Test.stopTest();
    } 
  //get cluster values
    
    static testMethod void getClusterValuesTest(){
        Test.startTest();
        AA_AgentAppService.getClusterValues();
        
        Test.stopTest();
        
    }
    
    static testMethod void getCountryValuesTest(){
        Test.startTest();
        AA_AgentAppService.getCountryValues();
        
        Test.stopTest();
        
    }
    static testMethod void getReportingOnListValuesTest(){
        Test.startTest();
        AA_AgentAppService.getReportingOnListValues();
        
        Test.stopTest();
        
    }
    
    static testMethod void getUnileverListValuesTest(){
        Test.startTest();
        AA_AgentAppService.getUnileverListValues();
        
        Test.stopTest();
        
    }
    
    static testMethod void getRetailerListValuesTest(){
        Test.startTest();
        AA_AgentAppService.getRetailerListValues();
        
        Test.stopTest();
    }
    
    static testMethod void getAutoPopulatedValues_UnileverReportTest(){
        Test.startTest();
        AA_AgentAppService.getAutoPopulatedValues_UnileverReport();
        
        Test.stopTest();
    }
    
    static testMethod void getSourceListValuesTest(){
        Test.startTest();
        AA_AgentAppService.getSourceListValues();
        
        Test.stopTest();
    }
    
    static testMethod void getTopicListValuesTest(){
        Test.startTest();
        AA_AgentAppService.getTopicListValues();
        
        Test.stopTest();
    }
    
    static testMethod void getCompetitorBrandListValuesTest(){
        Test.startTest();
        AA_AgentAppService.getCompetitorBrandListValues();
        
        Test.stopTest();
    }
    static testMethod void getCompetitorNameListValuesTest(){
        Test.startTest();
        AA_AgentAppService.getCompetitorNameListValues();
        
        Test.stopTest();
    }
    static testMethod void getCompetitorCategoryListValuesTest(){
        Test.startTest();
        AA_AgentAppService.getCompetitorCategoryListValues();
        
        Test.stopTest();
    }
    
    static testMethod void getSourceRetailerTopicCountry_CompetitorReportTest(){
        Test.startTest();
        AA_AgentAppService.getSourceRetailerTopicCountry_CompetitorReport();
        
        Test.stopTest();
    }
    
    static testMethod void getGlobalClusterIdTest(){
        Test.startTest();
        aa_Cluster__c globalCluster = new aa_Cluster__c (name ='global');
        insert globalCluster;
        AA_AgentAppService.getGlobalClusterId();
        
        Test.stopTest();
    }
    
    static testMethod void getCompetitorCategoryTest(){
        Test.startTest();
        
        
        aa_Agent_Competitor__c competitor = new aa_Agent_Competitor__c(name='Test');
        insert competitor;
        
        aa_Agent_App_Competitor_Brand__c competitorBrand = new aa_Agent_App_Competitor_Brand__c (name = 'Test');
        insert competitorBrand;
        
        aa_Agent_App_Brand_Category__c competitorCategory = new aa_Agent_App_Brand_Category__c (name='Test',Agent_Competitor_Id__c =competitor.id ,Brand_Id__c = competitorBrand.id );
        insert competitorCategory ;
        
        
        AA_AgentAppService.getCompetitorCategory(competitorBrand.Name);
        
        Test.stopTest();
    }
    
    static testMethod void getupdateLikeCountTest(){
        Test.startTest();
         
        aa_Agent_Report__c report = new aa_Agent_Report__c();
        insert report;
        AA_AgentAppService.getupdateLikeCount(report.id);
        
        Test.stopTest();
    }
    
   /* static testMethod void getupdateUnlikeCountTest(){
        Test.startTest();
         
        aa_Agent_Report__c report = new aa_Agent_Report__c(name='Competitor Report 1');
        insert report;     
       
        FeedItem post = new FeedItem();
        post.ParentId = report.Id ; //Activity ID..
        post.Body = 'welcome';
        insert post;
        
        report.chatter_post_id__c  = post.Id;
        update report;
        
        Feedlike feed = new Feedlike(FeedItemId=post.id);
        insert feed;
         AA_AgentAppService.getupdateLikeCount(report.id);
       
        AA_AgentAppService.getupdateUnlikeCount(report.id);
        
        Test.stopTest();
    
         }
*/         
         
   //Check UpdatesIsAccepted Test
    static testMethod void getupdateIsAcceptedTermsAndConditionTest(){
    Test.startTest();
        aa_Agent_App_User_Preference__c UserPref = new aa_Agent_App_User_Preference__c(UserId__c = UserInfo.getUserId(),Is_Accepted_Terms_Condition__c = true);
        insert UserPref;
       AA_ApplicationWrapperObjLtng obj1 = new AA_ApplicationWrapperObjLtng ();
       //obj1.IsAcceptedTermsCondition = true;
        Boolean isAcceptedTermsCondition = true; 
        AA_AgentAppService  obj =new AA_AgentAppService();
        AA_AgentAppService.getUpdateIsAcceptedTermsAndCondition(isAcceptedTermsCondition);
        system.assertEquals(UserPref.Is_Accepted_Terms_Condition__c,true);
        
        
        aa_Agent_App_User_Preference__c UserPref1 = new aa_Agent_App_User_Preference__c(UserId__c = UserInfo.getUserId(),Is_Accepted_Terms_Condition__c = false);
        insert UserPref1;
        //AA_ApplicationWrapperObj obj2 = new AA_ApplicationWrapperObj();
        //obj1.getIsAcceptedTermsCondition = false;
          
        //Boolean isAcceptedTermsCondition = false;  
        AA_AgentAppService  obj3 =new AA_AgentAppService();
        AA_AgentAppService.getUpdateIsAcceptedTermsAndCondition(false);
        system.assertEquals(UserPref1.Is_Accepted_Terms_Condition__c,false);
          
          
        AA_AgentAppService  obj4 =new AA_AgentAppService  ();
        AA_ApplicationWrapperObj wapperobj2 = new AA_ApplicationWrapperObj();
       // wapperobj2.getIsAcceptedTermsCondition = true;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];

        User u2 = new User(Alias = 'tdfss', Email='tes23132t@testorg.com',ProfileId = p.Id ,
        
        EmailEncodingKey='UTF-8', LastName='Tes3423423ting', LanguageLocaleKey=AA_Constants.Stringen_us,
        LocaleSidKey=AA_Constants.Stringen_us, TimeZoneSidKey='America/Los_Angeles', UserName='sdadaas123@testorg.com');
        System.runAs(u2) {
         
        AA_AgentAppService.getupdateIsAcceptedTermsAndCondition(true);
          
          }
          system.assertEquals(UserPref.Is_Accepted_Terms_Condition__c,true);
          Test.stopTest();  
    }
   //Check retriveAllAgentReportsTest_ApplyFilterTrue Test
    static testMethod void retriveAllAgentReportsTest_ApplyFilterTrue(){
    Test.startTest();
        User user = new User();
        user.Username ='testAgentLightninguser4@gmail.com';
        user.LastName = 'LastTestName';
        user.Email = AA_Constants.Stringtestemail;
        user.alias = 'testAl';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = AA_Constants.Stringen_us;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = [select id from Profile where Name='System Administrator'].Id;
        user.LanguageLocaleKey = AA_Constants.Stringen_us;
        insert user;
        
       
        
       aa_agent_app_custom_setting__c setting = new aa_agent_app_custom_setting__c();
       setting.Name = 'Salesforce Instance URL Content';
       setting.Value__c =  AA_Constants.Stringwhatever;
       insert setting;
 
       aa_agent_app_custom_setting__c setting1 = new aa_agent_app_custom_setting__c();
       setting1.Name = 'SFC Content';
       setting1.Value__c =  AA_Constants.Stringwhatever;
       insert setting1;

       aa_agent_app_custom_setting__c setting2 = new aa_agent_app_custom_setting__c();
       setting2.Name = 'Document URL Content';
       setting2.Value__c = AA_Constants.Stringwhatever;
       insert setting2;    
       Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
        
       AA_AgentAppService obj =new AA_AgentAppService();
       
       Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
        Id recTypeId1 = (RT1.get('Competitor Brand')).getRecordTypeId();
        
       Schema.DescribeSObjectResult R2 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
       Map<String,Schema.RecordTypeInfo> RT2 = R2.getRecordTypeInfosByName();
       Id recTypeId2 = (RT2.get('Unilever Brand')).getRecordTypeId();
        
        
       aa_Agent_App_Competitor_Brand__c uniBrand = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand,RecordTypeId=recTypeId2);
       insert uniBrand;
        
        
       aa_Agent_App_Competitor_Brand__c compBrand = new aa_Agent_App_Competitor_Brand__c(Name = 'BBOthers',RecordTypeId=recTypeId1);
       insert compBrand;
       aa_Agent_Competitor__c compName = new aa_Agent_Competitor__c(Name = 'Amul');
       insert compName;
       aa_Agent_App_Category__c compCategory = new aa_Agent_App_Category__c(Name = 'Skin Care');
       insert compCategory;
       aa_Topic__c topic = new aa_Topic__c(Name = 'Campaign');
       insert topic;
       aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = '7-Eleven');
       insert retailerData;
       aa_Cluster__c clusterData2 = new aa_Cluster__c(Name = 'Global');
        insert clusterData2;
       aa_Cluster__c clusterData = new aa_Cluster__c(Name = 'South Asia');
       insert clusterData;
       aa_Country__c countryData = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
       insert countryData;
       aa_Agent_Report__c competitorReport1 = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 1',Report_Description__c = 'this a test comp report',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = 'Pune',Retailer__c = retailerData.id);
       insert competitorReport1;
        aa_Agent_Report__c competitorReport2 = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 1',Report_Description__c = 'this a test comp report',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = 'Pune',Retailer__c = retailerData.id);
       insert competitorReport2;
       aa_Agent_Report__Feed agentFeed = new aa_Agent_Report__Feed();
       
       aa_Agent_App_User_Preference__c userpref = new aa_Agent_App_User_Preference__c(Category__c=compCategory.Id,Country__c =countryData.Id,UserId__c=user.Id);
       insert userpref;
       
       aa_Agent_App_User_Preference__c userpref1 = new aa_Agent_App_User_Preference__c(Category__c=compCategory.Id,Country__c =countryData.Id,UserId__c=UserInfo.getUserId());
       insert userpref1;
      
       AA_WrapperClass.AgentAppDataRequest objAgentApp = new AA_WrapperClass.AgentAppDataRequest();
       
       objAgentApp.ReportName = competitorReport1.Report_Title__c;
       objAgentApp.ReportDesc = competitorReport1.Report_Description__c;
       objAgentApp.CompetitorId = compName.id;
       objAgentApp.CompetitorBrandId = compBrand.id;
       objAgentApp.CategoryId = compCategory.id;
       objAgentApp.CodeOfConduct = 'false';
       objAgentApp.Source = competitorReport1.Source__c;
       objAgentApp.Retailer = retailerData.Id;
       objAgentApp.ReportingOn = 'Look-a-like';
       objAgentApp.CountryId = countryData.id;
       objAgentApp.Town = 'Pune';
       objAgentApp.Latitude = '18.5203° N';
       objAgentApp.Longitude = '73.8567° E';
       objAgentApp.RecordTypeId = recTypeId;
       objAgentApp.ClusterId = clusterData.id;
       objAgentApp.FilterType = 'filterReports';
       objAgentApp.ApplyFilter = 'true';
       objAgentApp.RecordType = 'Competitor';
       objAgentApp.SortOnMostLike = 'true'; 
        List<aa_Agent_Report__c> compReport = new List<aa_Agent_Report__c>();
        compReport.add(competitorReport1);
         compReport.add(competitorReport2);
      
       List<AA_WrapperClass.agentReportDetail> objFinalReport = new List<AA_WrapperClass.agentReportDetail>(); 
       AA_WrapperClass.agentReportDetail objGetAllReports = new AA_WrapperClass.agentReportDetail();
       for(aa_Agent_Report__c item : compReport)
                {
                 
                    objGetAllReports.agentReportID = item.Id;
                    objGetAllReports.competitor_nameId = item.Competitor_Name__c;
                    objGetAllReports.competitor_brandId = item.Competitor_Brand__c ;
                    objGetAllReports.retailerId = item.Retailer__c; 
                    objGetAllReports.userImgUrl=item.CreatedBy.SmallPhotoUrl;
                    objGetAllReports.reportTitl=item.Report_Title__c;
                    objGetAllReports.reportDesc=item.Report_Description__c;
                    objGetAllReports.competitor_name=item.Competitor_Brand__r.Name;
                    objGetAllReports.retailer=item.Retailer__r.Name;
                    objGetAllReports.town=item.Town__c;
                    objGetAllReports.country=item.Country__r.Name;
                   // objGetAllReports.status =item.Status__c;
                    }
                         system.runAs(user){
            objFinalReport.add(objGetAllReports);
            /*AA_AgentAppService obj1 = new AA_AgentAppService();
             AA_WrapperClass.AgentAppDataRequest objAgentAppDataRequest=new AA_WrapperClass.AgentAppDataRequest();
             
             AA_WrapperClass.AgentAppDataResponse objAgentAppDataResponse = new AA_WrapperClass.AgentAppDataResponse();
           
                   objAgentApp.OffSet= 0;
                   objAgentApp.LimitRecords=10;
                   objAgentApp.ApplyFilter='true';
                   objAgentApp.FilterType='All Reports';
                   obj1.objAgentAppDataRequest = objAgentApp;
                   obj1.objPassAgentReportsToNG = objGetAllReports;
                   obj1.objGetAgentDataResponse = objAgentAppDataResponse;*/

            
           AA_ApplicationWrapperObjLtng result = AA_AgentAppService.getRetriveAllAgentReports('MyReports', 'ShowLatestFirst',10,0, 'true' ,clusterData.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','UL', compBrand.id, compName.id ,compCategory.id , topic.id);
           
           AA_ApplicationWrapperObjLtng result1 = AA_AgentAppService.getRetriveAllAgentReports('FilteredReports', 'ShowLatestFirst',10,0, 'true' ,clusterData.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','UL', compBrand.id, compName.id ,compCategory.id , topic.id);
                       
           AA_ApplicationWrapperObjLtng result2 = AA_AgentAppService.getRetriveAllAgentReports('FilteredReports', 'ShowMostlikedFirst',10,0, 'true' ,clusterData.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','UL', compBrand.id, compName.id ,compCategory.id , topic.id);
                             
           AA_ApplicationWrapperObjLtng result3 = AA_AgentAppService.getRetriveAllAgentReports('MyReports', 'ShowMostlikedFirst',10,0, 'true' ,clusterData.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','UL', compBrand.id, compName.id ,compCategory.id , topic.id);
          
          AA_ApplicationWrapperObjLtng result6 = AA_AgentAppService.getRetriveAllAgentReports('MyReports', 'ShowLatestFirst',10,0, 'true' ,clusterData.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','CI', compBrand.id, compName.id ,compCategory.id , topic.id);
           
           AA_ApplicationWrapperObjLtng result7 = AA_AgentAppService.getRetriveAllAgentReports('MyReports', 'ShowLatestFirst',10,0, 'true' ,clusterData2.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','CI', compBrand.id, compName.id ,compCategory.id , topic.id);
           
           AA_ApplicationWrapperObjLtng result8 = AA_AgentAppService.getRetriveAllAgentReports('FilteredReports', 'ShowLatestFirst',10,0, 'true' ,clusterData.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','CI', compBrand.id, compName.id ,compCategory.id , topic.id);
                       
           AA_ApplicationWrapperObjLtng result9 = AA_AgentAppService.getRetriveAllAgentReports('FilteredReports', 'ShowMostlikedFirst',10,0, 'true' ,clusterData.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','CI', compBrand.id, compName.id ,compCategory.id , topic.id);
                             
           AA_ApplicationWrapperObjLtng result10 = AA_AgentAppService.getRetriveAllAgentReports('MyReports', 'ShowMostlikedFirst',10,0, 'true' ,clusterData.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','CI', compBrand.id, compName.id ,compCategory.id , topic.id);
           
           
            //system.assert(result1.size() != 0);
            
            
           }
           Test.stopTest();
    }
    
    //Check retriveAllAgentReportsTest_ApplyFilterFalse Test
    static testMethod void retriveAllAgentReportsTest_ApplyFilterFalse(){
    Test.startTest();
        User user = new User();
        user.Username ='testuser4@gmail.com';
        user.LastName = 'LastTestName';
        user.Email = AA_Constants.Stringtestemail;
        user.alias = 'testAl';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = AA_Constants.Stringen_us;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = [select id from Profile where Name='System Administrator'].Id;
        user.LanguageLocaleKey = AA_Constants.Stringen_us;
        insert user;
        
       
       aa_agent_app_custom_setting__c setting = new aa_agent_app_custom_setting__c();
       setting.Name = 'Salesforce Instance URL Content';
       setting.Value__c =  AA_Constants.Stringwhatever;
       insert setting;
 
       aa_agent_app_custom_setting__c setting1 = new aa_agent_app_custom_setting__c();
       setting1.Name = 'SFC Content';
       setting1.Value__c =  AA_Constants.Stringwhatever;
       insert setting1;

       aa_agent_app_custom_setting__c setting2 = new aa_agent_app_custom_setting__c();
       setting2.Name = 'Document URL Content';
       setting2.Value__c = AA_Constants.Stringwhatever;
       insert setting2;    
       Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
        
       AA_AgentAppService obj =new AA_AgentAppService();
       
       Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
        Id recTypeId1 = (RT1.get('Competitor Brand')).getRecordTypeId();
        
       Schema.DescribeSObjectResult R2 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
       Map<String,Schema.RecordTypeInfo> RT2 = R2.getRecordTypeInfosByName();
       Id recTypeId2 = (RT2.get('Unilever Brand')).getRecordTypeId();
        
        
       aa_Agent_App_Competitor_Brand__c uniBrand = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand,RecordTypeId=recTypeId2);
       insert uniBrand;
        
        
       aa_Agent_App_Competitor_Brand__c compBrand = new aa_Agent_App_Competitor_Brand__c(Name = 'BBOthers',RecordTypeId=recTypeId1);
       insert compBrand;
       aa_Agent_Competitor__c compName = new aa_Agent_Competitor__c(Name = 'Amul');
       insert compName;
       aa_Agent_App_Category__c compCategory = new aa_Agent_App_Category__c(Name = 'Skin Care');
       insert compCategory;
       aa_Topic__c topic = new aa_Topic__c(Name = 'Campaign');
       insert topic;
       aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = '7-Eleven');
       insert retailerData;
       aa_Cluster__c clusterData2 = new aa_Cluster__c(Name = 'Global');
        insert clusterData2;
       aa_Cluster__c clusterData = new aa_Cluster__c(Name = 'South Asia');
       insert clusterData;
       aa_Country__c countryData = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
       insert countryData;
       aa_Agent_Report__c competitorReport1 = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 1',Report_Description__c = 'this a test comp report',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = 'Pune',Retailer__c = retailerData.id);
       insert competitorReport1;
        aa_Agent_Report__c competitorReport2 = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 1',Report_Description__c = 'this a test comp report',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = 'Pune',Retailer__c = retailerData.id);
       insert competitorReport2;
       aa_Agent_Report__Feed agentFeed = new aa_Agent_Report__Feed();
      
      aa_Agent_App_User_Preference__c userpref = new aa_Agent_App_User_Preference__c(UserId__c=user.Id ,Category__c=compCategory.Id );
      insert userpref;
      
       AA_WrapperClass.AgentAppDataRequest objAgentApp = new AA_WrapperClass.AgentAppDataRequest();
       
       objAgentApp.ReportName = competitorReport1.Report_Title__c;
       objAgentApp.ReportDesc = competitorReport1.Report_Description__c;
       objAgentApp.CompetitorId = compName.id;
       objAgentApp.CompetitorBrandId = compBrand.id;
       objAgentApp.CategoryId = compCategory.id;
       objAgentApp.CodeOfConduct = 'false';
       objAgentApp.Source = competitorReport1.Source__c;
       objAgentApp.Retailer = retailerData.Id;
       objAgentApp.ReportingOn = 'Look-a-like';
       objAgentApp.CountryId = countryData.id;
       objAgentApp.Town = 'Pune';
       objAgentApp.Latitude = '18.5203° N';
       objAgentApp.Longitude = '73.8567° E';
       objAgentApp.RecordTypeId = recTypeId;
       objAgentApp.ClusterId = clusterData.id;
       objAgentApp.FilterType = 'filterReports';
       objAgentApp.ApplyFilter = 'false';
       objAgentApp.RecordType = 'Competitor';
       objAgentApp.SortOnMostLike = 'true'; 
        List<aa_Agent_Report__c> compReport = new List<aa_Agent_Report__c>();
        compReport.add(competitorReport1);
         compReport.add(competitorReport2);
      
       List<AA_WrapperClass.agentReportDetail> objFinalReport = new List<AA_WrapperClass.agentReportDetail>(); 
       AA_WrapperClass.agentReportDetail objGetAllReports = new AA_WrapperClass.agentReportDetail();
       for(aa_Agent_Report__c item : compReport)
                {
                 
                    objGetAllReports.agentReportID = item.Id;
                    objGetAllReports.competitor_nameId = item.Competitor_Name__c;
                    objGetAllReports.competitor_brandId = item.Competitor_Brand__c ;
                    objGetAllReports.retailerId = item.Retailer__c; 
                    objGetAllReports.userImgUrl=item.CreatedBy.SmallPhotoUrl;
                    objGetAllReports.reportTitl=item.Report_Title__c;
                    objGetAllReports.reportDesc=item.Report_Description__c;
                    objGetAllReports.competitor_name=item.Competitor_Brand__r.Name;
                    objGetAllReports.retailer=item.Retailer__r.Name;
                    objGetAllReports.town=item.Town__c;
                    objGetAllReports.country=item.Country__r.Name;
                   // objGetAllReports.status =item.Status__c;
                    }
                         system.runAs(user){
            objFinalReport.add(objGetAllReports);
            AA_AgentAppService obj1 = new AA_AgentAppService();
             AA_WrapperClass.AgentAppDataRequest objAgentAppDataRequest=new AA_WrapperClass.AgentAppDataRequest();
             
             AA_WrapperClass.AgentAppDataResponse objAgentAppDataResponse = new AA_WrapperClass.AgentAppDataResponse();
           
                objAgentApp.OffSet= 0;
                objAgentApp.LimitRecords=10;
                objAgentApp.ApplyFilter='false';
                objAgentApp.FilterType='All Reports';
                /*obj1.objAgentAppDataRequest = objAgentApp;
                obj1.objPassAgentReportsToNG = objGetAllReports;
                obj1.objGetAgentDataResponse = objAgentAppDataResponse;*/
    
            
           AA_ApplicationWrapperObjLtng result = AA_AgentAppService.getRetriveAllAgentReports('MyReports', 'ShowLatestFirst',10,0, 'true' ,clusterData.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','UL', compBrand.id, compName.id ,compCategory.id , topic.id);
           
           AA_ApplicationWrapperObjLtng  result1 = AA_AgentAppService.getRetriveAllAgentReports('FilteredReports', 'ShowLatestFirst',10,0, 'true' ,clusterData.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','UL', compBrand.id, compName.id ,compCategory.id , topic.id);
                       
           AA_ApplicationWrapperObjLtng result2 = AA_AgentAppService.getRetriveAllAgentReports('FilteredReports', 'ShowMostlikedFirst',10,0, 'false' ,clusterData.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','UL', compBrand.id, compName.id ,compCategory.id , topic.id);
                             
           AA_ApplicationWrapperObjLtng result3 = AA_AgentAppService.getRetriveAllAgentReports('MyReports', 'ShowMostlikedFirst',10,0, 'true' ,clusterData.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','UL', compBrand.id, compName.id ,compCategory.id , topic.id);
          
          AA_ApplicationWrapperObjLtng result6 = AA_AgentAppService.getRetriveAllAgentReports('MyReports', 'ShowLatestFirst',10,0, 'true' ,clusterData.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','CI', compBrand.id, compName.id ,compCategory.id , topic.id);
           
           AA_ApplicationWrapperObjLtng result7 = AA_AgentAppService.getRetriveAllAgentReports('MyReports', 'ShowLatestFirst',10,0, 'true' ,clusterData2.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','CI', compBrand.id, compName.id ,compCategory.id , topic.id);
           
           AA_ApplicationWrapperObjLtng result8 = AA_AgentAppService.getRetriveAllAgentReports('FilteredReports', 'ShowLatestFirst',10,0, 'false' ,clusterData.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','CI', compBrand.id, compName.id ,compCategory.id , topic.id);
                       
           AA_ApplicationWrapperObjLtng result9 = AA_AgentAppService.getRetriveAllAgentReports('FilteredReports', 'ShowMostlikedFirst',10,0, 'false' ,clusterData.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','CI', compBrand.id, compName.id ,compCategory.id , topic.id);
                             
           AA_ApplicationWrapperObjLtng result10 = AA_AgentAppService.getRetriveAllAgentReports('MyReports', 'ShowMostlikedFirst',10,0, 'true' ,clusterData.id , countryData.id ,uniBrand.id ,retailerData.id,
          'Reporting on','CI', compBrand.id, compName.id ,compCategory.id , topic.id);
           
           
            //system.assert(result1.size() != 0);
            
            
           }
           
      /*aa_Agent_Report__c objWrap=new aa_Agent_Report__c();
      objWrap.Id='';
      objWrap.ClusterId__c='';
      objWrap.ClusterId__r.name='';
      objWrap.Chatter_Post_ID__c='';
      objWrap.LastModifiedDate=;
      objWrap.Agent_App_Unilever_Brand__r.Name='';
      objWrap.Agent_App_Unilever_Brand__c='';
      objWrap.Town__c='';
      objWrap.Retailer__c='';
      objWrap.Retailer__r.Name='';
      objWrap.RecordType.Name='';
      objWrap.Name='';
      objWrap.Report_Title__c='';
      objWrap.Report_Description__c='';
      objWrap.CreatedDate=;
      objWrap.CreatedBy.SmallPhotoUrl='';
      objWrap.CreatedBy.Name='';
      objWrap.Country__c='';
      objWrap.Country__r.Name='';
      objWrap.Country__r.Cluster_Id__c='';
      objWrap.Competitor_Name__c='';
      objWrap.Competitor_Name__r.Name='';
      objWrap.Competitor_Brand__c='';
      objWrap.Competitor_Brand__r.Name='';
      objWrap.Category__c='';
      objWrap.Category__r.Name='';
      objWrap.Status__c='';*/
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
           Test.stopTest();
    }
    
    //Insert Unilever Report
  static testMethod void insertAgentApp_UnileverTest() {
  Test.startTest();
 
       Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
       Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
       Id recTypeId = (RT.get('Unilever Agent Report')).getRecordTypeId();
        
       AA_AgentAppService obj =new AA_AgentAppService();
       
       
       Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
       Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
       Id recTypeId1 = (RT1.get('Unilever Brand')).getRecordTypeId();
        
        
       aa_Agent_App_Competitor_Brand__c uniBrand = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand,RecordTypeId=recTypeId1);
       insert uniBrand;
       aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = AA_Constants.RetailerSample);
       insert retailerData;
       aa_Cluster__c clusterData = new aa_Cluster__c(Name = AA_Constants.ClusterSample);
       insert clusterData;
       aa_Country__c countryData = new aa_Country__c(Name = AA_Constants.CountrySample,Cluster_Id__c = clusterData.id);
       insert countryData;
       aa_Agent_Report__c unileverReport = new aa_Agent_Report__c(Report_Title__c = AA_Constants.ReportNameSample,Report_Description__c = 'This is a test description',Country__c = countryData.id,Reporting_on__c = AA_Constants.ReportingOnSample,Town__c = AA_Constants.TownSample,Retailer__c = retailerData.id,Agent_App_Unilever_Brand__c = uniBrand.id,Status__C='New');
       insert unileverReport;
       List<string> userList=new List<string>{'1234','3456'};
       List<string> topicList=new List<string>{'1234','3456'};
       AA_WrapperClass.AgentAppDataRequest objAgentApp = new AA_WrapperClass.AgentAppDataRequest();
       objAgentApp.UnileverBrandId = uniBrand.id;
       objAgentApp.CountryId = countryData.id;
       objAgentApp.ReportName = unileverReport.Report_Title__c;
       objAgentApp.ReportDesc = unileverReport.Report_Description__c;
       objAgentApp.Retailer = retailerData.Id;
       objAgentApp.ReportingOn = AA_constants.ReportingOnSample;
       objAgentApp.Town = AA_Constants.TownSample;
       objAgentApp.Latitude = AA_Constants.LatSample;
       objAgentApp.Longitude = AA_Constants.LongSample;
       objAgentApp.RecordTypeId = recTypeId;
       objAgentApp.usertomentionIds=userList; 
        objAgentApp.topicIds=topicList; 
          aa_Agent_Report__c newObj;   
       aa_Agent_Report__c objagent=AA_AgentAppService.convertRequestAgentReport(objAgentApp);
       //AA_ApplicationWrapperObjLtng obj1 = new AA_ApplicationWrapperObjLtng();
       //AA_AgentAppService .objAgentAppDataRequest = objAgentApp;
       //obj.getAutoPopulatedValues_UnileverReport(obj1);
       
       
        String clusterId = '1234';
        String countryId= '1234';
        String town='Bangalore';
        String reportName='Test Report';
        String reportDescription='This is a test Report';
        List<String> userIds= new List<String>();
        userIds.add('1234');
        userIds.add('3456');
        //String unileverBrandId='0987';
        //String retailerId='3457';
        String reportingOnId='9865';
        String recordType='Test Record';
        String status='New';
        String contentId='6457';
        
       AA_AgentAppService.insertAgentApp(clusterData.id,countryData.id ,town,reportName,reportDescription,userIds,uniBrand.id ,retailerData.id ,reportingOnId,recordType,status,contentId);


       system.assertnotEquals(objagent,newObj);
       Test.stopTest();
     }
  
    //Insert Competitor Report Test
     static testMethod void CompetitorTest() {
     Test.startTest();

        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
        
        AA_AgentAppService obj =new AA_AgentAppService();
       
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
       List<string> userList=new List<string>{'1234','3456'};
       List<string> topicList=new List<string>{'1234','3456'};
       aa_Topic__c newtopic=new aa_Topic__c(Name=AA_Constants.Topicsample,Sub_Topic__c=AA_Constants.SubtopicSample);
       AA_WrapperClass.AgentAppDataRequest objAgentApp = new AA_WrapperClass.AgentAppDataRequest();
       
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
      // obj.convertRequestAgentReport_Competitor(objAgentApp);
       //AA_ApplicationWrapperObjLtng obj1 = new AA_ApplicationWrapperObjLtng();
       //obj1.objAgentAppDataRequest = objAgentApp;
       //obj.insertAgentApp_Competitor(obj1);
      // obj.getCompetitorNameAndCategory_CompetitorReport(obj1);
       aa_Agent_Report__c newObj1;   
       aa_Agent_Report__c objagent=AA_AgentAppService.convertRequestAgentReport(objAgentApp);
       //AA_ApplicationWrapperObjLtng obj1 = new AA_ApplicationWrapperObjLtng();
       //AA_AgentAppService .objAgentAppDataRequest = objAgentApp;
       //obj.getAutoPopulatedValues_UnileverReport(obj1);
       
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
       
        //String clusterId = 'a6N18000000Cbw1';
        //String countryId= 'a6O18000000Cb7N';
        String town='Bangalore';
        String reportName='Test Report';
        String reportDescription='This is a test Report';
        List<String> userIds= new List<String>();
        userIds.add('1342');
        userIds.add('3456');
        String source='Test';
        //String competitorBrandId='0987';
        String otherBrandName='other';
        String otherCompetitor='other';
        //String competitorId='0123';
        //String categoryId='2222';
        //String retailer='3457';
        //String topicId='9865';
        String subTopic='Test subTopic';
        String recordType='Test Record';
        String status='New';
        String contentId='6457';
        
    AA_AgentAppService.insertAgentApp_Competitor(clusterData1.id ,countryData1.id ,town,reportName,reportDescription,userIds,source,uniBrand1.id ,otherBrandName,otherCompetitor,competitor1.id,cate.id,retailerData1.id ,topic1.id,subTopic,recordType,status,contentId);

       
       //obj.getSourceRetailerTopicCountry_CompetitorReport(newObj1);
       system.assertnotEquals(objagent,newObj1);
       Test.stopTest();
    }
    
    static testMethod void getOtherCompetitorBrandIdTest(){
        Test.startTest();
        aa_Agent_App_Competitor_Brand__c otherCompetitorBrandId= new aa_Agent_App_Competitor_Brand__c (name ='other');
        insert otherCompetitorBrandId;
        AA_AgentAppService.getOtherCompetitorBrandId();
        
        Test.stopTest();
    }
    static testMethod void uploadNewFileTest(){
        Test.startTest();
        String fileName='TestFile';
        String base64Data='TestBase';
        String contentType='Testc';
        String subjectId='1234';
        String textToPost='Test2';
        
        AA_AgentAppService.uploadNewFile(fileName,base64Data,contentType,subjectId,textToPost);
        
        Test.stopTest();
    }
    static testMethod void getBrandNameTest(){
        Test.startTest();
        aa_Agent_App_Competitor_Brand__c brand =new aa_Agent_App_Competitor_Brand__c(Name= 'newBrand');
        insert brand; 
       
        AA_AgentAppService.getBrandName(brand.Id);
        
        Test.stopTest();
    }
    static testMethod void getRetailerNameTest(){
        Test.startTest();
        aa_Agent_Retailer__c retailer=new aa_Agent_Retailer__c(Name= 'retailerName');
        insert retailer; 
       
        AA_AgentAppService.getRetailerName(retailer.Id);
        
        Test.stopTest();
    }
    static testMethod void getfiterDataIdsTest(){
        Test.startTest();
        aa_Agent_App_Competitor_Brand__c otherCompetitorBrandId= new aa_Agent_App_Competitor_Brand__c (name ='other');
        insert otherCompetitorBrandId;
        aa_Cluster__c globalCluster = new aa_Cluster__c (name ='global');
        insert globalCluster;
        
        AA_AgentAppService.getfiterDataIds();
        
        Test.stopTest();
    }
    static testMethod void getUserPreferenceTest(){
        Test.startTest();
        aa_Agent_App_User_Preference__c UserPref= new aa_Agent_App_User_Preference__c (UserId__c = UserInfo.getUserId());
        insert UserPref;
        
        
        AA_AgentAppService.getUserPreference();
        
        Test.stopTest();
    }
    static testMethod void saveTheFileTest(){
        Test.startTest();
        String fileName='TestFile';
        String base64Data='TestBase';
        String contentType='Testc';
        //String subjectId='1234';
        //String textToPost='Test2';
        
        AA_AgentAppService.saveTheFile(fileName,base64Data,contentType);
        
        Test.stopTest();
    }
    /*static testMethod void saveTheChunkTest(){
        Test.startTest();
        String fileName='TestFile1';
        String base64Data='TestBase';
        String contentType='Testc';
        String fileId='1234';
        //String textToPost='Test2';
        
        AA_AgentAppService.saveTheChunk(fileName,base64Data,contentType,fileId);
        
        Test.stopTest();
    }
    static testMethod void appendToFileTest(){
        Test.startTest();
        String fileName='TestFile2';
        String base64Data='TestBase';
        //String contentType='Testc';
        //String fileId='1234';
        //String textToPost='Test2';
        
        AA_AgentAppService.appendToFile(fileName,base64Data);
        
        Test.stopTest();
    }*/
    
 
    }