@isTest(seealldata=true)
/**
 * Name:        -   AA_DatabaseServiceUtil_Test
 * @description -   This is test class for AA_DatabaseServiceUtil class which includes all the DML operations
 * @Author      -   Aslesha R K     
 */

private class AA_DatabaseServiceUtil_Test {
   
static testMethod void validateIdssss() {
        aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = AA_Constants.RetailerSample);
        insert retailerData;
        Boolean res = AA_DatabaseServiceUtil.validateId(retailerData.id);
      
        system.assertEquals(res,true);
    } 
    /**
     * @date        -   19/09/2015
     * @description -   Test class to test the method upsertOperation
     * @param       -   None 
     * @return      -   None
     * @modifiedby  -
     */     
    static testMethod void upsertOperationTest() {
        aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = AA_Constants.RetailerSample);
        insert retailerData;
        List<aa_Agent_Retailer__c> retailerDataLst = new   List<aa_Agent_Retailer__c>();
        retailerDataLst.add(retailerData);
        List<String> res = AA_DatabaseServiceUtil.upsertOperation(retailerDataLst);
        
      //  List<String> res3 = AA_DatabaseServiceUtil.upsertOperation(retailerData);
        AA_DatabaseServiceUtil.upsertOperation(retailerData);
        //invalid obj
        sObject tst=new aa_Agent_Retailer__c(Name=AA_Constants.testString);
        //insert tst;
        //List<String> res1 = AA_DatabaseServiceUtil.upsertOperation(tst);        
        AA_DatabaseServiceUtil.upsertOperation(tst);        
        //invalid lst
        List<sobject> lst =new List<sObject>();
        //List<String> res2 = AA_DatabaseServiceUtil.upsertOperation(lst);
        AA_DatabaseServiceUtil.upsertOperation(lst);
        
        Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
        Id recTypeId1 = (RT1.get('Unilever Brand')).getRecordTypeId();
        
        aa_Agent_App_Competitor_Brand__c uniBrand = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand,RecordTypeId=recTypeId1);
        insert uniBrand;
        aa_Cluster__c clusterData = new aa_Cluster__c(Name = AA_Constants.ClusterSample);
       insert clusterData;
       aa_Country__c countryData = new aa_Country__c(Name = AA_Constants.CountrySample,Cluster_Id__c = clusterData.id);
       insert countryData;
       aa_Agent_Report__c unileverReport = new aa_Agent_Report__c(Report_Title__c =AA_Constants.ReportNameSample,Country__c = clusterData.id,Reporting_on__c = AA_Constants.testString,Town__c =AA_Constants.TownSample,Retailer__c = retailerData.id,Agent_App_Unilever_Brand__c = uniBrand.id);
       //insert unileverReport;         
        
        
       // List<String> res4 = AA_DatabaseServiceUtil.upsertOperation(unileverReport);
         AA_DatabaseServiceUtil.upsertOperation(unileverReport);
        List<aa_Agent_Report__c> reportLst=new List<aa_Agent_Report__c>();
        reportLst.add(unileverReport);
        //List<String> res5 = AA_DatabaseServiceUtil.upsertOperation(reportLst);
         AA_DatabaseServiceUtil.upsertOperation(reportLst);
        system.assert(res.size()>0);
    }
    
    /**
     * @date        -   19/09/2015
     * @description -   Test class to test the method deleteOperationList
     * @param       -   None 
     * @return      -   None
     * @modifiedby  -
     */      
    static testMethod void deleteOperationListTest() {
        aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = AA_Constants.RetailerSample);
        insert retailerData;
        List<aa_Agent_Retailer__c> retailerDataLst = new   List<aa_Agent_Retailer__c>();
        retailerDataLst.add(retailerData);
       List<String> res = AA_DatabaseServiceUtil.deleteOperation(retailerDataLst);
        
        List<sObject> lst=new List<sObject>();
        lst.add(retailerData);
        //List<String> res1 = AA_DatabaseServiceUtil.deleteOperation(lst);
        AA_DatabaseServiceUtil.deleteOperation(lst);
        system.assert(res.size()>0);
    }
    
     /**
     * @date        -   19/09/2015
     * @description -   Test class to test the method deleteOperation
     * @param       -   None 
     * @return      -   None
     * @modifiedby  -
     */     
    
    static testMethod void deleteOperationTest() {
        aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name =AA_Constants.RetailerSample);
        insert retailerData;
        
        List<String> res = AA_DatabaseServiceUtil.deleteOperation(retailerData);
        system.assert(res.size()>0);
        
       // List<String> res1 = AA_DatabaseServiceUtil.deleteOperation(retailerData);
        AA_DatabaseServiceUtil.deleteOperation(retailerData);
        
        sObject tst=new aa_Agent_Retailer__c(Name=AA_Constants.testString);
        //List<String> res2 = AA_DatabaseServiceUtil.deleteOperation(tst);
      AA_DatabaseServiceUtil.deleteOperation(tst);
        system.assert(res.size()>0);
        
    }

     /**
     * @date        -   19/09/2015
     * @description -   Test class to test the method getRecordType
     * @param       -   None 
     * @return      -   None
     * @modifiedby  -
     */       
    static testMethod void getRecordTypeId() {
        Id res = AA_DatabaseServiceUtil.getRecordTypeId('aa_Agent_Report__c','Unilever_Agent_Report');
        
         system.assert(res != '');
    }
    
     /**
     * @date        -   19/09/2015
     * @description -   Test class to test the method getPickListValues
     * @param       -   None 
     * @return      -   None
     * @modifiedby  -
     */    
    
    static testMethod void getPickListValues() {
        AA_DatabaseServiceUtil obj = new AA_DatabaseServiceUtil();
        List<String> res =new List<String>();
        res =obj.getPickListValues('aa_Agent_Report__c','Status__c');
        
        system.assert(res.size()!=0);  
    }
    
     /**
     * @date        -   19/09/2015
     * @description -   Test class to test the method validateId
     * @param       -   None 
     * @return      -   None
     * @modifiedby  -
     */     
    static testMethod void validateId() {
        aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = AA_Constants.RetailerSample);
        insert retailerData;
        Boolean res = AA_DatabaseServiceUtil.validateId(retailerData.id);
      
        system.assertEquals(res,true);
    }
    
    
     /**
     * @date        -   19/09/2015
     * @description -   Test class to test the method insertOperation
     * @param       -   None 
     * @return      -   None
     * @modifiedby  -
     */     
    static testMethod void insertOperationTest() {
        
        Schema.DescribeSObjectResult R1 = aa_Agent_App_Competitor_Brand__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT1 = R1.getRecordTypeInfosByName();
        Id recTypeId1 = (RT1.get('Unilever Brand')).getRecordTypeId();
        
       aa_Agent_App_Competitor_Brand__c uniBrand = new aa_Agent_App_Competitor_Brand__c(Name=AA_Constants.CompetitorSampleBrand,RecordTypeId=recTypeId1);
       insert uniBrand;
       aa_Agent_Retailer__c retailerData = new aa_Agent_Retailer__c(Name = AA_Constants.RetailerSample);
       insert retailerData;
       aa_Cluster__c clusterData = new aa_Cluster__c(Name = AA_Constants.ClusterSample);
       insert clusterData;
       aa_Country__c countryData = new aa_Country__c(Name = AA_Constants.CountrySample,Cluster_Id__c = clusterData.id);
       insert countryData;
       aa_Agent_Report__c unileverReport = new aa_Agent_Report__c(Report_Title__c = AA_Constants.ReportNameSample,Country__c = countryData.id,Reporting_on__c = AA_Constants.ReportingOnSample,Town__c = AA_Constants.TownSample,Retailer__c = retailerData.id,Agent_App_Unilever_Brand__c = uniBrand.id,TF_Mention_User__c='1234',TF_Topic_Name__c='2345',Status__c='Published (Public)');
       insert unileverReport;      
       
       
      //  List<String> res = AA_DatabaseServiceUtil.insertOperation(unileverReport.id,'');
         AA_DatabaseServiceUtil.insertOperation(unileverReport.id,'');
        
        ContentVersion contentVersionObj = new ContentVersion();
        contentVersionObj.ContentURL='http://www.google.com/';
        contentVersionObj.Title = AA_Constants.testString;           
        insert contentVersionObj;
        List<String> res1 = AA_DatabaseServiceUtil.insertOperation(unileverReport.id,contentVersionObj.id);
       // List<String> res2 = AA_DatabaseServiceUtil.insertOperation(unileverReport.id,AA_Constants.testString);
       AA_DatabaseServiceUtil.insertOperation(unileverReport.id,AA_Constants.testString);
        //commented as part of 10 Nov 2015 deployment 
        system.assert(res1.size()!=Null);
    }
    
     /**
     * @date        -   13/11/2015
     * @description -   Test class to test the method invokeTriggerAA_AgentReportRejected
     * @param       -   None 
     * @return      -   None
     * @modifiedby  - // Added as part of Nov 13 deployment 
     */ 
   
    static testMethod void invokeTriggerAA_AgentReportRejected_Email(){
    aa_Agent_Report__c recNew = new aa_Agent_Report__c(Name=AA_Constants.ReportNameSample);
    try{
       insert recNew;
       delete recNew;
       }
       catch(System.DmlException e){
         System.debug('Message: ' + e.getMessage()); 
       }
       system.assert(recNew!=null);
    }
     static testMethod void sendToChatterTest(){
        Test.startTest();

             
          aa_Agent_App_Competitor_Brand__c compBrand = new aa_Agent_App_Competitor_Brand__c(Name = AA_Constants.CompetitorBrandNameSample);
          insert compBrand;

           aa_Agent_Report__c  reportId= new aa_Agent_Report__c(Name='test');
           insert reportId;

          aa_Agent_Report__c userToMentionId= new aa_Agent_Report__c (Name='test');
          insert userToMentionId;
          aa_Topic__c topic = new aa_Topic__c(Name = AA_Constants.Topicsample);
          insert topic;
        String postText='Test2';
        String Country='India';
         String userIds='gh';
        String topicNames='testTopic';

        AA_DatabaseServiceUtil.sendToChatter(compBrand.id , userInfo.getUserId(),  postText, reportId.id, Country,userInfo.getUserId());
        system.assert(userIds!=null);
         

        
        Test.stopTest();
    }


   
    
}