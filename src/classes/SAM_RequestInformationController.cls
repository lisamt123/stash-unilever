/**********************************************************************
Name: SAM_RequestInformationController()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: Provide validation messages on request layout.
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR           DATE            DETAIL Description
1.0         Mindtree       13/07/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
//Dinesh 27/7 - Added with sharing in class declaration to fix SonarQube issue
//Issue - With Sharing should be used on classes that make use of DML
public with sharing class SAM_RequestInformationController{
 
     public Id requestId ;
     public Map<String,String> objectMap {get; set;}
     public List<RecordType>recordTypeInfoList;
     Public SAM_Request__c requestRecord;
     public String mandatoryStringFlag {get; set;}   
      public String redirectUrl {public get; private set;}
      public Boolean shouldRedirect {public get; private set;}
      private ApexPages.StandardController stdController;
      public Boolean flagToShowSubmitbutton{get; set;}
      public String commentsStr{get;set;}
      public boolean reminderSetFlag{get;set;}
      public List<PermissionSetAssignment> loggedInUserPermissionList;
      public PermissionSet requestorPermissionSet;  
      public PermissionSet samAdminPermissionSet;  
      public PermissionSet samTeamPermissionSet; 
       public PermissionSet financeTeamPermissionSet; 
      public boolean requestorFlag;
      public boolean samAdminFlag;
      public boolean samTeamFlag;
      public boolean financeTeamFlag;  
                    
    
     
    /*******************************************************************
    Purpose: Controller
    Parameters: ApexPages.StandardController
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
     public SAM_RequestInformationController(ApexPages.StandardController stdController){
         
         this.stdController = stdController;
         shouldRedirect = false; 
         reminderSetFlag = false;
          requestorFlag =false;
          samAdminFlag = false;
          samTeamFlag =false;
          financeTeamFlag =false;
         
        loggedInUserPermissionList = [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId()];
        requestorPermissionSet = [select id,Name from PermissionSet where Name = 'SAM_Requestor' limit 1];
        samAdminPermissionSet = [select id,Name from PermissionSet where Name = 'SAM_Admin' limit 1];
        samTeamPermissionSet = [select id,Name from PermissionSet where Name = 'SAM_Team' limit 1];
        financeTeamPermissionSet =  [select id,Name from PermissionSet where Name = 'SAM_Finance_Team' limit 1];
         system.debug('financeTeamPermissionSet !!'+financeTeamPermissionSet +'loggedInUserPermissionList !!'+loggedInUserPermissionList );
         
        if(loggedInUserPermissionList.size()>0 ){
          for(PermissionSetAssignment permissionSetObj:loggedInUserPermissionList){
         
              if(requestorPermissionSet!=null){
                if(permissionSetObj.PermissionSet.Name == requestorPermissionSet.Name){
                    requestorFlag = true;
                }
               }
               
              if(samAdminPermissionSet!=null){
                if(permissionSetObj.PermissionSet.Name == samAdminPermissionSet.Name){
                    samAdminFlag = true;
                }
               } 
               
             if(samTeamPermissionSet!=null){
                if(permissionSetObj.PermissionSet.Name == samTeamPermissionSet.Name){
                    samTeamFlag = true;
                }
               }
               
             if(financeTeamPermissionSet!=null){
                if(permissionSetObj.PermissionSet.Name == financeTeamPermissionSet.Name){
                     financeTeamFlag = true;
                   }
               }
            }
        }
        //Dinesh 26/7 - Remove this debug, once you are done with testing of this method
        system.debug('requestorFlag>>'+requestorFlag+'samAdminFlag>>'+samAdminFlag+'samTeamFlag>>'+samTeamFlag+'financeTeamFlag >>'+financeTeamFlag );
       
       
            
         if(ApexPages.currentPage().getParameters().get(SAM_Constants.ID) != null) {      
            requestId = ApexPages.currentPage().getParameters().get(SAM_Constants.ID);
            checkMessageValidation(requestId);
         }
     }
   
    /*******************************************************************
    Purpose: Below method will check the mandatory fields and flag message accordingly.
    Parameters: id
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    // Dinesh commented this method - 19/07/2016
     boolean checkMessageValidation(Id requestId){
         mandatoryStringFlag = null;
         string queryString = 'select ';
         objectMap = new Map<String,String>();
         flagToShowSubmitbutton = false;

        Schema.DescribeSObjectResult requestObj = SAM_Request__c.sObjectType.getDescribe();        
        Map<String, Schema.SobjectField> requestFieldMap = requestObj.fields.getMap();
        for(string apiName : requestFieldMap.keySet()){
            queryString = queryString + apiName + ',';
        }   
        queryString = queryString.removeEnd(',');
        queryString = queryString + ' from SAM_Request__c where id=:requestId';
        requestRecord = Database.query(queryString);          
           //project record type
           if(requestRecord.RecordTypeId !=null && requestRecord.txt_Request_Type__c != null){
           //if(requestRecord.RecordTypeId == projectRecordType){
               List<SAM_success_messages__c> customSettingStatusMsg = SAM_success_messages__c.getall().values();             
               for(SAM_success_messages__c msg:customSettingStatusMsg){
                   if(msg.SAM_Status__c == requestRecord.pkl_Status__c){                       
                       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg.SAM_Success_message__c));
                   }                
               }
           //below fields are manadtory if status is saved 
               if(requestRecord.pkl_Status__c== SAM_Constants.SAVED){
                   
                   string recordtypeValue = '%'+ requestRecord.txt_Request_Type__c + '%';
                   // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, label.SAM_SaveStatus));
                    Map<String, SAM_Mandatory_fields_for_submit__c> mandatoryFieldsMap = new Map<String, SAM_Mandatory_fields_for_submit__c>();
                    List<SAM_Mandatory_fields_for_submit__c> configuredMandatoryFields = [Select Name,SAM_Field_API_name__c, SAM_controlling_field__c, SAM_controlling_field_value__c, SAM_Field_Label__c, SAM_Record_type__c, SAM_is_mandatory__c,SAM_validation_message__c,SAM_Reverse_Validation_message__c,SAM_Reverse_Validation__c FROM SAM_Mandatory_fields_for_submit__c  WHERE SAM_is_mandatory__c = true AND SAM_Record_type__c LIKE: recordtypeValue];
                    for(SAM_Mandatory_fields_for_submit__c mandatoryField : configuredMandatoryFields)
                    {
                        if(recordtypeValue.Contains('SAM_RW_Query_Request') && !samTeamFlag && ((mandatoryField.SAM_Field_API_name__c.tolowercase() == 'date_query_end_date__c') || (mandatoryField.SAM_Field_API_name__c.tolowercase() == 'date_query_start_date__c')) )
                        {
                            //19/08 Dinesh - Added below to avoid SonarQube issue
                           //Avoid empty if statements
                           //You can always write reverse condition in If and move the else condition code to if.
                            System.debug('do NOT add to the mandatory list');
                        }
                        else
                        {
                            mandatoryFieldsMap.put(mandatoryField.SAM_Field_API_name__c.tolowercase(),mandatoryField);
                        }
                    }                   
                    
                    Map<String,Schema.SobjectField> mandatoryFields = new Map<string,Schema.SobjectField>();
                    Map<String,Schema.SobjectField> reverseMandatoryFields = new Map<string,Schema.SobjectField>();
                    Map<String,String> validation_message = new Map<string,String>();
                    Map<String,String> reverseValidation_message = new Map<string,String>();
                    for(string apiName : requestFieldMap.keySet()){
                        Schema.DescribeFieldResult dfr = requestFieldMap.get(apiName).getDescribe();                        
                        SAM_Mandatory_fields_for_submit__c configMandatoryField =  mandatoryFieldsMap.get(apiName);                     
                        if(configMandatoryField != null && configMandatoryField.SAM_is_mandatory__c){
                            //Check for Controlling field value
                            if(configMandatoryField.SAM_controlling_field__c != null && configMandatoryField.SAM_controlling_field_value__c != null){
                              string controllingfield_Value = String.valueOf(requestRecord.get(requestFieldMap.get(configMandatoryField.SAM_controlling_field__c))); 
                              string dependendfield_Value = String.valueOf(requestRecord.get(requestFieldMap.get(configMandatoryField.SAM_Field_API_name__c))); 
                              if(controllingfield_Value != null && controllingfield_Value.contains(configMandatoryField.SAM_controlling_field_value__c))
                              {
                                mandatoryFields.put(dfr.getLabel(),requestFieldMap.get(apiName));
                                validation_message.put(dfr.getLabel(),configMandatoryField.SAM_validation_message__c);
                              }
                              if((controllingfield_Value == null || !controllingfield_Value.contains(configMandatoryField.SAM_controlling_field_value__c)) && dependendfield_Value != null && configMandatoryField.SAM_Reverse_Validation__c && configMandatoryField.SAM_Reverse_Validation_message__c != null){
                                reverseMandatoryFields.put(dfr.getLabel(),requestFieldMap.get(apiName));
                                reverseValidation_message.put(dfr.getLabel(),configMandatoryField.SAM_Reverse_Validation_message__c);
                              }
                            }                            
                            else
                            {
                                mandatoryFields.put(dfr.getLabel(),requestFieldMap.get(apiName));
                                validation_message.put(dfr.getLabel(),configMandatoryField.SAM_validation_message__c);
                            }           
                        }
                                    
                    } 
                   system.debug('validation_message>'+validation_message);
                    for(string key : mandatoryFields.keySet()){
                       if(requestRecord.get(mandatoryFields.get(key)) == null)
                        objectMap.put(key,validation_message.get(key));
                    }
                    for(string key : reverseMandatoryFields.keySet()){
                        objectMap.put(key,reverseValidation_message.get(key));
                    }
                   if((requestRecord.txt_Request_Type__c == SAM_Constants.SAM_RW_PROJECT_REQUEST || requestRecord.txt_Request_Type__c == SAM_Constants.SAM_RW_NON_PROJECT_REQUEST) && requestRecord.rol_Product_Details_Count__c == 0){
                       objectMap.put(SAM_Constants.PRODUCTDETAIL,SAM_Constants.MANDATORY);
                   }
                   if(requestRecord.date_Go_Live_Date__c != null && requestRecord.date_Go_Live_Date__c <= system.today()){
                       objectMap.put(Schema.SAM_Request__c.fields.date_Go_Live_Date__c.getDescribe().getLabel(),SAM_Constants.GOLIVEDATECANNOTBEPASTDATE);
                   }

                }
            //}
        }               
            if(!objectMap.isEmpty()){ 
             mandatoryStringFlag = 'Below field(s) are mandatory to Submit the record';
            return false;
        } 
         if(requestRecord.pkl_Status__c== SAM_Constants.SAVED && objectMap.isEmpty()){
             flagToShowSubmitbutton = true;
             }
             
          if(requestRecord.pkl_Status__c == SAM_Constants.AWAITINGINFORMATION || requestRecord.pkl_Status__c == SAM_Constants.QUOTE_PROVIDED || requestRecord.pkl_Status__c == SAM_Constants.AWAITING_CC_DETAILS_PENDINGWITHULEMP || requestRecord.pkl_Status__c == SAM_Constants.DETAILS_PENDING || requestRecord.pkl_Status__c == SAM_Constants.QUERY_ANSWERED){
             if(requestorFlag && !samAdminFlag && !samTeamFlag){
                reminderSetFlag =false;
            }else if(financeTeamFlag && !samAdminFlag && !samTeamFlag){
                reminderSetFlag  = false;
            }else{
                 reminderSetFlag  = true;
            }
            
        }
         return true;
     }
     
    /*******************************************************************
    Purpose: This method is used to validate status.
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    
     public void submit(){
         shouldRedirect = true;
        system.debug('i am in submit'+requestRecord);
        //Dinesh 27/7 - modified below line to fix SonarQube issue - Variable not assigned: Found 'UR'-anomaly for variable 'resultflag' (lines '140'-'147').
         //boolean resultFlag;
         boolean resultFlag = false;
         if(requestId !=null){
             resultFlag= checkMessageValidation(requestId);
         }
         //Dinesh 27/7 - modified below if condition to fix SonarQube issue - Avoid unnecessary comparisons in boolean expressions
         //if(resultFlag == true){
         if(resultFlag){
             if(requestRecord.txt_Request_Type__c == SAM_Constants.SAM_RW_CROSSCHARGE_REQUEST){
                 requestRecord.pkl_Status__c= SAM_Constants.AWAITINGCHARGE;
             }else {
             requestRecord.pkl_Status__c= SAM_Constants.OPEN;
             requestRecord.pkl_Ownership_Reporting__c = 'Pending-SAM';
             }
             system.debug('requestRecord.pkl_Status__c>>'+requestRecord.pkl_Status__c);
             update requestRecord;
             system.debug('requestRecord>>'+requestRecord);
         }
         system.debug('requestRecord>>>'+requestRecord.pkl_Status__c); 
         redirectUrl = stdController.view().getUrl();
     }
     
    /*******************************************************************
    Purpose: This method is used for Reminder
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public PageReference reminderAction(){
        
      
        PageReference pageRef = new PageReference('/apex/SAM_CommentPage');
        pageRef.getParameters().put('id',requestId);
        pageRef.setRedirect(true);
     
       return pageRef;
   
  
    }
    
    /*******************************************************************
    Purpose: This method is used to send email
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public PageReference emailSentAction(){
    
    system.debug('commentsStr!!!'+commentsStr+'requestId!!'+requestId);
    if(commentsStr!=null && requestId!=null){
    SAM_Request__c reqInfo = [select Name,createdById from SAM_Request__c where id = :requestId limit 1];
    User user = [SELECT id,FirstName,Email FROM User where id=:reqInfo.createdById limit 1];
    system.debug('emailId !!'+user.email );
        if(user !=null && reqInfo!=null){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] {user.email};
        //message.toAddresses = new String[] {'varunikam@gmail.com'};
        String strSubject ='SR : '+reqInfo.Name+' : Reminder to take action';
        message.subject = strSubject;
        String strBody='Hi '+user.FirstName+','+'\n\n'+'The request with Id : '+reqInfo.Name+' is pending for your action with below details.'+'\n\n'+commentsStr+'\n\n'+'Kindly take the action.'+'\n\n'+'Thanks,'+'\n'+'UL SAM Team';
        system.debug('str!!!'+strBody);
        message.plainTextBody = strBody;
        Messaging.SendEmail(new Messaging.SingleEmailMessage[]{message});
        }
    }
    
    
        PageReference pageRef = new PageReference('/apex/SAM_RequestInformationPage');
        pageRef.getParameters().put(SAM_Constants.ID,requestId);
        pageRef.setRedirect(true);
      
       return pageRef;
    }
    /*******************************************************************
    Purpose: This method is used to cancel mail sending
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Pagereference canelAction(){
    
        PageReference pageRef = new PageReference('/apex/SAM_RequestInformationPage');
        pageRef.getParameters().put(SAM_Constants.ID,requestId);
        pageRef.setRedirect(true);
       
       return pageRef;
        
   
    }
    
 }