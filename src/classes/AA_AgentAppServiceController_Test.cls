@IsTest 
/**
 * Name:        -   AA_AgentAppServoceController_Test
 * @description -   This is the test class for AA_AgentAppServoceController Class to verify the code  for the services requested from frontend & which includes the business logic.
 * @Author      -   Aslesha R K     
 */
private class AA_AgentAppServiceController_Test {

  //Insert Unilever Report
  static testMethod void insertAgentApp_UnileverTest() {
 
       Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
       Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
       Id recTypeId = (RT.get('Unilever Agent Report')).getRecordTypeId();
        
       AA_AgentAppServiceController obj =new AA_AgentAppServiceController();
       
       
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
       List<string> userList=new List<string>{AA_Constants.StringFirstRandomNumber,AA_Constants.StringSecondRandomNumber};
       List<string> topicList=new List<string>{AA_Constants.StringFirstRandomNumber,AA_Constants.StringSecondRandomNumber};
       AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
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
             
       obj.convertRequestAgentReport(objAgentApp);
       AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
       obj1.objAgentAppDataRequest = objAgentApp;
       obj.getAutoPopulatedValues_UnileverReport(obj1);
       system.assertEquals(objAgentApp.ReportName,unileverReport.Report_Title__c);
     }
  
    
     //Insert Competitor Report Test
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
    
    //Check IsAccepted Terms & conditions test
    static testMethod void isAcceptedTermsAndConditionTest(){
        aa_Agent_App_User_Preference__c UserPref = new aa_Agent_App_User_Preference__c(UserId__c = UserInfo.getUserId(),Is_Accepted_Terms_Condition__c = true);
        insert UserPref;
        AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
        obj1.isAcceptedTermsCondition = true;
          
        AA_AgentAppServiceController obj =new AA_AgentAppServiceController();
        obj.isAcceptedTermsAndCondition(obj1);
        system.assertEquals(UserPref.Is_Accepted_Terms_Condition__c,true);
          
    }
    //Check UpdatesIsAccepted Test
    static testMethod void updateIsAcceptedTermsAndConditionTest(){
        aa_Agent_App_User_Preference__c UserPref = new aa_Agent_App_User_Preference__c(UserId__c = UserInfo.getUserId(),Is_Accepted_Terms_Condition__c = true);
        insert UserPref;
        AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
        obj1.isAcceptedTermsCondition = true;
          
        AA_AgentAppServiceController obj =new AA_AgentAppServiceController();
        obj.updateIsAcceptedTermsAndCondition(obj1);
        system.assertEquals(UserPref.Is_Accepted_Terms_Condition__c,true);
        
        
        aa_Agent_App_User_Preference__c UserPref1 = new aa_Agent_App_User_Preference__c(UserId__c = UserInfo.getUserId(),Is_Accepted_Terms_Condition__c = false);
        insert UserPref1;
        AA_ApplicationWrapperObj obj2 = new AA_ApplicationWrapperObj();
        obj1.isAcceptedTermsCondition = false;
          
        AA_AgentAppServiceController obj3 =new AA_AgentAppServiceController();
        obj3.updateIsAcceptedTermsAndCondition(obj2);
        system.assertEquals(UserPref1.Is_Accepted_Terms_Condition__c,false);
          
          
        AA_AgentAppServiceController obj4 =new AA_AgentAppServiceController();
        AA_ApplicationWrapperObj wapperobj2 = new AA_ApplicationWrapperObj();
        wapperobj2.isAcceptedTermsCondition = true;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];

