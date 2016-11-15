global with sharing class AA_WrapperUtility {


    global class AgentReportDataResponse extends AA_BaseApplicationWrapperObj{
           // public list<AllAgentReports> responseReports;
        }
        
    /**
     * @date        -   03/08/2015
     * @description -   In order to get request in wrapper object
     * @modifiedby  -
    */
    global class AgentAppDataRequest {
            public String ReportName;
            public String ReportDesc;
            public String CompetitorBrand;
            public String CompetitorBrandId;
            public String CompetitorName;
            public String CompetitorId;
            public String CountryId;
            public String CountryName;
            public String CategoryId;
            public String CategoryName;
            public String Retailer;
            public String TopicName;
            public String TopicId;
            public String SubTopic;
            public String Source;
            public String UnileverBrandName;
            public String UnileverBrandId;
            public String ReportingOn;
            public String ClusterId;
            public String Country;
            public String CodeOfConduct;
            public String Town;
            public String Latitude;   
            public String Longitude;
            public String ContentDocumentId;
            public String RecordTypeId;
            public String FilterType;
            public String ApplyFilter;
            public String OffSet;
            public String LimitRecords;
            public String RecordType;
            public String AgentReportId;
            public String SortOnMostLike;
           
        }
    
    /**
     * @date        -   03/08/2015
     * @description -   In order to send response in wrapper object
     * @modifiedby  -
    */
    global class AgentAppDataResponse {
            public List<aa_Agent_Report__c> agentRportsList;
            public List<aa_Agent_App_Competitor_Brand__c> unileverBrandList;
            public List<aa_Agent_Retailer__c> unileverRetailerList;
            public List<aa_Country__c> countryList;
            public List<aa_Cluster__c> clusterList;
            public List<String> reportingOnPicklistValues;
            public List<String> sourcePicklistValues;
            public List<aa_Agent_App_Competitor_Brand__c> competitorBrandList;
            public List<aa_Agent_Competitor__c> competitorNameList;
            public List<aa_Agent_App_Category__c> categoryList;
            public Map<String,String> competitorCategoryMap;
            public List<aa_Agent_App_Brand_Category__c> selectedCompetitorCategoryOnBrand;
            public List<aa_Topic__c> topicList;
            public String agentReportId;
            public String googleApiVaue;
            
        }
        
     
     /**
     * @date        -   03/08/2015
     * @description -   Provide list of reports to angularJS from salesforce
     * @modifiedby  -
    */
     global class agentReportDetail  implements Comparable {
            public String agentReportID; 
            public String userImgUrl; 
            public String reportTitl;
            public String reportDesc;
            public String unilever_brand ;
            public String competitor_name;
            public String competitor_brand ;
            public String retailer;
            public String unilever_brandId ;
            public String competitor_nameId;
            public String competitor_brandId ;
            public String retailerId;
            public String town;
            public String country;
            public String postImgUrl;
            public String createdTime;
            public String clusterName ;
            public String clusterId;
            public String status;
            public String recordType;
            public String CreatedBy;
            public String CountryId;
            public List<aa_Agent_Report__Feed> feedList;
            public String UserLike;
            public Integer LikeCount=0;
            public Integer TotalCommentCount=0;
            public String DocumentUrl;
            public String currentTime;
           
            global Integer compareTo(Object objToCompare) {
          
           agentReportDetail compareToreport=(agentReportDetail)objToCompare;
            
               if (LikeCount == compareToreport.LikeCount)  return 0;
               if (LikeCount < compareToreport.LikeCount) return 1;
               return -1; 
          
           
              
             
       
         
          }
           
            /*public String feedId;
            public String likeCount; 
            public String CommentCount;*/
    }
    
    /*global class listOfAgentReport {
        public List<agentReportDetail> responseListofAgentReport; 
    }*/
     
        
     global class FilterTypeRequest{
          public String FilterType;
        
     }
}