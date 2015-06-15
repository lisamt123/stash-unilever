public with sharing class IPM_Gate_RollOuts_Controller{
Id proId;
public IPM_Gate_RollOuts_Controller(){
proId=ApexPages.currentPage().getParameters().get('Id');

}
List<IPM_Country__c> ipm_countries = new List<IPM_Country__c>();

public List<IPM_Country__c> getIpm_countries(){
 
ipm_countries=[select Local_Rollout__r.Regional_Rollout__c,Country_Name__c,Local_Rollout__r.Target_Launch_Date__c,Local_Rollout__c,Local_Rollout__r.IPM_Status__c from IPM_Country__c where IPM_Project__c=:proId];
 
 return ipm_countries;
 
 }

}