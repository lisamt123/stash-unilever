public class AA_AgentAppService  {
    //Public AA_WrapperClass.AgentAppDataResponse objGetAgentDataResponse{get;set;}
    //Public AA_WrapperClass.AgentAppDataRequest objAgentAppDataRequest{get;set;}
    //Public AA_WrapperClass.agentReportDetail objPassAgentReportsToNG{get;set;}

   /******************************** New Methods ****************************/
    @AuraEnabled
    public static Boolean getIsAcceptedTermsAndCondition() {
        List<aa_Agent_App_User_Preference__c > UserPref = [SELECT Id,User_Last_Login__c,UserId__c,Is_Accepted_Terms_Condition__c,T_C_AcceptedDate__c FROM aa_Agent_App_User_Preference__c where UserId__c =: UserInfo.getUserId() LIMIT 1];
         if(UserPref.size() >= 1){
             if(!UserPref[0].Is_Accepted_Terms_Condition__c){
                return false;
             }
             else{
                return UserPref[0].Is_Accepted_Terms_Condition__c;
         }
        }
        return false;        
    }
    
    @AuraEnabled
    public static aa_Agent_App_User_Preference__c getUpdateIsAcceptedTermsAndCondition(Boolean isAcceptedTermsCondition){
        aa_Agent_App_User_Preference__c UserPref = new aa_Agent_App_User_Preference__c();
        List<aa_Agent_App_User_Preference__c> UserPrefData = [SELECT Id,User_Last_Login__c,UserId__c,Is_Accepted_Terms_Condition__c,T_C_AcceptedDate__c FROM aa_Agent_App_User_Preference__c where UserId__c =: UserInfo.getUserId() Limit 1];
                       
        if(UserPrefData.size() >= 1){
            UserPref.Is_Accepted_Terms_Condition__c = true;
            UserPref.UserId__c=UserInfo.getUserId();
            UserPref.Id=UserPrefData[0].Id;
            UserPref.User_Last_Login__c = System.now();
            update UserPref;
        }
        else {
            UserPref.UserId__c = UserInfo.getUserId();
            UserPref.Is_Accepted_Terms_Condition__c = true;
            UserPref.User_Last_Login__c = System.now();
            insert UserPref;
        }
        return UserPref;            
    }
    
    @AuraEnabled 
    public static List<aa_Cluster__c> getClusterValues(){
        List<aa_Cluster__c> ClusterNameList = fetchValues('aa_Cluster__c',AA_Constants.ID_NAME);
        return ClusterNameList;
    }    
    
   
    @AuraEnabled
    public static List<aa_Country__c> getCountryValues(){
        List<aa_Country__c> countryNameList = fetchValues('aa_Country__c','id,name,Cluster_Id__r.name,Cluster_Id__c');
        return countryNameList;
    }
    
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
    
   @AuraEnabled
   public static List<String> getReportingOnListValues(){
        Schema.DescribeFieldResult fieldResult;
        fieldResult = aa_Agent_Report__c.Reporting_on__c.getDescribe();
        List<String> reportingOnPickListValues = getPicklistValues(fieldResult);
        return reportingOnPickListValues;
   } 
   
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
    
    @AuraEnabled
    public static AA_ApplicationWrapperObjLtng getRetriveAllAgentReports(String filterType, String sortType, Integer limitRecords, Integer offSet, String applyFilter, String clusterId, String countryId,String unileverBrandId, String retailerId, String reportingOnId,String recordType,String competitorBrandId,String competitorId, String categoryId, String topicId){
        
        system.debug('Request ============>'+filterType+'===='+ sortType+'===CountryId'+ countryId + '===Cluster Id:'+ clusterId);
         
        //String competitorBrandId,String competitorId, String categoryId, String topicId
        AA_WrapperClass.AgentAppDataRequest objAgentAppDataRequest = new  AA_WrapperClass.AgentAppDataRequest();
        AA_WrapperClass.AgentAppDataResponse objAgentAppDataResponse = new AA_WrapperClass.AgentAppDataResponse();
        AA_WrapperClass.agentReportDetail objPassAgentReportsToNG  = new AA_WrapperClass.agentReportDetail();
        
        objAgentAppDataRequest.FilterType = filterType;
        objAgentAppDataRequest.ApplyFilter = applyFilter;
        objAgentAppDataRequest.OffSet= offSet;
        objAgentAppDataRequest.LimitRecords= limitRecords;
        if(countryId !='Select a Country' || countryId != null  ){
            objAgentAppDataRequest.CountryId=countryId;
        }
        
        if(!String.isEmpty(clusterId) && clusterId != 'Select a Cluster' && clusterId != null){
            objAgentAppDataRequest.ClusterId=clusterId;
        }
        
        objAgentAppDataRequest.RecordType=recordType;
        objAgentAppDataRequest.UnileverBrandId= unileverBrandId;
        objAgentAppDataRequest.Retailer=retailerId;
        if(reportingOnId != 'Reporting on' && reportingOnId != null){
            objAgentAppDataRequest.ReportingOn=reportingOnId;
        }
        
        objAgentAppDataRequest.CompetitorBrandId = competitorBrandId;
        if(competitorId != 'Select Competitor Name' && competitorId != null){
            objAgentAppDataRequest.CompetitorId= competitorId;
        }
        
        if(topicId!= 'Select Topic' && topicId!= null){
            objAgentAppDataRequest.TopicId= topicId;
        }
       
        if(categoryId!= 'Select Category' && categoryId != null){
            objAgentAppDataRequest.CategoryId= categoryId;
        }
          
        system.debug('SortType=====>'+ sortType);
        system.debug('applyFilter=====>'+ applyFilter);
        if(sortType == 'ShowLatestFirst'){
            objAgentAppDataRequest.SortOnMostLike = 'false';
        }else if(sortType == 'ShowMostlikedFirst'){
            objAgentAppDataRequest.SortOnMostLike = 'true';
        }
        /*else{
            objAgentAppDataRequest.SortOnMostLike = 'false';
        }*/
        system.debug('Request ============>'+objAgentAppDataRequest);
        
        Map<string,aa_agent_app_custom_setting__c> objURL = aa_agent_app_custom_setting__c.getAll(); 
        String urlHost =  objURL.get('Salesforce Instance URL Content').Value__c;  // Salesforce Instance URL
        String sfcURLContent =  objURL.get('SFC Content').Value__c; // URL for Image population on UI
        String docURLContent =  objURL.get('Document URL Content').Value__c; // URL for Document (Logo) population on UI
        String soqlquery='Select Id,ClusterId__c,ClusterId__r.name,Chatter_Post_ID__c,LastModifiedDate,Agent_App_Unilever_Brand__r.Name, Agent_App_Unilever_Brand__c,Town__c,Retailer__c, Retailer__r.Name, RecordType.Name, Name, Report_Title__c,Report_Description__c,CreatedDate,CreatedBy.SmallPhotoUrl, CreatedBy.Name, Country__c, Country__r.Name, Country__r.Cluster_Id__r.name,Country__r.Cluster_Id__c, Competitor_Name__c,Competitor_Name__r.Name,  Competitor_Brand__c,Competitor_Brand__r.Name,  Category__c, Category__r.Name,  Status__c,(Select Id, CommentCount, LikeCount, CreatedById,RelatedRecordId, ContentFileName From Feeds) From aa_Agent_Report__c where Status__c = \'Published (Public)\' ';
        
        AA_WrapperClass.AgentAppDataRequest objAgentApp = new AA_WrapperClass.AgentAppDataRequest();
        
        objAgentApp = objAgentAppDataRequest;
               
        if(objAgentAppDataRequest!=null){
        
            if(objAgentAppDataRequest.FilterType=='MyReports')
            {
                system.debug('MyReport===>'+objAgentAppDataRequest.FilterType);
                    soqlquery +='AND CreatedById =\''+UserInfo.getUserId()+'\'';  
            }
            if(objAgentAppDataRequest.FilterType=='FilteredReports' )
            {
                system.debug('FilteredReport===>'+objAgentAppDataRequest.FilterType);
                
                aa_Agent_Report__c requestAgentDataObj = new aa_Agent_Report__c();                
                if(objAgentApp.ApplyFilter=='false'){
                    system.debug('Apply Filter ===>'+objAgentApp.ApplyFilter);
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
                    system.debug('#######'+UserPref);
                    /*
                        Each value fetching from database needs to be go thrugh null check before applying it to the current filter i.e. in below query
                        If null check is removed query will fail with exception even if one value is null
                    */   
                    system.debug('UserPreferences' + UserPref );
                    system.debug('Country====>'+ UserPref.Country__c + '====='+ 'Cluster====='+ UserPref.Cluster__c );
                    //if country only selected
                    if(UserPref.Country__c != null && UserPref.Cluster__c == null )
                    {
                        soqlquery +=' AND ( Country__c = '+AA_Constants.Escapechar+UserPref.Country__c+AA_Constants.Escapechar;   
                        // get cluster id for this country
                        aa_Country__c countyclustidlst=[Select  Cluster_Id__c from  aa_Country__c where Id=:UserPref.Country__c];
                        aa_Cluster__c globalclustId=[Select Id from aa_Cluster__c where name='Global' ];
                           
                        soqlquery+= ' OR (ClusterId__c='+AA_Constants.Escapechar+countyclustidlst.Cluster_Id__c+AA_Constants.Escapechar;
                        soqlquery+=' AND country__c=null)';
                        soqlquery+=' OR  ClusterId__c= '+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar+ ' )';
                    } 
                
                    aa_Cluster__c globalclustId=[Select Id from aa_Cluster__c where name='Global' ];
                  
                    //IF cluster is selected and country also selected  
                    if(UserPref.Cluster__c  != null &&  UserPref.Country__c !=null){
                        soqlquery+=' AND (country__c= '+AA_Constants.Escapechar+UserPref.Country__c+AA_Constants.Escapechar;
                        soqlquery+=' OR (ClusterId__c = '+AA_Constants.Escapechar+UserPref.Cluster__c +AA_Constants.Escapechar;
                        soqlquery+=' AND country__c=null)';
                        soqlquery+=' OR ClusterId__c= '+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar+')';
                    } 
                   
                    // IF cluster is selected and country not  selected  
                    if(UserPref.Cluster__c  != null && UserPref.Country__c == null ){
                        //if global only selected
                        if(UserPref.Cluster__c == globalclustId.id)
                        {
                            soqlquery+=' AND ClusterId__c= '+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar;
                        }else{
                            soqlquery+=' AND (ClusterId__c = '+AA_Constants.Escapechar+UserPref.Cluster__c +AA_Constants.Escapechar;
                            soqlquery +=' OR (Country__r.Cluster_Id__c ='+AA_Constants.Escapechar+UserPref.Cluster__c+AA_Constants.Escapechar;
                            soqlquery+=' AND country__c=null)';
                            soqlquery+=' OR ClusterId__c= '+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar+')';
                        }                                                                       
                    }
                    
                    if(UserPref.Agent_App_Unilever_Brand__c!=null)
                    {
                      soqlquery +=' AND Agent_App_Unilever_Brand__c ='+AA_Constants.Escapechar+UserPref.Agent_App_Unilever_Brand__c+AA_Constants.Escapechar;
                    }                
                    if(UserPref.Competitor_Name__c !=null)
                    {
                      soqlquery +=' AND Competitor_Name__c='+AA_Constants.Escapechar+UserPref.Competitor_Name__c+AA_Constants.Escapechar;
                    }                
                    if(UserPref.Competitor_Brand__c !=null)
                    {
                       soqlquery +=' AND Competitor_Brand__c ='+AA_Constants.Escapechar+UserPref.Competitor_Brand__c+AA_Constants.Escapechar;
                    }                
                    if(UserPref.Retailer__c !=null)
                    {
                       soqlquery +=' AND Retailer__c ='+AA_Constants.Escapechar+UserPref.Retailer__c+AA_Constants.Escapechar;
                    }                
                    if(UserPref.Category__c !=null)
                    {
                       soqlquery +=' AND Category__c ='+AA_Constants.Escapechar+UserPref.Category__c+AA_Constants.Escapechar;
                    }  
     
                    if(UserPref.RecordTypeId__c!=null)
                    {
                    soqlquery +=' AND RecordTypeId  = '+AA_Constants.Escapechar+UserPref.RecordTypeId__c+AA_Constants.Escapechar;    
                    }       
                    if(UserPref.Topic__c!=null)
                    {
                        soqlquery +=' AND Topic__c ='+AA_Constants.Escapechar+UserPref.Topic__c+AA_Constants.Escapechar;
                    }
                    if(UserPref.ReportingOn__c!=null)
                    {
                        soqlquery +=' AND Reporting_on__c = '+AA_Constants.Escapechar+UserPref.ReportingOn__c+AA_Constants.Escapechar;
                    }
                }else if(objAgentAppDataRequest.ApplyFilter=='true') { 
                    system.debug('Filtered Report====>'+objAgentAppDataRequest.ApplyFilter);
                    requestAgentDataObj= convertRequestAgentReport(objAgentApp);
                    
                    //if country only selected
                    if(requestAgentDataObj.country__c != null && requestAgentDataObj.ClusterId__c == null)
                    {
                        soqlquery +=' AND ( Country__c = '+AA_Constants.Escapechar+requestAgentDataObj.country__c+AA_Constants.Escapechar;   
                        // get cluster id for this country
                        aa_Country__c countyclustidlst=[Select  Cluster_Id__c from  aa_Country__c where Id=:requestAgentDataObj.country__c];
                        aa_Cluster__c globalclustId=[Select Id from aa_Cluster__c where name='Global'];
                        soqlquery+= ' OR  (ClusterId__c ='+AA_Constants.Escapechar+countyclustidlst.Cluster_Id__c+AA_Constants.Escapechar;
                        soqlquery+=' AND country__c=null)';
                        soqlquery+=' OR  ClusterId__c='+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar+ ')';
                    }
                    
                    aa_Cluster__c globalclustId=[Select Id from aa_Cluster__c where name='Global' ];
                    //IF cluster is selected and country also selected
                    if(requestAgentDataObj.ClusterId__c != null &&  requestAgentDataObj.country__c != null){
                        soqlquery+=' AND (country__c= '+AA_Constants.Escapechar+requestAgentDataObj.country__c+AA_Constants.Escapechar;
                        soqlquery+=' OR (ClusterId__c = '+AA_Constants.Escapechar+requestAgentDataObj.ClusterId__c+AA_Constants.Escapechar;
                        soqlquery+=' AND country__c= null)';
                        soqlquery+=' OR ClusterId__c= '+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar+')';
                    }
                    
                    // IF cluster is selected and country not  selected
                    if(requestAgentDataObj.ClusterId__c != null && requestAgentDataObj.Country__c == null){
                        //if global only selected
                        if(requestAgentDataObj.ClusterId__c==globalclustId.id){
                            soqlquery+=' AND ClusterId__c= '+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar;
                        }else{                        
                            soqlquery+=' AND (ClusterId__c = '+AA_Constants.Escapechar+requestAgentDataObj.ClusterId__c+AA_Constants.Escapechar;
                            soqlquery+=' OR (ClusterId__c = '+AA_Constants.Escapechar+requestAgentDataObj.ClusterId__c+AA_Constants.Escapechar;
                            soqlquery+=' AND country__c=null)';
                            soqlquery+='OR ClusterId__c= '+AA_Constants.Escapechar+globalclustId.id+AA_Constants.Escapechar+')';
                        }
                    }
                    if(requestAgentDataObj.Agent_App_Unilever_Brand__c != null)
                    {
                      soqlquery +='AND Agent_App_Unilever_Brand__c ='+AA_Constants.Escapechar+requestAgentDataObj.Agent_App_Unilever_Brand__c +AA_Constants.Escapechar;
                    }                
                    if(requestAgentDataObj.Competitor_Name__c != null)
                    {
                      soqlquery +='AND Competitor_Name__c= '+AA_Constants.Escapechar+requestAgentDataObj.Competitor_Name__c +AA_Constants.Escapechar;
                    }                
                    if(requestAgentDataObj.Competitor_Brand__c != null)
                    {
                       soqlquery +='AND Competitor_Brand__c = '+AA_Constants.Escapechar+ requestAgentDataObj.Competitor_Brand__c+AA_Constants.Escapechar;
                    }                
                    if(requestAgentDataObj.Retailer__c !=null)
                    {
                       soqlquery +='AND Retailer__c = '+AA_Constants.Escapechar+requestAgentDataObj.Retailer__c+AA_Constants.Escapechar;
                    }                
                    if(requestAgentDataObj.Category__c !=null)
                    {
                       soqlquery +='AND Category__c = '+AA_Constants.Escapechar+requestAgentDataObj.Category__c+AA_Constants.Escapechar;
                    }                
                    /* if(appWrapperObj.objAgentAppDataRequest.ClusterId!=NULL)
                    {
                       soqlquery +='AND Country__r.Cluster_Id__c ='+AA_Constants.Escapechar+appWrapperObj.objAgentAppDataRequest.ClusterId+AA_Constants.Escapechar;
                    }*/
                    if(objAgentAppDataRequest.TopicId!=null)
                    {
                        soqlquery +='AND Topic__c ='+AA_Constants.Escapechar+objAgentAppDataRequest.TopicId+AA_Constants.Escapechar;
                    }
                    if(objAgentAppDataRequest.ReportingOn!=null)
                    {
                        soqlquery +='AND Reporting_on__c ='+AA_Constants.Escapechar+objAgentAppDataRequest.ReportingOn+AA_Constants.Escapechar;
                    }
                    String recTypeId='';
                    if(objAgentAppDataRequest.RecordType=='Unilever')
                    {
                        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
                        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
                        recTypeId = (RT.get('Unilever Agent Published Report')).getRecordTypeId();
                        soqlquery +='AND RecordTypeId  = '+AA_Constants.Escapechar+recTypeId+AA_Constants.Escapechar;
                    }            
                    if(objAgentAppDataRequest.RecordType=='Competitor')
                    {
                        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
                        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
                        recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
                        soqlquery +='AND RecordTypeId  = '+AA_Constants.Escapechar+recTypeId+AA_Constants.Escapechar;
                    }
                    
                    aa_Agent_App_User_Preference__c userPref = [SELECT Id,UserId__c 
                                                               FROM aa_Agent_App_User_Preference__c              
                                                              Where UserId__c =: UserInfo.getUserId()];      
                    userPref.Category__c=requestAgentDataObj.Category__c;
                    if(requestAgentDataObj.Country__c!= null || requestAgentDataObj.Country__c != 'null'){
                        userPref.Country__c=requestAgentDataObj.Country__c;
                    }
                    userPref.Competitor_Brand__c=requestAgentDataObj.Competitor_Brand__c;
                    userPref.Competitor_Name__c=requestAgentDataObj.Competitor_Name__c;
                    userPref.Retailer__c=requestAgentDataObj.Retailer__c;
                    userPref.Agent_App_Unilever_Brand__c=requestAgentDataObj.Agent_App_Unilever_Brand__c;
                    // if(appWrapperObj.objAgentAppDataRequest.ClusterId!=null || appWrapperObj.objAgentAppDataRequest.ClusterId!='null')
                    //if(!String.isEmpty(objAgentAppDataRequest.ClusterId)){
                    if(!String.isEmpty(objAgentAppDataRequest.ClusterId) && objAgentAppDataRequest.ClusterId != null && objAgentAppDataRequest.ClusterId != 'null'){
                        userPref.Cluster__c=objAgentAppDataRequest.ClusterId;
                    }else{
                        userPref.Cluster__c=null;
                    }
                    userPref.RecordTypeId__c=recTypeId;
                    userPref.Topic__c=objAgentAppDataRequest.TopicId;
                    userPref.ReportingOn__c=objAgentAppDataRequest.ReportingOn;
                    
                    system.debug('UserPreferences========>'+userPref );
                    update userPref;
                }
            }
            if(objAgentApp.SortOnMostLike!='true'){
                soqlquery +=' Order by LastModifiedDate desc';
            }else if(objAgentApp.SortOnMostLike=='true'){
                String  soqlFeedQuery='SELECT Id,likecount FROM aa_Agent_Report__Feed order by likecount desc limit 1000'; //+ ' OFFSET '+ objAgentAppDataRequest.OffSet;
                List<aa_Agent_Report__Feed> feedlist=  database.query(soqlFeedQuery);             
                set<ID>idlist=new set<ID>();            
                String reportidInString='( ';           
                for(aa_Agent_Report__Feed item:feedlist)
                {
                    idlist.add(String.valueOf(item.id));
                    reportidInString+='\''+item.id+'\',';
                }
           
                reportidInString+='\'\' )';
                soqlquery +=' AND chatter_post_id__c IN   '+ reportidInString; 
            }
            if(objAgentAppDataRequest.LimitRecords!=null && objAgentAppDataRequest.OffSet!=null &&(objAgentApp.SortOnMostLike!='true' || objAgentApp.SortOnMostLike==NULL)  )
            {
               soqlquery +=' LIMIT '+ objAgentAppDataRequest.LimitRecords + ' OFFSET '+objAgentAppDataRequest.OffSet;
            }else
               soqlquery +='  LIMIT 1000';
       }else
           soqlquery +='  LIMIT 1000';
        
        
        system.debug('SQL Query==============>'+ soqlquery);        
        List <aa_Agent_Report__c> tmpList=  database.query(soqlquery); 

        List<AA_WrapperClass.agentReportDetail> objFinalReport = new List<AA_WrapperClass.agentReportDetail>();        
        // To check whether current user has liked report or not 
       Set<ID> feedIds=new Set<ID>();
       for(aa_Agent_Report__c itemfeedlike :tmpList){
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
        system.debug(tmpList);
       for(aa_Agent_Report__c item : tmpList)
        {
           AA_WrapperClass.agentReportDetail objGetAllReports = new AA_WrapperClass.agentReportDetail();
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
            
            if(item.Country__c != null){
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
        if(objAgentApp.SortOnMostLike =='true'){
            objFinalReport.sort();    
                       
             Integer i=0; 
             Integer totallimit=Integer.valueOf(objAgentAppDataRequest.OffSet)+Integer.valueOf(objAgentAppDataRequest.LimitRecords);                       
             List<AA_WrapperClass.agentReportDetail> objFinalReportForSort = new List<AA_WrapperClass.agentReportDetail>();           
             Integer counter = Integer.valueOf(objAgentAppDataRequest.OffSet);             
             if(totallimit > objFinalReport.size())
                 totallimit=objFinalReport.size();         
             while(counter >= Integer.valueOf(objAgentAppDataRequest.OffSet) && counter < totallimit) {
                objFinalReportForSort.add(objFinalReport[counter++]);
             }
             objFinalReport=objFinalReportForSort;                  
        }   
        
       AA_ApplicationWrapperObjLtng objRep = new AA_ApplicationWrapperObjLtng();
       objRep.objAgentReportsData = objFinalReport;
        //To send total number of reports        
        List<String> arr=soqlquery.split( 'where');
        string finalstr=arr[1].SubstringBefore('Order by');
        finalstr=finalstr.SubstringBefore('LIMIT');   
    
        String countquery='Select count() From aa_Agent_Report__c a where '+finalstr;   
        Integer TotalAgentReports=database.countQuery(countquery);
        objRep.TotalAgentReportsCount=TotalAgentReports;                    
    
        return objRep;
    
    }
    
    public static List<aa_Agent_App_Competitor_Brand__c> getUnileverListValues(){
        List<aa_Agent_App_Competitor_Brand__c > agentUnileverBrandList = fetchValuesByRecordType('aa_Agent_App_Competitor_Brand__c',AA_Constants.ID_NAME,'Unilever Brand');     
        return agentUnileverBrandList;
        
    }
    
    public static List<Sobject> fetchValuesByRecordType(String SobjectApiName,String commaSepratedFields, String recType){
        
        List<Sobject> result=new List<Sobject>();
        String query;
         if(!Utility.isEmpty(SobjectApiName) && !Utility.isEmpty(commaSepratedFields)){
            
            query = 'select ' + commaSepratedFields + ' from ' + SobjectApiName + ' where RecordType.Name=\''+recType+'\'';
            result = Database.query(query);
         }
       return result;
    }
    
    public static List<aa_Agent_Retailer__c>  getRetailerListValues(){
        List<aa_Agent_Retailer__c> agentRetailerList = fetchValues('aa_Agent_Retailer__c',AA_Constants.ID_NAME);  
        return agentRetailerList;
    }
    
    @AuraEnabled
    public static AA_WrapperClass.AgentAppDataResponse getAutoPopulatedValues_UnileverReport(){
        AA_WrapperClass.AgentAppDataResponse wrapperUtilityObj = new AA_WrapperClass.AgentAppDataResponse();  
        List <aa_Cluster__c> clusterValuesList= getClusterValues();
        wrapperUtilityObj.clusterList = new List<aa_Cluster__c>();
        wrapperUtilityObj.clusterList = clusterValuesList;
      
        List<aa_Country__c>  countryValuesList = getCountryValues();
        wrapperUtilityObj.countryList = new List<aa_Country__c>();
        wrapperUtilityObj.countryList = countryValuesList;  
        
        //Reporting On Values
        List<String> reportingOnPickList = new List<String>();
        reportingOnPickList = getReportingOnListValues();
        wrapperUtilityObj.reportingOnPicklistValues = new List<String>();
        wrapperUtilityObj.reportingOnPicklistValues = reportingOnPickList;
        
        //Retailer Values
        List<aa_Agent_Retailer__c>  agentRetailerList = getRetailerListValues();
        wrapperUtilityObj.unileverRetailerList = new List<aa_Agent_Retailer__c>();
        wrapperUtilityObj.unileverRetailerList = agentRetailerList;
        
        List<aa_Agent_App_Competitor_Brand__c> agentUnileverBrandList = getUnileverListValues();
        wrapperUtilityObj.unileverBrandList = new List<aa_Agent_App_Competitor_Brand__c >();
        wrapperUtilityObj.unileverBrandList = agentUnileverBrandList;    
        return wrapperUtilityObj ;
    }
    
   
    public static List<String> getSourceListValues(){
        Schema.DescribeFieldResult fieldResult;
        fieldResult = aa_Agent_Report__c.Source__c.getDescribe();
        List<String> sourcePickListValues = getPicklistValues(fieldResult);
        return sourcePickListValues;
   }
   
    public static List<aa_Topic__c> getTopicListValues(){
        List<aa_Topic__c> agentTopicList = fetchValues('aa_Topic__c','id,name,Sub_Topic__c,Topic_Order__c');     
        return agentTopicList;
        
    }
    
    public static List<aa_Agent_App_Competitor_Brand__c>  getCompetitorBrandListValues(){
        List<aa_Agent_App_Competitor_Brand__c> agentCompetitorBrandList = fetchValuesByRecordType('aa_Agent_App_Competitor_Brand__c',AA_Constants.ID_NAME,'Competitor Brand');  
        return agentCompetitorBrandList;
    }
    public static List<aa_Agent_Competitor__c>  getCompetitorNameListValues(){
        List<aa_Agent_Competitor__c> agentCompetitorNameList = fetchValues('aa_Agent_Competitor__c',AA_Constants.ID_NAME);  
        return agentCompetitorNameList;
    }
    public static List<aa_Agent_App_Category__c>  getCompetitorCategoryListValues(){
        List<aa_Agent_App_Category__c> agentCompetitorCategoryList = fetchValues('aa_Agent_App_Category__c',AA_Constants.ID_NAME);  
        return agentCompetitorCategoryList;
    }
    
    @AuraEnabled
    public static AA_WrapperClass.AgentAppDataResponse getSourceRetailerTopicCountry_CompetitorReport(){
    
        AA_WrapperClass.AgentAppDataResponse wrapperUtilityObj = new AA_WrapperClass.AgentAppDataResponse();    
        //Retailer Values
        List<aa_Agent_Retailer__c>  agentRetailerList = getRetailerListValues();
        wrapperUtilityObj.unileverRetailerList = new List<aa_Agent_Retailer__c>();
        wrapperUtilityObj.unileverRetailerList = agentRetailerList;
        //appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Source Values
        List<String> sourcePickList = new List<String>();
        sourcePickList = getSourceListValues();
        wrapperUtilityObj.sourcePicklistValues = new List<String>();
        wrapperUtilityObj.sourcePicklistValues = sourcePickList;
        //appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Topic Values 
        List<aa_Topic__c>  topicValuesList = getTopicListValues();
        wrapperUtilityObj.topicList = new List<aa_Topic__c>();
        wrapperUtilityObj.topicList = topicValuesList;
        //appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
                
        //Country List Values 
        List<aa_Country__c>  countryValuesList = getCountryValues();
        wrapperUtilityObj.countryList = new List<aa_Country__c>();
        wrapperUtilityObj.countryList = countryValuesList;
        //appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Competitor Brand List Values 
        List<aa_Agent_App_Competitor_Brand__c>  objCompetitorBrandList = getCompetitorBrandListValues();
        wrapperUtilityObj.competitorBrandList = new List<aa_Agent_App_Competitor_Brand__c>();
        wrapperUtilityObj.competitorBrandList = objCompetitorBrandList;
        //appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Competitor Name List Values 
        List<aa_Agent_Competitor__c>  objCompetitorNameList = getCompetitorNameListValues();
        wrapperUtilityObj.competitorNameList = new List<aa_Agent_Competitor__c>();
        wrapperUtilityObj.competitorNameList = objCompetitorNameList;
        //appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        //Category Name List Values 
        List<aa_Agent_App_Category__c>  objCategoryNameList = getCompetitorCategoryListValues();
        wrapperUtilityObj.categoryList = new List<aa_Agent_App_Category__c>();
        wrapperUtilityObj.categoryList = objCategoryNameList;
        //appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
         //Cluster List Values
        List <aa_Cluster__c> clusterValuesList= getClusterValues();
        wrapperUtilityObj.clusterList = new List<aa_Cluster__c>();
        wrapperUtilityObj.clusterList = clusterValuesList;
        //appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
        
        Map<string,aa_agent_app_custom_setting__c> objURL = aa_agent_app_custom_setting__c.getAll(); 
        //appWrapperObj.objGetAgentDataResponse = wrapperUtilityObj;
       
        return wrapperUtilityObj;
    }
    
    @AuraEnabled
    public static List<aa_Agent_App_Brand_Category__c> getCompetitorCategory (String competitorBrand)
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
    
    @AuraEnabled
    public static aa_Agent_Report__c convertRequestAgentReport(AA_WrapperClass.AgentAppDataRequest objAgentApp){
        string userids='';
        string topicids='';        
        aa_Agent_Report__c newObjToBeInserted = new aa_Agent_Report__c();
        /*if(!String.isEmpty(objAgentApp.CountryId)){
            newObjToBeInserted.Country__c = objAgentApp.CountryId;
        } */
        if(!String.isEmpty(objAgentApp.CountryId) && objAgentApp.CountryId != 'null' && objAgentApp.CountryId != 'Select a Country'){
            newObjToBeInserted.Country__c = objAgentApp.CountryId;
        }
   
        newObjToBeInserted.Report_Title__c = objAgentApp.ReportName ;
        newObjToBeInserted.Agent_App_Unilever_Brand__c  = objAgentApp.UnileverBrandId;
        newObjToBeInserted.Report_Description__c = objAgentApp.ReportDesc ;
        newObjToBeInserted.Retailer__c  = objAgentApp.Retailer;
        newObjToBeInserted.Reporting_on__c = objAgentApp.ReportingOn;
        
        newObjToBeInserted.Town__c = objAgentApp.Town;
        newObjToBeInserted.longitude__c = objAgentApp.Longitude;
        newObjToBeInserted.latitude__c = objAgentApp.Latitude;
        newObjToBeInserted.Category__c = objAgentApp.CategoryId ;
        newObjToBeInserted.Competitor_Name__c = objAgentApp.CompetitorId ;
        newObjToBeInserted.Competitor_Brand__c = objAgentApp.CompetitorBrandId ;
        //Adding userids  to be mentioned in the feed and topics names  to be inserted
    
        if(objAgentApp.usertomentionIds != null && objAgentApp.usertomentionIds.size()>0){
            for(string str:objAgentApp.usertomentionIds)
            {
              userids=userids+str+',';
              
            }
            userids=userids.removeEnd(',');
            newObjToBeInserted.TF_Mention_User__c=userids;
        } 
        
        /* if(objAgentApp!=null && objAgentApp.topicIds!=null){
        for(string str:objAgentApp.topicIds)
        {
          topicids=topicids+str+',';
          
        }
        topicids=topicids.removeEnd(',');
        newObjToBeInserted.TF_Topic_Name__c=topicids;
        } */

        //Adding cluster
        if(!String.isEmpty(objAgentApp.ClusterId) && (objAgentApp.ClusterId != 'Select a Cluster') && (objAgentApp.ClusterId != 'null')){
            newObjToBeInserted.ClusterId__c= objAgentApp.ClusterId;
        }
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Unilever Agent Published Report')).getRecordTypeId();
        newObjToBeInserted.RecordTypeId = recTypeId;
           
        return newObjToBeInserted;
    }
    
    
   
    /*@AuraEnabled
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) { 
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion v = new ContentVersion();
        Blob b = Blob.valueOf(base64Data);
        v.versionData = b;
        v.title = 'from VF';
        v.pathOnClient ='/foo.txt';
        insert v;
       
        return v.Id;

    }*/
    @AuraEnabled
        public static Boolean getupdateLikeCount(String AgentReportId){
    
        try{           
            system.debug('ID===>'+AgentReportId);
           // aa_Agent_Report__c requestAgentDataObj = new aa_Agent_Report__c();
           // AA_WrapperClass.AgentAppDataRequest objAgentApp = new AA_WrapperClass.AgentAppDataRequest();
            //objAgentApp = appWrapperObj.objAgentAppDataRequest;
            
            List<aa_Agent_Report__c> reportList=[select chatter_post_id__c from aa_Agent_Report__c where Id=:Id.valueOf(AgentReportId)];
            FeedLike objFeed=New FeedLike(FeedItemId=reportList[0].chatter_post_id__c);
            
            insert objFeed;     
                       
           }
            catch(DMLException genEx){
            system.debug(genEx.getMessage());
        }
        //appWrapperObj.UpdateLikeCount = true;
        return true;
    }    
   
   @AuraEnabled
    public static Boolean getupdateUnlikeCount(String AgentReportId){
    system.debug('ID===>'+AgentReportId);
   // AA_WrapperClass.AgentAppDataRequest objAgentApp = new AA_WrapperClass.AgentAppDataRequest();
   // objAgentApp = appWrapperObj.objAgentAppDataRequest;

    aa_Agent_Report__c report=[select chatter_post_id__c from aa_Agent_Report__c where Id=:Id.valueOf(AgentReportId)];
   
    aa_Agent_Report__Feed reportfeed=[Select a.LikeCount, a.Id, ParentId,(Select Id, InsertedById From FeedLikes where InsertedById=:UserInfo.getUserId()) From aa_Agent_Report__Feed a where a.Id=:report.chatter_post_id__c];

    List<Feedlike> feedlikelist=reportfeed.Feedlikes;
    
    delete feedlikelist[0];
    return false;
   }

    @AuraEnabled
    public static Id getGlobalClusterId(){
        system.debug('Inside get Gloval==========>');
         aa_Cluster__c globalCluster=[Select Id from aa_Cluster__c where name='Global'];
        system.debug('Inside get Gloval==========>'+globalCluster.Id);
         return globalCluster.Id;
    
    } 
       
    /*@AuraEnabled
    public static AA_ApplicationWrapperObjLtng insertAgentApp_Competitor(AA_ApplicationWrapperObjLtng appWrapperObj){
 
            AA_WrapperClass.AgentAppDataRequest objAgentApp = new AA_WrapperClass.AgentAppDataRequest();
            objAgentApp = appWrapperObj.objAgentAppDataRequest;
            list<String> agentAPPIDInserted = AA_DatabaseServiceUtil.upsertOperation(convertRequestAgentReport_Competitor(objAgentApp));
            list<String> agentAPPDocumentIDInserted = AA_DatabaseServiceUtil.insertOperation(agentAPPIDInserted[0], objAgentApp.ContentDocumentId);
            appWrapperObj.message = System.Label.AA_Agent_Report_Success;
            AA_WrapperClass.AgentAppDataResponse objResponse = new AA_WrapperClass.AgentAppDataResponse();
            objResponse.agentReportId = agentAPPIDInserted[0];
            appWrapperObj.objGetAgentDataResponse  =  objResponse;
            
            
        return appWrapperObj;
    }*/
    
    @AuraEnabled
     public static AA_ApplicationWrapperObjLtng insertAgentApp(String clusterId,String countryId,String town, String reportName, String reportDescription,
     List<String> userIds ,String unileverBrandId, String retailerId, String reportingOnId,String recordType, String status,String contentId){
        System.debug('Inside Insert Agent App');
         AA_ApplicationWrapperObjLtng appWrapperObj = new AA_ApplicationWrapperObjLtng();
         try{
            AA_WrapperClass.AgentAppDataRequest objAgentApp = new  AA_WrapperClass.AgentAppDataRequest();
            objAgentApp.ClusterId = clusterId;
            objAgentApp.CountryId = countryId;
            objAgentApp.Town= town;
            objAgentApp.ReportName= reportName;
            objAgentApp.ReportDesc=reportDescription;
            objAgentApp.usertomentionIds= userIds;
            objAgentApp.UnileverBrandId=unileverBrandId;
            objAgentApp.Retailer=retailerId;
            objAgentApp.ReportingOn=reportingOnId;
            objAgentApp.RecordType=recordType;
            objAgentApp.Status= status;
            system.debug('Content Document Id=====>' + contentId);
            objAgentApp.ContentDocumentId = contentId;
            system.debug('AFter set Document Id=====>' + objAgentApp.ContentDocumentId);            
            appWrapperObj.objAgentAppDataRequest  = objAgentApp;
            list<String> agentAPPIDInserted = AA_DatabaseServiceUtil.upsertOperation(convertRequestAgentReport(objAgentApp));
            system.debug('Document Id=====>'+objAgentApp.ContentDocumentId);
            list<String> agentAPPDocumentIDInserted = AA_DatabaseServiceUtil.insertOperation(agentAPPIDInserted[0], objAgentApp.ContentDocumentId);
            appWrapperObj.message = System.Label.AA_Agent_Report_Success;
            AA_WrapperClass.AgentAppDataResponse objResponse = new AA_WrapperClass.AgentAppDataResponse();
            objResponse.agentReportId = agentAPPIDInserted[0];
            appWrapperObj.objGetAgentDataResponse  =  objResponse;
         }catch(System.DmlException exceptiondml){
             System.debug('Exception in DML:' + exceptiondml.getMessage());
        }
        return appWrapperObj;
    }
    
    
    @AuraEnabled 
    public static ContentVersion uploadNewFile(String fileName, String base64Data, String contentType, String subjectId, String textToPost){
    system.debug('File Upload ======>'+ fileName);
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion newContentVersion = new ContentVersion();
        // see https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_contentversion.htm
        newContentVersion.Title = fileName;
        newContentVersion.PathOnClient = fileName;
        newContentVersion.VersionData = EncodingUtil.base64Decode(base64Data);
        newContentVersion.Origin = 'H'; 
        insert newContentVersion;
        ContentVersion c = [Select Id, ContentDocumentId from ContentVersion where id =: newContentVersion.Id LIMIT 1]; 
            system.debug('Content Id ======>'+ c.ContentDocumentId);
            return c;
        //  postFeedElementWithExistingFile(subjectId,textToPost,c.ContentDocumentId);
    } 
    
     @AuraEnabled
    public static Id getOtherCompetitorBrandId(){
         aa_Agent_App_Competitor_Brand__c otherCompetitorBrandId=[Select Id from aa_Agent_App_Competitor_Brand__c where name='Other'];
         return otherCompetitorBrandId.Id;
    
    } 
       
    @AuraEnabled
    public static AA_ApplicationWrapperObjLtng insertAgentApp_Competitor(String clusterId,String countryId,String town, String reportName, String reportDescription,
     List<String> userIds ,String source,String competitorBrandId,String otherBrandName,String otherCompetitor ,String competitorId,String categoryId,String retailer, String topicId,String subTopic ,String recordType, String status,String contentId){
            
            AA_ApplicationWrapperObjLtng appWrapperObj= new AA_ApplicationWrapperObjLtng();
        try{
            AA_WrapperClass.AgentAppDataRequest objAgentApp = new  AA_WrapperClass.AgentAppDataRequest();
            
            objAgentApp.ClusterId = clusterId;
            objAgentApp.CountryId = countryId;
            objAgentApp.Town= town;
            objAgentApp.ReportName= reportName;
            objAgentApp.ReportDesc=reportDescription;
            objAgentApp.usertomentionIds= userIds;
            objAgentApp.Source=source;
            objAgentApp.CompetitorBrandId=competitorBrandId;
            objAgentApp.CompetitorId=competitorId;
            objAgentApp.CategoryId=categoryId;
            objAgentApp.Retailer=retailer;
            objAgentApp.TopicId=topicId;
            objAgentApp.SubTopic=subTopic;
            objAgentApp.RecordType=recordType;
            objAgentApp.Status= status;
            objAgentApp.OtherBrandName= otherBrandName;
            objAgentApp.OtherCompetitor= otherCompetitor;
            objAgentApp.ContentDocumentId = contentId;
             
            appWrapperObj.objAgentAppDataRequest  = objAgentApp;
            List<String> agentAPPIDInserted = AA_DatabaseServiceUtil.upsertOperation(convertRequestAgentReport_Competitor(objAgentApp));
            list<String> agentAPPDocumentIDInserted = AA_DatabaseServiceUtil.insertOperation(agentAPPIDInserted[0], objAgentApp.ContentDocumentId);
            appWrapperObj.message = System.Label.AA_Agent_Report_Success;
            AA_WrapperClass.AgentAppDataResponse objResponse = new AA_WrapperClass.AgentAppDataResponse();
            objResponse.agentReportId = agentAPPIDInserted[0];
            appWrapperObj.objGetAgentDataResponse  =  objResponse;
        } catch(System.DmlException exceptiondml){
             System.debug('Exception in DML:' + exceptiondml.getMessage());
        }
        return appWrapperObj;
    }
    
    @AuraEnabled
    public Static aa_Agent_Report__c convertRequestAgentReport_Competitor(AA_WrapperClass.AgentAppDataRequest objAgentApp){
        string userids='';
        string topicids='';
        aa_Agent_Report__c newObjToBeInserted = new aa_Agent_Report__c();
              newObjToBeInserted.Report_Title__c = objAgentApp.ReportName ;
              //objAgentApp.ReportName = 'reportTitle';
              newObjToBeInserted.Report_Description__c = objAgentApp.ReportDesc ;
              //objAgentApp.ReportDesc = 'ReportDescription';
    
        if(!String.isEmpty(objAgentApp.Source)){
            newObjToBeInserted.Source__c  = objAgentApp.Source;
            //objAgentApp.Source = 'Source';
        }
            newObjToBeInserted.Retailer__c  = objAgentApp.Retailer;
           // objAgentApp.Retailer = 'Retailer';
            newObjToBeInserted.Competitor_Brand__c  = objAgentApp.CompetitorBrandId;
        //objAgentApp.CompetitorBrandId = 'CompetitorBrand';
        
            newObjToBeInserted.Competitor_Name__c  = objAgentApp.CompetitorId;
            //objAgentApp.CompetitorId = 'CompetitorName';
        
        if(!String.isEmpty(objAgentApp.CategoryId)){
            newObjToBeInserted.Category__c  = objAgentApp.CategoryId;
            //objAgentApp.CategoryId = 'Category';
        }
       if(!String.isEmpty(objAgentApp.TopicId)){
            newObjToBeInserted.Topic__c  = objAgentApp.TopicId;
           //objAgentApp.TopicId = 'Topic';
            if(!String.isEmpty(objAgentApp.SubTopic)){
                newObjToBeInserted.Sub_Topics__c  = objAgentApp.SubTopic;
                //objAgentApp.SubTopic = 'SubTopic';
            }
            
        }   
        
         if(!String.isEmpty(objAgentApp.CountryId)) {
                newObjToBeInserted.Country__c = objAgentApp.CountryId;
             //objAgentApp.CountryId  = 'countryId';
          }
            
            newObjToBeInserted.Town__c = objAgentApp.Town;
            //objAgentApp.Town = 'townId';
            newObjToBeInserted.longitude__c = objAgentApp.Longitude;
            //objAgentApp.Longitude = '';
            newObjToBeInserted.latitude__c = objAgentApp.Latitude;
            //objAgentApp.Latitude ='';
        
        if(!String.isEmpty(objAgentApp.CodeOfConduct)){
            if(objAgentApp.CodeOfConduct == 'true'){
                newObjToBeInserted.Is_Accepted_Code_of_Conduct__c = true;    
            }else if(objAgentApp.CodeOfConduct == 'false'){
                newObjToBeInserted.Is_Accepted_Code_of_Conduct__c = false;    
            }          
        }      
       
        //Adding New Brand Fields 
        newObjToBeInserted.OtherBrandName__c=objAgentApp.OtherBrandName;
        //objAgentApp.OtherBrandName = '';
        newObjToBeInserted.OtherCompanyName__c=objAgentApp.OtherCompetitor;
        //objAgentApp.OtherCompetitor = '';
        
        //Adding userids  to be mentioned in the feed and topics names  to be inserted
        //objAgentApp.usertomentionIds = 'AddNotifyUser';
        if(objAgentApp.usertomentionIds.size()>0){
       
        for(string str:objAgentApp.usertomentionIds)
        {
          userids=userids+str+',';
          
        }       
        userids=userids.removeEnd(',');
        newObjToBeInserted.TF_Mention_User__c=userids;
        }
        
       /* for(string str:objAgentApp.topicIds)
        {
          topicids=topicids+str+',';
          
        }
         
          topicids=topicids.removeEnd(',');
        
        newObjToBeInserted.TF_Topic_Name__c=topicids; */
        
        //Adding cluster
        
         
         if(!String.isEmpty(objAgentApp.ClusterId)) {
         
          newObjToBeInserted.ClusterId__c=objAgentApp.ClusterId;
             //objAgentApp.ClusterId = 'clusterId';
         }
        
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id recTypeId = (RT.get('Competitor Report')).getRecordTypeId();
        newObjToBeInserted.RecordTypeId = recTypeId;    
        return newObjToBeInserted;
    } 
    
     /*public static Id saveTheFile(String fileName, String base64Data, String contentType){
    system.debug('File Upload ======>'+ fileName);
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion newContentVersion = new ContentVersion();
        newContentVersion.Title = fileName;
        newContentVersion.PathOnClient = fileName;
        newContentVersion.VersionData = EncodingUtil.base64Decode(base64Data);
        newContentVersion.Origin = 'H'; 
        insert newContentVersion;
        ContentVersion c = [Select Id, ContentDocumentId from ContentVersion where id =: newContentVersion.Id LIMIT 1]; 
            system.debug('Content Id ======>'+ c.ContentDocumentId);
            return newContentVersion.Id;
        //  postFeedElementWithExistingFile(subjectId,textToPost,c.ContentDocumentId);
    }*/ 
    
   /* @AuraEnabled
    public static Id saveTheChunk(String fileName, String base64Data, String contentType, String fileId) { 
        if (fileId == '') {
            fileId = saveTheFile(fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }*/
    
    /*@AuraEnabled 
    public static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion a = [Select Id, ContentDocumentId,VersionData from ContentVersion where id =: fileId];
        String existingBody = EncodingUtil.base64Encode(a.VersionData);
        a.VersionData= EncodingUtil.base64Decode(existingBody + base64Data); 
        
        String existingBody = String.valueof(a.VersionData);
        system.debug('Existing Body =========>'+ existingBody);
        
        system.debug('Append Body =========>'+ base64Data);
        
        a.VersionData = Blob.valueof(existingBody+base64Data);
        system.debug('Blob Body =========>'+ Blob.valueof(existingBody+base64Data));
        
        
        system.debug('Blob Body =========>'+ a.VersionData);
        
       // a.IsMajorVersion = false;
        update a;
        
    }*/
    
    @AuraEnabled
    public static String getBrandName(String brandId){
        aa_Agent_App_Competitor_Brand__c brand =[Select Id,Name from aa_Agent_App_Competitor_Brand__c where Id= :brandId];
        system.debug('Competitor name==>>>'+brand.Name);
        return brand.Name;
        
    } 
     @AuraEnabled
    public static String getRetailerName(String retailerId){
        aa_Agent_Retailer__c retailer =[Select Id,Name from aa_Agent_Retailer__c where Id= :retailerId];
        system.debug('retailer name==>>>'+retailer.Name);
        return retailer.Name;
    } 

     @AuraEnabled
    public static AA_WrapperClass.AgentAppFilterRequest getfiterDataIds(){
        AA_WrapperClass.AgentAppFilterRequest objAgentAppFilterData = new AA_WrapperClass.AgentAppFilterRequest();
       
        Schema.DescribeSObjectResult R = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RT = R.getRecordTypeInfosByName();
        Id UnileverRecTypeId = (RT.get('Unilever Agent Published Report')).getRecordTypeId();
        objAgentAppFilterData.UnileverRecordTypeId=UnileverRecTypeId;
        
        aa_Agent_App_Competitor_Brand__c otherCompetitorBrandId=[Select Id from aa_Agent_App_Competitor_Brand__c where name='Other'];
         objAgentAppFilterData.OtherCompetitorBrandId=otherCompetitorBrandId.Id; 
        
        aa_Cluster__c globalClusterId=[Select Id from aa_Cluster__c where name='Global'];
        objAgentAppFilterData.GlobalClusterId=globalClusterId.Id;
        
         Schema.DescribeSObjectResult Record = aa_Agent_Report__c.SObjectType.getDescribe();
        Map<String,Schema.RecordTypeInfo> RTId = Record.getRecordTypeInfosByName();
        Id CompetitorRecTypeId = (RTId.get('Competitor Report')).getRecordTypeId();
        objAgentAppFilterData.CompetitorRecordTypeId=CompetitorRecTypeId;
            
        return objAgentAppFilterData;
        
    }
    
     @AuraEnabled
    public static aa_Agent_App_User_Preference__c getUserPreference(){
   aa_Agent_App_User_Preference__c UserPref = new aa_Agent_App_User_Preference__c();
        UserPref = [SELECT Id,
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
        
        return UserPref;
    }
}