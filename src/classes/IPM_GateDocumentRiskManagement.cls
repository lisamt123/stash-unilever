/*

Version 1.0 : POS questions for the risk section
Date: 03/01/2015
Changelog :  [Samrat Chakraborty]: Created function to generated POS questions for the risk section in gate documents

*/

public class IPM_GateDocumentRiskManagement
{

    //variables
    public Id qId{get; set;}
    public Id quesId{get; set;}
    public string comments{get; set;}
    public Integer score{get; set;}
    public Boolean isAdd{get; set;}
    Public IPM_Questionnaire__c Question{get;set;}
    Public static List<IPM_Questionnaire__c> posQuestions {get;set;}
    Public static List<IPM_Questionnaire__c> rqsQuestions {get;set;}
    Public List<IPM_Questionnaire__c> rqsQuestionsList {get;set;}
    Public List<IPM_Questionnaire__c> crQuestionsList {get;set;}
    public List<IPM_Questionnaire__c> displayRQSQuestionsList {get;set;}
    public List<IPM_Questionnaire__c> displayCRQuestionsList {get;set;}
    Public static List<IPM_Questionnaire__c> posQuestionsForProject=new List<IPM_Questionnaire__c>();
    Public static List<IPM_Questionnaire__c> rqsQuestionsForProject=new List<IPM_Questionnaire__c>();
    Public Boolean IsEditable{get;set;}
    Public string isEditableUser{get;set;}
    public List<IPM_POS_RQS_Mapping__c> posRQSMapping  {get;set;}

    Public static  ID recTypeIDPOS {get;set;} // Record type ID for POS Questionnaire
    Public static  ID recTypeIDRQS {get;set;} //Record type ID for RQS Questionnaire
    Public static  ID recTypeIDCR {get;set;} //Record type ID for Corporate Risk Questionnaire
    Public ID projectId{get; set;}
    Public ID projDocSecId{get; set;}
    public Integer score1{get; set;}
    public Integer score3{get; set;}
    public Integer score5{get; set;}

    public  Boolean generateRisk{get;set;}

