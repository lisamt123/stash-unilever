public with sharing class AA_AgentAppServiceController {

    public AA_ApplicationWrapperObj aaToOperate {get;set;}
    
    public AA_AgentAppServiceController(){
        aaToOperate = new AA_ApplicationWrapperObj ();
    }
    
    public PageReference callAccountInsert(){
        system.debug(LoggingLevel.INFO,'Inside AA_AgentAppServiceController: callAgentAppInsert : accToBeInserted = '+aaToOperate);
       // AA_ApplicationWrapperObj appWrapperObj = new AA_ApplicationWrapperObj();
       // appWrapperObj.objAgentAppDataRequest = aaToOperate.objAgentAppDataRequest;
       // appWrapperObj.serviceName = AA_Constants.SVC_AGENT_APP_UNILEVER_CREATE;
       // AA_BaseApplicationServices.invokeService(appWrapperObj);
       // system.debug(LoggingLevel.INFO,'Inside AA_AgentAppServiceController: callAgentAppInsert : appWrapperObj.agentReportToInsert value = '+appWrapperObj);
        return null;
    }


    public AA_ApplicationWrapperObj insertAgentApp(AA_ApplicationWrapperObj appWrapperObj){
        try{
            AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
            objAgentApp = appWrapperObj.objAgentAppDataRequest;
            system.debug(LoggingLevel.INFO,'Inside AA_AgentAppServiceController: insertAgentApp : appWrapperObj.agentReportToInsert value = '+objAgentApp);
            list<String> agentAPPIDInserted = AA_DatabaseServiceUtil.upsertOperation(convertRequestAgentReport(objAgentApp));
            list<String> agentAPPDocumentIDInserted = AA_DatabaseServiceUtil.insertOperation(agentAPPIDInserted[0], objAgentApp.ContentDocumentId);
            system.debug(agentAPPIDInserted.size()+'=='+ agentAPPDocumentIDInserted.size());
            appWrapperObj.message = 'Report Inserted Successfully';
             system.debug('Unilever Report Submission Message ======>'+appWrapperObj.message);
            AA_WrapperUtility.AgentAppDataResponse objResponse = new AA_WrapperUtility.AgentAppDataResponse();
            system.debug('AgentDoc====contentDoc'+agentAPPDocumentIDInserted);
            objResponse.agentReportId = agentAPPIDInserted[0];
            appWrapperObj.objGetAgentDataResponse  =  objResponse;
            system.debug('Unilever---====>'+appWrapperObj.objGetAgentDataResponse);
  
        }catch(Exception e){
            
        }
        /*catch(BaseServiceException baseAppEx){
            throw new BaseServiceException(string.valueOf(baseAppEx.getCause()),baseAppEx);
        }
        catch(Exception genEx){
            throw new BaseServiceException(
            'Exception occured: AccountServiceController : insertAccount method ', genEx);
        }*/
        return appWrapperObj;
    }
    
    
     public AA_ApplicationWrapperObj insertAgentApp_Competitor(AA_ApplicationWrapperObj appWrapperObj){
        try{
            AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
            objAgentApp = appWrapperObj.objAgentAppDataRequest;
            system.debug(LoggingLevel.INFO,'Inside AA_AgentAppServiceController: insertAgentApp_Competitor : appWrapperObj.agentReportToInsert value = '+objAgentApp);
            list<String> agentAPPIDInserted = AA_DatabaseServiceUtil.upsertOperation(convertRequestAgentReport_Competitor(objAgentApp));
            list<String> agentAPPDocumentIDInserted = AA_DatabaseServiceUtil.insertOperation(agentAPPIDInserted[0], objAgentApp.ContentDocumentId);
            system.debug(agentAPPIDInserted.size()+'=='+ agentAPPDocumentIDInserted.size());
            appWrapperObj.message = 'Report Inserted Successfully';
            system.debug('Competitor Report Submission Message ======>'+appWrapperObj.message);
            AA_WrapperUtility.AgentAppDataResponse objResponse = new AA_WrapperUtility.AgentAppDataResponse();
            system.debug('AgentDoc====contentDoc'+agentAPPDocumentIDInserted);
            objResponse.agentReportId = agentAPPIDInserted[0];
            appWrapperObj.objGetAgentDataResponse  =  objResponse;
            system.debug('Competitor----====>'+appWrapperObj.objGetAgentDataResponse);
  
        }catch(Exception e){
            
        }
        /*catch(BaseServiceException baseAppEx){
            throw new BaseServiceException(string.valueOf(baseAppEx.getCause()),baseAppEx);
        }
        catch(Exception genEx){
            throw new BaseServiceException(
            'Exception occured: AccountServiceController : insertAccount method ', genEx);
        }*/
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
        aa_Agent_Report__c newObjToBeInserted = new aa_Agent_Report__c();
        if(!Utility.isEmpty(objAgentApp.UnileverBrandId)){
            newObjToBeInserted.Agent_App_Unilever_Brand__c  = objAgentApp.UnileverBrandId;
        }
        if(!Utility.isEmpty(objAgentApp.ReportDesc)){
            newObjToBeInserted.Report_Description__c = objAgentApp.ReportDesc ;
        }
        if(!Utility.isEmpty(objAgentApp.Retailer)){
            newObjToBeInserted.Retailer__c  = objAgentApp.Retailer;
        }
        if(!Utility.isEmpty(objAgentApp.ReportingOn)){
            newObjToBeInserted.Reporting_on__c = objAgentApp.ReportingOn;
        }
        if(!Utility.isEmpty(objAgentApp.CountryId)){
            newObjToBeInserted.Country__c = objAgentApp.CountryId;
        }
        if(!Utility.isEmpty(objAgentApp.ReportName )){
            newObjToBeInserted.Report_Title__c = objAgentApp.ReportName ;
        }
        
        if(!Utility.isEmpty(objAgentApp.Town)){
            newObjToBeInserted.Town__c = objAgentApp.Town;
        }
        if(!Utility.isEmpty(objAgentApp.Longitude)){
            newObjToBeInserted.longitude__c = objAgentApp.Longitude;
        }
        if(!Utility.isEmpty(objAgentApp.Latitude)){
            newObjToBeInserted.latitude__c = objAgentApp.Latitude;
        }
        if(!Utility.isEmpty(objAgentApp.CategoryId )){
            newObjToBeInserted.Category__c = objAgentApp.CategoryId ;
        }
        if(!Utility.isEmpty(objAgentApp.CompetitorId )){
            newObjToBeInserted.Competitor_Name__c = objAgentApp.CompetitorId ;
        }
        if(!Utility.isEmpty(objAgentApp.CompetitorBrandId )){
            newObjToBeInserted.Competitor_Brand__c = objAgentApp.CompetitorBrandId ;
        }
        /* if(!Utility.isEmpty(objAgentApp.ClusterId)){
            newObjToBeInserted.Country__r.Cluster_Id__c = objAgentApp.ClusterId ;
        }*/
        
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Unilever Agent Published Report')).getRecordTypeId();
        newObjToBeInserted.RecordTypeId = recTypeId;
        //newObjToBeInserted.RecordTypeId = '012c00000008rxMAAQ';
        //newObjToBeInserted.RecordTypeId = '012c00000008rxlAAA';
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
        aa_Agent_Report__c newObjToBeInserted = new aa_Agent_Report__c();
        
        if(!Utility.isEmpty(objAgentApp.ReportName )){
            newObjToBeInserted.Report_Title__c = objAgentApp.ReportName ;
        }
        if(!Utility.isEmpty(objAgentApp.ReportDesc)){
            newObjToBeInserted.Report_Description__c = objAgentApp.ReportDesc ;
        }
        if(!Utility.isEmpty(objAgentApp.Source)){
            newObjToBeInserted.Source__c  = objAgentApp.Source;
        }
        if(!Utility.isEmpty(objAgentApp.Retailer)){
            newObjToBeInserted.Retailer__c  = objAgentApp.Retailer;
        }
        if(!Utility.isEmpty(objAgentApp.CompetitorBrandId)){
            newObjToBeInserted.Competitor_Brand__c  = objAgentApp.CompetitorBrandId;
        }
        if(!Utility.isEmpty(objAgentApp.CompetitorId)){
            newObjToBeInserted.Competitor_Name__c  = objAgentApp.CompetitorId;
        }
        if(!Utility.isEmpty(objAgentApp.CategoryId)){
            newObjToBeInserted.Category__c  = objAgentApp.CategoryId;
        }
        if(!Utility.isEmpty(objAgentApp.TopicId)){
            newObjToBeInserted.Topic__c  = objAgentApp.TopicId;
            if(!Utility.isEmpty(objAgentApp.SubTopic)){
                newObjToBeInserted.Sub_Topics__c  = objAgentApp.SubTopic;    
            }
            
        }
        if(!Utility.isEmpty(objAgentApp.CountryId)){
            newObjToBeInserted.Country__c = objAgentApp.CountryId;
        }
        if(!Utility.isEmpty(objAgentApp.Town)){
            newObjToBeInserted.Town__c = objAgentApp.Town;
        }
        if(!Utility.isEmpty(objAgentApp.Longitude)){
            newObjToBeInserted.longitude__c = objAgentApp.Longitude;
        }
        if(!Utility.isEmpty(objAgentApp.Latitude)){
            newObjToBeInserted.latitude__c = objAgentApp.Latitude;
        }
        if(!Utility.isEmpty(objAgentApp.CodeOfConduct)){
            if(objAgentApp.CodeOfConduct == 'true'){
                newObjToBeInserted.Is_Accepted_Code_of_Conduct__c = true;    
            }else if(objAgentApp.CodeOfConduct == 'false'){
                newObjToBeInserted.Is_Accepted_Code_of_Conduct__c = false;    
            }
            
        }
        
       
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
        newObjToBeInserted.RecordTypeId = recTypeId;    
        //newObjToBeInserted.RecordTypeId = '012c00000008rxq';
        return newObjToBeInserted;
    }
    
    public ContentDocumentLink convertRequestAgentReportDocument(AA_WrapperUtility.AgentAppDataRequest objAgentApp,list<String> agentAPPIDInserted){
        //Image Upload
        String agentReportId = agentAPPIDInserted[0];   
        ContentDocumentLink newFileShare = new ContentDocumentLink();
        system.debug('content Version Id ========>'+objAgentApp.ContentDocumentId);     
        newFileShare.ContentDocumentId = [SELECT Id, VersionNumber, ContentDocumentId FROM ContentVersion where Id=: objAgentApp.ContentDocumentId LIMIT 1].ContentDocumentId ;
        system.debug('content Doc Id ========>'+newFileShare.ContentDocumentId);
        newFileShare.ShareType= 'V';
        newFileShare.LinkedEntityId = ID.valueOf(agentReportId);
        system.debug('======='+newFileShare);
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
        system.debug('List of unilever brand ====>'+ wrapperUtilityObj.unileverBrandList );
        appWrapperObj.objGetAgentDataResponse =  wrapperUtilityObj;
        
        //Retailer Values
        List<aa_Agent_Retailer__c>  agentRetailerList = getRetailerListValues();
        wrapperUtilityObj.unileverRetailerList = new List<aa_Agent_Retailer__c>();
        wrapperUtilityObj.unileverRetailerList = agentRetailerList;
        system.debug('List of Retailer ====>'+wrapperUtilityObj.unileverRetailerList );
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Reporting On Values
        List<String> reportingOnPickList = new List<String>();
        reportingOnPickList = getReportingOnListValues();
        wrapperUtilityObj.reportingOnPicklistValues = new List<String>();
        wrapperUtilityObj.reportingOnPicklistValues = reportingOnPickList;
        system.debug('List of Reporting ====>'+ wrapperUtilityObj.reportingOnPicklistValues);
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Country List Values 
        List<aa_Country__c>  countryValuesList = getCountryValues();
        wrapperUtilityObj.countryList = new List<aa_Country__c>();
        wrapperUtilityObj.countryList = countryValuesList;
        system.debug('List of country ====>'+wrapperUtilityObj.countryList);
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Cluster List Values
        List <aa_Cluster__c> clusterValuesList= getClusterValues();
        wrapperUtilityObj.clusterList = new List<aa_Cluster__c>();
        wrapperUtilityObj.clusterList = clusterValuesList;
        system.debug('List of cluster aslesha ====>'+wrapperUtilityObj.clusterList);
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        Map<string,aa_agent_app_custom_setting__c> objURL = aa_agent_app_custom_setting__c.getAll(); 
       // wrapperUtilityObj.googleApiVaue = objURL.get('Google Api Key').Value__c;
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
                                              
        return appWrapperObj;
    }
    //By anjali
   /* public AA_ApplicationWrapperObj getCountryClusterMap(AA_ApplicationWrapperObj appWrapperObj){
        Map<aa_Cluster__c,List<aa_Country__c>> countryClusterMapValues = getCountryClusterValues();
        AA_WrapperUtility.AgentAppDataResponse wrapperUtilityObj = new AA_WrapperUtility.AgentAppDataResponse();
        wrapperUtilityObj.countryClusterMap = new Map<aa_Cluster__c,List<aa_Country__c>>();
        wrapperUtilityObj.countryClusterMap = countryClusterMapValues;
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        return appWrapperObj;
    }
    
    
    public  Map<aa_Cluster__c,List<aa_Country__c>> getCountryClusterValues(){
        List<aa_Country__c> countrylst = getCountryValues();
        List<aa_Cluster__c> clusterList = getClusterValues();
        List<aa_Country__c> countryFinalList =  new List<aa_Country__c>();
        Map<aa_Cluster__c,List<aa_Country__c>> mapValue = new Map<aa_Cluster__c,List<aa_Country__c>>();
       
        for(aa_Cluster__c clusterObj:clusterList){
            for(aa_Country__c countryObj:countrylst){
                if(clusterObj.id == countryObj.Cluster_Id__c){
                    countryFinalList.add(countryObj);
                }
            
            }
            mapValue.put(clusterObj,countryFinalList);
            countryFinalList.clear();
        }
     return mapValue;
    }*/
    /**
     * @date        -   03/08/2015
     * @description -   retrieve all Unilever Brand Name 
     * @param       -   void 
     * @return      -   All unileverBrand name and Id in List format
     * @modifiedby  -   
     */
    public static List<aa_Agent_App_Competitor_Brand__c> getUnileverListValues(){
        List<aa_Agent_App_Competitor_Brand__c > agentUnileverBrandList = fetchValuesByRecordType('aa_Agent_App_Competitor_Brand__c','id,name','Unilever Brand');     
        return agentUnileverBrandList;
        
    }
    
     /**
     * @date        -   03/08/2015
     * @description -   retrieve all Competitor Brand Name 
     * @param       -   void 
     * @return      -   All Competitor Brand name and Id in List format
     * @modifiedby  -   
     
    public static List<aa_Agent_Unilever_Brand__c> getCompetitorListValues(){
        List<aa_Agent_Unilever_Brand__c> agentUnileverBrandList = fetchValues('aa_Agent_Unilever_Brand__c','id,name');     
        return agentUnileverBrandList;
        
    }*/
    
    /**
     * @date        -   03/08/2015
     * @description -   retrieve all retailer Name 
     * @param       -   void 
     * @return      -   All retailer name and Id in List format
     * @modifiedby  -   
     */
    public List<aa_Agent_Retailer__c>  getRetailerListValues(){
        List<aa_Agent_Retailer__c> agentRetailerList = fetchValues('aa_Agent_Retailer__c','id,name');  
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
        List<aa_Cluster__c> ClusterNameList = fetchValues('aa_Cluster__c','id,name');
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
         List<Sobject> result;
         String query;
         if(!Utility.isEmpty(SobjectApiName) && !Utility.isEmpty(commaSepratedFields)){
            system.debug(SobjectApiName +'==='+commaSepratedFields);
            query = 'select ' + commaSepratedFields + ' from ' + SobjectApiName ;
            result = Database.query(query);
         }
       return result;
    }
   
    public static List<Sobject> fetchValuesByRecordType(String SobjectApiName,String commaSepratedFields, String recType){
        /*Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get(recType)).getRecordTypeId();*/
        
        List<Sobject> result;
        String query;
         if(!Utility.isEmpty(SobjectApiName) && !Utility.isEmpty(commaSepratedFields)){
            system.debug(SobjectApiName +'==='+commaSepratedFields);
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
        //Competitor Name and Category Values
       system.debug('11111111111111==========>'+appWrapperObj.objAgentAppDataRequest.CompetitorBrandId);
        //Map<String,String> agentBrandCategory = getCompetitorCategory(appWrapperObj.objAgentAppDataRequest.CompetitorBrandId);
        List<aa_Agent_App_Brand_Category__c> objSelectedCompetitorCategoryOnBrand= getCompetitorCategory(appWrapperObj.objAgentAppDataRequest.CompetitorBrandId);
        wrapperUtilityObj.selectedCompetitorCategoryOnBrand = objSelectedCompetitorCategoryOnBrand;
        //wrapperUtilityObj.competitorCategoryMap = new Map<String,String>();
        //wrapperUtilityObj.competitorCategoryMap = agentBrandCategory;     
        system.debug('wrapperUtilityObj.selectedCompetitorCategoryOnBrand ====>'+ wrapperUtilityObj.selectedCompetitorCategoryOnBrand);
        appWrapperObj.objGetAgentDataResponse =  wrapperUtilityObj;
        system.debug('Wrapper obj------------------->'+appWrapperObj);
        return appWrapperObj;
    }
    
    public List<aa_Agent_App_Competitor_Brand__c>  getCompetitorBrandListValues(){
        List<aa_Agent_App_Competitor_Brand__c> agentCompetitorBrandList = fetchValuesByRecordType('aa_Agent_App_Competitor_Brand__c','id,name','Competitor Brand');  
        return agentCompetitorBrandList;
    }
    public List<aa_Agent_Competitor__c>  getCompetitorNameListValues(){
        List<aa_Agent_Competitor__c> agentCompetitorNameList = fetchValues('aa_Agent_Competitor__c','id,name');  
        return agentCompetitorNameList;
    }
    public List<aa_Agent_App_Category__c>  getCompetitorCategoryListValues(){
        List<aa_Agent_App_Category__c> agentCompetitorCategoryList = fetchValues('aa_Agent_App_Category__c','id,name');  
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
        system.debug('List of Retailer ====>'+wrapperUtilityObj.unileverRetailerList );
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Source Values
        List<String> sourcePickList = new List<String>();
        sourcePickList = getSourceListValues();
        wrapperUtilityObj.sourcePicklistValues = new List<String>();
        wrapperUtilityObj.sourcePicklistValues = sourcePickList;
        system.debug('List of source ====>'+ wrapperUtilityObj.sourcePicklistValues);
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Topic Values 
        List<aa_Topic__c>  topicValuesList = getTopicListValues();
        wrapperUtilityObj.topicList = new List<aa_Topic__c>();
        wrapperUtilityObj.topicList = topicValuesList;
        system.debug('List of topics ====>'+wrapperUtilityObj.topicList);
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
                
        //Country List Values 
        List<aa_Country__c>  countryValuesList = getCountryValues();
        wrapperUtilityObj.countryList = new List<aa_Country__c>();
        wrapperUtilityObj.countryList = countryValuesList;
        system.debug('List of country ====>'+wrapperUtilityObj.countryList);
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Competitor Brand List Values 
        List<aa_Agent_App_Competitor_Brand__c>  objCompetitorBrandList = getCompetitorBrandListValues();
        wrapperUtilityObj.competitorBrandList = new List<aa_Agent_App_Competitor_Brand__c>();
        wrapperUtilityObj.competitorBrandList = objCompetitorBrandList;
        system.debug('wrapperUtilityObj.competitorBrandList ====>'+wrapperUtilityObj.competitorBrandList);
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Competitor Name List Values 
        List<aa_Agent_Competitor__c>  objCompetitorNameList = getCompetitorNameListValues();
        wrapperUtilityObj.competitorNameList = new List<aa_Agent_Competitor__c>();
        wrapperUtilityObj.competitorNameList = objCompetitorNameList;
        system.debug('wrapperUtilityObj.competitorNameList ====>'+wrapperUtilityObj.competitorNameList);
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Category Name List Values 
        List<aa_Agent_App_Category__c>  objCategoryNameList = getCompetitorCategoryListValues();
        wrapperUtilityObj.categoryList = new List<aa_Agent_App_Category__c>();
        wrapperUtilityObj.categoryList = objCategoryNameList;
        system.debug('wrapperUtilityObj.categoryList ====>'+wrapperUtilityObj.categoryList);
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
         //Cluster List Values
        List <aa_Cluster__c> clusterValuesList= getClusterValues();
        wrapperUtilityObj.clusterList = new List<aa_Cluster__c>();
        wrapperUtilityObj.clusterList = clusterValuesList;
        system.debug('List of cluster aslesha ====>'+wrapperUtilityObj.clusterList);
        appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        Map<string,aa_agent_app_custom_setting__c> objURL = aa_agent_app_custom_setting__c.getAll(); 
       // wrapperUtilityObj.googleApiVaue = objURL.get('Google Api Key').Value__c;
        system.debug('======>google'+wrapperUtilityObj.googleApiVaue);
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
                
        }Catch(Exception e){
            
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
        system.debug('========sourcePickListValues=====>'+sourcePickListValues);
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
        List<aa_Topic__c> agentTopicList = fetchValues('aa_Topic__c','id,name,Sub_Topic__c');     
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
    
    
   public AA_ApplicationWrapperObj retriveAllAgentReports(AA_ApplicationWrapperObj appWrapperObj){
   try{
        system.debug('service controller retrive reports'+appWrapperObj.objAgentAppDataRequest);
        Map<string,aa_agent_app_custom_setting__c> objURL = aa_agent_app_custom_setting__c.getAll(); 
        String urlHost =  objURL.get('Salesforce Instance URL Content').Value__c;  // Salesforce Instance URL
        String sfcURLContent =  objURL.get('SFC Content').Value__c; // URL for Image population on UI
        String docURLContent =  objURL.get('Document URL Content').Value__c; // URL for Document (Logo) population on UI
        system.debug('Custom Setting Contents urlHost'+urlHost+' sfcURLContent'+sfcURLContent +' docURLContent'+docURLContent); 
       
        String soqlquery='Select Id,Chatter_Post_ID__c,LastModifiedDate,Agent_App_Unilever_Brand__r.Name, Agent_App_Unilever_Brand__c,Town__c,Retailer__c, Retailer__r.Name, RecordType.Name, Name, Report_Title__c,Report_Description__c,CreatedDate,CreatedBy.SmallPhotoUrl, CreatedBy.Name, Country__c, Country__r.Name, Country__r.Cluster_Id__r.name,Country__r.Cluster_Id__c, Competitor_Name__c,Competitor_Name__r.Name,  Competitor_Brand__c,Competitor_Brand__r.Name,  Category__c, Category__r.Name,  Status__c,(Select Id, CommentCount, LikeCount, CreatedById,RelatedRecordId, ContentFileName From Feeds) From aa_Agent_Report__c where Status__c = \'Published (Public)\' ';
        
        system.debug('wapper object=====>'+appWrapperObj);
        system.debug('filter type%%%%% '+appWrapperObj.objAgentAppDataRequest.FilterType+'  aply filter'+appWrapperObj.objAgentAppDataRequest.ApplyFilter);
         AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
          objAgentApp = appWrapperObj.objAgentAppDataRequest;
        
        if(appWrapperObj.objAgentAppDataRequest!=null)
        {
        if(appWrapperObj.objAgentAppDataRequest.FilterType==null ||  appWrapperObj.objAgentAppDataRequest.FilterType=='AllReports'){
            
        }
        
        if(appWrapperObj.objAgentAppDataRequest.FilterType=='myReport')
        {
            system.debug('In My Reports**');
            soqlquery +='AND CreatedById =\''+UserInfo.getUserId()+'\'';  
        }
        
        if(appWrapperObj.objAgentAppDataRequest.FilterType=='filterReports' )
        {
        
           system.debug('in filtered reports ');
            aa_Agent_Report__c requestAgentDataObj = new aa_Agent_Report__c();
                
            if(objAgentApp.ApplyFilter==null || objAgentApp.ApplyFilter=='false'){
                system.debug('apply filter null.......... faching values from db for user preferences');
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
                                                                
             if(UserPref.Country__c != NULL )
                {
                   soqlquery +='AND Country__c =\''+UserPref.Country__c+'\' ';    
                }
                
                if(UserPref.Agent_App_Unilever_Brand__c!=NULL)
                {
                  soqlquery +='AND Agent_App_Unilever_Brand__c =\''+UserPref.Agent_App_Unilever_Brand__c+'\' ';
                }
                
                if(UserPref.Competitor_Name__c !=NULL)
                {
                  soqlquery +='AND Competitor_Name__c=\''+UserPref.Competitor_Name__c+'\' ';
                }
                
                if(UserPref.Competitor_Brand__c !=NULL)
                 {
                   soqlquery +='AND Competitor_Brand__c =\''+UserPref.Competitor_Brand__c+'\' ';
                 }
                
                if(UserPref.Retailer__c !=NULL)
                {
                   soqlquery +='AND Retailer__c =\''+UserPref.Retailer__c+'\' ';
                }
                
                if(UserPref.Category__c !=NULL)
                {
                   soqlquery +='AND Category__c =\''+UserPref.Category__c+'\' ';
                }  
                 if(UserPref.Cluster__c !=NULL)
                {
                   soqlquery +='AND Country__r.Cluster_Id__c =\''+UserPref.Cluster__c+'\' ';
                }   
                if(UserPref.RecordTypeId__c!=NULL)
                {
                soqlquery +='AND RecordTypeId  = \''+UserPref.RecordTypeId__c+'\' ';    
                }       
                if(UserPref.Topic__c!=NULL)
                {
                    soqlquery +='AND Topic__c = \''+UserPref.Topic__c+'\' ';
                }
                if(UserPref.ReportingOn__c!=NULL)
                {
                    soqlquery +='AND Reporting_on__c = \''+UserPref.ReportingOn__c+'\' ';
                }
                  

           }else if(appWrapperObj.objAgentAppDataRequest.ApplyFilter=='true') {         
               system.debug('apply filter true saving user pref***********');
                requestAgentDataObj=(aa_Agent_Report__c)convertRequestAgentReport(objAgentApp);
                system.debug('requestAgentDataObj==>'+requestAgentDataObj);
                
                if(requestAgentDataObj.country__c != NULL )
                {
                   soqlquery +='AND Country__c =\''+requestAgentDataObj.country__c+'\' ';    
                }
                
                if(requestAgentDataObj.Agent_App_Unilever_Brand__c !=NULL)
                {
                  soqlquery +='AND Agent_App_Unilever_Brand__c = \''+requestAgentDataObj.Agent_App_Unilever_Brand__c +'\' ';
                }
                
                if(requestAgentDataObj.Competitor_Name__c !=NULL)
                {
                  soqlquery +='AND Competitor_Name__c= \''+requestAgentDataObj.Competitor_Name__c +'\' ';
                }
                
                if(requestAgentDataObj.Competitor_Brand__c !=NULL)
                 {
                   soqlquery +='AND Competitor_Brand__c =  \''+ requestAgentDataObj.Competitor_Brand__c+'\' ';
                 }
                
                if(requestAgentDataObj.Retailer__c !=NULL)
                {
                   soqlquery +='AND Retailer__c = \''+requestAgentDataObj.Retailer__c+'\' ';
                }
                
                if(requestAgentDataObj.Category__c !=NULL)
                {
                   soqlquery +='AND Category__c = \''+requestAgentDataObj.Category__c+'\' ';
                }
                
                if(appWrapperObj.objAgentAppDataRequest.ClusterId!=NULL)
                {
                   soqlquery +='AND Country__r.Cluster_Id__c = \''+appWrapperObj.objAgentAppDataRequest.ClusterId+'\' ';
                }
                if(appWrapperObj.objAgentAppDataRequest.TopicId!=NULL)
                {
                    soqlquery +='AND Topic__c = \''+appWrapperObj.objAgentAppDataRequest.TopicId+'\' ';
                }
                if(appWrapperObj.objAgentAppDataRequest.ReportingOn!=NULL)
                {
                    soqlquery +='AND Reporting_on__c = \''+appWrapperObj.objAgentAppDataRequest.ReportingOn+'\' ';
                }
                String recTypeId='';
                if(appWrapperObj.objAgentAppDataRequest.RecordType=='Unilever')
                {
                    //RecordType Rectype=[Select  r.Name,r.Id From RecordType r where IsActive=true and Name like 'Unilever Agent Published Report' and  SobjectType='aa_agent_report__c'];
                    Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
                    Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
                    recTypeId = (RT.get('Unilever Agent Published Report')).getRecordTypeId();
                    //newObjToBeInserted.RecordTypeId = recTypeId;
                    system.debug('Record Type Id==>'+recTypeId);
                    soqlquery +='AND RecordTypeId  = \''+recTypeId+'\' ';
                }                   
            
               if(appWrapperObj.objAgentAppDataRequest.RecordType=='Competitor')
                {
                    //RecordType Rectype=[Select  r.Name,r.Id From RecordType r where IsActive=true and Name like 'Competitor Report' and  SobjectType='aa_agent_report__c'];
                    Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
                    Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
                    recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
                    soqlquery +='AND RecordTypeId  = \''+recTypeId+'\' ';
                }  
            
            aa_Agent_App_User_Preference__c userPref = [SELECT Id,UserId__c 
                                                               FROM aa_Agent_App_User_Preference__c              
                                                              Where UserId__c =: UserInfo.getUserId()];
            system.debug('categoryid:::::::'+userPref);
            system.debug('country ID to be saved in user pref'+requestAgentDataObj.Country__c);
             
            userPref.Category__c=requestAgentDataObj.Category__c;
            if(requestAgentDataObj.Country__c!= null || requestAgentDataObj.Country__c!='null')
            userPref.Country__c=requestAgentDataObj.Country__c;
            
            userPref.Competitor_Brand__c=requestAgentDataObj.Competitor_Brand__c;
            userPref.Competitor_Name__c=requestAgentDataObj.Competitor_Name__c;
            userPref.Retailer__c=requestAgentDataObj.Retailer__c;
            userPref.Agent_App_Unilever_Brand__c=requestAgentDataObj.Agent_App_Unilever_Brand__c;
            if(appWrapperObj.objAgentAppDataRequest.ClusterId!=null || appWrapperObj.objAgentAppDataRequest.ClusterId!='null')
            userPref.Cluster__c=appWrapperObj.objAgentAppDataRequest.ClusterId;
            userPref.RecordTypeId__c=recTypeId;
            userPref.Topic__c=appWrapperObj.objAgentAppDataRequest.TopicId;
            userPref.ReportingOn__c=appWrapperObj.objAgentAppDataRequest.ReportingOn;
            system.debug('user pref will be saved as*==> '+userPref);
            update userPref;            
        }
        }
         system.debug('************'+appWrapperObj.objAgentAppDataRequest.LimitRecords);
         
         if(objAgentApp.SortOnMostLike!='true' || objAgentApp.SortOnMostLike==NULL){
         soqlquery +=' Order by LastModifiedDate desc';
         }
         else if(objAgentApp.SortOnMostLike=='true'){
            String  soqlFeedQuery='SELECT Id,likecount FROM aa_Agent_Report__Feed order by likecount desc limit 1000'  ; //+ ' OFFSET '+appWrapperObj.objAgentAppDataRequest.OffSet;
            List<aa_Agent_Report__Feed> feedlist=  database.query(soqlFeedQuery);             
            set<ID>idlist=new set<ID>();
            
            String reportidInString='( ';
           
            for(aa_Agent_Report__Feed item:feedlist)
            {
                 // if(i>Integer.valueOf(appWrapperObj.objAgentAppDataRequest.OffSet) && i<=totallimit)
                  //{
                   idlist.add(String.valueOf(item.id));
                   reportidInString+='\''+item.id+'\',';
                  //}
                   //i++; 
            }
                   reportidInString+='\'\' )';
           // set<ID> finalreportId=new set<ID>();
            
                       
                   
             soqlquery +=' AND chatter_post_id__c IN   '+ reportidInString; 
             system.debug('%%%%%%%%%%%1234'+' AND chatter_post_id__c IN  '+ reportidInString);
         }
         
        if(appWrapperObj.objAgentAppDataRequest.LimitRecords!=null && appWrapperObj.objAgentAppDataRequest.OffSet!=null &&(objAgentApp.SortOnMostLike!='true' || objAgentApp.SortOnMostLike==NULL)  )
        {
           soqlquery +=' LIMIT '+ appWrapperObj.objAgentAppDataRequest.LimitRecords + ' OFFSET '+appWrapperObj.objAgentAppDataRequest.OffSet;
        }else
           soqlquery +='  LIMIT 1000';
        
        }else
           soqlquery +='  LIMIT 1000';
        system.debug('Final SOQL Query -- >'+soqlquery);    
        List <aa_Agent_Report__c> tmpList=  database.query(soqlquery);          
        system.debug('tmpList aa report '+tmpList); 
        List<AA_WrapperUtility.agentReportDetail> objFinalReport = new List<AA_WrapperUtility.agentReportDetail>(); 
        
        // To check whether current user has liked report or not 
                   Set<ID> feedIds=new Set<ID>();
                   for(aa_Agent_Report__c itemfeedlike :tmpList){
                       for(aa_Agent_Report__Feed objfeedlike :itemfeedlike.Feeds){
                          if(itemfeedlike.Chatter_Post_ID__c==objfeedlike.Id){
                               feedIds.add(objfeedlike.Id);  
                          } 
                       }
                   }
                   system.debug('feedids set==>'+feedIds);
                   Map<ID,String> ReportUserLike =new Map<ID,String>();
                   List<aa_Agent_Report__Feed> userfeedliketest= [Select ParentId ,RelatedRecordId,(Select Id, InsertedById  From FeedLikes) From aa_Agent_Report__Feed a where a.Id IN: feedIds];
                  
                   for (aa_Agent_Report__Feed agentfeed :userfeedliketest){
                       for(FeedLike objfeedlike : agentfeed.FeedLikes)
                       {
                                 system.debug('in for of feedlike'+objfeedlike.InsertedById +'===userId'+UserInfo.getUserId()+'reportid::'+agentfeed.ParentId);
                                  if(objfeedlike.InsertedById==UserInfo.getUserId() ){
                                    ReportUserLike.put(agentfeed.ParentId,'true');
                                  }/*else{
                                   ReportUserLike.put(agentfeed.ParentId,'false');
                                  }*/
                       }
                   }
                   
                   system.debug('Final USer like map %%%%%%%'+ReportUserLike);
        
        
        
        for(aa_Agent_Report__c item : tmpList)
                {
                   AA_WrapperUtility.agentReportDetail objGetAllReports = new AA_WrapperUtility.agentReportDetail();
                   //objGetAllReports.LikeCount=0;
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
                    system.debug('=>>>>>>>>>>>>>>'+system.now()+'<<<<<'+objGetAllReports.currentTime);
                    //objGetAllReports.recordType=item.RecordType.Name;
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
                    system.debug(LoggingLevel.INFO,'?retriveAllAgentReports? item.Feeds -- ?'+objGetAllReports.feedList);
                    objGetAllReports.clusterName = item.Country__r.Cluster_Id__r.name;
                    objGetAllReports.clusterId=item.Country__r.Cluster_Id__c;
                    objGetAllReports.UserLike=ReportUserLike.get(objGetAllReports.agentReportID);
                    
                   // system.debug('feed array***********'+item.Feeds);
                   Set<String> imageFilekeyWords = new Set<String>{'.png','.jpg','.jpeg','.bmp','.JPG','.JPEG','.BMP','.PNG'}; // know the image file 
                   Set<String> docFilekeyWords = new Set<String>{'.ppt','.pdf','.xls','.xlsx','.doc','.docx','.csv','.txt'}; // know the image file     
                    for(aa_Agent_Report__Feed objfeed :item.Feeds)
                    {
                     objGetAllReports.TotalCommentCount+=objfeed.CommentCount;
                     system.debug('item.Chatter_Post_ID__c -- >'+item.Chatter_Post_ID__c+'== objfeed.Id : '+objfeed.Id );
                    // objGetAllReports.LikeCount=0;
                     if(item.Chatter_Post_ID__c == objfeed.Id){
                        system.debug('in like counr@@@@@@@@@@@@@@@@');
                        objGetAllReports.LikeCount=objfeed.LikeCount;
                       // objGetAllReports.TotalCommentCount=objfeed.CommentCount;
                        system.debug('Like count for this record================================>'+objfeed.LikeCount);
                    }
                        if(item.Chatter_Post_ID__c == objfeed.Id && objfeed.ContentFileName!=null){
                           
                            
                            system.debug(' objfeed.ContentFileName ' +objfeed.ContentFileName);
                            String feedFileName = objfeed.ContentFileName;
                            system.debug(' feedFileName ' +feedFileName);
                            List<String> tmpFileNameList = feedFileName.split('\\.');
                            String fileExtension;
                            if(tmpFileNameList.size() > 0){
                                fileExtension = '.'+tmpFileNameList[tmpFileNameList.size() -1];
                                fileExtension=fileExtension.toLowerCase();
                            }
                           fileExtension=fileExtension.toLowerCase();
                            //fileExtension.toLowerCase();
                            system.debug(' tmpFileNameList -->'+tmpFileNameList+' fileExtension-- >'+fileExtension);
                            if(imageFilekeyWords.contains(fileExtension)){/*If Image file format associated with Chatter Post*/
                                System.debug('It contains Image!');
                                 objGetAllReports.DocumentUrl = urlHost + sfcURLContent + objfeed.RelatedRecordId;
                                system.debug('tmpList aa report Image one* '+objGetAllReports.agentReportID);
                            }else if(docFilekeyWords.contains(fileExtension)){ /*If perticular file format associated with Chatter Post*/
                                System.debug('It contains file!');
                                if(item.RecordType.Name == 'Unilever Agent Published Report'){
                                    objGetAllReports.DocumentUrl = urlHost + docURLContent + objURL.get('UL Logo Id').Value__c;
                                } else if(item.RecordType.Name == 'Competitor Report'){
                                    objGetAllReports.DocumentUrl = urlHost + docURLContent + objURL.get('CI Logo Id').Value__c;
                                } 
                                system.debug('tmpList aa report Doc  '+objGetAllReports.DocumentUrl);
                            }
                            system.debug('tmpList aa report Doc 099* '+objGetAllReports.agentReportID);
                            system.debug('final like count for report'+objfeed.LikeCount+'final comment count'+objfeed.CommentCount+'sending value==>'+objGetAllReports.TotalCommentCount);
                        }
                    }
                    system.debug('item.Feeds.size()'+item.Feeds.size()+'++'+objGetAllReports.TotalCommentCount);
                    objGetAllReports.TotalCommentCount+=item.Feeds.size();
                    aa_agent_app_custom_setting__c cs = aa_agent_app_custom_setting__c.getInstance('CommentCount');
                    system.debug('CommentCount=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+cs.Value__c);
                    Integer decresecomment=Integer.valueOf(cs.Value__c);
                    if(objGetAllReports.TotalCommentCount>=decresecomment)
                    objGetAllReports.TotalCommentCount=objGetAllReports.TotalCommentCount-decresecomment;
                    /*Set UL or CI logo if no Chatter post Id associated with Agent Report */
                    if(objGetAllReports.DocumentUrl==null){
                        system.debug('*No File or Image Attached to Report*1232'+objGetAllReports.LikeCount);
                        if(item.RecordType.Name == 'Unilever Agent Published Report'){
                            objGetAllReports.DocumentUrl = urlHost + docURLContent + objURL.get('UL Logo Id').Value__c;
                        } else if(item.RecordType.Name == 'Competitor Report'){
                            objGetAllReports.DocumentUrl = urlHost + docURLContent + objURL.get('CI Logo Id').Value__c;
                        } 
                    }
                    //objGetAllReports.createdTime =item.CreatedDate;
                    objFinalReport.add(objGetAllReports);
                    system.debug('tmpList aa report 9* ');
                }
                system.debug('fileter type for sort'+appWrapperObj.objAgentAppDataRequest.FilterType);
        
        if(objAgentApp.SortOnMostLike=='true'){
            system.debug('sorting the report%%%%%%%%%%%%');
            objFinalReport.sort();
            
            for(AA_WrapperUtility.agentReportDetail test:objFinalReport){
            system.debug('sorted report Like count here=====>'+test.LikeCount);       
            
            }
                    
            
             Integer i=0; 
             Integer totallimit=Integer.valueOf(appWrapperObj.objAgentAppDataRequest.OffSet)+Integer.valueOf(appWrapperObj.objAgentAppDataRequest.LimitRecords);
             system.debug('offset'+Integer.valueOf(appWrapperObj.objAgentAppDataRequest.OffSet)+'totallimit%%'+totallimit);
             
             List< AA_WrapperUtility.agentReportDetail> objFinalReportForSort = new List<AA_WrapperUtility.agentReportDetail>();
           
             Integer counter = Integer.valueOf(appWrapperObj.objAgentAppDataRequest.OffSet);
             
             if(totallimit > objFinalReport.size())
                 totallimit=objFinalReport.size();         
             while(counter >= Integer.valueOf(appWrapperObj.objAgentAppDataRequest.OffSet) && counter < totallimit) {
                objFinalReportForSort.add(objFinalReport[counter++]);
                system.debug('report record hereeeeeeee=='+counter);
                }
                
               system.debug('List for sorted response ===>'+objFinalReportForSort); 
             objFinalReport=objFinalReportForSort;
             
            for(AA_WrapperUtility.agentReportDetail test:objFinalReportForSort){
            system.debug('sorted report Like count here with offset & limit=====>'+test.LikeCount);       
            
            }
            
        }    
        
           
        appWrapperObj.objPassAgentReportsToNG = objFinalReport;
        //To send total number of reports
        
        List<String> arr=soqlquery.split( 'where');
        system.debug('***************split where::'+ arr[1]);
        string finalstr=arr[1].SubstringBefore('Order by');
        finalstr=finalstr.SubstringBefore('LIMIT');
        system.debug('****finalcount***********'+ finalstr);
       // appWrapperObj.TotalAgentReports=10;
        String countquery='Select count() From aa_Agent_Report__c a where '+finalstr;
        system.debug('Final total count query'+countquery);
        Integer TotalAgentReports=database.countQuery(countquery);
        appWrapperObj.TotalAgentReports=TotalAgentReports; 
        system.debug('total number of rows'+TotalAgentReports);
                
       //appWrapperObj.TotalAgentReports=9;
        system.debug(LoggingLevel.INFO,'?retriveAllAgentReports?  '+appWrapperObj.objPassAgentReportsToNG);                               
        }catch(DMLException e){
            system.debug(e.getMessage());
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        
        return appWrapperObj;
    }
    
    /* Most like Reports results */
   public AA_ApplicationWrapperObj retrieveAgentReportsOnMostliked(AA_ApplicationWrapperObj appWrapperObj)
            { return appWrapperObj; }
      /*         try{
               system.debug('service controller retrive reports'+appWrapperObj.objAgentAppDataRequest);
               Map<string,aa_agent_app_custom_setting__c> objURL = aa_agent_app_custom_setting__c.getAll(); 
               String urlHost =  objURL.get('Salesforce Instance URL Content').Value__c;  // Salesforce Instance URL
               String sfcURLContent =  objURL.get('SFC Content').Value__c; // URL for Image population on UI
               String docURLContent =  objURL.get('Document URL Content').Value__c; // URL for Document (Logo) population on UI
               system.debug('Custom Setting Contents urlHost'+urlHost+' sfcURLContent'+sfcURLContent +' docURLContent'+docURLContent); 
               aa_Agent_Report__c requestAgentDataObj = new aa_Agent_Report__c();
               AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
               objAgentApp = appWrapperObj.objAgentAppDataRequest;
                
               List<string> idlist=new List<string>();
               List< AA_WrapperUtility.agentReportDetail> objFinalReport = new List<AA_WrapperUtility.agentReportDetail>();
               
               //List<aa_Agent_Report__Feed> feedlist=[SELECT Id,likecount FROM aa_Agent_Report__Feed order by likecount desc LIMIT :appWrapperObj.objAgentAppDataRequest.LimitRecords  OFFSET : appWrapperObj.objAgentAppDataRequest.OffSet];
             
             
              String  soqlFeedQuery='SELECT Id,likecount FROM aa_Agent_Report__Feed order by likecount desc';
                      
                      soqlFeedQuery +=' LIMIT '+ appWrapperObj.objAgentAppDataRequest.LimitRecords + ' OFFSET '+appWrapperObj.objAgentAppDataRequest.OffSet;
       
              system.debug('Final feed Query -- >'+soqlFeedQuery);    
              List<aa_Agent_Report__Feed> feedlist=  database.query(soqlFeedQuery);             
             
               system.debug('#######'+feedlist) ;
               for(aa_Agent_Report__Feed item:feedlist)
                {
                   idlist.add(String.valueOf(item.id));
                }
            
                   List<aa_Agent_Report__c> reportList=[Select Id,Chatter_Post_ID__c,Agent_App_Unilever_Brand__r.Name, Agent_App_Unilever_Brand__c,Town__c,Retailer__c, Retailer__r.Name, Report_Description__c,RecordType.Name, Name, Report_Title__c,CreatedDate,CreatedBy.SmallPhotoUrl, CreatedBy.Name, Country__c, Country__r.Name, Country__r.Cluster_Id__r.name,Country__r.Cluster_Id__c, Competitor_Name__c,Competitor_Name__r.Name,  Competitor_Brand__c,Competitor_Brand__r.Name,  Category__c, Category__r.Name,  Status__c,(Select Id, CommentCount, LikeCount, CreatedById,RelatedRecordId, ContentFileName From Feeds) From aa_Agent_Report__c where Status__c ='Published (Public)' AND chatter_post_id__c in:idlist];
                   
                   
                   // To check whether current user has liked report or not 
                   Set<ID> feedIds=new Set<ID>();
                   for(aa_Agent_Report__c itemfeedlike :reportList){
                       for(aa_Agent_Report__Feed objfeedlike :itemfeedlike.Feeds){
                        if(itemfeedlike.Chatter_Post_ID__c==objfeedlike.Id){
                               feedIds.add(objfeedlike.Id);  
                        }
                       }
                   }
                   system.debug('feedids set==>'+feedIds);
                   Map<ID,String> ReportUserLike =new Map<ID,String>();
                   List<aa_Agent_Report__Feed> userfeedliketest= [Select ParentId ,RelatedRecordId,(Select Id, InsertedById  From FeedLikes) From aa_Agent_Report__Feed a where a.Id IN: feedIds];
                  
                   for (aa_Agent_Report__Feed agentfeed :userfeedliketest){
                       for(FeedLike objfeedlike : agentfeed.FeedLikes)
                       {
                                 system.debug('in for of feedlike'+objfeedlike.InsertedById +'===userId'+UserInfo.getUserId());
                                  if(objfeedlike.InsertedById==UserInfo.getUserId() ){
                                    ReportUserLike.put(agentfeed.ParentId,'true');
                                  }/*else{
                                   ReportUserLike.put(agentfeed.ParentId,'false');
                                  }*/
             /*          }
                   }
                   
                   system.debug('Final USer like map %%%%%%%'+ReportUserLike);
                   
                   for(aa_Agent_Report__c item :reportList){
     
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
                    //objGetAllReports.recordType=item.RecordType.Name;
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
                    system.debug(LoggingLevel.INFO,'?retriveAllAgentReports? item.Feeds -- ?'+objGetAllReports.feedList);
                    objGetAllReports.clusterName = item.Country__r.Cluster_Id__r.name;
                    objGetAllReports.clusterId=item.Country__r.Cluster_Id__c;
                    Set<String> imageFilekeyWords = new Set<String>{'.png','.jpg','.jpeg','.bmp'}; // know the image file 
                    Set<String> docFilekeyWords = new Set<String>{'.ppt','.pdf','.xls','.xlsx','.doc','.docx','.csv','.txt'}; // know the image file     
                 
                 
                    for(aa_Agent_Report__Feed objfeed :item.Feeds)
                    {
                       system.debug('feed***********'+objfeed);
                       //get userId foe feed like 
                       objGetAllReports.UserLike=ReportUserLike.get(objGetAllReports.agentReportID);
                      
                    /*  
                        system.debug('if('+objfeed.RelatedRecordId+'=='+item.Id+')');
                      *//*
                        system.debug('item.Chatter_Post_ID__c -- >'+item.Chatter_Post_ID__c+'== objfeed.Id : '+objfeed.Id );
                        if(item.Chatter_Post_ID__c == objfeed.Id)
                        {
                            objGetAllReports.LikeCount=objfeed.LikeCount;
                            objGetAllReports.TotalCommentCount=objfeed.CommentCount;
                            system.debug('Like count ==============================================>'+objfeed.LikeCount);
                        }
                        if(item.Chatter_Post_ID__c == objfeed.Id && objfeed.ContentFileName!=null ){
                            
                            
                            system.debug(' objfeed.ContentFileName ' +objfeed.ContentFileName);
                            String feedFileName = objfeed.ContentFileName;
                            system.debug(' feedFileName ' +feedFileName);
                            List<String> tmpFileNameList = feedFileName.split('\\.');
                            String fileExtension;
                            if(tmpFileNameList.size() > 0){
                                fileExtension = '.'+tmpFileNameList[tmpFileNameList.size() -1];
                            }
                            system.debug(' tmpFileNameList -->'+tmpFileNameList+' fileExtension-- >'+fileExtension);
                            if(imageFilekeyWords.contains(fileExtension)){
                                System.debug('It contains Image!');
                                 objGetAllReports.DocumentUrl = urlHost + sfcURLContent + objfeed.RelatedRecordId;
                                system.debug('tmpList aa report Image one* '+objGetAllReports.agentReportID);
                            }else if(docFilekeyWords.contains(fileExtension)){ /*If perticular file format associated with Chatter Post*/
                  /*              System.debug('It contains file!');
                                if(item.RecordType.Name == 'Unilever Agent Published Report'){
                                    objGetAllReports.DocumentUrl = urlHost + docURLContent + objURL.get('UL Logo Id').Value__c;
                                } else if(item.RecordType.Name == 'Competitor Report'){
                                    objGetAllReports.DocumentUrl = urlHost + docURLContent + objURL.get('CI Logo Id').Value__c;
                                } 
                                system.debug('tmpList aa report Doc  '+objGetAllReports.DocumentUrl);
                            }
                            system.debug('tmpList aa report Doc 099* '+objGetAllReports.agentReportID);
                            system.debug('final like count for report'+objfeed.LikeCount+'final comment count'+objfeed.CommentCount+'sending value==>'+objGetAllReports.TotalCommentCount);
                        }
                    }
                    /*Set UL or CI logo if no Chatter post Id associated with Agent Report */
            /*         if(objGetAllReports.DocumentUrl==null){
                        system.debug('*No File or Image Attached to Report*');
                        if(item.RecordType.Name == 'Unilever Agent Published Report'){
                            objGetAllReports.DocumentUrl = urlHost + docURLContent + objURL.get('UL Logo Id').Value__c;
                        } else if(item.RecordType.Name == 'Competitor Report'){
                            objGetAllReports.DocumentUrl = urlHost + docURLContent + objURL.get('CI Logo Id').Value__c;
                        } 
                    }
                    
                    
                    objFinalReport.add(objGetAllReports);
                    system.debug('tmpList aa report 9************* '+objFinalReport.size());
                    objFinalReport.sort();
             appWrapperObj.objPassAgentReportsToNG = objFinalReport;
             
      String  countquery='SELECT count() FROM aa_Agent_Report__Feed';
        Integer TotalAgentReports=database.countQuery(countquery);
        appWrapperObj.TotalAgentReports=TotalAgentReports; 
        system.debug('total number of rows'+TotalAgentReports);
       //appWrapperObj.TotalAgentReports=9;
        system.debug(LoggingLevel.INFO,'?retriveAllAgentReports?  '+appWrapperObj.objPassAgentReportsToNG);                               
        }
        }catch(DMLException e){
            system.debug(e.getMessage());
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        
        return appWrapperObj;
           }
    */
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
         if(UserPref[0].Is_Accepted_Terms_Condition__c == null || UserPref[0].Is_Accepted_Terms_Condition__c == false){
            appWrapperObj.isAcceptedTermsCondition = false;
         }
         else if (UserPref[0].Is_Accepted_Terms_Condition__c == true){
            appWrapperObj.isAcceptedTermsCondition = UserPref[0].Is_Accepted_Terms_Condition__c;
            UserPref[0].User_Last_Login__c = System.now(); 
            update UserPref; 
         }
         }
        system.debug(appWrapperObj+'============='+appWrapperObj.isAcceptedTermsCondition);
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
               
             system.debug('UserPrefData.UserId__c==========>'+UserPrefData);  
                           
            if(UserPrefData.size() >= 1){
            
                UserPref.Is_Accepted_Terms_Condition__c = true;
                UserPref.UserId__c=UserInfo.getUserId();
                UserPref.Id=UserPrefData[0].Id;
                UserPref.User_Last_Login__c = System.now();
                update UserPref;
                appWrapperObj.isAcceptedTermsCondition = true;
                
            }
            else {
            system.debug('in else******');
                UserPref.UserId__c = UserInfo.getUserId();
                UserPref.Is_Accepted_Terms_Condition__c = true;
                appWrapperObj.isAcceptedTermsCondition = true;
                UserPref.User_Last_Login__c = System.now();
                insert UserPref;
            }
        system.debug(appWrapperObj+'=============updateIsAcceptedTermsAndCondition');
        }
        catch(DMLException e){
            system.debug(e.getMessage());
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        return appWrapperObj;
    }
    
    
    public AA_ApplicationWrapperObj updateLikeCount(AA_ApplicationWrapperObj appWrapperObj){
    
        try{           
            system.debug('In updateLikeCount');
            aa_Agent_Report__c requestAgentDataObj = new aa_Agent_Report__c();
            AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
            objAgentApp = appWrapperObj.objAgentAppDataRequest;
            //requestAgentDataObj=(aa_Agent_Report__c)convertRequestAgentReport(objAgentApp);
            //string postId;
            system.debug('report ID'+appWrapperObj.objAgentAppDataRequest);
            
            List<aa_Agent_Report__c> reportList=[select chatter_post_id__c from aa_Agent_Report__c where Id=:Id.valueOf(objAgentApp.AgentReportId)];
            FeedLike objFeed=New FeedLike(FeedItemId=reportList[0].chatter_post_id__c);
            system.debug('===>'+objFeed);
            insert objFeed;     
            //appWrapperObj.UpdateLikeCount
            
           }
            catch(Exception genEx){
            system.debug(genEx);
        }
        appWrapperObj.UpdateLikeCount = true;
        system.debug('wrapper response from update count:::'+appWrapperObj);
           return appWrapperObj;
    }    
   
    
    
    public AA_ApplicationWrapperObj updateUnlikeCount(AA_ApplicationWrapperObj appWrapperObj){
  
    AA_WrapperUtility.AgentAppDataRequest objAgentApp = new AA_WrapperUtility.AgentAppDataRequest();
    objAgentApp = appWrapperObj.objAgentAppDataRequest;
   system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'+objAgentApp);
    aa_Agent_Report__c report=[select chatter_post_id__c from aa_Agent_Report__c where Id=:Id.valueOf(objAgentApp.AgentReportId)];
   
    aa_Agent_Report__Feed reportfeed=[Select a.LikeCount, a.Id, ParentId,(Select Id, InsertedById From FeedLikes where InsertedById=:UserInfo.getUserId()) From aa_Agent_Report__Feed a where a.Id=:report.chatter_post_id__c];

    List<Feedlike> feedlikelist=reportfeed.Feedlikes;
    system.debug('dsadsfadsf=========>'+feedlikelist);
    
    delete feedlikelist[0];
    // appWrapperObj.UpdateUnlikeCount = true;
    return appWrapperObj;
   }
    
    
}