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
    public String labelStr {get;set;}
    public boolean reminderSetFlag{get;set;}
    public boolean requestorFlag;
    public boolean samAdminFlag;
    public boolean samTeamFlag;
    public boolean financeTeamFlag;  
    public boolean crossChargeInfoSetFlag{get;set;}
    public String subjectStr{get;set;}
    public Map<String,Schema.SobjectField> mandatoryFields;
    public Map<String,Schema.SobjectField> reverseMandatoryFields;
    public Map<String,String> validation_message;
    public Map<String,String> reverseValidation_message; 
     
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
        crossChargeInfoSetFlag =false;
        mandatoryFields = new Map<string,Schema.SobjectField>();
        reverseMandatoryFields = new Map<string,Schema.SobjectField>();
        validation_message = new Map<string,String>();
        reverseValidation_message = new Map<string,String>();
        labelStr = null; 
        List<PermissionSetAssignment> loggedInUserPermissionList = [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId()];
        PermissionSet requestorPermissionSet = [select id,Name from PermissionSet where Name = 'SAM_Requestor' limit 1];
        PermissionSet samAdminPermissionSet = [select id,Name from PermissionSet where Name = 'SAM_Admin' limit 1];
        PermissionSet samTeamPermissionSet = [select id,Name from PermissionSet where Name = 'SAM_Team' limit 1];
        PermissionSet financeTeamPermissionSet =  [select id,Name from PermissionSet where Name = 'SAM_Finance_Team' limit 1];
         
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
            /*List<SAM_success_messages__c> customSettingStatusMsg = SAM_success_messages__c.getall().values();             
            for(SAM_success_messages__c msg:customSettingStatusMsg){
               if(msg.SAM_Status__c == requestRecord.pkl_Status__c && msg.SAM_recordtype__c.contains(requestRecord.txt_Request_Type__c)){                       
                   labelStr = 'SAM_Open';
				   //List<String> l = s.split('<br>');
                   //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, '{!$Label.' + s + '}'));
                }                
            }*/
            if(requestRecord.pkl_Status__c != null && requestRecord.txt_Request_Type__c != null){
                string specialCharPatterns = '[^\\w]+';
                string multiUnderscorePattern = '_+';
                if(requestRecord.txt_Request_Type__c == SAM_Constants.SAM_RW_QUERY_REQUEST){
                    labelStr = SAM_Constants.SAM_RW_QUERY_REQUEST;
                }else 
                {labelStr = SAM_Constants.SAM_RW_PROJECT_REQUEST; }
                labelStr = labelStr +' ' + requestRecord.pkl_Status__c;
                system.debug('labelStr>>>>>>>>1'+labelStr);
                //replace special chars with underscores, and multiple underscores with one
                labelStr = labelStr.replaceAll(specialCharPatterns,'_').replaceAll(multiUnderscorePattern,'_').removeEnd('_');
                system.debug('labelStr>>>>>>>>2'+labelStr);
                
            }
            
            //below fields are manadtory if status is saved 
            mapOFMandatoryFields(requestRecord);
            mapOFDisplayList(requestRecord,mandatoryFields,reverseMandatoryFields);
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
            }else if((requestRecord.lkp_Assign_To__c !=null) && (samTeamFlag && requestRecord.lkp_Assign_To__c == userinfo.getuserid())){
                 reminderSetFlag  = true;
            }else if(samAdminFlag ){
                 reminderSetFlag  = true;
            }
            
        }
        if(requestRecord.txt_Request_Type_for_UI__c == 'Project' && (requestRecord.pkl_Status__c == SAM_Constants.QUOTE_APPROVED  || requestRecord.pkl_Status__c == SAM_Constants.CHARGING_REJECTED  || requestRecord.pkl_Status__c ==  SAM_Constants.AWAITING_CC_DETAILS_PENDINGWITHULSAM )){
             if(requestorFlag && !samAdminFlag && !samTeamFlag){
                crossChargeInfoSetFlag =false;
            }else if(financeTeamFlag && !samAdminFlag && !samTeamFlag){
                crossChargeInfoSetFlag = false;
            }else if((requestRecord.lkp_Assign_To__c !=null) && (samTeamFlag && requestRecord.lkp_Assign_To__c == userinfo.getuserid())){
                 crossChargeInfoSetFlag = true;
            }else if(samAdminFlag ){
                 crossChargeInfoSetFlag = true;
            }
            
        }      
         return true;
     }
   
    /*******************************************************************
    Purpose: Below method will check the mandatory fields and flag message accordingly.
    Parameters: id
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public void mapOFMandatoryFields(SAM_Request__c requestRecordValue){    
        Schema.DescribeSObjectResult requestObj = SAM_Request__c.sObjectType.getDescribe(); 
        Map<String, Schema.SobjectField> requestFieldMapValue = requestObj.fields.getMap();
        if(requestRecordValue.pkl_Status__c== SAM_Constants.SAVED){                  
            string recordtypeValue = '%'+ requestRecordValue.txt_Request_Type__c + '%';
            Map<String, SAM_Mandatory_fields_for_submit__c> mandatoryFieldsMap = new Map<String,SAM_Mandatory_fields_for_submit__c>();
            List<SAM_Mandatory_fields_for_submit__c> configuredMandatoryFields = [Select Name,SAM_Field_API_name__c, SAM_controlling_field__c, SAM_controlling_field_value__c, SAM_Field_Label__c, SAM_Record_type__c, SAM_is_mandatory__c,SAM_validation_message__c,SAM_Reverse_Validation_message__c,SAM_Reverse_Validation__c FROM SAM_Mandatory_fields_for_submit__c  WHERE SAM_is_mandatory__c = true AND SAM_Record_type__c LIKE: recordtypeValue];
            for(SAM_Mandatory_fields_for_submit__c mandatoryField : configuredMandatoryFields){
                if(recordtypeValue.Contains('SAM_RW_Query_Request') && !samTeamFlag && ((mandatoryField.SAM_Field_API_name__c.tolowercase() == 'date_query_end_date__c') || (mandatoryField.SAM_Field_API_name__c.tolowercase() == 'date_query_start_date__c')) ){
                    system.debug('Do nothing');
                }
                else{
                    mandatoryFieldsMap.put(mandatoryField.SAM_Field_API_name__c.tolowercase(),mandatoryField);
                }
            }                       
            for(string apiName : requestFieldMapValue.keySet()){
                Schema.DescribeFieldResult dfr = requestFieldMapValue.get(apiName).getDescribe();                        
                SAM_Mandatory_fields_for_submit__c configMandatoryField =  mandatoryFieldsMap.get(apiName);                     
                if(configMandatoryField != null && configMandatoryField.SAM_is_mandatory__c){
                    //Check for Controlling field value
                    if(configMandatoryField.SAM_controlling_field__c != null && configMandatoryField.SAM_controlling_field_value__c != null){
                        string controllingfield_Value = String.valueOf(requestRecordValue.get(requestFieldMapValue.get(configMandatoryField.SAM_controlling_field__c))); 
                        string dependendfield_Value = String.valueOf(requestRecordValue.get(requestFieldMapValue.get(configMandatoryField.SAM_Field_API_name__c))); 
                        if(controllingfield_Value != null && controllingfield_Value.contains(configMandatoryField.SAM_controlling_field_value__c)){
                            mandatoryFields.put(dfr.getLabel(),requestFieldMapValue.get(apiName));
                            validation_message.put(dfr.getLabel(),configMandatoryField.SAM_validation_message__c);
                        }
                        if((controllingfield_Value == null || !controllingfield_Value.contains(configMandatoryField.SAM_controlling_field_value__c)) && dependendfield_Value != null && configMandatoryField.SAM_Reverse_Validation__c && configMandatoryField.SAM_Reverse_Validation_message__c != null){
                            reverseMandatoryFields.put(dfr.getLabel(),requestFieldMapValue.get(apiName));
                            reverseValidation_message.put(dfr.getLabel(),configMandatoryField.SAM_Reverse_Validation_message__c);
                        }
                    }                            
                    else{
                        mandatoryFields.put(dfr.getLabel(),requestFieldMapValue.get(apiName));
                        validation_message.put(dfr.getLabel(),configMandatoryField.SAM_validation_message__c);
                    }           
                }
            } 
            
        }
    }
 /*******************************************************************
    Purpose: Below method will check the mandatory fields and flag message accordingly.
    Parameters: id
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public void mapOFDisplayList(SAM_Request__c requestRecordValue,Map<String,Schema.SobjectField> mandatoryFields,Map<String,Schema.SobjectField> reverseMandatoryFields){
		if(requestRecordValue.pkl_Status__c== SAM_Constants.SAVED){
			for(string key : mandatoryFields.keySet()){
					if(requestRecordValue.get(mandatoryFields.get(key)) == null)
						objectMap.put(key,validation_message.get(key));
				}
			for(string key : reverseMandatoryFields.keySet()){
				objectMap.put(key,reverseValidation_message.get(key));
			}
			if(requestRecordValue.pkl_SAAS_Yes_No__c != 'Yes' && (requestRecordValue.txt_Request_Type__c == SAM_Constants.SAM_RW_PROJECT_REQUEST || requestRecordValue.txt_Request_Type__c == SAM_Constants.SAM_RW_NON_PROJECT_REQUEST) && requestRecordValue.rol_Product_Details_Count__c == 0){
				objectMap.put(SAM_Constants.PRODUCTDETAIL,SAM_Constants.MANDATORY);
			}
			if(requestRecordValue.txt_Request_Type__c == SAM_Constants.SAM_RW_PROJECT_REQUEST && requestRecordValue.mpkl_Landscape_Details__c != SAM_Constants.GLOBALLANDSCAPE && requestRecordValue.mpkl_Country_of_Deployment__c == null){
				objectMap.put(Schema.SAM_Request__c.fields.mpkl_Country_of_Deployment__c.getDescribe().getLabel(),SAM_Constants.COUNTRYMANDATORY);
			}
			if(requestRecordValue.txt_Request_Type__c == SAM_Constants.SAM_RW_PROJECT_REQUEST && requestRecordValue.mpkl_Landscape_Details__c == SAM_Constants.GLOBALLANDSCAPE && requestRecordValue.mpkl_Country_of_Deployment__c != null){
				objectMap.put(Schema.SAM_Request__c.fields.mpkl_Country_of_Deployment__c.getDescribe().getLabel(),SAM_Constants.COUNTRYREVERSEMANDATORY);
			}
			if(requestRecordValue.date_Go_Live_Date__c != null && requestRecordValue.date_Go_Live_Date__c <= system.today()){
				objectMap.put(Schema.SAM_Request__c.fields.date_Go_Live_Date__c.getDescribe().getLabel(),SAM_Constants.GOLIVEDATECANNOTBEPASTDATE);
			}
            if(requestRecordValue.txt_Request_Type__c == SAM_Constants.SAM_RW_CROSSCHARGE_REQUEST){
                validationForApprovalEmail(requestRecordValue,objectMap);
            }
		}
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
    User user = [SELECT id,FirstName,lastname,Email FROM User where id=:reqInfo.createdById limit 1];
    system.debug('emailId !!'+user.email );
        if(user !=null && reqInfo!=null){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] {user.email};
       // message.toAddresses = new String[] {'varunikam@gmail.com'};
       if(crossChargeInfoSetFlag){
       message.subject = subjectStr;
       }else{
        String strSubject ='SR : '+reqInfo.Name+' : Reminder to take action';
        message.subject = strSubject;
        }
        String strBody='Hi '+user.FirstName+' '+user.lastname+','+'\n\n'+'The request with Id : '+reqInfo.Name+' is pending for your action with below details.'+'\n\n'+commentsStr+'\n\n'+'Kindly take the action.'+'\n\n'+'Thanks,'+'\n'+Userinfo.getname();
        system.debug('str!!!'+strBody);
        message.plainTextBody = strBody;
        if(!Test.isRunningTest()){
        	Messaging.SendEmail(new Messaging.SingleEmailMessage[]{message});
        }
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
	/*******************************************************************
    Purpose: Request can not send for Charging without attaching Approval email details
    Parameters: List of SAM_Request__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void validationForApprovalEmail(SAM_Request__c requestrecord,Map<String,String>objectMap){
        List<Attachment> lstAttachmentApproval_Emails = [SELECT ContentType,Id,Name,ParentId  FROM Attachment WHERE Name LIKE 'Approval_Emails%' and ParentId =:requestrecord.id];
        
		if(lstAttachmentApproval_Emails.size()<1){
			objectMap.put('Approval Email Attachment','You can not Send the Request for  Cross charge without Budget and Invoice approval email attached with file name "Approval_Emails".'); 
		}					
		
	}    
}