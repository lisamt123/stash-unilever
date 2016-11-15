@isTest
private class AA_DatabaseServiceUtil_Test {

    static testMethod void upsertOperationTest() {
        aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = '7-Eleven');
        insert retailerData;
        List<aa_Agent_Retailer__c> retailerDataLst = new   List<aa_Agent_Retailer__c>();
        retailerDataLst.add(retailerData);
        List<String> res = AA_DatabaseServiceUtil.upsertOperation(retailerDataLst);
        
        List<String> res3 = AA_DatabaseServiceUtil.upsertOperation(retailerData);
        
        //invalid obj
        sObject tst;
        //insert tst;
        List<String> res1 = AA_DatabaseServiceUtil.upsertOperation(tst);        
        
        //invalid lst
        List<sobject> lst;
        List<String> res2 = AA_DatabaseServiceUtil.upsertOperation(lst);
        
        Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
        Id recTypeId1 = (RT1.get('Unilever Brand')).getRecordTypeId();
        
        aa_Agent_App_Competitor_Brand__c uniBrand = new aa_Agent_App_Competitor_Brand__c(Name='Dove',RecordTypeId=recTypeId1);
       insert uniBrand;
        aa_Cluster__c clusterData = new aa_Cluster__c(Name = 'South Asia');
       insert clusterData;
       aa_Country__c countryData = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
       insert countryData;
       aa_Agent_Report__c unileverReport = new aa_Agent_Report__c(Report_Title__c = 'Unilever Report 1',Country__c = clusterData.id,Reporting_on__c = 'test',Town__c = 'Pune',Retailer__c = retailerData.id,Agent_App_Unilever_Brand__c = uniBrand.id);
       //insert unileverReport;         
        
        
        List<String> res4 = AA_DatabaseServiceUtil.upsertOperation(unileverReport);
        
        List<aa_Agent_Report__c> reportLst=new List<aa_Agent_Report__c>();
        reportLst.add(unileverReport);
        List<String> res5 = AA_DatabaseServiceUtil.upsertOperation(reportLst);
        
        system.assert(res.size()>0);
    }
    static testMethod void deleteOperationListTest() {
        aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = '7-Eleven');
        insert retailerData;
        List<aa_Agent_Retailer__c> retailerDataLst = new   List<aa_Agent_Retailer__c>();
        retailerDataLst.add(retailerData);
        List<String> res = AA_DatabaseServiceUtil.deleteOperation(retailerDataLst);
        
        List<sObject> lst=new List<sObject>();
        lst.add(retailerData);
        List<String> res1 = AA_DatabaseServiceUtil.deleteOperation(lst);
        
        system.assert(res.size()>0);
    }
    static testMethod void deleteOperationTest() {
        aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = '7-Eleven');
        insert retailerData;
        
        List<String> res = AA_DatabaseServiceUtil.deleteOperation(retailerData);
        system.assert(res.size()>0);
        
        List<String> res1 = AA_DatabaseServiceUtil.deleteOperation(retailerData);
        
        sObject tst;
        List<String> res2 = AA_DatabaseServiceUtil.deleteOperation(tst);
        system.assert(res.size()>0);
        
    }
    static testMethod void getRecordTypeId() {
        Id res = AA_DatabaseServiceUtil.getRecordTypeId('aa_Agent_Report__c','Unilever_Agent_Report');
        system.debug('Recordtype id '+AA_DatabaseServiceUtil.getRecordTypeId('aa_Agent_Report__c','Unilever Agent Report'));
         //system.assert(res,true);
    }
    static testMethod void getPickListValues() {
        AA_DatabaseServiceUtil obj = new AA_DatabaseServiceUtil();
        List<String> res = obj.getPickListValues('aa_Agent_Report__c','Status__c');
        system.debug('picklist values id '+obj.getPickListValues('aa_Agent_Report__c','Status__c'));
       // system.assert(res.size()>0);  
    }
    static testMethod void validateId() {
        Boolean res = AA_DatabaseServiceUtil.validateId('012c00000008rxM');
        system.debug('validate id'+AA_DatabaseServiceUtil.validateId('012c00000008rxM'));
        system.assertEquals(res,true);
    }
    
    static testMethod void insertOperationTest() {
        
        Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
        Id recTypeId1 = (RT1.get('Unilever Brand')).getRecordTypeId();
        
       aa_Agent_App_Competitor_Brand__c uniBrand = new aa_Agent_App_Competitor_Brand__c(Name='Dove',RecordTypeId=recTypeId1);
       insert uniBrand;
       aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = '7-Eleven');
       insert retailerData;
       aa_Cluster__c clusterData = new aa_Cluster__c(Name = 'South Asia');
       insert clusterData;
       aa_Country__c countryData = new aa_Country__c(Name = 'India',Cluster_Id__c = clusterData.id);
       insert countryData;
       aa_Agent_Report__c unileverReport = new aa_Agent_Report__c(Report_Title__c = 'Unilever Report 1',Country__c = countryData.id,Reporting_on__c = 'Look-a-like',Town__c = 'Pune',Retailer__c = retailerData.id,Agent_App_Unilever_Brand__c = uniBrand.id);
       insert unileverReport;      
       
       
        List<String> res = AA_DatabaseServiceUtil.insertOperation(unileverReport.id,'');
        
        ContentVersion contentVersionObj = new ContentVersion();
        contentVersionObj.ContentURL='http://www.google.com/';
        contentVersionObj.Title = 'test';           
        insert contentVersionObj;
        List<String> res1 = AA_DatabaseServiceUtil.insertOperation(unileverReport.id,contentVersionObj.id);
        List<String> res2 = AA_DatabaseServiceUtil.insertOperation(unileverReport.id,'test');
        //commented as part of 10 Nov 2015 deployment 
        //system.assert(res1.size()>0);
    }
    // Added as part of Nov 13 deployment 
    static testMethod void invokeTriggerAA_AgentReportRejected_Email(){
    aa_Agent_Report__c recNew = new aa_Agent_Report__c(Name='TestAgentReport102938');
    try{
       insert recNew;
       delete recNew;
       }
       catch(Exception e){
       system.debug('Inside Catch');
       }
    }
    
}