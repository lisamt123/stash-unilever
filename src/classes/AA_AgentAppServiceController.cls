/**
 * Name:        -   AA_AgentAppServiceController
 * @description -   This is the controller class for the services requested from frontend & includes the business logic
 * @Author      -   Aslesha R K     
 */

public with sharing class AA_AgentAppServiceController {

    public AA_ApplicationWrapperObj aaToOperate {get;set;}
   
    /**
     * @date        -   03/08/2015
     * @description -   Constructor of the class create object of the Application wrapperObj
     * @param       -   None 
     * @return      -   None
     * @modifiedby  -
     */        
    
    public AA_AgentAppServiceController(){
        aaToOperate = new AA_ApplicationWrapperObj ();
    }
    
    /**
     * @date        -   03/08/2015
     * @description -   create unliver type report
     * @param       -   AA_ApplicationWrapperObj 
     * @return      -   AA_ApplicationWrapperObj
     * @modifiedby  -
     */  
    
    public AA_ApplicationWrapperObj insertAgentApp(AA_ApplicationWrapperObj appWrapperObj){
        try{
            AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
            objAgentApp = appWrapperObj.objAgentAppDataRequest;
            system.debug('insert object in db'+convertRequestAgentReport(objAgentApp));
            list<String> agentAPPIDInserted = AA_DatabaseServiceUtil.upsertOperation(convertRequestAgentReport(objAgentApp));
            //list<String> agentAPPDocumentIDInserted = 
            AA_DatabaseServiceUtil.insertOperation(agentAPPIDInserted[0], objAgentApp.ContentDocumentId);
            appWrapperObj.message = System.Label.AA_Agent_Report_Success;
            AA_WrapperUtility.AgentAppDataResponse objResponse = new AA_WrapperUtility.AgentAppDataResponse();
            objResponse.agentReportId = agentAPPIDInserted[0];
            appWrapperObj.objGetAgentDataResponse  =  objResponse;
         }catch(System.DmlException exceptiondml){
             System.debug('Exception in DML:' + exceptiondml.getMessage());
        }
        return appWrapperObj;
    }

    /**
     * @date        -   03/08/2015
     * @description -   Create competitor type of agent report
     * @param       -   AA_ApplicationWrapperObj 
     * @return      -   AA_ApplicationWrapperObj
     * @modifiedby  -
     */      
    public AA_ApplicationWrapperObj insertAgentApp_Competitor(AA_ApplicationWrapperObj appWrapperObj){
 
            AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
            objAgentApp = appWrapperObj.objAgentAppDataRequest;
            list<String> agentAPPIDInserted = AA_DatabaseServiceUtil.upsertOperation(convertRequestAgentReport_Competitor(objAgentApp));
            //list<String> agentAPPDocumentIDInserted = 
            AA_DatabaseServiceUtil.insertOperation(agentAPPIDInserted[0], objAgentApp.ContentDocumentId);
            appWrapperObj.message = System.Label.AA_Agent_Report_Success;
            AA_WrapperUtility.AgentAppDataResponse objResponse = new AA_WrapperUtility.AgentAppDataResponse();
            objResponse.agentReportId = agentAPPIDInserted[0];
            appWrapperObj.objGetAgentDataResponse  =  objResponse;
            
            
        return appWrapperObj;
    }
    /**
     * @date        -   03/08/2015
     * @description -   mapping of InnerObjectFields to actual Objects
     * @param       -   objAgentApp - Request to insert data to salesforce 
     * @return      -   aa_Agent_Report__c type object
     * @modifiedby  -
     */
    public aa_Agent_Report__c convertRequestAgentReport(AA_WrapperUtility.AgentAppDataRequest objAgentApp){
        string userids='';
        
            aa_Agent_Report__c newObjToBeInserted = new aa_Agent_Report__c();
            newObjToBeInserted.Agent_App_Unilever_Brand__c  = objAgentApp.UnileverBrandId;
            newObjToBeInserted.Report_Description__c = objAgentApp.ReportDesc ;
            newObjToBeInserted.Retailer__c  = objAgentApp.Retailer;
            newObjToBeInserted.Reporting_on__c = objAgentApp.ReportingOn;
            if(!String.isEmpty(objAgentApp.CountryId)){
            newObjToBeInserted.Country__c = objAgentApp.CountryId;
             
            } 
            //Adding cluster
            if(!String.isEmpty(objAgentApp.ClusterId)){
            newObjToBeInserted.ClusterId__c=Id.ValueOf(objAgentApp.ClusterId);
            }else{
            	system.debug('User does not inserted cluster value');
                List<aa_country__c> clustidlist=[Select Cluster_Id__c from aa_Country__c where ID =:objAgentApp.CountryId Limit 1];
                newObjToBeInserted.ClusterId__c= clustidlist[0].Cluster_Id__c;
            }
            
           
            newObjToBeInserted.Report_Title__c = objAgentApp.ReportName ;
            
            newObjToBeInserted.Town__c = objAgentApp.Town;
            newObjToBeInserted.longitude__c = objAgentApp.Longitude;
            newObjToBeInserted.latitude__c = objAgentApp.Latitude;
            newObjToBeInserted.Category__c = objAgentApp.CategoryId ;
            newObjToBeInserted.Competitor_Name__c = objAgentApp.CompetitorId ;
            newObjToBeInserted.Competitor_Brand__c = objAgentApp.CompetitorBrandId ;
            //Adding userids  to be mentioned in the feed and topics names  to be inserted
        
          if(objAgentApp.usertomentionIds !=NUll && objAgentApp.usertomentionIds.size()>0){
        for(string str:objAgentApp.usertomentionIds)
        {
          userids=userids+str+',';
          
        }
        userids=userids.removeEnd(',');
        newObjToBeInserted.TF_Mention_User__c=userids;
        } 
         
    
         system.debug('newObjToBeInserted cluster value'+newObjToBeInserted.ClusterId__c);
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Unilever Agent Published Report')).getRecordTypeId();
        newObjToBeInserted.RecordTypeId = recTypeId;
       
        return newObjToBeInserted;
    }
    
    /**
     * @date        -   11/08/2015
     * @description -   mapping of InnerObjectFields to actual Objects
     * @param       -   objAgentApp - Request to insert data to salesforce 
     * @return      -   aa_Agent_Report__c Competitor type object
     * @modifiedby  -
     */
    public aa_Agent_Report__c convertRequestAgentReport_Competitor(AA_WrapperUtility.AgentAppDataRequest objAgentApp){
        string userids='';
        aa_Agent_Report__c newObjToBeInserted = new aa_Agent_Report__c();
              newObjToBeInserted.Report_Title__c = objAgentApp.ReportName ;
              newObjToBeInserted.Report_Description__c = objAgentApp.ReportDesc ;
    
        if(!String.isEmpty(objAgentApp.Source)){
            newObjToBeInserted.Source__c  = objAgentApp.Source;
        }
            newObjToBeInserted.Retailer__c  = objAgentApp.Retailer;
            newObjToBeInserted.Competitor_Brand__c  = objAgentApp.CompetitorBrandId;
            newObjToBeInserted.Competitor_Name__c  = objAgentApp.CompetitorId;
        
        if(!String.isEmpty(objAgentApp.CategoryId)){
            newObjToBeInserted.Category__c  = objAgentApp.CategoryId;
        }
     
         if(!String.isEmpty(objAgentApp.CountryId)) {
                newObjToBeInserted.Country__c = objAgentApp.CountryId;
          }
            
            newObjToBeInserted.Town__c = objAgentApp.Town;
            newObjToBeInserted.longitude__c = objAgentApp.Longitude;
            newObjToBeInserted.latitude__c = objAgentApp.Latitude;
        
        if(!String.isEmpty(objAgentApp.CodeOfConduct)){
            if(objAgentApp.CodeOfConduct == 'true'){
                newObjToBeInserted.Is_Accepted_Code_of_Conduct__c = true;    
            }else if(objAgentApp.CodeOfConduct == 'false'){
                newObjToBeInserted.Is_Accepted_Code_of_Conduct__c = false;    
            }          
        }      
       
        //Adding New Brand Fields 
        newObjToBeInserted.OtherBrandName__c=objAgentApp.OtherBrandName;
        newObjToBeInserted.OtherCompanyName__c=objAgentApp.OtherCompetitor;
        
        //Adding userids  to be mentioned in the feed and topics names  to be inserted
        if(objAgentApp.usertomentionIds.size()>0){
       
        for(string str:objAgentApp.usertomentionIds)
        {
          userids=userids+str+',';
          
        }       
        userids=userids.removeEnd(',');
        newObjToBeInserted.TF_Mention_User__c=userids;
        }
        
     
        //Adding cluster
      
         if(!String.isEmpty(objAgentApp.ClusterId)) {
         
          newObjToBeInserted.ClusterId__c=objAgentApp.ClusterId;
         }else{
                List<aa_country__c> clustidlist=[Select Cluster_Id__c from aa_Country__c where ID =:objAgentApp.CountryId Limit 1];
                newObjToBeInserted.ClusterId__c= clustidlist[0].Cluster_Id__c;
            }
        
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
        newObjToBeInserted.RecordTypeId = recTypeId;    
        return newObjToBeInserted;
    }
    
    /**
     * @date        -   03/08/2015
     * @description -   Upload the image into the content document 
     * @param       -   AA_WrapperUtility.AgentAppDataRequest, List of string
     * @return      -   ContentDocumentLink object
     * @modifiedby  -
     */      
    public ContentDocumentLink convertRequestAgentReportDocument(AA_WrapperUtility.AgentAppDataRequest objAgentApp,list<String> agentAPPIDInserted){
        //Image Upload
        String agentReportId = agentAPPIDInserted[0];   
        ContentDocumentLink newFileShare = new ContentDocumentLink();
        newFileShare.ContentDocumentId = [SELECT Id, VersionNumber, ContentDocumentId FROM ContentVersion where Id=: objAgentApp.ContentDocumentId LIMIT 1].ContentDocumentId ;
        newFileShare.ShareType= 'V';
        newFileShare.LinkedEntityId = ID.valueOf(agentReportId);
        return newFileShare;
    }  
  
    /**
     * @date        -   03/08/2015
     * @description -   retrieving values need to be autopopulated on form Load
     * @param       -   appWrapperObj - Assigning values which need to be auto populated 
     * @return      -   aa_Agent_Report__c type object
     * @modifiedby  -
     */
    public AA_ApplicationWrapperObj getAutoPopulatedValues_UnileverReport(AA_ApplicationWrapperObj appWrapperObj){
        //Unilever Brand Values
        List<aa_Agent_App_Competitor_Brand__c> agentUnileverBrandList = getUnileverListValues();
        AA_WrapperUtility.AgentAppDataResponse wrapperUtilityObj = new AA_WrapperUtility.AgentAppDataResponse();    
        wrapperUtilityObj.unileverBrandList = new List<aa_Agent_App_Competitor_Brand__c >();
        wrapperUtilityObj.unileverBrandList = agentUnileverBrandList;     
        appWrapperObj.objGetAgentDataResponse =  wrapperUtilityObj;
        
        //Retailer Values
        List<aa_Agent_Retailer__c>  agentRetailerList = getRetailerListValues();
        wrapperUtilityObj.unileverRetailerList = new List<aa_Agent_Retailer__c>();
        wrapperUtilityObj.unileverRetailerList = agentRetailerList;
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Reporting On Values
        List<String> reportingOnPickList = new List<String>();
        reportingOnPickList = getReportingOnListValues();
        wrapperUtilityObj.reportingOnPicklistValues = new List<String>();
        wrapperUtilityObj.reportingOnPicklistValues = reportingOnPickList;
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Country List Values 
        List<aa_Country__c>  countryValuesList = getCountryValues();
        wrapperUtilityObj.countryList = new List<aa_Country__c>();
        wrapperUtilityObj.countryList = countryValuesList;
       
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Cluster List Values
        List <aa_Cluster__c> clusterValuesList= getClusterValues();
        wrapperUtilityObj.clusterList = new List<aa_Cluster__c>();
        wrapperUtilityObj.clusterList = clusterValuesList;
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
      //  Map<string,aa_agent_app_custom_setting__c> objURL = aa_agent_app_custom_setting__c.getAll(); 
       // wrapperUtilityObj.googleApiVaue = objURL.get('Google Api Key').Value__c;
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
                                              
        return appWrapperObj;
    }
    
     /**
     * @date        -   03/08/2015
     * @description -   retrieve all Unilever Brand Name 
     * @param       -   void 
     * @return      -   All unileverBrand name and Id in List format
     * @modifiedby  -   
     */
    public static List<aa_Agent_App_Competitor_Brand__c> getUnileverListValues(){
        List<aa_Agent_App_Competitor_Brand__c > agentUnileverBrandList = fetchValuesByRecordType('aa_Agent_App_Competitor_Brand__c',AA_Constants.ID_NAME,'Unilever Brand');     
        return agentUnileverBrandList;
        
    }
    
         
    /**
     * @date        -   03/08/2015
     * @description -   retrieve all retailer Name 
     * @param       -   void 
     * @return      -   All retailer name and Id in List format
     * @modifiedby  -   
     */
    public List<aa_Agent_Retailer__c>  getRetailerListValues(){
        List<aa_Agent_Retailer__c> agentRetailerList = fetchValues('aa_Agent_Retailer__c',AA_Constants.ID_NAME);  
        return agentRetailerList;
    }
    
    /**
     * @date        -   03/08/2015
     * @description -   retrieve all country Name 
     * @param       -   void 
     * @return      -   All country name and Id in List format
     * @modifiedby  -   
     */
    public List<aa_Country__c> getCountryValues(){
        List<aa_Country__c> countryNameList = fetchValues('aa_Country__c','id,name,Cluster_Id__r.name,Cluster_Id__c');
        return countryNameList;
    }
    
    /**
     * @date        -   03/08/2015
     * @description -   retrieve all country Name 
     * @param       -   void 
     * @return      -   All country name and Id in List format
     * @modifiedby  -   
     */
    public List<aa_Cluster__c> getClusterValues(){
        List<aa_Cluster__c> ClusterNameList = fetchValues('aa_Cluster__c',AA_Constants.ID_NAME);
        return ClusterNameList;
    }    
    
    /**
     * @date        -   03/08/2015
     * @description -   Creating Query on basis of objectApiName and Field names need to be fetch
     * @param       -   Object Name , Field Name 
     * @return      -   List of Sobject type data retrieved from query
     * @modifiedby  -   
     */
    public static List<Sobject> fetchValues(String SobjectApiName,String commaSepratedFields){
         List<Sobject> result=new list<Sobject>();
         String query;
         if(!Utility.isEmpty(SobjectApiName) && !Utility.isEmpty(commaSepratedFields)){
         if(SobjectApiName == 'aa_Topic__c'){
                   query = 'select ' + commaSepratedFields + ' from ' + SobjectApiName + ' order by Topic_Order__c ' ;
		                   result = Database.query(query);
           }
           else { 
            query = 'select ' + commaSepratedFields + ' from ' + SobjectApiName ;
            result = Database.query(query);
        }
         }
       return result;
    }
    
    /**
     * @date        -   03/08/2015
     * @description -   to fetch the values from the database based the object sent as parameter
     * @param       -   Object Name , Fields comma seperated , record type 
     * @return      -   List of Sobject type data retrieved from query
     * @modifiedby  -   
     */   
    public static List<Sobject> fetchValuesByRecordType(String SobjectApiName,String commaSepratedFields, String recType){
        
        List<Sobject> result=new List<Sobject>();
        String query;
         if(!Utility.isEmpty(SobjectApiName) && !Utility.isEmpty(commaSepratedFields)){
            
            query = 'select ' + commaSepratedFields + ' from ' + SobjectApiName + ' where RecordType.Name=\''+recType+'\'';
            result = Database.query(query);
         }
       return result;
    }
    
    /**
     * @date        -   03/08/2015
     * @description -   retrieving Reporting On field picklist values
     * @param       -   void
     * @return      -   List of String having picklist values
     * @modifiedby  -   
     */
     
   public List<String> getReportingOnListValues(){
        Schema.DescribeFieldResult fieldResult;
        fieldResult = aa_Agent_Report__c.Reporting_on__c.getDescribe();
        List<String> reportingOnPickListValues = getPicklistValues(fieldResult);
        return reportingOnPickListValues;
   } 
    
    /**
     * @date        -   11/08/2015
     * @description -   retrieving competitor name and category.
     * @param       -   appWrapperObj - Assigning values which need to be auto populated 
     * @return      -   aa_Agent_Report__c type object
     * @modifiedby  -
     */
    public AA_ApplicationWrapperObj getCompetitorNameAndCategory_CompetitorReport(AA_ApplicationWrapperObj appWrapperObj){
        
        AA_WrapperUtility.AgentAppDataResponse wrapperUtilityObj = new AA_WrapperUtility.AgentAppDataResponse();    
        List<aa_Agent_App_Brand_Category__c> objSelectedCompetitorCategoryOnBrand= getCompetitorCategory(appWrapperObj.objAgentAppDataRequest.CompetitorBrandId);
        wrapperUtilityObj.selectedCompetitorCategoryOnBrand = objSelectedCompetitorCategoryOnBrand;
        appWrapperObj.objGetAgentDataResponse =  wrapperUtilityObj;
        return appWrapperObj;
    }    
    public List<aa_Agent_App_Competitor_Brand__c>  getCompetitorBrandListValues(){
        List<aa_Agent_App_Competitor_Brand__c> agentCompetitorBrandList = fetchValuesByRecordType('aa_Agent_App_Competitor_Brand__c',AA_Constants.ID_NAME,'Competitor Brand');  
        return agentCompetitorBrandList;
    }
    public List<aa_Agent_Competitor__c>  getCompetitorNameListValues(){
        List<aa_Agent_Competitor__c> agentCompetitorNameList = fetchValues('aa_Agent_Competitor__c',AA_Constants.ID_NAME);  
        return agentCompetitorNameList;
    }
    public List<aa_Agent_App_Category__c>  getCompetitorCategoryListValues(){
        List<aa_Agent_App_Category__c> agentCompetitorCategoryList = fetchValues('aa_Agent_App_Category__c',AA_Constants.ID_NAME);  
        return agentCompetitorCategoryList;
    }
    
    /**
     * @date        -   03/08/2015
     * @description -   retrieving values need to be autopopulated on form Load
     * @param       -   appWrapperObj - Assigning values which need to be auto populated 
     * @return      -   aa_Agent_Report__c type object
     * @modifiedby  -
     */
    public AA_ApplicationWrapperObj getSourceRetailerTopicCountry_CompetitorReport(AA_ApplicationWrapperObj appWrapperObj){
    
        AA_WrapperUtility.AgentAppDataResponse wrapperUtilityObj = new AA_WrapperUtility.AgentAppDataResponse();    
        //Retailer Values
        List<aa_Agent_Retailer__c>  agentRetailerList = getRetailerListValues();
        wrapperUtilityObj.unileverRetailerList = new List<aa_Agent_Retailer__c>();
        wrapperUtilityObj.unileverRetailerList = agentRetailerList;
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Source Values
        List<String> sourcePickList = new List<String>();
        sourcePickList = getSourceListValues();
        wrapperUtilityObj.sourcePicklistValues = new List<String>();
        wrapperUtilityObj.sourcePicklistValues = sourcePickList;
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Topic Values 
        List<aa_Topic__c>  topicValuesList = getTopicListValues();
        wrapperUtilityObj.topicList = new List<aa_Topic__c>();
        wrapperUtilityObj.topicList = topicValuesList;
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
                
        //Country List Values 
        List<aa_Country__c>  countryValuesList = getCountryValues();
        wrapperUtilityObj.countryList = new List<aa_Country__c>();
        wrapperUtilityObj.countryList = countryValuesList;
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Competitor Brand List Values 
        List<aa_Agent_App_Competitor_Brand__c>  objCompetitorBrandList = getCompetitorBrandListValues();
        wrapperUtilityObj.competitorBrandList = new List<aa_Agent_App_Competitor_Brand__c>();
        wrapperUtilityObj.competitorBrandList = objCompetitorBrandList;
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Competitor Name List Values 
        List<aa_Agent_Competitor__c>  objCompetitorNameList = getCompetitorNameListValues();
        wrapperUtilityObj.competitorNameList = new List<aa_Agent_Competitor__c>();
        wrapperUtilityObj.competitorNameList = objCompetitorNameList;
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Category Name List Values 
        List<aa_Agent_App_Category__c>  objCategoryNameList = getCompetitorCategoryListValues();
        wrapperUtilityObj.categoryList = new List<aa_Agent_App_Category__c>();
        wrapperUtilityObj.categoryList = objCategoryNameList;
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
         //Cluster List Values
        List <aa_Cluster__c> clusterValuesList= getClusterValues();
        wrapperUtilityObj.clusterList = new List<aa_Cluster__c>();
        wrapperUtilityObj.clusterList = clusterValuesList;
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
       // Map<string,aa_agent_app_custom_setting__c> objURL = aa_agent_app_custom_setting__c.getAll(); 
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
       
        return appWrapperObj;
    }   
     
    /**
     * @date        -   11/08/2015
     * @description -   retrieving competitor name & category name on the basis of competitor brand
     * @param       -   fieldResult - Schema.DescribeFieldResult 
     * @return      -   List of String having picklist values
     * @modifiedby  -   
     */
    public List<aa_Agent_App_Brand_Category__c> getCompetitorCategory (String competitorBrand)
    {
        List<aa_Agent_App_Brand_Category__c> agentBrandCategory = new List<aa_Agent_App_Brand_Category__c>();
        try{
            if(!Utility.isEmpty(competitorBrand)){
                agentBrandCategory = [select Id, Brand_Id__c, 
                                      Agent_Competitor_Id__c, 
                                      Agent_Competitor_Id__r.Name, 
                                      Category_Id__c,Category_Id__r.name 
                                      from  aa_Agent_App_Brand_Category__c where Brand_Id__c = :CompetitorBrand];   
            }
                
        }Catch(System.DmlException exceptiondml2){
             System.debug('Exception:' + exceptiondml2.getMessage());
        }
        return agentBrandCategory;
    }
    
     /**
     * @date        -   11/08/2015
     * @description -   retrieving Source field picklist values
     * @param       -   void
     * @return      -   List of String having picklist values
     * @modifiedby  -   
     */
   public List<String> getSourceListValues(){
        Schema.DescribeFieldResult fieldResult;
        fieldResult = aa_Agent_Report__c.Source__c.getDescribe();
        List<String> sourcePickListValues = getPicklistValues(fieldResult);
        return sourcePickListValues;
   }
   /**
     * @date        -   11/08/2015
     * @description -   retrieving topics in the Agent app database
     * @param       -   void
     * @return      -   List of topics
     * @modifiedby  -   
     */
   public static List<aa_Topic__c> getTopicListValues(){
        List<aa_Topic__c> agentTopicList = fetchValues('aa_Topic__c','id,name,Sub_Topic__c,Topic_Order__c ');     
        return agentTopicList;
        
    }
   /**
     * @date        -   03/08/2015
     * @description -   retrieving picklist values
     * @param       -   fieldResult - Schema.DescribeFieldResult 
     * @return      -   List of String having picklist values
     * @modifiedby  -   
     */
    public static List<String> getPicklistValues(Schema.DescribeFieldResult fieldResult){
        List<String> retList = new List<String>();
        if(fieldResult!=null) {
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();       
            for( Schema.PicklistEntry f : ple) {
                retList.add(f.getValue());
            }  
        }
        return retList;
    }   
     
   /**
     * @date        -   11/09/2015
     * @description -   retriev Agent report data for front end with sorting , filter etc
     * @param       -   AA_ApplicationWrapperObj
     * @return      -   List of Agent reports
     * @modifiedby  -   Aslesha R K
     */    
   public AA_ApplicationWrapperObj retriveAllAgentReports(AA_ApplicationWrapperObj appWrapperObj){
  // try{
      
        Map<string,aa_agent_app_custom_setting__c> objURL = aa_agent_app_custom_setting__c.getAll(); 
        String urlHost =  objURL.get('Salesforce Instance URL Content').Value__c;  // Salesforce Instance URL
        String sfcURLContent =  objURL.get('SFC Content').Value__c; // URL for Image population on UI
        String docURLContent =  objURL.get('Document URL Content').Value__c; // URL for Document (Logo) population on UI
        String soqlquery='Select Id,ClusterId__c,ClusterId__r.name,Chatter_Post_ID__c,LastModifiedDate,Agent_App_Unilever_Brand__r.Name, Agent_App_Unilever_Brand__c,Town__c,Retailer__c, Retailer__r.Name, RecordType.Name, Name, Report_Title__c,Report_Description__c,CreatedDate,CreatedBy.SmallPhotoUrl, CreatedBy.Name, Country__c, Country__r.Name, Country__r.Cluster_Id__r.name,Country__r.Cluster_Id__c, Competitor_Name__c,Competitor_Name__r.Name,  Competitor_Brand__c,Competitor_Brand__r.Name,  Category__c, Category__r.Name,  Status__c,(Select Id, CommentCount, LikeCount, CreatedById,RelatedRecordId, ContentFileName From Feeds) From aa_Agent_Report__c where Status__c = \'Published (Public)\' ';
        
         AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
         objAgentApp = appWrapperObj.objAgentAppDataRequest;        
        if(appWrapperObj.objAgentAppDataRequest!=null){
        if(appWrapperObj.objAgentAppDataRequest.FilterType=='myReport')
        {
                soqlquery +=' AND CreatedById =\''+UserInfo.getUserId()+'\'';  
        }        
        if(appWrapperObj.objAgentAppDataRequest.FilterType=='filterReports' )
        {
            aa_Agent_Report__c requestAgentDataObj = new aa_Agent_Report__c();                
            if(objAgentApp.ApplyFilter==null || objAgentApp.ApplyFilter=='false'){
               
            aa_Agent_App_User_Preference__c UserPref = [SELECT Id,
                                                                UserId__c, 
                                                                Category__c,
                                                                Country__c,
                                                                Competitor_Brand__c,
                                                                Competitor_Name__c,
                                                                Retailer__c,
                                                                Agent_App_Unilever_Brand__c,
                                                                Cluster__c,
                                                                RecordTypeId__c,
                                                                ReportingOn__c,
                                                                Topic__c
                                                                FROM aa_Agent_App_User_Preference__c 
                                                                where UserId__c =: UserInfo.getUserId()];   
                /*
                   Each value fetching from database needs to be go thrugh null check before applying it to the current filter i.e. in below query
                   If null check is removed query will fail with exception even if one value is null
                */   
                
                system.debug('userPref Values==>'+UserPref);
                 //if country only selected
                if(UserPref.Country__c != NULL && UserPref.Cluster__c == NULL )
                {
                   
                   soqlquery +=' AND ( Country__c ='+AA_Constants.Escapechar+UserPref.Country__c+AA_Constants.Escapechar;   
                   // get cluster id for this country
                   aa_Country__c countyclustidlst=[Select  Cluster_Id__c from  aa_Country__c where Id=:UserPref.Country__c];
                   aa_Cluster__c globalclustId=[Select Id from aa_Cluster__c where name='Global' ];
                   
                   soqlquery+= ' OR     (ClusterId__c='+AA_Constants.Escapechar+countyclustidlst.Cluster_Id__c+AA_Constants.Escapechar;
                   soqlquery+=' AND country__c=Null)';
                   soqlquery+=' OR  ClusterId__c='+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar+ ' ))';
                   
                  }  
                
                  aa_Cluster__c globalclustId=[Select Id from aa_Cluster__c where name='Global' ];
                  
                  //IF cluster is selected and country also selected  
                  
                   if(UserPref.Cluster__c  != NULL &&  UserPref.Country__c !=NULL){
                    
                       
                    soqlquery+=' AND (country__c='+AA_Constants.Escapechar+UserPref.Country__c+AA_Constants.Escapechar;
                    soqlquery+=' OR (ClusterId__c ='+AA_Constants.Escapechar+UserPref.Cluster__c +AA_Constants.Escapechar;
                    soqlquery+=' AND country__c=NULL)';
                    soqlquery+=' OR ClusterId__c='+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar+')';
                    
                   } 
                   
                   // IF cluster is selected and country not  selected  
                      if(UserPref.Cluster__c  != NULL &&  UserPref.Country__c ==NULL){
                      
                         //if global only selected
                        if(UserPref.Cluster__c ==globalclustId.id)
                        {
                   
                       soqlquery+=' AND ClusterId__c='+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar;
                      
                       }else{   
                        
                        
                       soqlquery+=' AND (ClusterId__c ='+AA_Constants.Escapechar+UserPref.Cluster__c +AA_Constants.Escapechar;
                       soqlquery +=' OR Country__r.Cluster_Id__c ='+AA_Constants.Escapechar+UserPref.Cluster__c+AA_Constants.Escapechar;
                       soqlquery+=' OR ClusterId__c='+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar+')';
                      
                      
                        }
                   }          
                
                                                                                                                          
              /* if(UserPref.Country__c != NULL )
                {
                   soqlquery +='AND Country__c ='+AA_Constants.Escapechar+UserPref.Country__c+AA_Constants.Escapechar;    
                }*/                
                if(UserPref.Agent_App_Unilever_Brand__c!=NULL)
                {
                  soqlquery +=' AND Agent_App_Unilever_Brand__c ='+AA_Constants.Escapechar+UserPref.Agent_App_Unilever_Brand__c+AA_Constants.Escapechar;
                }                
                if(UserPref.Competitor_Name__c !=NULL)
                {
                  soqlquery +=' AND Competitor_Name__c='+AA_Constants.Escapechar+UserPref.Competitor_Name__c+AA_Constants.Escapechar;
                }                
                if(UserPref.Competitor_Brand__c !=NULL)
                {
                   soqlquery +=' AND Competitor_Brand__c ='+AA_Constants.Escapechar+UserPref.Competitor_Brand__c+AA_Constants.Escapechar;
                }                
                if(UserPref.Retailer__c !=NULL)
                {
                   soqlquery +=' AND Retailer__c ='+AA_Constants.Escapechar+UserPref.Retailer__c+AA_Constants.Escapechar;
                }                
                if(UserPref.Category__c !=NULL)
                {
                   soqlquery +=' AND Category__c ='+AA_Constants.Escapechar+UserPref.Category__c+AA_Constants.Escapechar;
                }  
              /*  if(UserPref.Cluster__c !=NULL)
                {
                   soqlquery +='AND Country__r.Cluster_Id__c ='+AA_Constants.Escapechar+UserPref.Cluster__c+AA_Constants.Escapechar;
                }*/   
                if(UserPref.RecordTypeId__c!=NULL)
                {
                soqlquery +=' AND RecordTypeId  = '+AA_Constants.Escapechar+UserPref.RecordTypeId__c+AA_Constants.Escapechar;    
                }       
                if(UserPref.Topic__c!=NULL)
                {
                    soqlquery +=' AND Topic__c ='+AA_Constants.Escapechar+UserPref.Topic__c+AA_Constants.Escapechar;
                }
                if(UserPref.ReportingOn__c!=NULL)
                {
                    soqlquery +=' AND Reporting_on__c = '+AA_Constants.Escapechar+UserPref.ReportingOn__c+AA_Constants.Escapechar;
                }
           }else if(appWrapperObj.objAgentAppDataRequest.ApplyFilter=='true') {     
                 
                requestAgentDataObj=(aa_Agent_Report__c)convertRequestAgentReport(objAgentApp);
               
               //if country only selected
                
                if(requestAgentDataObj.country__c != NULL && requestAgentDataObj.ClusterId__c == NULL )
                {
                                 
                   soqlquery +=' AND ( Country__c ='+AA_Constants.Escapechar+requestAgentDataObj.country__c+AA_Constants.Escapechar;   
                   // get cluster id for this country
                   aa_Country__c countyclustidlst=[Select  Cluster_Id__c from  aa_Country__c where Id=:requestAgentDataObj.country__c];
                   aa_Cluster__c globalclustId=[Select Id from aa_Cluster__c where name='Global' ];
                   soqlquery+= ' OR  (ClusterId__c='+AA_Constants.Escapechar+countyclustidlst.Cluster_Id__c+AA_Constants.Escapechar;
                   soqlquery+=' AND country__c=Null)';
                   soqlquery+=' OR  ClusterId__c='+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar+ ')';
                                     
                  }  
                
                  aa_Cluster__c globalclustId=[Select Id from aa_Cluster__c where name='Global' ];
                  
                  //IF cluster is selected and country also selected  
                  
                   if(requestAgentDataObj.ClusterId__c != NULL &&  requestAgentDataObj.country__c !=Null){
                    
                    soqlquery+=' AND (country__c='+AA_Constants.Escapechar+requestAgentDataObj.country__c+AA_Constants.Escapechar;
                    soqlquery+=' OR (ClusterId__c ='+AA_Constants.Escapechar+requestAgentDataObj.ClusterId__c+AA_Constants.Escapechar;
                    soqlquery+=' AND country__c=Null)';
                    soqlquery+=' OR ClusterId__c='+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar+')';
                    
                   } 
                   
                   // IF cluster is selected and country not  selected  
                      if(requestAgentDataObj.ClusterId__c != NULL &&  requestAgentDataObj.country__c ==Null){
                        //if global only selected
                        if(requestAgentDataObj.ClusterId__c==globalclustId.id){
                                     
                        soqlquery+=' AND ClusterId__c='+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar;
                      
                       }else{                        
                        
                       soqlquery+=' AND (ClusterId__c ='+AA_Constants.Escapechar+requestAgentDataObj.ClusterId__c+AA_Constants.Escapechar;
                       soqlquery+=' OR (ClusterId__c ='+AA_Constants.Escapechar+requestAgentDataObj.ClusterId__c+AA_Constants.Escapechar;
                       soqlquery+=' AND country__c=Null)';
                       soqlquery+=' OR ClusterId__c='+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar+')';
                       
                        }
                   }          
                if(requestAgentDataObj.Agent_App_Unilever_Brand__c !=NULL)
                {
                  soqlquery +=' AND Agent_App_Unilever_Brand__c ='+AA_Constants.Escapechar+requestAgentDataObj.Agent_App_Unilever_Brand__c +AA_Constants.Escapechar;
                }                
                if(requestAgentDataObj.Competitor_Name__c !=NULL)
                {
                  soqlquery +=' AND Competitor_Name__c= '+AA_Constants.Escapechar+requestAgentDataObj.Competitor_Name__c +AA_Constants.Escapechar;
                }                
                if(requestAgentDataObj.Competitor_Brand__c !=NULL)
                {
                   soqlquery +=' AND Competitor_Brand__c = '+AA_Constants.Escapechar+ requestAgentDataObj.Competitor_Brand__c+AA_Constants.Escapechar;
                }                
                if(requestAgentDataObj.Retailer__c !=NULL)
                {
                   soqlquery +=' AND Retailer__c = '+AA_Constants.Escapechar+requestAgentDataObj.Retailer__c+AA_Constants.Escapechar;
                }                
                if(requestAgentDataObj.Category__c !=NULL)
                {
                   soqlquery +=' AND Category__c = '+AA_Constants.Escapechar+requestAgentDataObj.Category__c+AA_Constants.Escapechar;
                }                
               /* if(appWrapperObj.objAgentAppDataRequest.ClusterId!=NULL)
                {
                   soqlquery +='AND Country__r.Cluster_Id__c ='+AA_Constants.Escapechar+appWrapperObj.objAgentAppDataRequest.ClusterId+AA_Constants.Escapechar;
                }*/
                if(appWrapperObj.objAgentAppDataRequest.TopicId!=NULL)
                {
                    soqlquery +=' AND Topic__c ='+AA_Constants.Escapechar+appWrapperObj.objAgentAppDataRequest.TopicId+AA_Constants.Escapechar;
                }
                if(appWrapperObj.objAgentAppDataRequest.ReportingOn!=NULL)
                {
                    soqlquery +=' AND Reporting_on__c ='+AA_Constants.Escapechar+appWrapperObj.objAgentAppDataRequest.ReportingOn+AA_Constants.Escapechar;
                }
                String recTypeId='';
                if(appWrapperObj.objAgentAppDataRequest.RecordType=='Unilever')
                {
                    Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
                    Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
                    recTypeId = (RT.get('Unilever Agent Published Report')).getRecordTypeId();
                    soqlquery +=' AND RecordTypeId  = '+AA_Constants.Escapechar+recTypeId+AA_Constants.Escapechar;
                }            
                if(appWrapperObj.objAgentAppDataRequest.RecordType=='Competitor')
                {
                    Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
                    Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
                    recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
                    soqlquery +=' AND RecordTypeId  = '+AA_Constants.Escapechar+recTypeId+AA_Constants.Escapechar;
                }            
            aa_Agent_App_User_Preference__c userPref = [SELECT Id,UserId__c 
                                                               FROM aa_Agent_App_User_Preference__c              
                                                              Where UserId__c =: UserInfo.getUserId()];      
              
            userPref.Category__c=requestAgentDataObj.Category__c;
            if(requestAgentDataObj.Country__c!= null || requestAgentDataObj.Country__c!='null')
            userPref.Country__c=requestAgentDataObj.Country__c;            
            userPref.Competitor_Brand__c=requestAgentDataObj.Competitor_Brand__c;
            userPref.Competitor_Name__c=requestAgentDataObj.Competitor_Name__c;
            userPref.Retailer__c=requestAgentDataObj.Retailer__c;
            userPref.Agent_App_Unilever_Brand__c=requestAgentDataObj.Agent_App_Unilever_Brand__c;
           // if(appWrapperObj.objAgentAppDataRequest.ClusterId!=null || appWrapperObj.objAgentAppDataRequest.ClusterId!='null')
           if(!String.isEmpty(appWrapperObj.objAgentAppDataRequest.ClusterId)){
            userPref.Cluster__c=appWrapperObj.objAgentAppDataRequest.ClusterId;
            }
            userPref.RecordTypeId__c=recTypeId;
            userPref.Topic__c=appWrapperObj.objAgentAppDataRequest.TopicId;
            userPref.ReportingOn__c=appWrapperObj.objAgentAppDataRequest.ReportingOn;
         
            update userPref;            
        }
        }        
         if(objAgentApp.SortOnMostLike!='true' || objAgentApp.SortOnMostLike==NULL){
         soqlquery +=' Order by LastModifiedDate desc';
         }else if(objAgentApp.SortOnMostLike=='true'){
            String  soqlFeedQuery='SELECT Id,likecount FROM aa_Agent_Report__Feed order by likecount desc limit 1000'  ; //+ ' OFFSET '+appWrapperObj.objAgentAppDataRequest.OffSet;
            List<aa_Agent_Report__Feed> feedlist=  database.query(soqlFeedQuery); 
            system.debug('FeedList==>'+feedList);
            set<ID>idlist=new set<ID>();            
            String reportidInString='( ';           
            for(aa_Agent_Report__Feed item:feedlist)
            {      idlist.add(String.valueOf(item.id));
                   reportidInString+='\''+item.id+'\',';
            }
                   reportidInString+='\'\' )';
                   soqlquery +=' AND chatter_post_id__c IN   '+ reportidInString; 
            }         
        if(appWrapperObj.objAgentAppDataRequest.LimitRecords!=null && appWrapperObj.objAgentAppDataRequest.OffSet!=null &&(objAgentApp.SortOnMostLike!='true' || objAgentApp.SortOnMostLike==NULL)  )
        {
           soqlquery +=' LIMIT '+ appWrapperObj.objAgentAppDataRequest.LimitRecords + ' OFFSET '+appWrapperObj.objAgentAppDataRequest.OffSet;
        }else
           soqlquery +=' LIMIT 1000';        
       }else
           soqlquery +=' LIMIT 1000';
	     
       system.debug('Soql query =====>'+soqlquery);
        List <aa_Agent_Report__c> tmpList=  database.query(soqlquery); 
        system.debug('tmpList===>'+tmpList);
        List<AA_WrapperUtility.agentReportDetail> objFinalReport = new List<AA_WrapperUtility.agentReportDetail>();        
        // To check whether current user has liked report or not 
                   Set<ID> feedIds=new Set<ID>();
                   for(aa_Agent_Report__c itemfeedlike :tmpList){
                       system.debug('tmpList for loop===>'+itemfeedlike.Name);
                       for(aa_Agent_Report__Feed objfeedlike :itemfeedlike.Feeds){
                          if(itemfeedlike.Chatter_Post_ID__c==objfeedlike.Id){
                               feedIds.add(objfeedlike.Id);  
                          } 
                       }
                   }
                   Map<ID,String> ReportUserLike =new Map<ID,String>();
                   List<aa_Agent_Report__Feed> userfeedliketest= [Select ParentId ,RelatedRecordId,(Select Id, InsertedById  From FeedLikes) From aa_Agent_Report__Feed a where a.Id IN: feedIds];
                   for (aa_Agent_Report__Feed agentfeed :userfeedliketest){
                       for(FeedLike objfeedlike : agentfeed.FeedLikes)
                       {
                            if(objfeedlike.InsertedById==UserInfo.getUserId() ){
                            ReportUserLike.put(agentfeed.ParentId,'true');
                            }
                       }
                   }
               for(aa_Agent_Report__c item : tmpList)
                {
                   AA_WrapperUtility.agentReportDetail objGetAllReports = new AA_WrapperUtility.agentReportDetail();
                    objGetAllReports.agentReportID = item.Id;
                    objGetAllReports.unilever_brandId = item.Agent_App_Unilever_Brand__c;
                    objGetAllReports.competitor_nameId = item.Competitor_Name__c;
                    objGetAllReports.competitor_brandId = item.Competitor_Brand__c ;
                    objGetAllReports.retailerId = item.Retailer__c; 
                    objGetAllReports.userImgUrl=item.CreatedBy.SmallPhotoUrl;
                    objGetAllReports.reportTitl=item.Report_Title__c;
                    objGetAllReports.reportDesc=item.Report_Description__c;
                    objGetAllReports.unilever_brand=item.Agent_App_Unilever_Brand__r.Name;
                    objGetAllReports.competitor_name=item.Competitor_Brand__r.Name;
                    objGetAllReports.retailer=item.Retailer__r.Name;
                    objGetAllReports.town=item.Town__c;
                    objGetAllReports.country=item.Country__r.Name;
                    objGetAllReports.feedList =item.Feeds;
                    objGetAllReports.status =item.Status__c;
                    objGetAllReports.currentTime=String.valueOf(system.now());
                    if(item.RecordType.Name!= null){
                        if(item.RecordType.Name == 'Unilever Agent Published Report'){
                             objGetAllReports.recordType = 'UL';
                        } else if(item.RecordType.Name == 'Competitor Report'){
                            objGetAllReports.recordType = 'CI';
                        }
                    }
                    objGetAllReports.CreatedBy=item.CreatedBy.Name;
                    objGetAllReports.CountryId=item.Country__c;
                    objGetAllReports.CreatedTime=String.valueOf(item.LastModifiedDate);
                    
                    if(item.Country__c !=null){
                    objGetAllReports.clusterName = item.Country__r.Cluster_Id__r.name;
                    }
                    else{
                    objGetAllReports.clusterName = item.ClusterId__r.name;
                    }
                   
                    
                    objGetAllReports.clusterId=item.Country__r.Cluster_Id__c;
                    objGetAllReports.UserLike=ReportUserLike.get(objGetAllReports.agentReportID);
                
                   Set<String> imageFilekeyWords = new Set<String>{'.png','.jpg','.jpeg','.bmp','.JPG','.JPEG','.BMP','.PNG'}; // know the image file 
                   Set<String> docFilekeyWords = new Set<String>{'.ppt','.pdf','.xls','.xlsx','.doc','.docx','.csv','.txt'}; // know the image file     
                    for(aa_Agent_Report__Feed objfeed :item.Feeds)
                    {
                     objGetAllReports.TotalCommentCount+=objfeed.CommentCount;
                    if(item.Chatter_Post_ID__c == objfeed.Id){
                        objGetAllReports.LikeCount=objfeed.LikeCount;
                    }
                        if(item.Chatter_Post_ID__c == objfeed.Id && objfeed.ContentFileName!=null){                          
                            String feedFileName = objfeed.ContentFileName;
                            List<String> tmpFileNameList = feedFileName.split('\\.');
                            String fileExtension;
                            if(tmpFileNameList.size() > 0){
                                fileExtension = '.'+tmpFileNameList[tmpFileNameList.size() -1];
                                fileExtension=fileExtension.toLowerCase();
                            }
                           fileExtension=fileExtension.toLowerCase();
                           if(imageFilekeyWords.contains(fileExtension)){/*If Image file format associated with Chatter Post*/
                              objGetAllReports.DocumentUrl = urlHost + sfcURLContent + objfeed.RelatedRecordId;
                              }else if(docFilekeyWords.contains(fileExtension)){ /*If perticular file format associated with Chatter Post*/
                           
                                if(item.RecordType.Name == 'Unilever Agent Published Report'){
                                    objGetAllReports.DocumentUrl = urlHost + docURLContent + objURL.get('UL Logo Id').Value__c;
                                } else if(item.RecordType.Name == 'Competitor Report'){
                                    objGetAllReports.DocumentUrl = urlHost + docURLContent + objURL.get('CI Logo Id').Value__c;
                                } 
                            }
                           }
                    }
                    objGetAllReports.TotalCommentCount+=item.Feeds.size();
                    aa_agent_app_custom_setting__c cs = aa_agent_app_custom_setting__c.getInstance('CommentCount');                
                    Integer decresecomment=Integer.valueOf(cs.Value__c);
                    if(objGetAllReports.TotalCommentCount>=decresecomment)
                    objGetAllReports.TotalCommentCount=objGetAllReports.TotalCommentCount-decresecomment;
                    /*Set UL or CI logo if no Chatter post Id associated with Agent Report */
                    if(objGetAllReports.DocumentUrl==null){
                       if(item.RecordType.Name == 'Unilever Agent Published Report'){
                            objGetAllReports.DocumentUrl = urlHost + docURLContent + objURL.get('UL Logo Id').Value__c;
                        } else if(item.RecordType.Name == 'Competitor Report'){
                            objGetAllReports.DocumentUrl = urlHost + docURLContent + objURL.get('CI Logo Id').Value__c;
                        }
                      }
                     
                    objFinalReport.add(objGetAllReports);                   
                }        
        if(objAgentApp.SortOnMostLike=='true'){
            objFinalReport.sort();    
                       
            // Integer i=0; 
             Integer totallimit=Integer.valueOf(appWrapperObj.objAgentAppDataRequest.OffSet)+Integer.valueOf(appWrapperObj.objAgentAppDataRequest.LimitRecords);                       
             List< AA_WrapperUtility.agentReportDetail> objFinalReportForSort = new List<AA_WrapperUtility.agentReportDetail>();           
             Integer counter = Integer.valueOf(appWrapperObj.objAgentAppDataRequest.OffSet);             
             if(totallimit > objFinalReport.size())
                 totallimit=objFinalReport.size();         
             while(counter >= Integer.valueOf(appWrapperObj.objAgentAppDataRequest.OffSet) && counter < totallimit) {
                objFinalReportForSort.add(objFinalReport[counter++]);
             }
             objFinalReport=objFinalReportForSort;                  
        }           
        appWrapperObj.objPassAgentReportsToNG = objFinalReport;
        //To send total number of reports        
        List<String> arr=soqlquery.split( 'where');
        string finalstr=arr[1].SubstringBefore('Order by');
        finalstr=finalstr.SubstringBefore('LIMIT');   
       
        String countquery='Select count() From aa_Agent_Report__c a where '+finalstr;   
        Integer TotalAgentReports=database.countQuery(countquery);
        appWrapperObj.TotalAgentReports=TotalAgentReports;                    
       
        return appWrapperObj;
    }
    
    /* Most like Reports results */
      public AA_ApplicationWrapperObj retrieveAgentReportsOnMostliked(AA_ApplicationWrapperObj appWrapperObj)
            { return appWrapperObj; }
  
    /**
     * @date        -   19/08/2015
     * @description -   retrieving isAcceptedTerms & Condition value
     * @param       -   void
     * @return      -   appWrapperObj of isAcceptedTermsCondition
     * @modifiedby  -   
     */
    public AA_ApplicationWrapperObj isAcceptedTermsAndCondition(AA_ApplicationWrapperObj appWrapperObj){
        List<aa_Agent_App_User_Preference__c> UserPref = [SELECT Id,User_Last_Login__c,UserId__c,Is_Accepted_Terms_Condition__c,T_C_AcceptedDate__c FROM aa_Agent_App_User_Preference__c where UserId__c =: UserInfo.getUserId() LIMIT 1];
         if(UserPref.size() >= 1){
         if(!UserPref[0].Is_Accepted_Terms_Condition__c){
            appWrapperObj.isAcceptedTermsCondition = false;
         }
         else{
            appWrapperObj.isAcceptedTermsCondition = UserPref[0].Is_Accepted_Terms_Condition__c;
            UserPref[0].User_Last_Login__c = System.now(); 
            update UserPref; 
         }
         }
     
        return appWrapperObj;
    }
    
    /**
     * @date        -   19/08/2015
     * @description -   updates isAcceptedTerms & Condition value
     * @param       -   void
     * @return      -   appWrapperObj of isAcceptedTermsCondition
     * @modifiedby  -   
     */
     public AA_ApplicationWrapperObj updateIsAcceptedTermsAndCondition(AA_ApplicationWrapperObj appWrapperObj){
        try{
            aa_Agent_App_User_Preference__c UserPref = new aa_Agent_App_User_Preference__c();
            List<aa_Agent_App_User_Preference__c> UserPrefData = [SELECT Id,User_Last_Login__c,UserId__c,Is_Accepted_Terms_Condition__c,T_C_AcceptedDate__c FROM aa_Agent_App_User_Preference__c where UserId__c =: UserInfo.getUserId() Limit 1];
               
           
                           
            if(UserPrefData.size() >= 1){
            
                UserPref.Is_Accepted_Terms_Condition__c = true;
                UserPref.UserId__c=UserInfo.getUserId();
                UserPref.Id=UserPrefData[0].Id;
                UserPref.User_Last_Login__c = System.now();
                update UserPref;
                appWrapperObj.isAcceptedTermsCondition = true;
                
            }
            else {
                UserPref.UserId__c = UserInfo.getUserId();
                UserPref.Is_Accepted_Terms_Condition__c = true;
                appWrapperObj.isAcceptedTermsCondition = true;
                UserPref.User_Last_Login__c = System.now();
                insert UserPref;
            }
        
        }
        catch(DMLException e){
            system.debug(e.getMessage());
        }

        return appWrapperObj;
    }
    
    /**
     * @date        -   19/08/2015
     * @description -   updates isAcceptedTerms & Condition value
     * @param       -   void
     * @return      -   appWrapperObj of isAcceptedTermsCondition
     * @modifiedby  -   
     */
    public AA_ApplicationWrapperObj updateLikeCount(AA_ApplicationWrapperObj appWrapperObj){
    
        try{           
            
           // aa_Agent_Report__c requestAgentDataObj = new aa_Agent_Report__c();
            AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
            objAgentApp = appWrapperObj.objAgentAppDataRequest;
            
            List<aa_Agent_Report__c> reportList=[select chatter_post_id__c from aa_Agent_Report__c where Id=:Id.valueOf(objAgentApp.AgentReportId)];
            FeedLike objFeed=New FeedLike(FeedItemId=reportList[0].chatter_post_id__c);
            
            insert objFeed;     
                       
           }
            catch(DMLException genEx){
            system.debug(genEx.getMessage());
        }
        appWrapperObj.UpdateLikeCount = true;
        return appWrapperObj;
    }    
   
 /**
     * @date        -   19/08/2015
     * @description -   Reduce the like count when user unlike the report
     * @param       -   AA_ApplicationWrapperObj 
     * @return      -   AA_ApplicationWrapperObj
     * @modifiedby  -   Aslesha RK
     */
       
    
    public AA_ApplicationWrapperObj updateUnlikeCount(AA_ApplicationWrapperObj appWrapperObj){
  
    AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
    objAgentApp = appWrapperObj.objAgentAppDataRequest;

    aa_Agent_Report__c report=[select chatter_post_id__c from aa_Agent_Report__c where Id=:Id.valueOf(objAgentApp.AgentReportId)];
   
    aa_Agent_Report__Feed reportfeed=[Select a.LikeCount, a.Id, ParentId,(Select Id, InsertedById From FeedLikes where InsertedById=:UserInfo.getUserId()) From aa_Agent_Report__Feed a where a.Id=:report.chatter_post_id__c];

    List<Feedlike> feedlikelist=reportfeed.Feedlikes;
  
    
    delete feedlikelist[0];
    
    return appWrapperObj;
   }
    
    
    
    /**
     * @date        -   14/03/2016
     * @description -   @mention user autocomplete method
     * @param       -   AA_ApplicationWrapperObj
     * @return      -   appWrapperObj 
     * @modifiedby  -   
     */
    
    public AA_ApplicationWrapperObj getUserList(AA_ApplicationWrapperObj appWrapperObj)
    {
        AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
        objAgentApp = appWrapperObj.objAgentAppDataRequest;
        AA_WrapperUtility.AgentAppDataResponse wrapperUtilityObj = new AA_WrapperUtility.AgentAppDataResponse(); 
      
        
        if(objAgentApp.searchType=='users')
        {
            String sanitizedSearchString = String.escapeSingleQuotes(objAgentApp.searchString);
        
            List<sObject> userList=new List<sObject>();
        
            String searchQuery = 'FIND \'' + sanitizedSearchString + '*\' IN ALL FIELDS RETURNING ' + 'User' + '(id,name where IsActive=true ) Limit 10';
            List<List<SObject>> searchList = search.query(searchQuery); 
        
       
            for (SObject item : searchList[0]){
                if(userinfo.getUserId() != item.Id){
        
                    userList.add(item);
              }
            }
           //    wrapperUtilityObj.autocompleteList=new List<User>();
            wrapperUtilityObj.autocompleteList=userList;
        }
        
        if(objAgentApp.searchType == 'topics')
        {
           
        String sanitizedSearchString = String.escapeSingleQuotes(objAgentApp.searchString);
        
        List<sObject> topicsList=new List<sObject>();
        
        String searchQuery = 'FIND \'' + sanitizedSearchString + '*\' IN ALL FIELDS RETURNING ' + 'Topic' + '(id,name) Limit 10';
        List<List<SObject>> searchList = search.query(searchQuery); 
         
       
        for (SObject item : searchList[0]){
            
        
                topicsList.add(item);
              
               }
         //  wrapperUtilityObj.autocompleteList=new List<Topic>();
        wrapperUtilityObj.autocompleteList=topicsList;
       

            
        }
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
     
        
         return appWrapperObj;   
              
    }    
}