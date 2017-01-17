/**
* Name:        -   SAFE_RiskAssessmentQuestionnaireView_CC
* @Description -   This controller fetches all questionnaire record,edit ,clone and delete the same,Create Questionaire as well.
This controller fetches all question record,edit ,clone and delete the same,Create Question for a particular questionnaire as well.
* @Author      - Sibatri/Sagar      
*/

public class SAFE_RiskAssessmentQuestionnaireView_CC {
    public ApexPages.StandardController stdController;
    public boolean showStatus1{ get; set; }//By sibatri
    public boolean showStatus2{ get; set; }//By sibatri
    public boolean showStatus3{ get; set; }//By sibatri
    public boolean showStatus4{ get; set; }//By sibatri
    public boolean showStatus5{ get; set; }//By sibatri
    public String id1{ get; set; }//By sibatri
    public SAFE_Risk_Assessment_Questionnaire__c raq{get; set;}
    
    public SAFE_Risk_Assessment_Questionnaire__c qList{get; set;}
    public String userName{get;set;}
    Public User Owner_name {get; set;} 
    public boolean displayPopup {get; set;}
    public  String actionPerform{get; set;}
    
    Public SAFE_Risk_Assessment_Questionnaire__c QuestionnaireDetails {get; set;} // by sagar
    public List<SAFE_Questions__c> questionList {get; set;}  //  by sagar
    public SAFE_Questions__C PrepopulateQuestion {get; set;} // by sagar
    Public User Owner_name1 {get; set;} // by sagar
    public string QuestionID { get; set; } // by sagar
    public string q_Id {get; set;}
    integer totalRecs = 0;//By sibatri for pagination
    integer count= 0;//By sibatri for pagination
    integer limitSize= 5;//By sibatri for pagination
    public string editStatus{get; set;}
    public String IDdeleteQ {get; set;}// By sagar
    
    public SAFE_RiskAssessmentQuestionnaireView_CC (ApexPages.StandardController controller) 
    { 
        this.stdController = stdController; 
        showStatus1=true;
        showStatus2=false;
        showStatus3=false;
        showStatus5=false;
        userName = Userinfo.getName();
        qList = new SAFE_Risk_Assessment_Questionnaire__c();
        totalRecs = [SELECT count() FROM SAFE_Risk_Assessment_Questionnaire__c];
    }  
    /*Code for Question creation,deletion ,updation starts from here --by Sibatri */
    
    public List<SAFE_Risk_Assessment_Questionnaire__c> getQuestionnaireList()
    { 
        List<SAFE_Risk_Assessment_Questionnaire__c> QuestionnaireList=[SELECT CreatedDate,Owner.name,Id,Name,SAFE_Status__c,lastModifiedDate,SAFE_Description__c FROM SAFE_Risk_Assessment_Questionnaire__c  LIMIT:limitsize OFFSET:count];
        
        return QuestionnaireList;
    }
    
    /*  pagination implementation*/
    public PageReference Firstbtn() {
        count=0;
        return null;
    }
    /* Risk Assessments List as pagination implementation*/
    public PageReference prvbtn() {
        count=count-limitsize;
        return null;
    }
    /* Risk Assessments List as pagination implementation*/
    public PageReference Nxtbtn() {
        count=count+limitsize;
        return null;
    }
    /* Risk Assessments List as pagination implementation*/
    public PageReference lstbtn() {
        count= totalrecs - math.mod(totalRecs,LimitSize);
        return null;
    }
    
    /* Risk Assessments List as pagination implementation*/
    public Boolean getNxt() {
        if((count+ LimitSize) > totalRecs)
            return true;
        else
            return false;
    }
    /* Risk Assessments List as pagination implementation*/
    public Boolean getPrv() {
        if(count== 0)
            return true;
        else
            return false;
    } 
    
