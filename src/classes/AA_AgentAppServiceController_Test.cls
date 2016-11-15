@IsTest (SeeAllData=true)
private class AA_AgentAppServiceController_Test {

    //Unilever Report
  static testMethod void insertAgentApp_UnileverTest() {
      //aa_agent_app_custom_setting__c agentAppCustomSetting1 = new aa_agent_app_custom_setting__c(Name = 'Google Api Key',Key__c = 'Google_Api_Key',Value__c='test Value');
       // insert agentAppCustomSetting1; 
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Unilever Agent Report')).getRecordTypeId();
        
       AA_AgentAppServiceController obj =new AA_AgentAppServiceController();
       
       
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
       aa_Agent_Report__c unileverReport = new aa_Agent_Report__c(Report_Title__c = 'Unilever Report 1',Report_Description__c = 'This is a test description',Country__c = countryData.id,Reporting_on__c = 'Look-a-like',Town__c = 'Pune',Retailer__c = retailerData.id,Agent_App_Unilever_Brand__c = uniBrand.id);
       insert unileverReport;
       
       AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
       objAgentApp.UnileverBrandId = uniBrand.id;
       objAgentApp.CountryId = countryData.id;
       objAgentApp.ReportName = unileverReport.Report_Title__c;
       objAgentApp.ReportDesc = unileverReport.Report_Description__c;
       objAgentApp.Retailer = retailerData.Id;
       objAgentApp.ReportingOn = 'Look-a-like';
       objAgentApp.Town = 'Pune';
       objAgentApp.Latitude = '18.5203° N';
       objAgentApp.Longitude = '73.8567° E';
       objAgentApp.RecordTypeId = recTypeId;
       
       obj.convertRequestAgentReport(objAgentApp);
       AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
       obj1.objAgentAppDataRequest = objAgentApp;
       obj.insertAgentApp(obj1);
       obj.getAutoPopulatedValues_UnileverReport(obj1);
        system.assertEquals(objAgentApp.ReportName,unileverReport.Report_Title__c);
     }
  
    
  //Competitor Test
    static testMethod void insertAgentApp_CompetitorTest() {
    
    //aa_agent_app_custom_setting__c agentAppCustomSetting1 = new aa_agent_app_custom_setting__c(Name = 'Google Api Key',Key__c = 'Google_Api_Key',Value__c='test Value');
       // insert agentAppCustomSetting1; 
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
       aa_Agent_Report__c competitorReport = new aa_Agent_Report__c(Report_Title__c = 'Competitor Report 1',Report_Description__c = 'this a test comp report',Competitor_Name__c = compName.id,Competitor_Brand__c = compBrand.id,Is_Accepted_Code_of_Conduct__c = true,Category__c = compCategory.id,Topic__c = topic.Id,Sub_Topics__c = 'Marketing is a subtopic of Campaign',Source__c = 'Overheard from 3rd parties, Unsolicited',Country__c = countryData.id,Town__c = 'Pune',Retailer__c = retailerData.id);
       insert competitorReport;
       
       aa_Topic__c newtopic=new aa_Topic__c(Name='topic name');
       AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
       
       objAgentApp.ReportName = competitorReport.Report_Title__c;
       objAgentApp.ReportDesc = competitorReport.Report_Description__c;
       objAgentApp.CompetitorId = compName.id;
       objAgentApp.CompetitorBrandId = compBrand.id;
       objAgentApp.CategoryId = compCategory.id;
       objAgentApp.CodeOfConduct = 'true';
       objAgentApp.Source = competitorReport.Source__c;
       objAgentApp.Retailer = retailerData.Id;
       objAgentApp.ReportingOn = 'Look-a-like';
       objAgentApp.CountryId = countryData.id;
       objAgentApp.Town = 'Pune';
       objAgentApp.Latitude = '18.5203° N';
       objAgentApp.Longitude = '73.8567° E';
       objAgentApp.RecordTypeId = recTypeId;
       objAgentApp.TopicId=newtopic.Id;
      // objAgentApp.CodeOfConduct='true';
       
       obj.convertRequestAgentReport_Competitor(objAgentApp);
       AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
       obj1.objAgentAppDataRequest = objAgentApp;
       obj.insertAgentApp_Competitor(obj1);
       obj.getCompetitorNameAndCategory_CompetitorReport(obj1);
       
       aa_Agent_App_Competitor_Brand__c uniBrand1 = new aa_Agent_App_Competitor_Brand__c(Name='Dove',RecordTypeId=recTypeId1);
       insert uniBrand1;
       aa_Agent_Retailer__c retailerData1 = new aa_Agent_Retailer__c(Name = '7-Eleven');
       insert retailerData1;
       aa_Cluster__c clusterData1 = new aa_Cluster__c(Name = 'South Asia');
       insert clusterData1;
       aa_Country__c countryData1 = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
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
    
    //IsAccepted Test
    static testMethod void isAcceptedTermsAndConditionTest(){
        aa_Agent_App_User_Preference__c UserPref = new aa_Agent_App_User_Preference__c(UserId__c = UserInfo.getUserId(),Is_Accepted_Terms_Condition__c = true);
        insert UserPref;
        AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
        obj1.isAcceptedTermsCondition = true;
          
        AA_AgentAppServiceController obj =new AA_AgentAppServiceController();
        obj.isAcceptedTermsAndCondition(obj1);
        system.assertEquals(UserPref.Is_Accepted_Terms_Condition__c,true);
          
    }
    //UpdatesIsAccepted Test
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
        
        EmailEncodingKey='UTF-8', LastName='Tes3423423ting', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles', UserName='sdadaas123@testorg.com');
        System.runAs(u2) {
         
        obj4.updateIsAcceptedTermsAndCondition(wapperobj2);
          
          }
    }
  
    
    // updateLikeCount Test
  static testMethod void updateLikeCountTest(){
    
        //aa_agent_app_custom_setting__c agentAppCustomSetting1 = new aa_agent_app_custom_setting__c(Name = 'Google Api Key',Key__c = 'Google_Api_Key',Value__c='test Value');
        //insert agentAppCustomSetting1; 
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
       aa_Country__c countryData = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
       insert countryData;
       aa_Agent_Report__c unileverReport = new aa_Agent_Report__c(Report_Title__c = 'Unilever Report 1',Country__c = countryData.id,Reporting_on__c = 'Look-a-like',Town__c = 'Pune',Retailer__c = retailerData.id,Agent_App_Unilever_Brand__c = uniBrand.id);
       insert unileverReport;
        AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
        objAgentApp.UnileverBrandId = uniBrand.id;
        objAgentApp.CountryId = countryData.id;
        objAgentApp.ReportName = unileverReport.Report_Title__c;
        objAgentApp.Retailer = retailerData.Id;
        objAgentApp.ReportingOn = 'Look-a-like';
        objAgentApp.Town = 'Pune';
        objAgentApp.Latitude = '18.5203° N';
        objAgentApp.Longitude = '73.8567° E';
        objAgentApp.RecordTypeId = recTypeId;
        objAgentApp.AgentReportId=unileverReport.id;
        obj.convertRequestAgentReport(objAgentApp);
        AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
        obj1.objAgentAppDataRequest = objAgentApp;
        
         aa_Agent_App_Competitor_Brand__c uniBrand1 = new aa_Agent_App_Competitor_Brand__c(Name='Dove',RecordTypeId=recTypeId1);
       insert uniBrand1;
       aa_Agent_Retailer__c retailerData2 = new aa_Agent_Retailer__c(Name = '7-Eleven');
       insert retailerData2;
       aa_Cluster__c clusterData2 = new aa_Cluster__c(Name = 'South Asia');
       insert clusterData2;
       aa_Country__c countryData3 = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
       insert countryData3;
       aa_Topic__c topic=new aa_Topic__c();
       insert topic;
       
       aa_Agent_Competitor__c competitor=new aa_Agent_Competitor__c();
       insert competitor;
       
       aa_Agent_App_Category__c cate=new aa_Agent_App_Category__c();
       insert cate;
        
        
        
        obj.getAutoPopulatedValues_UnileverReport(obj1);
        obj.insertAgentApp(obj1);
        obj1.UpdateLikeCount = true;
        obj.updateLikeCount(obj1);
       // obj.updateUnlikeCount(obj1);
         system.assert(obj!=null);
   
  }
    static testMethod void retriveAllAgentReportsTest_ApplyFilterFalse(){
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
        aa_Country__c countryData = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
        insert countryData;
        aa_Agent_Report__c unileverReport1 = new aa_Agent_Report__c(Report_Title__c = 'Unilever Report 1',Country__c = countryData.id,Reporting_on__c = 'Look-a-like',Town__c = 'Pune',Retailer__c = retailerData.id,Agent_App_Unilever_Brand__c = uniBrand.id,Status__c = 'Published (Public)');
        insert unileverReport1;
        aa_Agent_Report__c unileverReport2 = new aa_Agent_Report__c(Report_Title__c = 'Unilever Report 1',Country__c = countryData.id,Reporting_on__c = 'Look-a-like',Town__c = 'Pune',Retailer__c = retailerData.id,Agent_App_Unilever_Brand__c = uniBrand.id,Status__c = 'Published (Public)');
        insert unileverReport2;
        
        List<aa_Agent_Report__c> unileverReport = new List<aa_Agent_Report__c>();
        unileverReport.add(unileverReport1);
         unileverReport.add(unileverReport2);
         // aa_Agent_App_User_Preference__c UserPref = new aa_Agent_App_User_Preference__c(UserId__c = UserInfo.getUserId(),Is_Accepted_Terms_Condition__c = true, Country__c = countrydata.id,Cluster__c = clusterData.id);
        //insert UserPref;
        
       AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
       objAgentApp.UnileverBrandId = uniBrand.id;
       objAgentApp.CountryId = countryData.id;
       objAgentApp.ReportName = unileverReport1.Report_Title__c;
       objAgentApp.ReportDesc = unileverReport1.Report_Description__c;
       objAgentApp.Retailer = retailerData.Id;
       objAgentApp.ReportingOn = 'Look-a-like';
       objAgentApp.Town = 'Pune';
       objAgentApp.Latitude = '18.5203° N';
       objAgentApp.Longitude = '73.8567° E';
       objAgentApp.RecordTypeId = recTypeId;
       //.FilterType=='filterReports'
       objAgentApp.ClusterId = clusterData.id;
       objAgentApp.FilterType = 'filterReports';
       //objAgentAppDataRequest.ApplyFilter=='true'
       objAgentApp.ApplyFilter = 'false';
       objAgentApp.RecordType = 'Unilever';
       List<AA_WrapperUtility.agentReportDetail> objFinalReport = new List<AA_WrapperUtility.agentReportDetail>(); 
       AA_WrapperUtility.agentReportDetail objGetAllReports = new AA_WrapperUtility.agentReportDetail();
       for(aa_Agent_Report__c item : unileverReport)
                {
                 
                    objGetAllReports.agentReportID = item.Id;
                    objGetAllReports.unilever_brandId = item.Agent_App_Unilever_Brand__c;
                    objGetAllReports.retailerId = item.Retailer__c; 
                    objGetAllReports.userImgUrl=item.CreatedBy.SmallPhotoUrl;
                    objGetAllReports.reportTitl=item.Report_Title__c;
                    objGetAllReports.unilever_brand=item.Agent_App_Unilever_Brand__r.Name;
                    objGetAllReports.retailer=item.Retailer__r.Name;
                    objGetAllReports.town=item.Town__c;
                    objGetAllReports.country=item.Country__r.Name;
                   // objGetAllReports.status =item.Status__c;
                    }
        objFinalReport.add(objGetAllReports);
        AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
          obj1.objAgentAppDataRequest = objAgentApp;
        obj1.objPassAgentReportsToNG = objFinalReport;
        obj.retriveAllAgentReports(obj1);
        
                system.assert(obj!=null);
    }
    static testMethod void retriveAllAgentReportsTest_ApplyFilterTrue(){
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
       aa_Agent_Report__Feed agentFeed = new aa_Agent_Report__Feed();
      
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
       objAgentApp.FilterType = 'filterReports';
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
        objFinalReport.add(objGetAllReports);
        AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
          obj1.objAgentAppDataRequest = objAgentApp;
        obj1.objPassAgentReportsToNG = objFinalReport;
        obj.retriveAllAgentReports(obj1);
        obj.retrieveAgentReportsOnMostliked(obj1);
                system.assert(obj!=null);
    }
    
