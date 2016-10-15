public with sharing class IPM_ExportTeamMembersReportController {
        
        public  Reports.reportResults reportResults{get;set;}
        private Report currentReport;
        private String reportId; 
        private String currUserCompanyCards{get;set;}   
        
        
        
        public IPM_ExportTeamMembersReportController()  
        { 
	        // Get the report ID
	        currentReport = [SELECT Id,Format,DeveloperName FROM Report where  DeveloperName = 'IPM_Team_Members' LIMIT 1]; // move to util label
	        reportId = (String)currentReport.get('Id');
	        
	        //Get the company cards assigned to logged in user
	        Boolean notFirstCmpnyCard=false;	        
	        for(IPM_User_Profile__c userProfile : [Select IPM_Company_Card__c,IPM_Company_Card__r.name from IPM_User_Profile__c where IPM_User__c=:UserInfo.getUserID()])
	        {
	        	 
	        	if(notFirstCmpnyCard)
	        	{
	        		currUserCompanyCards=currUserCompanyCards + ',' + userProfile.IPM_Company_Card__r.name;
	        	}
	        	else
	        	{
	        		currUserCompanyCards=userProfile.IPM_Company_Card__r.name;
	        		notFirstCmpnyCard=true; 
	        	} 
	        } 
	        
	        // Get the report metadata
	        Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportId);
	        Reports.ReportMetadata reportMd = describe.getReportMetadata();
	        
	        // Override filter 
	        Reports.ReportFilter filter = reportMd.getReportFilters()[2];
	        filter.setValue(currUserCompanyCards); 
	                        
	       // Run a report synchronously
	        reportResults = Reports.ReportManager.runReport(reportId,reportMd,true);   
            
        }
    
}