    public  String[] rqsSeqActiveNumberCharter{get;set;}
    public  String[] rqsSeqActiveNumberContract{get;set;}
    //For Pagination
    public Boolean nextBool{get; set;}
    public Boolean prevBool{get; set;}
    public Integer index = 2;
    public Integer start = 0;
    Public List<IPM_Questionnaire__c> posQuestionsList{get; set;}
    public Integer count=10;
    public Boolean posComplete{get; set;}
    public boolean edit{ 
        get {
            return edit;
        }
        set {
            edit= value;
        }}
    public String projDocType{ 
        get {
            return projDocType;
        }
        set {
            projDocType= value;
            getPOSList();
        }}
    public IPM_GateDocumentRiskManagement()
    {
        projectId=ApexPages.currentPage().getParameters().get('Id'); 
        projDocSecId=ApexPages.currentPage().getParameters().get('projDocSecId');
        projDocType=ApexPages.currentPage().getParameters().get('gateType');
        isEditableUser=ApexPages.currentPage().getParameters().get('IsEditable');
        System.debug(projDocType+'projDocType'+ApexPages.currentPage().getParameters());
        posComplete=false;
        isAdd=false;
        question=new IPM_Questionnaire__c();
        getPOSList();
        //getScore();

    }
    //function to generate the POS for a Project 
    // Parameter required is Project ID
    public static void generatePOSforProject(ID projid)
    {
        System.debug('Entering');
        recTypeIDPOS=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('POS Questionnaire').RecordTypeId;
        recTypeIDRQS=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('RQS Questionnaire').RecordTypeId;

        posQuestions=[SELECT IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_POS_Question_Type__c,RecordTypeId,IPM_Score__c,IPM_Show_Create_Link__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDPOS  AND IPM_Project__c = '' AND Is_Master__c=true];

        rqsQuestions=[SELECT IPM_Is_Added_Question__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_HelpText_Five__c,IPM_RQS_Question_Type__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Score__c,IPM_Show_Create_Link__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS  AND IPM_Project__c = '' AND Is_Master__c=true];

        system.debug('Pos Size---'+posQuestions.size());
        System.debug(projId+'projectId');
        //projId=projid;
        if(posQuestions.size()>0)
        {
            for(IPM_Questionnaire__c rqPOS:posQuestions)
            {
                IPM_Questionnaire__c que=new IPM_Questionnaire__c();
                que.IPM_Project__c=projid;
                que.IPM_HelpText_Yes__c=rqPOS.IPM_HelpText_Yes__c;
                que.IPM_HelpText_No__c=rqPOS.IPM_HelpText_No__c;
                que.IPM_HelpText_Partly__c=rqPOS.IPM_HelpText_Partly__c;               
                que.IPM_Question__c=rqPOS.IPM_Question__c;
                que.IPM_Sequence_Number__c=rqPOS.IPM_Sequence_Number__c;
                que.IPM_POS_Question_Type__c=rqPOS.IPM_POS_Question_Type__c;
                que.RecordTypeId=recTypeIDPOS;
                que.IPM_Show_Create_Link__c=true;
                posQuestionsForProject.add(que);
                
            }
            system.debug('pos list'+posQuestionsForProject);
            if (posQuestionsForProject.isEmpty() == false) {
                try {
                    insert posQuestionsForProject;
                } catch (DmlException e) {
                    // Process exception here
                }
                
            }
            
            if(rqsQuestions.size()>0)
            {
                for(IPM_Questionnaire__c rqRQS:rqsQuestions)
                {
                    IPM_Questionnaire__c que=new IPM_Questionnaire__c();
                    que.IPM_Project__c=projid;
                    que.IPM_Question_Help_Text__c=rqRQS.IPM_Question_Help_Text__c;
                    que.IPM_HelpText_Yes__c=rqRQS.IPM_HelpText_Yes__c;
                    que.IPM_HelpText_No__c=rqRQS.IPM_HelpText_No__c;
                    que.IPM_HelpText_Partly__c=rqRQS.IPM_HelpText_Partly__c;
                    que.IPM_HelpText_Five__c=rqRQS.IPM_HelpText_Five__c;               
                    que.IPM_Question__c=rqRQS.IPM_Question__c;
                    que.IPM_Sequence_Number__c=rqRQS.IPM_Sequence_Number__c;
                    que.IPM_RQS_Gate_Type__c=rqRQS.IPM_RQS_Gate_Type__c;
                    que.IPM_RQS_Question_Type__c=rqRQS.IPM_RQS_Question_Type__c;
                    que.RecordTypeId=recTypeIDRQS;
                    //que.IPM_Show_Create_Link__c=true;
                    rqsQuestionsForProject.add(que);
                    
                }
                if (rqsQuestionsForProject.isEmpty() == false) {
                    try {
                        insert rqsQuestionsForProject;
                    } catch (DmlException e) {
                        // Process exception here
                    }
                    
                }
                
            }
        }
        //getPOSList();
    }

