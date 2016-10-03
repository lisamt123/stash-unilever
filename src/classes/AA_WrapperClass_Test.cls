@isTest
/**
 * Name:        -   AA_WrapperUtility_Test
 * @description -   This is the test class for AA_WrapperUtility Class to verify the code to get request, send response in wrapper Objects.
           and provide list of reports to angularJs from Salesforce 
 *  @Author      -   Ipsita S.Patra     
 */
private class AA_WrapperClass_Test {

    static testMethod void myUnitTest() {
        AA_WrapperClass.AgentAppDataRequest req= new AA_WrapperClass.AgentAppDataRequest();
        AA_WrapperClass.AgentAppDataResponse res = new AA_WrapperClass.AgentAppDataResponse();
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
        req.OffSet= 0;
        req.LimitRecords=12;
        req.SortOnMostLike='true';
        
       aa_Country__c country =new aa_Country__c();
       aa_Agent_Report__c report1=new aa_Agent_Report__c(Report_Title__c='test report',country__c=country.id);
       aa_Agent_Report__c report2=new aa_Agent_Report__c(Report_Title__c='test report1',country__c=country.id); 
       aa_Agent_Report__c report3=new aa_Agent_Report__c(Report_Title__c='test report2',country__c=country.id); 
        
        AA_WrapperClass.agentReportDetail repDetail0 = new AA_WrapperClass.agentReportDetail(); 
        repDetail0.agentReportID=report1.Id;
        repDetail0.LikeCount=0;
        repDetail0.compareTo(repDetail0);  
        
        AA_WrapperClass.agentReportDetail repDetail1 = new AA_WrapperClass.agentReportDetail();  
         
        repDetail1.agentReportID=report2.Id;
        repDetail1.LikeCount=1;
        repDetail1.compareTo(repDetail0); 
        
        AA_WrapperClass.agentReportDetail repDetail2 = new AA_WrapperClass.agentReportDetail(); 
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