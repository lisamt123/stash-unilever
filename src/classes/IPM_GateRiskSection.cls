/****************************************************************************************************************************
@Author Cognizant
@name IPM_GateRiskSection
@CreateDate 03/01/2015
@Description Controller for the Risk section in Charter gate document
@Version 1.0
@reference IPM_GateRiskSection component
*/
public with sharing class IPM_GateRiskSection{   
    //For exception handling
    private static final string CLASS_NAME = IPM_GateRiskSection.class.getName();
    private static final string RMP_PLAN='rmpPlan';
    private static final string SAVE_COMMENT='saveComment';  
    public List<IPM_Questionnaire__c> questionsList{get;set;} //to get list of all question types
    public List<IPM_Questionnaire__c> posQuestionsList{get;set;} //to get the list of the pos Question
    public List<IPM_Questionnaire__c> displayRQSQuestionsList {get;set;}//to get the list of the RQS Question
    public List<IPM_Questionnaire__c> displayCRQuestionsList {get;set;}//to get the list of the Corporate Question
    public string projDocType{get;set;}//to get the gate document type
    public ID projectId{ //to get the project id from teh component attribute
        get {
            return projectId;
        }
        set {
            projectId= value;//to get the project id from teh component attribute
            rmpPlan();//call the RMP plan to be displayed
            setRenderValues();
        }
    }
    public boolean edit{ //boolean for editable
        get {
            return edit;
        }
        set {
            edit= value;
        }
    }    
    public static  ID recTypeIDRQS {get;set;} //Record type ID for RQS Questionnaire
    public static  ID recTypeIDCR {get;set;} //Record type ID for Corporate Risk Questionnaire   
    public static  ID recTypeIDPOS  {get;set;}//Record type ID for POS Questionnaire
    public ID projDocSecId{get; set;}// the project doc section id
    public Boolean IsEditable{get;set;}//boolean for editable
    public  Boolean generateRisk{get;set;}//to generate risk
    public Id quesId{get; set;}//to get the question ID
    public string comments{get; set;}// to get the comments against risk
    public Set<String> riskCategories {get;set;} //to get the categories of risks
    
    public Boolean isMarketDeployment{get;set;}
    public Boolean isMarketReady{get;set;}
    public Boolean isCharter{get;set;}
    public Boolean isContract{get;set;}
    /***************************************************************************************************************************************
    *  @description Functions to display the RMP questions. 
    *  @name rmpPlan
    *  @param none
    *  @return void
    *  @throws Exception 
    */
    public void rmpPlan(){
        try{
            //Getting Record Type Ids
            recTypeIDPOS =Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.POS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
            recTypeIDRQS=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RQS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
            recTypeIDCR=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.CORPORATE_RISK_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
           
            //List of questionnaires to diaplay
            questionsList=[SELECT Id,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_RQS_Gate_Type__c,IPM_RQS_Question_Type__c,IPM_Comments__c,
                                  IPM_Project__c ,IPM_Sequence_Number__c,IPM_POS_Question_Type__c,RecordTypeId,IPM_Score__c,IPM_Question_Help_Text__c,IPM_Active_RQS__c,
                                  IPM_Is_Added_Question__c,IPM_Show_Create_Link__c,IPM_Charter_Comments__c,IPM_Contract_Comments__c,IPM_Market_Ready_Comments__c,
                                  IPM_Market_Deployment_Comments__c,IPM_Charter_Score__c,IPM_Contract_Score__c,IPM_Market_Deployment_Score__c,IPM_Market_Ready_Score__c 
                           FROM IPM_Questionnaire__c
                           WHERE IPM_Project__c =:projectId AND (RecordTypeId=:recTypeIDPOS OR RecordTypeId=:recTypeIDRQS OR RecordTypeId=:recTypeIDCR) ORDER BY IPM_Sequence_Number__c];
            
            
            posQuestionsList= new List<IPM_Questionnaire__c>();
            displayRQSQuestionsList=new List<IPM_Questionnaire__c>();
            displayCRQuestionsList=new List<IPM_Questionnaire__c>();
            riskCategories=new Set<String>();
            //Getting list of POS,RQS questions
            if(questionsList!=null && !questionsList.isEmpty()){
                for(IPM_Questionnaire__c ques:questionsList){
                    if(ques.RecordTypeId==recTypeIDPOS){
                        posQuestionsList.add(ques);
                    }
                    if(ques.RecordTypeId==recTypeIDRQS && ques.IPM_Active_RQS__c && ((projDocType==IPM_ConstantUtils.CHARTER_GATE && ques.IPM_Charter_Score__c >= IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE) ||
                        (projDocType==IPM_ConstantUtils.CONTRACT_GATE && ques.IPM_Contract_Score__c >= IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE) ||
                        (projDocType==IPM_ConstantUtils.MARKET_READY_GATE && ques.IPM_Market_Ready_Score__c >= IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE) ||
                        (projDocType==IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE && ques.IPM_Market_Deployment_Score__c >= IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE))){
                            displayRQSQuestionsList.add(ques);
                            riskCategories.add(ques.IPM_RQS_Question_Type__c);
                    }
                }               
                if(posQuestionsList != null && !posQuestionsList.isEmpty()){
                    if(posQuestionsList[0].IPM_Show_Create_Link__c){
                        generateRisk=false;
                    }
                    else{
                        generateRisk=true;
                    }
                }
            }
            //Getting list of Corporate risk questions
            if(projDocType==IPM_ConstantUtils.CONTRACT_GATE || projDocType==IPM_ConstantUtils.MARKET_READY_GATE || projDocType==IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE){
                for(IPM_Questionnaire__c crs:questionsList){
                    if(crs.RecordTypeId==recTypeIDCR && ((projDocType==IPM_ConstantUtils.CHARTER_GATE && crs.IPM_Charter_Score__c >= IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE) ||
                        (projDocType==IPM_ConstantUtils.CONTRACT_GATE && crs.IPM_Contract_Score__c >= IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE) ||
                        (projDocType==IPM_ConstantUtils.MARKET_READY_GATE && crs.IPM_Market_Ready_Score__c >= IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE) ||
                        (projDocType==IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE && crs.IPM_Market_Deployment_Score__c >= IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE))){
                            displayCRQuestionsList.add(crs);
                    }
                }
                generateRisk=true;
            }  
        } 
        catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                RMP_PLAN,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
        }
    }
    
    /***************************************************************************************************************************************
    *  @description Functions to save the comments for RMP questions. 
    *  @name saveComment
    *  @param none
    *  @return void
    *  @throws DmlException 
    */
    public void saveComment(){
       IPM_Questionnaire__c question=new IPM_Questionnaire__c();
        if(!string.isBlank(quesId)){
            try{
                question.Id=quesId;
                if(projDocType==IPM_ConstantUtils.CHARTER_GATE){
                    question.IPM_Charter_Comments__c=comments;
                    question.IPM_Contract_Comments__c=comments;
                    question.IPM_Market_Ready_Comments__c=comments;
                    question.IPM_Market_Deployment_Comments__c=comments;
                }
                else if(projDocType==IPM_ConstantUtils.CONTRACT_GATE){
                    question.IPM_Contract_Comments__c=comments;
                    question.IPM_Market_Ready_Comments__c=comments;
                    question.IPM_Market_Deployment_Comments__c=comments;
                }
                else if(projDocType==IPM_ConstantUtils.MARKET_READY_GATE){
                    question.IPM_Market_Ready_Comments__c=comments;
                    question.IPM_Market_Deployment_Comments__c=comments;
                }
                else if(projDocType==IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE){
                    question.IPM_Market_Deployment_Comments__c=comments;
                }
                update question;//there will always be single record with the ID
            }
             catch (DmlException ex) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                    SAVE_COMMENT,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
           }
        }
    }
    
    /***************************************************************************************************************************************
    *  @description Functions to set up rendering conditions. 
    *  @name setRenderValue
    *  @param none
    *  @return void
    *  @throws DmlException 
    */
    public void setRenderValues(){
        if(projDocType.Equals(IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE))
        {
            isMarketDeployment=true;
        }
        if(projDocType.Equals(IPM_ConstantUtils.MARKET_READY_GATE)) 
        { 
            isMarketReady=true;
        }
        if(projDocType.Equals(IPM_ConstantUtils.CHARTER_GATE))
        {
            isCharter=true;
        }
        if(projDocType.Equals(IPM_ConstantUtils.CONTRACT_GATE))
        {
            isContract=true;
        }    
    }
}