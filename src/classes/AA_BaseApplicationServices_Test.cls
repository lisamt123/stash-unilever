@isTest
/**
 * Name:        -   AA_BaseApplicationServices_Test
 * @description -   This is the test class for AA_BaseApplicationServices Class to verify the code to get all the basic application services..Example: Handle service request to create unilever report.
 * @Author      -   Aslesha R K     
 */

private class AA_BaseApplicationServices_Test {

    static testMethod void myUnitTest() {
    	/*******************************************************************************
			Purpose: Method to test if we could handle all the basic application services.
		********************************************************************************/
       Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
        
      
       aa_Agent_App_Competitor_Brand__c compBrand = new aa_Agent_App_Competitor_Brand__c(Name = 'BBOthers');
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
     
       
       AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
       objAgentApp.CompetitorId = compName.id;
       objAgentApp.CompetitorBrandId = compBrand.id;
       objAgentApp.CategoryId = compCategory.id;
       objAgentApp.CodeOfConduct = 'true';
       objAgentApp.Retailer = retailerData.Id;
       objAgentApp.ReportingOn = 'Look-a-like';
       objAgentApp.CountryId = countryData.id;
       objAgentApp.Town = 'Pune';
       objAgentApp.Latitude = '18.5203° N';
       objAgentApp.Longitude = '73.8567° E';
        objAgentApp.RecordTypeId = recTypeId;
        AA_ApplicationWrapperObj obj1 = new AA_ApplicationWrapperObj();
        
        obj1.message='test';
        obj1.errorCode='test';
        
       //Call to method with values that handles service request to unlike the report count
        obj1.serviceName = AA_Constants.SVC_AGENT_APP_UNLIKE_UPDATE;
        obj1.objAgentAppDataRequest = objAgentApp;
        AA_BaseApplicationServices.invokeService(obj1);
        
        //Call to method with values that handles service request to fetch all reports to show on landing page
        obj1.serviceName = AA_Constants.SVC_AGENT_APP_GET_ALL_REPORTS;
        obj1.objAgentAppDataRequest = objAgentApp;
        AA_BaseApplicationServices.invokeService(obj1);
        
        //Call to method with values that handles service request to fetch most like reports
        obj1.serviceName = AA_Constants.SVC_AGENT_APP_MOST_LIKE_REPORTS;
        obj1.objAgentAppDataRequest = objAgentApp;
        AA_BaseApplicationServices.invokeService(obj1);
        
        //Call to method with values that handles service request to create unilever report
        obj1.serviceName = AA_Constants.SVC_AGENT_APP_UNILEVER_CREATE;
        obj1.objAgentAppDataRequest = objAgentApp;
        AA_BaseApplicationServices.invokeService(obj1);
        
        //Call to method with values that handles service request to get auto populate values like category ,company name compititor brand 
        obj1.serviceName = AA_Constants.SVC_AGENT_APP_GET_AUTO_POPULATED_VALUES;
        obj1.objAgentAppDataRequest = objAgentApp;
        AA_BaseApplicationServices.invokeService(obj1);
        
        //Call to method with values that handles service request to auto populate the category & company name based on compititor brand
        obj1.serviceName = AA_Constants.SVC_AGENT_APP_GET_COMPETITOR_NAME_AND_CATEGORY;
        obj1.objAgentAppDataRequest = objAgentApp;
        AA_BaseApplicationServices.invokeService(obj1);
        
        //Call to method with values that handles service request to get values for source retailer topic & country 
        obj1.serviceName = AA_Constants.SVC_AGENT_APP_GET_COMPETITOR_SOURCE_RETAILER_TOPIC_COUNTRY;
        obj1.objAgentAppDataRequest = objAgentApp;
        AA_BaseApplicationServices.invokeService(obj1);
        
        //Call to method with values that handles service request to create competitor report
        obj1.serviceName = AA_Constants.SVC_AGENT_APP_COMPETITOR_CREATE;
        obj1.objAgentAppDataRequest = objAgentApp;
        AA_BaseApplicationServices.invokeService(obj1);
        
        //Call to method with values that handles service request to check whether user has accepted terms & conditions
        obj1.serviceName = AA_Constants.SVC_AGENT_APP_TERMS_AND_CONDITION;
        obj1.objAgentAppDataRequest = objAgentApp;
        AA_BaseApplicationServices.invokeService(obj1);
        
        //Call to method with values that handles service request to update the terms & conditions
        obj1.serviceName = AA_Constants.SVC_AGENT_APP_UPDATE_TERMS_AND_CONDITION;
        obj1.objAgentAppDataRequest = objAgentApp;
        AA_BaseApplicationWrapperObj baseobj= AA_BaseApplicationServices.invokeService(obj1);
      
        //Call to method with values that handles service request to update the like count
        obj1.serviceName = AA_Constants.SVC_AGENT_APP_LIKE_UPDATE;
        obj1.objAgentAppDataRequest = objAgentApp;
        AA_BaseApplicationServices.invokeService(obj1);
        
         //Call to method with values that handles service request to update the unlike count      
        obj1.serviceName = AA_Constants.SVC_AGENT_APP_UNLIKE_UPDATE;
        obj1.objAgentAppDataRequest = objAgentApp;
        AA_BaseApplicationServices.invokeService(obj1);
        
       // Topic topicone=new Topic(Name=AA_Constants.testString); 
        objAgentApp.searchString=AA_Constants.testString;
        objAgentApp.searchType='topics';
        obj1.serviceName = AA_Constants.SVC_AGENT_APP_AUTOCOMPLETELIST;
        obj1.objAgentAppDataRequest = objAgentApp;
        AA_BaseApplicationServices.invokeService(obj1);
        
        system.debug('************==>'+baseobj);
        system.assertEquals(baseobj.message ,AA_Constants.testString);
    }
    
    static testMethod void createSerializedMapStringTest(){
    	/********************************************************************
			Purpose: Method to test if we could create serialized map string.
		*********************************************************************/
    
        String response = AA_BaseApplicationServices.createSerializedMapString('{"AgentAppDataRequest":{"FilterType":"AllReports","LimitRecords":12,"OffSet":0}}');
        system.assertEquals(response,'{"OffSet":0,"LimitRecords":12,"FilterType":"AllReports"}');
    }
    
 
  
}