    public pageReference backToQuestionnaireList(){system.debug('hguj');
                                                   showStatus1=true;
                                                   showStatus2=false;
                                                   showStatus3=false;
                                                   showStatus4=false;
                                                   showStatus5=false;
                                                   return null;
                                                  } 
    /*Navigate to Questionnaire creation form*/
    public PageReference createQuestionnaire()
    { 
        showStatus1=false;
        showStatus2=true;
        showStatus3=false;
        showStatus4=false;
        showStatus5=false;
        raq = new SAFE_Risk_Assessment_Questionnaire__c();
        return null;
    }
    /*Navigate to Questionnaire updation form*/
    public PageReference editQuestionnaire(){
        showStatus1=false;
        showStatus2=true;
        showStatus3=false;
        showStatus4=false;
        showStatus5=false;
        id1 = system.CurrentPageReference().getParameters().get('id1'); 
        actionPerform = system.CurrentPageReference().getParameters().get('actionPerform');
        system.debug(showStatus2);
        raq = [select SAFE_Description__c,Owner.Name,Name,Id,SAFE_Status__c from SAFE_Risk_Assessment_Questionnaire__c where Id=: id1];
        
        return null;
    }
    /*Navigate to display a particular Questionnaire in readable format*/
    public PageReference viewQuestionnaireRecord(){
        showStatus1=false;
        showStatus2=false;
        showStatus3=false;
        showStatus4=false;
        showStatus5=true;
        
        id1 = system.CurrentPageReference().getParameters().get('id1'); 
        raq = [select SAFE_Description__c,Owner.Name,Name,Id,SAFE_Status__c from SAFE_Risk_Assessment_Questionnaire__c where Id=: id1];
        return null;  
        
    }
    /*For Deletion of a particular Questionnaire */ 
    public void showPopup() 
    {        
        displayPopup = true;    
        id1 = system.CurrentPageReference().getParameters().get('id1');  
    }
    /*For Deletion of a particular Questionnaire */ 
    public void closePopup() 
    {        
        displayPopup = false;    
    }   
    /*Deletion of a particular Questionnaire */
    public void deleteQuestionnaire(){
        
        showStatus1=true;     
        showStatus2=false;
        showStatus3=false;
        showStatus4=false;
        showStatus5=false;
        displayPopup = false;
        raq = [select SAFE_Description__c,OwnerId,Name,Id,SAFE_Status__c from SAFE_Risk_Assessment_Questionnaire__c where Id=: id1];
        delete raq; 
        
    }
    /*Navigate to Questionnaire clone form*/
    public  PageReference cloneQuestionnaire()
    {
        showStatus1=false;
        showStatus2=true;
        showStatus3=false;
        showStatus4=false;
        showStatus5=false;
        id1 = system.CurrentPageReference().getParameters().get('id1'); 
        actionPerform = system.CurrentPageReference().getParameters().get('actionPerform');
        
        raq = [select SAFE_Description__c,Owner.Name,Name,Id,SAFE_Status__c from SAFE_Risk_Assessment_Questionnaire__c where Id=: id1];
        
        return null;  
    }   
    
    
    /*Action is written for New Questionnaire creation,updation and clone based on actionPerform value*/
    public PageReference saveQuestionnaire() 
    {
        system.debug(actionPerform);
        if(actionPerform=='edit')
        {
            
            qList = [select SAFE_Description__c,Name,SAFE_Status__c from SAFE_Risk_Assessment_Questionnaire__c where Id=: raq.id];
            qList.SAFE_Status__c=raq.SAFE_Status__c;
            qList.Name=raq.Name;
            qList.SAFE_Description__c=raq.SAFE_Description__c;
            
            update qList;
            showStatus1=false;
            showStatus2=false;
            showStatus3=true;
            showStatus4=false;
            showStatus5=false;
            system.debug(showStatus3+'2='+showStatus2);
            QuestionnaireDetails = [SELECT Id,Name,OwnerId,SAFE_Description__c,SAFE_Status__c FROM SAFE_Risk_Assessment_Questionnaire__c WHERE Id =: raq.id];        
            
            Owner_name1 = [SELECT Id,Name FROM User WHERE Id =: QuestionnaireDetails.OwnerId];
            
            questionList = [SELECT Id,Name,SAFE_Answering_Method__c,SAFE_Answers__c,SAFE_Help_Text__c,SAFE_Questionnaire__c,SAFE_Question_Status__c,SAFE_Question__c,SAFE_Scores__c,SAFE_Weightage__c FROM SAFE_Questions__c WHERE SAFE_Questionnaire__c =: raq.Id ];
            
            
        }
        else if(actionPerform=='clone')
        {
            
            raq.id=null;                         
            insert raq;  
            QuestionnaireDetails = [SELECT Id,Name,OwnerId,SAFE_Description__c,SAFE_Status__c FROM SAFE_Risk_Assessment_Questionnaire__c WHERE Id =: raq.id];        
            
            Owner_name1 = [SELECT Id,Name FROM User WHERE Id =: QuestionnaireDetails.OwnerId];
            
            questionList = [SELECT Id,Name,SAFE_Answering_Method__c,SAFE_Answers__c,SAFE_Help_Text__c,SAFE_Questionnaire__c,SAFE_Question_Status__c,SAFE_Question__c,SAFE_Scores__c,SAFE_Weightage__c FROM SAFE_Questions__c WHERE SAFE_Questionnaire__c =: raq.Id ];
            
            showStatus1=false;
            showStatus2=false;
            showStatus3=true;
            showStatus4=false;
            showStatus5=false;
        }
        
        else
        {
            // system.debug('raq'+raq);
            raq.id=null;//edited by rinku 
            insert raq;  
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Data Saved Successfully'));
            
            QuestionnaireDetails = [SELECT Id,Name,OwnerId,SAFE_Description__c,SAFE_Status__c FROM SAFE_Risk_Assessment_Questionnaire__c WHERE Id =: raq.Id ];        
            
            Owner_name1 = [SELECT Id,Name FROM User WHERE Id =: QuestionnaireDetails.OwnerId];
            
            questionList = [SELECT Id,Name,SAFE_Answering_Method__c,SAFE_Answers__c,SAFE_Help_Text__c,SAFE_Questionnaire__c,SAFE_Question_Status__c,SAFE_Question__c,SAFE_Scores__c,SAFE_Weightage__c FROM SAFE_Questions__c WHERE SAFE_Questionnaire__c =: raq.Id AND SAFE_Question_Status__c = 'Activated' ];
            
            showStatus1=false;
            showStatus2=false;
            showStatus3=true;
            showStatus4=false;
            showStatus5=false;
            system.debug('show status 2' + showStatus2);
            
        }
        return null;
        
    }
    /*End of code*/ 
    /*Code for Question creation,deletion ,updation starts from here --by Sagar*/
    public Pagereference EditQuestion()
    {   
        showStatus1=false;
        showStatus2=false;
        showStatus3=false;
        showStatus4=true;
        showStatus5=false;
        q_Id = system.CurrentPageReference().getParameters().get('q_Id');       
        system.debug('Q Id  ' + q_Id);
        PrepopulateQuestion = [SELECT Id,Name,OwnerId,SAFE_Answering_Method__c,SAFE_Answers__c,SAFE_Help_Text__c,SAFE_Questionnaire__c,SAFE_Question_Status__c,SAFE_Question__c,SAFE_Scores__c,SAFE_Weightage__c FROM SAFE_Questions__c WHERE Id =: q_Id ];
        system.Debug('prepopulate ' + PrepopulateQuestion );
        
        return null;    
    }
    
