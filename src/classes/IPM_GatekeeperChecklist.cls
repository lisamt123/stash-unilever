/****************************************************************************************************************************
@Author: Cognizant
@Name: IPM_GatekeeperChecklist
@Created Date: 12/01/2015
@Description: To Display Gatekeeper Checklist Questions for gate Documents
@Version: 1.0
@Reference: Gatekeeper Checklist Components
*/
public with sharing class IPM_GatekeeperChecklist{  
    //For exception handler
    private static final String IPM_GATEKEEPERCHECKLIST_STR = IPM_GatekeeperChecklist.class.getName();
    private static final String GET_CHECKLIST_QUESTIONS_STR='getChecklistQuestions';
    private static final String GET_SECTION_WISE_GKCHECKLIST_STR='getSectioWiseGKChecklist'; 
    private static final String GET_GKCHECKLIST_STR='getGKChecklist';
    private static final String UPDATE_GKCHECKLIST_STR='updateGKchecklist';
    private static final String UPDATE_READONLY_GKCHECKLIST_STR='updateReadOnlyGKchecklist';
    private static final String GET_RECORDTYPEID_STR='getRecordTypeId';
    //Initializing Variables
    public static  ID recTypeGK; //Contains Gatekeeper Check list Record type Id
    public static  ID recTypeRnD; //Contains R&D  Record type Id
    public static  ID recTypeRnDFeasibility; //Contains R&D Feasibility  Record type Id
    public static  ID recTypeSCFeasibility; //Contains SC Feasibility  Record type Id
    public static  ID recTypeTrademark;//Contains Trademark Feasibility  Record type Id
    
    public static list<IPM_Questionnaire__c> gkChecklist{get;set;} //Contains Gatekeeper Check list Questions 
    public Map<Id,List<SelectOption>> gkChecklistAnsMap{get;set;} //Contains responses to the Gatekeeper Check list Questions
    public Map<String,String> gkHelpTextMap{get; set;} //Contains help text corresponding to the Gatekeeper Check list responses
    public static list<IPM_Questionnaire__c> quesList{get; set;} //Contains feasibility and rnd questions
    public IPM_Questionnaire__c gkCheck{get; set;} //Contains Gatekeeper Check list Record
    public Id quesId{get; set;} //Questionnaire Record Id
    public string comment{get; set;} //Comments for Questionnaire
    public string ans{get; set;} //Answer for Questionnaire
    public Boolean isEditable{get;set;} //To Check Read Only Mode or Editable
    public ID projectID{get;set;} //Project Id
    public Boolean cmts{get; set;} //Used for updating comments and Check list Value
    public IPM_Project_Document_Section__c  projDocSec {get;set;} //Contains Project Document Section Record
    public Map<Id,IPM_Questionnaire__c> readOnlyQuestionnaireMap {get;set;}
    
    public static final Map<String,String> GK_DEF_APPLICABLE_ANSMAP = new  Map<String,String>{Label.IPM_YES => Label.IPM_YES ,Label.IPM_PARTLY => Label.IPM_PARTLY , Label.IPM_NO => Label.IPM_NO, Label.IPM_NA => Label.IPM_NO_APPLICABLE };
    
    //Contains Gate Document Type and Retrieving Gatekeeper Check list Questionnaires
    public string gateType{ 
        get {
            return gateType;
        }
        set {
            gateType = value;
            getGKChecklist(); 
        }
    }
    //Contains Gate Document Type to Retrieve R&D Questionnaires
    public string gateTypeRND{  
        get {
            return gateType;
        }
        set {
            gateTypeRND = value;
            getChecklistQuestions(IPM_ConstantUtils.RND,gateTypeRND);
        }
    }
    //Contains Gate Document Type to Retrieve SC Feasibility Questionnaires
    public string gateTypeSCFeas{  
        get {
            return gateType;
        }
        set {
            gateTypeSCFeas = value;
            getChecklistQuestions(IPM_ConstantUtils.SC_FEASIBILITY,gateTypeSCFeas);
        }
    }
    //Contains Gate Document Type to Retrieve R&D Feasibility Questionnaires
    public string gateTypeRNDFeas{  
        get {
            return gateType;
        }
        set {
            gateTypeRNDFeas = value;
            getChecklistQuestions(IPM_ConstantUtils.RND_FEASIBILITY,gateTypeRNDFeas);
        }
    }
    
    public string gateTypeTradeMark{  
        get {
            return gateType;
        }
        set {
            gateTypeTradeMark= value;
            getChecklistQuestions(IPM_ConstantUtils.TRADEMARK_RECORD_TYPE,gateTypeTradeMark);
        }
    }
    
    //To Check Record is Editable or Read Mode
    public boolean editTable{ 
        get {
            return editTable;
        }
        set {
            editTable= value;
        }
    }
    //Contains Project Document Section Id to Retrieve Gatekeeper Checklist Questionnaires Section Wise
    public ID SecId{ 
        get {
            return SecId;
        }
        set {
            SecId= value;
            getSectioWiseGKChecklist();
        }
    }
    
    /************************************************************************************************************************
    *  Description Constructor Getting Project Id From Page URL Parameter
    *  @name IPM_GatekeeperChecklist
    */
    
    public IPM_GatekeeperChecklist(){
        if(ApexPages.currentPage().getParameters().get('id') != null) {
            if(ApexPages.currentPage().getParameters().get('isEditable') == 'true') {isEditable = true;} else {isEditable = false;}
            gateType = ApexPages.currentPage().getParameters().get('gateType');
            if(ApexPages.currentPage().getParameters().get('editTable') == 'true') {editTable = true;} else {editTable = false;}
            projectID = ApexPages.currentPage().getParameters().get('Id');
            gateTypeRND = ApexPages.currentPage().getParameters().get('gateTypeRND');
        }
        IPM_IECompatible.ieFix();//For IE Compatibility        
        readOnlyQuestionnaireMap = new Map<Id,IPM_Questionnaire__c>(); 
    }
    
    /************************************************************************************************************************
    *  Description Getting Gatekeeper Checklist,R&D & Feasibility Record Type Ids
    *  @name getRecordTypeId
    *  @param none
    *  @return void
    *  @throws query exception
    */
    public static void getRecordTypeId(){  
        try{
            recTypeGK =Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.GATEKEEPER_CHECKLIST_RECORD_TYPE).RecordTypeId;
            recTypeRnD =Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RNDQUESTION_RECORD_TYPE).RecordTypeId;
            recTypeRnDFeasibility=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RNDFEASIBILITYQUESTION_RECORD_TYPE).RecordTypeId;
            recTypeSCFeasibility=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.SCFEASIBILITY_RECORD_TYPE).RecordTypeId;
            recTypeTrademark=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.TRADEMARK_RECORD_TYPE).RecordTypeId;
        }
        
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEKEEPERCHECKLIST_STR,
                                                  GET_RECORDTYPEID_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    
    /************************************************************************************************************************
    *  Description To Show Gatekeeper Checklist Questionnaires for Displaying in Gate Document
    *  @name getGKChecklist
    *  @param none
    *  @return void
    *  @throws query exception
    */
    public void getGKChecklist()
    {
        try
        {
            //Retrieving Record Type Ids
            readOnlyQuestionnaireMap = new Map<Id,IPM_Questionnaire__c>(); 
            getRecordTypeId();  
            projectID=ApexPages.currentPage().getParameters().get('Id'); //this is not passing to this method from constructor
            String sObjectName = 'IPM_Questionnaire__c';
            Schema.DescribeSObjectResult sObjectDescribe = Schema.getGlobalDescribe().get(sObjectName).getDescribe();
        
        	Map<String,Schema.SObjectField> sobjectFieldMap = sObjectDescribe.fields.getMap();
            If(gateType != NULL) {
                String query = ' SELECT ';
                for(String fieldAPIName :  sobjectFieldMap.keySet())
                {   
                    if(!(fieldAPIName.equalsIgnoreCase('Id')))
                    {
                        query += ' '+fieldAPIName+',';
                    }
                }
                
                query += 'Id,IPM_Project_Document_Section__r.IPM_Section_Name__c from '+ sObjectName +' WHERE IPM_RQS_Gate_Type__c=:gateType AND RecordTypeId=:recTypeGK AND IPM_Project__c=:projectID';
                
                if(projDocSec!=null){
                    string projDocSecSequence=string.escapeSingleQuotes(projDocSec.IPM_Section_Sequence__c);//exception of unused local varaibale of Sonar. Used in below query
                    gkChecklist=Database.query(query+' AND IPM_Section_Sequence_Number__c=:projDocSecSequence order by IPM_Sequence_Number__c ASC LIMIT 50000');
                } 
                else
                {   
                    gkChecklist=Database.Query(query+' order by IPM_Sequence_Number__c ASC LIMIT 50000');        
                } 
            }
          
            // Get BET status and Set BET Gatekeeping answer
              
            
            if(gkChecklist!=null && !gkChecklist.isEmpty())  
            {
                for(IPM_Questionnaire__c ipmQue : gkChecklist) 
                {
                    String dependentFieldAPIName = ipmQue.DependentFieldAPIName__c; 
                    if(String.isNotBlank(dependentFieldAPIName))
                    {
                        ipmQue.put('IPM_GK_Answers__c',(String)ipmQue.get(dependentFieldAPIName));
                        readOnlyQuestionnaireMap.put(ipmQue.Id,ipmQue);
                    }   
                } 
                
                gkChecklistAnsMap  = new Map<Id , List<SelectOption>>();
                
                for(IPM_Questionnaire__c ipmQue : gkChecklist) 
                {   
                    // Prepare a map of Options VS help Text.           
                    gkHelpTextMap = new  Map<String , String>{ Label.IPM_YES => ipmQue.IPM_HelpText_Yes__c  , Label.IPM_PARTLY => ipmQue.IPM_HelpText_Partly__c , Label.IPM_NO => ipmQue.IPM_HelpText_No__c ,Label.IPM_NA=> ipmQue.IPM_Question_Help_Text__c };
                    
                    List<SelectOption> applicableGKOptions = new  List<SelectOption>{new SelectOption('0',Label.IPM_SELECT)};
                    
                    // Get the Applicable Answer List based on the Questionare record.
                    String gkAnswers=ipmQue.IPM_GK_Answers_Multiselect__c;
                    
                    if( gkAnswers!=null && !String.isBlank(gkAnswers))
                    {
                         List<String> applicableAnswerList = gkAnswers.split(IPM_ConstantUtils.SEMICOLON);
                         
                         for(String answerString : applicableAnswerList)
                         {  
                            String[] optionsArray = answerString.split(IPM_ConstantUtils.TILDA_DELIMITER);
                            
                            if(!optionsArray.isEmpty())
                            {
                                String optionLabel = optionsArray[0];
                                String optionValue = optionsArray[1];
                                
                                SelectOption answerOption = null; 
                                if(!gkHelpTextMap.containsKey(optionLabel))
                                {
                                    answerOption = new SelectOption(optionValue,optionLabel);
                                }
                                else
                                {
                                    answerOption = new SelectOption(optionValue,'<span title= " '+  gkHelpTextMap.get(optionLabel)  + ' " >' +optionLabel+'</span>');
                                }
                                answerOption.setEscapeItem(false);
                                applicableGKOptions.add(answerOption);              
                            }
                         } 
                     }
                     else  
                     {
                         for(String key :GK_DEF_APPLICABLE_ANSMAP.keyset())
                         {
                            SelectOption answerOption =new SelectOption( GK_DEF_APPLICABLE_ANSMAP.get(key),'<span title= " '+  gkHelpTextMap.get(key)  + ' ">' +key+'</span>');
                         
                            answerOption.setEscapeItem(false);
                         
                            applicableGKOptions.add(answerOption); 
                         } 
                     }                 
                     
                     gkChecklistAnsMap.put(ipmQue.id, applicableGKOptions);   
                 }
             } 
        }
        
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEKEEPERCHECKLIST_STR,
                                                  GET_GKCHECKLIST_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    /************************************************************************************************************************
    *  Description To Update the Answers and Comments in the Gatekeeper Checklist Questionnaires
    *  @name getSectioWiseGKChecklist
    *  @param none
    *  @return void
    *  @throws dml exception
    */
    
    public void  updateReadOnlyGKchecklist()
    {
        try
        {
            update readOnlyQuestionnaireMap.values(); 
        }  
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEKEEPERCHECKLIST_STR,
                                                  UPDATE_READONLY_GKCHECKLIST_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    public pageReference updateGKchecklist(){
        if(quesId != null)  
        {
            gkCheck=new IPM_Questionnaire__c();
            gkCheck.Id=quesId;
            try{
                if(cmts){
                    gkCheck.IPM_Comments__c =comment;
                }   
                else{
                    gkCheck.IPM_GK_Answers__c=ans;
                }
                update gkCheck;
            }
            catch (DMLException ex) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEKEEPERCHECKLIST_STR,
                                                      UPDATE_GKCHECKLIST_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
            }
            catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEKEEPERCHECKLIST_STR,
                                                      UPDATE_GKCHECKLIST_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            }
        }
        return null;
    }
    
    /************************************************************************************************************************
    *  Description To Fetch Section Wise Gatekeeper Checklist Questionnaires
    *  @name getSectioWiseGKChecklist
    *  @param none
    *  @return void
    *  @throws query exception
    */
    public void getSectioWiseGKChecklist(){
        try{
            projDocSec=[SELECT Id,IPM_Section_Sequence__c,IPM_Master_Section_External_Id__c FROM IPM_Project_Document_Section__c WHERE Id=:SecId];
            getGKChecklist();
        }
        
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEKEEPERCHECKLIST_STR,
                                                  GET_SECTION_WISE_GKCHECKLIST_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    /************************************************************************************************************************
    *  Description For Showing R&D,Feasibility Gatekeeper Checklist Questions
    *  @name getChecklistQuestions
    *  @param checkListType
    *  @return void
    *  @throws query exception
    */
    public void getChecklistQuestions(String checklistType,String gateType){
        try{
            String checklistRecordType=IPM_ConstantUtils.BLANK;
            //Retrieving Record Type Ids
            getRecordTypeId();
            if(checklistType==IPM_ConstantUtils.SC_FEASIBILITY){
                checklistRecordType=recTypeSCFeasibility;
            } 
            else if(checklistType==IPM_ConstantUtils.RND_FEASIBILITY){
                checklistRecordType=recTypeRnDFeasibility;
            }
            else if(checklistType==IPM_ConstantUtils.RND){ 
                checklistRecordType=recTypeRnD;
            }
            else if(checklistType==IPM_ConstantUtils.TRADEMARK_RECORD_TYPE){ 
                checklistRecordType=recTypeTrademark;
            }
            if(String.isNotBlank(checklistRecordType) && gateType != NULL){
                //Getting Supply Chain Questionnaires for Project
                quesList=[SELECT ID,IPM_Question__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_RQS_Gate_Type__c,
                          IPM_Section_Sequence_Number__c,IPM_Sequence_Number__c,IPM_Section_External_Id__c,IPM_GK_Answers__c,IPM_Comments__c ,IPM_Project__c,RecordTypeId 
                          FROM IPM_Questionnaire__c 
                          WHERE RecordTypeId=:checklistRecordType AND IPM_Project__c=:projectID AND IPM_RQS_Gate_Type__c=:gateType];
            }
            
        }
        
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATEKEEPERCHECKLIST_STR,
                                                  GET_CHECKLIST_QUESTIONS_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
}