      static testMethod void updateUnLikeCountTest(){
    
        //aa_agent_app_custom_setting__c agentAppCustomSetting1 = new aa_agent_app_custom_setting__c(Name = 'Google Api Key',Key__c = 'Google_Api_Key',Value__c='test Value');
        //insert agentAppCustomSetting1; 
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
       aa_Country__c countryData = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
       insert countryData;
        
       aa_Agent_Report__c unileverReport = new aa_Agent_Report__c(Report_Title__c = 'Unilever Report 1',Country__c = countryData.id,Reporting_on__c = 'Look-a-like',Town__c = 'Pune',Retailer__c = retailerData.id,Agent_App_Unilever_Brand__c = uniBrand.id);
       insert unileverReport;
                
       FeedItem fi2 = new FeedItem();
            fi2.body = 'New Agent File uploaded';
            fi2.Type = 'TextPost' ;
            fi2.Title = 'Agent File';           
            fi2.ParentId = unileverReport.Id;
       //     system.debug('feed iem to be inserted '+fi2);
            insert fi2;          
       unileverReport.Chatter_Post_ID__c=fi2.Id;
       update unileverReport;
       
        AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
        objAgentApp.AgentReportId=unileverReport.id;
        obj.convertRequestAgentReport(objAgentApp);
        AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
        obj1.objAgentAppDataRequest = objAgentApp;
      
        obj.insertAgentApp(obj1);
        //obj1.UpdateUnLikeCount = true;
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
        
       
        
        
         aa_Agent_App_Competitor_Brand__c uniBrand2 = new aa_Agent_App_Competitor_Brand__c(Name='Dove',RecordTypeId=recTypeId1);
       insert uniBrand2;
       aa_Agent_Retailer__c retailerData4 = new aa_Agent_Retailer__c(Name = '7-Eleven');
       insert retailerData4;
       aa_Cluster__c clusterData3 = new aa_Cluster__c(Name = 'South Asia');
       insert clusterData3;
       aa_Country__c countryData4 = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
       insert countryData4;
       aa_Topic__c topic=new aa_Topic__c();
       insert topic;
       
       aa_Agent_Competitor__c competitor=new aa_Agent_Competitor__c();
       insert competitor;
       
       aa_Agent_App_Category__c cate=new aa_Agent_App_Category__c();
       insert cate;
        obj.getAutoPopulatedValues_UnileverReport(obj1);
        
        system.assert(obj!=null);
   
  }
    
     static TestMethod void convertRequestAgentReportDocument_Test(){
        
    AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
    ContentVersion contentVersionObj = new ContentVersion();
        contentVersionObj.ContentURL='http://www.google.com/';
        contentVersionObj.Title = 'test';           
        insert contentVersionObj;
    objAgentApp.ContentDocumentId=contentVersionObj.id;
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
       list<String> agentAPPIDInserted=new List<String>();
       agentAPPIDInserted.add(unileverReport.ID);
       AA_AgentAppServiceController serobj=new AA_AgentAppServiceController();
       serobj.convertRequestAgentReportDocument(objAgentApp,agentAPPIDInserted);
        system.assert(unileverReport!=null);
    
    }
    
   }