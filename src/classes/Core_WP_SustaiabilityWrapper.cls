/*
  Class Name: Core_WP_WorkplaceWrapperClass
  Author : Mindtree
  Date: 29 Nov 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Wrapper class for Workplace Landing Page
*/

public class Core_WP_SustaiabilityWrapper{
    @AuraEnabled
    public String workplaceName {get;set;}

    @AuraEnabled
    public String targetYearLabel {get;set;}
    
    @AuraEnabled
    public Integer targetYearValue {get;set;}
    
    @AuraEnabled
    public String firstMonthLabel {get;set;}
     
    @AuraEnabled
    public Integer firstMonthValue {get;set;}
        
    @AuraEnabled
    public String secondMonthLabel {get;set;}     
    
    @AuraEnabled
    public Integer secondMonthValue {get;set;}
     
    @AuraEnabled
    public String thirdMonthLabel {get;set;}
    
    @AuraEnabled
    public Integer thirdMonthValue {get;set;}
    
    @AuraEnabled
    public String sustainabilityPageInfo {get;set;}
    
    @AuraEnabled
    public String monthValueLowColor {get;set;}
    
    @AuraEnabled
    public String monthValueHighColor {get;set;}
    
    @AuraEnabled
    public String knowledgeSectionHeader {get;set;}
    
    @AuraEnabled
    public String knowledgeSectionBody {get;set;}
    
    @AuraEnabled
    public String tooltipSectionHeader {get;set;}
    
    @AuraEnabled
    public String tooltipSectionBody {get;set;}
}