    public void getPOSList()
    {
        recTypeIDPOS=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('POS Questionnaire').RecordTypeId;
        recTypeIDRQS=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('RQS Questionnaire').RecordTypeId;
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
            
            displayRQSQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_RQS_Question_Type__c,IPM_Comments__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS  AND IPM_Project__c =:projectId and IPM_Score__c >= 4 order by IPM_RQS_Question_Type__c];
            System.debug(displayRQSQuestionsList+'displayRQSQuestionsList');
        }
        System.debug(projDocType+'projDocType');
        if(projDocType=='Contract')
        {
            recTypeIDCR=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('Corporate Risk').RecordTypeId;
            generateRisk=true;
            displayRQSQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_RQS_Question_Type__c,IPM_Comments__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS AND IPM_Project__c =:projectId and IPM_Score__c >= 4 order by IPM_RQS_Question_Type__c];
            posComplete=true;
            rqsQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS  AND IPM_Project__c =:projectId  and (IPM_Active_RQS__c=true OR IPM_Is_Added_Question__c=true) order by IPM_Sequence_Number__c];
            displayCRQuestionsList=[SELECT ID,IPM_Comments__c,IPM_Is_Added_Question__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDCR  AND IPM_Project__c =:projectId  and IPM_Score__c >= 4 and IPM_Active_RQS__c=true order by IPM_Sequence_Number__c];
            crQuestionsList=[SELECT ID,IPM_Comments__c,IPM_Is_Added_Question__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDCR  AND IPM_Project__c =:projectId  and IPM_Active_RQS__c=true order by IPM_Sequence_Number__c];
        }   
        
    }

    


    public void saveScore()
    {
        if(posQuestionsList[0].IPM_Show_Create_Link__c==true)
        {
            for (IPM_Questionnaire__c pos:posQuestionsList)
            {
                IPM_Questionnaire__c pShow=new IPM_Questionnaire__c();
                
                pShow.ID=pos.ID;
                pShow.IPM_Show_Create_Link__c=false;
                posQuestionsForProject.add(pShow);
                
                
            }
            if(posQuestionsForProject.size()>0)
            {
                update posQuestionsForProject;
            }
            getPOSList();
        }
        System.debug('Entering'+qId+score+projDocType);
        IPM_Questionnaire__c ques=[Select Id,IPM_Score__c,IPM_POS_Question_Type__c from IPM_Questionnaire__c where Id=:qId];
        ques.IPM_Score__c=score;
        ques.IPM_Show_Create_Link__c=false;
        update ques;
        system.debug('get list pos'+posQuestionsList.size()+'check link' + posQuestionsList[0].IPM_Show_Create_Link__c);
        System.debug(ques+'updated score'+score);       
    }  
    public void saveRQSScore()
    {
        System.debug('Entering RQS'+qId+score);
        IPM_Questionnaire__c ques=[Select Id,IPM_Score__c,IPM_RQS_Question_Type__c from IPM_Questionnaire__c where Id=:qId];
        ques.IPM_Score__c=score;
        update ques;
        System.debug(ques+'updated score'+score);
        // List<IPM_Questionnaire__c> quesList=new List<IPM_Questionnaire__c>();
        //  quesList.add(ques);
    }  
    /*  public void getScore()
    {
        IPM_Questionnaire_Score__c scoreCard=IPM_Questionnaire_Score__c.getInstance('Score');
        score1=Integer.valueOf(scoreCard.Score_1__c);
        score3=Integer.valueOf(scoreCard.Score_3__c);
        score5=Integer.valueOf(scoreCard.Score_5__c);
    } */

    public PageReference proceed()
    {
        /*Starting Point for Activating RQS*/
        List<IPM_Questionnaire__c> activatePosQuestionList=new List<IPM_Questionnaire__c>(); 
        List<IPM_Questionnaire__c> activateRqsQuestionsList=new List<IPM_Questionnaire__c>(); 
        List<IPM_Questionnaire__c> activateContractRqsQuestionsList=new List<IPM_Questionnaire__c>(); 
        List<IPM_Questionnaire__c> deActivateRqsQuestionsList=new List<IPM_Questionnaire__c>();
        recTypeIDPOS=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('POS Questionnaire').RecordTypeId;
        recTypeIDRQS=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('RQS Questionnaire').RecordTypeId;
        activatePosQuestionList=[SELECT ID,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_POS_Question_Type__c,RecordTypeId,IPM_Score__c,IPM_Is_Added_Question__c,IPM_Show_Create_Link__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDPOS  AND IPM_Project__c =:projectId and IPM_Score__c>=3 order by IPM_Sequence_Number__c];
        posRQSMapping=[SELECT Name,Charter__c,Contract__c,Score__c FROM IPM_POS_RQS_Mapping__c];
        Set<Integer> activeNumberCharter=new Set<Integer>();
        Set<Integer> activeNumberContract=new Set<Integer>();
        System.debug(activatePosQuestionList+'activatePosQuestionList');
        for(Integer i=0;i<activatePosQuestionList.size();i++)
        {
            for(IPM_POS_RQS_Mapping__c prm : posRQSMapping)
            {
                if(activatePosQuestionList[i].IPM_Score__c>=prm.Score__c && prm.Name==activatePosQuestionList[i].IPM_POS_Question_Type__c)
                {
                    rqsSeqActiveNumberCharter=(prm.Charter__c.split(','));
                    rqsSeqActiveNumberContract=(prm.Contract__c.split(','));
                }
            }
            for(Integer j=0;j<rqsSeqActiveNumberCharter.size();j++)
            {
                activeNumberCharter.add(Integer.valueOf(rqsSeqActiveNumberCharter[j]));
            }
            for(Integer k=0;k<rqsSeqActiveNumberContract.size();k++)
            {
                activeNumberContract.add(Integer.valueOf(rqsSeqActiveNumberContract[k]));
            }
        }
        deActivateRqsQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_RQS_Question_Type__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS  AND IPM_Project__c =:projectId];
        for(IPM_Questionnaire__c rqRQS : deActivateRqsQuestionsList)
        {
            rqRQS.IPM_Active_RQS__c=false;
        }
        update deActivateRqsQuestionsList;
        System.debug(deActivateRqsQuestionsList+'deActivateRqsQuestionsList');
        if(projDocType=='Charter')
        activateRqsQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_RQS_Question_Type__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS  AND IPM_Project__c =:projectId  and IPM_Sequence_Number__c in:activeNumberCharter];
        //if(projDocType=='Contract')
        activateContractRqsQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_RQS_Question_Type__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS  AND IPM_Project__c =:projectId  and IPM_Sequence_Number__c in:activeNumberContract];    
        for(IPM_Questionnaire__c rqRQS : activateRqsQuestionsList)
        {
            rqRQS.IPM_Active_RQS__c=true;
        }
        update activateRqsQuestionsList;
        for(IPM_Questionnaire__c crqRQS : activateContractRqsQuestionsList)
        {
            crqRQS.IPM_Active_RQS__c=true;
        }
        update activateContractRqsQuestionsList;
        System.debug(activateRqsQuestionsList+'activateRqsQuestionsList');
        posComplete=true;
        

        rqsQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS  AND IPM_Project__c =:projectId  and (IPM_Active_RQS__c=true OR IPM_Is_Added_Question__c=true) order by IPM_Sequence_Number__c];
        System.debug(posComplete+''+rqsQuestionsList);
        return null;
    }
    public PageReference generateMitigationPlan()
    {
        recTypeIDRQS=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('RQS Questionnaire').RecordTypeId;

        rqsQuestionsList=[SELECT ID,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c,IPM_Is_Added_Question__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS  AND IPM_Project__c =:projectId  and IPM_Active_RQS__c=true order by IPM_Sequence_Number__c];
        if(projDocType=='Contract')
        {
            recTypeIDCR=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('Corporate Risk').RecordTypeId;
            rqsQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS  AND IPM_Project__c =:projectId  and (IPM_Active_RQS__c=true OR IPM_Is_Added_Question__c=true) order by IPM_Sequence_Number__c];
            crQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_Comments__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDCR  AND IPM_Project__c =:projectId  and IPM_Active_RQS__c=true order by IPM_Sequence_Number__c];
        }
        System.debug(posComplete+''+rqsQuestionsList);
        return null;
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
    public void addQuestion()
    {
        if(question.IPM_RQS_Question_Type__c==null || question.IPM_RQS_Question_Type__c=='')
        apexpages.addmessage(new apexpages.message(apexpages.severity.warning,'Please Select Question Type'));
        else if(question.IPM_Question__c==null || question.IPM_Question__c=='')
        apexpages.addmessage(new apexpages.message(apexpages.severity.warning,'Please Enter Question'));
        else
        {
            recTypeIDRQS=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('RQS Questionnaire').RecordTypeId;
            question.IPM_Project__c=projectId;
            question.RecordtypeId=recTypeIDRQS;
            question.IPM_Active_RQS__c=true;
            question.IPM_RQS_Gate_Type__c=projDocType;
            question.IPM_Is_Added_Question__c=true;
            Insert question;
            if(projDocType=='Contract')
            {
                recTypeIDCR=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('Corporate Risk').RecordTypeId;
                rqsQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS  AND IPM_Project__c =:projectId  and (IPM_Active_RQS__c=true OR IPM_Is_Added_Question__c=true) order by IPM_Sequence_Number__c];
                crQuestionsList=[SELECT ID,IPM_Comments__c ,IPM_Is_Added_Question__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDCR  AND IPM_Project__c =:projectId  and IPM_Active_RQS__c=true order by IPM_Sequence_Number__c];
            }
            else
            {
                rqsQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS  AND IPM_Project__c =:projectId  and IPM_Active_RQS__c=true order by IPM_Sequence_Number__c];
            }
            PosComplete=true;
            isAdd=false;
            question=new IPM_Questionnaire__c();
        }
    }
    public void changeQuestionView()
    {
        System.debug('Entering Question Action');
        isAdd=true;
        PosComplete=false;
    }
    public void cancelQuestion()
    {
        recTypeIDRQS=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('RQS Questionnaire').RecordTypeId;
        if(projDocType=='Contract')
        {
            recTypeIDCR=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('Corporate Risk').RecordTypeId;
            rqsQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS  AND IPM_Project__c =:projectId  and (IPM_Active_RQS__c=true OR IPM_Is_Added_Question__c=true) order by IPM_Sequence_Number__c];
            crQuestionsList=[SELECT ID,IPM_Comments__c,IPM_Is_Added_Question__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDCR  AND IPM_Project__c =:projectId  and IPM_Active_RQS__c=true order by IPM_Sequence_Number__c];
        }
        else    
        {
            rqsQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS  AND IPM_Project__c =:projectId  and IPM_Active_RQS__c=true order by IPM_Sequence_Number__c];
        }
        PosComplete=true;
        isAdd=false;
    }
    public void backToPos()
    {
        PosComplete=false;
        isAdd=false;
    }
    public void deleteQuestion()
    {
        if(quesId!=null)
        {
            IPM_Questionnaire__c rqsQuestion=[SELECT ID,IPM_Is_Added_Question__c,IPM_POS_Question_Type__c ,IPM_HelpText_Five__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE Id=:quesId];
            delete rqsQuestion;
        }
        recTypeIDRQS=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('RQS Questionnaire').RecordTypeId;
        System.debug(recTypeIDRQS+''+projectId+''+projDocType+'SOQL Values');   
        if(projDocType=='Contract')
        {
            recTypeIDCR=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('Corporate Risk').RecordTypeId;
            rqsQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS  AND IPM_Project__c =:projectId  and (IPM_Active_RQS__c=true OR IPM_Is_Added_Question__c=true) order by IPM_Sequence_Number__c];
            crQuestionsList=[SELECT ID,IPM_Comments__c,IPM_Is_Added_Question__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDCR  AND IPM_Project__c =:projectId  and IPM_Active_RQS__c=true order by IPM_Sequence_Number__c];
        }
        else
        {
            rqsQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS  AND IPM_Project__c =:projectId  and IPM_Active_RQS__c=true order by IPM_Sequence_Number__c];
        }
        PosComplete=true;
        isAdd=false;
    }
    @future
    public static void CharterToContractRiskQuestions(Set<Id> ParentProjId,Set<Id> projectId)
    {
        recTypeIDRQS=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('RQS Questionnaire').RecordTypeId;
        recTypeIDCR=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get('Corporate Risk').RecordTypeId;
        List<IPM_Questionnaire__c> charterQuestionsList=new  List<IPM_Questionnaire__c>();
        List<IPM_Questionnaire__c> contractQuestionsList=new  List<IPM_Questionnaire__c>();
        List<IPM_Questionnaire__c> insertCharterQuestionsList=new  List<IPM_Questionnaire__c>();
        List<IPM_Questionnaire__c> insertContractQuestionsList=new  List<IPM_Questionnaire__c>();
        List<IPM_Questionnaire__c> crQuestionsList=new  List<IPM_Questionnaire__c>();
        List<IPM_Questionnaire__c> insertCRQuestionsList=new  List<IPM_Questionnaire__c>();
        
        charterQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_Comments__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS  and IPM_Project__c In :ParentProjId and (IPM_Active_RQS__c=true OR IPM_Is_Added_Question__c=true) order by IPM_Sequence_Number__c];
        //contractQuestionsList=[SELECT ID,IPM_Is_Added_Question__c,IPM_Comments__c,IPM_HelpText_Five__c ,IPM_POS_Question_Type__c ,IPM_RQS_Question_Type__c,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,IPM_RQS_Gate_Type__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDRQS  AND IPM_RQS_Gate_Type__c='Contract' and IPM_Project__c In :ParentProjId and IPM_Active_RQS__c=true order by IPM_Sequence_Number__c];
        List<IPM_Project__c> projList=new List<IPM_Project__c>();
        projList=[Select Id,IPMProject_Span__c,IPM_Parent_Project__c from IPM_Project__c where Id In:projectId];
        System.debug(charterQuestionsList+'charterQuestionsList');
        for(IPM_Project__c proj:projList)
        {
            if(proj.IPMProject_Span__c=='Regional')
            {
                for(IPM_Questionnaire__c charterQues:charterQuestionsList)
                {
                    if(charterQues.IPM_Project__c==proj.IPM_Parent_Project__c)
                    {
                        IPM_Questionnaire__c que=new IPM_Questionnaire__c();
                        que.IPM_Project__c=proj.Id;
                        que.IPM_Question_Help_Text__c=charterQues.IPM_Question_Help_Text__c;
                        que.IPM_HelpText_Yes__c=charterQues.IPM_HelpText_Yes__c;
                        que.IPM_HelpText_No__c=charterQues.IPM_HelpText_No__c;
                        que.IPM_HelpText_Partly__c=charterQues.IPM_HelpText_Partly__c;
                        que.IPM_HelpText_Five__c=charterQues.IPM_HelpText_Five__c;               
                        que.IPM_Question__c=charterQues.IPM_Question__c;
                        que.IPM_Sequence_Number__c=charterQues.IPM_Sequence_Number__c;
                        que.IPM_RQS_Question_Type__c=charterQues.IPM_RQS_Question_Type__c;
                        que.IPM_Score__c=charterQues.IPM_Score__c;
                        que.IPM_Comments__c=charterQues.IPM_Comments__c;
                        que.IPM_Is_Added_Question__c=charterQues.IPM_Is_Added_Question__c;
                        que.IPM_Active_RQS__c=charterQues.IPM_Active_RQS__c;
                        que.RecordTypeId=recTypeIDRQS;
                        insertCharterQuestionsList.add(que);
                    }
                }
            }
        }
        System.debug(insertCharterQuestionsList+'insertCharterQuestionsList');
        if(insertCharterQuestionsList.size()>0)
        Insert insertCharterQuestionsList;
        /*System.debug(contractQuestionsList+'contractQuestionsList');  
        for(IPM_Project__c proj:projList)
        {
            if(proj.IPMProject_Span__c=='Regional')
            {
                for(IPM_Questionnaire__c contractQues:contractQuestionsList)
                {
                    if(contractQues.IPM_Project__c==proj.IPM_Parent_Project__c)
                    {
                        IPM_Questionnaire__c que=new IPM_Questionnaire__c();
                        que.IPM_Project__c=proj.Id;
                        que.IPM_Question_Help_Text__c=contractQues.IPM_Question_Help_Text__c;
                        que.IPM_HelpText_Yes__c=contractQues.IPM_HelpText_Yes__c;
                        que.IPM_HelpText_No__c=contractQues.IPM_HelpText_No__c;
                        que.IPM_HelpText_Partly__c=contractQues.IPM_HelpText_Partly__c;
                        que.IPM_HelpText_Five__c=contractQues.IPM_HelpText_Five__c;               
                        que.IPM_Question__c=contractQues.IPM_Question__c;
                        que.IPM_Sequence_Number__c=contractQues.IPM_Sequence_Number__c;
                        que.IPM_RQS_Question_Type__c=contractQues.IPM_RQS_Question_Type__c;
                        que.IPM_Active_RQS__c=contractQues.IPM_Active_RQS__c;
                        que.RecordTypeId=recTypeIDRQS;
                        insertContractQuestionsList.add(que);
                    }
                }
            }
        }
        System.debug(insertContractQuestionsList+'insertContractQuestionsList');
        if(insertContractQuestionsList.size()>0)
            Insert insertContractQuestionsList; */
        List<IPM_Project__c> projectList=new List<IPM_Project__c>();
        projectList=[Select Id,IPMProject_Span__c,IPM_Parent_Project__c from IPM_Project__c where Id In:projectId OR Id In:ParentProjId];   
        crQuestionsList=[SELECT ID,IPM_Comments__c,IPM_HelpText_Five__c ,IPM_Question_Help_Text__c,IPM_HelpText_Yes__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_Question__c,IPM_Project__c ,IPM_Sequence_Number__c,Is_Master__c,RecordTypeId,IPM_Active_RQS__c,IPM_Score__c FROM IPM_Questionnaire__c WHERE RecordTypeId =: recTypeIDCR and Is_Master__c=true ];
        System.debug(crQuestionsList+'crQuestionsList');
        for(IPM_Project__c project:projectList)
        {
            for(IPM_Questionnaire__c crQues:crQuestionsList)
            {
                
                IPM_Questionnaire__c que=new IPM_Questionnaire__c();
                que.IPM_Project__c=project.Id;
                que.IPM_Question_Help_Text__c=crQues.IPM_Question_Help_Text__c;
                que.IPM_HelpText_Yes__c=crQues.IPM_HelpText_Yes__c;
                que.IPM_HelpText_No__c=crQues.IPM_HelpText_No__c;
                que.IPM_HelpText_Partly__c=crQues.IPM_HelpText_Partly__c;
                que.IPM_HelpText_Five__c=crQues.IPM_HelpText_Five__c;               
                que.IPM_Question__c=crQues.IPM_Question__c;
                que.IPM_Sequence_Number__c=crQues.IPM_Sequence_Number__c;
                que.IPM_Active_RQS__c=true;
                que.Is_Master__c=false;
                que.RecordTypeId=recTypeIDCR;
                insertCRQuestionsList.add(que);
            }
        }
        System.debug(insertCRQuestionsList+'insertCRQuestionsList');
        if(insertCRQuestionsList.size() > 0)
        Insert insertCRQuestionsList;
    }
}