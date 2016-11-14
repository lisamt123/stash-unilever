public with sharing class IPM_ExportTeamMembersReportController {
        
        public  Reports.reportResults reportResults{get;set;}
        private Report currentReport;
        private String reportId; 
        private String currUserCompanyCards{get;set;} 
        private static final string TEAM_MEMBER = 'IPM_Team_Members';  
        
        
        
        public IPM_ExportTeamMembersReportController()   
        { 
          // Get the report ID
          List<Report> currentReportList = [SELECT Id,Format,DeveloperName FROM Report where  DeveloperName = : TEAM_MEMBER  LIMIT 1]; // move to util label
          if(!currentReportList.isEmpty())
          {
            currentReport = currentReportList[0];
            reportId = (String)currentReport.get('Id');
            
             //Get the company cards assigned to logged in user and the ones with company cards having  business partner as teh current user 
            Boolean notFirstCmpnyCard=false;          
            for(IPM_User_Profile__c userProfile : [Select IPM_Company_Card__c,IPM_Company_Card__r.name from IPM_User_Profile__c where (IPM_User__c=:UserInfo.getUserID() OR IPM_Company_Card__r.IPM_Business_Partner__c=:UserInfo.getUserID())])
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
    
}