        User u2 = new User(Alias = 'tdfss', Email='tes23132t@testorg.com',ProfileId = p.Id ,
        
        EmailEncodingKey='UTF-8', LastName='Tes3423423ting', LanguageLocaleKey=AA_Constants.Stringen_us,
        LocaleSidKey=AA_Constants.Stringen_us, TimeZoneSidKey='America/Los_Angeles', UserName='sdadaas123@testorg.com');
        System.runAs(u2) {
         
        obj4.updateIsAcceptedTermsAndCondition(wapperobj2);
          
          }
          system.assertEquals(UserPref.Is_Accepted_Terms_Condition__c,true);
    }
  
    
  	//Check retriveAllAgentReportsTest_ApplyFilterTrue Test
    static testMethod void retriveAllAgentReportsTest_ApplyFilterTrue(){
        
        User user = new User();
<<<<<<< HEAD
        user.Username ='testuser7@gmail.com';
=======
        user.Username ='testagentuser301@gmail.com';
>>>>>>> develop
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
       
        system.runAs(user){
        
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
        
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
       
       
       AA_AgentAppServiceController obj = new AA_AgentAppServiceController();
 
       AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
      
       objAgentApp.FilterType = AA_Constants.StringfilterReports;
   
       objAgentApp.ApplyFilter = 'true';
       objAgentApp.ReportingOn=AA_Constants.ReportingOnSample;
       aa_Agent_App_Category__c cat1= new aa_Agent_App_Category__c(Name=AA_Constants.CategorySample);
       insert cat1;
       
        aa_Cluster__c clusterData1 = new aa_Cluster__c(Name =AA_Constants.ClusterSample);
       insert clusterData1;
       
       aa_Country__c countryData1 = new aa_Country__c(Name = AA_Constants.CountrySample,Cluster_Id__c = clusterData1.id);
       insert countryData1;
       
        Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
        Id recTypeId1 = (RT1.get('Competitor Brand')).getRecordTypeId();
       
       aa_Agent_App_Competitor_Brand__c uniBrand1 = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand,RecordTypeId=recTypeId1);
       insert uniBrand1;
        aa_Cluster__c clusterData2 = new aa_Cluster__c(Name = 'Global');
        insert clusterData2;
       
         aa_Agent_Retailer__c retailerData1 = new aa_Agent_Retailer__c(Name = AA_Constants.RetailerSample);
       insert retailerData1;
        
        List<string> userList=new List<string>{AA_Constants.StringFirstRandomNumber,AA_Constants.StringSecondRandomNumber};
        objAgentApp.usertomentionIds= userList;
       objAgentApp.CategoryId=cat1.id;
       objAgentApp.CountryId=countryData1.Id;
       objAgentApp.ClusterId=clusterData1.id;
       objAgentApp.RecordTypeId=recTypeId;      
       objAgentApp.Retailer=retailerData1.id;

       AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
       obj1.objAgentAppDataRequest = objAgentApp;
    
       obj.retriveAllAgentReports(obj1);
       obj.retrieveAgentReportsOnMostliked(obj1);
       
       AA_WrapperUtility.AgentAppDataRequest objAgentApp2 = new AA_WrapperUtility.AgentAppDataRequest();
       objAgentApp2.FilterType ='myReport';
       objAgentApp2.ApplyFilter = 'true';
	   objAgentApp2.ReportingOn=AA_Constants.ReportingOnSample;
     
        objAgentApp2.usertomentionIds= userList;
       objAgentApp2.CategoryId=cat1.id;
       objAgentApp2.CountryId=countryData1.Id;
       objAgentApp2.ClusterId=clusterData1.id;
       objAgentApp2.RecordTypeId=recTypeId;      
       objAgentApp2.Retailer=retailerData1.id;
	   
      
       AA_ApplicationWrapperObj obj2 = new AA_ApplicationWrapperObj();
       obj2.objAgentAppDataRequest = objAgentApp2;
       obj.retriveAllAgentReports(obj2);
    
       AA_WrapperUtility.AgentAppDataRequest objAgentApp3 = new AA_WrapperUtility.AgentAppDataRequest();
            objAgentApp3.FilterType = AA_Constants.StringfilterReports;    
            objAgentApp3.ApplyFilter = 'true';
            objAgentApp3.RecordType='Unilever';
            objAgentApp3.ReportingOn=AA_Constants.ReportingOnSample;
            objAgentApp3.usertomentionIds= userList;
            objAgentApp3.CategoryId=cat1.id;
            objAgentApp3.CountryId=countryData1.Id;
            objAgentApp3.ClusterId=clusterData1.id;
            objAgentApp3.RecordTypeId=recTypeId;      
            objAgentApp3.Retailer=retailerData1.id;
            
       AA_ApplicationWrapperObj obj3 = new AA_ApplicationWrapperObj();
       obj3.objAgentAppDataRequest = objAgentApp3;
       obj.retriveAllAgentReports(obj3);
   
       
       AA_WrapperUtility.AgentAppDataRequest objAgentApp4 = new AA_WrapperUtility.AgentAppDataRequest();
       objAgentApp4.FilterType = AA_Constants.StringfilterReports;    
       objAgentApp4.ApplyFilter = 'true';
       objAgentApp4.RecordType='Competitor';
       objAgentApp4.ReportingOn=AA_Constants.ReportingOnSample;
       objAgentApp4.usertomentionIds= userList;
       objAgentApp4.CategoryId=cat1.id;
       objAgentApp4.CountryId=countryData1.Id;
       objAgentApp4.ClusterId=NULL;
       objAgentApp4.RecordTypeId=recTypeId;      
       objAgentApp4.Retailer=retailerData1.id;
       AA_ApplicationWrapperObj obj4 = new AA_ApplicationWrapperObj();
       obj4.objAgentAppDataRequest = objAgentApp4; 
       obj.retriveAllAgentReports(obj4);
  
     // filter False    
        aa_Agent_App_Category__c cat= new aa_Agent_App_Category__c(Name=AA_Constants.CategorySample);
        insert cat;
        aa_Agent_App_User_Preference__c upref = new aa_Agent_App_User_Preference__c();
       
       upref.Category__c=cat.id;
       upref.UserId__c=UserInfo.getUserId();
        
       insert upref; 
       AA_WrapperUtility.AgentAppDataRequest objAgentApp5 = new AA_WrapperUtility.AgentAppDataRequest();
       objAgentApp.FilterType = AA_Constants.StringfilterReports;
 
    
       AA_ApplicationWrapperObj obj5 = new AA_ApplicationWrapperObj();
       obj5.objAgentAppDataRequest = objAgentApp5;
       obj.retriveAllAgentReports(obj5);   
       
       // sort in most like 
       AA_WrapperUtility.AgentAppDataRequest objAgentApp1 = new AA_WrapperUtility.AgentAppDataRequest();
       objAgentApp1.SortOnMostLike='true';
       AA_ApplicationWrapperObj obj6 = new AA_ApplicationWrapperObj();
    //    AA_WrapperUtility.AgentAppDataRequest objAgentAppDataRequest=new AA_WrapperUtility.AgentAppDataRequest();
      
       objAgentApp1.OffSet='0';
      objAgentApp1.LimitRecords='10';
       objAgentApp1.ApplyFilter='true';
       objAgentApp1.FilterType='All Reports';
       obj6.serviceName='GetAgentAllReport';
       obj6.objAgentAppDataRequest = objAgentApp1;
       AA_ApplicationWrapperObj result=obj.retriveAllAgentReports(obj6);  
       system.assertEquals(result.serviceName ,'GetAgentAllReport');
       
        }
        
    }
     
      //check updateUnlikeCount Test
      static testMethod void updateUnLikeCountTest(){
    
        AA_AgentAppServiceController obj =new AA_AgentAppServiceController();
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
       List<string> topicList=new List<string>{AA_Constants.StringFirstRandomNumber,AA_Constants.StringSecondRandomNumber};
       AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
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
       FeedItem fi2 = new FeedItem();
            fi2.body = 'New Agent File uploaded';
            fi2.Type = 'TextPost' ;
            fi2.Title = 'Agent File';           
            fi2.ParentId = unileverReport.Id;
           insert fi2;          
       unileverReport.Chatter_Post_ID__c=fi2.Id;
       unileverReport.Status__c='Existing';
       update unileverReport;
       
       //AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
       objAgentApp.AgentReportId=unileverReport.id;
      
       obj.convertRequestAgentReport(objAgentApp);
       AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
       obj1.objAgentAppDataRequest = objAgentApp;
       obj1.serviceName='GetAutoPopulatedValues';
       obj.insertAgentApp(obj1);
       obj.updateLikeCount(obj1);
       obj.updateUnlikeCount(obj1);
            
        aa_Agent_Retailer__c retailer =new aa_Agent_Retailer__c(Name='Dmart');        
        insert retailer;
        
        aa_Agent_App_Competitor_Brand__c brand =new aa_Agent_App_Competitor_Brand__c(Name='brand');
        insert brand;
        
        aa_Cluster__c cluster=new aa_Cluster__c(Name='test');
        insert cluster;
        
        aa_Country__c country =new aa_Country__c(Name='country',Cluster_Id__c = cluster.id);
        insert country;
      
        aa_Agent_App_Competitor_Brand__c uniBrand2 = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand,RecordTypeId=recTypeId1);
        insert uniBrand2;
       
        aa_Agent_Retailer__c retailerData4 = new aa_Agent_Retailer__c(Name =AA_Constants.RetailerSample);
        insert retailerData4;
        
        aa_Cluster__c clusterData3 = new aa_Cluster__c(Name = AA_Constants.ClusterSample);
        insert clusterData3;
        
        aa_Country__c countryData4 = new aa_Country__c(Name =AA_Constants.CountrySample,Cluster_Id__c = clusterData.id);
        insert countryData4;
        
        aa_Topic__c topic=new aa_Topic__c();
        insert topic;
       
        aa_Agent_Competitor__c competitor=new aa_Agent_Competitor__c();
        insert competitor;
       
        aa_Agent_App_Category__c cate=new aa_Agent_App_Category__c();
        insert cate;
        AA_ApplicationWrapperObj result=obj.getAutoPopulatedValues_UnileverReport(obj1);
        system.assertEquals(result.objGetAgentDataResponse.clusterList[0].Name,AA_Constants.ClusterSample);
   
  }
    
    //Check convertRequestAgentReportDocument Test
     static TestMethod void convertRequestAgentReportDocument_Test(){
        
    AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
    ContentVersion contentVersionObj = new ContentVersion();
        contentVersionObj.ContentURL='http://www.google.com/';
        contentVersionObj.Title = 'test';           
        insert contentVersionObj;
        objAgentApp.ContentDocumentId=contentVersionObj.id;
       // Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        //Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
       // Id recTypeId = (RT.get('Unilever Agent Report')).getRecordTypeId();
        Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
        Id recTypeId1 = (RT1.get('Unilever Brand')).getRecordTypeId();
        
       aa_Agent_App_Competitor_Brand__c uniBrand = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand,RecordTypeId=recTypeId1);
       insert uniBrand;
       aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name =AA_Constants.RetailerSample);
       insert retailerData;
       aa_Cluster__c clusterData = new aa_Cluster__c(Name = AA_Constants.ClusterSample);
       insert clusterData;
       aa_Country__c countryData = new aa_Country__c(Name = AA_Constants.CountrySample,Cluster_Id__c = clusterData.id);
       insert countryData;
        
       aa_Agent_Report__c unileverReport = new aa_Agent_Report__c(Report_Title__c = AA_Constants.ReportNameSample,Country__c = countryData.id,Reporting_on__c = AA_constants.ReportingOnSample,Town__c = AA_Constants.TownSample,Retailer__c = retailerData.id,Agent_App_Unilever_Brand__c = uniBrand.id);
       insert unileverReport;
       list<String> agentAPPIDInserted=new List<String>();
       agentAPPIDInserted.add(unileverReport.ID);
       AA_AgentAppServiceController serobj=new AA_AgentAppServiceController();
      ContentDocumentLink conLink= serobj.convertRequestAgentReportDocument(objAgentApp,agentAPPIDInserted);
     
      system.assertNotEquals(conlink.ContentDocumentId,null);
    
    }
    
     //Check retriveAllAgentReportsTest_ApplyFilterTrue Test
    static testMethod void retriveAllAgentReportsTest_ApplyFilterTrue1(){
        User user = new User();
<<<<<<< HEAD
        user.Username ='testuser4@gmail.com';
=======
        user.Username ='testagentuser302@gmail.com';
>>>>>>> develop
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
        
       AA_AgentAppServiceController obj =new AA_AgentAppServiceController();
       
       Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
        Id recTypeId1 = (RT1.get('Competitor Brand')).getRecordTypeId();
        
        
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
       aa_Cluster__c clusterData = new aa_Cluster__c(Name = 'South Asia');
       insert clusterData;
       aa_Country__c countryData = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
       insert countryData;
       aa_Agent_Report__c competitorReport1 = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 1',Report_Description__c = 'this a test comp report',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = 'Pune',Retailer__c = retailerData.id);
       insert competitorReport1;
        aa_Agent_Report__c competitorReport2 = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 1',Report_Description__c = 'this a test comp report',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = 'Pune',Retailer__c = retailerData.id);
       insert competitorReport2;
      // aa_Agent_Report__Feed agentFeed = new aa_Agent_Report__Feed();
      
      aa_Agent_App_User_Preference__c userpref = new aa_Agent_App_User_Preference__c(UserId__c=user.Id ,Category__c=compCategory.Id);
      insert userpref;
      
       AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
       
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
       objAgentApp.FilterType = AA_Constants.StringfilterReports;
       objAgentApp.ApplyFilter = 'true';
       objAgentApp.RecordType = 'Competitor';
       objAgentApp.SortOnMostLike = 'true'; 
        List<aa_Agent_Report__c> compReport = new List<aa_Agent_Report__c>();
        compReport.add(competitorReport1);
         compReport.add(competitorReport2);
      
       List<AA_WrapperUtility.agentReportDetail> objFinalReport = new List<AA_WrapperUtility.agentReportDetail>(); 
       AA_WrapperUtility.agentReportDetail objGetAllReports = new AA_WrapperUtility.agentReportDetail();
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
        AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
        // AA_WrapperUtility.AgentAppDataRequest objAgentAppDataRequest=new AA_WrapperUtility.AgentAppDataRequest();
       
        objAgentApp.OffSet='0';
      objAgentApp.LimitRecords='10';
      objAgentApp.ApplyFilter='true';
       objAgentApp.FilterType='All Reports';
        obj1.objAgentAppDataRequest = objAgentApp;
        obj1.objPassAgentReportsToNG = objFinalReport;
        AA_ApplicationWrapperObj result1= obj.retriveAllAgentReports(obj1);
       system.assert(result1.objPassAgentReportsToNG != null);
       }
    }
   
     //Check retriveAllAgentReportsTest_ApplyFilterFalse Test
     static testMethod void retriveAllAgentReportsTest_ApplyFilterFalse(){
           
        User user = new User();
<<<<<<< HEAD
        user.Username ='testuser7@gmail.com';
=======
        user.Username ='testagentuser303@gmail.com';
>>>>>>> develop
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
         Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
        Id recTypeId1 = (RT1.get('Unilever Brand')).getRecordTypeId();
             
        aa_Agent_App_Competitor_Brand__c uniBrand = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand,RecordTypeId=recTypeId1);
        insert uniBrand;
        aa_Agent_App_User_Preference__c userpref = new aa_Agent_App_User_Preference__c(UserId__c=user.Id,Cluster__c=clusterData3.Id,Country__c= countryData2.Id,Agent_App_Unilever_Brand__c=uniBrand.Id,Retailer__c=retailerData2.Id,Category__c=compCategory.Id,Is_Accepted_Terms_Condition__c=true);
        insert userpref;
       
        system.runAs(user){
        
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
        
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
       
       
       AA_AgentAppServiceController obj = new AA_AgentAppServiceController();
 
       AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
      
       objAgentApp.FilterType = AA_Constants.StringfilterReports;
   
       objAgentApp.ApplyFilter = 'false';
       objAgentApp.ReportingOn=AA_Constants.ReportingOnSample;
       aa_Agent_App_Category__c cat1= new aa_Agent_App_Category__c(Name=AA_Constants.CategorySample);
       insert cat1;
       
        aa_Cluster__c clusterData1 = new aa_Cluster__c(Name =AA_Constants.ClusterSample);
       insert clusterData1;
       
       aa_Country__c countryData1 = new aa_Country__c(Name = AA_Constants.CountrySample,Cluster_Id__c = clusterData1.id);
       insert countryData1;
       
       
        aa_Cluster__c clusterData2 = new aa_Cluster__c(Name = 'Global');
        insert clusterData2;
       
         aa_Agent_Retailer__c retailerData1 = new aa_Agent_Retailer__c(Name = AA_Constants.RetailerSample);
       insert retailerData1;
        
        List<string> userList=new List<string>{AA_Constants.StringFirstRandomNumber,AA_Constants.StringSecondRandomNumber};
        objAgentApp.usertomentionIds= userList;
       objAgentApp.CategoryId=cat1.id;
       objAgentApp.CountryId=countryData1.Id;
       objAgentApp.ClusterId=clusterData1.id;
       objAgentApp.RecordTypeId=recTypeId;  
       objAgentApp.Retailer=retailerData1.id;
	   objAgentApp.UnileverBrandId = uniBrand.id;
       AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
       obj1.objAgentAppDataRequest = objAgentApp;
    
       obj.retriveAllAgentReports(obj1);
         
         
         
         
        }
        
     /*  aa_agent_app_custom_setting__c setting = new aa_agent_app_custom_setting__c();
       setting.Name = 'Salesforce Instance URL Content';
       setting.Value__c =  AA_Constants.Stringwhatever;
       insert setting;
 
       aa_agent_app_custom_setting__c setting1 = new aa_agent_app_custom_setting__c();
       setting1.Name = 'SFC Content';
       setting1.Value__c =  AA_Constants.Stringwhatever;
       insert setting1;

       aa_agent_app_custom_setting__c setting2 = new aa_agent_app_custom_setting__c();
       setting2.Name = 'Document URL Content';
       setting2.Value__c =  AA_Constants.Stringwhatever;
       insert setting2;     
        
        User user = new User();
        //user.Username =AA_Constants.Stringtestemail;
        user.Username ='testuser6@gmail.com';
        user.LastName = 'LastTestName';
        user.Email = AA_Constants.Stringtestemail;
        user.alias = 'testAl';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = AA_Constants.Stringen_us;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = [select id from Profile where Name='System Administrator'].Id;
        user.LanguageLocaleKey = AA_Constants.Stringen_us;
        insert user;
        aa_Agent_App_Category__c compCategory = new aa_Agent_App_Category__c(Name = 'Skin Care');
        insert compCategory;
          aa_Cluster__c clusterData3 = new aa_Cluster__c(Name =AA_Constants.ClusterSample);
        insert clusterData3;
         aa_Country__c countryData2 = new aa_Country__c(Name = AA_Constants.CountrySample,Cluster_Id__c = clusterData3.Id);
        insert countryData2; 
        aa_Agent_Retailer__c retailerData2 = new aa_Agent_Retailer__c(Name = AA_Constants.RetailerSample);
       insert retailerData2;
        aa_Agent_App_User_Preference__c userpref = new aa_Agent_App_User_Preference__c(UserId__c=user.Id,Cluster__c=NULL,Country__c= countryData2.Id,Retailer__c=retailerData2.Id,Category__c=compCategory.Id,Is_Accepted_Terms_Condition__c=true);
        insert userpref;
        
        AA_AgentAppServiceController obj =new AA_AgentAppServiceController();
          
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
        aa_Cluster__c clusterData2 = new aa_Cluster__c(Name = 'Global');
        insert clusterData2;
        aa_Country__c countryData = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
        insert countryData;
        
        system.runAs(user){

       AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();

       objAgentApp.UnileverBrandId = uniBrand.id;
       objAgentApp.CountryId = countryData.id;
      
       objAgentApp.Retailer = retailerData.Id;
       objAgentApp.ReportingOn = 'Look-a-like';
       objAgentApp.Town = 'Pune';
       objAgentApp.Latitude = '18.5203° N';
       objAgentApp.Longitude = '73.8567° E';
       objAgentApp.RecordTypeId = recTypeId;
       objAgentApp.ClusterId = clusterData.id;
       objAgentApp.FilterType = 'filterReports';     
       objAgentApp.ApplyFilter = 'false';      
       AA_WrapperUtility.agentReportDetail objGetAllReports = new AA_WrapperUtility.agentReportDetail();

       AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
       obj1.objAgentAppDataRequest = objAgentApp;
 
       AA_ApplicationWrapperObj result= obj.retriveAllAgentReports(obj1);
        
       system.assert(result.objAgentAppDataRequest!=null);
    }*/  
     }
         
  //Check getUserList Positive Test.
  static testMethod void getUserList_Test_Positive(){
        User user = new User();
<<<<<<< HEAD
        user.Username ='testuser5@gmail.com';
=======
        user.Username ='testagentuser304@gmail.com';
>>>>>>> develop
        user.FirstName=AA_constants.testString;
        user.LastName = AA_constants.testString;
        user.Email = AA_Constants.Stringtestemail;
        user.alias = AA_constants.testString;
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = AA_Constants.Stringen_us;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = [select id from Profile where Name='System Administrator'].Id;
        user.LanguageLocaleKey = AA_Constants.Stringen_us;
        user.IsActive=true;
        insert user;
    
        AA_AgentAppServiceController obj =new AA_AgentAppServiceController();
        AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
        // for users 
        objAgentApp.searchString = 'test';
        objAgentApp.searchType='users';
        AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
        obj1.objAgentAppDataRequest = objAgentApp;
        obj1.serviceName=AA_Constants.SVC_AGENT_APP_AUTOCOMPLETELIST;
       // AA_ApplicationWrapperObj result= obj.getUserList(obj1);
       obj.getUserList(obj1);
        // Topic topictest=new Topic(Name=AA_Constants.testString);
       //for topics
        objAgentApp.searchString = 'test';
        objAgentApp.searchType='topics';
        AA_ApplicationWrapperObj obj2 = new AA_ApplicationWrapperObj();
        obj2.objAgentAppDataRequest = objAgentApp;
        obj2.serviceName=AA_Constants.SVC_AGENT_APP_AUTOCOMPLETELIST;
        AA_ApplicationWrapperObj result1= obj.getUserList(obj2);

        system.assertEquals(result1.serviceName,AA_Constants.SVC_AGENT_APP_AUTOCOMPLETELIST);
        
                
        
   }
   
   //Check getUserList Negative Test.
  static testMethod void getUserList_Test_Negative(){
        
        AA_AgentAppServiceController obj =new AA_AgentAppServiceController();
        AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
        objAgentApp.searchString = '';
        objAgentApp.searchType='';
       
        AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
        obj1.objAgentAppDataRequest = objAgentApp;
        obj1.serviceName=AA_Constants.SVC_AGENT_APP_AUTOCOMPLETELIST;
        AA_ApplicationWrapperObj result= obj.getUserList(obj1);
        system.assertEquals(result.serviceName,AA_Constants.SVC_AGENT_APP_AUTOCOMPLETELIST);
        
        
   }   
}