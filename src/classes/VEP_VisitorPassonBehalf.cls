/**********************************************************************
Name: VEP_VisitorPassonBehalf 
Purpose:
This Apex Class is used to get the visitor pass number
and display in email template of visitor on behalf
VERSION   AUTHOR   DATE    
1.0       Leena   Feb-2016   
***********************************************************************/
public with sharing class VEP_VisitorPassonBehalf {
    public Id VisitorId{get; set;}
    
    public VEP_Visitor_Pass__c getVisitorDetail() {
    VEP_Visitor_Pass__c v = new VEP_Visitor_Pass__c();
    v = [Select id,name,visitor__r.name,visitor__c from VEP_Visitor_Pass__c where Visitor__c =: VisitorId Limit 1];
    return v;
}
    
}