public with sharing class PACVRiskAssesmentRecords_CC{ 
public List<PACV_Risk_Assessment__c> Records {get; set;} 

public string userid {get; set;}



public PACVRiskAssesmentRecords_CC()
{ 
userid = Userinfo.getUserId();
Records = [SELECT CreatedById,PACV_Project_Name__c,PACV_Project_Start_Date1__c,PACV_Project_Start_Date__c,PACV_Risk_Status__c,PACV_Solution_Name__c,PACV_Status__c,Name FROM PACV_Risk_Assessment__c WHERE CreatedById = :userid]; 
} 
}