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
    private static final String GET_RECORDTYPEID_STR='getRecordTypeId';
    //Initializing Variables
    public static  ID recTypeGK; //Contains Gatekeeper Check list Record type Id
    public static  ID recTypeRnD; //Contains R&D  Record type Id
    public static  ID recTypeRnDFeasibility; //Contains R&D Feasibility  Record type Id
    public static  ID recTypeSCFeasibility; //Contains SC Feasibility  Record type Id
    public static  ID recTypeTrademark;//Contains Trademark Feasibility  Record type Id
     
    public static list<IPM_Questionnaire__c> gkChecklist{get;set;} //Contains Gatekeeper Check list Questions
    public static list<IPM_Questionnaire__c> quesList{get; set;} //Contains feasibility and rnd questions
    public IPM_Questionnaire__c gkCheck{get; set;} //Contains Gatekeeper Check list Record
    public Id quesId{get; set;} //Questionnaire Record Id
    public string comment{get; set;} //Comments for Questionnaire
    public string ans{get; set;} //Answer for Questionnaire
    public Boolean isEditable{get;set;} //To Check Read Only Mode or Editable
    public ID projectID{get;set;} //Project Id
    public Boolean cmts{get; set;} //Used for updating comments and Check list Value
    public IPM_Project_Document_Section__c  projDocSec {get;set;} //Contains Project Document Section Record
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
        IPM_IECompatible.ieFix();//For IE Compatibility
        projectID=ApexPages.currentPage().getParameters().get('Id'); 
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
    public void getGKChecklist(){
        try{
            //Retrieving Record Type Ids
            getRecordTypeId();  
            String query='SELECT ID,IPM_Section_External_Id__c,IPM_Question__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_Partly__c,IPM_HelpText_No__c,IPM_RQS_Gate_Type__c,IPM_Section_Sequence_Number__c,IPM_Sequence_Number__c,IPM_GK_Answers__c,IPM_Comments__c ,IPM_Project__c,RecordTypeId,IPM_Project_Document_Section__c,IPM_Project_Document_Section__r.IPM_Section_Name__c FROM IPM_Questionnaire__c WHERE IPM_RQS_Gate_Type__c=:gateType AND RecordTypeId=:recTypeGK AND IPM_Project__c=:projectID';
            if(projDocSec!=null){
                string projDocSecSequence=string.escapeSingleQuotes(projDocSec.IPM_Section_Sequence__c);//exception of unused local varaibale of Sonar. Used in below query
                gkChecklist=Database.query(query+' AND IPM_Section_Sequence_Number__c=:projDocSecSequence order by IPM_Sequence_Number__c ASC LIMIT 50000');
            }
            else{
                gkChecklist=Database.Query(query+' order by IPM_Sequence_Number__c ASC LIMIT 50000');
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
    public pageReference updateGKchecklist(){
        if(quesId != null)  {
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
            if(String.isNotBlank(checklistRecordType)){
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