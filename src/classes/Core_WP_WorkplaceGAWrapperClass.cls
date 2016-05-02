/*
  Class Name: Core_WP_WorkplaceGAWrapperClass
  Author : Mindtree
  Date: 2 Dec 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Wrapper class for Workplace Landing Page
*/

public class Core_WP_WorkplaceGAWrapperClass{
    @AuraEnabled
    public String workplaceId {get;set;}

    @AuraEnabled
    public String workplaceGaId {get;set;}
    
    @AuraEnabled
    public String userId {get;set;}
}