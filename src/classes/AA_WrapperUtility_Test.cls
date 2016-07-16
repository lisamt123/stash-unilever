@isTest
/**
 * Name:        -   AA_WrapperUtility_Test
 * @description -   This is the test class for AA_WrapperUtility Class to verify the code to get request, send response in wrapper Objects.
 					and provide list of reports to angularJs from Salesforce 
 *	@Author      -   Aslesha R K     
 */
private class AA_WrapperUtility_Test {

    static testMethod void myUnitTest() {
		/*********************************************************************************************************************
			Purpose: Method to test if we could get request, send Respose and provide List of Reports to AngularJS from Salesorce .
		************************************************************************************************************************/
        AA_WrapperUtility.AgentAppDataRequest req= new AA_WrapperUtility.AgentAppDataRequest();
        AA_WrapperUtility.AgentAppDataResponse res = new AA_WrapperUtility.AgentAppDataResponse();
        AA_WrapperUtility.AgentReportDataResponse repResp = new AA_WrapperUtility.AgentReportDataResponse();
        AA_WrapperUtility.agentReportDetail repDetail = new AA_WrapperUtility.agentReportDetail();
        AA_WrapperUtility.FilterTypeRequest filterRequest = new AA_WrapperUtility.FilterTypeRequest();
        
        aa_Agent_App_Category__c cat=new aa_Agent_App_Category__c();
        req.CategoryId=cat.id;
        
        aa_Cluster__c clust=new aa_Cluster__c();
        req.ClusterId=clust.id;
        
        aa_Agent_App_Competitor_Brand__c compbrand=new aa_Agent_App_Competitor_Brand__c();
        req.CompetitorBrand=compbrand.id;
        
        req.ApplyFilter='true';
        req.CodeOfConduct='true';
        req.FilterType='Allreports';
        req.OffSet='0';
        req.LimitRecords='12';
        req.SortOnMostLike='true';
        
       // List<aa_Agent_Report__c> reportList=new List<aa_Agent_Report__c>();
       aa_Country__c country =new aa_Country__c();
       aa_Agent_Report__c report1=new aa_Agent_Report__c(Report_Title__c='test report',country__c=country.id);
       aa_Agent_Report__c report2=new aa_Agent_Report__c(Report_Title__c='test report1',country__c=country.id); 
       aa_Agent_Report__c report3=new aa_Agent_Report__c(Report_Title__c='test report2',country__c=country.id); 
        
        AA_WrapperUtility.agentReportDetail repDetail0 = new AA_WrapperUtility.agentReportDetail(); 
        repDetail0.agentReportID=report1.Id;
        repDetail0.LikeCount=0;
        repDetail0.compareTo(repDetail0);  
        
        AA_WrapperUtility.agentReportDetail repDetail1 = new AA_WrapperUtility.agentReportDetail();  
         
        repDetail1.agentReportID=report2.Id;
        repDetail1.LikeCount=1;
        repDetail1.compareTo(repDetail0); 
        
        AA_WrapperUtility.agentReportDetail repDetail2 = new AA_WrapperUtility.agentReportDetail(); 
        repDetail2.agentReportID=report3.Id;
        repDetail2.LikeCount=2;
        repDetail2.compareTo(repDetail1); 
        
        system.assertNotEquals(req!=null,null);
        system.assertNotEquals(res!=null,null);
        system.assertNotEquals(repResp!=null,null);
        system.assertNotEquals(repDetail!=null,null);
        system.assertNotEquals(filterRequest!=null,null);
    }
}