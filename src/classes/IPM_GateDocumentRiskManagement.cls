/****************************************************************************************************************************
@Author Cognizant
@name IPM_GateDocumentRiskManagement
@CreateDate 03/01/2015
@Description Created function to generated POS questions for the risk section in gate documents
@Version 1.0
@reference IPM_Risk_Management component
*/
public with sharing class IPM_GateDocumentRiskManagement{ 
    //variables
    private static final String IPM_GATE_DOCUMENT_RISK_MANAGEMENT = IPM_GateDocumentRiskManagement.class.getName();
    private static final string SAVE_SCORE = 'saveScore';
    private static final string PROCEED_METHOD = 'proceed';
    private static final string DELETE_QUESTION = 'deleteQuestion';
    private static final string ADD_QUESTION = 'addQuestion';
    private static final string SAVE_RQS_SCORE = 'saveRQSScore';
    private static final string GET_RECORDTYPE_ID = 'getRecordTypeId';
    private static final string GET_RECORDS = 'getRecords';
    public static  ID recTypeIDPOS; // Record type ID for POS Questionnaire
    public static  ID recTypeIDRQS; //Record type ID for RQS Questionnaire
    public static  ID recTypeIDCR; //Record type ID for Corporate Risk Questionnaire
    public List<IPM_POS_RQS_Mapping__c> posRQSMapping;// list from the custom settings for the POS RQS mapping
    public Id qId{get; set;}// to get the question  of the RQS questions
    public Integer score{get; set;} //to get the score(weightage) of the risk question
    public Boolean isAdd{get; set;} //if a custom question is added
    public IPM_Questionnaire__c question{get;set;}//instance of the Questionnaire object
    public static List<IPM_Questionnaire__c> questions {get;set;}//list of the master POS,RQS questions from Questionnaire Object
    public List<IPM_Questionnaire__c> questionsList{get;set;} //to get list of all question types
    public List<IPM_Questionnaire__c> posQuestionsList{get; set;}//POS questions list variable used for logic
    public List<IPM_Questionnaire__c> rqsQuestionsList {get;set;}//RQS questions list variable used for logic
    public List<IPM_Questionnaire__c> crQuestionsList {get;set;}//Corporate Risk questions list variable used for logic
    public static List<IPM_Questionnaire__c> questionsForProject {get; set;}//For inserting POS,RQS questionnaires for project
    public string isEditableUser{get;set;}// Boolean to indicate if the user has edit rights
    public ID projectId{get; set;}// to get the project ID from the Risk component referenced in the Gate Document page
    public ID projDocSecId{get; set;}// to get the project docuemtn section ID related to the Risk component referenced in the Gate Document page
    public String[] rqsSeqActiveNumberCharter{get;set;}// stores the list of RQS questions to be active in Charter Gate
    public String[] rqsSeqActiveNumberContract{get;set;}// stores the list of RQS questions to be active in Contract Gate
    public Boolean posComplete{get; set;}// to indicate if POS is completed(used for viewing right questions)
    public String projDocType{get; set;}// to get the proj document type getter setter from component (used like this as componenet value was not setting)   
    public Set<String> riskCategories {get;set;} //to get the categories of risks
    public Set<String> posCategories {get;set;} //to get the categories of POS Questionnaires
    
    
    /***************************************************************************************************************************************
    *  @description Constructor for the class. 
    *  @name IPM_GateDocumentRiskManagement
    */
    public IPM_GateDocumentRiskManagement(){
        projectId=ApexPages.currentPage().getParameters().get('Id'); 
        projDocSecId=ApexPages.currentPage().getParameters().get('projDocSecId');
        projDocType=ApexPages.currentPage().getParameters().get('gateType');
        isEditableUser=ApexPages.currentPage().getParameters().get('IsEditable');
        backToPos();
        question=new IPM_Questionnaire__c();
        riskCategories=new Set<String>();
        posCategories=new Set<String>();
        getPOSList(); // calling function to display the POS list     
    }
    
    /***************************************************************************************************************************************
    *  @description function to get record type id. 
    *  @name getRecordTypeId
    *  @param none
    *  @return void
    *  @throws Exception 
    */
    public static void getRecordTypeId(){
        try{
            recTypeIDPOS=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.POS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
            recTypeIDRQS=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RQS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
            recTypeIDCR=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.CORPORATE_RISK_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
        }
        catch (Exception ex) {
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATE_DOCUMENT_RISK_MANAGEMENT,
                GET_RECORDTYPE_ID,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    /***************************************************************************************************************************************
    *  @description function to get POS,RQS,Corporate Risk Questions for displaying in page. 
    *  @name getRecords
    *  @param none
    *  @return void
    *  @throws Exception 
    */
    public void getRecords(){
        try{
             //List of questionnaires to diaplay
            questionsList=[SELECT Id,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_HelpText_Five__c,IPM_Question__c,IPM_RQS_Gate_Type__c,IPM_RQS_Question_Type__c,IPM_Comments__c,IPM_Is_Added_Question__c,
                                  IPM_Project__c ,IPM_Sequence_Number__c,IPM_POS_Question_Type__c,RecordTypeId,IPM_Score__c,IPM_Question_Help_Text__c,IPM_Active_RQS__c,IPM_Show_Create_Link__c,IPM_Charter_Comments__c,
                                  IPM_Contract_Comments__c,IPM_Market_Ready_Comments__c,IPM_Market_Deployment_Comments__c,IPM_Charter_Score__c,IPM_Contract_Score__c,IPM_Market_Deployment_Score__c,IPM_Market_Ready_Score__c
                           FROM IPM_Questionnaire__c
                           WHERE IPM_Project__c =:projectId AND (RecordTypeId=:recTypeIDPOS OR RecordTypeId=:recTypeIDRQS OR RecordTypeId=:recTypeIDCR) ORDER BY IPM_Sequence_Number__c LIMIT 1000];
            
            //Getting list of POS,RQS questions
            posQuestionsList=new List<IPM_Questionnaire__c>();
            rqsQuestionsList=new List<IPM_Questionnaire__c>();
            crQuestionsList=new List<IPM_Questionnaire__c>();
            riskCategories=new Set<String>();
            if(questionsList!=null && !questionsList.isEmpty()){           
                for(IPM_Questionnaire__c ques:questionsList){
               
                    if(ques.RecordTypeId==recTypeIDPOS){
                        
                        posQuestionsList.add(ques);
                        posCategories.add(ques.IPM_POS_Question_Type__c);
                    }
                    if(ques.RecordTypeId==recTypeIDRQS && (ques.IPM_Active_RQS__c || ques.IPM_Is_Added_Question__c)){
                        if(projDocType==IPM_ConstantUtils.CHARTER_GATE && projDocType==ques.IPM_RQS_Gate_Type__c){
                            rqsQuestionsList.add(ques);
                            riskCategories.add(ques.IPM_RQS_Question_Type__c);
                        }
                        else if(projDocType==IPM_ConstantUtils.CONTRACT_GATE){
                            rqsQuestionsList.add(ques);
                            riskCategories.add(ques.IPM_RQS_Question_Type__c);
                        }
                    }
                }               
                //Getting list of Corporate risk questions
                if(projDocType==IPM_ConstantUtils.CONTRACT_GATE){
                    for(IPM_Questionnaire__c crs:questionsList){
                        if(crs.RecordTypeId==recTypeIDCR && crs.IPM_Active_RQS__c){
                            crQuestionsList.add(crs);
                        }
                    }
                }
            }         
        }
        catch (Exception ex) {
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATE_DOCUMENT_RISK_MANAGEMENT,
                GET_RECORDS,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    /***************************************************************************************************************************************
    *  @description Function to fetch the POS list of questionnaire. 
    *  @name getPOSList
    *  @param None
    *  @return void
    */
    public void getPOSList(){
        //Getting RecordType Id
        getRecordTypeId();
        getRecords();
        if(projDocType==IPM_ConstantUtils.CONTRACT_GATE){
            posComplete=true;
        }
    }
    
    /***************************************************************************************************************************************
    *  @description Function to save the POS question response. 
    *  @name saveScore
    *  @param None
    *  @return void
    *  @throws Exception 
    */
    public void saveScore(){
        if(posQuestionsList!=null && !posQuestionsList.isEmpty()){
            for(IPM_Questionnaire__c pos:posQuestionsList){
                pos.IPM_Show_Create_Link__c=false;
                if(!String.isBlank(qId) && pos.Id==qId){
                    pos.IPM_Score__c=score;
                }
            }
            try{
                update posQuestionsList;
                getPOSList();
            }
            catch(DMLException ex){
            	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATE_DOCUMENT_RISK_MANAGEMENT,
                	SAVE_SCORE,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
            }
        }
    }
    
    /***************************************************************************************************************************************
    *  @description Function to save the RQS question response. 
    *  @name saveRQSScore
    *  @param None
    *  @return void
    *  @throws Exception 
    */
    public void saveRQSScore(){
        try{ 
            if(!String.isBlank(qId)){
                question=new IPM_Questionnaire__c();
                question.Id=qId;
                if(projDocType==IPM_ConstantUtils.CHARTER_GATE){
                    question.IPM_Charter_Score__c=score;
                    question.IPM_Contract_Score__c=score;
                    question.IPM_Market_Ready_Score__c=score;//it is being added because if user has not updated risk question at contract then also it get copied to MR gate
                	question.IPM_Market_Deployment_Score__c=score;
                }
                else if(projDocType==IPM_ConstantUtils.CONTRACT_GATE){
                	question.IPM_Contract_Score__c=score;
                	question.IPM_Market_Ready_Score__c=score;
                	question.IPM_Market_Deployment_Score__c=score;
                }
                question.IPM_Active_RQS__c=true;
                update question;// its unique record hence not in list
            }   
        }
        catch(DMLException ex){
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATE_DOCUMENT_RISK_MANAGEMENT,
                SAVE_RQS_SCORE,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }  
    
    /***************************************************************************************************************************************
    *  @description function to generate RQS questions Based on POS selections. 
    *  @name proceed
    *  @param None
    *  @return PageReference
    *  @throws Exception 
    */
    public PageReference proceed(){
        /*Starting Point for Activating RQS*/
        List<IPM_Questionnaire__c> rqsQuestionsList=new List<IPM_Questionnaire__c>(); // List of POS,RQS Questionnaires list
        List<IPM_Questionnaire__c> activatePosQuestionList=new List<IPM_Questionnaire__c>(); // list of POS questions
        List<IPM_Questionnaire__c> activateRqsQuestionsList=new List<IPM_Questionnaire__c>(); // list of RQS questions
        List<IPM_Questionnaire__c> activateContractRqsQuestionsList=new List<IPM_Questionnaire__c>(); // list of RQS generated questions
        List<IPM_Questionnaire__c> deActivateRqsQuestionsList=new List<IPM_Questionnaire__c>(); // deactivated RQS list
        try{
        //Getting RecordType Id
        getRecordTypeId();
        rqsQuestionsList=[SELECT Id,IPM_HelpText_Yes__c,IPM_Is_Added_Question__c,IPM_Question_Help_Text__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c,IPM_RQS_Gate_Type__c,
                                 IPM_Sequence_Number__c,IPM_POS_Question_Type__c,RecordTypeId,IPM_Score__c,IPM_Show_Create_Link__c,IPM_HelpText_Five__c,IPM_RQS_Question_Type__c,IPM_Charter_Comments__c,
                                 IPM_Contract_Comments__c,IPM_Market_Ready_Comments__c,IPM_Market_Deployment_Comments__c,IPM_Charter_Score__c,IPM_Contract_Score__c,IPM_Market_Deployment_Score__c,IPM_Market_Ready_Score__c
                          FROM IPM_Questionnaire__c 
                          WHERE IPM_Project__c =:projectId AND (RecordTypeId =: recTypeIDPOS OR RecordTypeId =: recTypeIDRQS) ORDER BY IPM_Sequence_Number__c];
        
        //Getting list of POS,RQS questions
        if(rqsQuestionsList!=null && !rqsQuestionsList.isEmpty()){
            for(IPM_Questionnaire__c ques:rqsQuestionsList){
                if(ques.RecordTypeId==recTypeIDPOS && ques.IPM_Score__c >= IPM_ConstantUtils.POS_QUESTIONNAIRE_SCORE){
                    activatePosQuestionList.add(ques);
                }
                if(ques.RecordTypeId==recTypeIDRQS && (!ques.IPM_Is_Added_Question__c)){
                    deActivateRqsQuestionsList.add(ques);
                }
            }
        }
        posRQSMapping=new List<IPM_POS_RQS_Mapping__c>();
        posRQSMapping=IPM_POS_RQS_Mapping__c.getAll().values();
        
        Set<Integer> activeNumberCharter=new Set<Integer>();// set integers of the active RQS questions in Charter
        Set<Integer> activeNumberContract=new Set<Integer>();// set integers of the active RQS questions in Contract
        
        for(Integer i=0;i<activatePosQuestionList.size();i++){
            for(IPM_POS_RQS_Mapping__c prm : posRQSMapping){
                if(activatePosQuestionList[i].IPM_Score__c>=prm.Score__c && prm.Name==activatePosQuestionList[i].IPM_POS_Question_Type__c){
                    rqsSeqActiveNumberCharter=prm.Charter__c.split(',');
                    rqsSeqActiveNumberContract=prm.Contract__c.split(',');
                }
            }
            for(Integer j=0;j<rqsSeqActiveNumberCharter.size();j++){
                activeNumberCharter.add(Integer.valueOf(rqsSeqActiveNumberCharter[j]));
            }
            for(Integer k=0;k<rqsSeqActiveNumberContract.size();k++){
                activeNumberContract.add(Integer.valueOf(rqsSeqActiveNumberContract[k]));
            }
        }
        
        for(IPM_Questionnaire__c rqRQS : deActivateRqsQuestionsList){
            rqRQS.IPM_Active_RQS__c=false;
        }
        if(deActivateRqsQuestionsList != NULL && !deActivateRqsQuestionsList.isEmpty()){
            update deActivateRqsQuestionsList;
        }
        if(projDocType==IPM_ConstantUtils.CHARTER_GATE){
            activateRqsQuestionsList=[SELECT Id,IPM_Is_Added_Question__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_RQS_Question_Type__c,
                                             IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c,IPM_Charter_Comments__c,
                                             IPM_Contract_Comments__c,IPM_Market_Ready_Comments__c,IPM_Market_Deployment_Comments__c,IPM_Charter_Score__c,IPM_Contract_Score__c,IPM_Market_Deployment_Score__c,IPM_Market_Ready_Score__c 
                                      FROM IPM_Questionnaire__c 
                                      WHERE RecordTypeId =: recTypeIDRQS  AND IPM_Project__c =:projectId  AND IPM_Sequence_Number__c in:activeNumberCharter];
            
            activateContractRqsQuestionsList=[SELECT Id,IPM_Is_Added_Question__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_RQS_Question_Type__c,
                                                     IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c,IPM_Charter_Comments__c,
                                                     IPM_Contract_Comments__c,IPM_Market_Ready_Comments__c,IPM_Market_Deployment_Comments__c,IPM_Charter_Score__c,IPM_Contract_Score__c,IPM_Market_Deployment_Score__c,IPM_Market_Ready_Score__c 
                                              FROM IPM_Questionnaire__c 
                                              WHERE RecordTypeId =: recTypeIDRQS  AND IPM_Project__c =:projectId  AND IPM_Sequence_Number__c in:activeNumberContract];    
        }
        for(IPM_Questionnaire__c rqRQS : activateRqsQuestionsList){
            rqRQS.IPM_Active_RQS__c=true;
        }
        if(activateRqsQuestionsList != NULL && !activateRqsQuestionsList.isEmpty()){
            update activateRqsQuestionsList;
        }   
        
        for(IPM_Questionnaire__c crqRQS : activateContractRqsQuestionsList){
            crqRQS.IPM_Active_RQS__c=true;
        }
        if(activateContractRqsQuestionsList != NULL && !activateContractRqsQuestionsList.isEmpty()){
            update activateContractRqsQuestionsList;
        }
        getRecords();   
        posComplete=true;
        }
        catch(DMLException ex){
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATE_DOCUMENT_RISK_MANAGEMENT,
                PROCEED_METHOD,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
        catch(Exception ex){
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATE_DOCUMENT_RISK_MANAGEMENT,
                PROCEED_METHOD,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
        }                
        return null;
    }
    
    /***************************************************************************************************************************************
    *  @description function to view RISK Mitigation Plan based on RQS and Corporate Risk Selections. 
    *  @name generateMitigationPlan
    *  @param None
    *  @return PageReference
    */
    public PageReference generateMitigationPlan(){
    	String suffix = 'RiskIdentified__c';
        IPM_Project__c proUpdate = new IPM_Project__c(id = projectId);
        proUpdate.put(projDocType+suffix,true);
        update proUpdate;
        //Getting RecordType Id
        getRecordTypeId();
        getRecords();
        return null;
    }

    /***************************************************************************************************************************************
    *  @description to add custom and Display RQS RISK question. 
    *  @name addQuestion
    *  @param none
    *  @return void
    *  @throws Exception 
    */
    public void addQuestion(){
        //Getting RecordType Id
        getRecordTypeId();
        if(String.isBlank(question.IPM_RQS_Question_Type__c)){
            Apexpages.addmessage(new apexpages.message(apexpages.severity.warning,System.Label.IPM_SELECT_QUESTION_TYPE));
        }
        else if(String.isBlank(question.IPM_Question__c)){
            Apexpages.addmessage(new apexpages.message(apexpages.severity.warning,System.Label.IPM_ENTER_QUESTION));
        }
        else{
        	question.IPM_Project__c=projectId;
            question.RecordtypeId=recTypeIDRQS;
            question.IPM_Active_RQS__c=true;
            question.IPM_RQS_Gate_Type__c=projDocType;
            question.IPM_Is_Added_Question__c=true;
            try{
                if(question!=null){
                    insert question; // always will be 1 record hence done directly
                }
            }
            catch(DMLException ex){
            	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATE_DOCUMENT_RISK_MANAGEMENT,
                	ADD_QUESTION,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            }
            catch(Exception ex){
            	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATE_DOCUMENT_RISK_MANAGEMENT,
                	ADD_QUESTION,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION);
            }
            getRecords();
            stayRQSPage();
            question=new IPM_Questionnaire__c();//clear view state
        }
    }
    
    /***************************************************************************************************************************************
    *  @description To stay on the rqs page. 
    *  @name stayRQSPage
    *  @param none
    *  @return void
    */
    public void stayRQSPage(){
        posComplete=true;
        isAdd=false;
    }
    
    /***************************************************************************************************************************************
    *  @description To change the View based on the type of Gate. 
    *  @name changeQuestionView
    *  @param none
    *  @return void
    */
    public void changeQuestionView(){
        isAdd=true;
        posComplete=false;
    }
    
    /***************************************************************************************************************************************
    *  @description To cancel the question and redirect to pervious view of RQS and Corporate risk questions. 
    *  @name cancelQuestion
    *  @param none
    *  @return void 
    */
    public void cancelQuestion(){
        //Getting RecordType Id
        getRecordTypeId();
        getRecords();
        stayRQSPage();
    }
    
    /***************************************************************************************************************************************
    *  @description To enable view of to be back to POS list at Carter Document level. 
    *  @name backToPos
    *  @param NONE
    *  @return void
    */
    public void backToPos(){
        posComplete=false;
        isAdd=false;
    }
    
    /***************************************************************************************************************************************
    *  @description To Delete custom added risk question. 
    *  @name deleteQuestion
    *  @param none
    *  @return void
    *  @throws Exception 
    */
    public void deleteQuestion(){
    	try{
	        //Getting RecordType Id
	        getRecordTypeId();
	        if(!string.isBlank(qId)){
	            IPM_Questionnaire__c userQuestion=new IPM_Questionnaire__c();
	            userQuestion.Id=qId;
	            delete userQuestion;
	        }
    	}     
        catch(Exception ex){
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_GATE_DOCUMENT_RISK_MANAGEMENT,
            	DELETE_QUESTION,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,IPM_ConstantUtils.IPM_NG_APPLICATION); 
        }
        //Getting records  to display
        getRecords();
        stayRQSPage();
    }
}