    public PageReference createQuestion()
    { 
        showStatus1=false;
        showStatus2=false;
        showStatus3=false;
        showStatus4=true;  
        showStatus5=false;
        PrepopulateQuestion = new SAFE_Questions__c();
        return null;
    }
    
    // Related to Save and edit Questions    
    
    public PageReference SaveQuestion()
    {     
        
        system.debug('save question id  '+ q_Id);        
        
        
        if(q_Id != null)
        {
            system.debug('edit');
            SAFE_Questions__c SAFEQuestionUpdate;
            SAFEQuestionUpdate = [SELECT SAFE_Question__c, SAFE_Answering_Method__c, SAFE_Answers__c, SAFE_Question_Status__c, SAFE_Weightage__c, SAFE_Help_Text__c, SAFE_Scores__c FROM SAFE_Questions__c WHERE Id =: q_Id ];        
            
            SAFEQuestionUpdate.SAFE_Question__c = PrepopulateQuestion.SAFE_Question__c;
            SAFEQuestionUpdate.SAFE_Answering_Method__c = PrepopulateQuestion.SAFE_Answering_Method__c;
            SAFEQuestionUpdate.SAFE_Answers__c = PrepopulateQuestion.SAFE_Answers__c;
            SAFEQuestionUpdate.SAFE_Question_Status__c = PrepopulateQuestion.SAFE_Question_Status__c;
            SAFEQuestionUpdate.SAFE_Weightage__c = PrepopulateQuestion.SAFE_Weightage__c;
            SAFEQuestionUpdate.SAFE_Help_Text__c = PrepopulateQuestion.SAFE_Help_Text__c;
            SAFEQuestionUpdate.SAFE_Scores__c = PrepopulateQuestion.SAFE_Scores__c;
            
            update SAFEQuestionUpdate;
            
        } 
        else
        {   
            system.debug('save');
            PrepopulateQuestion.SAFE_Weightage__c =PrepopulateQuestion.SAFE_Weightage__c;
            PrepopulateQuestion.SAFE_Questionnaire__c =raq.Id;
            insert PrepopulateQuestion;   
        }
        showStatus1=false;
        showStatus2=false;
        showStatus3=true;
        showStatus4=false; 
        showStatus5=false;
        return null;
    }
    
    public PageReference cancelQuestion()
    { 
        showStatus1=false;
        showStatus2=false;
        showStatus3=true;
        showStatus4=false; 
        showStatus5=false;
        return null;
    }
    
    public void showPopup_deleteQuestion() 
    {        
        displayPopup = true;    
        IDdeleteQ = system.CurrentPageReference().getParameters().get('iddeleteQ');  
    }
    public void closePopup_deleteQuestion() 
    {        
        displayPopup = false;    
    }
    
    public void deleteQuestion()
    {        
        showStatus1=false;
        showStatus2=false;
        showStatus3=true;
        showStatus4=false; 
        showStatus5=false;
        displayPopup = false;
        PrepopulateQuestion = [SELECT SAFE_Question__c, SAFE_Answering_Method__c, SAFE_Answers__c, SAFE_Question_Status__c, SAFE_Weightage__c, SAFE_Help_Text__c, SAFE_Scores__c FROM SAFE_Questions__c WHERE Id =: IDdeleteQ ];
        delete PrepopulateQuestion;         
    }
    
    public pageReference backToQuestionList(){
        showStatus1=false;
        showStatus2=false;
        showStatus3=true;
        showStatus4=false; 
        showStatus5=false;
        return null;
    } 
    
}