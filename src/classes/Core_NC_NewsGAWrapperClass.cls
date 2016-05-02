/*
  Class Name: Core_NC_NewsGAWrapperClass
  Author : Mindtree
  Date: 2 Nov 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Wrapper class for Google Analytics information
*/

public class Core_NC_NewsGAWrapperClass{
    @AuraEnabled
    public String UserId {get;set;}
    
    @AuraEnabled
    public String GAId {get;set;}
 
}