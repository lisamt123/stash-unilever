public with sharing class AA_DatabaseServiceUtil {

/* Performs DB Upsert operation of List<SObject> passed  */
    public static List<String> upsertOperation(List<SObject> upsertObjList){
         List<String> idList = new List<String>();
         try{
            list<Database.UpsertResult> saveResultList = Database.upsert(upsertObjList,true);        
            for(Database.UpsertResult saveResult:saveResultList) {
                if(!saveResult.isSuccess()){
                    Database.Error err = saveResult.getErrors()[0];
                    system.debug('Error: '+err);
                    break;
                }
            idList.add(saveResult.getId()); 
            }
        }
        catch(DMLException dmlEx){ 
          //  throw new BaseServiceException('Exception occured: DatabaseServiceUtil : upsertOperation method ', dmlEx);         
           System.debug(AA_Constants.StringException + dmlEx);   
        }
        catch(Exception genEx){ 
          // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : upsertOperation method ', genEx);  
             System.debug(AA_Constants.StringException + genEx);
        }  
        return idList;
    }
    
    
    /* Performs DB upsert operation with Sobject passed */
    public static List<String> upsertOperation(SObject upsertObj){
        
        List<String> idList = new List<String>();   
        try{
            Database.Upsertresult upsertResult= Database.upsert(upsertObj, true);
            if(!upsertResult.isSuccess()){
                Database.Error err = upsertResult.getErrors()[0];
                    system.debug('Error: '+err);
            }else{
                idList.add(upsertResult.getId());            
            }
        }catch(DMLException dmlEx){ 
           // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : upsertOperation method ', dmlEx);         
          System.debug(AA_Constants.StringException + dmlEx); 
        }
        catch(Exception genEx){ 
           // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : upsertOperation method ', genEx); 
           System.debug(AA_Constants.StringException + genEx); 
        }  
        return idList;
    } 
    
      /* Performs DB upsert operation with Sobject passed */
    public static List<String> insertOperation(String varAgentReportId,String contentID){
       
        List<String> idList = new List<String>();   
        try{
           
            FeedItem fi2 = new FeedItem();
            fi2.body = 'New Agent File uploaded';
            fi2.Type = 'TextPost' ;
            if(contentID !=null && contentID != ''){
                 
                fi2.RelatedRecordId = contentID;
                fi2.Type = 'ContentPost' ;
            }
            fi2.Title = 'Agent File';           
            fi2.ParentId = varAgentReportId;
           
            insert fi2;           
            
            
            aa_Agent_Report__c c = [select Chatter_Post_ID__c from aa_Agent_Report__c where id = :varAgentReportId];
            c.Chatter_Post_ID__c = fi2.id;
            update c;
           
            idList.add(varAgentReportId);
            
            
           aa_Agent_Report__c objReport=[select id,Report_Title__c, TF_Mention_User__c, TF_Topic_Name__c, Country__c,status__c, CreatedById from aa_Agent_Report__c where id =: varAgentReportId];
           
           if(objReport.status__c =='Published (Public)')
             {
                 system.debug('@ Mention user: '+objReport.TF_Mention_User__c);
            
//                AA_DatabaseServiceUtil.sendToChatter(objReport.CreatedById,objReport.CreatedById, objReport.Report_Title__c, objReport.id,objReport.Country__c,objReport.TF_Mention_User__c,objReport.TF_Topic_Name__c);
     AA_DatabaseServiceUtil.sendToChatter(objReport.CreatedById,objReport.CreatedById, objReport.Report_Title__c, objReport.id,objReport.Country__c,objReport.TF_Mention_User__c);               
             }
        
        
            
        }catch(DMLException dmlEx){ 
           // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : upsertOperation method ', dmlEx);     
           System.debug(AA_Constants.StringException + dmlEx);       
        }
        catch(Exception genEx){ 
           // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : upsertOperation method ', genEx);  
           System.debug(AA_Constants.StringException + genEx);
        }  
     
        return idList;
    }
    
    
   // public static void sendToChatter(Id objectId, ID userToMentionId, String postText, Id reportId,string Country,string userIds,string topicNames) {    
      public static void sendToChatter(Id objectId, ID userToMentionId, String postText, Id reportId,string Country,string userIds) {       
        String reportCreatorName = [SELECT Name FROM User where Id=:userToMentionId].Name;
        //String reportName=[Select name from aa_Agent_Report__c where id=:reportId].name;
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        feedItemInput.body = new ConnectApi.MessageBodyInput();
        
        feedItemInput.body.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        //intro
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = 'New Agent Report by '+reportCreatorName ;
        feedItemInput.body.messageSegments.add(textSegment);
        ConnectApi.TextSegmentInput textSegment2 = new ConnectApi.TextSegmentInput();
        textSegment2.text = ': ' + postText+' ';
        feedItemInput.body.messageSegments.add(textSegment2);
        system.debug('Mention user to notify===> '+userIds);
        // add the mention
        if(userIds !=null){
            string[] splittedids=userIds.split(',');
            for(String ids:splittedids)
            {
              
                if(ids !=',')
                {
                    
                    ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
                    mentionSegment.id = Id.ValueOf(ids);
                    feedItemInput.body.messageSegments.add(mentionSegment);
                    ConnectApi.TextSegmentInput textSegment4 = new ConnectApi.TextSegmentInput();
                    textSegment4.text = ' ' ;
                    feedItemInput.body.messageSegments.add(textSegment4);  
                }
               
            }
            }
      /*  //Add Topics
        if(topicNames !=null)
        {
        string[] splittedTopics=topicNames.split(',');
        for(string topic:splittedTopics)
        {
           
            if(topic !=','){
            ConnectApi.Topics.assignTopic(null,reportId,topic);
            }
         }
        }
*/
        // add the text segment  
           ConnectApi.TextSegmentInput textSegment3 = new ConnectApi.TextSegmentInput();
          textSegment3.text = ' ' ;
          feedItemInput.body.messageSegments.add(textSegment3);     
        
        
        // add inline link
        ConnectApi.LinkSegmentInput report_link = new ConnectApi.LinkSegmentInput();
        String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + reportId;
        report_link.url = fullRecordURL;
        feedItemInput.body.messageSegments.add(report_link);
        
        //Adding Attachment            
        List<ContentDocumentLink> documentlist=[SELECT ContentDocument.id FROM ContentDocumentLink WHERE LinkedEntityId = :reportId LIMIT 1];
        if(!documentlist.IsEmpty()){
             ConnectApi.ContentAttachmentInput attachmentInput = new ConnectApi.ContentAttachmentInput(); 
             attachmentInput.contentDocumentId=documentlist[0].ContentDocument.id;
             system.debug('attachmentInput.contentDocumentId===='+attachmentInput.contentDocumentId);  
             feedItemInput.attachment = attachmentInput;
        } 
                    
        // post it!
        // ConnectApi.FeedItem new_chat = ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, objectId, feedItemInput, null);
    	ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, objectId, feedItemInput, null);
    } 
    
    /* Performs DB delete operation on List<SObject> passed */
    public static List<String> deleteOperation(List<SObject> deleteObjList){
         List<String> idList = new List<String>();
       try{
            Database.DeleteResult[] deleteResultList = Database.delete(deleteObjList, true);
            String dbErrMessage = '';
            for(Database.DeleteResult deleteResult:deleteResultList) {
                if(!deleteResult.isSuccess()){
                    Database.Error err = deleteResult.getErrors()[0];
                    system.debug('Error : '+err);
                    dbErrMessage = dbErrMessage + err.getMessage();
                    
                }
            idList.add(deleteResult.getId());
            }
       }catch(DMLException dmlEx){ 
           // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : deleteOperation method ', dmlEx);   
           System.debug(AA_Constants.StringException + dmlEx);         
       }catch(Exception genEx){ 
          // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : deleteOperation method ', genEx);  
        System.debug(AA_Constants.StringException+ genEx);  
       }  
       return idList;
    }
    
    
    /* Performs DB delete operation with Sobject passed */
    public static List<String> deleteOperation(SObject deleteObj){
        List<String> idList = new List<String>();
        try{
            Database.Deleteresult deleteResult= Database.delete(deleteObj, true);
            if(!deleteResult.isSuccess()){
                Database.Error err = deleteResult.getErrors()[0];
                system.debug('Error: '+err);
            }else{
                idList.add(deleteResult.getId());            
            }
        }catch(DMLException dmlEx){ 
           // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : deleteOperation method ', dmlEx);  
           System.debug(AA_Constants.StringException+ dmlEx);           
        }
        catch(Exception genEx){ 
          // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : deleteOperation method ', genEx);  
            System.debug(AA_Constants.StringException + genEx); 
        }  
        return idList;
    }  
    
    
    /**********************************************************************************
    // Method returns Recordtype id for the OBJECT NAME and the RECORDTYPE NAME passed
    **********************************************************************************/
    public static ID getRecordTypeId(String ObjectType, String RecordTypeLabel)
    {
        Id rtId = null;
        try{
            Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe() ;
            Schema.SObjectType s = sObjectMap.get(ObjectType) ; // getting Sobject Type
            Schema.DescribeSObjectResult resSchema = s.getDescribe() ;
            Map<String,Schema.RecordTypeInfo> recordTypeInfo = resSchema.getRecordTypeInfosByName(); //getting all Recordtype for the Sobject
            rtId = recordTypeInfo.get(RecordTypeLabel).getRecordTypeId();//particular RecordId by  Name
        }catch(Exception ex){ 
          //  throw new BaseServiceException('Exception occured: Utility : getRecordTypeId method ',ex);
          System.debug(AA_Constants.StringException + ex);
        }
        
        return rtId;
    } 
    
    
    /**********************************************************************************
    // Method returns the Picklist values of the FIELDNAME of the OBJECTNAME passed
    **********************************************************************************/
    public list<String> getPickListValues(String ObjectType, String PickListFieldAPIName)
    {
        //list<String> pickListValues = null;
        List<String> pickListValues =new List<String>();
        try{
            SObjectType sObjType = Schema.getGlobalDescribe().get(ObjectType);
            Map<String,Schema.SObjectField> mfields = sObjType.getDescribe().fields.getMap();
                
            Schema.DescribeFieldResult field = mfields.get(PickListFieldAPIName).getDescribe();
            system.debug('===============field>'+field.getPicklistValues());
            for (Schema.PicklistEntry f : field.getPicklistValues())
            {
                system.debug('===============>'+f.getLabel());
                pickListValues.add(f.getLabel());
            }
        }catch(Exception ex){ 
           // throw new BaseServiceException('Exception occured: Utility : getPickListValues method ',ex);
           System.debug(AA_Constants.StringException + ex);
        }  
        return pickListValues;
    }
    
    public static boolean validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        if((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id)) {
            return true;
        }
        return false;
    }
    
    

}