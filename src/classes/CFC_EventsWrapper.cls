/*
  Class Name: CFC_EventsWrapper
  Author : Mindtree
  Date: 11 March 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Grouped wrapper request data 
*/
public class CFC_EventsWrapper{

@AuraEnabled
public List<Core_Event> Events{get;set;}

@AuraEnabled
public String DefaultRecordTypeId{get;set;}

public class Core_Event{
@AuraEnabled
public String Banner{get;set;}

@AuraEnabled
public String Description{get;set;}

@AuraEnabled
public DateTime FromDate{get;set;}

@AuraEnabled
public String Id{get;set;}

@AuraEnabled
public String Name{get;set;}

@AuraEnabled
public DateTime ToDate{get;set;}
}
}