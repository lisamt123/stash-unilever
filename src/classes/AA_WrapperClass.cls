public class AA_WrapperClass{
    /**
     * @date        -   03/08/2015
     * @description -   In order to send response in wrapper object
     * @modifiedby  -
    */
    public class AgentAppDataResponse {
            @AuraEnabled
            public List<aa_Cluster__c> clusterList;
            
            @AuraEnabled
            public List<aa_Country__c> countryList;
            
            @AuraEnabled
            public List<String> reportingOnPicklistValues;
            
            @AuraEnabled
            public List<String> sourcePicklistValues;
           
            @AuraEnabled
            public List<aa_Agent_Retailer__c> unileverRetailerList;
               
            @AuraEnabled
            public List<aa_Agent_App_Competitor_Brand__c> unileverBrandList;
           
            @AuraEnabled
            public List<aa_Agent_App_Competitor_Brand__c> competitorBrandList;
            
            @AuraEnabled
            public List<aa_Agent_Competitor__c> competitorNameList;
            
            @AuraEnabled
            public List<aa_Agent_App_Category__c> categoryList;
            
            @AuraEnabled
            public Map<String,String> competitorCategoryMap;
            
            @AuraEnabled
            public List<aa_Agent_App_Brand_Category__c> selectedCompetitorCategoryOnBrand;
            
            @AuraEnabled
            public List<aa_Topic__c> topicList;
            
            @AuraEnabled
            public List<sObject>  autocompleteList;
            
            @AuraEnabled
            public List<aa_Agent_Report__c> agentReportList;
            
            @AuraEnabled
            public String agentReportId;
            
            @AuraEnabled
            public String googleApiValue;
            // public Map<String,String> usernamesMap;
        }
        
        /**
     * @date        -   03/08/2015
     * @description -   In order to get request in wrapper object
     * @modifiedby  -
    */
    public class AgentAppDataRequest {
            @AuraEnabled
            public String ReportName;
            @AuraEnabled
            public String ReportDesc;
            @AuraEnabled
            public String CompetitorBrand;
            @AuraEnabled
            public String CompetitorBrandId;
            @AuraEnabled
            public String CompetitorName;
            @AuraEnabled
            public String CompetitorId;
            @AuraEnabled
            public String CountryId;
            @AuraEnabled
            public String CountryName;
            @AuraEnabled
            public String CategoryId;
            @AuraEnabled
            public String CategoryName;
            @AuraEnabled
            public String Retailer;
            @AuraEnabled
            public String TopicName;
            @AuraEnabled
            public String TopicId;
            @AuraEnabled
            public String SubTopic;
            @AuraEnabled
            public String Source;
            @AuraEnabled
            public String UnileverBrandName;
            @AuraEnabled
            public String UnileverBrandId;
            @AuraEnabled
            public String ReportingOn;
            @AuraEnabled
            public String ClusterId;
            @AuraEnabled
            public String Country;
            @AuraEnabled
            public String CodeOfConduct;
            @AuraEnabled
            public String Town;
            @AuraEnabled
            public String Latitude;   
            @AuraEnabled
            public String Longitude;
            @AuraEnabled
            public String ContentDocumentId;
            @AuraEnabled
            public String RecordTypeId;
            @AuraEnabled
            public String FilterType;
            @AuraEnabled
            public String ApplyFilter;
            @AuraEnabled
            public Integer OffSet;
            @AuraEnabled
            public Integer LimitRecords;
            @AuraEnabled
            public String RecordType;
            @AuraEnabled
            public String AgentReportId;
            @AuraEnabled
            public String SortOnMostLike;
            @AuraEnabled
            public String Status;
            @AuraEnabled
            public String searchString;
            @AuraEnabled
            public String searchType;
            @AuraEnabled
            public List<String> usertomentionIds;
            @AuraEnabled
            public List<String> topicIds;
          
            /* Other brand and company names */
            @AuraEnabled
            public String OtherBrandName;
            @AuraEnabled
            public String OtherCompetitor; 
           
        }
        
         /**
     * @date        -   03/08/2015
     * @description -   Provide list of reports to angularJS from salesforce
     * @modifiedby  -
    */
     public class agentReportDetail  implements Comparable {
            @AuraEnabled
            public String agentReportID; 
            @AuraEnabled
            public String userImgUrl; 
            @AuraEnabled
            public String reportTitl;
            @AuraEnabled
            public String reportDesc;
            @AuraEnabled
            public String unilever_brand ;
            @AuraEnabled
            public String competitor_name;
            @AuraEnabled
            public String competitor_brand ;
            @AuraEnabled
            public String retailer;
            @AuraEnabled
            public String unilever_brandId ;
            @AuraEnabled
            public String competitor_nameId;
            @AuraEnabled
            public String competitor_brandId ;
            @AuraEnabled
            public String retailerId;
            @AuraEnabled
            public String town;
            @AuraEnabled
            public String country;
            @AuraEnabled
            public String postImgUrl;
            @AuraEnabled
            public String createdTime;
            @AuraEnabled
            public String clusterName ;
            @AuraEnabled
            public String clusterId;
            @AuraEnabled
            public String status;
            @AuraEnabled
            public String recordType;
            @AuraEnabled
            public String CreatedBy;
            @AuraEnabled
            public String CountryId;
            @AuraEnabled
            public List<aa_Agent_Report__Feed> feedList;
            @AuraEnabled
            public String UserLike;
            @AuraEnabled
            public Integer LikeCount=0;
            @AuraEnabled
            public Integer TotalCommentCount=0;
            @AuraEnabled
            public String DocumentUrl;
            @AuraEnabled
            public String currentTime;
            
            public Integer compareTo(Object objToCompare) {
          
                agentReportDetail compareToreport=(agentReportDetail)objToCompare;
            
                if (LikeCount == compareToreport.LikeCount)  return 0;
                if (LikeCount < compareToreport.LikeCount) return 1;
                   return -1; 
                }          
            }
    
    //Provide Ids that are required while filtering.
     public class AgentAppFilterRequest {
            @AuraEnabled
            public Id GlobalClusterId;
            @AuraEnabled
            public Id UnileverRecordTypeId;
            @AuraEnabled
            public Id CompetitorRecordTypeId;
            @AuraEnabled
            public String OtherCompetitorBrandId;
     } 
}