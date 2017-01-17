/**
* Name:        -   SAFE_RiskAssessmentListView_CC
* @Description -   This is the Controller for Display of Risk Assessments.On Click of Project Assessment Display of Questions and answers.Functionality for Save or Submit of Questions and answers in SAFE_Response object 
* @Author      -   Submit functionality by Chandru, Mindtree Ltd ; Save and Pagination functionality By Sibatri,Delegate Functionality By Sagar     
*/
public with sharing class SAFE_RiskAssessmentListView_CC{ 
    
    //public boolean displayPopup1 {get; set;}     
    public Id riskAssesmentId{get;set;}
    public string selectedTab{get;set;}
    public Set<Id> questionIdSet {get;set;}
    public static String selectedAns{get;set;}
    public String questionId{get;set;}
    public static List<SAFE_Questions__c > questionList = new List<SAFE_Questions__c >();
    public List<Question> questionWrapperList {get;set;} //= new List<Question>();//{get;set;} ;
    public static List<Question> questionWrapperListtemp = new List<Question>();//{get;set;} ;
    public ApexPages.StandardController stdController;
    public static Map<Id, List<String>> selectedAnswerMap {get;set;}
    public Boolean selected {get; set;}
    List<String> patternCheckResponse = new List<String>();//By sibatri
    List<SAFE_Answers__c > ansId = new List<SAFE_Answers__c >();//By sibatri
    public Integer completedCount{ get; set; }//By sibatri
    public Integer NotcompletedCount{ get; set; }//By sibatri
    integer totalRecs = 0;//By sibatri
    integer count= 0;//By sibatri
    integer limitSize= 5;//By sibatri
    public  Id responseId {get; set;}//By sibatri
    public boolean showStatus{ get; set; }//By sibatri
    public String id1 {get;set;}//By sibatri  
    
    // by sagar for Deleagte Popup Integration
    public Boolean displayPopup {get;set;}
    public string ExtUserEmail {get; set;}
    public List<User> UserTemp = new List<User>();    
    public string userid {get; set;}    
    public String searchTerm {get; set;}
    public String selecteduser {get; set;}
    public List<User> PMusername {get;set;} // for storing PM user name for delegate email
    public string DelegateLink {get; set;} // For storing Delegate link
    public string FnameLname {get; set;}
    public Boolean ShowDelegateFaceIcon {get; set; } //variable based on which v wil show Delegate face icon
    public string checkforclone {get;set;}
    public SAFE_Risk_Assessment__c SaveResponseList = new SAFE_Risk_Assessment__c();   
    public SAFE_Risk_Assessment__c SAFERiskassesmentinsertClone=new SAFE_Risk_Assessment__c(); 
    public decimal riskVersion;
    
    public void showPopup()
    {       
        //System.debug('user Name is: '+searchTerm );
        displayPopup = true;    
        QuestionID = Apexpages.currentPage().getParameters().get('QuestionID');
    }    
    
    public void closePopup() 
    {    
        selecteduser = '';
        displayPopup = false;    
    }   
    
    @RemoteAction
    public static List<User> searchuser(String searchTerm) {
        System.debug('user Name is: '+searchTerm );
        List<User> user = Database.query('SELECT Name,Id FROM User where Name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\' Limit 20');        
        return user;
    }
    
    // Click on Save button in Delegate popup
    
    public Pagereference redirectPopup()
    {        
        System.debug('Check this selected: ' +selecteduser);
        System.debug('Check this exntuser: ' +ExtUserEmail);
        if(selecteduser == '' && ExtUserEmail == '')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter Alteast Internal/External User'));
            return null;
        }
        else
        {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            if(selecteduser == '')
            {
                message.toAddresses = new String[] { ExtUserEmail , ExtUserEmail }; 
                    message.optOutPolicy = 'FILTER';
                message.subject = 'SAFE Email test';
                message.plainTextBody = 'Hello ' + searchTerm  + '<br> You have been delegated a question by ' + PMusername + '. Kindly visit the following link to answer the question: <br>' + DelegateLink +' .';
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);   
                if (results[0].success) 
                {
                    System.debug('The email was sent successfully.');
                } 
                else 
                {
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                }                            
            }
            else
            {           
                User UserEmail = [SELECT Email FROM User where ID =: selecteduser LIMIT 1];
                string InternalUserEmail = UserEmail.Email;
                message.toAddresses = new String[] { InternalUserEmail , InternalUserEmail };                
                    message.optOutPolicy = 'FILTER';
                message.subject = 'SAFE Email test';
                message.plainTextBody = 'Hello ' + searchTerm  + '<br> You have been delegated a question by ' + PMusername + '. Kindly visit the following link to answer the question: <br>' + DelegateLink +' .';
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                if (results[0].success) 
                {
                    System.debug('The email was sent successfully.');
                } 
                else 
                {
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                }  
            }             
            SaveDelegateData();            
            selecteduser = '';
            ExtUserEmail = '';
            displayPopup = false;
            return null;        
        }
    } 
    
    // To save Delegated to and External user's email id into the object
    
    public void SaveDelegateData()
    {        
        
        SAFE_Questions__c SAFEQuestionToUpdate;
        try 
        {  
            if(selecteduser == '' )
            {
                SAFEQuestionToUpdate = [SELECT SAFE_Delegated_To_Email__c FROM SAFE_Questions__c WHERE ID=: QuestionID LIMIT 1];
                SAFEQuestionToUpdate.SAFE_Delegated_To_Email__c = ExtUserEmail;
                //SAFEQuestionToUpdate.SAFE_Delegated_To__c = selecteduser;
                update SAFEQuestionToUpdate;
                ShowDelegateFaceIcon = true;
            }
            else
            {
                SAFEQuestionToUpdate = [SELECT SAFE_Delegated_To_Email__c, SAFE_Delegated_To__c FROM SAFE_Questions__c WHERE ID=: QuestionID LIMIT 1];
                SAFEQuestionToUpdate.SAFE_Delegated_To_Email__c = ExtUserEmail;
                SAFEQuestionToUpdate.SAFE_Delegated_To__c = selecteduser;
                update SAFEQuestionToUpdate; 
                ShowDelegateFaceIcon = true;
            }
        } 
        catch(DmlException e) 
        {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }      
    
    // End of Delegate Functionality
    
    public SAFE_RiskAssessmentListView_CC (ApexPages.StandardController controller) 
    { 
        ShowDelegateFaceIcon = false;
        string PMuserID = UserInfo.getUserId();
        PMusername = [SELECT FirstName, LastName FROM User WHERE Id =: PMuserID]; 
        
        DelegateLink = 'https://unilever--pacv--c.cs60.visual.force.com/apex/SAFE_QuestionaireTab?core.apexpages.request.devconsole=1';
        
        this.stdController = stdController;
        totalRecs = [select count() from SAFE_Risk_Assessment__c ];
        NotcompletedCount=[SELECT count() FROM SAFE_Risk_Assessment__c ];
        completedCount =[SELECT count() FROM SAFE_Risk_Assessment__c ]; 
        showStatus=true;
    }
    
    public SAFE_RiskAssessmentListView_CC(){}
    
    /*to show list of Risk Assessments*/
    
    public List<SAFE_Risk_Assessment__c> getResponseList() {
        List<SAFE_Risk_Assessment__c> ResponseList=[SELECT OwnerID,CreatedById,Id,SAFE_Project_Name__c,SAFE_Project_End_Date__c,SAFE_Project_Start_Date__c,SAFE_Status__c,Name FROM SAFE_Risk_Assessment__c  LIMIT:limitsize OFFSET:count];
        return ResponseList;
    }
    /* Risk Assessments List as pagination implementation*/
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
        count=count+limitsize;system.debug(count);
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
    
    /* On Click Project Assessment Button List of Questions and Options will be displayed.Risk Assessment Id is passes with processLinkClick action */
    
    public PageReference processLinkClick(){ 
        id1 = system.CurrentPageReference().getParameters().get('id1');
        checkforclone = system.CurrentPageReference().getParameters().get('actionPerform');  //value will be - CloneButton
        riskAssesmentId = id1;
        Set<Id> questionIdSet = new Set<Id>();
        
        questionWrapperList = new List<Question>();
        
        SAFE_Risk_Assessment_Questionnaire__c questionnaire = [Select id, (Select id,SAFE_Answering_Method__c,SAFE_Question__c,SAFE_Question_Status__c,SAFE_Weightage__c from Questions__r)  from SAFE_Risk_Assessment_Questionnaire__c where  SAFE_Status__c =: 'Published' LIMIT 1];
        for(SAFE_Questions__c question : questionnaire.Questions__r)
        {
            if(question.SAFE_Question_Status__c == 'Activated')
                questionIdSet.add(question.Id);
        }
        
        selectedAnswerMap = new Map<Id, List<String>>();
        questionList = [Select id,Name,SAFE_Answering_Method__c,SAFE_Question__c,SAFE_Question_Status__c,SAFE_Help_Text__c,SAFE_Weightage__c, (Select id,Name, SAFE_Score_Value__c,SAFE_Question__c,SAFE_Comments__c from Answers__r) from SAFE_Questions__c where Id IN :questionIdSet and  SAFE_Question_Status__c=:'Activated' ];
        Integer counter =0;
        List<SAFE_Responses__c> responseDetail=[select Id,Name,SAFE_Question__c,SAFE_Answer__c from SAFE_Responses__c where SAFE_Risk_Assessment__r.Id =: riskAssesmentId ] ; 
        
        for(SAFE_Questions__c question : questionList )
        {
            Question q  = new Question();
            q.questionValue = question.SAFE_Question__c;
            q.Id = question.Id; //Question ID
            counter ++;
            q.qNo = counter;
            q.AnsweringMethod = question.SAFE_Answering_Method__c;
            q.helpText=question.SAFE_Help_Text__c;
            if(q.AnsweringMethod != null && q.AnsweringMethod != '')
            {
                if(q.AnsweringMethod.equalsIgnoreCase('Radio Button Objective Answering')){
                    q.singleSelect = true;
                }
                else if (q.AnsweringMethod.equalsIgnoreCase('Checkbox Objective Answering')){
                    q.multiSelect = true;
                }
            }
            
            q.answerIdMap= new Map<Id,Answer>();
            q.answerOptions = new List<SelectOption>();
            
            for(SAFE_Answers__c answer : question.Answers__r)
            {
                Answer a = new Answer();
                a.Id = answer.Id;
                a.answerValue = answer.Name;
                a.score = answer.SAFE_Score_Value__c;
                q.answerIdMap.put(a.Id,a);
                SelectOption so = new SelectOption(a.Id,a.answerValue);
                
                q.answerOptions.add(so);
                
            }
            //Code for Response by Sibatri for answer selection if a question is saved already
            
            for(Integer i=0;i<responseDetail.size();i++)
            {
                
                if(q.questionValue==responseDetail[i].SAFE_Question__c)
                {
                    for(SAFE_Answers__c answer : question.Answers__r)
                    {
                        if(q.singleSelect && answer.Name == responseDetail[i].SAFE_Answer__c)
                        {
                            q.answerSelected = answer.Id;
                            break;                           
                        }
                        if(q.multiSelect )
                        {
                            boolean result = responseDetail[i].SAFE_Answer__c.CONTAINS(answer.Name);  
                            if(result==true)
                            {
                                q.selectedAnswersList.add(answer.Id);
                                
                            }
                        }
                    }
                }
            }
            //Code End for Response by Sibatri
            questionWrapperList.add(q);
            questionWrapperListtemp.add(q);
        }
        showStatus = false;system.debug('%%%%%'+showStatus);
        return null;
        
    }
    public class Question
    {
        public  boolean selected{get;set;}
        public  String Id{get;set;}
        public  integer qNo{get;set;}
        public  String questionValue{get;set;}
        public  String AnsweringMethod{get;set;}
        public  Boolean singleSelect{get;set;}
        public  Boolean multiSelect{get;set;}
        public  Map<Id,Answer> answerIdMap{get;set;}
        public  String answerSelected{get;set;}
        public  List<SelectOption> answerOptions{get;set;}
        public  List<String> selectedAnswersList{get;set;}
        public List<SAFE_Responses__c> responseList{get;set;}
        public String helpText{get;set;}
        public Question()
        {
            answerSelected = '';
            singleSelect = false;
            multiSelect = false;
            qNo = 0;
            selectedAnswersList = new List<String>();
            responseList = new List<SAFE_Responses__c>();
            
        }
        
        public void setAnswerOptions(List<SelectOption> l)
        {
            answerOptions=l;
        }
        public List<SelectOption> getAnswerOptions()
        {
            return answerOptions;
        }
        
        public void setSelectedAnswersList(List<String> l)
        {
            selectedAnswersList=l;
        }
        public List<String> getSelectedAnswersList()
        {
            return selectedAnswersList;
        }
        
        public void setAnswerSelected(String l)
        {
            answerSelected=l;
        }
        public String getAnswerSelected()
        {
            return answerSelected;
        }
        
    }
    //  public void actionSave1(){
    // System.debug('Selected ans' + selectedAns);
    // }
    
    Public class Answer
    {
        public String answerValue;
        public Decimal score;
        public String Id;
    }
    
    /* public void showPopup() {  // commented by sagar      
displayPopup = true;    
} */
    /*On click of Save button ,All the Questions and its answers will be saved in SAFE_Response Object.If it is saved ,it can be updated next time */
    public Integer getResponseDetailFromQuestionValue(String questionValue)
    {
        List<SAFE_Responses__c> responseDetail=[select Id,Name,SAFE_Question__c,SAFE_Answer__c from SAFE_Responses__c where SAFE_Risk_Assessment__r.Id =: riskAssesmentId ] ;
        for(Integer i=0;i<responseDetail.size();i++)
        {
            if(questionValue == responseDetail[i].SAFE_Question__c)
            { 
                return i;
            }
        }  
        return -1;
    }
    /*On click of Save button ,All the Questions and its answers will be saved in SAFE_Response Object.If it is saved ,it can be updated next time */
    public PageReference  saveQuestionAnswerResponseObj()
    {pagereference p = apexpages.Currentpage();
     integer resIndex;
     showStatus=true;
     apexpages.Message msg;
     
     List<SAFE_Responses__c> responseDetail=[select Id,Name,SAFE_Question__c,SAFE_Answer__c from SAFE_Responses__c where SAFE_Risk_Assessment__r.Id =: riskAssesmentId ] ; 
     List<SAFE_Responses__c> ResListInsert= new List<SAFE_Responses__c>();
     List<SAFE_Responses__c> ResListUpdate= new List<SAFE_Responses__c>();
     
     for(Question q :  questionWrapperList )
     {
         resIndex = getResponseDetailFromQuestionValue(q.questionValue);
         if(q.singleSelect && q.answerSelected != null && q.answerSelected != '')
         {
             if(q.answerIdMap.containsKey(String.valueOf(q.answerSelected )))
             {
                 SAFE_Responses__c resp1= new SAFE_Responses__c();
                 Answer ans = q.answerIdMap.get(q.answerSelected);
                 resp1.SAFE_Question__c = q.questionValue;
                 resp1.SAFE_Answer__c = ans.answerValue;
                 resp1.SAFE_Score_Value__c = ans.score;
                 resp1.SAFE_Risk_Assessment__c = riskAssesmentId;
                 
                 if(resIndex != -1)
                 {
                     resp1.id = responseDetail[resIndex].id;
                     ResListUpdate.add(resp1);
                 }
                 else
                 {
                     ResListInsert.add(resp1);
                 }
             }
         }
         else if(q.multiSelect && q.selectedAnswersList.size()>0)
         {
             SAFE_Responses__c resp1= new SAFE_Responses__c();
             resp1.SAFE_Question__c = q.questionValue;
             resp1.SAFE_Answer__c='';
             resp1.SAFE_Score_Value__c = 0;
             resp1.SAFE_Risk_Assessment__c = riskAssesmentId;
             
             for(String ans : q.selectedAnswersList)
             {
                 if(q.answerIdMap.containsKey(ans))
                 {
                     Answer a = q.answerIdMap.get(ans);
                     resp1.SAFE_Answer__c +=  a.answerValue + ';';
                     resp1.SAFE_Score_Value__c = resp1.SAFE_Score_Value__c + a.score; 
                 }
             }
             
             if(resIndex != -1)
             {
                 resp1.id = responseDetail[resIndex].id;
                 ResListUpdate.add(resp1);
             }
             else 
             {
                 ResListInsert.add(resp1);     
             }
         }
         else if(q.multiSelect && q.selectedAnswersList.size() == 0)
         {
             if(resIndex != -1)
             {
                 delete responseDetail[resIndex];
             } 
         }  
     }
     
     if(ResListInsert.size()>0)
     {
         insert ResListInsert;msg = new Apexpages.Message(ApexPages.Severity.Info,'Total Number of reloads: ');
     }
     if(ResListUpdate.size()>0)
     {
         update ResListUpdate; msg = new Apexpages.Message(ApexPages.Severity.Info,'Total Number of reloads: ');
     }
     
     apexpages.addmessage(msg);
     return p; 
    }
    
    
    public boolean displayPopup1 {get; set;}     
    
    public void closePopup1() 
    {        
        displayPopup1 = false;    
    }     
    public void showPopup1() 
    {        
        displayPopup1 = true;    
    }
    
    /*On click of Submit button ,All the Questions and its answers will be saved in SAFE_Response Object.Once it is saved ,it can not be updated next time */   
    public void submitQuestionAnswerResponseObj()
    {
        system.debug('clone button' + checkforclone);
        if(checkforclone == 'CloneButton')
        {
            
            SaveResponseList = [SELECT SAFE_Project_Name__c,SAFE_Project_End_Date__c, SAFE_Risk_Assessment_Link__c,SAFE_version__c,SAFE_Project_Start_Date__c,SAFE_Status__c,Name FROM SAFE_Risk_Assessment__c WHERE  ID =: id1];
            riskVersion=SaveResponseList.SAFE_version__c;
            riskVersion=riskVersion+1;
            SAFERiskassesmentinsertClone.SAFE_Project_Name__c = SaveResponseList.SAFE_Project_Name__c;system.debug('save response1' + SAFERiskassesmentinsertClone.SAFE_Project_Name__c);
            SAFERiskassesmentinsertClone.SAFE_Project_End_Date__c = SaveResponseList.SAFE_Project_End_Date__c;system.debug('save response2' + SAFERiskassesmentinsertClone.SAFE_Project_End_Date__c);
            SAFERiskassesmentinsertClone.SAFE_Project_Start_Date__c = SaveResponseList.SAFE_Project_Start_Date__c;system.debug('save response3' + SAFERiskassesmentinsertClone.SAFE_Project_Start_Date__c);
            SAFERiskassesmentinsertClone.SAFE_Status__c = SaveResponseList.SAFE_Status__c;system.debug('save response4' + SAFERiskassesmentinsertClone.SAFE_Status__c);
            SAFERiskassesmentinsertclone.SAFE_Risk_Assessment_Link__c = SaveResponseList.SAFE_Risk_Assessment_Link__c;
            SAFERiskassesmentinsertclone.SAFE_version__c = riskVersion;
            insert SAFERiskassesmentinsertClone;
            
            saveQuestionAnswerResponseObj(); 
            // write a query to save status as completed
        }
        else
        {
            saveQuestionAnswerResponseObj(); 
        }
        checkforclone = '';  
        
        displayPopup1 = false; 
        
        //Code to  Update the status of Risk Assessment
        SAFE_Risk_Assessment__c riskAssessmentToUpdate;
        riskAssessmentToUpdate = [SELECT SAFE_Status__c  FROM SAFE_Risk_Assessment__c WHERE id =: riskAssesmentId]; 
        riskAssessmentToUpdate.SAFE_Status__c = 'Completed';
        // Make the update call.
        update riskAssessmentToUpdate;
    }
    
    
    
    
}