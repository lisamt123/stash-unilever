public with sharing class AA_DatabaseServiceUtil {

/* Performs DB Upsert operation of List<SObject> passed  */
    public static List<String> upsertOperation(List<SObject> upsertObjList){
         List<String> idList = new List<String>();
         try{
            list<Database.UpsertResult> saveResultList = Database.upsert(upsertObjList,true);        
            for(Database.UpsertResult saveResult:saveResultList) {
                if(!saveResult.isSuccess()){
                    Database.Error err = saveResult.getErrors()[0];
                    break;
                }
            idList.add(saveResult.getId()); 
            }
        }
        catch(DMLException dmlEx){ 
          //  throw new BaseServiceException('Exception occured: DatabaseServiceUtil : upsertOperation method ', dmlEx);            
        }
        catch(Exception genEx){ 
          // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : upsertOperation method ', genEx);  
            
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
                
            }else{
                idList.add(upsertResult.getId());            
            }
        }catch(DMLException dmlEx){ 
           // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : upsertOperation method ', dmlEx);            
        }
        catch(Exception genEx){ 
           // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : upsertOperation method ', genEx);  
        }  
        return idList;
    } 
    
     /* Performs DB upsert operation with Sobject passed */
    public static List<String> insertOperation(String varAgentReportId,String contentID){
        system.debug('******************* in feed insert');
        List<String> idList = new List<String>();   
        try{
            system.debug('******7');    
            FeedItem fi2 = new FeedItem();
            fi2.body = 'New Agent File uploaded';
            fi2.Type = 'TextPost' ;
            if(contentID !=null && contentID != ''){
                system.debug('******8'); 
                fi2.RelatedRecordId = contentID;
                fi2.Type = 'ContentPost' ;
            }
            fi2.Title = 'Agent File';           
            fi2.ParentId = varAgentReportId;
            system.debug('feed iem to be inserted '+fi2);
            insert fi2;
            
            
            system.debug('New Feed Created --> '+ fi2.id +' With Content Id as '+contentID);
            aa_Agent_Report__c c = [select Chatter_Post_ID__c from aa_Agent_Report__c where id = :varAgentReportId];
            c.Chatter_Post_ID__c = fi2.id;
            update c;
            system.debug('Chatter_Post_ID__c inserted --> ');
            idList.add(varAgentReportId);
        }catch(DMLException dmlEx){ 
           // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : upsertOperation method ', dmlEx);            
        }
        catch(Exception genEx){ 
           // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : upsertOperation method ', genEx);  
        }  
     
        return idList;
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
                    dbErrMessage = dbErrMessage + err.getMessage();
                    
                }
            idList.add(deleteResult.getId());
            }
       }catch(DMLException dmlEx){ 
           // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : deleteOperation method ', dmlEx);            
       }catch(Exception genEx){ 
          // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : deleteOperation method ', genEx);  
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
            }else{
                idList.add(deleteResult.getId());            
            }
        }catch(DMLException dmlEx){ 
           // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : deleteOperation method ', dmlEx);            
        }
        catch(Exception genEx){ 
          // throw new BaseServiceException('Exception occured: DatabaseServiceUtil : deleteOperation method ', genEx);  
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
        }
        
        return rtId;
    } 
    
    
    /**********************************************************************************
    // Method returns the Picklist values of the FIELDNAME of the OBJECTNAME passed
    **********************************************************************************/
    public list<String> getPickListValues(String ObjectType, String PickListFieldAPIName)
    {
        list<String> pickListValues = null;
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