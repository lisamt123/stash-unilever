public class IPM_GateRiskSection
{

    public List<IPM_Questionnaire__c> posQuestionsList{get;set;}
    public List<IPM_Questionnaire__c> displayRQSQuestionsList {get;set;}
    public List<IPM_Questionnaire__c> displayCRQuestionsList {get;set;}
    public string projDocType{get;set;}
    public ID projectId{ 
        get {
            return projectId;
        }
        set {
            projectId= value;
            rmpPlan();
            
        }}
        
    public boolean edit{ 
        get {
            return edit;
        }
        set {
            edit= value;
        }}    
    Public static  ID recTypeIDRQS {get;set;} //Record type ID for RQS Questionnaire
    Public static  ID recTypeIDCR {get;set;} //Record type ID for Corporate Risk Questionnaire   
     Public static  ID recTypeIDPOS  {get;set;}
   
    Public ID projDocSecId{get; set;}
    Public Boolean IsEditable{get;set;}
     public  Boolean generateRisk{get;set;}
     public Id quesId{get; set;}
     public string comments{get; set;}

    public void rmpPlan()
    {
        system.debug('Risk getting Called');
        recTypeIDPOS =Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('POS Questionnaire').RecordTypeId;
        posQuestionsList=[SELECT ID,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_POS_Question_Type__c,RecordTypeId,IPM_Score__c,IPM_Is_Added_Question__c,IPM_Show_Create_Link__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDPOS  AND IPM_Project__c =:projectId order by IPM_Sequence_Number__c];
        
        if(posQuestionsList.size()>0)    
        {
            if(posQuestionsList[0].IPM_Show_Create_Link__c==true)
            {
                generateRisk=false;
            }
            else
            {
                generateRisk=true;
            }
       }
            recTypeIDRQS=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('RQS Questionnaire').RecordTypeId;
            displayRQSQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_RQS_Question_Type__c,IPM_Comments__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS AND IPM_Project__c =:projectId and IPM_Score__c >= 4 order by IPM_RQS_Question_Type__c];
            if(projDocType=='Contract')
            {
                recTypeIDCR=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('Corporate Risk').RecordTypeId;
               
                
                displayCRQuestionsList=[SELECT ID,IPM_Comments__c,IPM_Is_Added_Question__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDCR  AND IPM_Project__c =:projectId  and IPM_Score__c >= 4 and IPM_Active_RQS__c=true order by IPM_Sequence_Number__c];
               
            }   
    }
    
     public void saveComment()
    {
        System.debug(quesId+'quesId');  
        if(quesId!=null)
        {
            IPM_Questionnaire__c rqsQuestion=[SELECT ID,IPM_Is_Added_Question__c,IPM_POS_Question_Type__c ,IPM_HelpText_Five__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE Id=:quesId];
            rqsQuestion.IPM_Comments__c=comments;
            update rqsQuestion;
        }
    }

}